##
# Default apache configuration
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

## Package
package "httpd" do
	action :install
	package_name "httpd"
end

## Ensure the default directory is removed so we can link it later.
directory "/var/log/httpd" do
	not_if "readlink /var/log/httpd"
	action :delete
	recursive true
end

## Service control
service "httpd" do
	action [ :enable, :start ]
	supports :restart => true, :reload => true
	ignore_failure true
end

## Legacy hack
cookbook_file "/etc/httpd/conf.d/ptzplace.lockerz.com.conf" do
	action :delete
end

## SSL Setup
package "mod_ssl"

directory "/etc/httpd/ssl" do
    mode "0644"
    owner "root"
    group "root"
    action :create
    recursive true
end

cookbook_file "/etc/httpd/ssl/server.crt" do
    mode "0644"
    owner "root"
    group "root"
    source "ssl/server.crt"
end

cookbook_file "/etc/httpd/ssl/server.key" do
    mode "0644"
    owner "root"
    group "root"
    source "ssl/server.key"
end

## Logging
directory "/mnt/local/lockerz.com/logs/httpd" do
	mode "0775"
	owner "apache"
	group "apache"
	action :create
	recursive true
end

execute "chown" do
	command "chown apache:apache /mnt/local/lockerz.com/logs/httpd"
end

link "/var/log/httpd" do
    to "/mnt/local/lockerz.com/logs/httpd"
end

## PHP config
cookbook_file "/etc/php.ini" do
    mode "0755"
    owner "root"
    group "root"
    source "php.ini"
end

## Main httpd config
template "/etc/httpd/conf/httpd.conf" do
    mode "0755"
    owner "apache"
    group "apache"
    notifies :restart, resources(:service => "httpd")
    source "httpd.conf.erb"
    variables({ 
                :node => node
        })
end

cookbook_file "/etc/httpd/conf.d/php.conf" do
    mode "0755"
    owner "apache"
    group "apache"
    source "httpd.php.conf"
    notifies :restart, resources(:service => "httpd")
end

## Web space
directory "/var/www/lockerz.com/" do 
    owner "apache"
    group "apache"
    mode "0775"
    action :create
    recursive true
end

