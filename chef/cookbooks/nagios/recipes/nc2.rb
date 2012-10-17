# Client recipe
# This recipe installs and configures nrpe on a locekrz client server
# copied from platz-system.rb recipes written by Bernard Gardner (Spry)

## Config dirs
directory "/var/log/nagios" % dir do
        mode 0777
        owner "nagios"
        group "nagios"
        action :create
end


if(node[:platform] == "ubuntu")

	package "nagios-nrpe-server"

	service "nagios-nrpe-server" do
		action [ :enable, :start ]
		supports :restart => true, :reload => true
		ignore_failure true
	end

	cookbook_file "/etc/nagios/nrpe.cfg" do
		mode "0444"
		owner "root"
		group "root"
		source "platz/nrpe.cfg"
		notifies :restart, resources(:service => "nagios-nrpe-server")
	end


	cookbook_file  "/etc/nagios/nrpe.d/system.cfg" do
		mode "0444"
		owner "root"
		group "root"
		source "system.cfg"
		notifies :restart, resources(:service => "nagios-nrpe-server")
	end


	## Role based template
	node.tags.each do |tagItem|

		serviceName = nil
		serviceName = "memcache" if(tagItem.match( /memcache/ ))

		if(serviceName != nil)
			template "/etc/nagios/nrpe.d/%s.cfg" % serviceName do
				mode "0444"
				owner "root"
 				group "root"
				source "nrpe.d/%s.cfg.erb" % serviceName
				notifies :restart, resources(:service => "nagios-nrpe-server")
			end
		end
	end


	#servers=[]
	#search(:node, "nagios\\:\\:server") {|n| servers << n["ipaddress"] }
	# not sure why this doesn't work...
	servers=['10.96.191.114']

	template "/etc/nagios/nrpe_local.cfg" do
		mode "0444"
		owner "root"
		group "root"
		source "platz/nrpe_local.cfg.erb"
		variables({:nagios_server => servers.join(",") }) 
		notifies :restart, resources(:service => "nagios-nrpe-server")
	end


	## Custom/extra plugins
	["check_cpu","check_memory","check_postfix_mailqueue"].each do |pluginName|
		cookbook_file "/usr/lib/nagios/plugins/%s" % pluginName do
			mode "0555"
			owner "root"
			group "root"
			source "plugins/%s" % pluginName
		end
	end
end


if(node[:platform] == "centos")

	##
	# Client nagios nrpe.
	#
	# @author   Bryan Kroger ( bryan@lockerz.com )
	# @copyright 2011 lockerz.com


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
		serviceName = "system" if(runListItem.name == "Lockerz_base" ) 
		serviceName = "vodpod" if(runListItem.name.match( /VodpodService/ )) 
		serviceName = "jasper" if(runListItem.name.match( /Jasper/ )) 
		serviceName = "vertica" if(runListItem.name.match( /Vertica/ )) 
		serviceName = "phoenix" if(runListItem.name.match( /Phoenix/ ))
		serviceName = "memcache" if(runListItem.name.match( /Memcache/ )) 
		serviceName = "memcache" if(runListItem.name.match( /MemcacheServer/ )) 
		serviceName = "targo" if(runListItem.name.match( /Targo/ ))
	
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
end
