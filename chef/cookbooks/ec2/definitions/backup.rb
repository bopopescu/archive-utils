##
# EBS related functions.
#
# Backup usage:
#
#  default[:ebs][:backup] = [{
#  	:hour => "23/*",
#  	:user => "root"
#  	:minute => "*",
#  	:mailto => "bernard@lockerz.com",
#  	:devices => ["sdf1", "sdf13", "sdf12", "sdf11", "sdf10", "sdf9", "sdf8", "sdf7", "sdf6", "sdf5", "sdf4", "sdf3", "sdf2"]
#  }]
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

define :ebs_backup do
	#puts params.inspect
	snapshotConfig = params[:snapshotConfig]

	name = (snapshotConfig["name"] == nil ? snapshotConfig[:node]["fqdn"] : snapshotConfig["name"])
	puts "Creating backup for %s" % name

	cron "backup_%s" % name do
		hour snapshotConfig["hour"]
		user "ec2drone"
		minute snapshotConfig["minute"]
		mailto snapshotConfig["mailto"]
		command "/home/logmanager/scripts/ebs_backup.rb %s --devices %s " % [snapshotConfig[:node]["ec2"]["instance_id"],snapshotConfig["devices"].join( ',' )]
	end

end
