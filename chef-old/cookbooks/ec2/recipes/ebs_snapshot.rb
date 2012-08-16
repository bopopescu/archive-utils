##
# EBS related helpers.
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

## Find any nodes with attributes["ebs"]["backup"]
search( :node, "*:*" ).each do |lNode|
	#puts "Node: %s" % lNode["ebs"]
	if(lNode["ebs"] != nil && lNode["ebs"]["backup"] != nil)
		lNode["ebs"]["backup"].each do |backupConfig|
			#puts "Creating ebs backup: %s" % backupConfig.inspect
			backupConfig[:node] = lNode
			ebs_backup do
				snapshotConfig backupConfig
			end
		end
	end
end
