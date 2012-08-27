##
# Core ldap items.
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

package "openldap-clients"
package "openldap-servers"

directory "/etc/openldap" do
	mode "0755"
	owner "ldap"
	group "ldap"
	recursive true
end

directory "/etc/openldap/schema" do
	owner "ldap"
	group "ldap"
	recursive true
end

directory "/etc/openldap/ssl" do
	owner "ldap"
	group "ldap"
	recursive true
end

directory "/mnt/local/lockerz.com/logs/ldap" do
	owner "ldap"
	group "ldap"
	recursive true
end

## Data is stored on the ephemeral disk and backed up to the ebs volume
directory "/mnt/local/ldap" do
	owner "ldap"
	group "ldap"
end

## Backups
directory "/mnt/ebs/lockerz.com/backups/ldap" do
	owner "ldap"
	group "ldap"
	recursive true
end

cookbook_file "/etc/sysconfig/ldap" do
	mode "0755"
	owner "ldap"
	group "ldap"
	source "sysconfig/ldap"
end

cookbook_file "/etc/openldap/ssl/server.pem" do 
	mode "0600"
	owner "ldap"
	group "ldap"
	source "ssl/server.pem"
end

["nis","openldap","ppolicy","duaconf","dyngroup","inetorgperson","java","misc","nadf","cosine","corba","core","autofs","collective"].each do |schemaFilename|
	cookbook_file "/etc/openldap/schema/%s.schema" % schemaFilename do 
		mode "755"
		source "schema/%s.schema" % schemaFilename
	end
end
