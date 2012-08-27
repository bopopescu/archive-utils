##
# Cookbook Name:: bind
# Recipe:: server
#
include_recipe "bind::default"

cookbook_file "/etc/named.conf" do
	mode "0755"
	owner "named"
	group "named"
	source "named.conf"
	notifies :reload, resources(:service => "named")
end

cookbook_file "/etc/named.lockerz.zones" do
	mode "0755"
	owner "named"
	group "named"
	source "named.lockerz.zones"
	notifies :reload, resources(:service => "named")
end

cookbook_file "/etc/named.rfc1912.zones" do
	mode "0755"
	owner "named"
	group "named"
	source "named.rfc1912.zones"
	notifies :reload, resources(:service => "named")
end

## forward zone is for lockerz.int reverse zone is for 10.in-addr.arpa
## Ideally, we'd be able to generate reverse lookups for the hosts that
## scalr manages, but for now, scalr hosts will see scalr hosts in reverse
## lookups and chef hosts will see chef hosts.

hosts = []
search(:node, "*:*") {|n| hosts << n }
nameservers = []
search(:node, "fqdn:auth*.opz.prod.lockerz.us") {|n| nameservers << n }
serial = Time.now.strftime("%Y%m%d%H%M%S")

template "/var/named/lockerz.int.zone" do
  source "forward.erb"
  mode 0644
  owner "named"
  group "named"
  backup 0
  variables({
	:hosts => hosts,
	:serial => serial,
	:nameservers => nameservers
  })
  notifies :reload, resources(:service => "named")
end

template "/var/named/10.in-addr.arpa.zone" do
  source "reverse.erb"
  mode 0644
  owner "named"
  group "named"
  backup 0
  variables({
	:hosts => hosts,
	:nameservers => nameservers,
	:serial => serial
  })
  notifies :reload, resources(:service => "named")
end


