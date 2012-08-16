##
# Description:
#	Installs the sudo package and a very basic configuration
#
# We don't really need sudo

package "sudo" do
	action :install
	package_name "sudo"
end

## For now, everyone uses prod.sudoers
# The idea here being that everyone uses root
cookbook_file "/etc/sudoers" do
	mode 0440
	owner "root"
	group "root"
	source "sudo/prod.sudoers" 
end
