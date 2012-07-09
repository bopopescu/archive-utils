##
# Cookbook Name:: bind
# Recipe:: default
#

package "bind" do
	package_name "bind97"
	action :install
end

service "named" do
	action [ :enable, :start ]
	supports :restart => true, :reload => true
	ignore_failure true
end

