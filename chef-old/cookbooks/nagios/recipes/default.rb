##
# Default aspects for nagios functionality
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

if(node[:platform] == "ubuntu" )

else
	cookbook_file "/etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag" do
    	mode "0755"
    	owner "nagios"
    	group "nagios"
    	source "server/RPM-GPG-KEY-rpmforge-dag"
	end

	cookbook_file "/etc/yum.repos.d/rpmforge.repo" do
    	mode "0755"
    	owner "nagios"
    	group "nagios"
    	source "server/rpmforge.repo"
	end
end

