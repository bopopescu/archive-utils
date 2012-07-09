##
# Tomcat recipe for argo
#
include_recipe "tomcat::default"

directory "/mnt/local/lockerz.com/argo/" do
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

node[:splunk][:monitors]["/mnt/local/tomcat6/logs/catalina.out"] = "argo"
