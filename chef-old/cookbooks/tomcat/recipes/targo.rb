##
# Tomcat recipe for targo
#
include_recipe "tomcat::default"

directory "/mnt/local/lockerz.com/targo/" do
	mode "0755"
	owner "tomcat"
	group "tomcat"
	action :create
	recursive true
end

#link "/mnt/local/tomcat/etc/services/targo_service/" do
	#to "/etc/targo"
#end

## Framing up the new standard.
directory "%s/targo_service/" % node[:fsServiceConfigRoot] do
	mode "0755"
	owner "tomcat"
	group "tomcat"
	action :create
	recursive true
end

directory "%s/targo/" % node[:fsLockerzRoot] do
	mode "0755"
	owner "tomcat"
	group "tomcat"
	action :create
	recursive true
end

node[:splunk][:monitors]["/mnt/local/tomcat6/logs/catalina.out"] = "targo"
