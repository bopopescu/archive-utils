##
# Cookbook Name:: phoenix::email
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

#parts = node[:fqdn].split( '.' )
#parts.shift
#domain = parts.join( '.' )
#puts "Domain: %s" % domain
#domain = "uat0.lockerz.
#envName = node[:fqdn].split( '.' ).reverse()[2]

json = JSON::parse( node["ec2"]["userdata"] )
domain = "%s.lockerz.int" % json["envName"]

template "/mnt/local/lockerz.com/phoenix/etc/emailService.properties" do
	mode "0755"
	owner "phoenix"
	group "phoenix"
	source "emailService.properties.erb"
	variables({ 
		:domain => domain,
		:envName => json["envName"]
	})
end

