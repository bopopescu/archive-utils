# Cookbook Name:: dns 
# 	This cookbook is the base setup for dns. 
#
#
# @author	Steve Layton ( steve@lockerz.com )

## Ensure the resolv.conf file gets created properly.
#	This means using chef searches to find the DNSMasters and DNSSlaves
#       and search domains

h = Hash.new
hosts = []
search(:node, "*:*") {|n| hosts << n }
hosts.each do |host|
       if (host['fqdn'] == nil)
              h[host.fqdn.gsub(/^.*/,'lockerz.int')]=1
       else
              h[host.fqdn.gsub(/^[a-z0-9\-]*\./,'')]=1
       end
end
searchlist=h.keys.join(' ')

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
                :domain => searchlist,
                :nameservers => nameServers
        })
end

