##
# Resolve def
#	This creates an /etc/resolv.conf based on two things:
#	1) Search domain defined by 'domain'
#	2) Nameservers are gathered by searching chef for any nodes that have
#		the recipe "bind::server", which should be any qualified nameserver.
#
# @author   Steve Layton ( steve@lockerz.com )

define :resolv, :domain => "lockerz.int" do

	## Assemble the list of primary and secondary dns servers.
	nameServers = {}
	search( :node,'run_list:role\[DNSMaster\]' ).each do |srv|
		nameServers[srv.fqdn] = srv
	end
	search( :node,'run_list:role\[DNSSlave\]' ).each do |srv|
		nameServers[srv.fqdn] = srv
	end

	template "/etc/resolv.conf" do
		mode "0755"
		owner "root"
		group "root"
		source "resolv.erb"
		variables({
			:domain => params[:domain],
			:nameservers => nameServers
		})
	end
end
