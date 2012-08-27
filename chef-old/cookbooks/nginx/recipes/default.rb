##
# Default recipe for nginx services
#
# @TODO:	IPTables state save and restore
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

# Package install
package "nginx"

# Service setup
service "nginx" do
	action [ :enable,:start ]
	supports :restart => true, :reload => true
	ignore_failure true
end

group "nginx" do
end

user "nginx" do
	shell "/bin/false"
	group "nginx"
	system true
	comment "nginx"
end

package "iptables"

## Remove the default directory so we can link it later on.
directory "/var/log/nginx" do
	not_if "readlink /var/log/nginx"
	action :delete
	recursive true
end

# Directories
["sites-enabled","sites-available","upstreams-enabled","upstreams-available"].each do |dirName|
	directory "/etc/nginx/%s" % dirName do
		mode "0755"
		owner "root"
		group "root"
		action :create
		recursive true
	end
end

## SSL
directory "/etc/nginx/ssl" do
	owner "root"
	group "root"
	mode "0755"
	action :create
	recursive true
end

["server","lockerz"].each do |keyName|
	cookbook_file "/etc/nginx/ssl/%s.crt" % keyName do
		mode "0744"
		owner "root"
		group "root"
		source "ssl/%s.crt" % keyName
		notifies :restart, resources(:service => "nginx")
	end

	cookbook_file "/etc/nginx/ssl/%s.key" % keyName do
		mode "0744"
		owner "root"
		group "root"
		source "ssl/%s.key" % keyName
		notifies :restart, resources(:service => "nginx")
	end
end

## Logging
cookbook_file "/etc/logrotate.conf" do
	mode "0744"
	owner "root"
	group "root"
	source "logrotate.conf"
end

## Default log rotation setup for nginx
cookbook_file "/etc/logrotate.d/nginx" do
	source "nginx.logrotate.conf"
	mode "0744"
	owner "root"
	group "root"
end

## Create logging container
directory "/mnt/local/lockerz.com/logs/nginx/" do
	mode "0755"
	owner "apache"
	group "apache"
	action :create
	recursive true
end

## Link
link "/var/log/nginx" do
	to "/mnt/local/lockerz.com/logs/nginx"
end

## These files are presented when `knife data bag edit ENV_NAME site` site+static_failover = true
remote_directory "/var/www/lockerz.com/outage/" do
	mode "0755"
	owner "apache"
	group "apache"
	source "lockerz.com/outage"
end 

## Error pages for any 404/500 page errors generated from the upstream servers
remote_directory "/var/www/lockerz.com/errors/" do
	mode "0755"
	owner "apache"
	group "apache"
	source "lockerz.com/errors"
end 

## Main nginx config
cookbook_file "/etc/nginx/nginx.conf" do
	mode "0755"
	owner "root"
	group "root"
	source "lockerz.com/nginx.conf"
	notifies :reload , resources(:service => "nginx")
end

