##
# Main nagios server recipe.
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com
include_recipe "nagios::default"

## Packages
package "pymongo" ## Enable this for the mongodb checks
package "nagios"
package "nagios-plugins-nrpe"

## Base containers.
["cache_dir","run_dir","log_dir","plugin_dir","state_dir","config_dir"].each do |dirName|
	directory node[:nagios][dirName] do
		mode "0775"
		owner node[:nagios]["user"]
		group node[:nagios]["group"]
		action :create
		recursive true
	end
end

# This directory requires special configuration to work
directory node[:nagios]["cache_rw_dir"] do
	owner node[:nagios]["user"]
	group "apache" # XXX this might ought to be plucked from somewhere else
	mode "2750"
	action :create
end


## Config dirs
["commands","hosts","hostgroups","services","contacts","scripts"].each do |dir|
	directory "/etc/nagios/%s" % dir do
		mode "0775"
		owner node[:nagios]["user"]
		group node[:nagios]["group"]
		action :create
	end
end

## Deploy custom plugins
["check_mongodb.py","check_json_status"].each do |pluginName|
	cookbook_file "%s/%s" % [node[:nagios]["plugin_dir"],pluginName] do
		mode "0755"
		owner "nagios"
		group "nagios"
		source "plugins/%s" % pluginName
	end
end



## Core lockerz service.
#	Anything related to OPZ-742 will use these as their core services.
nagios_service "lockerz_service" do
    register false
    check_period "24x7"
    check_freshness false
    parallelize_check true
    process_perf_data true
    max_check_attempts 3
    obsess_over_service true
    notification_period "24x7"
    notification_options "w,u,c,r"
    retry_check_interval 1
    normal_check_interval 15
    notifications_enabled true
    notification_interval 0
    normal_check_interval 5
    event_handler_enabled true
    flap_detection_enabled true
    retain_status_information true
    retain_nonstatus_information true
end

## Default nagios host def
nagios_host "lockerz_host" do
	register false
	contacts "ops@lockerz.com"
	check_command "check-host-alive"
	process_perf_data false
	max_check_attempts 10
	notification_period "24x7"
	notification_options "d,u,r"
	notification_interval 0
	notifications_enabled true
	event_handler_enabled true
	flap_detection_enabled true
	retain_status_information true
	failure_prediction_enabled true
	retain_nonstatus_information true
end

nagios_host "noping_lockerz_host" do
	register false
	contacts "ops@lockerz.com"
	check_command "check-host-dummy"
	process_perf_data false
	max_check_attempts 10
	notification_period "24x7"
	notification_options "d,u,r"
	notification_interval 0
	notifications_enabled true
	event_handler_enabled true
	flap_detection_enabled true
	retain_status_information true
	failure_prediction_enabled true
	retain_nonstatus_information true
end



## These will end up being pushed to the nagios.cfg file
cfgFiles = { :hostgroups => [], :hosts => [], :services => [], :contacts => [], :commands => [] }

## Attempting to automate user contacts
gem_package "ruby-net-ldap" do
	action :install
end
require "net/ldap"

ldapUsers = []
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

filter = Net::LDAP::Filter.eq( "objectClass","posixAccount" )
ldapUsers = ldap.search( :base => "dc=lockerz,dc=com", :filter => filter )

template "/etc/nagios/contacts/auto.cfg"  do
	mode "0755"
	owner node[:nagios]["user"]
	group node[:nagios]["group"]
	source "contacts.cfg.erb"
	variables({
		:users => ldapUsers
	})
end
cfgFiles[:contacts].push( "auto.cfg" ) 

## Contact types and oncall pointers
["contact_types","oncall","pagers"].each do |fileName|
	cookbook_file "/etc/nagios/contacts/%s.cfg" % fileName do
		mode "0755"
		owner node[:nagios]["user"]
		group node[:nagios]["group"]
		source "contacts/%s.cfg" % fileName
	end
	cfgFiles[:contacts].push( "%s.cfg" % fileName )
end

