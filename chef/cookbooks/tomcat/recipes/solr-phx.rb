##
# Solr for the phoenix services.
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

include_recipe "tomcat::default"

["conf","data"].each do |dirName|
	directory "/mnt/local/solr/%s" % dirName do
		mode "0755"
		owner "tomcat"
		group "tomcat"
		action :create
		recursive true
	end
end

remote_directory "/mnt/local/solr/conf" do
	mode "0755"
	owner "tomcat"
	group "tomcat"
	source "solr/generic"
end

cookbook_file "/mnt/local/tomcat6/wars/apache-solr-1.4.1.war" do
	mode "0755"
	owner "tomcat"
	group "tomcat"
	source "solr/apache-solr-1.4.1.war"
end

cookbook_file "/etc/tomcat6/tomcat6.conf" do
    mode "0755"
    owner "root"
    group "root"
    source "solr/tomcat6.conf"
end


envName = node.chef_environment.to_sym()
dBagDBA = search( envName.to_sym(),"id:dba" ).first
pods = dBagDBA["resources"][envName]["pod"]

if(pods == nil || pods.size == 0)
	raise Exception.new( "No pods defined for this environment" )
end

template "/mnt/local/solr/conf/data-config.xml" do
	mode "0755"
	owner "tomcat"
	group "tomcat"
	source "solr/data-config.xml.erb"
	variables({
		:node => node,
		:pods => pods
	})
end

cookbook_file "/mnt/local/solr/conf/solrconfig.xml" do
	mode "0755"
	owner "tomcat"
	group "tomcat"
	source "solr/solrconfig.xml"
end

cookbook_file "/mnt/local/solr/conf/schema.xml" do
	mode "0755"
	owner "tomcat"
	group "tomcat"
	source "solr/schema.xml"
end













# Reminder for future upgrades:
# need logic for removing deployed webapp and auto restarting tomcat
#cookbook_file "/var/lib/tomcat6/webapps/solr.war" do
	#source "solr/#{node['lockerz']['environment'].first}/war/apache-solr-1.4.1.war"
	#owner "root"
	#group "tomcat"
	#mode "0440"
#end

#%w{admin-extra.html elevate.xml mapping-ISOLatin1Accent.txt protwords.txt scripts.conf spellings.txt stopwords.txt synonyms.txt}.each do |file|
	#cookbook_file "/etc/solr/conf/#{file}" do
		#source "solr/#{node['lockerz']['environment'].first}/conf/generic/#{file}"
		#owner "root"
		#group "tomcat"
		#mode "0444"
	#end
#end

# Update system tomcat script with classpath settings (don't know where else to put it,
# tomcat broke when I tried to use /etc/sysconfig/tomcat6
#cookbook_file "/usr/sbin/tomcat6" do
	#source "solr/#{node['lockerz']['environment'].first}/bin/tomcat6"
	#owner "root"
	#group "tomcat"
	#mode "0555"
#end

#file "/etc/solr/conf/dataimport.properties" do
	#owner "root"
	#group "tomcat"
	#mode "0664"
	#action :touch
#end

#cookbook_file "/etc/solr/conf/data-config.xml" do
	#source "solr/#{node['lockerz']['environment'].first}/conf/data-config.xml"
	#owner "root"
	#group "tomcat"
	#mode "0440"
#end

#cookbook_file "/etc/solr/conf/schema.xml" do
	#source "solr/#{node['lockerz']['environment'].first}/conf/schema.xml"
	#owner "root"
	#group "tomcat"
	#mode "0440"
#end

#cookbook_file "/etc/solr/conf/solrconfig.xml_master" do
	#source "solr/#{node['lockerz']['environment'].first}/conf/solrconfig.xml_master"
	#owner "root"
	#group "tomcat"
	#mode "0440"
#end

#cookbook_file "/etc/solr/conf/solrconfig.xml_slave" do
	#source "solr/#{node['lockerz']['environment'].first}/conf/solrconfig.xml_slave"
	#owner "root"
	#group "tomcat"
	#mode "0440"
#end

#if ( "#{node['lockerz']['solr-type'].first}" == "master" )
	#link "/etc/solr/conf/solrconfig.xml" do
		#to "/etc/solr/conf/solrconfig.xml_master"
	#end
#end

#if ( "#{node['lockerz']['solr-type'].first}" == "slave" )
	#link "/etc/solr/conf/solrconfig.xml" do
		#to "/etc/solr/conf/solrconfig.xml_slave"
	#end
#end

