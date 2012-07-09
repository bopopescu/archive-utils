#!/usr/local/bin/ruby
##
# Papi remote client.
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com
require "rubygems"
require "mongo"
require "net/ssh"
require "optparse"

options = { :verbose => false }
optParse    = OptionParser.new do |opts|
    opts.banner = "Usage: snap_and_mount.rb [--verbose] --destination=InstanceId --source=InstanceId"

    opts.on("-v", "--verbose", "Run verbosely") do |v|
        options[:verbose] = v
    end

    opts.on("-s","--source SOURCE_LOG_FILE","source log file") do |source|
        options[:source] = source
    end

    opts.on("-h","--host SOURCE_HOSTNAME","source hostname") do |hostname|
        options[:hostname] = hostname
    end

    opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
    end
end
optParse.parse( ARGV )

puts options.inspect

MaxNumThreads = 10

begin
	failures = []

	apiThreads = []

	Username = "bryan"
	MongoDBHostname = "buddy0.opz.prod.lockerz.int"

	coll = Mongo::Connection.new( MongoDBHostname,27017,{ :pool_size => 10 }).db( "papi" ).collection( "access_log_stats" )
	collUris = Mongo::Connection.new( MongoDBHostname,27017,{ :pool_size => 10 }).db( "papi" ).collection( "access_log_uris" )
	collHosts = Mongo::Connection.new( MongoDBHostname,27017,{ :pool_size => 10 }).db( "papi" ).collection( "access_log_hosts" )

	#Log.debug( "File (%s :: %i)" % [apiNode,@numThreads] ){ fileName }
	(year,month,day,hour) = options[:source].scan( /u_ex([0-9]{2})([0-9]{2})([0-9]{2})([0-9]{2})\.log$/ )[0]
	#puts "%i\t%i\t%i\t%i" % [year.to_i(),month.to_i(),day.to_i(),hour.to_i()]
	#next

	stats = { 
		:numHits => 0.0,
		:failures => 0,
		:redirects => 0,
		:successes => 0,
		:totalTime => 0.0,
		:totalBytes => 0.0
	}

	uriStats = {}
	hostStats = {}

	fsLocal = "%s/%s" % ["/mnt/local/logmanager",File.basename( options[:source] )]

	if(!File.exists?( fsLocal ))
		cmdPullFile = "scp %s@%s:%s %s" % [Username,options[:hostname],options[:source],fsLocal]
		puts "CMD(pull): %s" % cmdPullFile
		system( cmdPullFile )
		puts "File pulled"
	end

	tsStart = Time.new.to_f()
	File.open( fsLocal ).each do |line|
	#Net::SSH.start( options[:hostname],Username ) do |ssh|
		#ssh.exec( "cat %s" % options[:source] ) do |channel,stream,data|
			#data.split( "\n" ).each do |line|
				vars = line.chomp.split()
				#puts vars.inspect
				next if(vars.size != 14 || vars[0].match( /^#/ ))
				#puts vars.size
				code = vars[10].to_i()

				stats[:numHits] += 1
				stats[:failures] += 1 if(code >= 500)
				stats[:successes] += 1 if(code <= 200 && code < 300)

				#uri = vars[4]
				#if(!uriStats[uri])
					#uriStats[uri] = { 
						#:numHits => 0.0,
						#:failures => 0,
						#:redirects => 0,
						#:successes => 0,
						#:totalTime => 0.0,
						#:totalBytes => 0.0
					#}
				#end
				#uriStats[uri][:numHits] += 1
				#uriStats[uri][:failures] += 1 if(code >= 500)
				#uriStats[uri][:successes] += 1 if(code <= 200 && code < 300)

				ipNum = vars[8].split(/\./).map{|c| c.to_i}.pack("C*").unpack("N").first
				if(!hostStats[ipNum])
					hostStats[ipNum] = {
						:ipAddr => vars[8],
						:numHits => 0.0,
						:failures => 0,
						:redirects => 0,
						:successes => 0,
						:totalTime => 0.0,
						:totalBytes => 0.0
					}
				end

				hostStats[ipNum][:numHits] += 1
				hostStats[ipNum][:failures] += 1 if(code >= 500)
				hostStats[ipNum][:successes] += 1 if(code >= 200 && code < 300)

			#end ## data.split
		#end ## ssh.exec
	#end ## SSH.start
	end ## File.open
	#Log.debug( "File (%i)" % File.size(fileName) ){ "%s\t%.2f" % [fileName,(Time.new.to_f()-tsStart)] }

	puts "Process time: %.2f" % (Time.new.to_f()-tsStart)

	puts "NumHosts: %i" % hostStats.size

	coll.update({
		:date => "%i-%i-%i" % [year.to_i(),month.to_i(),day.to_i()],
		:hour => hour.to_i()
	}, { "$inc" => { 
		:numHits => stats[:numHits],
		:failures => stats[:failures] 
	}}, { :upsert => true })

	#uriStats.each do |uri,stats|
		#collUris.update({
			#:uri => uri
		#}, { "$inc" => { 
			#:numHits => stats[:numHits],
			#:failures => stats[:failures] ,
			#:successes => stats[:successes] 
		#}}, { :upsert => true })
	#end

	hostStats.each do |ipNum,stats|
		next if(stats[:numHits] < 100)
		collHosts.update({
			:ipNum => ipNum
		}, { "$inc" => { 
			:numHits => stats[:numHits],
			:failures => stats[:failures] ,
			:successes => stats[:successes] 
		}}, { :upsert => true })
	end

	puts "Runtime: %.2f" % (Time.new.to_f()-tsStart)

rescue => e
	puts "Exception caught: %s" % e
	puts e.backtrace()

end

