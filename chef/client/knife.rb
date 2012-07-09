##
# Basic knife configuration file

current_dir = File.dirname(__FILE__)
chef_server_url          "https://chef-server.lockerz.us:8080"

log_level                :debug
log_location             STDOUT

node_name                "lockerz.com"
client_key               "%s/lockerz.com.pem" % current_dir
validation_key           "%s/lockerz.com.pem" % current_dir
validation_client_name   "lockerz.com"

cache_type 'BasicFile'
cache_options( :path => "%s/.chef/checksums" % ENV['HOME'] )

cookbook_path ["%s/svn/chef/cookbooks" % ENV['HOME']]
cookbook_loader_ignore_regexes [/.*\.svn$/]

#knife[:aws_access_key_id] = "AKIAIO6ZJBIIOKEYEGV"
#knife[:aws_secret_access_key] = "bbVJ0Cu4MCajNsuTY65ehxLRLJ3AV4XjHHBcV4BP"
knife[:aws_access_key_id] = "#{ENV['AWS_ACCESS_KEY_ID']}"
knife[:aws_secret_access_key] = "#{ENV['AWS_SECRET_ACCESS_KEY']}"
