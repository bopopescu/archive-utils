##
# MySQL service
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

## Packages
package "mysql-5.0.77-4.el5_6.6.x86_64" do
  action :remove
end

package "MySQL-server"
package "MySQL-devel"
package "MySQL-shared-compat"

## Required for the mysql_check_health nagios plugin.
package "perl-DBD-MySQL" do
	options "--skip-broken"
end

directory " /var/tmp/check_mysql_health" do
	mode "0755"
	owner "nrpe"
	group "nrpe"
	recursive true
end


## Config file
userData = JSON::parse(node["ec2"]["userdata"])
serverId = (userData["nodeInt"].to_i()+1)
template "/etc/my.cnf" % node[:mysql][:fsConfRoot] do
	owner "mysql"
	group "mysql"
	mode "0755"
	source "main.cnf.erb"
	variables({
		:node => node,
		:serverId => serverId
	})
end

## Containers
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

## Service config.
service "mysql" do
	supports :restart => true, :reload => true
	action [ :enable, :start ]
end

## Mounts.
#mount "/mnt/ebs/lockerz.com/data" do
#	device "/dev/md0"
#	fstype "xfs"
#	action [:mount, :enable]
#end

#mount "/mnt/ebs/lockerz.com/logs" do
#	device "/dev/md1"
#	fstype "xfs"
#	action [:mount, :enable]
#end

