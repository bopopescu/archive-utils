##
# LogManager Log Watcher
#
# Usage:
#	Monitor an apache log file:
#
#	lm_watcher do
#		owner "apache"
#		group "apache"
#		postCmd "sudo /etc/init.d/httpd restart"
#		logName "apache_access_log"
#		logFilename "%s/pegasus/access.log" % node[:fsLogRoot]
#		logDisplay "Apache Access Log"
#		rotationInterval 30
#	end
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

define :lm_watcher do
	raise Exception.new( "Please pass a logFilename param to lm_watcher" ) if(params[:logFilename] == nil)

	## Ensure the scripts directory will exist.
	directory "/home/logmanager/scripts" do
		mode "0755"
		owner "logmanager"
		group "logmanager"
		recursive true
	end

	## This might end up being bad, but in order to prevent every node from either:
	#	* restarting apache at the same time
	#	* or trying to deliver logs as the same time
	# The rotationInterval is stagared based on the hosts integer value
	# For example: 
	#	if the rotationInterval = 20, and the node's fqdn = webfe4 ; rotationalInterval is now 24.
	stagInt = node[:fqdn].split( "." )[0].gsub( /[a-z]/,'' ).to_i()
	#stagInt = rand(100)
	if(stagInt > 0)
		params[:rotationInterval] = (params[:rotationInterval] + (stagInt % (params[:rotationInterval]/2)))
	end
	#puts "StagInt: %i :: %i" % [stagInt,params[:rotationInterval]]

	## Normally we'd use something like File.path, but that apparently requires fileutils
	pathParts = params[:logFilename].split( /\// )
	fsContainer = pathParts[0,(pathParts.length-1)].join( "/" )

	## Ensure that the archive directory for this log file will exist
	directory "%s/archive" % fsContainer do
		mode "0755"
		owner "logmanager"
		group "logmanager"
		recursive true
	end

	## Template for the rotation script.
	template "/home/logmanager/scripts/rotate_%s.sh" % params[:logName] do
		mode "0755"
		owner "logmanager"
		group "logmanager"
		source "rotate_log.sh.erb" % params[:logName]
		cookbook "log_manager"
		variables({ 
			:path => fsContainer,
			:group => params[:group],
			:owner => params[:owner],
			:postCmd => params[:postCmd],
			:logName => params[:logName],
			:basename => File.basename( params[:logFilename] ),
			:logDisplay => params[:logDisplay],
			:logFilename => params[:logFilename]
		})
	end

	## Crontab for the rotation script.
	cron "rotate_%s" % params[:logName] do
		hour "*"
		user "logmanager"
		minute "*/%i" % params[:rotationInterval].to_i()
		command "/home/logmanager/scripts/rotate_%s.sh &> /dev/null" % params[:logName]
	end

	## The idea here is that we can disable nodes in the landing fleet.
	#openNodes = []
	#landingNode = 

	#landingFleet = search( :node,"chef_environment:%s AND run_list:role\\[DWLogReceiver\\]" % node.chef_environment )
	#landingFleet = search( :node,"chef_environment:%s AND run_list:role\\[DWLogReceiver\\]" % "prod" ).first()
	#landingFleet.each do |lfNode| 
		#puts "Status: %s" % lfNode.inspect
		#openNodes.push( lfNode ) if(lfNode["status"] == "open")
	#end
	#puts "Open: %s" % openNodes.inspect
	#if(openNodes.size > 0)
		#landingNode = (openNodes.size == 1 ? openNodes[0] : openNodes[rand(openNodes.size)] )
	#end

	targetNodeFQDN = (params[:targetNodeFQDN] == nil ? "dw-logs0.dba.prod.lockerz.int" : params[:targetNodeFQDN])

	#if(landingNode != nil)
		## Create the delivery script.
		template "/home/logmanager/scripts/deliver_%s.sh" % params[:logName] do
			mode "0755"
			owner "logmanager"
			group "logmanager"
			source "deliver_log.sh.erb" % params[:logName]
			cookbook "log_manager"
			variables({ 
				:path => fsContainer,
				:logName => params[:logName],
				:basename => File.basename( params[:logFilename] ),
				:logDisplay => params[:logDisplay],
				:logFilename => params[:logFilename],
				:targetHostname => targetNodeFQDN,
				#:targetHostname => landingNode.internalip,
				:targetContainer => "/mnt/local/logmanager/%s/%s" % [node[:fqdn],params[:logName]]
			})
		end
	
		## Crontab for the delivery script.
		cron "deliver_%s" % params[:logName] do
			hour "*"
			user "logmanager"
			minute "*/%i" % (params[:rotationInterval].to_i()+1)
			command "/home/logmanager/scripts/deliver_%s.sh &> /dev/null" % params[:logName]
		end

		## Crontab for pruning the archives.
		cron "prune_%s_archive" % params[:logName] do
			hour "23"
			minute "5"
			user "logmanager"
			command "find %s/archive -mtime +10 -exec rm -rf {} \\ &> /dev/null;" % fsContainer
		end

		## Modified the above two stanzas to remove bryan from mail to in hopes of lowering mail deliveries.

	#else
	if(false)
		## Ensure the crontabs are disabled
		cron "deliver_%s" % params[:logName] do
			hour "*"
			user "logmanager"
			minute "*/%i" % (params[:rotationInterval].to_i()+1)
			action :delete
			command "/home/logmanager/scripts/deliver_%s.sh &> /dev/null" % params[:logName]
		end

		## Crontab for pruning the archives.
		cron "prune_%s_archive" % params[:logName] do
			hour "23"
			minute "5"
			user "logmanager"
			action :delete
			command "find %s/archive -mtime +10 -exec rm -rf {} \\; &> /dev/null" % fsContainer
		end

	end

end
