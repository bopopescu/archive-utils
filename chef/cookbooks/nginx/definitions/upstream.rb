##
# Upstream def
#
# Creates an nginx upstream file using the upstream.erb template.
#
# Usage:
#	upstream do 
#		envName envName
#		roleName RoleArgoService
#		defaultPort 8080
#		serviceName "api"
#	end
#
# This will create something to the effect of:
#
#	upstream api_ArgoService_wit_upstream {
#		server 10.241.58.111:8080; 
#	}
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com
define :upstream do

	params[:envName] ||= node.chef_environment
	nodes = nil

	if(params[:nodes] == nil)
		nodes = []
		s = search( :node,"chef_environment:%s AND run_list:role\\[%s\\] AND NOT reverseproxy_enabled:false" % [params[:envName],params[:roleName]] )
		s.map{|node| nodes.push( node.ipaddress )}

	else
		nodes = params[:nodes]
	end

	if(nodes == nil || nodes.count == 0)
		puts "Unable to find any nodes for %s :: %s" % [params[:envName],params[:roleName]]
		raise Exception.new( "Unable to find any nodes for %s :: %s" % [params[:envName],params[:roleName]] )
	end

	defaultPort = (params[:defaultPort] == nil || params[:defaultPort].to_i() == 0 ? 80 : params[:defaultPort].to_i())

	template "/etc/nginx/upstreams-available/%s" % params[:serviceName] do
		mode "0755"
		owner "apache"
		group "root"
		source "upstream.erb"
		notifies :reload , resources(:service => "nginx")
		variables({
			:nodes => nodes,
			:defaultPort => defaultPort,
			:upstreamName => "%s_%s_upstream" % [params[:serviceName],params[:envName]]
		})
	end
	
	link "/etc/nginx/upstreams-enabled/%s" % params[:serviceName] do
		to "/etc/nginx/upstreams-available/%s" % params[:serviceName]
	end

end

