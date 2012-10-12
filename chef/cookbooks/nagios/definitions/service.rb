##
# Nagios service
#
# Usage:
#	Monitor an apache log file:
#
#	nagios_service :serviceAlias do
#	end
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com
define :nagios_service, :name => :name do
	if(params[:tpl_check_command] != nil)
		erb = Erubis::Eruby.new(params[:tpl_check_command])
		params[:check_command] = erb.evaluate({ 
			:role => role,
			:environment => environment
		}) 
	end

	if(params[:use_nagios_service] != nil)
		params[:use] = params.delete( :use_nagios_service )
	end

	params.each do |key,val|
		params[key] = 1 if(val.class == TrueClass)
		params[key] = 0 if(val.class == FalseClass)
	end

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
