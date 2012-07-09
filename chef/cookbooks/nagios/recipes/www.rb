#
# Cookbook Name:: nagios
# Recipe:: default
#

package "nagios-www" do
	only_if "test -f /etc/redhat-release"
	package_name "nagios-www"
	action :install
end

