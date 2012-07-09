##
# Client recipe for log_manager
#
# This will setup the log manager to accept connections from endnodes.
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

## User setup
user = search( :lockerz,"id:users" ).first["logmanager@lockerz.com"]
user_dir do
	username "logmanager"
	public_keys user["keys"]
	private_key user["private_key"]
end

directory "/mnt/local/logmanager" do
	mode "0755"
	owner "logmanager"
	group "logmanager"
	recursive true
end

directory "/mnt/ebs/logmanager" do
	mode "0755"
	owner "logmanager"
	group "logmanager"
	recursive true
end

gem_package "mongo" do
	action :install
end

gem_package "bson_ext" do
	action :install
end

directory "/home/logmanager/scripts" do
	mode "0755"
	owner "logmanager"
	group "logmanager"
end

cookbook_file "/home/logmanager/scripts/papi_rps_remote.rb" do
	mode "0755"
	owner "logmanager"
	group "logmanager"
	source "processor/papi_rps_remote.rb"
end

