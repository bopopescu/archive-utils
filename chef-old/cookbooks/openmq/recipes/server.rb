##
# OpenMQ recipe
#
# NOTE ABOUT ACTIVEMQ (not sure if this applies to openmq or not yet)
# 
# It needs a host file entry pointing it's host name to it's internal IP address, otherwise jmx doesn't work right(tries to connect to external IP)
#

## TODO: move these to the attribute space
FSOpenMQPath = "/mnt/local/lockerz.com/openmq"
FSOpenMQPidPath = "/var/run/openmq"
FSOpenMQLogPath = "%s/logs" % FSOpenMQPath
FSOpenMQStatsPath = "%s/stats" % FSOpenMQPath

## Directories
directory FSOpenMQLogPath do
	mode "0775"
	owner "openmq"
	group "openmq"
	recursive true
end

directory FSOpenMQPidPath do
	mode "0775"
	owner "openmq"
	group "openmq"
	recursive true
end

directory FSOpenMQStatsPath do
	mode "0775"
	owner "openmq"
	group "openmq"
	recursive true
end

cookbook_file "/root/openmq-4.5.lockerz.tar.bz2" do
	source "openmq-4.5.lockerz.tar.bz2"
end

execute "Install openmq" do
	not_if File.exists?( "/usr/local/openmq-4.5/etc/mq/admin.pw" ).to_s()
	action :run
	command "tar -xjp -C /usr/local -f /root/openmq-4.5.lockerz.tar.bz2"
end

execute "Fix perms" do
	action :run
	command "chown -R openmq /usr/local/openmq-4.5/var/mq/*"
end

link "/usr/local/openmq" do
	to "/usr/local/openmq-4.5"
end

template "/etc/init.d/openmq" do
	mode "0755"
	owner "root"
	group "root"
	source "openmq.init.erb"
	variables({
		:fsOpenMQPath => FSOpenMQPath,
		:fsOpenMQPidPath => FSOpenMQPidPath,
		:fsOpenMQLogPath => FSOpenMQLogPath,
		:fsOpenMQStatsPath => FSOpenMQStatsPath
	})
end

