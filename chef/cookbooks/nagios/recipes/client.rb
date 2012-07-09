##
# Client nagios nrpe.
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com
include_recipe "nagios::default"

## Packages
if(node[:platform] == "ubuntu")
	group "crontab"

	group "munin"
	user "munin" do
		group "munin"
	end


	#group "rails"
	#user "rails" do
		#group "rails"
	#end

	#group "www-data"
	#user "www-data" do
		#group "www-data"
	#end

	group "ssl-cert"
	user "ssl-cert" do
		group "ssl-cert"
	end

	package "nagios-nrpe-server"
else
	package "nrpe" do
		action :install
	end
	package "nagios-plugins" do
		action :install
	end

end

## Config
directory "/etc/nrpe.d" do
	mode "0755"
	owner "nrpe"
	group "ops"
	recursive true
end

cookbook_file "/etc/nagios/nrpe.cfg" do
	mode "0755"
	owner "root"
	group "root"
	source "client/nrpe.cfg"
end

## Custom/extra plugins
["check_procs","check_mysql_health","check_cpu","check_memory"].each do |pluginName|
	cookbook_file "/usr/lib64/nagios/plugins/%s" % pluginName do
		mode "0755"
		owner "nrpe"
		group "ops"
		source "plugins/%s" % pluginName
	end
end

if(node[:platform] == "ubuntu")
    cookbook_file "/usr/lib/nagios/plugins/check_procs" do
        mode "0755"
        owner "root"
        group "root"
        source "plugins.ubuntu/check_procs"
    end
end

## Service config
service "nrpe" do
	action [ :enable, :start ]
	supports :restart => true, :reload => true
	ignore_failure true
end

## Role based template
node.run_list.each do |runListItem|

	serviceName = nil
	serviceName = "solr" if(runListItem.name.match( /Solr/ )) 
	serviceName = "chef" if(runListItem.name.match( /Chef/ )) 
	serviceName = "mysql" if(runListItem.name.match( /MySQL/ )) 
	serviceName = "openmq" if(runListItem.name == "OpenMQServer" ) 
	serviceName = "system" if(runListItem.name == "system" ) 
	serviceName = "vodpod" if(runListItem.name.match( /VodpodService/ )) 
	serviceName = "jasper" if(runListItem.name.match( /Jasper/ )) 
	serviceName = "vertica" if(runListItem.name.match( /Vertica/ )) 
	serviceName = "phoenix" if(runListItem.name.match( /Phoenix/ ))
	serviceName = "memcache" if(runListItem.name.match( /Memcache/ )) 
	serviceName = "memcache" if(runListItem.name.match( /MemcacheServer/ )) 
	serviceName = "targo" if(runListItem.name.match( /Targo/ ))
	## serviceName = "mailserver" if(runListItem.name.match( /Mail/ ))
	#serviceName = "mailserver" if(search(:node, 'recipes:smtp\:\:relay_server')) 

	## Not every role will have a template associated with it.
	if(serviceName != nil)
		template "/etc/nrpe.d/%s.cfg" % serviceName do
			mode "0755"
			owner "nrpe"
			group "ops"
			source "nrpe.d/%s.cfg.erb" % serviceName
			notifies :restart, resources(:service => "nrpe")
		end
	end

end

