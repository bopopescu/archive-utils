##
# Description:
# 	Apache-specific configuration for site webfe systems
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

include_recipe "httpd::default"

envName = node.chef_environment

## VHost
domain = (envName == "production" ? "lockerz.com" : "%s.lockerz.us" % envName)
template "/etc/httpd/conf.d/site.conf" do
	mode "0755"
	owner "apache"
	group "apache"
	source "site/vhost.conf.erb"
	variables({
		:domain => domain,
		:logRoot => "%s/site/" % node[:fsLogRoot],
		:envName => envName,
		:documentRoot => "%s/site/current/public" % node[:fsDocRoot],
		:vShopDocumentRoot => "%s/vshop/current/public" % node[:fsDocRoot]	
	})
end

## Document root
directory "%s/site" % node[:fsDocRoot] do
	mode "0755"
	owner "apache"
	group "apache"
	action :create
	recursive true
end

## Custom yum repo file.
cookbook_file "/etc/yum.repos.d/CentOS-Testing.repo" do
	mode "0755"
	owner "root"
	group "root"
	source "CentOS-Testing.repo"
end

## Cache and temp storage for the application
["cache","compile","compile/site","compile/mobile"].each do |containerName|
	directory "%s/site/%s" % [node[:fsCacheRoot],containerName] do
		mode "0755"
		owner "apache"
		group "apache"
		action :create
		recursive true
	end
end

## Ensure that these packages are removed
package "php53" do
	action :remove
end
package "php53-common" do
	action :remove
end

## Ensure these packages are installed
["libmcrypt", "GeoIP", "zlib-devel", "ice", "ice-php"].each do |packageName|
	package packageName do
		action :install
		package_name packageName
	end
end

["php-common", "php-pear","php-gd","php-mbstring" ].each do |packageName|
	package packageName do
		action :install
		package_name packageName
	end
end

## Modules
# Site requires some special love in the form of custom modules.
# I built these modules by installing the *-devel packages on a given webfe node
#	then using pecl install blah to install the packages and give me the module
["geoip","mcrypt","memcache","syck","apc"].each do |moduleName|
	cookbook_file "/usr/lib64/php/modules/%s.so" % moduleName do
		mode "0755"
		owner "root"
		group "root"
		source "php/modules/%s.so" % moduleName
	end
end

cookbook_file "/usr/lib64/php/modules/IcePHP.so" do
	mode "0755"
	owner "root"
	group "root"
	source "ice-3.2.1/IcePHP.so"
end

## PHP config
cookbook_file "/etc/php.ini" do
	mode "0755"
	owner "root"
	group "root"
	source "site/php.ini"
end

cookbook_file "/etc/php.d/ice.ini" do
	mode "0755"
	owner "root"
	group "root"
	source "ice331/ice.ini"
end

## Log container
directory "%s/site/" % node[:fsLogRoot] do
	mode "0755"
	owner "apache"
	group "apache"
	action :create
	recursive true
end

## Link CORE
link "%s/site/core" % node[:fsLogRoot] do
	to "%s/site/current/application/libraries/vendor/core/tmp" % node[:fsDocRoot]
end

## Log rotation.
#cookbook_file "/etc/logrotate.d/httpd" do
	#source "site/logrotate.conf"
	#owner "root"
	#group "root"
	#mode "0755"
#end

## Watch the apache log
lm_watcher do
	owner "apache"
	group "apache"
	postCmd "sudo /etc/init.d/httpd graceful"
	logName "site_apache_access_log"
	logDisplay "Site Apache Access Log"
	logFilename "%s/site/access.log" % node[:fsLogRoot]
	rotationInterval 10
end

## Watch the CORE CLICKSTREAM log
lm_watcher do
	owner "apache"
	group "apache"
	#postCmd "sudo /etc/init.d/httpd restart"
	postCmd ""
	logName "site_clickstream_log"
	logDisplay "Site Clickstream Log"
	logFilename "%s/site/core/CLICKSTREAM.log" % node[:fsLogRoot]
	rotationInterval 15
end

## Splunk
node[:splunk] = { :monitors => {} } if(node[:splunk] == nil)
node[:splunk][:monitors]["%s/site/error.log" % node[:fsLogRoot]] = ""
node[:splunk][:monitors]["%s/site/access.log" % node[:fsLogRoot]] = ""
node[:splunk][:monitors]["%s/site/core/ERROR.log" % node[:fsLogRoot]] = ""
node[:splunk][:monitors]["%s/site/core/CLICKSTREAM.log" % node[:fsLogRoot]] = "lockerz-clickstream"

