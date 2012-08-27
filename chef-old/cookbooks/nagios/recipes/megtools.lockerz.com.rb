##
# Megtools
#	* pimtool
#	* video admin
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

hosts = []

## Setup our hosts, which are defined in the prod papi data bag.

nagios_host "pim.lockerz.com" do
	address "pim.lockerz.com"
	use_nagios_host "noping_lockerz_host"
	notifications_enabled true
end
hosts.push( "pim.lockerz.com" )


fsServiceDir = "%s/services/megtools/prod/uri/" % node["nagios"]["config_dir"]
directory fsServiceDir do
	mode "0755"
	owner "nagios"
	group "nagios"
	action :create
	recursive true
end



## Setup the basic site checks.

hostname = "pim.lockerz.com"
nagios_service "megtools/prod/uri/%s_%s" % [hostname,"root"] do
	hosts hostname
	register true
	contacts "ops@lockerz.com"
	check_command "checkHTTPSUrlStatus!%s!\"%s\"!401" % [hostname,"/"]
	use_nagios_service "lockerz_service"
	service_description "Check the %s site: %s" % [hostname,"root"]
	notifications_enabled true
end
