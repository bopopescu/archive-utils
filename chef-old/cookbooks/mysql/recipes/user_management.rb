##
# MySQL UserManagement service
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

if(node["mysql"] != nil && node["mysql"]["users"] != nil)
	envMysqlUsers = node["mysql"]["users"]
	envMysqlUsers.each do |user,info|
		mysql_user do
			userInfo info
		end
	end
end

## Bind this server to a specific service
# Basically all this is intended to do is ensure that the mysql users are created from the service config on the environment.
if(node["service"] != nil)
	serviceName = node["service"]
	if(node[serviceName]["mysql"] != nil && node[serviceName]["mysql"]["users"] != nil)
		envMysqlUsers = node[serviceName]["mysql"]["users"]
		envMysqlUsers.each do |user,info|
			mysql_user do
				userInfo info
			end
		end
	end
end

