##
# Cookbook Name:: base-packages
#	This is more of a container to put all of the base packages
#	in place.  These are the packages that we care about maintaining
#	and that should be part of the system as per the standard kit.
#
# @author	Bryan Kroger ( bryan@lockerz.com )

## lockerz.com repo
#cookbook_file "/etc/yum.repos.d/lockerz.com.repo" do
	#mode "0755"
	#owner "root"
	#group "root"
	#source "yum/lockerz.com"
#end

## packages
["telnet","diffutils","mtr","screen","lynx","nmap","ntp","bash-completion",
	"dstat","xfsprogs","mdadm","subversion","git"].each do |packageName|
	package packageName do
		action :install
	end
end



