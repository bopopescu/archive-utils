##
# Photos API ( PAPI )
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

## Setup our hosts, which are defined in the prod papi data bag.
papiNodeId = 0
# Setting a friendly hostname that somewhat matches everything else.
papiPattern = "winapi%i.papi.%s.lockerz.us" 

papiResources = search( :prod,"id:papi" ).first()["resources"]["prod"]

hostGroupMembers = []
papiResources["winapi"].each do |hostIp|
	# Create a host def for each node.
	nagios_host papiPattern % [papiNodeId,"prod"] do
		address hostIp
		hostgroups "winapi.prod"
		use_nagios_host "lockerz_host"
		notifications_enabled true
	end
	hostGroupMembers.push( papiPattern % [papiNodeId,"prod"] )
	papiNodeId += 1
end

# Gather the hosts into a hostgroup, which we'll use with the service.
nagios_hostgroup "winapi.prod" do
	members hostGroupMembers.join( "," )
end

## Setup the basic api end point checks.
[{
	:uri => "photos",
	:name => "photots"
},{
	:uri => "socialfeed",
	:name => "social_feed"
},{
	:uri => "test",
	:name => "test"
},{
	:uri => "photos/1",
	:name => "photos_1"
},{
	:uri => "users/1",
	:name => "users_1"
}].each do |test|
	nagios_service "check_papi_%s" % test[:name] do
		register true
		hostgroup "winapi.prod"
		check_command "checkHTTPUrl!api.plixi.com!/api/tpapi.svc/%s!80" % test[:uri]
		contact_groups "papi-oncall"
		use_nagios_service "lockerz_service"
		service_description "Check the lockerz photos api service: %s" % test[:uri]
		notifications_enabled true
	end
end

