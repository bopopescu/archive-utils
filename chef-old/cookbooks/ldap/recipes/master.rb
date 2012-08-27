##
# slapd master configuration.
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

include_recipe "ldap::default"

admins = search( :lockerz,"id:opz").first()["users"]
replicaNodes = search( :node,"run_list:role\\[LDAPReplicator\\] AND chef_environment:opz" )
#puts "Replicators: %s" % replicaNodes.inspect

template "/etc/openldap/slapd.conf" do
	mode "755"
	owner "ldap"
	group "ldap"
	source "master.conf.erb"
	variables({
		:admins => admins,
		:replicaNodes => replicaNodes
	})
end

