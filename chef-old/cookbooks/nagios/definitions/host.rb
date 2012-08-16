##
# Nagios host
#
# Usage:
#	Create a nagios host def.
#
#	nagios_host :hostname do
#	end
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com
define :nagios_host do

	if(params[:use_nagios_host] != nil)
		params[:use] = params.delete( :use_nagios_host )
	end

	params[:host_name] = params[:name]
	#puts "HostName: [%s]" % params.inspect

	params.each do |key,val|
		params[key] = 1 if(val.class == TrueClass)
		params[key] = 0 if(val.class == FalseClass)
	end

    template "%s/hosts/%s.cfg" % [node[:nagios]["config_dir"],params[:host_name]] do
        mode "0755"
        owner node[:nagios]["user"]
        group node[:nagios]["group"]
        source "host.erb"
        variables({
            :params => params
        })
    end
end
