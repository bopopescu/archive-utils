##
# Description:
# 	Apache-specific configuration for the video admin tool
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

include_recipe "httpd::default"

envName = node.chef_environment

domain = (envName == "prod" ? "lockerz.com" : "lockerz.us")
domain = "lockerz.us" if(node[:fqdn] == "pierre0.opz.prod.lockerz.com")

## VHost
template "/etc/httpd/conf.d/video_admin.conf" do
	mode "0755"
	owner "apache"
	group "apache"
	source "video_admin/vhost.conf.erb"
	variables({ :domain => domain })
end


