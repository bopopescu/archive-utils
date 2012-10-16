##
# Main nagios3 server recipe.
#
# @author   Steve Layton ( steve@lockerz.com )
# @copyright 2012 lockerz.com


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
end

## Nagios contacts config
cookbook_file "/etc/nagios3/conf.d/contacts/contacts_nagios2.cfg" do
        mode "0755"
        owner "root"
        group "root"
        source "contacts/contacts_nagios2.cfg"
end


## Nagios services config
cookbook_file "/etc/nagios3/conf.d/services/services.lockerz.com.cfg" do
        mode "0755"
        owner "root"
        group "root"
        source "services/services.lockerz.com.cfg"
end


## Nagios hostgroup config
cookbook_file "/etc/nagios3/conf.d/hostgroups/hostgroups.lockerz.com.cfg" do
        mode "0755"
        owner "root"
        group "root"
        source "hostgroups/hostgroups.lockerz.com.cfg"
end

## Custom/extra plugins
        ["check_http"].each do |pluginName|
                cookbook_file "/etc/nagios-plugins/config/%s" % pluginName do
                        mode "0555"
                        owner "root"
                        group "root"
                        source "commands/%s" % pluginName
                end
        end

