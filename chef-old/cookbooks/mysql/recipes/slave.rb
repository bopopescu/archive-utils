##
# MySQL slave recipe.
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com
include_recipe "mysql::default"
include_recipe "mysql::client"
include_recipe "mysql::user_management"
include_recipe "mysql::service"

rplUser = node["mysql"]["users"]["replication"]

mysql_user do
	userInfo node["mysql"]["users"]["replication"]
end

template "%s/conf.d/slave.cnf" % node[:mysql][:fsConfRoot] do
	mode "0755"
	owner "mysql"
	group "mysql"
	source "slave.cnf.erb"
	variables({
		:rplUser => rplUser
	})
end

## Check for slave replication status.
rootPass = "15RKsVgtTKTra2RQ"
cmdTestSlaveStatus = "[[ `mysql -E -u root -p%s mysql -e \"SHOW SLAVE STATUS\"|grep 'Slave_IO_State'|awk '{print $2}'` == '' ]]" % [ rootPass ]
## Test for the user
# If the user doesn't exist, create it.
#puts "CMD(testSlaveStatus): %s" % cmdTestSlaveStatus
execute "Start slave" do
	command "mysql -u root -p%s mysql -e \"START SLAVE\"" % [ rootPass ]
	only_if cmdTestSlaveStatus
end

