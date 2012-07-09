#!/usr/local/bin/ruby
##
# Simple script to dump and load data from production
#
# We should never have production data in any other environment other then production.
#	However, due to the fact that we have no way of creating "dummy" data we don't have much of a choice.
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

threads = []

LoadVideoData = true
LoadMediaData = true
LoadContentData = true

DBMediaMaster = "10.104.105.237"
DBLocatorMaster = "10.102.35.223"

DBTargetHostname = "preprod0.cmmbbmwrrirf.us-east-1.rds.amazonaws.com"
DBTargetUsername = "awsuser"
DBTargetPassword = "a3cYv8q3PVYsIcqz"

if(LoadVideoData == true)
threads << Thread.new do
	puts "Dumping video data"
	cmdDumpVideo = "mysqldump -u videouser -h %s -pmnghlhgl --skip-opt --add-drop-table --database video > /tmp/video.sql" % DBMediaMaster 
	puts "CMD(dumpVideo): %s" % cmdDumpVideo
	system( cmdDumpVideo ) 

	puts "Loading video data"
	tsStart = Time.new.to_f()
	system( "mysql -h %s -u %s -p%s video < /tmp/video.sql" % [DBTargetHostname,DBTargetUsername,DBTargetPassword] )
	puts "Done loading video data %.2f" % (Time.new.to_f() - tsStart )
end
end

if(LoadMediaData == true)
threads << Thread.new do
	puts "Dumping media data"
	system( "mysqldump -u media -h %s -pLaiPeuqueT0k --skip-opt --add-drop-table --database media > /tmp/media.sql" % DBMediaMaster )

	puts "Loading media data"
	tsStart = Time.new.to_f()
	system( "mysql -h %s -u %s -p%s media < /tmp/media.sql" % [DBTargetHostname,DBTargetUsername,DBTargetPassword] )
	puts "Done loading media data %.2f" % (Time.new.to_f() - tsStart )
end
end

if(LoadContentData == true)
threads << Thread.new do
	puts "Dumping content data from bits"
	system( "mysqldump -u bits -h %s -pidle912giro bits --skip-opt --add-drop-table --tables decal_master content_video_category content_video_metadata content_decal_lookup ptz_type content_video_catalog content_providers > /tmp/content.sql" % DBLocatorMaster )

	puts "Loading content data"
	tsStart = Time.new.to_f()
	system( "mysql -h %s -u %s -p%s bits < /tmp/content.sql" % [DBTargetHostname,DBTargetUsername,DBTargetPassword] )
	puts "Done loading content data %.2f" % (Time.new.to_f() - tsStart )
end
end

threads.each do |t| t.join end

