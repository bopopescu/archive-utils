##
# Nagios defaults.
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com
default['nagios']['user'] = "nagios"
default['nagios']['group'] = "nagios"

default["nagios"]["run_dir"] = "/var/run/nagios"
default["nagios"]["log_dir"] = "/mnt/local/nagios/log"
default["nagios"]["state_dir"] = "/mnt/local/nagios/cache"
default["nagios"]["cache_dir"] = "/mnt/local/nagios/cache"
default['nagios']["plugin_dir"] = "/usr/lib64/nagios/plugins"
default["nagios"]["config_dir"] = "/etc/nagios"
#default["nagios"]["plugin_dir"] = "/mnt/local/nagios/plugins"
default["nagios"]["cache_rw_dir"] = "/mnt/local/nagios/cache/rw/"

