##
# MongoDB slave
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
	owner "root"
	group "root"
	mode "0755"
	source "slave.erb"
	variables({
		:source => node["source"]
	})
end
