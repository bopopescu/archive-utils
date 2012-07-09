##
# Python packages required for the check_cpu package to work.
#	( and we could probably use this stuff for other things too )
#
# @author	Bryan Kroger ( bryan@lockerz.com )

#["python","python-elementtree","libxml2-python","python-sqlite","python-libs","rpm-python",
#"python-iniparse","python-bson","python-ldap","python-urlgrabber"].each do |packageName|
	#package packageName do
		#action :install
	#end
#end

directory "/var/tmp" do
	mode "0777"
	owner "root"
	group "root"
	recursive true
end

## Ensure that the check_cpu.state file is not owned by root
execute "Check CPU Perms" do
	command "touch /var/tmp/check_cpu.state ; chown nrpe:4502 /var/tmp/check_cpu.state"
end
