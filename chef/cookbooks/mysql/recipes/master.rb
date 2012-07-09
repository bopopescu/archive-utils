##
# MySQL master server recipe.
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

include_recipe "mysql::client"
include_recipe "mysql::default"
include_recipe "mysql::service"
include_recipe "mysql::user_management"

