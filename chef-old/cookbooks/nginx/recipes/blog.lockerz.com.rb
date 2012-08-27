##
# blog.lockerz.com
#
# @author	Bryan Kroger ( bryan@lockerz.com )
# Copyright 2011, lockerz.com
# All rights reserved - Do Not Redistribute

envName = node.chef_environment
serverName = (envName == "prod" ? "lockerz.com" : "%s.lockerz.us" % envName)

dBagSite = search(envName,"id:site").first

blogNodes = dBagSite["resources"][envName]["blog"]
blogStaticFailover = dBagSite["blog_static_fail_over"]

## Create the logging directory
directory "%s/blog/" % node[:fsLogRoot] do
	mode "0755"
	owner "nginx"
	group "nginx"
	recursive true
end

upstream do
	nodes blogNodes
	serviceName "blog.%s" % serverName
end

nginx_vhost "blog.%s" % serverName do
	state (blogStaticFailover == true ? :disabled : :enabled)
	serverNames ["blog.%s" % serverName]
	serviceName "blog.%s" % serverName
	upstreamName "blog.%s_%s_upstream" % [serverName,envName]
	errorLogName "blog/error.log"
	accessLogName "blog/access.log"
end

if envName == "prod" then
lm_watcher do
	owner "apache"
	group "apache"
	postCmd "sudo service nginx reload"
	logName "nginx_blog_access_log"
	logDisplay "Nginx Blog Access Log"
	logFilename "%s/blog/access.log" % node[:fsLogRoot]
	rotationInterval 10
end
end

node[:splunk] = { :monitors => {} } if(node[:splunk] == nil)
node[:splunk][:monitors]["%s/blog/error.log" % node[:fsLogRoot]] = ""
node[:splunk][:monitors]["%s/blog/access.log" % node[:fsLogRoot]] = ""

