##
# Client recipe for log_manager
#
# This will setup the log manager to send files to an ingester target
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

isAdmin = node[:recipes].include?( "linux-base::admin" )

#landingFleet = search( :node,"chef_environment:%s AND run_list:role\\[DWLogReceiver\\]" % node.chef_environment )
#puts landingFleet.first().inspect()

if(isAdmin == false)
## User setup
user = search( :lockerz,"id:users" ).first["logmanager@lockerz.com"]
user_dir "logmanager" do
	private_key user["private_key"]
	group "logmanager"
end

directory "/var/run/logmanager" do
	mode "0755"
	owner "logmanager"
	group "logmanager"
end

end
