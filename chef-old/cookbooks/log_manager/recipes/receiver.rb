##
# Client recipe for log_manager
#
# This will setup the log manager to accept connections from endnodes.
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

## Packages
["s3cmd"].each do |packageName|
	package packageName
end

cookbook_file "/root/.s3cmd" do
	mode "0755"
	owner "root"
	group "root"
	source "s3cmd.cfg"
end

## User setup
user = search( :lockerz,"id:users" ).first["logmanager@lockerz.com"]
user_dir do
	username "logmanager"
	public_keys user["keys"]
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

mount "/mnt/local" do
	device "/dev/md1"
	fstype "xfs"
	action [:mount,:enable]
end

#mount "/mnt/ebs" do
	#device "/dev/md0"
	#fstype "xfs"
	#action [:mount,:enable]
#end

#mount "/mnt/archive" do
	#device "/dev/sdg1"
	#fstype "xfs"
	#action [:mount,:enable]
#end

#/dev/md1             1761332992 1501895332 259437660  86% /mnt/local
#/dev/md0             786298880 671438000 114860880  86% /mnt/ebs
#/dev/sdg1            1048439424 459291180 589148244  44% /mnt/archive

