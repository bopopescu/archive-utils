# Mail Checks


nagios_service "checkPostfixQueue" do
	hostgroup "prod.postfix"
	register true
	check_command "check_nrpe!checkPostfixQueue"
	contact_groups "opz"
	use_nagios_service "generic-service"
	service_description "Check Postfix Queue Status"
	notifications_enabled true
end

nagios_service "checkSmtp" do
	hostgroup "prod.postfix"
	register true
	check_command "check_nrpe!checkSmtp"
	contact_groups "opz"
	use_nagios_service "generic-service"
	service_description "Check SMTP Port 25 for Availability"
	notifications_enabled true
end
