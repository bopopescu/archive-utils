##
# MySQL backup script.
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

define :mysql_backup_script do
	targetNodeFQDN = params[:targetNode][:fqdn]

	directory "/home/mysqlbackup/scripts" do
		mode "0755"
		owner "mysqlbackup"
		group "mysqlbackup"
		recursive true
	end

	## Ensure that the target directory will exist for both logs and data
	# logging 
	directory "%s/%s" % [node[:mysqlBackup][:fsLogRoot],targetNodeFQDN] do
		mode "0755"
		owner "mysqlbackup"
		group "mysqlbackup"
		action :create
		recursive true
	end

	# data 
	directory "%s/%s" % [node[:mysqlBackup][:fsDataRoot],targetNodeFQDN] do
		mode "0755"
		owner "mysqlbackup"
		group "mysqlbackup"
		action :create
		recursive true
	end

	## First we setup the script and crontab job to handle the ebs volume backups
	#template "/home/mysqlbackup/scripts/snapshot_ebs_%s.sh" % targetNodeFQDN do
		#mode "0755"
		#owner "mysqlbackup"
		#group "mysqlbackup"
		#source "snapshot_ebs.rb.erb"
		#variables({
			#:targetNode => params[:targetNode]
		#})
	#end	

    cron "snapshot_ebs_%s" % targetNodeFQDN do
        hour "*/4"
        user "ec2user"
        minute "*/20" 
        command "/home/mysqlbackup/scripts/snapshot_ebs.rb --target %s --fqdn %s" % [
			params[:targetNode]["ec2"]["instance_id"],
			targetNodeFQDN
		]
    end
	
end
