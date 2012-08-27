
cookbook_file "/var/lib/tomcat6/jars/mysql-connector-java-5.1.10-bin.jar" do
	source "mysql/#{node['lockerz']['environment'].first}/mysql-connector-java-5.1.10-bin.jar"
	owner "root"
	group "tomcat"
	mode "0440"
end


