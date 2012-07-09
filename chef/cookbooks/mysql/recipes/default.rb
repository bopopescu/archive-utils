##
# MySQL server recipe
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

## Configuration container
directory node[:mysql][:fsConfRoot] do
	mode "0755"
	owner "mysql"
	group "mysql"
	recursive true
end

directory "%s/conf.d" % node[:mysql][:fsConfRoot] do
	mode "0755"
	owner "mysql"
	group "mysql"
	recursive true
end

directory node[:mysql][:fsRunRoot] do
	mode "0755"
	owner "mysql"
	group "mysql"
	recursive true
end

#directory node[:mysql][:fsLogRoot] do
	#mode "0755"
	#owner "mysql"
	#group "mysql"
	#recursive true
#end

## Local data
directory node[:mysql][:fsLocalDataRoot] do
	mode "0755"
	owner "mysql"
	group "mysql"
	recursive true
end

## Local logs
directory node[:mysql][:fsLocalLogRoot] do
	mode "0755"
	owner "mysql"
	group "mysql"
	recursive true
end

## EBS data container
directory node[:mysql][:fsEBSDataRoot] do
	mode "0755"
	owner "mysql"
	group "mysql"
	recursive true
end

## EBS log container
directory node[:mysql][:fsEBSLogRoot] do
	mode "0755"
	owner "mysql"
	group "mysql"
	recursive true
end

## Misc dirs for things like logs and tmp files
#["tmp","slog","elog","logs"].each do |dirName|
["tmp"].each do |dirName|
	directory "%s/%s" % [node[:mysql][:fsLocalDataRoot],dirName] do
		mode "0755"
		owner "mysql"
		group "mysql"
		action :create
		recursive true
	end
end

## Data dirs for the actual table/index data
#["mysql"].each do |dirName|
	#directory "%s/%s" % [node[:mysql][:fsEBSDataRoot],dirName] do
		#mode "0755"
		#owner "mysql"
		#group "mysql"
		#action :create
		#recursive true
	#end
#end

