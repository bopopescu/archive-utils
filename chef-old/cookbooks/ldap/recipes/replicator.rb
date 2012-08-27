##
# slurpd configuration.
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

include_recipe "ldap::default"

admins = search( :lockerz,"id:admins").first()["members"]

template "/etc/openldap/slapd.conf" do
	mode "755"
	owner "ldap"
	group "ldap"
	source "replicator.conf.erb"
	variables({
		:admins => admins
	})
end

