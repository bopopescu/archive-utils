##
# firefly.lockerz.com
#
# @author	Bryan Kroger ( bryan@lockerz.com )
# Copyright 2011, lockerz.com
# All rights reserved - Do Not Redistribute

envName = node.chef_environment
serverName = (envName == "prod" ? "lockerz.com" : "%s.lockerz.us" % envName)

#dBagSite = search(envName,"id:site").first
#fireflyStaticFailover = dBagSite["firefly_static_fail_over"]

## Create the logging directory
directory "%s/firefly/" % node[:fsLogRoot] do
	mode "0755"
	owner "nginx"
	group "nginx"
	recursive true
end

port = 9093
port = 9094 if(node.chef_environment == "prod")

upstream do
	roleName "FireflyApplicationService"
	defaultPort 7500 
	serviceName "firefly.%s" % serverName
end

routes = []
routes.push( "/rdoc/             { root /mnt/md0.local/lockerz.com/bryan/firefly/docs/; } ")
routes.push( "/js/               { root /mnt/md0.local/lockerz.com/bryan/firefly/static/; } ")
routes.push( "/css/              { root /mnt/md0.local/lockerz.com/bryan/firefly/static/; } ")
routes.push( "/images/   { root /mnt/md0.local/lockerz.com/bryan/firefly/static/; } ")
routes.push( "/resources/        { root /mnt/md0.local/lockerz.com/bryan/firefly/static/; } ")
routes.push( "/ { proxy_set_header X-Real-IP $remote_addr; proxy_pass http://firefly.%s_%s_upstream/; auth_pam 'Secure Zone'; auth_pam_service_name 'nginx'; }" % [serverName,node.chef_environment] )

nginx_vhost "firefly.%s" % serverName do
	ssl true
	state (fireflyStaticFailover == true ? :disabled : :enabled)
	routes routes
	usePamAuth true
	serverNames ["firefly.%s" % serverName]
	serviceName "firefly.%s" % serverName
	defaultPort port
	upstreamName "firefly.%s_%s_upstream" % [serverName,envName]
	errorLogName "firefly/error.log"
	accessLogName "firefly/access.log"
	noDefaultRoute true
end

#lm_watcher do
	#owner "apache"
	#group "apache"
	#postCmd "sudo service nginx reload"
	#logName "nginx_firefly_access_log"
	#logDisplay "Nginx Blog Access Log"
	#logFilename "%s/firefly/access.log" % node[:fsLogRoot]
	#rotationInterval 10
#end

#node[:splunk] = { :monitors => {} } if(node[:splunk] == nil)
#node[:splunk][:monitors]["%s/firefly/error.log" % node[:fsLogRoot]] = ""
#node[:splunk][:monitors]["%s/firefly/access.log" % node[:fsLogRoot]] = ""

