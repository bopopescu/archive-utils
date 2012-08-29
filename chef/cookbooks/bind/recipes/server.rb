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
<<<<<<< HEAD
	notifies :restart, resources(:service => "bind9")
=======
	notifies :reload, resources(:service => "bind9")
>>>>>>> b2145a077f37a478998148d5b822f3f00f28e2b0
end

cookbook_file "/etc/bind/named.conf.lockerz-zones" do
	mode "0755"
	owner "named"
	group "bind"
	source "named.conf.lockerz-zones"
<<<<<<< HEAD
	notifies :restart, resources(:service => "bind9")
=======
	notifies :reload, resources(:service => "bind9")
>>>>>>> b2145a077f37a478998148d5b822f3f00f28e2b0
end

# cookbook_file "/etc/bind/named.rfc1912.zones" do
# 	mode "0755"
# 	owner "named"
# 	group "bind"
# 	source "named.rfc1912.zones"
<<<<<<< HEAD
# 	notifies :reload, resources(:service => "bind")
=======
# 	notifies :reload, resources(:service => "bind9")
>>>>>>> b2145a077f37a478998148d5b822f3f00f28e2b0
# end

## forward zone is for lockerz.int reverse zone is for 10.in-addr.arpa
## Ideally, we'd be able to generate reverse lookups for the hosts that
## scalr manages, but for now, scalr hosts will see scalr hosts in reverse
## lookups and chef hosts will see chef hosts.

hosts = []
search(:node, "*:*") {|n| hosts << n }
nameservers = []
<<<<<<< HEAD
search(:node, "fqdn:sys*.opz.prod.lockerz.int") {|n| nameservers << n }
=======
search(:node, "fqdn:auth*.opz.prod.lockerz.us") {|n| nameservers << n }
>>>>>>> b2145a077f37a478998148d5b822f3f00f28e2b0
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
<<<<<<< HEAD
  notifies :restart, resources(:service => "bind9")
=======
  notifies :reload, resources(:service => "bind9")
>>>>>>> b2145a077f37a478998148d5b822f3f00f28e2b0
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
<<<<<<< HEAD
  notifies :restart, resources(:service => "bind9")
=======
  notifies :reload, resources(:service => "bind9")
>>>>>>> b2145a077f37a478998148d5b822f3f00f28e2b0
end


