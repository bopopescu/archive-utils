##
# Description: Core system elements
#
# @author	Bryan Kroger ( bryan@lockerz.com )

#puts "Recipes: %s" % node[:recipes].inspect
isAdmin = node[:recipes].include?( "linux-base::admin" )

## If ldap auth fails, this will ensure that the opz people can get into the box.
#if(!node[:fqdn].match( /^admin[0-9]{1,}\.opz\.[a-z]{1,}\.lockerz\.us$/ ))
#if(isAdmin == false)
#	## However, if the host is an admin box, we want to skip this.
#	# @TODO: make this smarter: look for the admin *role*
#	cookbook_file "/etc/passwd" do
#		mode "0644"
#		owner "root"
#		group "root"
#		backup false
#		source "system/passwd"
#	end
#end
#
#cookbook_file "/etc/group" do
#	mode "0644"
#	owner "root"
#	group "root"
#	backup false
#	source "system/group"
#end
#
#cookbook_file "/etc/shadow" do
#	mode "0000"
#	owner "root"
#	group "root"
#	backup false
#	source "system/shadow"
#end

#user = "root"

## Root
directory "/root/.ssh" do
	mode 0700
	owner "root"
	group "root"
	action :create
	recursive true
end

envName = node.chef_environment
#puts "EnvName: %s" % envName

## Push a custom bashrc for prod and non-prod environments
if(envName == "prod")
	cookbook_file "/root/.bashrc" do
		mode "0640"
		owner "root"
		group "root"
		source "users/root/.bashrc.prod" 
	end

else
	cookbook_file "/root/.bashrc" do
		mode "0640"
		owner "root"
		group "root"
		source "users/root/.bashrc.non-prod" 
	end

end

cookbook_file "/root/.bash_profile" do
	mode "0640"
	group "root"
	owner "root"
	backup false
	source "users/root/.bash_profile" 
end


## This is how we:
# 1) Ensure opz users always have root access by installing their keys
# 2) Control who has access to the node by either:
#	1) Adding user to the role by adding: {"override_variables": { "owners": ["user@domain.tld"] }}
#	2) Adding the user to the node by using: {"node_owners": ["user@domain.tld"]}
#
# This requires that any user defined as an owner also have their keys setup in the
#	lockerz/users databag

rootKeys = []
users = search( :lockerz,"id:users" ).first
#puts "Users: %s" % users.inspect

opzUsers = search( :lockerz,"id:opz" ).first["users"]

opzUsers.each do |email|
	## This indicated that the user's keys are not installed in the lockerz/users data bag.
	raise Exception.new( "(Opz) No keys for user: %s" % email ) if(!users[email])

	## This will ensure that the user has a key in the root auth_keys file
	rootKeys += users[email]["keys"]

	## Skip the home dirs if this is an admin node
	#	Being an admin node means it's running autofs, so trying to create
	#	the home dirs while autofs is in play breaks the workflow.
	next if(isAdmin)

	username = email.gsub( /@.*$/,'' )

	#user username do
	#	comment username
	#	shell "/bin/bash"
	#end

	directory "/home/%s/" % username do
		mode "0700"
		owner username
		group "ops"
		action :create
		recursive true
	end

	directory "/home/%s/.ssh" % username do
		mode "0700"
		owner username
		group "ops"
		action :create
		recursive true
	end

	template "/home/%s/.ssh/authorized_keys" % username do
		mode "0400"
		owner username
		group "ops"
		source "authorized_keys.erb"
		variables({ 
			:keys => users[email]["keys"] 
		})
	end

end

## Add owners from the role
owners = (node.override_attrs["owners"] != nil ? node.override_attrs["owners"] : [])

## Add owners from the node
if(node["node_owners"] != nil)
	owners += node["node_owners"]
end

if(owners.size > 0)
	owners.each do |email|
		raise Exception.new( "(Owner) No keys for user: %s" % email ) if(!users[email])
		rootKeys += users[email]["keys"]
	end
end

## Root authorized keys
template "/root/.ssh/authorized_keys" do
	mode "0400"
	owner "root"
	group "root"
	backup false
	source "authorized_keys.erb"
	variables({ :keys => rootKeys })
end
