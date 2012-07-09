##
# SMTP Relay service using authsmtp.
#
# @TODO: replace all ref's to "/etc/postfix" with an attribute.
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com
include_recipe "smtp::default"

envName = node.chef_environment

## Postfix service def
service "postfix" do
	supports :restart => true, :reload => true
	action :enable
end

## This will compile the sasl password into a postfix-friendly db file.
execute "postmap sasl_passwd" do
	action :nothing
	command "postmap /etc/postfix/sasl_passwd.authsmtp"
end

## SASL password for authsmtp.
cookbook_file "/etc/postfix/sasl_passwd.authsmtp" do
	mode "0755"
	owner "root"
	group "root"
	source "sasl_passwd.authsmtp"
	notifies :run,"execute[postmap sasl_passwd]",:immediately
	notifies :restart,"service[postfix]"
end

## Main postfix configuration file.
template "/etc/postfix/main.cf" do
	mode "0755"
	owner "root"
	group "root"
	source "main.cf.erb"
	notifies :restart,"service[postfix]"
	variables({
		:hostname => (envName == "prod" ? "lockerz.com" : "%s.lockerz.us" % envName)
	})
end

## This will compile the canonical map into a postfix-friendly db file.
execute "postmap canonical" do
	action :nothing
	command "postmap /etc/postfix/canonical"
end

## Canonical file to map the hostname to an approved authsmtp from address.
template "/etc/postfix/canonical" do
	mode "0755"
	owner "root"
	group "root"
	source "canonical.erb"
	notifies :run,"execute[postmap canonical]",:immediately
	notifies :restart,"service[postfix]"
end

## Same thing as above, but this ensures that the file will be created
#	if it doesn't actually exist.
execute "create canonical db" do
	not_if "test -f /etc/postfix/canonical.db"
	command "postmap /etc/postfix/canonical"
end
