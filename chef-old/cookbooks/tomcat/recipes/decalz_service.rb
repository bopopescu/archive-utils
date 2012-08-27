##
# Direct Messaging Service
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com
include_recipe "tomcat::default"

## Required for github
package "git"
cookbook_file "/root/.ssh/id_rsa" do
	mode "0600"
	owner "root"
	group "root"
	source "golden_key"
end

cookbook_file "/root/.ssh/config" do
	mode "0600"
	owner "root"
	group "root"
	source "ssh_config"
end

directory "%s/decalz_service/" % node[:fsServiceConfigRoot] do
	mode "0755"
	owner "tomcat"
	group "tomcat"
	action :create
	recursive true
end

directory "%s/decalz/" % node[:fsLockerzRoot] do
	mode "0755"
	owner "tomcat"
	group "tomcat"
	action :create
	recursive true
end

node[:splunk][:monitors]["%s/logs/catalina.out" % node[:fsTomcatRoot]] = "DecalzService"
node[:splunk][:monitors]["%s/logs/decalz.log" % node[:fsTomcatRoot]] = "DecalzService"

