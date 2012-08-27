##
# Description: ldapadmin.lockerz.us 
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

include_recipe "httpd::default"

package "phpldapadmin" do
	package_name "phpldapadmin"
	action :install
end

## Override the default
cookbook_file "/etc/httpd/conf/httpd.conf" do
	mode "0755"
	owner "root"
	group "root"
	source "ldapadmin/httpd.conf"
	notifies :restart, resources(:service => "httpd")
end

## VHost
cookbook_file "/etc/httpd/conf.d/ldapadmin.lockerz.us.conf" do
	mode "0755"
	owner "root"
	group "root"
	source "ldapadmin/ldapadmin.lockerz.us.conf"
	notifies :restart, resources(:service => "httpd")
end

cookbook_file "/etc/php.ini" do
	mode "0744"
	owner "root"
	group "root"
	source "ldapadmin/php.ini"
end

cookbook_file "/etc/logrotate.d/httpd" do
	mode "0744"
	owner "root"
	group "root"
	source "logrotate.conf"
end

directory "/mnt/local/lockerz.com/logs/httpd" do
	mode "0775"
	owner "apache"
	group "apache"
	action :create
	recursive true
end
