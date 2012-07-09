current_dir = File.dirname(__FILE__)
chef_server_url          "https://chef-server.lockerz.us:8080"

log_level                :info
log_location             STDOUT

node_name                "lockerz.com"
client_key               "%s/lockerz.com.pem" % current_dir
validation_client_name   "lockerz.com"
validation_key           "%s/lockerz.com.pem" % current_dir

cache_type	'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )

cookbook_path	["/home/bryan/svn/chef/cookbooks"]
cookbook_loader_ignore_regexes [/.*\.svn$/]

knife[:aws_access_key_id]     = "AKIAJAQA6V4NZZVCZK2A"
knife[:aws_secret_access_key] = "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"


