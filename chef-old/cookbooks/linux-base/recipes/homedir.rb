##
# Home directory server
#
# @author   Bryan Kroger ( bryan@lockerz.com )
gem "ruby-net-ldap" do
	action :install
end
require 'net/ldap'

cookbook_file "/etc/exports" do
	mode "0755"
	owner "root"
	group "root"
	source "homedir/exports"
end


ldap = Net::LDAP.new({
	:host => "auth0.opz.prod.lockerz.int",
	:port => 636,
	:auth => {
		:method => :simple,
		:username => "cn=admin,dc=lockerz,dc=com",
		:password => "lat8-towards"
	},
	:verbose => false,
	:encryption => :simple_tls
})
res = ldap.bind()


## Get groups
treebase = "dc=lockerz,dc=com"
ldapGroups = {}
filter = Net::LDAP::Filter.eq( "objectClass", "posixGroup" )
ldap.search( :base => treebase, :filter => filter ) do |ldapGroup|
	#ldapGroups[ldapGroup[:cn][0]] = ldapGroup
	ldapGroups[ldapGroup[:gidNumber][0].to_i()] = ldapGroup
end

filter = Net::LDAP::Filter.eq( "objectClass", "posixAccount" )
treebase = "dc=lockerz,dc=com"
ldapUsers = {}
filter = Net::LDAP::Filter.eq( "objectClass", "posixAccount" )
ldapUsers = ldap.search( :base => treebase, :filter => filter )

ldapUsers.each do |ldapUser|
	next if(ldapUser[:dn][0].match( /System/ ))
	uid = ldapUser[:uid][0]
	filter = Net::LDAP::Filter.eq( "cn",uid )
	treebase = "dc=lockerz,dc=com"
	autoCheck = ldap.search( :base => treebase, :filter => filter )
	#Log.verbose( "AutoCheck",7 ){ autoCheck.count }
	if(autoCheck.count == 0)
		#Log.fatal( "No automount entry for this user" ){ uid }
		puts "No automount entry for this user: %s" % uid 
	else
		directory "/mnt/ebs/home/%s" % uid do
			mode "0700"
			owner uid
			group ldapGroups[ldapUser[:gidnumber][0].to_i()][:cn][0]
		end
	end
end



