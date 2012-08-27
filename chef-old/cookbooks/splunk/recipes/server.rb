# Splunk server recipe
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

package "splunk" do
	action :install
end

directory "/opt/splunk/etc/apps/search/local/" do
	mode "0755"
	owner "root"
	group "root"
	recursive true
end

mdadm "/dev/md0" do
	level 0
	action [ :create, :assemble ]
	devices ["sdf1", "sdf13", "sdf12", "sdf11", "sdf10", "sdf9", "sdf8", "sdf7", "sdf6", "sdf5", "sdf4", "sdf3", "sdf2"]
end

