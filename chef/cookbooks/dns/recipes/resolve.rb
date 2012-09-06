# Cookbook Name:: linux-base
# 	This cookbook is the base setup script for everything else.
#
#
# @author	Stece Layton ( steve@lockerz.com )

## Pull in the other recipes for default.
# 	This could be moved to the recipe for system, but this
#	seems to make things more clear.

## Ensure the resolv.conf file gets created properly.
#	This means using chef searches to find the DNSMasters and DNSSlaves
#	Defined in definitions/resolv.rb
resolv do
	domain "lockerz.int" % envName
end


