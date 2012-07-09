#!/usr/bin/ruby
##
# Phoenix control script
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com
#
# Usage: phoenix.rb [start|stop] [serviceName] [machine|human]
#
# Examples:
#	Start everything:
#	$> phoenix.rb start
#
#	Status of everything
#	$> phoenix.rb status
#
RED     = "\e[0;31m"
BRIGHT_RED      = "\e[1;31m"
GREEN   = "\e[0;32m"
YELLOW  = "\e[1;33m"
BRIGHT_YELLOW   = "\e[0;33m"
BLUE    = "\e[1;34m"
BRIGHT_BLUE = "\e[0;34m"
PURPLE  = "\e[1;35m"
CLOSE   = "\e[0m"

LogFormat = "%s%s #{CLOSE}\n"

FSPhoenixRoot ="/mnt/local/lockerz.com/phoenix"
FSLogPath ="%s/logs" % FSPhoenixRoot
FSPidPath ="%s/run" % FSPhoenixRoot
FSLibPath ="%s/lib" % FSPhoenixRoot
FSBinPath ="%s/bin" % FSPhoenixRoot
FSCfgPath ="%s/etc" % FSPhoenixRoot

Services = {
	:acl => {
		:javaEndPoint => "com.lockerz.phoenix.accesscontrol.AccessControlServiceMain"
	},
	:accesscontrol => {
		:javaEndPoint => "com.lockerz.phoenix.accesscontrol.AccessControlServiceMain"
	},
	:auction => {
		:javaOpts => " -Dhazelcast.config=%s/auction.hazelcast.xml -Dorg.aspectj.weaver.loadtime.configuration=META-INF/loggingaop.xml -Dhazelcast.logging.type=log4j " % [ FSCfgPath ],
		:javaEndPoint => "com.lockerz.phoenix.auction.AuctionServiceMain"
	},
	:auctionproxy => {
		:javaOpts => " -Dhazelcast.config=%s/auctionProxy.hazelcast.xml -Dhazelcast.logging.type=log4j " % FSCfgPath,
		:javaEndPoint => "com.lockerz.phoenix.auction.AuctionServiceMain"
	},
	:authentication => {
		:javaEndPoint => "com.lockerz.phoenix.authentication.AuthenticationServiceMain"
	},
	:content => {
		:javaEndPoint => "com.lockerz.phoenix.content.ContentServiceMain"
	},
	#:contentadmin => {
		#:javaEndPoint => "com.lockerz.phoenix.content.ContentAdminServiceMain"
	#},
	:contentpublish => {
		:javaEndPoint => "com.lockerz.phoenix.content.publish.ContentPublishService"
	},
	:dailies => {
		:javaEndPoint => "com.lockerz.phoenix.dailies.DailiesServiceMain"
	},
	#:dailiesadmin => {
		#:javaEndPoint => "com.lockerz.phoenix.dailies.DailiesAdminServiceMain"
	#},
	:decal => {
		:javaEndPoint => "com.lockerz.phoenix.decal.DecalServiceMain"
	},
	:email => {
		:javaEndPoint => "com.lockerz.phoenix.email.EmailServiceMain"
	},
	:emischeduler => {
		:javaEndPoint => "com.lockerz.phoenix.video.emi.EmiScheduler"
	},
	:forum => {
		:javaEndPoint => "com.lockerz.phoenix.forum.ForumServiceMain"
	},
	:fwbphoto => {
		:javaEndPoint => "com.lockerz.phoenix.photos.FwbPhotoServiceMain"
	},
	#:fwbphotoadmin => {
		#:javaEndPoint => "com.lockerz.phoenix.photos.FwbPhotoAdminServiceMain"
	#},
	:fwbphotostreambatchmain => {
		:javaEndPoint => "com.lockerz.phoenix.photos.FwbPhotoStreamBatchMain"
	},
	:giftcard => {
		:javaEndPoint => "com.lockerz.phoenix.giftcard.GiftCardServiceMain"
	},
	:hallway => {
		:javaEndPoint => "com.lockerz.phoenix.hallway.HallwayServiceMain"
	},
	:imageprocessing => {
		:javaOpts => "-Djava.library.path=%s/lib" % FSLibPath,
		:javaEndPoint => "com.lockerz.phoenix.media.processing.ImageProcessingServiceMain"
	},
	:invitation => {
		:javaEndPoint => "com.lockerz.phoenix.invitation.InvitationServiceMain"
	},
	:locator => {
		:javaEndPoint => "com.lockerz.phoenix.locator.LocatorServiceMain"
	},
	:media => {
		:javaEndPoint => "com.lockerz.phoenix.media.MediaServiceMain"
	},
	:payment => {
		:javaEndPoint => "com.lockerz.phoenix.payment.PaymentServiceMain"
	},
	:platformplugin => {
		:javaEndPoint => "com.lockerz.phoenix.content.metadata.theplatform.ThePlatformMetadataProviderMain"
	},
	:pod => {
		:javaEndPoint => "com.lockerz.phoenix.pod.PodServiceMain"
	},
	:ptz => {
		:javaEndPoint => "com.lockerz.phoenix.ptz.PtzServiceMain"
	},
	#:ptzadmin => {
		#:javaEndPoint => "com.lockerz.phoenix.ptz.PtzAdminServiceMain"
	#},
	:search => {
		:javaEndPoint => "com.lockerz.phoenix.search.SearchServiceMain"
	},
	:servicelocation => {
		:javaEndPoint => "com.lockerz.phoenix.serviceLocation.ServiceLocationServiceMain"
	},
	:social => {
		:javaEndPoint => "com.lockerz.phoenix.social.SocialServiceMain"
	},
	:theplatformmetadataprovidermain => {
		:javaEndPoint => "com.lockerz.phoenix.content.metadata.theplatform.ThePlatformMetadataProviderMain"
	},
	:user => {
		:javaEndPoint => "com.lockerz.phoenix.user.UserServiceMain"
	},
	:usermediaupload => {
		:javaEndPoint => "com.lockerz.phoenix.media.upload.UserMediaUploadService"
	}
}

