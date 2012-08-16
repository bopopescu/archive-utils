#!/usr/local/bin/ruby
##
# Simple script to dump and load data
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

threads = []

LoadVideoData = true
LoadMediaData = false
LoadContentData = true

if(LoadVideoData == true)
threads << Thread.new do
	puts "Dumping video data"
	system( "mysqldump -u videouser -h 10.104.105.237 -pmnghlhgl --skip-opt --add-drop-table --database video > /tmp/video.sql" )

	puts "Loading video data"
	tsStart = Time.new.to_f()
	system( "mysql -u awsuser -h wit1.cmmbbmwrrirf.us-east-1.rds.amazonaws.com -p8RUwdO4Khk3HIF video < /tmp/video.sql" )
	puts "Done loading video data %.2f" % (Time.new.to_f() - tsStart )
end
end

if(LoadMediaData == true)
threads << Thread.new do
	puts "Dumping media data"
	system( "mysqldump -u media -h 10.102.41.151 -pLaiPeuqueT0k --skip-opt --add-drop-table --database media > /tmp/media.sql" )

	puts "Loading media data"
	tsStart = Time.new.to_f()
	system( "mysql -u awsuser -h wit1.cmmbbmwrrirf.us-east-1.rds.amazonaws.com -p8RUwdO4Khk3HIF media < /tmp/media.sql" )
	puts "Done loading media data %.2f" % (Time.new.to_f() - tsStart )
end
end

if(LoadContentData == true)
threads << Thread.new do
	puts "Dumping content data from bits"
	system( "mysqldump -u bits -h 10.102.35.223 -pidle912giro bits --skip-opt --add-drop-table --tables decal_master content_video_category content_video_metadata content_decal_lookup ptz_type > /tmp/content.sql" )

	puts "Loading content data"
	tsStart = Time.new.to_f()
	system( "mysql -u awsuser -h wit1.cmmbbmwrrirf.us-east-1.rds.amazonaws.com -p8RUwdO4Khk3HIF bits < /tmp/content.sql" )
	puts "Done loading content data %.2f" % (Time.new.to_f() - tsStart )
end
end

threads.each do |t| t.join end

