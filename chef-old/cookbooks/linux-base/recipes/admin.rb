##
# An admin server would require portmap and autofs running for automount services.
#
# @author	Bryan Kroger ( bryan@lockerz.com )

## Ensure that portmap is running
service "portmap" do
	action [ :enable, :start ]
	supports :restart => true, :reload => true
	ignore_failure true
end

## Ensure that autofs is running
service "autofs" do
	action [ :enable, :start ]
	supports :restart => true, :reload => true
	ignore_failure true
end

## Ensure the ec2 tools get installed
package "ec2-ami-tools" do
	action :install
end

directory "/usr/local/ec2/" do
	mode "0755"
	owner "root"
	group "ops"
end

remote_directory "/usr/local/ec2/" do
	mode "0755"
	owner "root"
	group "ops"
	source "ec2"
end

