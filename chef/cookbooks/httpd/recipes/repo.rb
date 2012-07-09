##
# Description: custom rpm repo for lockerz
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

include_recipe "httpd::default"

## VHost
cookbook_file "/etc/httpd/conf.d/repo.conf" do
	mode "0755"
	owner "root"
	group "root"
	source "repo/vhost.conf"
end

