##
# MySQL defaults
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

default[:mysql][:fsEBSLogRoot] = "/mnt/ebs/lockerz.com/logs/mysql/"
default[:mysql][:fsEBSDataRoot] = "/mnt/ebs/lockerz.com/data/mysql/"

default[:mysql][:fsLocalLogRoot] = "/mnt/local/lockerz.com/logs/mysql/"
default[:mysql][:fsLocalDataRoot] = "/mnt/local/lockerz.com/data/mysql/"

default[:mysql][:fsLogRoot] = default[:mysql][:fsEBSLogRoot]
default[:mysql][:fsDataRoot] = default[:mysql][:fsEBSDataRoot]

default[:mysql][:fsRunRoot] = "/var/run/mysqld/"
default[:mysql][:fsConfRoot] = "/etc/mysql/"

default[:mysqlBackup][:fsLogRoot] = "/mnt/local/lockerz.com/logs/mysql/"
default[:mysqlBackup][:fsDataRoot] = "/mnt/local/lockerz.com/data/mysql/"
