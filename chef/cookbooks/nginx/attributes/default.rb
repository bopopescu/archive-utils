##
# Nginx defaults
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

default[:fsLogRoot] = "/mnt/local/lockerz.com/logs/nginx"

## Splunk
#default[:splunk][:monitors]["/mnt/local/lockerz.com/logs/nginx/*.log"] = ""

#envName = node.chef_environment
#fsLogRoot = "/mnt/local/lockerz.com/logs/nginx/"
#serverName = (envName == "prod" ? "lockerz.com" : "%s.lockerz.us" % envName)