## Contact groups ( pulled from `knife data bag show lockerz contact_groups` )
contactGroups = search( :lockerz,"id:contact_groups" ).first()["groups"]
template "/etc/nagios/contacts/groups.cfg"  do
	mode "0755"
	owner node[:nagios]["user"]
	group node[:nagios]["group"]
	source "contact_groups.cfg.erb"
	variables({
		:groups => contactGroups
	})
end
cfgFiles[:contacts].push( "groups.cfg" ) 



## Generic service 
cookbook_file "/etc/nagios/services/generic.cfg" do
	mode "0755"
	owner node[:nagios]["user"]
	group node[:nagios]["group"]
	source "services/generic.cfg"
end

## Generic host 
cookbook_file "/etc/nagios/hosts/generic.cfg" do
	mode "0755"
	owner "nagios"
	group "nagios"
	source "hosts/generic.cfg"
end

## Generic server config
cookbook_file "/etc/nagios/hosts/server.cfg" do
	mode "0755"
	owner "nagios"
	group "nagios"
	source "hosts/server.cfg"
end
cfgFiles[:hosts].push( "server.cfg" )

## Resource file
cookbook_file "/etc/nagios/resource.cfg" do
	mode "0755"
	owner "nagios"
	group "nagios"
	source "server/resource.cfg"
end



## Commands
# Commands are grouped into files for easier management.
["vertica","notifications","http","solr","mailcheck","memcache","openmq",
	"mysql","mongod","phoenix","system","commands","chef", "platz"].each do |cmdFile|
	cookbook_file "/etc/nagios/commands/%s.cfg" % cmdFile do
		mode "0755"
		owner "nagios"
		group "nagios"
		source "commands/%s.cfg" % cmdFile
	end
	cfgFiles[:commands].push( "%s.cfg" % cmdFile )
end



## This is where we use chef to build out the configuration files nagios will use for alerting.

## Pull in the environment list
envs = search( :environment,"*:*" )

## Pull in the role list
roles = search( :role,"*:*" )

