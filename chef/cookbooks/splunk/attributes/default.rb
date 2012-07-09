##
# Description
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com
default[:splunkserver][:forwarderport] = "9997"

default[:splunkforwarder][:root] = "/opt/splunkforwarder"
default[:splunk][:monitors]["/var/log/messages"] = ""
default[:splunk][:monitors]["/var/log/secure"] = ""
default[:splunk][:monitors]["/var/log/maillog"] = ""

default[:ebs][:backup] = [{
	:hour => "23",
	:user => "root",
	:minute => "*",
	:mailto => "bernard@lockerz.com",
	:devices => ["sdf1", "sdf13", "sdf12", "sdf11", "sdf10", "sdf9", "sdf8", "sdf7", "sdf6", "sdf5", "sdf4", "sdf3", "sdf2"]
}]
