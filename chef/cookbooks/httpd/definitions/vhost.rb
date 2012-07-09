##
# Virtual host def
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

define :vhost, :serverName => nil do

	raise Exception.new( "Please pass serverName to vhost" ) if(params[:serverName] == nil)

	listen = (params[:listen] == nil ? 80 : params[:listen].to_i())
	logLevel = (params[:logLevel] == nil ? "warn" : params[:logLevel])

	puts params.inspect

	template "/etc/httpd/conf.d/site.conf" do
		mode "0755"
		owner "apache"
		group "apache"
		source "vhost.conf.erb"
		variables({
			:listen => listen,
			:envName => node.chef_environment,
			:logLevel => logLevel,
			:serverName => params[:serverName],
			:documentRoot => params[:documentRoot],
			:serverAliases => params[:serverAliases]
		})
	end


end
