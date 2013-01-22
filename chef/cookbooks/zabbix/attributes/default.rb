#
# Cookbook Name:: zabbix
# Attributes:: default

default['zabbix']['agent']['install'] = true
default['zabbix']['agent']['version'] = "2.0.4"
default['zabbix']['agent']['servers'] = []
default['zabbix']['agent']['servers_active'] = []
default['zabbix']['agent']['hostname'] = node['fqdn']

default['zabbix']['server']['install'] = false
default['zabbix']['server']['version'] = "2.0.4"
default['zabbix']['server']['branch'] = "ZABBIX%20Latest%20Stable"
default['zabbix']['server']['dbname'] = "zabbix"
default['zabbix']['server']['dbuser'] = "zabbix"
default['zabbix']['server']['dbhost'] = "localhost"
default['zabbix']['server']['dbport'] = "3306"
 
default['zabbix']['install_dir'] = "/opt/zabbix"
# default['zabbix']['etc_dir'] = "/etc/zabbix"
default['zabbix']['etc_dir'] = "/usr/local/etc/zabbix"
default['zabbix']['web_dir'] = "/opt/zabbix/web"
default['zabbix']['external_dir'] = "/opt/zabbix/externalscripts"
default['zabbix']['alert_dir'] = "/opt/zabbix/AlertScriptsPath"
default['zabbix']['lock_dir'] = "/var/lock/subsys"
default['zabbix']['src_dir'] = "/opt"
default['zabbix']['log_dir'] = "/var/log/zabbix"
default['zabbix']['run_dir'] = "/var/run/zabbix"

default['zabbix']['login'] = "zabbix"
default['zabbix']['group'] = "zabbix"
default['zabbix']['uid'] = nil
default['zabbix']['gid'] = nil
default['zabbix']['home'] = '/opt/zabbix'
default['zabbix']['shell'] = "/bin/bash"
