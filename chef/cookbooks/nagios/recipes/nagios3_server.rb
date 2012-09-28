##
# Main nagios3 server recipe.
#
# @author   Steve Layton ( steve@lockerz.com )
# @copyright 2012 lockerz.com


## This is where we use chef to build out the configuration files nagios will use for alerting.
## Create a host file for each environment

## Config dirs
["hosts"].each do |dir|
	directory "/etc/nagios3/conf.d/%s" % dir do
		mode 0755
		owner "root"
		group "root"
		action :create
        end
end

hosts = []
search(:node, "*:*") {|n| hosts << n }

template "/etc/nagios3/conf.d/hosts/systems.cfg" do
  mode 0755
  owner "root"
  group "root"
  source "hosts.cfg.erb"
  variables({
        :hosts => hosts
  })
end

