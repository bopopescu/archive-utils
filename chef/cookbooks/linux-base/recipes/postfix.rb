#
# Description
#	This installs the postfix MTA and configures the system to relay through "AuthSMTP",
#	also installs the mail client software "mail"

#execute "rebuild-postfix-maps" do
	#command "postmap hash:/etc/postfix/my-maps"
	#action :nothing
#end

package "postfix" do
	action :install
	package_name "postfix"
end

service "postfix" do
	supports :restart => true, :reload => true
	action [ :enable, :start ]
end

cookbook_file "/etc/postfix/main.cf" do
	mode 0444
	owner "root"
	group "root"
	source "postfix/main.cf"
	notifies :restart, resources(:service => "postfix")
end

