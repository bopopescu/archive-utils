##
# MongoDB server
include_recipe "mongodb::default"

package "mongo-server" do
	package_name "mongo-10gen-server"
	action :install
end

cookbook_file "/etc/init.d/mongod" do
	source "mongod.init"
	owner "root"
	group "root"
	mode "0755"
end

template "/etc/mongo/mongod.conf" do
	source "master.erb"
	owner "root"
	group "root"
	mode "0755"
end

directory "/mnt/local/lockerz.com/logs/mongodb" do
	owner "mongod"
	group "mongod"
	mode "0775"
	recursive true
end

directory "/mnt/ebs/lockerz.com/data/mongodb/" do
	owner "mongod"
	group "mongod"
	mode "0755"
	recursive true
end

