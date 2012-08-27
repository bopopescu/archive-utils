##
# Description:
# 	Apache-specific configuration for commerce webfe systems
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

include_recipe "httpd::default"

envName = node.chef_environment
domain = (envName == "prod" ? "lockerz.com" : "%s.lockerz.us" % envName)

## Remove these first
package "php53-common" do
	action :remove
	package_name "php53-common"
end
package "MySQL-server" do
	action :remove
end

cookbook_file "/etc/httpd/conf.d/ssl.conf" do
	action :delete
end

## VHost
template "/etc/httpd/conf.d/commerce.conf" do
	mode "0755"
	owner "apache"
	group "apache"
	source "commerce/vhost.conf.erb"
	variables({ 
		:node => node,
		:domain => domain 
	})
end

## Document root
directory "%s/commerce" % node[:fsDocRoot] do
    mode "0755"
    owner "apache"
    group "apache"
    action :create
    recursive true
end

## Custom repo so we can pull in php-5.2
cookbook_file "/etc/yum.repos.d/CentOS-Testing.repo" do
	mode "0755"
	owner "root"
	group "root"
	source "CentOS-Testing.repo"
end

## Don't update if the correct version of php has already been installed
execute "update" do
	action :run
	not_if (`php -v|grep built|awk '{print $2}'`.chomp == "5.2.10" ? "true" : "false")
	command "yum -y update"
end

## Packages
["GeoIP-devel","php-mysql","php-pdo","ice","ice-php","php-pear","php-mhash","php-bcmath","php-mcrypt","php-mbstring","php-gd"].each do |packageName|
	package packageName do
		action :install
		package_name packageName
	end
end

## Load custom modules
["IcePHP.so","apc.so","memcache.so","pdo.so","pdo_mysql.so","syck.so"].each do |modFile|
	cookbook_file "/usr/lib64/php/modules/%s" % modFile do
		mode "0755"
		owner "root"
		group "root"
		source "php52/%s" % modFile
	end
end

## Requires a special geoip module.
cookbook_file "/usr/lib64/php/modules/geoip.so" do
	mode "0755"
	owner "apache"
	group "apache"
	source "php/modules/geoip.so"
end

## PHP config
cookbook_file "/etc/php.ini" do
	mode "0755"
	owner "root"
	group "root"
	source "commerce/php.ini"
end

## Ice configuration which will point to the commerce phoenix.ice file
cookbook_file "/etc/php.d/ice.ini" do
	mode "0755"
	owner "root"
	group "root"
	source "commerce/ice.ini"
end

## Asset container
directory "%s/commerce/media/" % node[:fsAssetRoot] do
	mode "0755"
	owner "apache"
	group "apache"
	action :create
	recursive true
end

## Log container for apache logs
directory "%s/commerce/" % node[:fsLogRoot] do
	mode "0755"
	owner "apache"
	group "apache"
	action :create
	recursive true
end

## Log container for magento crash reports
directory "%s/commerce/reports" % node[:fsLogRoot] do
	mode "0755"
	owner "apache"
	group "apache"
	action :create
	recursive true
end

## Cache container
directory "%s/commerce/" % node[:fsCacheRoot] do
	mode "0755"
	owner "apache"
	group "apache"
	action :create
	recursive true
end

## Log container for core logging
directory "%s/commerce/core" % node[:fsLogRoot] do
	mode "0755"
	owner "apache"
	group "apache"
	action :create
	recursive true
end

## Link CORE
#link "%s/commerce/core" % node[:fsLogRoot] do
	#to "%s/commerce/current/magento/app/code/local/Lockerz/lib/CORE/tmp" % node[:fsDocRoot] 
#end

## Watch the apache log
lm_watcher do
	owner "apache"
	group "apache"
	postCmd "sudo /etc/init.d/httpd graceful"
	logName "commerce_apache_access_log"
	logDisplay "Commerce Apache Access Log"
	logFilename "%s/commerce/access.log" % node[:fsLogRoot]
	rotationInterval 20
end

## Watch the core CLICKSTREAM log
# There is no CLICKSTREAM log for commerce...yet
#lm_watcher do
	#owner "apache"
	#group "apache"
	#postCmd "sudo /etc/init.d/httpd restart"
	#postCmd ""
	#logName "commerce_clickstream_log"
	#logDisplay "Commerce Clickstream Log"
	#logFilename "%s/commerce/core/CLICKSTREAM.log" % node[:fsLogRoot]
	#rotationInterval 25
#end



## Fix for the media image issue ( https://lockerz.jira.com/browse/OPZ-756 )
# Hardcoding the admin ip for now until we can move it over to chef and use a search.
commAdminIp = "10.211.114.191"
commAdminFSTarget = "/opt/workspace/COMMERCE/magento/media/"
node[:fsMediaRoot] = "%s/commerce/media" % node[:fsAssetRoot]
cron "pull_media_images" do
	hour "*"
	user "root"
	minute "*/5"
	command "rsync --exclude=.svn --exclude=lost+found -qave 'ssh -o StrictHostKeyChecking=no -i /root/admin_key.pem -l app-servers' %s:%s %s" % [
		commAdminIp,
		commAdminFSTarget,
		node[:fsMediaRoot]
	]
end

cookbook_file "/root/admin_key.pem" % node[:fsDocRoot] do
	mode "0600"
	owner "root"
	group "root"
	source "commerce/admin_key.pem"
end



## Splunk
node[:splunk] = { :monitors => [] } if(node[:splunk] == nil)
node[:splunk][:monitors]["%s/commerce/access.log" % node[:fsLogRoot]] = "access_lockerz"
node[:splunk][:monitors]["%s/commerce/error.log" % node[:fsLogRoot]] = ""
node[:splunk][:monitors]["%s/commerce/minify.log" % node[:fsLogRoot]] = ""
node[:splunk][:monitors]["%s/commerce/system.log" % node[:fsLogRoot]] = "commerce-system-log"
node[:splunk][:monitors]["%s/commerce/core/ERROR.log" % node[:fsLogRoot]] = ""
node[:splunk][:monitors]["%s/commerce/core/CLICKSTREAM.log" % node[:fsLogRoot]] = "lockerz-clickstream"

