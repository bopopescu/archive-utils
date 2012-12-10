#!/usr/bin/env python
import os
import sys
import argparse
import aws
import subprocess
import pprint
import time
import urllib
"""
Chef needs a pem key to authenticate with the API, check for some under common names
If we can't find a pem key bail out as none of this will work without one
"""
pemFile = ''
if os.path.exists('platzScript0.pem'):
    pemFile = 'platzScript0.pem'
elif os.path.exists('chefPlatz.pem'):
    pemFile = 'chefPlatz.pem'
else:
    print ''
    print '*** ERROR ***'
    print 'No certificate file could be found!'
    print ''
    exit()


def admin_hosts():
    return ["admin01.platz.lockerz.int"]

def load_balancers():
    #return ["deploy-test"]
    return ["lockerz-com", 
            "api-lockerz-com", 
            "pics-lockerz-com",
            "secure-lockerz-com"]

    #return ["lockerz-com", "api-lockerz-com"]
    #return ["pics-lockerz-com"]

def wait_for_traffic_to_die(host):
    #code = subprocess.call(["scripts/check-for-traffic", "-le", "0", host])
    time.sleep(20)

def wait_for_traffic(host):
    code = subprocess.call(["scripts/check-for-traffic", "-ge", "3", host])

def try_call(what):
    code = subprocess.call(what)
    if code != 0:
        return False
    else:
        return True
    
def notify_newrelic(version, email):
    return try_call(["scripts/notify-newrelic", version, email])

def notify_hipchat(message, color):
    encoded = urllib.quote(message)
    return try_call(["scripts/notify-hipchat", encoded, color])

def hipchat_msg(message):
    return notify_hipchat(message, "yellow")

def hipchat_err(message):
    return notify_hipchat(message, "red")

def hipchat_success(message):
    return notify_hipchat(message, "green")
    
def checkout(version):
    return try_call(["scripts/checkout", version])

def tag(version):
    return try_call(["scripts/tag", version])

def build_platz(version):
    return try_call(["scripts/build-platz", version])
    
def build_pegasus(version):
    return try_call(["scripts/build-pegasus", version])
    
def deploy_platz(version,host):
    return try_call(["scripts/deploy-platz", version, host])

def deploy_pegasus(version, host):
    return try_call(["scripts/deploy-pegasus", version, host])
 
def get_app_host_info():
    print "Using load balancer names: %s" % (load_balancers())

    instance_ids_to_fqdns = {}
    instance_ids_to_fqdns['i-ec303788'] = 'admin01.platz.lockerz.int'
    instance_ids_to_fqdns['i-4c828528'] = 'apps01.platz.lockerz.int'
    instance_ids_to_fqdns['i-d08186b4'] = 'apps02.platz.lockerz.int'
    instance_ids_to_fqdns['i-1880877c'] = 'apps03.platz.lockerz.int'
    instance_ids_to_fqdns['i-d2843eb5'] = 'apps04.platz.lockerz.int'
    instance_ids_to_fqdns['i-df4974a0'] = 'apps05.platz.lockerz.int'
    instance_ids_to_fqdns['i-813508fe'] = 'apps06.platz.lockerz.int'
    instance_ids_to_fqdns['i-7f340900'] = 'apps07.platz.lockerz.int'
    instance_ids_to_fqdns['i-baccffdd'] = 'apps08.platz.lockerz.int'
    instance_ids_to_fqdns['i-95136fee'] = 'pics01.lockerz.int'
    instance_ids_to_fqdns['i-930579e8'] = 'pics02.lockerz.int'
    balancers_to_instance_ids = {}
    ids_to_instances = {}
    ids_to_balancers = {}
    fqdns_to_ids = {}
    

    for lb in load_balancers():
        balancers_to_instance_ids[lb] = set()
        found = aws.get_instances_in_elb(lb)
        for instance in found:
            balancers_to_instance_ids[lb].add(instance.id)
            ids_to_instances[instance.id] = instance
            
        
    for instance_id in ids_to_instances.keys():
        #fqdn = aws.fqdn_for_instance_id(instance_id)
        fqdn = instance_ids_to_fqdns[instance_id]
        fqdns_to_ids[fqdn] = instance_id
        ids_to_balancers[instance_id] = [b for b in balancers_to_instance_ids.keys() if instance_id in balancers_to_instance_ids[b]]
        


    fqdns = fqdns_to_ids.keys()
    fqdns.sort()
    
    
    return {"hosts" : fqdns,
            "ids_to_instances" : ids_to_instances,
            "ids_to_balancers" : ids_to_balancers,
            "balancers_to_ids" : balancers_to_instance_ids,
            "hosts_to_ids"     : fqdns_to_ids}
        


