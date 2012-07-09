##
# Description:
#	This installs the SNMP daemon and a configuration for it
#
# @author	Bryan Kroger ( bryan@lockerz.com )

if(node[:platform] == "ubuntu")

	package "snmpd" do
		action :install
		package_name "snmpd"
	end

	cookbook_file "/etc/default/snmpd" do
		mode "0755"
		group "root"
		owner "root"
		source "snmpd/snmpd.default"
	end

else
	package "snmpd" do
		action :install
		package_name "net-snmp"
	end

	cookbook_file "/etc/sysconfig/snmpd.options" do
		mode "0755"
		group "root"
		owner "root"
		source "snmpd/snmpd.default"
	end

end

service "snmpd" do
	action [ :enable, :start ]
	supports :restart => true, :reload => true
end

cookbook_file "/etc/snmp/snmpd.conf" do
	mode "0755"
	group "root"
	owner "root"
	source "snmpd/snmpd.conf"
	notifies :restart, resources( :service => "snmpd" )
end

