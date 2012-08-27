#!/usr/bin/ruby
##
#
require 'rubygems'
require 'pp'
require 'uri'
require 'json'
require 'net/https'

APIUsername = "drone"
APIPassword = "orange1"

Mapping = {
	"10.46.245.209" 	=> "authentication0.phoenix.<%= @envName %>.lockerz.int",
	"10.212.71.175" 	=> "authentication1.phoenix.<%= @envName %>.lockerz.int",
	"10.122.251.227" 	=> "decal0.phoenix.<%= @envName %>.lockerz.int",
	"10.68.74.172" 		=> "decal1.phoenix.<%= @envName %>.lockerz.int",
	"10.214.247.160" 	=> "content0.phoenix.<%= @envName %>.lockerz.int",
	"10.211.169.140" 	=> "content1.phoenix.<%= @envName %>.lockerz.int",
	"10.249.106.48" 	=> "email0.phoenix.<%= @envName %>.lockerz.int",
	"10.254.41.220" 	=> "email1.phoenix.<%= @envName %>.lockerz.int",
	"10.209.194.112" 	=> "hallway0.phoenix.<%= @envName %>.lockerz.int",
	"10.210.49.172" 	=> "hallway1.phoenix.<%= @envName %>.lockerz.int",
	"10.212.114.111" 	=> "invitation0.phoenix.<%= @envName %>.lockerz.int",
	"10.204.246.144" 	=> "invitation1.phoenix.<%= @envName %>.lockerz.int",
	"10.104.41.207"		=> "memc0.site.<%= @envName %>.lockerz.int",
	"10.253.181.171"	=> "memc1.site.<%= @envName %>.lockerz.int",
	"10.244.141.188"	=> "memc2.site.<%= @envName %>.lockerz.int",
	"10.217.49.183" 	=> "memc3.site.<%= @envName %>.lockerz.int",
	"10.250.143.96" 	=> "memc4.site.<%= @envName %>.lockerz.int",
	"10.245.191.208"	=> "openmq0.dba.<%= @envName %>.lockerz.int",
	"10.248.31.223" 	=> "locator0.phoenix.<%= @envName %>.lockerz.int",
	"10.210.38.207" 	=> "locator1.phoenix.<%= @envName %>.lockerz.int",
	"10.245.205.209" 	=> "smtp0.site.<%= @envName %>.lockerz.int",
	"10.220.166.224" 	=> "media0.phoenix.<%= @envName %>.lockerz.int",
	"10.249.182.207" 	=> "media1.phoenix.<%= @envName %>.lockerz.int",

	"10.102.35.223" 	=> "site0.dba.<%= @envName %>.lockerz.int",
	"10.102.35.223" 	=> "site1.dba.<%= @envName %>.lockerz.int",
	"10.104.7.183"		=> "forum0.dba.<%= @envName %>.lockerz.int",
	"10.102.43.174"		=> "social0.dba.<%= @envName %>.lockerz.int",
	"10.102.43.174"		=> "social1.dba.<%= @envName %>.lockerz.int",
	"10.102.41.151"		=> "media0.dba.<%= @envName %>.lockerz.int",
	"10.102.41.151"		=> "media1.dba.<%= @envName %>.lockerz.int",
	"10.102.9.172"		=> "auctionproxy0.dba.<%= @envName %>.lockerz.int",
	"10.102.9.172"		=> "auctionproxy1.dba.<%= @envName %>.lockerz.int",
	"10.102.9.172"		=> "payment0.dba.<%= @envName %>.lockerz.int",
	"10.102.9.172"		=> "payment1.dba.<%= @envName %>.lockerz.int",

	"10.78.11.159" 		=> "comments0.dba.<%= @envName %>.lockerz.int",
	"10.102.45.189" 	=> "fwbmaster.dba.<%= @envName %>.lockerz.int",
	"10.218.41.53" 		=> "fwbslave.dba.<%= @envName %>.lockerz.int",
	"10.209.54.240"		=> "ptz0.phoenix.<%= @envName %>.lockerz.int",
	"10.210.179.192"	=> "ptz1.phoenix.<%= @envName %>.lockerz.int",
	"10.209.207.192"	=> "social0.phoenix.<%= @envName %>.lockerz.int",
	"10.96.233.225"		=> "social1.phoenix.<%= @envName %>.lockerz.int",
	"10.122.57.90"		=> "social2.phoenix.<%= @envName %>.lockerz.int",
	"10.116.242.146"	=> "social3.phoenix.<%= @envName %>.lockerz.int",
	"10.218.35.155" 	=> "solr0.dba.<%= @envName %>.lockerz.int",
	"10.218.35.187" 	=> "solr1.dba.<%= @envName %>.lockerz.int",
	"10.241.98.239" 	=> "sls0.phoenix.<%= @envName %>.lockerz.int",
	"10.114.171.93"		=> "topic0.phoenix.<%= @envName %>.lockerz.int",
	"10.110.30.68"		=> "topic1.phoenix.<%= @envName %>.lockerz.int",
	"10.96.222.153"		=> "topic2.phoenix.<%= @envName %>.lockerz.int",
	"10.211.146.111"	=> "user0.phoenix.<%= @envName %>.lockerz.int",
	"10.248.55.191"		=> "user1.phoenix.<%= @envName %>.lockerz.int",
	"10.242.198.176"	=> "user1.phoenix.<%= @envName %>.lockerz.int",
	"10.211.50.159"		=> "user1.phoenix.<%= @envName %>.lockerz.int",
}

