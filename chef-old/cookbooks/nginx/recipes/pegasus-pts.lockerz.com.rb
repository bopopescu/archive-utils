##
# Pegasus Pixel Tracking Service.
#	pegasus-pts.lockerz.com 
#
# @author	Bryan Kroger ( bryan@lockerz.com )
#
# Copyright 2011, lockerz.com
# All rights reserved - Do Not Redistribute
include_recipe "nginx::default"

envName = node.chef_environment

fsLogRoot = "/mnt/local/lockerz.com/logs/nginx/"

cookbook_file "/etc/nginx/nginx.conf" do
	mode "0755"
	owner "root"
	group "root"
	source "pts.lockerz.com/nginx.conf"
	notifies :reload , resources(:service => "nginx")
end

directory "%s/pegasus-pts" % fsLogRoot do
	mode "0755"
	owner "nginx"
	group "nginx"
	action :create
	recursive true
end

directory "/var/www/lockerz.com/pts" do
	mode "0755"
	owner "nginx"
	group "nginx"
	action :create
	recursive true
end

cookbook_file "/var/www/lockerz.com/pts/1x1.gif" do
	mode "0755"
	owner "nginx"
	group "nginx"
	source "pts.lockerz.com/1x1.gif"
end

cookbook_file "/var/www/lockerz.com/pts/index.html" do
	mode "0755"
	owner "nginx"
	group "nginx"
	source "pts.lockerz.com/index.html"
end

template "/etc/nginx/sites-available/pegasus-pts.lockerz.com" do
    mode "0755"
    owner "root"
    group "root"
    source "pegasus-pts.lockerz.com/vhost.erb"
    notifies :reload , resources(:service => "nginx")
    variables({
        :ssl => false,
        :envName => envName,
        :fsLogRoot => fsLogRoot,
        :serverName => (envName == "prod" ? "lockerz.com" : "%s.lockerz.us" % envName),
        :staticFailover => false
    })
end

link "/etc/nginx/sites-enabled/pegasus-pts.lockerz.com" do
	to "/etc/nginx/sites-available/pegasus-pts.lockerz.com"
end

## Watch the application level log file
if envName == "prod" then
lm_watcher do
	owner "nginx"
	group "nginx"
	postCmd "sudo kill -USR1 `cat /var/run/nginx.pid`"
	logName "pts_pegasus"
	logDisplay "Pegasus Pixel Tracking Service"
	logFilename "%s/pegasus-pts/access.log" % [fsLogRoot]
	targetNodeFQDN "dw-logs0.dba.prod.lockerz.int"
	rotationInterval 15
end
end