def remove_from_elbs(host, host_info):
    host_id = host_info["hosts_to_ids"][host]
    elbs = host_info["ids_to_balancers"][host_id]
    print "Removing %s [%s] from elbs:" % (host, host_id)
    for elb in elbs:
        sys.stdout.write("\t%s... " % elb)
        sys.stdout.flush()
        aws.remove_instance_from_elb(elb, host_id)
        sys.stdout.write("Done!\n")
        sys.stdout.flush()


def add_to_elbs(host, host_info):
    host_id = host_info["hosts_to_ids"][host]
    elbs = host_info["ids_to_balancers"][host_id]
    print "Re-adding %s [%s] to elbs:" % (host, host_id)
    for elb in elbs:
        sys.stdout.write("\t%s... " % elb)
        sys.stdout.flush()
        aws.add_instance_to_elb(elb, host_id)
        sys.stdout.write("Done!\n")
        sys.stdout.flush()


    
    
  
        
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Platz deployment script')
    parser.add_argument("version", type=str, nargs=1, help="the version to give this build")
    parser.add_argument("email", type=str, nargs=1, help="the email of the person running this deployment")
    parser.add_argument("--platz-only", dest='platz_only', action='store_true', default=False, help="only deploy platz")
    args = parser.parse_args()
    version = args.version[0]
    email = args.email[0]
    platz_only = args.platz_only

    if platz_only:
        print "** ONLY DEPLOYING PLATZ, MAKE SURE THIS IS WHAT YOU WANT! ***"
    host_info = get_app_host_info()
    print "Will deploy platz *only* to hosts:\n\t%s" % ("\n\t".join(admin_hosts()))
    print "\n"
                   

    print "Will deploy to hosts:\n\t%s" % ("\n\t".join(host_info["hosts"]))       
    raw_input ("Hit <Enter> to continue")
    hipchat_msg("Starting Production Deployment (%s, %s)" % (email, version))
    print "Updating source"
    checkout_ok = checkout(version)
    if checkout_ok == False:
        msg = "Checkout failed. Stopping deployment."
        print msg
        hipchat_err(msg)
        exit(1)

    print "Building Pegasus"
    if not platz_only:
        pegasus_ok = build_pegasus(version)
    else:
        pegasus_ok = True

    if pegasus_ok  == False:
        msg = "Pegasus build failed. Stopping deployment."
        print msg
        hipchat_err(msg)
        exit(1)
        
    print "Building Platz"
    platz_ok = build_platz(version)
    if platz_ok == False:
        msg = "Platz build failed. Stopping deployment."
        print msg
        hipchat_err(msg)
        exit(1)

    print "Tagging Build"
    tag_ok = tag(version)
    if tag_ok == False:
        msg = "Tag failed. stopping deployment."
        print msg
        hipchat_err(msg)
        exit(1)

    show_prompt = True

    for host in admin_hosts():
        deploy_platz(version, host)

    val = raw_input("Admin deploy done, print <Enter> to continue: ")
    hipchat_msg("Admin deploy complete")
    for host in host_info["hosts"]:
        hipchat_msg("Removing %s from ELB" % (host))
        remove_from_elbs(host, host_info)
        

        if 'platz' in host:
            print "Waiting for traffic to die off"
            wait_for_traffic_to_die(host)
            hipchat_msg("Deploying (Platz/Pegasus) to %s" % (host))
            deploy_platz(version, host)
        else:
            hipchat_msg("Deploying (Pegasus) to %s" % (host))

        if not platz_only:
            deploy_pegasus(version, host)


        add_to_elbs(host, host_info)

        if 'platz' in host:
            print "Waiting for host to start getting traffic"
            wait_for_traffic(host)

        hipchat_msg("%s back in ELB" % host)
        print "Done with %s" % host
        if show_prompt == True:
            val = raw_input("Hit <Enter> to continue to the next host, or type all and hit <Enter> to do the remainder or the boxes without prompting again.")
            if val == "all":
                print "Prompt will be skipped for the remaining boxes."
                time.sleep(2)
                show_prompt = False

    print "Notifying new relic of deployment"
    notify_newrelic(version, email)
    print "Notifying hipchat of deployment"
    hipchat_success("Production Deployment Complete! (%s, %s)" % (email, version))            

        

        

            
        

        

        
        
                
            
