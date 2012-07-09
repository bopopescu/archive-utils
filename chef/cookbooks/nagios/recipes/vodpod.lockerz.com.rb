##
# Vodpod
#
# https://lockerz.jira.com/wiki/display/VODPOD/Vodpod+Server+Roles
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

envName = "prod"

## Setup our hosts
nagios_host "vodpod.com" do
	address "vodpod.com"
	use_nagios_host "lockerz_host"
	notifications_enabled true
end

nagios_host "api.vodpod.com" do
	address "api.vodpod.com"
	use_nagios_host "lockerz_host"
	notifications_enabled true
end

## Setup the basic site checks.
[{
	:uri => "/",
	:name => "root"
},{
	:uri => "/tmim",
	:name => "tmim"
},{
	:uri => "/watch/19517-flying-dude",
	:name => "watch"
},{
	:uri => "/search/browse?q=obama",
	:name => "search"
}].each do |test|
	nagios_service "check_vodpod_%s" % test[:name] do
		hosts "vodpod.com"
		register true
		check_command "checkHTTPUrl!vodpod.com!\"%s\"!80" % test[:uri]
		contact_groups "vodpod-oncall"
		use_nagios_service "lockerz_service"
		service_description "Check the vod pod site: %s" % test[:name]
		notifications_enabled true
	end
end

# So not only is this horribly complex to read - it doesn't work (-r 'title' isn't part of the uri and it screws up the test
### API checks
#[{
#	:uri => "/v2/users/scottp/collections/scottsfaves/videos.json?api_key=2e01955b612890c6&limit=1&include=collections_count" ,
#	:name => "videos_json"
#},{
#	:uri => "/api/ingest/lookup_embed?video_id=10000&api_key=plixipod&auth=236xo1JM3jSa -r 'title'",
#	:name => "lookup_embed"
#}].each do |test|
#	nagios_service "check_vodpod_%s" % test[:name] do
#		hosts "api.vodpod.com"
#		register true
#		check_command "checkHTTPUrl!api.vodpod.com!\"%s\"!80" % test[:uri]
#		contact_groups "vodpod-oncall"
#		use_nagios_service "lockerz_service"
#		service_description "Check the vodpod api service: %s" % test[:name]
#		notifications_enabled true
#	end
#end

# API checks
nagios_service "check_vodpod_videos_json" do
	hosts "api.vodpod.com"
	register true
	check_command "checkHTTPUrl!api.vodpod.com!\"/v2/users/scottp/collections/scottsfaves/videos.json?api_key=2e01955b612890c6&limit=1&include=collections_count\"!80"
	contact_groups "vodpod-oncall"
	use_nagios_service "lockerz_service"
	service_description "Check the vodpod api service: videos_json"
	notifications_enabled true
end

nagios_service "check_vodpod_lookup_embed" do
	hosts "api.vodpod.com"
	register true
	check_command "checkHTTPUrlRegex!api.vodpod.com!\"/api/ingest/lookup_embed?video_id=10000&api_key=plixipod&auth=236xo1JM3jSa\"!80!title"
	contact_groups "vodpod-oncall"
	use_nagios_service "lockerz_service"
	service_description "Check the vodpod api service: lookup_embed"
	notifications_enabled true
end


## What I'm doing here is creating a hash containing roleName and fqdn.
#	I use this later on with the service checks.  This should eventually be
#	replaced with something that uses roles, but then that would require
#	creating/applying each role to each node.  Granted there are only <10 nodes,
#	but I don't have the time, and I can't afford the risk to do this correctly.
nodes = search( :node,"chef_environment:preprod AND run_list:role\\[VodpodService\\]" )
hostgroups = { "all" => [] }
nodes.each do |node|
	## Not terribly impressed with this, but it'll have to do for now, please replace it with something better.
	s = node[:fqdn].scan( /^([a-z]{1,})[0-9]{1,}\.vodpod.prod\.lockerz\.us$/ )[0]
	next if(s == nil)
	hostgroup = s[0]
	hostgroups[hostgroup] ||= []
	hostgroups[hostgroup].push( node[:fqdn] )
	hostgroups["all"].push( node[:fqdn] )

	nagios_host node[:fqdn] do
		address node.ipaddress
		use_nagios_host "lockerz_host"
		notifications_enabled true
	end
end
## This creates the actual nagios hostgroup used later in the service defs
hostgroups.each do |name,fqdns|
	nagios_hostgroup "vodpod_%s" % name do
		members fqdns.join( "," )
	end
end


## Core checks
fsServiceDir = "%s/services/vodpod/%s/system" % [node["nagios"]["config_dir"],envName]
directory fsServiceDir do
	mode "0755"
	owner "nagios"
	group "nagios"
	action :create
	recursive true
end

nagios_service "vodpod/%s/system/check_root_disk" % envName do
	hostgroup "vodpod_all"
	check_command "checkDisk!root"
	contact_groups "opz"
	use_nagios_service "lockerz_service"
	service_description "Check root disk"
	notifications_enabled true
end

nagios_service "vodpod/%s/system/check_local_disk" % envName do
	hostgroup "vodpod_all"
	check_command "checkDisk!local"
	contact_groups "opz"
	use_nagios_service "lockerz_service"
	service_description "Check local disk"
	notifications_enabled true
end

nagios_service "vodpod/%s/system/check_cpu" % envName do
	hostgroup "vodpod_all"
	check_command "checkCPU"
	contact_groups "opz"
	use_nagios_service "lockerz_service"
	service_description "Check CPU"
	notifications_enabled true