#puts Services.collect{|k,v| k.to_s }.to_json

Options = {:verbose => false, :strLogDate => Time.new().strftime( "%Y%m%d_%H%M%S" )}

#["auctionproxy","authentication","locator","ptz","fwbphotostreambatchmain","decal","giftcard","accesscontrol","dailies","forum","pod","social","hallway","fwbphoto","imageprocessing","invitation","media","payment","auction","content","platformplugin","user","email","search"]

## first param is the action
Options[:action] = ARGV[0]

## second param is always the target
Options[:target] = (ARGV[1] == nil ? "all" : ARGV[1])

## Output format
Options[:format] = (ARGV[2] != nil || ARGV[2] == "machine" ? :machine : :human)

## Log levels
#Log.level = Logger::ERROR if(Options[:verbose] == 1)
#Log.level = Logger::WARN if(Options[:verbose] == 2)
#Log.level = Logger::INFO if(Options[:verbose] == 3)
#Log.level = Logger::DEBUG if(Options[:verbose] == 4)

##
# Status of a given service
# @param	string	serviceName	Name of service.
def startService( serviceName,params={} )

	if(serviceName == "icebox")
		cmdRunIce = "icebox --Ice.Config=%s/icestorm.config.icebox &" % FSCfgPath
		system( cmdRunIce )
		return
	end

	## Check for run dir

	vars = {}
	vars["java.awt.headless"] = true
	#vars["log.dir"] = "%s/%s" % [FSLogPath,serviceName]
	vars["config.dir"] = FSCfgPath
	vars["log.filename"] = "%s/%s/service" % [FSLogPath,serviceName]
	vars["user.timezone"] = "UTC"
	vars["file.encoding"] = "utf-8"
	vars["net.spy.log.LoggerImpl"] = "net.spy.memcached.compat.log.Log4JLogger"
	vars["com.mchange.v2.c3p0.cfg.xml"] = "%s/c3p0-config.xml" % FSCfgPath

	javaOpts = []
	javaOpts += vars.collect{|k,v| "-D%s=%s" % [k,v] }
	javaOpts.push( " -javaagent:%s/aspectjweaver.jar " % FSLibPath )

	#javaArgs = " -Xmx256m -XX:+PrintTenuringDistribution -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -Xloggc:%s/%s/gc_%s.log -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=%s/%s/dump " % [
	javaArgs = " -Xmx128m -XX:+PrintTenuringDistribution -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -Xloggc:%s/%s/gc_%s.log -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=%s/%s/dump " % [
		FSLogPath,
		serviceName,
		Options[:strLogDate],
		FSLogPath,
		serviceName
	]

	srvCfg = Services[serviceName.to_sym()]
	if(srvCfg == nil)
		raise Exception.new( "No configuration found for %s" % serviceName )
	end

	## Merge in any override options
	javaOpts.push( srvCfg[:javaOpts] ) if(srvCfg[:javaOpts] != nil)

	## End point
	javaOpts.push( srvCfg[:javaEndPoint] )

	classPath = "%s:%s" % [FSCfgPath,Dir.glob( "%s/*" % FSLibPath ).collect{|object| 
		(object.match( /^.*\.jar$/ ) ? object : nil)
	}.compact.join( ":" )]

	cmdRunJava = "/usr/bin/java -server %s -cp %s %s " % [
		javaArgs,
		classPath,
		javaOpts.join( " " )
	]

	cmdRunJava += ">> %s/%s/stdout.log 2>&1 & echo $! > %s/%s.pid" % [
		FSLogPath,
		serviceName,
		FSPidPath,
		serviceName
	]
	#puts "CMD(runJava): %s" % cmdRunJava
	#puts "Running...."
	puts LogFormat % [GREEN,"Starting %s" % serviceName]
	system( cmdRunJava )