## Simple little helper to push out a json list of ip's
#json = {}
#Mapping.each do |k,v|
	#(roleName,stackName) = v.scan( /^([a-z]{1,}).*\.([a-z]{1,})\.<.*/ )[0]
	#json[stackName] = {} if(json[stackName] == nil)
	#json[stackName][roleName] = [] if(json[stackName][roleName] == nil)
	#json[stackName][roleName].push( k )
#end
#puts json["phoenix"].to_json
#exit

def getNodeInfo( ip )
	uri = URI.parse( "https://locknoc.lockerz.us:9092" )

	http = Net::HTTP.new( uri.host,uri.port )
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE

	req = Net::HTTP::Get.new( "/f/%s" % ip )

	req.basic_auth( APIUsername,APIPassword )

	info = JSON.parse(http.request( req ).body)
	return info["data"]
end

#Mapping.each do |ip,hostString|
	#next if(ip != "10.245.191.208")
	#puts "Changing %s to %s" % [ip,hostString]
	#info = getNodeInfo( ip )
	#pp info
	#exit
#end

#exit


begin
	newLines = []

	#tplFile = "properties.erb"
	#outFile = "all.properties.erb"

	#tplFile = "proxies.json"
	#tplFile = "/home/bryan/tomcat/templates/default/argo/properties.erb"
	#tplFile = "/home/bryan/tomcat/templates/default/argo/prod.properties.erb"
	#outFile = "/tmp/argo.properties.erb"
	#outFile = "proxies.json.erb"

	#tplFile = "/home/bryan/phoenix/files/default/c3p0/c3p0-config.xml"
	#outFile = "/tmp/c3p0-config.xml"

	#tplFile = "/home/bryan/phoenix/templates/default/memcached.properties"
	#outFile = "/tmp/memcached.properties"

	tplFile = "/home/bryan/build/pim/trunk/config/templates/ice_proxies.php"
	outFile = "/tmp/ice_proxies.php"
	
  	File.open( tplFile ).each do |line|
		#puts line
		#(key,val) = line.chomp.split( /=/ )
		#next if(val == nil)
		#findIp = val.scan( /(10\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})/ )
		#puts "Found: %i" % findIp.size
		#next

		findIp = line.scan( /(10\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})/ )

		ips = []

		if(findIp != nil)
			findIp.each do |match|
				ip = match[0]
				#ip = findIp[0]
				if(Mapping[ip] != nil && Mapping[ip] != "")
					#puts "Replacing %s with %s" % [ip,Mapping[ip]]
					line.gsub!( ip,Mapping[ip] )
				else
					#raise Exception.new( "Unknown mapping for: %s" % ip )
					puts "Unknown mapping for: %s" % ip
				end
			end
			#puts "%s :: %s" % [key,val]
			#puts "Found ip: %s" % findIp[0]
			#ips.push( findIp[0] )
		end
	
		newLines.push( line.chomp )
	
		#ips.sort.each do |ip|
			#puts ip
		#end
  	end

	fOut = File.open( outFile,"w" )
	fOut.puts(newLines.join( "\n" ))
	fOut.close()
 
rescue => e
	puts e
	puts e.backtrace
	exit

end





