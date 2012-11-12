# Cookbook Name:: dns 
# 	This cookbook is the base setup for dns. 
#
#
# @author	Steve Layton ( steve@lockerz.com )

## Ensure the resolv.conf file gets created properly.
#	This means using chef searches to find the DNSMasters and DNSSlaves
#       and search domains


# THIS USED TO WORK!! - DYNAMICALLY BUILD A LIST OF DF DOMAINS
# h = Hash.new
# hosts = []
# search(:node, "*:*") {|n| hosts << n }
# hosts.each do |host|
#         if (host['fqdn'] == nil)
#               h[host.fqdn.gsub(/^.*/,'lockerz.int')]=1
#         else
#              h[host.name.gsub(/^[a-z0-9\-]*\./,'')]=1
#         end
# end
# searchlist=h.keys.join(' ')
searchlist="lockerz.int dba.prod.lockerz.int opz.prod.lockerz.int platz.lockerz.int dba.uat.lockerz.int"

## Assemble the list of primary and secondary dns servers.
nameServers = {}
search( :node,'run_list:role\[DNSServer\]' ).each do |srv|
        nameServers[srv.fqdn] = srv
end


template "/etc/resolvconf/resolv.conf.d/base" do
        mode "0755"
        owner "root"
        group "root"
        source "base.erb"
        variables({
                :domain => searchlist
        })
end

template "/etc/resolvconf/resolv.conf.d/head" do
        mode "0755"
        owner "root"
        group "root"
        source "head.erb"
        variables({
                :nameservers => nameServers
        })
end


