##
#
# Description:
#	This (re)configures chef to auto start on boot for runit systems
#	and creates a couple directories that chef needs, both should
#	really never be needed but it's here in case something else
#	disrupts the configuration

directory "/usr/local/sbin/chef" do
	mode "0755"
	owner "root"
	group "root"
end

execute "restart-chef-service" do
	action :nothing
	command "/etc/rc.d/init.d/chef restart"
end

cookbook_file "/etc/init.d/chef" do
	mode "0755"
	source "chef-base/etc/init.d/chef"
	#notifies :run, resources(:execute => "restart-chef-service"), :immediately
end


link "/etc/rc2.d/S60chef" do
	to "/etc/rc.d/init.d/chef"
end

link "/etc/rc2.d/K60chef" do
	to "/etc/rc.d/init.d/chef"
end

link "/etc/rc3.d/S60chef" do
	to "/etc/rc.d/init.d/chef"
end

link "/etc/rc3.d/K60chef" do
	to "/etc/rc.d/init.d/chef"
end

link "/etc/rc4.d/S60chef" do
	to "/etc/rc.d/init.d/chef"
end

link "/etc/rc4.d/K60chef" do
	to "/etc/rc.d/init.d/chef"
end

link "/etc/rc5.d/S60chef" do
	to "/etc/rc.d/init.d/chef"
end

link "/etc/rc5.d/K60chef" do
	to "/etc/rc.d/init.d/chef"
end

directory "/var/log/chef" do
	mode "0755"
	owner "root"
	group "root"
	action :create
end

directory "/var/chef" do
	mode "0755"
	owner "root"
	group "root"
	action :create
end

