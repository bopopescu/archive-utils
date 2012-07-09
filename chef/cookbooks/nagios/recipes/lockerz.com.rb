# recipe to configure high level health checks for the user visible interfaces of lockerz.com

# lockerz.com - check the DNS, check the site is up, check the SSL cert is valid
# shop.lockerz.com - check the DNS, check the site is up, check the SSL cert is valid
# secure.lockerz.com - check the DNS, check the site is up, check the SSL cert is valid
# api.lockerz.com - check the DNS, check the API is up, check the SSL cert is valid
# Would be good to build in an ELB status check for these too - warn if > 1 unhealthy instance or <=1 healthy instance, crit if 0 healthy

nagios_host "lockerz.com" do
	address "lockerz.com"
	use_nagios_host "noping_lockerz_host"
	notifications_enabled false
end

nagios_host "shop.lockerz.com" do
	address "shop.lockerz.com"
	use_nagios_host "noping_lockerz_host"
	notifications_enabled false
end

nagios_host "secure.lockerz.com" do
	address "secure.lockerz.com"
	use_nagios_host "noping_lockerz_host"
	notifications_enabled false
end

nagios_host "api.lockerz.com" do
	address "api.lockerz.com"
	use_nagios_host "noping_lockerz_host"
	notifications_enabled false
end

nagios_service "secure_site_check" do
        hosts "secure.lockerz.com"
        register true
        contacts "ops@lockerz.com"
        check_command "check_http_port_expect!80!301"
        use_nagios_service "lockerz_service"
        service_description "http redirects to lockerz.com"
        notifications_enabled false
end

nagios_service "cert_check" do
        hosts "lockerz.com, shop.lockerz.com, secure.lockerz.com, api.lockerz.com"
        register true
        contacts "ops@lockerz.com"
        check_command "check_https_cert"
        use_nagios_service "lockerz_service"
        service_description "SSL Cert is valid"
        notifications_enabled false
end

nagios_service "shop_check" do
        hosts "shop.lockerz.com"
        register true
        contacts "ops@lockerz.com"
        check_command "check_http_content!shop.lockerz.com!/!\"Shop @ Lockerz\""
        use_nagios_service "lockerz_service"
        service_description "says Shop @ Lockerz"
        notifications_enabled false
end


nagios_service "content_check" do
        hosts "lockerz.com"
        register true
        contacts "ops@lockerz.com"
        check_command "check_http_content!lockerz.com!/!\"Tastemakers\""
        use_nagios_service "lockerz_service"
        service_description "says Tastemakers"
        notifications_enabled false
end

