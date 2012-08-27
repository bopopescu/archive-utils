##
# Description: Add2Any 
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

include_recipe "httpd::default"
envName = node.chef_environment

## VHost
domain = (envName == "prod" ? "lockerz.com" : "%s.lockerz.us" % envName)
listenPort = (envName == "prod" ? 80 : 80)

template "/etc/httpd/conf.d/add2any.lockerz.com.conf" do
	mode "0755"
	owner "apache"
	group "apache"
	source "add2any/vhost.conf.erb"
	notifies :reload, resources(:service => "httpd")
	variables({
		:domain => domain,
		:envName => envName,
		:fsDocRoot => "%s/add2any/current/" % node[:fsDocRoot],
		:fsLogRoot => "%s/add2any/" % node[:fsLogRoot],
		:listenPort => listenPort.to_i()
	})
end

## Document root
directory "%s/add2any" % node[:fsDocRoot] do
	mode "0755"
	owner "apache"
	group "apache"
	action :create
	recursive true
end

## Custom yum repo for php5.3 on centos 5.6
cookbook_file "/etc/yum.repos.d/ius.repo" do
	mode "0755"
	owner "root"
	group "root"
	source "php53/ius.repo"
end

cookbook_file "/etc/pki/rpm-gpg/IUS-COMMUNITY-GPG-KEY" do
	mode "0755"
	owner "root"
	group "root"
	source "php53/IUS-COMMUNITY-GPG-KEY"
end

## Packages
["git"].each do |packageName|
	package packageName do
		action :install
		package_name packageName
	end
end

package "php53-common" do
	action :remove
	package_name "php53-common"
end

## PHP packages
["php53u-pecl-memcache","php53u-pecl-apc","php53u-mcrypt","php53u","php53u-mbstring","php53u-common","php53u-xml"].each do |packageName|
	package packageName do
		action :install
		package_name packageName
	end
end

## Custom mongo lib
cookbook_file "/usr/lib64/php/modules/mongo.so" do
	mode "0755"
	owner "root"
	group "root"
	source "php53/modules/mongo.so"
end

## Required for github
cookbook_file "/root/.ssh/id_rsa" do
	mode "0600"
	owner "root"
	group "root"
	source "add2any/github.rsa"
end

cookbook_file "/root/.ssh/config" do
	mode "0600"
	owner "root"
	group "root"
	source "add2any/ssh_config"
end

## PHP ini 
cookbook_file "/etc/php.ini" do
	mode "0755"
	owner "root"
	group "root"
	source "add2any/php.ini"
end

## Log container
directory "%s/add2any/" % node[:fsLogRoot] do
	mode "0755"
	owner "apache"
	group "apache"
	action :create
	recursive true
end

## Watch the apache access log
lm_watcher do
	owner "apache"
	group "apache"
	postCmd "sudo /etc/init.d/httpd graceful"
	logName "add2any_apache_access_log"
	logDisplay "Add2Any Apache Access Log"
	logFilename "%s/add2any/access.log" % node[:fsLogRoot]
	rotationInterval 10
end

## Splunk
node[:splunk] = { :monitors => {} } if(node[:splunk] == nil)
node[:splunk][:monitors]["%s/add2any/access.log" % node[:fsLogRoot]] = ""
node[:splunk][:monitors]["%s/add2any/error.log" % node[:fsLogRoot]] = ""

