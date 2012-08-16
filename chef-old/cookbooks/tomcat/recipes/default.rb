##
# Tomcat6 recipe
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

## Packages
package "tomcat6"
package "tomcat6-jsp-2.1-api"
package "tomcat6-lib"
package "tomcat6-webapps"
package "tomcat6-servlet-2.5-api"

service "tomcat6" do
	supports :restart => true, :reload => true
	action [ :enable, :start ]
end

package "memcached"

## Directories
directory "/etc/tomcat6/" do
	mode "0755"
	owner "root"
	group "tomcat"
	recursive true
end

["dumps","etc/services","wars","work","logs","tmp","tmp/restapi","cache/temp"].each do |dirName|
	directory "/mnt/local/tomcat6/%s" % dirName do
    	mode "0775"
    	owner "tomcat"
    	group "tomcat"
    	recursive true
	end
end

cookbook_file "/etc/tomcat6/server.xml" do
    mode "0744"
    owner "root"
    group "tomcat"
    source "server/server.xml"
end

cookbook_file "/usr/sbin/dtomcat6" do
   	mode "0775"
   	owner "root"
   	group "root"
	source "dtomcat6"
end

## Delete the directory created from the installer
directory "/var/log/tomcat6" do
	not_if "readlink /var/log/tomcat6"
	action :delete
	recursive true
end

## Link logging container for easy access
link "/var/log/tomcat6" do
	to "/mnt/local/tomcat6/logs"
end

link "/mnt/local/tomcat6/bin" do
	to "/usr/share/tomcat6/bin"
end

link "/mnt/local/tomcat6/lib" do
	to "/usr/share/java/tomcat6"
end

directory "/mnt/local/tomcat6/conf" do
	not_if "readlink /mnt/local/tomcat6/conf"
	action :delete
	recursive true
end
link "/mnt/local/tomcat6/conf" do
	to "/etc/tomcat6"
end

directory "/var/lib/tomcat6/jsp/operations" do
	mode "0755"
	owner "tomcat"
	group "tomcat"
	recursive true
end

cookbook_file "/var/lib/tomcat6/jsp/operations/get_heap_free.jsp" do
	mode "0444"
	source "jsp/get_heap_free.jsp"
end

cookbook_file "/etc/tomcat6/tomcat.keystore" do
	mode "0440"
	owner "root"
	group "tomcat"
	source "tomcat6/production/conf/tomcat.keystore"
end

cookbook_file "/etc/init.d/tomcat6" do
	mode "0555"
	owner "root"
	group "tomcat"
	source "tomcat6/init"
end

cookbook_file "/etc/tomcat6/tomcat6.conf" do
	mode "0755"
	owner "root"
	group "root"
	source "tomcat6/defaults"
end

cookbook_file "/etc/tomcat6/logging.properties" do
	mode "0444"
	owner "root"
	group "tomcat"
	source "tomcat6/production/conf/logging.properties"
end


## Log rotation
cookbook_file "/etc/logrotate.d/httpd" do
	action :delete
end

cookbook_file "/etc/logrotate.d/tomcat6" do
	mode "0755"
	owner "tomcat"
	group "tomcat"
	source "tomcat6/service.logrotate.conf"
end

cookbook_file "/etc/logrotate.conf" do
	mode "0755"
	owner "tomcat"
	group "tomcat"
	source "tomcat6/logrotate.conf"
end

