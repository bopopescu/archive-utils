##
# MySQL Percona install
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com


package "mysql-server-shared" do
	action :install
	package_name "Percona-Server-shared-55-5.5.13-rel20.4.138.rhel5"
end

package "mysql-server" do
	action :install
	package_name "Percona-Server-server-55-5.5.13-rel20.4.138.rhel5"
end

cookbook_file "/etc/mysql/my.cnf" do
	mode "0755"
	owner "apache"
	group "apache"
	source "my.cnf"
end
