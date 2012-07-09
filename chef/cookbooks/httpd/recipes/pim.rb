##
# Description:
# 	Apache-specific configuration for the pim tool.
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

include_recipe "httpd::default"

package "php-pear" do
	action :install
	package_name "php-pear"
end

cookbook_file "/etc/httpd/conf.d/ssl.conf" do
	action :delete
end

#domain = (envName == "prod" ? "lockerz.com" : "lockerz.us")
domain = "lockerz.us"

## Domain config
template "/etc/httpd/conf.d/pim.conf" do
	mode "0755"
	owner "apache"
	group "apache"
	source "pim/vhost.conf.erb"
	variables({ :domain => domain })
end

cookbook_file "/etc/php.ini" do
    mode "0755"
    owner "root"
    group "root"
    source "pim/php.ini"
end


