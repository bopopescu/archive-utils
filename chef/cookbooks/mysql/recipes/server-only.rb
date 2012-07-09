##
# MySQL service
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

package "MySQL-server"

directory "/var/log/mysql" do
	not_if "readlink /var/log/mysql"
	action :delete
	recursive true
end
link "/var/log/mysql" do
	to node[:mysql][:fsLogRoot]
end

directory "/var/lib/mysql" do
	not_if "readlink /var/lib/mysql"
	action :delete
	recursive true
end
link "/var/lib/mysql" do
	to node[:mysql][:fsDataRoot]
end

service "mysql" do
	supports :restart => true, :reload => true
	action [ :enable, :start ]
end


