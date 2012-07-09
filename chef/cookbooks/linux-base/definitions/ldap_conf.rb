##
# LDAP client configuration setup
#
# @author   Bryan Kroger ( bryan@lockerz.com )

define :ldap_client do
	baseDN = "dc=lockerz,dc=com"
	rootBindDN = "uid=authdrone,ou=System,dc=lockerz,dc=com"
	ldapAdminSecret = "trlGOwvWDef0SMtI"

	opzUsers = search( :lockerz,"id:opz" ).first["users"]

	## Assemble the list of primary and secondary dns servers.
	ldapServers = {}
	# Primary ldap servers
	search( :node,'chef_environment:opz AND run_list:role\[LDAPMaster\]' ).each do |srv|
		ldapServers[srv.fqdn] = srv
	end
	# Secondary
	search( :node,'chef_environment:opz AND run_list:role\[LDAPReplicator\]' ).each do |srv|
		ldapServers[srv.fqdn] = srv
	end

	puts "LDAPServers: %i" % ldapServers.size

	template "/etc/ldap.conf" do
		mode "0755"
		owner "root"
		group "root"
		source "ldap_auth/ldap.conf.erb"
		variables({
			:baseDN => baseDN,
			:opzUsers => opzUsers,
			:rootBindDN => rootBindDN,
			:ldapServers => ldapServers
		})
	end

	directory "/etc/openldap" do
		mode "0755"
		owner "root"
		group "root"
		action :create
		recursive true
	end

	template "/etc/openldap/ldap.conf" do
		mode "0755"
		owner "root"
		group "root"
		source "ldap_auth/openldap.conf.erb"
		variables({
			:rootBindDN => rootBindDN,
			:ldapServers => ldapServers
		})
	end

	template "/etc/ldap.secret" do
		mode "0600"
		owner "root"
		group "root"
		source "ldap_auth/ldap.secret.erb"
		variables({
			:ldapAdminSecret => ldapAdminSecret
		})
	end

end
