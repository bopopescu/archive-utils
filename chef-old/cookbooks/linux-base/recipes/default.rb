# Cookbook Name:: linux-base
# 	This cookbook is the base setup script for everything else.
#
# @TODO: move ldap_auth to ldap-auth
# @TODO: fix sudo 
#
# @author	Bryan Kroger ( bryan@lockerz.com )

## Pull in the other recipes for default.
# 	This could be moved to the recipe for system, but this
#	seems to make things more clear.
if(node[:platform] != "ubuntu")
	include_recipe "linux-base::yum"
end
include_recipe "linux-base::core-packages"
include_recipe "linux-base::sudo"
include_recipe "linux-base::snmpd"
#include_recipe "linux-base::postfix"
#include_recipe "smtp::relay_server"
include_recipe "linux-base::chef-base"
include_recipe "linux-base::ldap-auth"
include_recipe "linux-base::user-accounts"
include_recipe "linux-base::python"

## Set this here so we can use it later on
#	Default to 'opz' just in case.
envName = (node.chef_environment == nil ? "opz" : node.chef_environment)

## Ensure the resolv.conf file gets created properly.
#	This means using chef searches to find the DNSMasters and DNSSlaves
#	Defined in definitions/resolv.rb
resolv do
	domain "%s.lockerz.int" % envName
end

## We use this to keep things secret, although, how secret is anything
#	if we're keeping the secret key in the repo?
cookbook_file "/etc/chef/encrypted_data_bag_secret" do
	mode "0600"
	owner "root"
	group "root"
	source "lockerz_db_secure"
end

## Enable and start the nscd service.
#	@TODO: move this to core-packages
service "nscd" do
    action [ :enable, :start ]
    supports :restart => true, :reload => true
    ignore_failure true
end

## Save the current state of any mdadm arrays
execute "Backup mdadm state" do
	not_if File.exists?( "/etc/mdadm.conf" ).to_s()
	action :run
	command "mdadm -Es > /etc/mdadm.conf"
end


directory "/root/bin/"
cookbook_file "/root/bin/mk_sdb" do
	mode "0755"
	source "system/mk_sdb"
end
cookbook_file "/root/bin/sdb.partition" do
	source "system/sdb.partition"
end

## Push out the scripts to create sdc just in case we end up needing it.
cookbook_file "/root/bin/mk_sdc" do
	mode "0755"
	source "system/mk_sdc"
end
cookbook_file "/root/bin/sdc.partition" do
	source "system/sdc.partition"
end



## This will ensure that /dev/sdb1 gets created as per the standard
#	disk image rules contained on the base "golden" image.
# 	However, if the disk is part of an mdraid, we don't want this to happen.
#execute "ephemeral test" do
#	only_if {
#		File.exists?( "/dev/sdb" ) && ## the disk actually exists
#		(
#			!File.open( "/proc/partitions" ).read.match( /sdb1/ ) && ## sdb* does not exist in the partition table
#			!File.open("/proc/mdstat").read.match( /sdb/ ) && ## sdb is not in an mdadm array
#			node['ec2']['instance_type'] != 'cc1.4xlarge' ## this is not an hvm instance
#		)
#	}
#	action :run
#	command "/root/bin/mk_sdb"
#end
# above commented out ony march 28th 2012.


## This ensures that there will always be a place to mount /dev/sdb1
#	Regardless of it's state in an mdadm array we want to make sure this
#	exists because we want to enforce a standard location for things
#	like logging, or data dumps.
directory "/mnt/local" do
	mode "0755"
	owner "root"
	group "root"
	recursive true
end

## Mount /dev/sdb to /mnt/local
# However, if the disk is part of an mdraid, don't try to mount it
mount "/mnt/local" do
	device (node[:platform] == "ubuntu" ? "/dev/sdb" : "/dev/sdb1")
	fstype (node[:platform] == "ubuntu" ? "ext3" : "xfs")
	only_if {
		File.open( "/proc/partitions" ).read.match( /sdb1/ ) && ## The partition exists in /proc/partitions.
		!File.open("/proc/mdstat").read.match( /sdb/ ) && ## The partition is not part of an mdadm array.
		node['ec2']['instance_type'] != 'cc1.4xlarge' ## This is not an hvm instance.
	}
end

## Ensure the proper time zone is set.
cookbook_file "/etc/localtime" do
	action :delete
	only_if("test -f /etc/localtime")	
end
link "/usr/share/zoneinfo/GMT" do
	to "/etc/localtime"
end



