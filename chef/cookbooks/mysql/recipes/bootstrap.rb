##
# This recipe will not install any mysql components, it's job is to frame up
#	the .sql files and any support scripts for bootstrapping a new environment.
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com


## SQL Files
[
	"clear_users.sql",
	"commerce.config_fix.sql",
	"commerce.shop_to_site.sql",
	"authentication.sql",
	"click_through.sql",
	"follows.sql",
	"decalz.sql",
	"locator.sql",
	"bits.sql",
	"social.sql",
	"socialgraph.sql",
	"create_databases.sql",
	"pod.sql",
	"reset_pod.sql"
].each do |sqlFile|
	template "/root/sql/%s" % sqlFile do
		mode "0755"
		source "bootstrap/%s.erb" % sqlFile
		variables({
			:envName => node.chef_environment
		})
	end
end

## Support scripts
cookbook_file "/root/sql/sync.rb" do
	mode "0755"
	source "bootstrap/sync.rb"
end
