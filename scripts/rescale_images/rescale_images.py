#!/usr/bin/python

import argparse
import urllib2
import os
import re
import subprocess
import shutil 

from boto.s3.connection import S3Connection
from boto.s3.key import Key

s3_conn = None
decalz_bucket = None
def connect_to_s3():
    global s3_conn
    global decalz_bucket
    try:
        s3_conn = S3Connection(aws_access_key_id='AKIAIO6ZJBIIOKEYEGVQ',  aws_secret_access_key='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')
    except:
        fail("couldn't connect to s3")
    try:
        decalz_bucket = s3_conn.create_bucket(s3_bucket())
    except:
        fail("couldn't get decalz_bucket")
        
    
def fail(reason):
    print "fail - %s" % reason
    exit(1)

def s3_bucket():
    return "lockerz-static"

def s3_key_template_for_url(url):
    candidate = url[url.find("decalz")-1:]
    if not candidate.startswith("/decalz"):
        fail("Couldn't build an s3 key for %s" % url)
    return candidate

def s3_key_for_template(key_template, descriptor):
    return key_template.replace("<SIZE>", descriptor.name)

def filename_for_url(url):
    return "scratch/%s" % url.split("/")[-1]

def fetch_best_source_for_candidates(candidates):
    for candidate in candidates:
        try:
            f = urllib2.urlopen(candidate)
            ret = f.read()
            filename = filename_for_url(candidate)
            file_hnd = open(filename, "w")
            file_hnd.write(ret)
            f.close()
            file_hnd.close()
            return filename
            
        except urllib2.HTTPError:
            pass
    return None

    
def is_gif(filename):
    return filename.lower().endswith("gif")

def is_jpeg(filename):
    return filename.lower().endswith("jpg") or filename.lower().endswith("jpeg")

def is_png(filename):
    return filename.lower().endswith("png")

def sized_url(template_url, size):
    return template_url.replace("<SIZE>", size)


class ScaleDescriptor:
    def __init__(self, name, width=None, height=None, quality=85, optimize=False):
        self.name = name
        self.width = width
        self.height = height
        self.quality=quality
        self.optimize=optimize

    def scale_only_width(self):
        return self.width and not self.height

    def scale_both(self):
        return self.width and self.height


ScaleDescriptor.THUMBNAIL=ScaleDescriptor("thumbnail", width=75, height=75)
ScaleDescriptor.SMALL=ScaleDescriptor("small", width=150, height=150)
ScaleDescriptor.W300=ScaleDescriptor("w300", width=300, quality=70, optimize=True)
ScaleDescriptor.W300LQ=ScaleDescriptor("w300_lq", width=300, quality=45, optimize=True)
ScaleDescriptor.MOBILE=ScaleDescriptor("mobile", width=320)
ScaleDescriptor.MEDIUM=ScaleDescriptor("medium", width=600)
ScaleDescriptor.W600=ScaleDescriptor("w600", width=600, quality=70, optimize=True)
ScaleDescriptor.W600LQ=ScaleDescriptor("w600_lq", width=600, quality=45, optimize=True)
ScaleDescriptor.ORIGINAL=ScaleDescriptor("original")
ScaleDescriptor.ALL=[ScaleDescriptor.THUMBNAIL, 
                     ScaleDescriptor.SMALL, 
                     ScaleDescriptor.W300, 
                     ScaleDescriptor.W300LQ, 
                     ScaleDescriptor.MOBILE, 
                     ScaleDescriptor.MEDIUM, 
                     ScaleDescriptor.W600, 
                     ScaleDescriptor.W600LQ]

ScaleDescriptor.ONLY_NEW=[ScaleDescriptor.W300, 
                          ScaleDescriptor.W300LQ, 
                          ScaleDescriptor.W600, 
                          ScaleDescriptor.W600LQ]
    
class ScaleResult:
    def __init__(self, filename, s3_key):
        self.filename = filename
        self.s3_key = s3_key
    def __str__(self):
        return "(%s, %s)" % (self.filename, self.s3_key)
    def __repr__(self):
        return self.__str__()
def scale_file(filename, key_template, descriptor, dest_format=None):
    base_filename, orig_extension = os.path.splitext(filename)
    dest_extension = orig_extension
    if dest_format:
        dest_extension = ".%s" % dest_format
        
    dest_filename = "%s_%s%s" % (base_filename, descriptor.name, dest_extension)
        
    dest_s3_key = s3_key_for_template(key_template, descriptor)
    
    if descriptor.scale_only_width():
        scale_only_width(filename, dest_filename, descriptor)
    elif descriptor.scale_both():
        scale_width_and_height(filename, dest_filename, descriptor)
        
    if descriptor.optimize:
        if is_png(dest_filename):
            optimize_png(dest_filename)
        elif is_jpeg(dest_filename):
            optimize_jpeg(dest_filename)
    
    return ScaleResult(dest_filename, dest_s3_key)
    
