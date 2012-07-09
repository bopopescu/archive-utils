##
# vodpod core bits.  Throwing everything into one bucket for now.
#
# This is a one-size-fits-all solution here, nothings fansy, just getting things to work.
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @serviceOwner	Scott ( scott@lockerz.com )
keys = []

## Service ownern ( scott@lockerz.com )
keys.push( "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAndv0DHy14mg1q/f40UPqQlPE0U+ri++pheciF9KFzNnTL83TJm0DFZeHrWjRwOGcgrbQgAJadcxsTkH67qZFi19oOBWLU/dQvnuA6HjlH+KL7dRVhYrznMsjNbuJv485Y/zzReB4HzMxQtvZ+tK4AGjtXpSvuIvVOAtcW3vUg70U22oskeTnsC64K3HadUB3Wx9vcM8HBC6FBIcrAJ/oYhe3cAl1yJwljxywtEdbdVr43HdrQdn1DZR1VT1q+krLPyXkNogWWvvEXvHei1TftxyYijZqL8+FZZpEyBJwon+EGHNWsgqrdpoQuuW1uAeqG4zdTgEIF7k4/jRyndSmLw== scottp@scottp.local" )

users = search( :lockerz,"id:users" ).first

package "libpam-cracklib" 

## Opz keys.
# This will ensure that any opz user can use these accounts with their own pub keys.
search( :lockerz,"id:opz" ).first()["users"].each do |email|
	keys.push(users[email]["keys"])
end

## Deployment user. ( required for pushing code )
user_dir "deploy" do
	group "deploy"
	mk_user true
	public_keys keys
end

## Redis user. ( required for redis service )
user_dir "redis" do
	group "redis"
	mk_user true
	#public_keys keys
end


## Rails user. ( required for the rails application )
user_dir "rails" do
	home "/mnt/rails"
	group "rails"
	mk_user true
	public_keys keys
end
## Ensure that this container always exists.
directory "/mnt/rails" do
	mode "0755"
	owner "rails"
	group "rails"
	recursive true
end
## Enforcing link for rails user.
#	This is required to ensure we're always writting application data to a disk that isn't /.
link "/mnt/rails" do
	to "/home/rails"
	not_if "readlink /home/rails"
end

## Matches backend nodes ( backend%i.vodpod.prod.lockerz.us )
#puts "FQDN: %s" % node[:fqdn]
if(node[:fqdn].match( /backend/ ))
	#puts "Creating jobs"
	## Jobs user. ( required for background tasks )
	user_dir "jobs" do
		group "jobs"
		mk_user true
		public_keys keys
	end
end

## Matches solr node ( solr.vodpod.prod.lockerz.us )
if(node[:fqdn].match( /solr/ ))
	## Required for the solr service.
	user_dir "solr" do
		group "solr"
		mk_user true
		public_keys keys
	end
end

## Matches api nodes ( api%i.vodpod.prod.lockerz.us )
if(node[:fqdn].match( /api/ ))
	## API user ( ? )
	user_dir "api" do
		home "/var/www/api" ## Requires custom home directory path.
		group "api"
		shell "/bin/bash"
		mk_user true
		public_keys keys
	end
end

## Required for the nginx service.
user_dir "www-data" do
	group "www-data"
	system "true" ## System user, no home dir.
	mk_user true
	public_keys keys
end