end


def stopService( serviceName )
	puts "Stopping %s " % LogFormat % [RED,serviceName]
	system( "kill `cat %s/%s.pid`" % [FSPidPath,serviceName] )
end

def restartService( serviceName )
	stopService( serviceName )
	startService( serviceName )
end

def getServiceNames()
	ro = []
	cfgFile = "%s/phoenix.conf" % FSCfgPath
	cfgFile = "/etc/phoenix/phoenix.conf" if(File.exists?( "/etc/phoenix/phoenix.conf" ))
	#lines = `cat #{FSCfgPath}/phoenix.conf`.split( /\n/ )
	File.open( cfgFile ).each do |line|
		next if(line.match( /^#/ ) || line == "\n")
		if(line.match( /^serviceArgs/ )) ## legacy junk
			ro.push( line.split()[1].downcase.gsub( /_/,'' ) )
		else
			ro.push( line.chomp )
		end
		#statusService( serviceName )
	end
	#puts "Services: %s" % ro.inspect
	return ro
end

##
# Status of a given service
# @param	string	serviceName	Name of service.
def statusService( serviceName,jps )
	if(serviceName == "icebox")
		test = `ps aux|grep icebox|grep -v grep`.split.sort
		return (test.size > 0 ? true : false )
	end

	fmtServiceName = serviceName.gsub( /_/,'' ).downcase

	if(fmtServiceName == "platformplugin")
		running = jps.include?( "ThePlatformMetadataProviderMain" ) 
	elsif(fmtServiceName == "usermediaupload")
		running = jps.include?( "usermediauploadservice" ) 
	else
		running = jps.include?( fmtServiceName )
	end

	if(running == true)
		if(Options[:format] == :human)
			puts LogFormat % [GREEN,"%s\t\trunning" % serviceName]
		end
	else
		if(Options[:format] == :human)
			puts LogFormat % [RED,"%s\t\tnot running" % serviceName]
			puts "\tLogs: %s/%s" % [FSLogPath,serviceName]
			puts "\tStart: %s/phoenix.rb start %s" % [FSBinPath,serviceName]
		end
	end
	return running
end



case Options[:action]
when "start"
	if(Options[:target] == "all")
		getServiceNames.each do |serviceName|
			startService( serviceName )
			sleep 5
		end
	else
		startService( Options[:target] )
	end

when "stop"
	if(Options[:target] == "all")
		getServiceNames.each do |serviceName|
			stopService( serviceName )
		end
	else
		stopService( Options[:target] )
	end

when "restart"
	if(Options[:target] == "all")
		getServiceNames.each do |serviceName|
			restartService( serviceName )
		end
	else
		restartService( Options[:target] )
	end

when "status"
	numServicesOkay = 0
	numServicesFailed = 0
	failedServices = []
	cmd = "%s jps" % (ENV['USER'] != "root" ? "sudo" : "")
	jps = `#{cmd}`.split( /\n/ ).map{|line|
		line.split[1].gsub( /ServiceMain$/,'' ).downcase
		#(line.downcase.match( /#{fmtServiceName}service/ ) ? true : nil)
	}
	#puts "JPS: %s" % jps.inspect

	if(Options[:target] == "all")
		getServiceNames.each do |serviceName|
			status = statusService( serviceName,jps )
			if(status == false)
				numServicesFailed += 1
				failedServices.push( serviceName )
			else
				numServicesOkay += 1
			end
		end
		if(numServicesFailed > 0)
			puts "CRITICAL %i services failed (%s)" % [numServicesFailed,failedServices.join( "," )]
			exit 1

		else
			puts "OK %i services working" % [numServicesOkay]
			exit 0

		end

	else
		status = statusService( Options[:target],jps )
		if(status == false)
			puts "CRITICAL 1 services failed (%s)" % serviceName
			exit 1

		else
			puts "OK 1 service working" 
			exit 0

		end
	end


else
	puts "Unknown action"
	exit 1

end

exit 0
