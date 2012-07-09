##
# Creates an nginx vhost entry by assuming many default values.
#	Most of these values are overwriteable.
#
# This will create the vhost entry from the template.
#
# Usage:
#	nginx_vhost "lockerz.com" do
#		state (siteStaticFailover == true ? :disabled : :enabled)
#		serverNames ["lockerz.com","www.lockerz.com"]
#		fsLogRoot fsLogRoot
#		#xForwardedProto "blah"
#		rateLimiting false
#		#rateLimiting true
#		#   limit_req   zone=LockerzCom burst=20    nodelay;
#		#   limit_conn  LockerzComLimitConn 5;
#		#rateLimitReq "zone=LockerzCom burst=20 nodelay"
#		#rateLimitConn "LockerzComLimitConn 5"
#	end
#
# Variables:
#	@param	Bool	ssl			Enables ssl support
#	@param	String	sslCertificateFile	File location for the certificate file ( server.crt )
#	@param	String	sslCertificateKeyFile	File location for the certificate key file ( server.key )

#	@param	Sym		state		Disabled will throw outage page. (:enabled|:disabled)
#	@param	String	fsLogRoot	String	Log container location node[:fsLogRoot]
#	@param	Array	serverNames	Array of server name strings ( "lockerz.com" )
#	@param	String	upstreamName	Name of the upstream name to use.
#	@param	Bool	rateLimiting	False means "no rate limting"
#	@param	String	rateLimitReq	Nginx limit_req value.
#	@param	String	rateLimitConn	Nginx limit_conn value.
#	@param	String	xForwardedProto	Nginx proxy_header X-Forwarded-Proto value.
#	@param	String	xForwardedPort	Nginx proxy_header X-Forwarded-Port value.
#	@param	Bool	defaultServer	should this server config capture reqeusts for unknown hostnames?
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com
define :nginx_vhost, :vHostName => :name do
	name = params[:name]

	## Default listen port is the standard :80 http.
	params[:defaultPort] ||= 80
	params[:defaultServer] ||= false
	params[:listen] = params[:defaultPort]

	## Default state is enabled.
	params[:state] ||= :enabled

	## Default value for the logging container is the default attribute value for the node.
	params[:fsLogRoot] ||= node[:fsLogRoot]

	## Empty list of server names in case this is the default vhost ( in which case there would be no server_name value ).
	params[:serverNames] ||= []

	params[:errorLogName] ||= "%s_error_log" % name
	params[:accessLogName] ||= "%s_access_log" % name

	## Error log.
	defaultErrorLog = {
		:lm => nil,
		:level => :info,
		:fsLocation => "%s/%s" % [params[:fsLogRoot],params[:errorLogName]]
	}
	params[:errorLog] = defaultErrorLog.merge(( params[:errorLog] == nil ? {} : params[:errorLog] ))

	## Access log.
	defaultAccessLog = {
		:type => "lockerz",
		:level => :info,
		:fsLocation => "%s/%s" % [params[:fsLogRoot],params[:accessLogName]]
	}
	params[:accessLog] = defaultAccessLog.merge(( params[:accessLog] == nil ? {} : params[:accessLog] ))

	## Ensure that we'll have a logging directory to log files to.
	directory File.dirname( defaultAccessLog[:fsLocation] ) do
		mode "0755"
		owner "nginx"
		group "nginx"
		recursive true
	end

	## Frame up the vhost config.
	vHostConfig = {
		:ssl => nil,
		:errorLog => params[:errorLog],
		:accessLog => params[:accessLog],
		:serverNames => params[:serverNames],
		:proxy_set_header => [
			"Host $host",
			"X-Real-IP $remote_addr",
			"X-Forwarded-For $remote_addr"
		],
		:listen => params[:listen],
		:error_page => [
			"500 = /500.html",
			"404 = /400.html"
		],
		:routes => [
			"/500.html { root /var/www/lockerz.com/errors/; }",
			"/400.html { root /var/www/lockerz.com/errors/; }"
		],
		:proxy_buffering => "off",
		:proxy_intercept_errors => "off"
	}

	## SSL options
	if(params[:ssl] == true)
		vHostConfig[:listen] = 443 if(vHostConfig[:listen] == 80) ## default change to 443 from 80.
		vHostConfig[:ssl] = {
			:ssl_certificate => (params[:sslCertificateFile] == nil ? "/etc/nginx/ssl/lockerz.crt" : params[:sslCertificateFile]),
			:ssl_certificate_key => (params[:sslCertificateKeyFile] == nil ? "/etc/nginx/ssl/lockerz.key" : params[:sslCertificateKeyFile])
		}
	end

	## Set the X-Forwarded-Proto header.
	vHostConfig[:proxy_set_header].push( "X-Forwarded-Proto '%s'" % 
		( params[:xForwardedProto] == nil ? (params[:ssl] == true ? "https" : "http") : params[:xForwardedProto] ) 
	)

	## Set the X-Forwarded-Port header.
	vHostConfig[:proxy_set_header].push( "X-Forwarded-Port '%s'" % 
		( params[:xForwardedPort] == nil ? (vHostConfig[:listen]) : params[:xForwardedPort] ) 
	)

	# default server
	vHostConfig[:defaultServer] = params[:defaultServer] ? "default_server" : ""

	## Rate limiting
	vHostConfig[:rateLimiting] = params[:rateLimiting]
	vHostConfig[:rateLimitReq] = (vHostConfig[:rateLimitReq] == nil ? "zone=LockerzCom burst=20    nodelay" : vHostConfig[:rateLimitReq])
	vHostConfig[:rateLimitConn] = (vHostConfig[:rateLimitConn] == nil ? "LockerzComLimitConn 5" : vHostConfig[:rateLimitConn])

	## Check state
	if(params[:state] == :disabled)
		## If the site is disabled, use the outage files.
        vHostConfig[:routes].push( "~ .png$ { rewrite ^/.*/(.*\.png)$ /$1 ; root /var/www/lockerz.com/outage/; }" )
        vHostConfig[:routes].push( "= /index.html { root /var/www/lockerz.com/outage/; }" )
        vHostConfig[:routes].push( "~ ^/ { rewrite ^/(.*)$ /index.html last; }" )

	else
		## Otherwise pass the request along.

		## Set the name of the upstream.
		#params[:upstreamName] ||= "%s_%s_upstream" % [name,node.chef_environment]

		if(params[:upstreamName] != nil)
			if(params[:noDefaultRoute] == nil || params[:noDefaultRoute] == false)
				vHostConfig[:routes].push( "/ { proxy_pass http://%s/; }" % params[:upstreamName] )
			end
		end

		if(params[:routes] != nil && params[:routes].class == Array)
			params[:routes].each{|route| vHostConfig[:routes].push( route )}
		end
	end



	## Use the default template to generate the config.
	template "/etc/nginx/sites-available/%s" % name do
		mode "0755"
		owner "apache"
		group "apache"
		source "vhost.erb"
		notifies :reload , resources(:service => "nginx")
		variables({
			:vHostConfig => vHostConfig
		})
	end
	
	## Finally, activate the site by linking.
	link "/etc/nginx/sites-enabled/%s" % name do 
		to "/etc/nginx/sites-available/%s" % name
	end
end