## Create a host file for each environment
envs.each do |environment|
	next if (['platz', 'scalr', '_default'].include?(environment)) # Skip this nonsense for the new
	# environments

	## Create api checks for each environment based on the role and environment configuration.
	#	This is desgined for the new java services that have their own ping_url.
	environment.default_attributes.each do |key,val|
		next if(!key.match( /Service$/ )) ## Process services only ( excluding things like pegasus )

		role = nil
		roles.each do |objRole|
			role = objRole if(objRole.name == key)
		end
		next if(role == nil) ## If the role wasn't found for this service, then we skip, this might indicate a problem.

		if(role.default_attributes["ping_url"] != nil) ## Don't process any service that does not have a ping_url variable.
			hostname = "api.%s.lockerz.us" % environment.name
			hostname = "api.lockerz.com" if(environment.name == "prod") ## Production override.

			checkConfig = {
				:use => "%s-generic-service" % environment.name,
				:host => hostname,
				:notesUrl => "",
				:register => 0,
				:hostgroup => nil,
				:checkCommand => nil,
				:description => "Check %s on %s" % [key,environment.name],
				:contactGroups => []
			}

			register = 1 if(environment.name == "prod") ## Enable for prod, disable for everything else.

			## ping_url can use a template for variables.
			pingUrl = Erubis::Eruby.new(role.default_attributes["ping_url"]).evaluate({ 
				:environment => environment 
			})
			#puts "\tPing url: %s" % pingUrl

			## Always use https for this check.
			checkConfig[:checkCommand] = "checkHTTPSUrl!%s!'%s'" % [hostname,pingUrl]

			## Create the nagios config file.
			tplName = "%s_%s.api.lockerz.com.cfg" % [environment.name,key]
			template "/etc/nagios/services/%s" % tplName do 
				mode "0755"
				owner "root"
				group "root"
				source "single_service.cfg.erb"
				variables({ :cfg => checkConfig })
			end
			cfgFiles[:services].push( tplName )
		end ## ping_url
	end ## each service

	## Get a list of nodes for this environment
	nodes = search( :node,"chef_environment:%s" % environment.name )

	## Build a map of nodes per role.
	# 	This is required so we don't create empty services, which apparently nagios hates.
	envRoleNodes = {}
	roles.each do |role|
		sNodes = []

		## Ensure that we exclude any nodes that have a specific requirement of:
		#	{ nagios_service: {register: 0} }
		#	This indicates that we do not want to monitor any services on this node.
		search( :node,"run_list:role\\[%s\\] AND chef_environment:%s" % [role.name,environment.name] ).each do |node|
			next if(node["nagios_service"] != nil && node["nagios_service"]["register"] != nil && node["nagios_service"]["register"].to_i == 0)
			next if(node["ec2"] == nil) ## Don't include any nodes that are not fully qualified ec2 nodes.
			#puts "FQDN: %s" % node["fqdn"]
			next if(node["fqdn"] != nil && node["fqdn"].match( /vodpod/ )) ## Exclude vodpod nodes ( part of migrating services to recipies )
			next if(node["fqdn"] != nil && node["fqdn"].match( /jasper/ )) ## Exclude jasper nodes
			next if(node["fqdn"] != nil && node["fqdn"].match( /targo/ )) ## Exclude Targo
			next if(node["fqdn"] != nil && node["fqdn"].match( /pegasus/ )) ## Exclude commerce nodes ( part of migrating services to recipies )
			next if(node["fqdn"] != nil && node["fqdn"].match( /commerce/ )) ## Exclude commerce nodes ( part of migrating services to recipies )
			#puts "\tNext: %s" % node["fqdn"]
			sNodes.push( node )
		end
		envRoleNodes[role.name] = sNodes
	end

	## Use the hosts template to create the host stanzas.
	template "/etc/nagios/hosts/%s.cfg" % environment.name do
		mode "0755"
		owner "root"
		group "root"
		source "hosts.cfg.erb"
		variables({
			:roles => roles,
			:nodes => nodes,
			:environment => environment,
			:envRoleNodes => envRoleNodes
		})
	end
	cfgFiles[:hosts].push( "%s.cfg" % environment.name )

	if(nodes.size > 0)
		## Use the services template to create the service stanzas.
		template "/etc/nagios/services/%s.cfg" % environment.name do
			mode "0755"
			owner "root"
			group "root"
			source "services.cfg.erb"
			variables({
				:roles => roles,
				:environment => environment,
				:envRoleNodes => envRoleNodes
			})
		end
		cfgFiles[:services].push( "%s.cfg" % environment.name )
	end
end

## Main nagios config
template "/etc/nagios/nagios.cfg" do
	mode "0755"
	owner "nagios"
	group "nagios"
	source "nagios.cfg.erb"
	variables({
		:cfgFiles => cfgFiles
	})
end

## Link the logging location
link "/var/log/nagios" do
	to "/mnt/local/nagios/log"
end

## Nagios cgi config
cookbook_file "/etc/nagios/cgi.cfg" do
	mode "0755"
	owner "nagios"
	group "nagios"
	source "server/cgi.cfg"
end

## Oncall calendar management
## These require some python modules that are installed by the python26 recipe in the linux-base cookbook...
cookbook_file "/etc/nagios/scripts/oncall.sh" do
	mode "0755"
	owner "nagios"
	group "nagios"
	source "scripts/oncall.sh"
end

cookbook_file "/etc/nagios/scripts/whosOnFirst.py" do
	mode "0755"
	owner "nagios"
	group "nagios"
	source "scripts/whosOnFirst.py"
end


cookbook_file "/etc/nagios/scripts/oocSetForwarding" do
	mode "0755"
	owner "nagios"
	group "nagios"
	source "scripts/oocSetForwarding"
end


cron "nagios_oncall" do
        minute "*/10"
        command "/etc/nagios/scripts/oncall.sh"
end


# Bernard put these in to work around mreid's TargoCheck(s)? stuff
nagios_hostgroup "prod.TargoService"
nagios_hostgroup "prod.TargoCheck"
nagios_hostgroup "prod.TargoChecks"
