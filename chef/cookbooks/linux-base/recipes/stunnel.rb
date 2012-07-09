#
# Description:
#	Installs stunnel4
#
# The stunnel program is designed to work  as  SSL  encryption
# wrapper between remote client and local (inetd-startable) or
# remote server. The concept is that having non-SSL aware daemons
# running  on  your  system you can easily setup them to
# communicate with clients over secure SSL channel.
# 
# stunnel can be used to add  SSL  functionality  to  commonly
# used  inetd  daemons  like  POP-2,  POP-3  and  IMAP servers
# without any changes in the programs' code.

## This should actually be depricated since we don't use stunnel any more.

package "stunnel" do
	action :install
	package_name "stunnel"
end

cookbook_file "/etc/init.d/stunnel" do
	mode "755"
	owner "root"
	group "root"
	source "stunnel/init"
end

cookbook_file "/etc/stunnel/ldap.conf" do
	mode "755"
	owner "root"
	group "root"
	source "stunnel/ldap.conf"
end

