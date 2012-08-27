##
# This is for the chef server
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

include_recipe "httpd::default"

## VHost config
cookbook_file "/etc/httpd/conf.d/chef.conf" do
	mode "0755"
	owner "root"
	group "root"
	source "chef/vhost.conf"
end

