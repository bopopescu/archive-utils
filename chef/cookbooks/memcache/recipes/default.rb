#
# Cookbook Name:: memcache
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

MemcDefaultPort = 11211

package "memcached" do
	action :install
	package_name "memcached"
end

cookbook_file "/etc/init.d/memcached" do
	mode "0755"
	owner "root"
	group "root"
	source "memcached"
end

if(node[:num_servers] != nil && node[:num_servers].to_i.size > 0 )
	node[:num_servers].to_i().times do |i|
		port = (MemcDefaultPort+i)

		template "/etc/init.d/memcached_%i" % port do
			mode "0755"
			owner "root"
			group "root"
			source "init.erb"
			variables({ :port => port, :opts => "" })
		end

		service "memcached_%i" % port do
			action [ :enable, :start ]
			supports :restart => true, :reload => true
		end
	end

end

