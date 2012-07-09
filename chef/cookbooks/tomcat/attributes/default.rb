##
# Default attributes for all tomcat instances.
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

default[:fsTomcatRoot] = "/mnt/local/tomcat6/"
default[:fsLockerzRoot] = "/mnt/local/lockerz.com/"
default[:fsServiceConfigRoot] = "%s/etc/services/" % default[:fsTomcatRoot]

default[:splunk][:monitors]["/mnt/local/tomcat6/logs/admin.*.log"] = ""
default[:splunk][:monitors]["/mnt/local/tomcat6/logs/manager.*.log"] = ""
default[:splunk][:monitors]["/mnt/local/tomcat6/logs/catalina.*.log"] = ""
default[:splunk][:monitors]["/mnt/local/tomcat6/logs/localhost.*.log"] = ""
default[:splunk][:monitors]["/mnt/local/tomcat6/logs/host-manager.*.log"] = ""

