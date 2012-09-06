##
# Cookbook Name:: bind
# Recipe:: server
#
include_recipe "bind::default"

cookbook_file "/etc/bind/named.conf" do
	mode "0755"
	owner "named"
	group "bind"
	source "named.conf"
	notifies :restart, resources(:service => "bind9")
end

cookbook_file "/etc/bind/named.conf.lockerz-zones" do
	mode "0755"
	owner "named"
	group "bind"
	source "named.conf.lockerz-zones"
	notifies :restart, resources(:service => "bind9")
end

cookbook_file "/etc/bind/named.conf.options" do
        mode "0755"
        owner "named"
        group "bind"
        source "named.conf.options"
        notifies :restart, resources(:service => "bind9")
end

# cookbook_file "/etc/bind/named.rfc1912.zones" do
# 	mode "0755"
# 	owner "named"
# 	group "bind"
# 	source "named.rfc1912.zones"
# 	notifies :reload, resources(:service => "bind9")
# end

## forward zone is for lockerz.int reverse zone is for 10.in-addr.arpa
## Ideally, we'd be able to generate reverse lookups for the hosts that
## scalr manages, but for now, scalr hosts will see scalr hosts in reverse
## lookups and chef hosts will see chef hosts.

hosts = []
search(:node, "*:*") {|n| hosts << n }
nameservers = []
search(:node, "fqdn:sys*.opz.prod.lockerz.int") {|n| nameservers << n }
serial = Time.now.strftime("%Y%m%d%H%M%S")

template "/etc/bind/db.lockerz" do
  source "forward.erb"
  mode 0644
  owner "named"
  group "bind"
  backup 0
  variables({
	:hosts => hosts,
	:serial => serial,
	:nameservers => nameservers
  })
  notifies :restart, resources(:service => "bind9")
end

template "/etc/bind/db.lockerz-reverse" do
  source "reverse.erb"
  mode 0644
  owner "named"
  group "bind"
  backup 0
  variables({
	:hosts => hosts,
	:nameservers => nameservers,
	:serial => serial
  })
  notifies :restart, resources(:service => "bind9")
end


