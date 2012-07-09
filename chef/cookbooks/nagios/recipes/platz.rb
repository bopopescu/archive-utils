##
# Platz checks - this file defines what's in the nagios server's config
# 
#
# All platz boxes checks:
# * NRPE check_chef_client_procs
# * NRPE check_nrsysmond_procs
# * NRPE check_root_disk
# * NRPE check_cpu
# * NRPE check_memory

# Apps servers checks:
# * port 80 HTTP string "Sign In"
# * port 8080 HTTP status code 401
# * API health check
# * NRPE check_apache_procs
# * NRPE check_platz_procs

# Redis servers checks:
# * NRPE check_redis_proc_6379
# * check redis disk flush delay
# * check redis replication
# * check redis any other health checks

# Shop servers checks:
# * NRPE check_apache_procs
# * port 80 HTTP

# Shop DB servers checks:
# * NRPE check_disk_mnt
# * NRPE check_disk_vol
# * NRPE mysql process
# * mysql health

# Admin servers checks:
# * /admin/login = Giddy up
# * API health check

nagios_service "check_platz_nrsysmond_procs" do
	hostgroup "platz.platz_apps,platz.platz_redis,platz.platz_admin"
	register true
	check_command "check_nrpe!check_nrsysmond_procs"
	contact_groups "platz"
	use_nagios_service "lockerz_service"
	service_description "nrsysmond running"
	notifications_enabled true
end

nagios_service "check_platz_disk_root" do
	hostgroup "platz.platz_apps,platz.platz_redis,platz.platz_admin"
	register true
	check_command "check_nrpe!check_disk_root"
	contact_groups "platz"
	use_nagios_service "lockerz_service"
	service_description "/ Filesystem"
	notifications_enabled true
end

nagios_service "check_platz_disk_mnt" do
	hostgroup "platz.platz_apps,platz.platz_redis,platz.platz_admin"
	register true
	check_command "check_nrpe!check_disk_mnt"
	contact_groups "platz"
	use_nagios_service "lockerz_service"
	service_description "/mnt Filesystem"
	notifications_enabled true
end

nagios_service "check_platz_cpu" do
	hostgroup "platz.platz_apps,platz.platz_redis,platz.platz_admin"
	register true
	check_command "check_nrpe!check_cpu"
	contact_groups "platz"
	use_nagios_service "lockerz_service"
	service_description "CPU"
	notifications_enabled true
end

nagios_service "check_platz_memory" do
	hostgroup "platz.platz_apps,platz.platz_redis,platz.platz_admin"
	register true
	check_command "check_nrpe!check_memory"
	contact_groups "platz"
	use_nagios_service "lockerz_service"
	service_description "Memory"
	notifications_enabled true
end

nagios_service "check_platz_chef_client_procs" do
	hostgroup "platz.platz_apps,platz.platz_redis,platz.platz_admin"
	register true
	check_command "check_nrpe!check_chef_client_procs"
	contact_groups "platz"
	use_nagios_service "lockerz_service"
	service_description "Chef client process running"
	notifications_enabled true
end

# Check non-signed in pegasus home page
#/usr/lib64/nagios/plugins/check_http -I apps01.platz.lockerz.int -H lockerz.com -s "Sign In"
#HTTP OK: HTTP/1.1 200 OK - 11666 bytes in 0.106 second response time |time=0.105675s;;;0.000000 size=11666B;;;0
nagios_service "check_platz_apps_pegasus" do
	hostgroup "platz.platz_apps"
	register true
	check_command "check_http_content!lockerz.com!/!\"Sign In\""
	contact_groups "platz"
	use_nagios_service "lockerz_service"
	service_description "Pegasus home page"
	notifications_enabled true
end

# Check platz API 
#/usr/lib64/nagios/plugins/check_http -I apps01.platz.lockerz.int -H lockerz.com -p 8080 -e 401
#HTTP OK: Status line output matched "401" - 366 bytes in 0.008 second response time |time=0.008213s;;;0.000000 size=366B;;;0

nagios_service "check_platz_api" do
	hostgroup "platz.platz_apps"
	register true
	check_command "check_http_port_expect!8080!401"
	contact_groups "platz"
	use_nagios_service "lockerz_service"
	service_description "Platz API"
	notifications_enabled true
end

nagios_service "check_platz_api_health" do
	hostgroup "platz.platz_apps"
	register true
	check_command "check_platz_api"
	contact_groups "platz"
	use_nagios_service "lockerz_service"
	service_description "Platz API Health"
	notifications_enabled true
end

nagios_service "check_platz_apache_procs" do
	hostgroup "platz.platz_apps"
	register true
	check_command "check_nrpe!check_apache_procs"
	contact_groups "platz"
	use_nagios_service "lockerz_service"
	service_description "Apache processes"
	notifications_enabled true
end

nagios_service "check_shop_apache_procs" do
	hostgroup "platz.platz_shop"
	register true
	check_command "check_nrpe!check_shop_apache_procs"
	contact_groups "shop"
	use_nagios_service "lockerz_service"
	service_description "Apache processes"
	notifications_enabled true
end


nagios_service "check_platz_platz_proc" do
	hostgroup "platz.platz_apps"
	register true
	check_command "check_nrpe!check_platz_procs"
	contact_groups "platz"
	use_nagios_service "lockerz_service"
	service_description "Platz uber process"
	notifications_enabled true
end

