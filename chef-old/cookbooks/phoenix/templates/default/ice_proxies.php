<?php
self::$service_dsns = array(
    'user' => array(
        'name' => '::com::lockerz::phoenix::slice::UserService',
        'proxy_location' => 'UserService:tcp -h 10.211.146.111 -p 10100 -t 10000:tcp -h 10.248.55.191 -p 10100 -t 10000:tcp -h 10.242.198.176 -p 10100 -t 10000:tcp -h 10.211.50.159 -p 10100 -t 10000'
    ),
   'authentication' => array(
        'name' => '::com::lockerz::phoenix::slice::AuthenticationService',
        'proxy_location' => 'AuthenticationService:tcp -h 10.248.230.31 -p 10200 -t 10000:tcp -h 10.212.71.175 -p 10200 -t 10000'
    ),
    'email' => array(
        'name' => '::com::lockerz::phoenix::slice::EmailService',
        'proxy_location' => 'EmailService:tcp -h 10.249.106.48 -p 10400 -t 10000:tcp -h 10.254.41.220 -p 10400 -t 10000'
    ),
    'invitation' => array(
        'name' => '::com::lockerz::phoenix::slice::InvitationService',
        'proxy_location' => 'InvitationService:tcp -h 10.212.114.111 -p 10500 -t 10000:tcp -h 10.244.47.16 -p 10500 -t 10000'
    ),
    'dailies' => array(
        'name' => '::com::lockerz::phoenix::slice::DailiesService',
        'proxy_location' => 'DailiesService:tcp -h 10.249.107.32 -p 10700 -t 10000:tcp -h 10.215.202.111 -p 10700 -t 10000'
    ),
    'hallway' => array(
        'name' => '::com::lockerz::phoenix::slice::HallwayService',
        'proxy_location' => 'HallwayService:tcp -h 10.209.194.112 -p 10800 -t 10000:tcp -h 10.210.49.172 -p 10800 -t 10000'
    ),
    'ptz' => array(
        'name' => '::com::lockerz::phoenix::slice::PtzService',
        'proxy_location' => 'PtzService:tcp -h 10.210.179.192 -p 10900 -t 10000:tcp -h 10.209.54.240 -p 10900 -t 10000'
    ),
    'content' => array(
        'name' => '::com::lockerz::phoenix::slice::ContentService',
        'proxy_location' => 'ContentService:tcp -h 10.214.247.160 -p 11000 -t 10000:tcp -h 10.211.169.140 -p 11000 -t 10000'
    ),
    'ptzadmin' => array(
        'name' => '::com::lockerz::phoenix::slice::PtzServiceAdmin',
        'proxy_location' => 'PtzServiceAdmin:tcp -h 10.210.179.192 -p 10950 -t 10000:tcp -h 10.209.54.240 -p 10950 -t 10000'
    ),
    'dailies_admin' => array(
        'name' => '::com::lockerz::phoenix::slice::DailiesServiceAdmin',
        'proxy_location' => 'DailiesServiceAdmin:tcp -h 10.249.107.32 -p 10750 -t 10000:tcp -h 10.215.202.111 -p 10750 -t 10000'
    ),
    'content_admin' => array(
        'name' => '::com::lockerz::phoenix::slice::ContentServiceAdmin',
        'proxy_location' => 'ContentServiceAdmin:tcp -h 10.214.247.160 -p 11050 -t 10000:tcp -h 10.211.169.140 -p 11050 -t 10000'
    ),
    'social' => array(
        'name' => '::com::lockerz::phoenix::slice::social::SocialService',
        'proxy_location' => 'SocialService:tcp -h 10.209.207.192 -p 11400 -t 10000:tcp -h 10.122.57.90 -p 11400 -t 10000'
    ),
    'media' => array(
        'name' => '::com::lockerz::phoenix::slice::MediaService',
        'proxy_location' => 'MediaService:tcp -h 10.220.166.224 -p 11600 -t 10000:tcp -h 10.249.182.207 -p 11600 -t 10000'
    ),
	'decal' => array(
        'name' => '::com::lockerz::phoenix::slice::social::DecalService',
        'proxy_location' => 'DecalService:tcp -h 10.122.251.227 -p 11800 -t 10000:tcp -h 10.249.107.207 -p 11800 -t 10000'
    ),
	'decaladmin' => array(
        'name' => '::com::lockerz::phoenix::slice::social::DecalServiceAdmin',
        'proxy_location' => 'DecalServiceAdmin:tcp -h 10.122.251.227 -p 11850 -t 5000:tcp -h 10.249.107.207 -p 11850 -t 5000'
	),
    'acl' => array(
        'name' => '::com::lockerz::phoenix::slice::AccessControlService',
        'proxy_location' => 'AccessControlService:tcp -h 10.122.251.227 -p 11900 -t 10000:tcp -h 10.249.107.207 -p 11900 -t 10000'
    ),
 	'auction' => array(
		'name' => '::com::lockerz::phoenix::slice::auctions::AuctionService',
		'proxy_location' => 'AuctionService:tcp -h 10.223.55.127 -p 12000 -t 10000'
	)
);
