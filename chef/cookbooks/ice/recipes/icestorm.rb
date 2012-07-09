include_recipe "ice::ice331"


###
# Directories
###

directory "/mnt/logs" do
	recursive false
	owner "root"
	group "loguser"
	mode "0775"
end

directory "/var/run/icestorm" do
	recursive false
	owner "root"
	group "ice"
	mode "0775"
end

directory "/mnt/logs/icestorm" do
	recursive false
	owner "ice"
	group "loguser"
	mode "0775"
end

directory "/var/lib/icestorm/db" do
	recursive true
	owner "ice"
	group "ice"
	mode "0755"
end

directory "/etc/icestorm" do
	recursive false
	owner "root"
	group "root"
	mode "0755"
end

# Reminder for future upgrades:
# need logic for removing deployed webapp and auto restarting tomcat
cookbook_file "/etc/icestorm/icestorm.config" do
	source "icestorm/#{node['lockerz']['environment'].first}/#{node['fqdn'].first}/icestorm.config"
	owner "root"
	group "ice"
	mode "0440"
end

cookbook_file "/etc/icestorm/icestorm.config.admin" do
	source "icestorm/#{node['lockerz']['environment'].first}/#{node['fqdn'].first}/icestorm.config.admin"
	owner "root"
	group "ice"
	mode "0440"
end

cookbook_file "/etc/init.d/icestorm" do
	source "icestorm/#{node['lockerz']['environment'].first}/init.d/icestorm"
	owner "root"
	group "root"
	mode "0554"
end

cookbook_file "/etc/icestorm/icebox.config" do
	source "icestorm/#{node['lockerz']['environment'].first}/icebox/icebox.config"
	owner "root"
	group "root"
	mode "0444"
end

cookbook_file "/usr/local/bin/ICEstormadmin" do
	source "icestorm/#{node['lockerz']['environment'].first}/scripts/ICEstormadmin"
	owner "root"
	group "root"
	mode "0755"
end
