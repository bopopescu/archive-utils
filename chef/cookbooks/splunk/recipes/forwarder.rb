##
# Splunk forwarder recipe
#
# @author   Bernard ( bernard@sprybts.com )
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

if node.attribute?("ec2") and  node.ec2.attribute?("userdata") and not (node.ec2.userdata.nil? or node.ec2.userdata.empty?)
	json = JSON.parse( node[:ec2]["userdata"] )
elsif node.chef_environment="platz"
	if node[:fqdn] =~ /[0-9.]+/
		# This fakes the role to be the start of the hostname up to the first digit or dot
		json = { "roleName" => node[:fqdn][0,node[:fqdn] =~ /[0-9.]+/], "stackName" => "platz" }
	else
		raise "platz node role can't be determined from fqdn %s"%(node[:fqdn])
	end
else
	raise "The splunk::forwarder recipe can only handle hosts with a json string in ec2 userdata, and platz boxes"
end

user "splunk" do
	shell "/bin/false"
	system true
	comment "splunk user"
end 

# We have the splunkforwarder package avaiable in our centos repo
package "splunkforwarder" do
	action :install
        only_if { node[:platform] == "centos" }
end

# We don't have a repo for ubuntu yet, so we'll install the package from a deb file
deb="splunkforwarder-4.3.1-119532-linux-2.6-amd64.deb"

bash "install_splunkforwarder_deb" do
	action :nothing
	user "root"
	cwd "/var/tmp"
	code <<-EOH
	dpkg -i "#{deb}"
	EOH
end

cookbook_file "/var/tmp/#{deb}" do
	mode 0444
	source deb
	only_if { node[:platform] == "ubuntu" }
	notifies :run, resources(:bash => "install_splunkforwarder_deb"), :immediately
end

directory "#{node[:splunkforwarder][:root]}/etc/system/local/" do
	mode 0755
	owner "splunk"
	group "splunk"
	recursive true
end

directory "#{node[:splunkforwarder][:root]}/etc/apps/search/local/" do
	mode 0755
	owner "splunk"
	group "splunk"
	recursive true
end

cookbook_file "#{node[:splunkforwarder][:root]}/etc/system/local/fields.conf" do
	mode 0444
	owner "splunk"
	group "splunk"
	source "splunk/forwarder/fields.conf"
end

## Outputs
forwarders = search( :node,'run_list:recipe\[splunk\:\:server\]' )
template "#{node[:splunkforwarder][:root]}/etc/system/local/outputs.conf" do
	mode 0444
	owner "splunk"
	group "splunk"
	source "outputs.conf.erb"
	variables(
		:port => node[:splunkserver][:forwarderport],
		:forwarders => forwarders
	)
	notifies :restart, "service[splunk]", :delayed
end

## Setup data source monitors
monitors = Hash.new
if node.attribute?("splunk")
	if node.splunk.attribute?("monitors")
		node.splunk.monitors.each_pair do |k,v|
			monitors[k] = v
		end
	end
end

template "#{node[:splunkforwarder][:root]}/etc/apps/search/local/inputs.conf" do
	mode 0444
	owner "splunk"
	group "splunk"
	source "forwarder-inputs.conf.erb"
	notifies :reload, "service[splunk]", :delayed
	variables( :monitors => monitors)
end

template "#{node[:splunkforwarder][:root]}/etc/apps/search/local/props.conf" do
	mode 0444
	owner "splunk"
	group "splunk"
	source "forwarder-props.conf.erb"
	notifies :reload, "service[splunk]", :delayed
	variables( :monitors => monitors)
end

template "#{node[:splunkforwarder][:root]}/etc/system/local/inputs.conf" do
	mode 0444
	owner "splunk"
	group "splunk"
	source "system-inputs.conf.erb"
	variables(
		:node => node,
		:roleName => json["roleName"],
		:stackName => json["stackName"]
	)
	notifies :reload, "service[splunk]", :delayed
end

# Only do this on the initial install
script "splunk-initial-install" do
	cwd "#{node[:splunkforwarder][:root]}"
	user "root"
	code <<-EOH
		./bin/splunk start splunkd --accept-license # start splunk and accept license
		./bin/splunk enable boot-start # enable auto start on reboot
	EOH
	not_if "test -f /etc/init.d/splunk"
	interpreter "bash"
end

## Service config
service "splunk" do
	action [ :start ]
	running true
	supports :status => true, :restart => true, :reload => true
	stop_command "#{node[:splunkforwarder][:root]}/bin/splunk stop"
	start_command "#{node[:splunkforwarder][:root]}/bin/splunk start --accept-license"
	status_command "#{node[:splunkforwarder][:root]}/bin/splunk status"
	reload_command "/usr/bin/wget https://localhost:8089/services/data/inputs/monitor/_reload --post-data '' --no-check-certificate --user admin --password changeme -O -"
	restart_command "#{node[:splunkforwarder][:root]}/bin/splunk restart --accept-license"
end

