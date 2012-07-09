##
# api.lockerz.com
#
# @author	Bryan Kroger ( bryan@lockerz.com )
# Copyright 2011, lockerz.com
# All rights reserved - Do Not Redistribute

envName = node.chef_environment
serverName = (envName == "prod" ? "lockerz.com" : "%s.lockerz.us" % envName)

upstream do 
	envName "platz"
	serviceName "api"
	roleName "platz_apps"
	defaultPort 8080
end

## Vhost for api external
nginx_vhost "api-external.%s" % serverName do
	ssl true
	state :enabled
	upstreamName "api_platz_upstream"
	defaultPort 443
	errorLogName "api/external-error.log"
	accessLogName "api/external-access.log"
	serverNames ["api.%s" % serverName]
end

if envName == "prod" then
lm_watcher do
	owner "nginx"
	group "nginx"
	postCmd "sudo service nginx reload"
	logName "nginx_api-external_access_log"
	logDisplay "Nginx API-External Access Log"
	logFilename "%s/api/external-access.log" % node[:fsLogRoot]
	rotationInterval 10
end
end

node[:splunk] = { :monitors => {} } if(node[:splunk] == nil)
node[:splunk][:monitors]["%s/api/external-error.log" % node[:fsLogRoot]] = ""
node[:splunk][:monitors]["%s/api/external-access.log" % node[:fsLogRoot]] = ""


## VHost for api internal
apiInternalName = "api.prod.lockerz.int"
nginx_vhost "api-internal.%s" % serverName do
	state :enabled
	upstreamName "api_platz_upstream"
	defaultPort 8080
	serverNames [apiInternalName]
	errorLogName "api/internal-error.log"
	accessLogName "api/internal-access.log"
end

if envName == "prod" then
lm_watcher do
	owner "nginx"
	group "nginx"
	postCmd "sudo service nginx reload"
	logName "nginx_api-internal_access_log"
	logDisplay "Nginx API-Internal Access Log"
	logFilename "%s/api/internal-access.log" % node[:fsLogRoot]
	rotationInterval 10
end
end

node[:splunk][:monitors]["%s/api/internal-error.log" % node[:fsLogRoot]] = ""
node[:splunk][:monitors]["%s/api/internal-access.log" % node[:fsLogRoot]] = ""

