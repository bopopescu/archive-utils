##
# Cookbook Name:: bind
# Recipe:: default
#

package "bind" do
	package_name "bind9"
	action :install
end

service "bind9" do
	action [ :enable, :start ]
	supports :restart => true, :reload => true
	ignore_failure true
end

