##
# CommentService.
#
include_recipe "tomcat::default"

package "git"

## Required for github
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

directory "/etc/CommentService/" do
	mode "0755"
	owner "tomcat"
	group "tomcat"
	action :create
	recursive true
end

directory "/mnt/local/lockerz.com/CommentService/" do
	mode "0755"
	owner "tomcat"
	group "tomcat"
	action :create
	recursive true
end

## Framing up the new standard.
directory "%s/follow_service/" % node[:fsServiceConfigRoot] do
	mode "0755"
	owner "tomcat"
	group "tomcat"
	action :create
	recursive true
end

directory "%s/follow/" % node[:fsLockerzRoot] do
	mode "0755"
	owner "tomcat"
	group "tomcat"
	action :create
	recursive true
end


node[:splunk][:monitors]["/mnt/local/tomcat6/logs/catalina.out"] = "CommentService"