end



## Web role
fsServiceDir = "%s/services/vodpod/%s/web" % [node["nagios"]["config_dir"],envName]
directory fsServiceDir do
	mode "0755"
	owner "nagios"
	group "nagios"
	action :create
	recursive true
end

nagios_service "vodpod/%s/web/check_for_nginx" % envName do
	register true
	hostgroup "vodpod_uniweb"
	check_command "check_nrpe!check_for_nginx"
	contact_groups "vodpod-oncall"
	use_nagios_service "lockerz_service"
	service_description "Check for nginx process on web role."
end

nagios_service "vodpod/%s/web/check_for_cluster_script" % envName do
	register true
	hostgroup "vodpod_uniweb"
	check_command "check_nrpe!check_for_cluster_script"
	contact_groups "vodpod-oncall"
	use_nagios_service "lockerz_service"
	service_description "Check for cluster process on web role."
end

nagios_service "vodpod/%s/web/check_for_mongrel_rails" % envName do
	register true
	hostgroup "vodpod_uniweb"
	check_command "check_nrpe!check_for_mongrel_rails"
	contact_groups "vodpod-oncall"
	use_nagios_service "lockerz_service"
	service_description "Check for mongrel process on web role."
end



## API
fsServiceDir = "%s/services/vodpod/%s/api" % [node["nagios"]["config_dir"],envName]
directory fsServiceDir do
	mode "0755"
	owner "nagios"
	group "nagios"
	action :create
	recursive true
end

nagios_service "vodpod/%s/api/check_for_nginx" % envName do
	register true
	hostgroup "vodpod_api"
	check_command "check_nrpe!check_for_nginx"
	contact_groups "vodpod-oncall"
	use_nagios_service "lockerz_service"
	service_description "Check for nginx process on api role."
end

nagios_service "vodpod/%s/api/check_for_api_cluster" % envName do
	register true
	hostgroup "vodpod_api"
	check_command "check_nrpe!check_for_api_cluster"
	contact_groups "vodpod-oncall"
	use_nagios_service "lockerz_service"
	service_description "Check for api cluster process on api role."
end

nagios_service "vodpod/%s/api/check_for_api_service" % envName do
	register true
	hostgroup "vodpod_api"
	check_command "check_nrpe!check_for_api_service"
	contact_groups "vodpod-oncall"
	use_nagios_service "lockerz_service"
	service_description "Check for api service process on api role."
end



## Backend services
fsServiceDir = "%s/services/vodpod/%s/backend" % [node["nagios"]["config_dir"],envName]
directory fsServiceDir do
	mode "0755"
	owner "nagios"
	group "nagios"
	action :create
	recursive true
end

nagios_service "vodpod/%s/backend/check_for_run_queue" % envName do
	register true
	hostgroup "vodpod_backend"
	check_command "check_nrpe!check_for_run_queue"
	contact_groups "vodpod-oncall"
	use_nagios_service "lockerz_service"
	service_description "Check for run queue process on backend role."
end

nagios_service "vodpod/%s/backend/check_for_run_scrape_queue" % envName do
	register true
	hostgroup "vodpod_backend"
	check_command "check_nrpe!check_for_run_scrape_queue"
	contact_groups "vodpod-oncall"
	use_nagios_service "lockerz_service"
	service_description "Check for run scrape queue process on backend role."
end

## Check for the alerts.rb script on backend1
nagios_service "vodpod/%s/backend/check_for_alerts_script" % envName do
	host "backend1.vodpod.prod.lockerz.us"
	register true
	check_command "check_nrpe!check_for_alerts_script"
	contact_groups "vodpod-oncall"
	use_nagios_service "lockerz_service"
	service_description "Check for alerts process on backend1."
end

## Check for redis on backend2
nagios_service "vodpod/%s/backend/check_for_redis_service" % envName do
	host "backend2.vodpod.prod.lockerz.us"
	register true
	check_command "check_nrpe!check_for_redis_service"
	contact_groups "vodpod-oncall"
	use_nagios_service "lockerz_service"
	service_description "Check for redis on backend2 ."
end



## Stats role
if(false)
fsServiceDir = "%s/services/vodpod/%s/stats" % [node["nagios"]["config_dir"],envName]
directory fsServiceDir do
	mode "0755"
	owner "nagios"
	group "nagios"
	action :create
	recursive true
end

nagios_service "vodpod/%s/stats/check_for_nginx" % envName do
	register true
	hostgroup "vodpod_stats"
	check_command "check_nrpe!check_for_nginx"
	contact_groups "vodpod-oncall"
	use_nagios_service "lockerz_service"
	service_description "Check for queued job process on backend role."
end

nagios_service "vodpod/%s/stats/check_for_cluster_script" % envName do
	register true
	hostgroup "vodpod_stats"
	check_command "check_nrpe!check_for_cluster_script"
	contact_groups "vodpod-oncall"
	use_nagios_service "lockerz_service"
	service_description "Check for queued job process on backend role."
end

nagios_service "vodpod/%s/stats/check_for_mongrel_rails" % envName  do
	register true
	hostgroup "vodpod_stats"
	check_command "check_nrpe!check_for_mongrel_rails"
	contact_groups "vodpod-oncall"
	use_nagios_service "lockerz_service"
	service_description "Check for queued job process on backend role."
end
end



## Solr role

