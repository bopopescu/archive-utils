# Client recipe
# This recipe installs and configures nrpe on a locekrz client server
# copied from platz-system.rb recipes written by Bernard Gardner (Spry)

if(node[:platform] != "ubuntu")
	raise "Currently the nagios::nagios-client.rb recipe only works on ubuntu systems"
end

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

cookbook_file  "/etc/nagios/nrpe.d/platz.cfg" do
	mode "0444"
	owner "root"
	group "root"
	source "platz/platz.cfg"
	notifies :restart, resources(:service => "nagios-nrpe-server")
end

template "/etc/nagios/nrpe.d/platz-db.cfg" do
	mode "0444"
	owner "root"
	group "root"
	source "platz/platz-db.cfg.erb"
	variables({:database_type => (node[:tags].include?("db-master")?(:db_master):(node[:tags].include?("db-slave")?(:db_slave):false)) })
	only_if { node[:tags].include?("db-master") or node[:tags].include?("db-slave") }
	notifies :restart, resources(:service => "nagios-nrpe-server")
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

