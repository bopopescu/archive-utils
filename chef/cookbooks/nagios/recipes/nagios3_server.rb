##
# Main nagios3 server recipe.
#
# @author   Steve Layton ( steve@lockerz.com )
# @copyright 2012 lockerz.com

service "nagios3" do
        action [ :enable, :start ]
        supports :restart => true, :reload => true
        ignore_failure true
end

## This is where we use chef to build out the configuration files nagios will use for alerting.

## Config dirs
["contacts","hosts","hostgroups","services"].each do |dir|
	directory "/etc/nagios3/conf.d/%s" % dir do
		mode 0755
		owner "root"
		group "root"
		action :create
        end
end

## Create a host file 
hosts = []
search(:node, "*:*") {|n| hosts << n }

template "/etc/nagios3/conf.d/hosts/hosts.lockerz.com.cfg" do
  mode 0755
  owner "root"
  group "root"
  source "hosts.cfg.erb"
  variables({
        :hosts => hosts
  })
  notifies :restart, resources(:service => "nagios3")
end

## Nagios contacts config
cookbook_file "/etc/nagios3/conf.d/contacts/contacts_nagios2.cfg" do
        mode "0755"
        owner "root"
        group "root"
        source "contacts/contacts_nagios2.cfg"
        notifies :restart, resources(:service => "nagios3")
end


## Nagios services config
cookbook_file "/etc/nagios3/conf.d/services/services.lockerz.com.cfg" do
        mode "0755"
        owner "root"
        group "root"
        source "services/services.lockerz.com.cfg"
        notifies :restart, resources(:service => "nagios3")
end

## Nagios services config
cookbook_file "/etc/nagios3/conf.d/services/platz-service_nagios2.cfg" do
        mode "0755"
        owner "root"
        group "root"
        source "services/platz-service_nagios2.cfg"
        notifies :restart, resources(:service => "nagios3")
end


## Nagios hostgroup config
cookbook_file "/etc/nagios3/conf.d/hostgroups/hostgroups.lockerz.com.cfg" do
        mode "0755"
        owner "root"
        group "root"
        source "hostgroups/hostgroups.lockerz.com.cfg"
        notifies :restart, resources(:service => "nagios3")
end

## Custom/extra plugins
        ["http","vertica"].each do |pluginName|
                cookbook_file "/etc/nagios-plugins/config/%s.cfg" % pluginName do
                        mode "0555"
                        owner "root"
                        group "root"
                        source "commands/%s.cfg" % pluginName
                end
        end

