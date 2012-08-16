##
# Virtual IP using an FQDN
#
# Usage:
#	Create a fqdn that points to one or more nodes.
#
#	vip :fqdn do
#		members search( :node,"*:*" )
#	end
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com
define :vip, :name => :name do
	template "%s/services/%s.cfg" % [node[:nagios]["config_dir"],params[:name]] do
		mode "0755"
		owner node[:nagios]["user"]
		group node[:nagios]["group"]
		source "service.erb"
		variables({
			:params => params
		})
	end
end