# Redis
nagios_service "check_platz_redis_proc_6379" do
	hostgroup "platz.platz_redis"
	register true
	check_command "check_nrpe!check_redis_proc_6379"
	contact_groups "platz"
	use_nagios_service "lockerz_service"
	service_description "redis 6379 process"
	notifications_enabled true
end


# Shop
nagios_service "check_platz_shop_nrsysmond_procs" do
	hostgroup "platz.platz_shop"
	register true
	check_command "check_nrpe!check_nrsysmond_procs"
	contact_groups "shop"
	use_nagios_service "lockerz_service"
	service_description "nrsysmond running"
	notifications_enabled true
end

nagios_service "check_platz_shop_disk_root" do
	hostgroup "platz.platz_shop,platz.platz_shopdb"
	register true
	check_command "check_nrpe!check_disk_root"
	contact_groups "shop"
	use_nagios_service "lockerz_service"
	service_description "/ Filesystem"
	notifications_enabled true
end

nagios_service "check_platz_shop_cpu" do
	hostgroup "platz.platz_shop"
	register true
	check_command "check_nrpe!check_cpu"
	contact_groups "shop"
	use_nagios_service "lockerz_service"
	service_description "CPU"
	notifications_enabled true
end

nagios_service "check_platz_shop_memory" do
	hostgroup "platz.platz_shop"
	register true
	check_command "check_nrpe!check_memory"
	contact_groups "shop"
	use_nagios_service "lockerz_service"
	service_description "Memory"
	notifications_enabled true
end

nagios_service "check_platz_shop_chef_client_procs" do
	hostgroup "platz.platz_shop"
	register true
	check_command "check_nrpe!check_chef_client_procs"
	contact_groups "shop"
	use_nagios_service "lockerz_service"
	service_description "Chef client process running"
	notifications_enabled true
end

nagios_service "check_platz_shop_http" do
	hostgroup "platz.platz_shop"
	register true
	check_command "check_http_content!shop.lockerz.com!/!\"Shop @ Lockerz\""
	contact_groups "shop"
	use_nagios_service "lockerz_service"
	service_description "shop home page"
	notifications_enabled true
end

nagios_service "check_platz_shop_disk_mnt" do
	hostgroup "platz.platz_shop"
	register true
	check_command "check_nrpe!check_disk_mnt"
	contact_groups "shop"
	use_nagios_service "lockerz_service"
	service_description "/mnt Filesystem"
	notifications_enabled true
end

# Shop DB
nagios_service "check_platz_shopdb_cpu" do
	hostgroup "platz.platz_shopdb"
	register true
	check_command "check_nrpe!check_cpu"
	contact_groups "shop"
	use_nagios_service "lockerz_service"
	service_description "CPU"
	notifications_enabled true
end

nagios_service "check_platz_shopdb_memory" do
	hostgroup "platz.platz_shopdb"
	register true
	check_command "check_nrpe!check_memory"
	contact_groups "shop"
	use_nagios_service "lockerz_service"
	service_description "Memory"
	notifications_enabled true
end

nagios_service "check_platz_shopdb_mysql_proc" do
	hostgroup "platz.platz_shopdb"
	register true
	check_command "checkMySQLProcess"
	contact_groups "shop"
	use_nagios_service "lockerz_service"
	service_description "MySQL process running"
	notifications_enabled true
end

nagios_service "check_platz_shopdb_mysql" do
	hostgroup "platz.platz_shopdb"
	register true
	check_command "check_nrpe!check_mysql"
	contact_groups "shop"
	use_nagios_service "lockerz_service"
	service_description "MySQL status"
	notifications_enabled true
end

nagios_service "check_platz_shopdb_mysql_slow_queries" do
	hostgroup "platz.platz_shopdb"
	register true
	check_command "mysql_slow_queries!Qq7V3ktyKxCUHpwKockrwLhBSiyk4rU"
	contact_groups "shop"
	use_nagios_service "lockerz_service"
	service_description "MySQL Slow Queries"
	notifications_enabled true
end

nagios_service "check_platz_shopdb_mysql_long_procs" do
	hostgroup "platz.platz_shopdb"
	register true
	check_command "mysql_long_procs!Qq7V3ktyKxCUHpwKockrwLhBSiyk4rU"
	contact_groups "shop"
	use_nagios_service "lockerz_service"
	service_description "MySQL Long Running Threads"
	notifications_enabled true
end

nagios_service "check_platz_shopdb_disk_mnt" do
	hostgroup "platz.platz_shopdb"
	register true
	check_command "check_nrpe!check_disk_mnt"
	contact_groups "shop"
	use_nagios_service "lockerz_service"
	service_description "/mnt Filesystem"
	notifications_enabled true
end

nagios_service "check_platz_shopdb_disk_vol" do
	hostgroup "platz.platz_shopdb"
	register true
	check_command "check_nrpe!check_disk_vol"
	contact_groups "shop"
	use_nagios_service "lockerz_service"
	service_description "/vol Filesystem"
	notifications_enabled true
end

# Admin
nagios_service "check_platz_admin_login" do
	hostgroup "platz.platz_admin"
	register true
	check_command "check_https_port_uri_string!8443!/admin/login!Giddy up"
	contact_groups "platz"
	use_nagios_service "lockerz_service"
	service_description "admin login"
	notifications_enabled true
end

nagios_service "check_platz_admin_api_health" do
	hostgroup "platz.platz_admin"
	register true
	check_command "check_platz_api_secure_port!8443"
	contact_groups "platz"
	use_nagios_service "lockerz_service"
	service_description "api health"
	notifications_enabled false
end
