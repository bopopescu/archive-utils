##
# Description: artifactory.lockerz.us 
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

include_recipe "httpd::default"

["server.crt","server.key"].each do |fileName|
	cookbook_file "/etc/httpd/ssl/%s" % fileName do
		mode "0755"
		owner "apache"
		group "apache"
		source "artifactory/%s" % fileName
	end
end

## VHost
cookbook_file "/etc/httpd/conf.d/artifactory.lockerz.us.conf" do
	mode "0755"
	owner "root"
	group "root"
	source "artifactory/vhost.conf"
	notifies :restart, resources(:service => "httpd")
end

