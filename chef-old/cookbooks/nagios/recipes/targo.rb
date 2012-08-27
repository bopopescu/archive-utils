##
# Targo alarms
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

chefRoleName = "TargoChecks"
nodes = search( :node,"run_list:role\\[%s\\]" % [chefRoleName] )

## Create the hostgroup
nagios_hostgroup "TargoServers" do
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

fsServiceDir = "%s/services/targo/" % [node["nagios"]["config_dir"]]
directory fsServiceDir do
	mode "0755"
	owner "nagios"
	group "nagios"
	action :create
	recursive true
end

nagios_service "targo/check_for_mysql" do
	register true
	contacts "dw-alert@lockerz.com"
	host "targo0.service.prod.lockerz.us"
	check_command "check_nrpe!check_for_mysql"
	use_nagios_service "lockerz_service"
	service_description "Check for mysql"
	notifications_enabled true
end

nagios_service "targo/check_for_tomcat" do
	register true
	contacts "dw-alert@lockerz.com"
	hostgroup "TargoServers"
	check_command "check_nrpe!check_for_tomcat"
	use_nagios_service "lockerz_service"
	service_description "Check for tomcat"
	notifications_enabled true
end


nagios_service "targo/check_root_disk" do
	contacts "dw-alert@lockerz.com"
	hostgroup "TargoServers"
    check_command "checkDisk!root"
    use_nagios_service "lockerz_service"
    service_description "Check root disk"
    notifications_enabled true
end

nagios_service "targo/check_local_disk"  do
	contacts "dw-alert@lockerz.com"
	hostgroup "TargoServers"
    check_command "checkDisk!local"
    use_nagios_service "lockerz_service"
    service_description "Check local disk"
    notifications_enabled true
end

nagios_service "targo/check_cpu" do
	contacts "dw-alert@lockerz.com"
	hostgroup "TargoServers"
    check_command "checkCPU"
    use_nagios_service "lockerz_service"
    service_description "Check CPU"
    notifications_enabled true
end

