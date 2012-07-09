##
# MongoDB server
include_recipe "mongodb::default"

## Init script
cookbook_file "/etc/init.d/mongod" do
	mode "0755"
	owner "root"
	group "root"
	source "mongo_server.service"
end

## Config file
template "/etc/mongo/mongod.conf" do
	mode "0755"
	owner "root"
	group "root"
	source "master.erb"
	#variables({
		#:source => node["source"]
	#})
end

