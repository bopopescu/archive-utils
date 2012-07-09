##
# Site attributes

#if(node[:run_list].include?( "SiteWebFrontend" ))

	#default[:splunk][:monitors]["/mnt/local/lockerz.com/logs/httpd/site/access.log"] = ""
	#default[:splunk][:monitors]["/mnt/local/lockerz.com/logs/httpd/site/error.log"] = ""
	#default[:splunk][:monitors]["/mnt/local/lockerz.com/logs/httpd/access.log"] = ""
	#default[:splunk][:monitors]["/mnt/local/lockerz.com/logs/httpd/error.log"] = ""
	#default[:splunk][:monitors]["/mnt/local/lockerz.com/logs/httpd/site/CLICKSTREAM.log"] = "lockerz-clickstream"
	#default[:splunk][:monitors]["/mnt/local/lockerz.com/logs/httpd/site/ERROR.log"] = ""

#end
