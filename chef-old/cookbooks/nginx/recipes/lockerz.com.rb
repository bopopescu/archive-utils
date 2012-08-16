##
# lockerz.com
#
# @author	Bryan Kroger ( bryan@lockerz.com )
# Copyright 2011, lockerz.com
# All rights reserved - Do Not Redistribute

envName = node.chef_environment
serverName = (envName == "prod" ? "lockerz.com" : "%s.lockerz.us" % envName)

## Get info for site
dBagSite = search(envName,"id:site").first

## Site config
siteStaticFailover = dBagSite["site_static_fail_over"]  ## GoneFishing override for site

# The prod load balancers now use upstreams in the platz environment
envName = (envName == "prod" ? "platz" : envName)

## PegasusWebFrontend is lockerz.com
upstream do 
	envName envName
	roleName "platz_apps"
	serviceName serverName
end

nginx_vhost serverName do
	state (siteStaticFailover == true ? :disabled : :enabled)
	defaultServer true
	serverNames [
		"plixi.com","tweetphoto.com",
		"www.%s" % serverName,serverName
	]
	upstreamName "%s_%s_upstream" % [serverName,envName]
	errorLogName "lockerz.com/error.log"
	accessLogName "lockerz.com/access.log"
	rewrite [
		# Legacy URL rewrites
		"^/redeem        /dealz  permanent",
		"^/auction       /dealz  permanent",
		"^/ultimateWallpaper /dealz  permanent",
		# Rewrite /forum[s] 
		"^/forum     http://lockerz.zendesk.com/categories/20000622-community permanent",
		"^/forums    http://lockerz.zendesk.com/categories/20000622-community permanent"
	]

	routes [
        # OPZ-603
        "/gallery/1625046 { rewrite . http://%s/ redirect; }" % serverName,
        "= /s/156878622 { rewrite . http://%s/ redirect; }" % serverName,
        "~ ^/shop/.* { rewrite  ^/shop/(.*) http://shop.%s/$1   permanent; }" % serverName,
        "~ ^/shop { rewrite ^/shop  http://shop.%s/ permanent; }" % serverName,
	]
end

if envName == "prod" then
lm_watcher do
	owner "nginx"
	group "nginx"
	postCmd "sudo service nginx reload"
	logName "nginx_lockerz.com_access_log"
	logDisplay "Nginx Lockerz Access Log"
	logFilename "%s/lockerz.com/access.log" % node[:fsLogRoot]
	rotationInterval 10
end
end
node[:splunk][:monitors]["%s/lockerz.com/error.log" % node[:fsLogRoot]] = ""
node[:splunk][:monitors]["%s/lockerz.com/access.log" % node[:fsLogRoot]] = ""



## SSL-enabled site 
nginx_vhost "ssl-%s" % serverName do
	ssl true
	state (siteStaticFailover == true ? :disabled : :enabled)
	serverNames ["secure.%s" % serverName,"ssl.%s" % serverName,serverName,"www.%s" % serverName]
	upstreamName "%s_%s_upstream" % [serverName,envName]
	rateLimiting false
	errorLogName "lockerz.com/ssl-error.log"
	accessLogName "lockerz.com/ssl-access.log"
end

if envName == "prod" then
lm_watcher do
	owner "nginx"
	group "nginx"
	postCmd "sudo service nginx reload"
	logName "nginx_ssl-lockerz.com_access_log"
	logDisplay "Nginx SSL-Lockerz Access Log"
	logFilename "%s/lockerz.com/ssl-access.log" % node[:fsLogRoot]
	rotationInterval 10
end
end
node[:splunk][:monitors]["%s/lockerz.com/ssl-error.log" % node[:fsLogRoot]] = ""
node[:splunk][:monitors]["%s/lockerz.com/ssl-access.log" % node[:fsLogRoot]] = ""

