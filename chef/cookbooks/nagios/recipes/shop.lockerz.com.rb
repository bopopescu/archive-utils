##
# Shop/Commerce alarming
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

chefRoleName = "CommerceWebFrontend"
strHostgroupPattern = "commerce.site.%s.lockerz.com" 

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
	nagios_hostgroup strHostgroupPattern % envName do
		members nodes.map{|node| node.fqdn }.join( "," )
	end

	## Now create each host entry
	nodes.each do |node|
		nagios_host node.fqdn do
			address node.ipaddress
			use_nagios_host "lockerz_host"
			notifications_enabled true
		end
	end

	fsServiceDir = "%s/services/shop/%s/uri" % [node["nagios"]["config_dir"],envName]
	directory fsServiceDir do
		mode "0755"
		owner "nagios"
		group "nagios"
		action :create
		recursive true
	end

	fsServiceDir = "%s/services/shop/%s/system" % [node["nagios"]["config_dir"],envName]
	directory fsServiceDir do
		mode "0755"
		owner "nagios"
		group "nagios"
		action :create
		recursive true
	end

	## Core checks
	nagios_service "shop/%s/system/check_root_disk" % envName do
		hostgroup strHostgroupPattern % envName
		check_command "checkDisk!root"
		contact_groups "opz"
		use_nagios_service "lockerz_service"
		service_description "Check root disk"
		notifications_enabled true
	end

	nagios_service "shop/%s/system/check_local_disk" % envName do
		hostgroup strHostgroupPattern % envName
		check_command "checkDisk!local"
		contact_groups "opz"
		use_nagios_service "lockerz_service"
		service_description "Check local disk"
		notifications_enabled true
	end

	nagios_service "shop/%s/system/check_cpu" % envName do
		hostgroup strHostgroupPattern % envName
		check_command "checkCPU"
		contact_groups "opz"
		use_nagios_service "lockerz_service"
		service_description "Check CPU"
		notifications_enabled true
	end

	## Setup the basic site uri checks.
	[{
		:uri => "/",
		:name => "root"
	},{
		:uri => "/REVISION",
		:name => "CheckRevision",
		:expect => "^[0-9]{1,}$",
		#:uri_tpl => "/REVISION"
	}].each do |test|

		#if(test[:uri_tpl] != nil)
			#erb = Erubis::Eruby.new(test[:uri_tpl])
			#test[:uri] = erb.evaluate({
				#:role => search( :role,"name:%s" % chefRoleName ).first(),
				#:environment => search( :environment,"name:%s" % envName ).first()
			#})
		#end

		nagios_service "shop/%s/uri/%s" % [envName,test[:name]] do
			register true
			contacts "ooc@lockerz.com"
			hostgroup strHostgroupPattern % envName
			check_command "checkHTTPUrl!shop.lockerz.com!\"%s\"%s!80" % [
				test[:uri],
				(test[:expect] != nil ? " -r '%s' " % test[:expect] : "" )
			]
			use_nagios_service "lockerz_service"
			service_description "Check shop.lockerz.com: %s" % test[:uri]
			notifications_enabled true
		end
	end

end
