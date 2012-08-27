##
# User directory
#
# @author   Bryan Kroger ( bryan@lockerz.com )

define :user_dir, :userName => :name do 
	userName = (params[:name] == nil ? params[:username] : params[:name])

	groupName = (params[:group] == nil ? "user" : params[:group])

	raise Exception.new( "Please pass a userName to user_dir" ) if(userName == nil)

	## mk_user is used if the user isn't in ldap, for instance, a local system account
	##	that is part of a new application that hasn't been fully setup.
	if(params[:mk_user] == true)
		group groupName
		user userName do
			home params[:home] 
			shell params[:shell]
			group groupName
			system params[:system]
		end
	end

	directory "/home/%s" % userName do
		mode "0755"
		owner userName
		group groupName
	end

	directory "/home/%s/.ssh" % userName do
		mode "0755"
		owner userName
		group groupName
	end

	if(params[:private_key] != nil)
		template "/home/%s/.ssh/id_rsa" % userName do
			mode "0600"
			owner userName
			group groupName
			source "id_rsa.erb"
			cookbook "linux-base"
			variables({ :keyData => params[:private_key] })
		end

		#cookbook_file "/home/%s/.ssh/config" % userName do
			#mode "0600"
			#owner userName
			#group groupName
			#source "basic_ssh_config"
			#cookbook "linux-base"
		#end 
	end

	if(params[:public_keys] != nil)
		template "/home/%s/.ssh/authorized_keys" % userName do
			mode "0600"
			owner userName
			group groupName
			source "authorized_keys.erb"
			cookbook "linux-base"
			variables({ :keys => params[:public_keys] })
		end
	end

end
