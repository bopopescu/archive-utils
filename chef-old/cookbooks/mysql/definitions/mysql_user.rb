##
# MySQL user.
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com
rootPass = "15RKsVgtTKTra2RQ"

define :mysql_user do

	userInfo = params[:userInfo]

	cmdTestUser = "[ `mysql -NE -u root -p%s mysql -e \"SELECT COUNT(*) AS cnt FROM user WHERE User='%s'\"|grep -e \"^[0-9]\"` == 0 ]" % [
		rootPass,
		userInfo["username"]
	]
	## Test for the user
	# If the user doesn't exist, create it.
    execute "Create user %s" % userInfo["username"] do
        command "mysql -u root -p%s mysql -e \"GRANT %s ON *.* TO '%s'@'%%' IDENTIFIED BY '%s';FLUSH PRIVILEGES\"" % [ 
            rootPass,
            userInfo["privs"],
            userInfo["username"],
            userInfo["password"]
        ]
        only_if cmdTestUser, :return_code => 0
    end

	## Test to make sure this users password is correct.
	# This assumes that any user, regardless of permissions can connect to the local instance.
	#cmdTestUser = "[ `mysql -N -u %s -p%s mysql -e \"SHOW PROCESSLIST\"|grep %s` == '' ]" % [
	cmdTestUserPassword = "mysql -N -u %s -p%s -h %s test -e \"SHOW PROCESSLIST\"" % [
		userInfo["username"],
		userInfo["password"],
		node[:ipaddress]
	]
	puts "CMD(testUserPass): %s" % cmdTestUserPassword
    execute "Updating userpass for %s" % userInfo["username"] do
        command "mysql -u root -p%s mysql -e \"SET PASSWORD FOR '%s'@'%%' = PASSWORD('%s');FLUSH PRIVILEGES\"" % [ 
			rootPass,
            userInfo["username"],
            userInfo["password"]
        ]
        #only_if cmdTestUserPassword, :return_code => 1
        not_if cmdTestUserPassword
    end
end
