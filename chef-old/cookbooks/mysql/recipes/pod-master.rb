##
# Pod master recipe.
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

include_recipe "mysql::client"
include_recipe "mysql::server"

## Custom my.cnf for pod master
cookbook_file "/etc/mysql/conf.d/my.cnf" do
	mode "0755"
	owner "root"
	group "root"
	source "prod/pod/master.cnf"
end

