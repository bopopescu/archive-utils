#
# Cookbook Name:: mongodb
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

user "mongod" do
	shell "/bin/false"
	system true
	comment "mongodb user"
end

cookbook_file "/etc/yum.repos.d/10gen.repo" do
	source "10gen.repo"
	owner "root"
	group "root"
	mode "0755"
end

execute "update" do
	action :run
	not_if File.exists?( "/usr/bin/mongo" ).to_s() 
	command "yum -y update"
end

package "mongo-server" do
	action :install
	package_name "mongo-10gen-server"
end

service "mongod" do
	action [ :enable, :start ]
	supports :restart => true, :reload => true
	ignore_failure true
end

directory "/etc/mongo/" do
	mode "0755"
	owner "mongod"
	group "mongod"
	recursive true
end

cookbook_file "/etc/logrotate.d/mongodb" do
	mode "0744"
	owner "root"
	group "root"
	source "mongodb.logrotate.conf"
end

## Logging dir
directory "/mnt/local/lockerz.com/logs/mongodb" do
	mode "0775"
	owner "mongod"
	group "mongod"
	recursive true
end

## Data dir
directory "/mnt/ebs/lockerz.com/data/mongodb/" do
	mode "0755"
	owner "mongod"
	group "mongod"
	recursive true
end

