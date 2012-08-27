##
# Description
#	Simple IRC server
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

package "ircd" do
	action :install
	package_name "ircd-hybrid"
end

service "ircd" do
	action [ :enable, :start ]
	supports :restart => true, :reload => true
end


