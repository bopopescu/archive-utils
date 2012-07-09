##
# Commerce attributes
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

#puts node.run_list.inspect
#if(node.run_list.map{|r| r.name }.include?( "CommerceWebFrontend" ))
	## Containers
	#default[:fsDocRoot] = "/var/www/lockerz.com/commerce/current"
	#default[:fsLogRoot] = "/mnt/local/lockerz.com/logs/httpd/commerce"
	
	## Splunk
	#default[:splunk][:monitors]["%s/access.log" % default[:fsLogRoot]] = ""
	#default[:splunk][:monitors]["%s/error.log" % default[:fsLogRoot]] = ""
	#default[:splunk][:monitors]["%s/core/DEBUG.log" % default[:fsLogRoot]] = ""
	#default[:splunk][:monitors]["%s/core/INFO.log" % default[:fsLogRoot]] = ""
	#default[:splunk][:monitors]["%s/core/ERROR.log" % default[:fsLogRoot]] = ""
	#default[:splunk][:monitors]["%s/core/CLICKSTREAM.log" % default[:fsLogRoot]] = "lockerz-clickstream"

#end
