##
# Attributes for the httpd recipes
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

## Document root
default[:fsDocRoot] = "/var/www/lockerz.com"

## Logging container
default[:fsLogRoot] = "/mnt/local/lockerz.com/logs/httpd"

## Cache type data
default[:fsCacheRoot] = "/mnt/local/lockerz.com/cache"

## Asset container 
default[:fsAssetRoot] = "/mnt/local/lockerz.com/assets"
