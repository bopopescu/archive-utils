##
# Cookbook Name:: phoenix::access_control
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

directory "/mnt/local/lockerz.com/etc/access_control/" do
	mode "0755"
	owner "phoenix"
	group "phoenix"
	action :create
	recursive true
end

cookbook_file "/mnt/local/lockerz.com/etc/access_control/options" do
	mode "0755"
	owner "phoenix"
	group "phoenix"
	action :create
	source "services/access_control/options"
end