def init_context(in_filename, out_filename, descriptor):
    other_flags = ""
    in_filename_page = ""
    if is_gif(in_filename) and not is_gif(out_filename):
        in_filename_page="[0]"
    if is_gif(in_filename):
        other_flags = "-coalesce"
        
    return {
        "colorspace" : "sRGB",
        "in_filename" : in_filename,
        "out_filename" : out_filename,
        "quality" : descriptor.quality,
        "other_flags" : other_flags,
        "in_filename_page":in_filename_page,
        "width":descriptor.width,
        "height":descriptor.height }

whitespace = re.compile(r'\\W+')

def run_command(command):
    try:
        ret = subprocess.check_call(command , shell=True, stderr=None, stdout=None)
    except:
        fail("Command Failed: '%s'" % command)
    
def scale_only_width(in_filename, out_filename, descriptor):
    template = "convert \"%(in_filename)s%(in_filename_page)s\" -quality %(quality).1f %(other_flags)s -resize \"%(width)dx-1>\" %(out_filename)s"
    args = init_context(in_filename, out_filename, descriptor)
    resolved = template % args
    resolved = whitespace.sub(' ', resolved)
    run_command(resolved)
    
    
def scale_width_and_height(in_filename, out_filename, descriptor):
    template = "convert \"%(in_filename)s%(in_filename_page)s\" -quality %(quality).1f %(other_flags)s -resize %(width)dx%(height)d^ -gravity Center -crop %(width)dx%(height)d+0+0 %(page_command)s %(out_filename)s"
    page_command = ""
    if is_gif(in_filename):
        page_command = "-page +0+0"
    args = init_context(in_filename, out_filename, descriptor)
    args["page_command"] = page_command
    resolved = template % args
    resolved = whitespace.sub(' ', resolved)
    run_command(resolved)




def optimize_jpeg(filename):
    jpeg_optim_template = "jpegoptim --strip-all %s"
    jpeg_optim = jpeg_optim_template % (filename)
    
    run_command(jpeg_optim)

    jpeg_rescan_template = "jpegrescan %s %s" 
    jpeg_rescan = jpeg_rescan_template % (filename, filename)

    run_command(jpeg_rescan)
    
    

def optimize_png(filename):
    precrush_filename = "%s_precrush" % filename
    shutil.copyfile(filename, precrush_filename)
    template = "pngcrush -reduce -brute %(precrush_filename)s %(filename)s"
    args = {"precrush_filename" : precrush_filename,
            "filename" : filename}
    resolved =  template % args
    run_command(resolved)
    os.remove(pngcrush_filename)

def upload_to_s3(scale_result):
    try:
        key = Key(decalz_bucket)
        key.key = scale_result.s3_key
        key.set_contents_from_filename(scale_result.filename)
        key.set_acl('public-read')
    except:
        fail("Failed uploading to s3")

def rescale_from(template_url, source_url, cleanup, upload):
    garbage_url = sized_url(template_url, "garbage")
    original_url = sized_url(template_url, "original")
    medium_url = sized_url(template_url, "medium")
    
    candidates = [original_url, medium_url, source_url]
    filename = fetch_best_source_for_candidates(candidates)
    if not filename:
        fail("failed - couldn't download any of %s" % candidates)


    s3_key_template = s3_key_template_for_url(template_url)
    
    
    scaled = []
    if is_gif(filename):
        scaled = [scale_file(filename, s3_key_template, d, dest_format="png") for d in ScaleDescriptor.ALL]
        scaled = scaled + [scale_file(filename, s3_key_template, d) for d in ScaleDescriptor.ONLY_NEW]
    else:
        scaled = [scale_file(filename, s3_key_template, d) for d in ScaleDescriptor.ONLY_NEW]

    if upload:
        connect_to_s3()
        for scale_result in scaled:
            upload_to_s3(scale_result)
            
    if cleanup:
        for scale_result in scaled:
            os.remove(scale_result.filename)
        os.remove(filename)
    print "success %s" % template_url
        


def main():
    parser = argparse.ArgumentParser(description="Rescale original images for lockerz")
    parser.add_argument('template_url', type=str, help="the value of url in decal_entity")
    parser.add_argument('source_url', type=str, help="the source_url in decal_entity")
    parser.add_argument("--no-cleanup", action="store_false", dest="cleanup", default=True, help="don't erase dowloaded / scaled files, useful for debugging")
    parser.add_argument("--no-upload", action="store_false", dest="upload", default=True, help="don't upload to s3. useful for debugging")
    args = parser.parse_args()
    rescale_from(args.template_url, args.source_url, args.cleanup, args.upload)


if __name__ == "__main__":
    main()
