##
# Tomcat recipe for argo
#
include_recipe "tomcat::default"

["etc","data","logs","backup","work"].each do |dirName|
	directory "/home/tomcat/.artifactory/%s" % dirName do
		mode "0755"
		owner "tomcat"
		group "tomcat"
		recursive true
	end
end

cookbook_file "/etc/tomcat6/tomcat6.conf" do
	mode "0755"
	owner "tomcat"
	group "tomcat"
	source "artifactory/defaults"
end

cookbook_file "/mnt/local/artifactory/etc/cacerts" do
	mode "0755"
	owner "tomcat"
	group "tomcat"
	source "artifactory/cacerts"
end

cookbook_file "/mnt/local/tomcat6/wars/artifactory.war" do
	mode "0755"
	owner "tomcat"
	group "tomcat"
	source "artifactory/artifactory.war"
end
