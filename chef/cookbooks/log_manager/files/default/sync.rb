#!/usr/local/bin/ruby
##
# Compress and sync files to s3
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

S3Bucket = "s3://dw-lockerz-com"
FSLogManagerRoot = "/mnt/local/logmanager"

threads = []

Dir.glob( "%s/*" % FSLogManagerRoot ).each do |hostnamePath|
  threads << Thread.new do
	#puts hostnamePath
	#next if(hostnamePath.match( /pts/ ))
	hostname = File.basename( hostnamePath )
	Dir.glob( "%s/*" % hostnamePath ).each do |contextPath|
		#puts "\t%s" % contextPath
		context = File.basename( contextPath )
		Dir.glob( "%s/*.lm" % contextPath ).each do |fileName|
			ts = Time.at( fileName.scan( /([0-9]{10})\.lm$/ )[0][0].to_i() )
			next if(ts.to_f() > (Time.new.to_f() - (86400 * 10)))
			#puts ts.to_s()

			## Compress the file before sending it to s3
			cmdCompress = "gzip -f %s" % fileName
			#puts "CMD(compress): %s" % cmdCompress
			system( cmdCompress )

			## Send the file up to s3
			s3Path = "%s/%s/%s/%i/%i/%i/" % [S3Bucket,hostname,context,ts.year,ts.month,ts.day]
			#puts "\t\tS3Path: %s" % s3Path

			cmdUploadContent = "s3cmd put %s.gz %s" % [fileName,s3Path]
			cmdUploadChecksum = "s3cmd put %s.checksum %s" % [fileName,s3Path]

			#puts "CMD(uploadContent): %s" % cmdUploadContent
			system( cmdUploadContent )

			#puts "CMD(uploadChecksum): %s" % cmdUploadChecksum
			system( cmdUploadChecksum )

			## Finally, remove the file
			#cmdRemove = "rm -rf %s*" % fileName
			#puts "CMD(remove): %s" % cmdRemove
			#system( cmdRemove )
		end
	end
  end ## thread
end

threads.each do |t| t.join end
