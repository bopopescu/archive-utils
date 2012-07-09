# Cookbook Name:: linux-base
# 	This cookbook is the base setup script for everything else.
#
# @TODO: move ldap_auth to ldap-auth
# @TODO: fix sudo 

## Pull in the other recipes for default.
# 	This could be moved to the recipe for system, but this
#	seems to make things more clear.
if(node[:platform] != "ubuntu")
	include_recipe "linux-base::yum"
end
include_recipe "linux-base::ldap-auth"
include_recipe "linux-base::user-accounts"
include_recipe "linux-base::sudo"
include_recipe "linux-base::snmpd"

## Set this here so we can use it later on
#	Default to 'opz' just in case.
envName = (node.chef_environment == nil ? "opz" : node.chef_environment)

## Ensure the resolv.conf file gets created properly.
#	This means using chef searches to find the DNSMasters and DNSSlaves
#	Defined in definitions/resolv.rb
resolv do
	domain "%s.lockerz.int" % envName
end

## Enable and start the nscd service.
#	@TODO: move this to core-packages
service "nscd" do
    action [ :enable, :start ]
    supports :restart => true, :reload => true
    ignore_failure true
end

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

## Ensure the proper time zone is set.
cookbook_file "/etc/localtime" do
	action :delete
	only_if("test -f /etc/localtime")	
end

link "/usr/share/zoneinfo/GMT" do
	to "/etc/localtime"
end


package "ntp" do
	action :install
end

service "ntp" do
    action [ :enable, :start ]
    supports :restart => true
    ignore_failure true
end

