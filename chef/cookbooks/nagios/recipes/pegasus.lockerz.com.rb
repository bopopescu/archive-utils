##
# Pegasus alarms
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

#envs = search( :environment,"*:*" )
#puts envs.inspect

chefRoleName = "PegasusWebFrontend"

## This will ensure that we don't create entries for empty environments 
#	( or environments that have no nodes for this role ).
envs = {}
allNodes = search( :node,"run_list:role\\[%s\\]" % [chefRoleName] )
allNodes.each do |node|
	envName = node.chef_environment
	envs[envName] ||= [] 
	envs[envName].push( node )
end

envs.each do |envName,nodes|
	## Create the hostgroup
	nagios_hostgroup "pegasus.site.%s.lockerz.com" % envName do
		members nodes.map{|node| node.fqdn }.join( "," )
	end

	## Now create each host entry
	nodes.each do |node|
		next if(node.fqdn == "nate0.opz.prod.lockerz.us") ## Ignore this guy, he's bad news ;)
		nagios_host node.fqdn do
			address node.ipaddress
			use_nagios_host "lockerz_host"
			notifications_enabled true
		end
	end

	fsServiceDir = "%s/services/pegasus/%s/uri" % [node["nagios"]["config_dir"],envName]
	directory fsServiceDir do
		mode "0755"
		owner "nagios"
		group "nagios"
		action :create
		recursive true
	end

	## Setup the basic site checks.
	[{
		:uri => "/",
		:name => "root"
	},{
		:uri => "/s/1",
		:name => "first_image"
	}].each do |test|
		nagios_service "pegasus/%s/uri/%s" % [envName,test[:name]] do
			register true
			contacts "ooc@lockerz.com,dev-oncall@lockerz.com"
			#contacts "bryan@lockerz.com"
			hostgroup "pegasus.site.%s.lockerz.com" % envName
			check_command "checkHTTPUrl!lockerz.com!\"%s\"!80" % test[:uri]
			use_nagios_service "lockerz_service"
			service_description "Check lockerz.com: %s" % test[:uri]
			notifications_enabled true
		end
	end

	nagios_service "pegasus/%s/check_root_disk" % envName do
		contacts "ooc@lockerz.com,pegasus-oncall@lockerz.com"
		hostgroup "pegasus.site.%s.lockerz.com" % envName
		check_command "checkDisk!root"
		use_nagios_service "lockerz_service"
		service_description "Check root disk"
		notifications_enabled true
	end

	nagios_service "pegasus/%s/check_local_disk" % envName  do
		contacts "ooc@lockerz.com,dev-oncall@lockerz.com"
		hostgroup "pegasus.site.%s.lockerz.com" % envName
		check_command "checkDisk!local"
		use_nagios_service "lockerz_service"
		service_description "Check local disk"
		notifications_enabled true
	end

	nagios_service "pegasus/%s/check_cpu" % envName do
		contacts "ooc@lockerz.com,dev-oncall@lockerz.com"
		hostgroup "pegasus.site.%s.lockerz.com" % envName
		check_command "checkCPU"
		use_nagios_service "lockerz_service"
		service_description "Check CPU"
		notifications_enabled true
	end

end
