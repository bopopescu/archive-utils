##
# Nagios http server
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

## Packages
package "mod_ssl"

# httpd config
cookbook_file "/etc/httpd/conf/httpd.conf" do
	source "server/httpd.conf"
	owner "apache"
	group "apache"
	mode "0775"
end

cookbook_file "/etc/httpd/conf.d/nagios.conf" do
	source "server/vhost.conf"
	owner "apache"
	group "apache"
	mode "0775"
end

directory "/etc/httpd/ssl" do
    mode "0644"
    owner "root"
    group "root"
    action :create
    recursive true
end

cookbook_file "/etc/httpd/ssl/server.crt" do
    source "ssl/server.crt"
    mode "0644"
    owner "root"
    group "root"
end

cookbook_file "/etc/httpd/ssl/server.key" do
    mode "0644"
    owner "root"
    group "root"
    source "ssl/server.key"
end

directory "/mnt/local/lockerz.com/logs/httpd" do
	owner "apache"
	group "apache"
	mode "0775"
	action :create
	recursive true
end
