##
# Cookbook Name:: phoenix
# Recipe:: default
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

envName = node.chef_environment

FSPhxPath = "/mnt/local/lockerz.com/phoenix/"

user "phoenix" do
	shell "/bin/false"
	system true
	comment "phoenix user"
end    

["java-1.6.0-openjdk-devel","bzip2-libs"].each do |packageName|
	package packageName
end

## Phoenix core directories
["db","run","etc","bin","sql","lib","logs"].each do |dirName|
	directory "%s/%s" % [FSPhxPath,dirName] do 
		mode "0755"
		owner "phoenix"
		group "phoenix"
		action :create
		recursive true
	end
end

link "/usr/phoenix" do
	to "/mnt/local/lockerz.com/phoenix/"
end

link "/var/log/phoenix" do
	to "/mnt/local/lockerz.com/phoenix/logs" 
end

remote_directory "%s/etc/com" % FSPhxPath do
	source "etc/com"
	overwrite true
	files_mode "0755"
	files_owner "phoenix"
	files_group "phoenix"
	files_backup false
end

remote_directory "%s/lib/" % FSPhxPath do
	source "lib"
	overwrite true
	files_mode "0755"
	files_owner "phoenix"
	files_group "phoenix"
	files_backup false
end

#cookbook_file "%s/bin/phoenix" % FSPhxPath do 
	#mode "0755"
	#owner "phoenix"
	#group "phoenix"
	#source "phoenix"
#end

#cookbook_file "%s/bin/phoenix.rb" % FSPhxPath do 
	#mode "0755"
	#owner "phoenix"
	#group "phoenix"
	#source "phoenix.rb"
#end
#link "/usr/bin/phx" do
	#to "/mnt/local/lockerz.com/phoenix/bin/phoenix.rb"
#end


