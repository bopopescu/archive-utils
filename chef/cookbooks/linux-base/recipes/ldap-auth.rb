##
# LDAP client authentication
#
# @author   Bryan Kroger ( bryan@lockerz.com )

if(node[:fqdn] != nil && !node[:fqdn].match( /^auth/ )) ## quick hack
	cookbook_file "/etc/nsswitch.conf" do
		mode "0755"
		owner "root"
		group "root"
		source "ldap_auth/nsswitch.conf"
	end
end

if(node.fqdn == "jira0.opz.prod.lockerz.us")

ldap_client

else
cookbook_file "/etc/ldap.conf" do
	mode "0755"
	owner "root"
	group "root"
	source "ldap_auth/ldap.conf"
end

group "ldap"
user "ldap" do
	group "ldap"
	shell "/bin/false"
end

directory "/etc/openldap" do
	mode "0755"
	owner "ldap"
	group "ldap"
	action :create
	recursive true
end

cookbook_file "/etc/openldap/ldap.conf" do
	mode "0755"
	owner "root"
	group "root"
	source "ldap_auth/sys_ldap.conf"
end

cookbook_file "/etc/ldap.secret" do
	mode "0755"
	owner "root"
	group "root"
	source "ldap_auth/ldap.secret"
end
end

if(node[:platform] == "ubuntu")
	package "pam_ldap" do
		action :install
		package_name "libpam-ldapd"
	end
else
	package "pam_ldap" do
		action :install
		package_name "nss_ldap"
	end
end

["account","auth","password","session","session-noninteractive"].each do |type|
	cookbook_file "/etc/pam.d/common-%s" % type do
		source "ldap_auth/pam.d/common-%s" % type
		owner "root"
		group "root"
		mode "0755"
	end
end

cookbook_file "/etc/pam.d/common" do
	source "ldap_auth/pam.d/common"
	owner "root"
	group "root"
	mode "0755"
end

link "/etc/pam.d/system-auth" do
	to "/etc/pam.d/system-auth-ldap"
end

cookbook_file "/etc/pam.d/nginx" do
	source "ldap_auth/pam.d/nginx"
	owner "root"
	group "root"
	mode "0755"
end

pamFiles = [
"atd", "authconfig", "authconfig-tui", "chfn", "chsh", "config-util",
"crond", "ekshell", "gssftp", "halt", "kshell", "ksu", "login", "newrole",
"other", "passwd", "poweroff", "reboot", "remote", "run_init", "runuser",
"runuser-l", "screen", "setup", "smtp", "smtp.postfix", "smtp.sendmail",
"sshd", "su", "sudo", "sudo-i", "su-l", "system-auth-ac", "system-auth-ldap" ]

pamFiles.each do |pFile|
	cookbook_file "/etc/pam.d/%s" % pFile do
		source "ldap_auth/pam.d/%s" % pFile
		owner "root"
		group "root"
		mode "0755"
	end
end
