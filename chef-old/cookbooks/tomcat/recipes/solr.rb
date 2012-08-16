##
# Solr for the new java service backend
#
# https://lockerz.jira.com/browse/FOUNDRY-40
#
# Testing:
#	curl "http://search0.dba.prod.lockerz.int:8080/solr/"
#       should show a welcome page -- if the cores are initialized properly, it will
#       also show links to admin pages for all three cores.
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

include_recipe "tomcat::default"

directory "/mnt/local/solr/" do
        mode "0755"
        owner "tomcat"
        group "tomcat"
        recursive true
end

["conf","data"].each do |dirName|
	directory "/mnt/local/solr/%s" % dirName do
		mode "0755"
		owner "tomcat"
		group "tomcat"
		action :create
		recursive true
	end
end

remote_directory "/mnt/local/solr/lib" do
	mode "0755"
	owner "tomcat"
	group "tomcat"
	source "solr/lib"
end

remote_directory "/mnt/local/solr/conf/" do
    mode "0755"
    owner "tomcat"
    group "tomcat"
	source "solr/conf"
end

["decalz","video","members"].each do |coreName| 
	directory "/mnt/local/solr/conf/%s/conf" % coreName do
		mode "0755"
		owner "tomcat"
		group "tomcat"
		action :create
		recursive true
	end
end

["decalz","video","members"].each do |searchName| 
	## By default point at the environments mysql host
	dbHostname = "mysql0.dba.%s.lockerz.int" % node.chef_environment

	dbUsername = node["SearchService"]["mysql"]["users"]["readwrite"]["username"]
	dbPassword = node["SearchService"]["mysql"]["users"]["readwrite"]["password"]

	## The prod environment requires a more complex structures, so we use 
	#	chef searches to find what we're looking for.
	if(node.chef_environment == "prod")
		if(searchName == "decalz")
			#dbHostname = search( 
				#:node,
				#"chef_environment:%s AND run_list:role\\[MySQLMaster\\] AND service:DecalzService" % node.chef_environment 
			#).first().fqdn.gsub( /\.us$/,'.int' )
			dbHostname = "decalz0.dba.prod.lockerz.int"
			dbUsername = node["DecalzService"]["mysql"]["users"]["readwrite"]["username"]
			dbPassword = node["DecalzService"]["mysql"]["users"]["readwrite"]["password"]
	
		elsif(searchName == "members")
			#dbHostname = search( 
				#:node,
				#"chef_environment:%s AND run_list:role\\[MySQLMaster\\] AND run_list:role\\[FollowService\\]" % node.chef_environment 
			#).first().fqdn.gsub( /\.us$/,'.int' )
			dbHostname = "follow0.dba.prod.lockerz.int"
			dbUsername = node["FollowService"]["mysql"]["users"]["readwrite"]["username"]
			dbPassword = node["FollowService"]["mysql"]["users"]["readwrite"]["password"]

		elsif(searchName == "video")
			dbHostname = "mysql-masters0.dba.prod.lockerz.int"

			## Scalr nodes are not managed by chef, therfor we have to use a specific username/password.
			dbUsername = "videouser"
			dbPassword = "mnghlhgl"
		end
	end

	execute "reload config for %s" % searchName do
		command "curl localhost:8080/solr/%s/dataimport?command=reload-config" % searchName
		action :nothing   # only run if the template changes
	end

	template "/mnt/local/solr/conf/%s/conf/data-config.xml" % searchName do
		mode "0755"
		owner "tomcat"
		group "tomcat"
		source "solr/%s/data-config.xml.erb" % searchName
		variables({
			:envName => node.chef_environment,
			:dbUsername => dbUsername,
			:dbPassword => dbPassword,
			:dbHostname => dbHostname
		})
		notifies :run, resources(:execute => "reload config for %s" % searchName), :immediately
	end


end

cookbook_file "/mnt/local/tomcat6/conf/web.xml" do
	mode "0755"
	owner "tomcat"
	group "tomcat"
	source "solr/web.xml"
end

cookbook_file "/mnt/local/tomcat6/wars/solr.war" do
	mode "0755"
	owner "tomcat"
	group "tomcat"
	source "solr/apache-solr-3.4.0.war"
end


cookbook_file "/etc/tomcat6/tomcat6.conf" do
    mode "0755"
    owner "root"
    group "root"
    if(node.chef_environment == "prod")
        source "solr/tomcat6.conf.prod"
    else
        source "solr/tomcat6.conf"
    end
end

cookbook_file "/mnt/local/solr/solr.xml" do
	mode "0755"
	owner "tomcat"
	group "tomcat"
	source "solr/solr.xml"
	action :create_if_missing
end

cookbook_file "/mnt/local/tomcat6/conf/Catalina/localhost/solr.xml" do
	mode "0755"
	owner "tomcat"
	group "tomcat"
	source "solr/solr.xml.tomcat"
end

cron "member_delta_index" do
	minute "*/2"
	command 'curl localhost:8080/solr/members/dataimport?command=full-import\&clean=false > /root/member_index_results.txt'
            #(need to use the single quotes here so the / escape character makes it into the crontab itself)
end

cron "decalz_delta_index" do
	minute "*/2"
	command 'curl localhost:8080/solr/decalz/dataimport?command=full-import\&clean=false > /root/decalz_index_results.txt'
            #(need to use the single quotes here so the / escape character makes it into the crontab itself)
end

cron "decalz_full_index" do
	hour "3"
	minute "0"
	command 'curl localhost:8080/solr/decalz/dataimport?command=full-import'
end

cron "video_full_index" do
	minute "*/10"
	command 'curl localhost:8080/solr/video/dataimport?command=full-import > /root/video_index_results.txt'
end

script "initialize_cores" do   ## have to use a script because the curl commands are conditional on tomcat fully restarting first
  interpreter "bash"
  user "root"
  not_if {File.exists?("/mnt/local/solr/data/decalz")}  ## This script is technically idempodent but we don't want to restart tomcat needlessly
  cwd "/tmp"
  code <<-EOH
  service tomcat6 restart
  echo "Waiting for tomcat to start up..."
  sleep 10
  curl "http://localhost:8080/solr/admin/cores?action=CREATE&name=decalz&instanceDir=/mnt/local/solr/conf/decalz"
  curl "http://localhost:8080/solr/admin/cores?action=CREATE&name=members&instanceDir=/mnt/local/solr/conf/members"
  curl "http://localhost:8080/solr/admin/cores?action=CREATE&name=video&instanceDir=/mnt/local/solr/conf/video"
  echo "Cores have been initialized and are ready for indexing"
  EOH
end

##  To index initially, manually run:
##  curl "http://localhost:8080/solr/decalz/dataimport?command=full-import"
##  curl "http://localhost:8080/solr/members/dataimport?command=full-import"
##  curl "http://localhost:8080/solr/video/dataimport?command=full-import"

##  ... however, if this is not done, the cron jobs should eventually index them all one way or another regardless.
