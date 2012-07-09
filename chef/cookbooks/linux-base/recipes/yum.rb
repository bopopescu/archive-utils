##
# Yum repos
#
cookbook_file "/etc/yum.repos.d/jpackage.repo" do
	mode "0755"
	owner "root" 
	group "root"
	source "yum/jpackage.repo"
end

cookbook_file "/etc/yum.repos.d/lockerz.com.repo" do
	mode "0755"
	owner "root" 
	group "root"
	source "yum/lockerz.com"
end