if(node[:phoenix_services] != nil && node[:phoenix_services].size > 0 )

	## This is a very simple list of services that are enabled on this node
	template "%s/etc/phoenix.conf" % FSPhxPath do
		mode "0755"
		owner "phoenix"
		group "phoenix"
		source "phoenix.conf"
		variables({ 
			:services => node[:phoenix_services] 
		})
	end

	## Create logging directories
	node[:phoenix_services].each do |serviceName|
		directory "%s/logs/%s" % [FSPhxPath,serviceName] do 
			mode "0755"
			owner "phoenix"
			group "phoenix"
			action :create
			recursive true
		end
	end

	## c3po configs
	template "%s/etc/c3p0-config.xml" % FSPhxPath do
		mode "0755"
		owner "phoenix"
		group "phoenix"
		source "c3p0-config.xml.erb"
		variables({ 
			:envName => envName ,
			:dbUsername => node["mysql"]["users"]["readwrite"]["username"],
			:dbPassword => node["mysql"]["users"]["readwrite"]["password"]
		})
	end

	## memcache settings
	template "%s/etc/memcached.properties" % FSPhxPath do
		mode "0755"
		owner "phoenix"
		group "phoenix"
		source "memcached.properties.erb"
		variables({ :envName => envName })
	end

	## ECache
	cookbook_file "%s/etc/ehcache.locator.client.xml" % FSPhxPath do
		mode "0755"
		owner "phoenix"
		group "phoenix"
		source "ehcache.locator.client.xml"
	end

	cookbook_file "%s/etc/ehcache.auction.uid.sku.xml" % FSPhxPath do
		mode "0755"
		owner "phoenix"
		group "phoenix"
		source "ehcache.auction.uid.sku.xml"
	end

	## Queries file
	cookbook_file "%s/etc/queries.properties" % FSPhxPath do
		mode "0755"
		owner "phoenix"
		group "phoenix"
		source "queries.properties"
	end

	## IceStorm
	if(node["phoenix_services"].include?( "icebox" ))
		## This rule will ensure that only the node with a phoenix_service including icebox will
		#	be able to run the icebox service.
		cookbook_file "%s/etc/icestorm.config.icebox" % FSPhxPath do
			mode "0755"
			owner "phoenix"
			group "phoenix"
			source "icestorm.config.icebox"
		end

		cookbook_file "%s/etc/icestorm.config.admin" % FSPhxPath do
			mode "0755"
			owner "phoenix"
			group "phoenix"
			source "icestorm.config.admin"
		end

		cookbook_file "%s/etc/icestorm.config.service" % FSPhxPath do
			mode "0755"
			owner "phoenix"
			group "phoenix"
			source "icestorm.config.service"
		end

		template "%s/bin/check_ice_topics.rb" % FSPhxPath do
			mode "0755"
			owner "phoenix"
			group "phoenix"
			source "check_ice_topics.erb"
			variables({
				:envName => envName
			})
		end

	end

	phxDbag = search( envName,"id:phoenix" ).first
	proxies = phxDbag["proxies"]
	serviceResources = phxDbag["resources"][envName]

	timeout = 5000
	tplProxies = []

	proxies.sort.each do |proxyName,config| 
		raise Exception.new( "No proxy resources for %s" % proxyName.downcase ) if(serviceResources[proxyName.downcase] == nil)
		tplProxies.push( "\t\t%sServicePrx: \"%sService: %s\"" % [
			proxyName,
			#proxyName.capitalize,
			#proxyName[0].upcase,
			"%s%s" % [proxyName[0,1].upcase,proxyName[1,proxyName.size]],
			serviceResources[proxyName.downcase].map{|node| "tcp -h %s -p %i -t %i" % [node,config["port"],timeout] }.join( ": " )
		])

		if(config["has_admin"] == true)
			tplProxies.push( "\t\t%sServiceAdminPrx: \"%sServiceAdmin: %s\"" % [
				proxyName,
				#proxyName.capitalize,
				"%s%s" % [proxyName[0,1].upcase,proxyName[1,proxyName.size]],
				serviceResources[proxyName.downcase].map{|node| "tcp -h %s -p %i -t %i" % [node,(config["port"]+50),timeout] }.join( ":" )
			])
		end
	end

	## Proxies
	template "%s/etc/proxies.json" % FSPhxPath do
		mode "0755"
		owner "phoenix"
		group "phoenix"
		source "proxies.json.erb"
		variables({ 
			:envName => envName,
			:tplProxies => tplProxies
		})
	end

	jsonUserData = JSON.parse( node[:ec2]["userdata"] )

	## Master config
	template "%s/etc/master-services.conf" % FSPhxPath do
		mode "0755"
		owner "phoenix"
		group "phoenix"
		source "all.properties.erb"
		variables({ 
			:proxies => proxies,
			:envName => envName,
			:jsonUserData => jsonUserData,
			:serviceResources => serviceResources
		})
	end

	## Link service property files to master config file
	link "%s/etc/accessControlService.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end
	link "%s/etc/amazonfps.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end
	link "%s/etc/auctionService.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end
	link "%s/etc/auctionProxyService.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end
	link "%s/etc/authenticationService.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end
	link "%s/etc/contentPublishService.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end
	link "%s/etc/contentService.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end
	link "%s/etc/dailiesService.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end
	link "%s/etc/dashboard.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end
	link "%s/etc/decalService.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end
	link "%s/etc/emailService.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end
	link "%s/etc/forumService.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end
	link "%s/etc/fwbPhotoService.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end
	link "%s/etc/giftcardService.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end
	link "%s/etc/hallwayService.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end
	link "%s/etc/imageProcessingService.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end
	link "%s/etc/invitationService.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end
	link "%s/etc/jms.endpoint.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end
	link "%s/etc/locatorService.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end
	link "%s/etc/mediaService.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end
	#link "%s/memcached.properties" % FSPhxPath do
		#to "%s/master-services.conf" % FSPhxPath
	#end
	link "%s/etc/mongodb.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end
	link "%s/etc/paymentService.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end
	link "%s/etc/podService.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end
	link "%s/etc/ptzService.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end
	#link "%s/etc/queries.properties" % FSPhxPath do
		#to "%s/etc/master-services.conf" % FSPhxPath
	#end
	link "%s/etc/searchService.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end
	link "%s/etc/serviceLocationService.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end
	link "%s/etc/socialService.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end
	link "%s/etc/thePlatformMetadataProvider.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end
	link "%s/etc/userMediaUploadService.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end
	link "%s/etc/userService.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end
	link "%s/etc/emiProvider.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end
	link "%s/etc/quartz.properties" % FSPhxPath do
		to "%s/etc/master-services.conf" % FSPhxPath
	end

end
