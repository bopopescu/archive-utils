##
# Serenity
# @author	Bryan Kroger ( bryan@lockerz.com )
#
# Copyright 2011, lockerz.com
#
# All rights reserved - Do Not Redistribute
##
include_recipe "nginx"

## Pull stack/env/role information from user data store
begin
	res = `curl -s http://169.254.169.254/2011-01-01/user-data/`
	jsonUserData = JSON.parse( res )

	envName = jsonUserData["envName"] 
	envNameSym = ("%s00" % jsonUserData["envName"]).to_sym()

	roleName = jsonUserData["roleName"]
	stackName = jsonUserData["stackName"]

rescue => e
	puts "Fatal: unable to pull user data!"
	exit

end



## SOP
directory "/etc/nginx/sites-enabled" do
	owner "root"
	group "root"
	mode "0755"
	action :create
	recursive true
end

directory "/etc/nginx/ssl" do
	owner "root"
	group "root"
	mode "0755"
	action :create
	recursive true
end

directory "/etc/nginx/sites-available" do
	owner "root"
	group "root"
	mode "0755"
	action :create
	recursive true
end

directory "/etc/nginx/upstreams-available" do
	owner "root"
	group "root"
	mode "0755"
	action :create
	recursive true
end

directory "/etc/nginx/upstreams-enabled" do
	owner "root"
	group "root"
	mode "0755"
	action :create
	recursive true
end

cookbook_file "/etc/nginx/ssl/server.crt" do
	source "ssl/server.crt"
	mode "0744"
	owner "root"
	group "root"
	notifies :restart, resources(:service => "nginx")
end

cookbook_file "/etc/nginx/ssl/server.key" do
	source "ssl/server.key"
	mode "0744"
	owner "root"
	group "root"
	notifies :restart, resources(:service => "nginx")
end

## Logging
cookbook_file "/etc/logrotate.conf" do
	source "logrotate.conf"
	mode "0744"
	owner "root"
	group "root"
end

directory "/mnt/local/lockerz.com/logs/nginx/" do
	owner "apache"
	group "apache"
	mode "0755"
	action :create
	recursive true
end



## Prod config
template "/etc/nginx/sites-available/serenity.conf" do
	source "serenity/site.erb"
	mode "0755"
	owner "root"
	group "root"
	notifies :reload , resources(:service => "nginx")
	variables({ })
end

cookbook_file "/etc/nginx/nginx.conf" do
	source "serenity/nginx.conf"
	mode "0755"
	owner "root"
	group "root"
	notifies :reload , resources(:service => "nginx")
end



## Prod upstreams
link "/etc/nginx/sites-enabled/serenity.conf" do
	to "/etc/nginx/sites-available/serenity.conf"
	link_type :symbolic
end


