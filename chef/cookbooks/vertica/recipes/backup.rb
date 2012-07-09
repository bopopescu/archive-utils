##
# Vertica backup recipe
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

cookbook_file "/etc/hosts" do
	mode "0755"
	owner "root"
	group "root"
	source "prod.hosts"
end

devices = []
14.times do |i| devices.push( "/dev/sdf%i" % (i+1) ) end

mdadm "/dev/md0" do
	level 0
	action [ :create, :assemble ]
	devices devices
	#devices [ "/dev/sdd", "/dev/sde", "/dev/sdf", "/dev/sdg", "/dev/sdh", "/dev/sdi",
		#"/dev/sdj", "/dev/sdk", "/dev/sdl", "/dev/sdm", "/dev/sdn", "/dev/sdo", "/dev/sdp" ]
end

mount "/data" do
	not_if "grep 'md0' /etc/mtab"
	device "/dev/md0"
	fstype "xfs"
end

directory "/data/dbadmin/backup/" do
	mode "0755"
	owner "dbadmin"
	group "dbadmin"
	recursive true
end
