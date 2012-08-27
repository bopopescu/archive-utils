#!/usr/local/bin/ruby
##
# Create EBS snapshots for this host.
#
# ec2-describe-snapshots -F "tag:fqdn=clickthrough1.dba.prod.lockerz.us"
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com
require 'rubygems'
require 'optparse'

options = { :verbose => false }
optParse = OptionParser.new do |opts|
    opts.banner = "Usage: snapshot_ebs.rb [--verbose] --destination=InstanceId --source=InstanceId"

    opts.on("-v", "--verbose", "Run verbosely") do |v|
        options[:verbose] = v
    end

    opts.on("-t","--target TARGET_INSTANCE_ID","Target instanceId") do |instanceId|
        options[:targetInstanceId] = instanceId
    end

    opts.on("-f","--fqdn TARGET_FQDN","Target fqdn") do |fqdn|
        options[:targetFQDN] = fqdn
    end

    opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
    end
end
optParse.parse( ARGV )

if(options[:targetInstanceId] == nil || !options[:targetInstanceId].match( /^i-/ ))
	puts "Target instance id failed sanity check."
	exit
end

if(options[:targetFQDN] == nil || options[:targetFQDN] == "")
	puts "Target fqdn failed sanity check."
	exit
end

Ec2Home="/usr/local/ec2/api"
Ec2Cert="/home/mysqlbackup/ec2/cert.pem"
Ec2PrivateKey="/home/mysqlbackup/ec2/pk.pem"

#Ec2Home="/usr/local/aws/ec2-api-tools-1.3-62308/"
#Ec2Cert="/usr/local/ec2/prod/cert.pem"
#Ec2PrivateKey="/usr/local/ec2/prod/pk.pem"

cmdGetBlocks = "%s/bin/ec2-describe-instances -K %s -C %s %s|grep BLOCKDEVICE" % [
	Ec2Home,
	Ec2PrivateKey,
	Ec2Cert,
	options[:targetInstanceId]
]
puts "CMD(getBlocks): %s" % cmdGetBlocks
blocks = []
`#{cmdGetBlocks}`.split( /\n/ ).each do |line|
	parts = line.split()
	#puts "Block: %s" % line
	blocks.push({
		:fqdn => options[:targetFQDN],
		:volId => parts[2],
		:device => parts[1]
	})
end
#puts blocks.inspect
#exit

blocks.each do |block|
	cmdCreateSnapshot = "%s/bin/ec2-create-snapshot -K %s -C %s %s|awk '{print $2}'" % [
		Ec2Home,
		Ec2PrivateKey,
		Ec2Cert,
		block[:volId]
	]
	puts "CMD(createSnap): %s" % cmdCreateSnapshot
	#next

	snapId = `#{cmdCreateSnapshot}`.chomp
	cmdTagSnapshot = "%s/bin/ec2-create-tags -K %s -C %s %s --tag 'fqdn=%s' --tag 'device=%s'" % [
		Ec2Home,
		Ec2PrivateKey,
		Ec2Cert,
		snapId,
		block[:fqdn],
		block[:device]
	]
	puts "CMD(tagSnap): %s" % cmdTagSnapshot
	system( cmdTagSnapshot )
end


