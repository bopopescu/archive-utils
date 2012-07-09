##
# Description: Pegasus
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

package "mysql" do
	#package_name "mysql-5.0.77-4.el5_6.6"
	action :remove
end

include_recipe "httpd::default"
#node.load_attribute_by_short_filename("pegasus", "httpd")

envName = node.chef_environment


## VHost
domain = (envName == "prod" ? "lockerz.com" : "%s.lockerz.us" % envName)
listenPort = (envName == "prod" ? 80 : 80)
template "/etc/httpd/conf.d/pegasus.lockerz.com.conf" do
	mode "0755"
	owner "apache"
	group "apache"
	source "pegasus/vhost.conf.erb"
	notifies :reload, resources(:service => "httpd")
	variables({
		:domain => domain,
		:listenPort => listenPort.to_i()
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
["s3cmd","git"].each do |packageName|
	package packageName do
		action :install
		package_name packageName
	end
end

package "php53-common" do
	action :remove
	package_name "php53-common"
end

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

## OAuth
cookbook_file "/usr/lib64/php/modules/oauth.so" do
	mode "0755"
	owner "root"
	group "root"
	source "php53/modules/oauth.so"
end

## Required for pegasus software
execute "install compass" do
	not_if "test -f /usr/local/bin/compass"
	action :run
	command "gem install compass"
end
link "/usr/bin/compass" do
	to "/usr/local/bin/compass"
end


cookbook_file "/root/.s3cfg" do
	mode "0600"
	owner "root"
	group "root"
	source "s3cmd"
end

#directory "/opt/splunk/etc/apps/search/local/" do
	#mode "0775"
	#owner "apache"
	#group "apache"
	#action :create
	#recursive true
#end

#cookbook_file "/opt/splunk/etc/apps/search/local/inputs.conf" do
	#mode "0744"
	#owner "root"
	#group "root"
	#source "pegasus/splunk/inputs.conf"
#end

## Required for github
cookbook_file "/root/.ssh/id_rsa" do
	mode "0600"
	owner "root"
	group "root"
	source "pegasus/github_id_rsa"
end

cookbook_file "/root/.ssh/config" do
	mode "0600"
	owner "root"
	group "root"
	source "pegasus/ssh_config"
end

## PHP ini 
#cookbook_file "/etc/php.ini" do
	#mode "0755"
	#owner "root"
	#group "root"
	#source "pegasus/php.ini"
#end

## Set the memcache fqdn for use with the php.ini file.
memcServer = "memc0.site.%s.lockerz.int" % node.chef_environment
## Override the value for production.
memcServer = "memc-scalr0.site.prod.lockerz.int" if(node.chef_environment == "prod")

template "/etc/php.ini" do
	mode "0755"
	owner "root"
	group "root"
	source "pegasus/php.ini.erb"
	variables({
		:memcServer => memcServer
	})
end

## Log container
directory "%s/pegasus/" % node[:fsLogRoot] do
	mode "0755"
	owner "apache"
	group "apache"
	action :create
	recursive true
end

isAdmin = node[:recipes].include?( "linux-base::admin" )

if(isAdmin == false)
## Watch the apache access log
lm_watcher do
	owner "apache"
	group "apache"
	postCmd "sudo /etc/init.d/httpd graceful"
	logName "apache_access_log"
	logDisplay "Apache Access Log"
	logFilename "%s/pegasus/access.log" % node[:fsLogRoot]
	rotationInterval 10
end

## Watch the application level log file
lm_watcher do
	owner "apache"
	group "apache"
	#postCmd "sudo /etc/init.d/httpd restart"
	logName "pegasus_application_log"
	logDisplay "Pegasus application log"
	logFilename "%s/pegasus/current/logs/%s.log" % [node[:fsDocRoot],envName]
	rotationInterval 15
end
end

## Splunk
node[:splunk] = { :monitors => {} } if(node[:splunk] == nil)
node[:splunk][:monitors]["%s/pegasus/access.log" % node[:fsLogRoot]] = ""
node[:splunk][:monitors]["%s/pegasus/error.log" % node[:fsLogRoot]] = ""
node[:splunk][:monitors]["%s/pegasus/current/logs/%s.log" % [node[:fsDocRoot],node.chef_environment]] = ""

execute "Prep container" do
	not_if "test -L /var/www/lockerz.com/pegasus/current"
	action :run
	command "rm -rf /var/www/lockerz.com/pegasus/current"
end
