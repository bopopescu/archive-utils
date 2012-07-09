##
# shop.lockerz.com 
#
# @author	Bryan Kroger ( bryan@lockerz.com )
# Copyright 2011, lockerz.com
# All rights reserved - Do Not Redistribute

envName = node.chef_environment
serverName = (envName == "prod" ? "lockerz.com" : "%s.lockerz.us" % envName)

## Site config
dBagSite = search(envName,"id:site").first

## Static failover
commerceStaticFailover = dBagSite["commerce_static_fail_over"]

commerceNodes = nil

## This is a hack for rp0, also known as preprod.
if(node.fqdn == "reverseproxy0.site.prod.lockerz.us")
	commerceNodes = dBagSite["resources"][envName]["commerce-preprod"]
end
## Same hack for weblab-prod
if(node.fqdn == "reverseproxy1.site.prod.lockerz.us")
	commerceNodes = dBagSite["resources"][envName]["commerce-weblab"]
end

# The prod load balancers now use servers in the platz environment
envName = (envName == "prod" ? "platz" : envName)

if(commerceNodes == nil)
## Upstream for prod load balancers
upstream do
	serviceName "shop.%s" % serverName
        envName envName
        roleName "platz_shop"
end
else
## Upstream for preprod or weblab
upstream do
	nodes commerceNodes
	serviceName "shop.%s" % serverName
        envName envName
end
end

## Standard site.
nginx_vhost "shop.%s" % serverName do
	state (commerceStaticFailover == true ? :disabled : :enabled)
	serverNames ["shop.%s" % serverName]
	upstreamName "shop.%s_%s_upstream" % [serverName,envName]
	errorLogName "commerce/error.log"
	accessLogName "commerce/access.log"
	#rateLimiting true
	rateLimiting false
end

if envName == "prod" then
lm_watcher do
	owner "nginx"
	group "nginx"
	postCmd "sudo service nginx reload"
	logName "nginx_commerce_access_log"
	logDisplay "Nginx Commerce Access Log"
	logFilename "%s/commerce/access.log" % node[:fsLogRoot]
	rotationInterval 10
end
end

node[:splunk] = { :monitors => {} } if(node[:splunk] == nil)

node[:splunk][:monitors]["%s/commerce/error.log" % node[:fsLogRoot]] = ""
node[:splunk][:monitors]["%s/commerce/access.log" % node[:fsLogRoot]] = ""



## SSL-enabled site.
nginx_vhost "ssl-shop.%s" % serverName do
	ssl true
	state (commerceStaticFailover == true ? :disabled : :enabled)
	serverNames ["shop.%s" % serverName]
	upstreamName "shop.%s_%s_upstream" % [serverName,envName]
	errorLogName "commerce/ssl-error.log"
	accessLogName "commerce/ssl-access.log"
	#rateLimiting true
	rateLimiting false
end

if envName == "prod" then
lm_watcher do
	owner "nginx"
	group "nginx"
	postCmd "sudo service nginx reload"
	logName "nginx_ssl-commerce_access_log"
	logDisplay "Nginx SSL-Commerce Access Log"
	logFilename "%s/commerce/ssl-access.log" % node[:fsLogRoot]
	rotationInterval 10
end
end

node[:splunk][:monitors]["%s/commerce/ssl-error.log" % node[:fsLogRoot]] = ""
node[:splunk][:monitors]["%s/commerce/ssl-access.log" % node[:fsLogRoot]] = ""



