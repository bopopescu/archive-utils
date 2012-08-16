##
# Nagios hostgroup
#
# Usage:
#	Monitor an apache log file:
#
#	nagios_hostgroup :hostgroupAlias do
#	end
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com
define :nagios_hostgroup, :name => :name do
	params[:alias] = params.delete( :name )
	params[:hostgroup_name] = params[:alias]

	params.each do |key,val|
		params[key] = 1 if(val.class == TrueClass)
		params[key] = 0 if(val.class == FalseClass)
	end

	#puts "Class: %s" % params[:members].class

    template "%s/hostgroups/%s.cfg" % [node[:nagios]["config_dir"],params[:alias]] do
        mode "0755"
        owner node[:nagios]["user"]
        group node[:nagios]["group"]
        source "hostgroup.erb"
        variables({
            :params => params
        })
    end
end
