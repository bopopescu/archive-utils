-- MySQL dump 10.13  Distrib 5.5.13, for Linux (x86_64)
--
-- Host: ENV_NAME Database: pod1
-- ------------------------------------------------------
-- Server version	5.1.57-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `content_video_consumed`
--

DROP TABLE IF EXISTS `content_video_consumed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_video_consumed` (
  `uid` int(10) NOT NULL,
  `content_id` int(10) NOT NULL,
  `date_consumed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `watch_count` int(10) NOT NULL DEFAULT '1',
  UNIQUE KEY `UQ_video_content_consumed` (`uid`,`content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `content_video_consumed`
--

LOCK TABLES `content_video_consumed` WRITE;
/*!40000 ALTER TABLE `content_video_consumed` DISABLE KEYS */;
/*!40000 ALTER TABLE `content_video_consumed` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `country`
--

DROP TABLE IF EXISTS `country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `country` (
  `code` char(2) NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `country`
--

LOCK TABLES `country` WRITE;
/*!40000 ALTER TABLE `country` DISABLE KEYS */;
INSERT INTO `country` VALUES ('AD','Andorra'),('AE','United Arab Emirates'),('AF','Afghanistan'),('AG','Antigua And Barbuda'),('AI','Anguilla'),('AL','Albania'),('AM','Armenia'),('AN','Netherlands Antilles'),('AO','Angola'),('AQ','Antarctica'),('AR','Argentina'),('AS','American Samoa'),('AT','Austria'),('AU','Australia'),('AW','Aruba'),('AZ','Azerbaijan'),('BA','Bosnia And Herzegovina'),('BB','Barbados'),('BD','Bangladesh'),('BE','Belgium'),('BF','Burkina Faso'),('BG','Bulgaria'),('BH','Bahrain'),('BI','Burundi'),('BJ','Benin'),('BM','Bermuda'),('BN','Brunei Darussalam'),('BO','Bolivia'),('BR','Brazil'),('BS','Bahamas'),('BT','Bhutan'),('BV','Bouvet Island'),('BW','Botswana'),('BY','Belarus'),('BZ','Belize'),('CA','Canada'),('CC','Cocos (keeling) Islands'),('CD','Congo, The Democratic Republic Of The'),('CF','Central African Republic'),('CG','Congo'),('CH','Switzerland'),('CI','Cote D\'ivoire'),('CK','Cook Islands'),('CL','Chile'),('CM','Cameroon'),('CN','China'),('CO','Colombia'),('CR','Costa Rica'),('CU','Cuba'),('CV','Cape Verde'),('CX','Christmas Island'),('CY','Cyprus'),('CZ','Czech Republic'),('DE','Germany'),('DJ','Djibouti'),('DK','Denmark'),('DM','Dominica'),('DO','Dominican Republic'),('DZ','Algeria'),('EC','Ecuador'),('EE','Estonia'),('EG','Egypt'),('EH','Western Sahara'),('ER','Eritrea'),('ES','Spain'),('ET','Ethiopia'),('FI','Finland'),('FJ','Fiji'),('FK','Falkland Islands (malvinas)'),('FM','Micronesia, Federated States Of'),('FO','Faroe Islands'),('FR','France'),('GA','Gabon'),('GB','United Kingdom'),('GD','Grenada'),('GE','Georgia'),('GF','French Guiana'),('GH','Ghana'),('GI','Gibraltar'),('GL','Greenland'),('GM','Gambia'),('GN','Guinea'),('GP','Guadeloupe'),('GQ','Equatorial Guinea'),('GR','Greece'),('GS','South Georgia And The South Sandwich Islands'),('GT','Guatemala'),('GU','Guam'),('GW','Guinea-bissau'),('GY','Guyana'),('HK','Hong Kong'),('HM','Heard Island And Mcdonald Islands'),('HN','Honduras'),('HR','Croatia'),('HT','Haiti'),('HU','Hungary'),('ID','Indonesia'),('IE','Ireland'),('IL','Israel'),('IN','India'),('IO','British Indian Ocean Territory'),('IQ','Iraq'),('IR','Iran, Islamic Republic Of'),('IS','Iceland'),('IT','Italy'),('JM','Jamaica'),('JO','Jordan'),('JP','Japan'),('KE','Kenya'),('KG','Kyrgyzstan'),('KH','Cambodia'),('KI','Kiribati'),('KM','Comoros'),('KN','Saint Kitts And Nevis'),('KP','Korea, Democratic People\'s Republic Of'),('KR','Korea, Republic Of'),('KV','Kosovo'),('KW','Kuwait'),('KY','Cayman Islands'),('KZ','Kazakstan'),('LA','Lao People\'s Democratic Republic'),('LB','Lebanon'),('LC','Saint Lucia'),('LI','Liechtenstein'),('LK','Sri Lanka'),('LR','Liberia'),('LS','Lesotho'),('LT','Lithuania'),('LU','Luxembourg'),('LV','Latvia'),('LY','Libyan Arab Jamahiriya'),('MA','Morocco'),('MC','Monaco'),('MD','Moldova, Republic Of'),('ME','Montenegro'),('MG','Madagascar'),('MH','Marshall Islands'),('MK','Macedonia, The Former Yugoslav Republic Of'),('ML','Mali'),('MM','Myanmar'),('MN','Mongolia'),('MO','Macau'),('MP','Northern Mariana Islands'),('MQ','Martinique'),('MR','Mauritania'),('MS','Montserrat'),('MT','Malta'),('MU','Mauritius'),('MV','Maldives'),('MW','Malawi'),('MX','Mexico'),('MY','Malaysia'),('MZ','Mozambique'),('NA','Namibia'),('NC','New Caledonia'),('NE','Niger'),('NF','Norfolk Island'),('NG','Nigeria'),('NI','Nicaragua'),('NL','Netherlands'),('NO','Norway'),('NP','Nepal'),('NR','Nauru'),('NU','Niue'),('NZ','New Zealand'),('OM','Oman'),('PA','Panama'),('PE','Peru'),('PF','French Polynesia'),('PG','Papua New Guinea'),('PH','Philippines'),('PK','Pakistan'),('PL','Poland'),('PM','Saint Pierre And Miquelon'),('PN','Pitcairn'),('PR','Puerto Rico'),('PS','Palestinian Territory, Occupied'),('PT','Portugal'),('PW','Palau'),('PY','Paraguay'),('QA','Qatar'),('RE','Reunion'),('RO','Romania'),('RS','Serbia'),('RU','Russian Federation'),('RW','Rwanda'),('SA','Saudi Arabia'),('SB','Solomon Islands'),('SC','Seychelles'),('SD','Sudan'),('SE','Sweden'),('SG','Singapore'),('SH','Saint Helena'),('SI','Slovenia'),('SJ','Svalbard And Jan Mayen'),('SK','Slovakia'),('SL','Sierra Leone'),('SM','San Marino'),('SN','Senegal'),('SO','Somalia'),('SR','Suriname'),('ST','Sao Tome And Principe'),('SV','El Salvador'),('SY','Syrian Arab Republic'),('SZ','Swaziland'),('TC','Turks And Caicos Islands'),('TD','Chad'),('TF','French Southern Territories'),('TG','Togo'),('TH','Thailand'),('TJ','Tajikistan'),('TK','Tokelau'),('TM','Turkmenistan'),('TN','Tunisia'),('TO','Tonga'),('TP','East Timor'),('TR','Turkey'),('TT','Trinidad And Tobago'),('TV','Tuvalu'),('TW','Taiwan, Province Of China'),('TZ','Tanzania, United Republic Of'),('UA','Ukraine'),('UG','Uganda'),('UM','United States Minor Outlying Islands'),('US','United States'),('UY','Uruguay'),('UZ','Uzbekistan'),('VA','Holy See (vatican City State)'),('VC','Saint Vincent And The Grenadines'),('VE','Venezuela'),('VG','Virgin Islands, British'),('VI','Virgin Islands, U.s.'),('VN','Viet Nam'),('VU','Vanuatu'),('WF','Wallis And Futuna'),('WS','Samoa'),('YE','Yemen'),('YT','Mayotte'),('ZA','South Africa'),('ZM','Zambia'),('ZW','Zimbabwe'),('ZZ','Unspecified Country');
/*!40000 ALTER TABLE `country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `daily_post_answer`
--

DROP TABLE IF EXISTS `daily_post_answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `daily_post_answer` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(10) unsigned NOT NULL,
  `daily_post_id` int(10) unsigned NOT NULL,
  `daily_post_option_id` int(10) unsigned DEFAULT NULL,
  `answer` varchar(500) DEFAULT NULL,
  `date_answered` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_poster_daily` (`uid`,`daily_post_id`),
  CONSTRAINT `FK_daily_poster_user_id` FOREIGN KEY (`uid`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `daily_post_answer`
--

LOCK TABLES `daily_post_answer` WRITE;
/*!40000 ALTER TABLE `daily_post_answer` DISABLE KEYS */;
/*!40000 ALTER TABLE `daily_post_answer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `decals_clicked`
--

DROP TABLE IF EXISTS `decals_clicked`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `decals_clicked` (
  `viewer_uid` int(10) unsigned NOT NULL,
  `decal_id` int(10) unsigned NOT NULL,
  `created` datetime NOT NULL,
  UNIQUE KEY `viewer_uid_decal_id` (`viewer_uid`,`decal_id`),
  CONSTRAINT `FK_decals_consumed_viewer_uid` FOREIGN KEY (`viewer_uid`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `decals_clicked`
--

LOCK TABLES `decals_clicked` WRITE;
/*!40000 ALTER TABLE `decals_clicked` DISABLE KEYS */;
/*!40000 ALTER TABLE `decals_clicked` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `direct_message`
--

DROP TABLE IF EXISTS `direct_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `direct_message` (
  `id` varchar(50) NOT NULL,
  `uid` int(10) unsigned NOT NULL,
  `sender` int(10) unsigned NOT NULL,
  `receiver` int(10) unsigned NOT NULL,
  `message_text` varchar(1000) NOT NULL,
  `thread_id` varchar(50) NOT NULL,
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '0 - UNREAD, 1 - READ, 2 - DELETED',
  `flagged` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '0 - FLAG_OFF, 1 - FLAG_ON',
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_direct_message_uid` (`uid`),
  KEY `FK_direct_message_sender` (`sender`),
  KEY `FK_direct_message_receiver` (`receiver`),
  KEY `FK_direct_message_thread_id` (`thread_id`),
  CONSTRAINT `FK_direct_message_receiver` FOREIGN KEY (`receiver`) REFERENCES `user` (`id`),
  CONSTRAINT `FK_direct_message_sender` FOREIGN KEY (`sender`) REFERENCES `user` (`id`),
  CONSTRAINT `FK_direct_message_thread_id` FOREIGN KEY (`thread_id`) REFERENCES `direct_message_thread` (`id`),
  CONSTRAINT `FK_direct_message_uid` FOREIGN KEY (`uid`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `direct_message`
--

LOCK TABLES `direct_message` WRITE;
/*!40000 ALTER TABLE `direct_message` DISABLE KEYS */;
/*!40000 ALTER TABLE `direct_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `direct_message_thread`
--

DROP TABLE IF EXISTS `direct_message_thread`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `direct_message_thread` (
  `id` varchar(50) NOT NULL,
  `uid` int(10) unsigned NOT NULL,
  `sender` int(10) unsigned NOT NULL,
  `receiver` int(10) unsigned NOT NULL,
  `subject` varchar(150) NOT NULL,
  `updated` datetime NOT NULL,
  `message_count` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_dm_thread_uid` (`uid`),
  KEY `FK_dm_thread_sender` (`sender`),
  KEY `FK_dm_thread_receiver` (`receiver`),
  CONSTRAINT `FK_dm_thread_receiver` FOREIGN KEY (`receiver`) REFERENCES `user` (`id`),
  CONSTRAINT `FK_dm_thread_sender` FOREIGN KEY (`sender`) REFERENCES `user` (`id`),
  CONSTRAINT `FK_dm_thread_uid` FOREIGN KEY (`uid`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `direct_message_thread`
--

LOCK TABLES `direct_message_thread` WRITE;
/*!40000 ALTER TABLE `direct_message_thread` DISABLE KEYS */;
/*!40000 ALTER TABLE `direct_message_thread` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hallway_event_type`
--

DROP TABLE IF EXISTS `hallway_event_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hallway_event_type` (
  `id` tinyint(3) unsigned NOT NULL,
  `name` varchar(100) NOT NULL,
  `template` varchar(1000) DEFAULT NULL,
  `iconType` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hallway_event_type`
--

LOCK TABLES `hallway_event_type` WRITE;
/*!40000 ALTER TABLE `hallway_event_type` DISABLE KEYS */;
INSERT INTO `hallway_event_type` VALUES (1,'invitation accepted','**firstname** **lastname** has accepted your invitation',1),(2,'welcome message','Welcome to Lockerz!',4),(3,'lockerz care',NULL,0),(4,'lockerz connect',NULL,1),(5,'lockerz dailies',NULL,2),(6,'lockerz lab',NULL,3),(7,'lockerz locker',NULL,4),(8,'lockerz play',NULL,5),(9,'lockerz ptz',NULL,6),(10,'lockerz shop',NULL,7),(11,'lockerz zlist',NULL,8);
/*!40000 ALTER TABLE `hallway_event_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hallway_post`
--

DROP TABLE IF EXISTS `hallway_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hallway_post` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(10) unsigned NOT NULL,
  `event_type_id` tinyint(3) unsigned NOT NULL,
  `event_ref_id` int(10) unsigned DEFAULT NULL,
  `event_values` varchar(500) NOT NULL,
  `date_posted` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_hallway_post_user_id` (`uid`),
  KEY `FK_hallway_post_event_type_id` (`event_type_id`),
  CONSTRAINT `FK_hallway_post_event_type_id` FOREIGN KEY (`event_type_id`) REFERENCES `hallway_event_type` (`id`),
  CONSTRAINT `FK_hallway_post_user_id` FOREIGN KEY (`uid`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hallway_post`
--

LOCK TABLES `hallway_post` WRITE;
/*!40000 ALTER TABLE `hallway_post` DISABLE KEYS */;
/*!40000 ALTER TABLE `hallway_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invitation`
--

DROP TABLE IF EXISTS `invitation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invitation` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `invitation_type_id` tinyint(3) unsigned NOT NULL,
  `sender_uid` int(10) unsigned NOT NULL,
  `recipient_uid` int(10) unsigned DEFAULT NULL,
  `recipient` varchar(200) NOT NULL,
  `date_sent` datetime NOT NULL,
  `date_clicked` datetime DEFAULT NULL,
  `date_accepted` datetime DEFAULT NULL,
  `is_friend_request` tinyint(3) unsigned NOT NULL,
  `is_sent` tinyint(3) unsigned NOT NULL,
  `custom_message` varchar(300) DEFAULT NULL,
  `sender_ip_address` varchar(20) NOT NULL,
  `recipient_ip_address` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `senderUid_recipient` (`sender_uid`,`recipient`),
  KEY `FK_invitation_type_id` (`invitation_type_id`),
  CONSTRAINT `FK_invitation_sender_user_id` FOREIGN KEY (`sender_uid`) REFERENCES `user` (`id`),
  CONSTRAINT `FK_invitation_type_id` FOREIGN KEY (`invitation_type_id`) REFERENCES `invitation_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invitation`
--

LOCK TABLES `invitation` WRITE;
/*!40000 ALTER TABLE `invitation` DISABLE KEYS */;
/*!40000 ALTER TABLE `invitation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invitation_type`
--

DROP TABLE IF EXISTS `invitation_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invitation_type` (
  `id` tinyint(3) unsigned NOT NULL,
  `title` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invitation_type`
--

LOCK TABLES `invitation_type` WRITE;
/*!40000 ALTER TABLE `invitation_type` DISABLE KEYS */;
INSERT INTO `invitation_type` VALUES (0,'Email Invite'),(1,'Facebook Invite');
/*!40000 ALTER TABLE `invitation_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `language`
--

DROP TABLE IF EXISTS `language`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `language` (
  `code` char(2) NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `language`
--

LOCK TABLES `language` WRITE;
/*!40000 ALTER TABLE `language` DISABLE KEYS */;
INSERT INTO `language` VALUES ('AA','Afar'),('AB','Abkhazian'),('AF','Afrikaans'),('AM','Amharic'),('AR','Arabic'),('AS','Assamese'),('AY','Aymara'),('AZ','Azerbaijani'),('BA','Bashkir'),('BE','Byelorussian'),('BG','Bulgarian'),('BH','Bihari'),('BI','Bislama'),('BN','Bengali; Bangla'),('BO','Tibetan'),('BR','Breton'),('CA','Catalan'),('CO','Corsican'),('CS','Czech'),('CY','Welsh'),('DA','Danish'),('DE','German'),('DZ','Bhutani'),('EL','Greek'),('EN','English'),('EO','Esperanto'),('ES','Spanish'),('ET','Estonian'),('EU','Basque'),('FA','Persian'),('FI','Finnish'),('FJ','Fiji'),('FO','Faroese'),('FR','French'),('FY','Frisian'),('GA','Irish'),('GD','Scots Gaelic'),('GL','Galician'),('GN','Guarani'),('GU','Gujarati'),('HA','Hausa'),('HE','Hebrew (formerly iw)'),('HI','Hindi'),('HR','Croatian'),('HU','Hungarian'),('HY','Armenian'),('IA','Interlingua'),('ID','Indonesian (formerly in)'),('IE','Interlingue'),('IK','Inupiak'),('IS','Icelandic'),('IT','Italian'),('IU','Inuktitut'),('JA','Japanese'),('JW','Javanese'),('KA','Georgian'),('KK','Kazakh'),('KL','Greenlandic'),('KM','Cambodian'),('KN','Kannada'),('KO','Korean'),('KS','Kashmiri'),('KU','Kurdish'),('KY','Kirghiz'),('LA','Latin'),('LN','Lingala'),('LO','Laothian'),('LT','Lithuanian'),('LV','Latvian, Lettish'),('MG','Malagasy'),('MI','Maori'),('MK','Macedonian'),('ML','Malayalam'),('MN','Mongolian'),('MO','Moldavian'),('MR','Marathi'),('MS','Malay'),('MT','Maltese'),('MY','Burmese'),('NA','Nauru'),('NE','Nepali'),('NL','Dutch'),('NO','Norwegian'),('OC','Occitan'),('OM','(Afan) Oromo'),('OR','Oriya'),('PA','Punjabi'),('PL','Polish'),('PS','Pashto, Pushto'),('PT','Portuguese'),('QU','Quechua'),('RM','Rhaeto-Romance'),('RN','Kirundi'),('RO','Romanian'),('RU','Russian'),('RW','Kinyarwanda'),('SA','Sanskrit'),('SD','Sindhi'),('SG','Sangho'),('SH','Serbo-Croatian'),('SI','Sinhalese'),('SK','Slovak'),('SL','Slovenian'),('SM','Samoan'),('SN','Shona'),('SO','Somali'),('SQ','Albanian'),('SR','Serbian'),('SS','Siswati'),('ST','Sesotho'),('SU','Sundanese'),('SV','Swedish'),('SW','Swahili'),('TA','Tamil'),('TE','Telugu'),('TG','Tajik'),('TH','Thai'),('TI','Tigrinya'),('TK','Turkmen'),('TL','Tagalog'),('TN','Setswana'),('TO','Tonga'),('TR','Turkish'),('TS','Tsonga'),('TT','Tatar'),('TW','Twi'),('UG','Uighur'),('UK','Ukrainian'),('UR','Urdu'),('UZ','Uzbek'),('VI','Vietnamese'),('VO','Volapuk'),('WO','Wolof'),('XH','Xhosa'),('YI','Yiddish (formerly ji)'),('YO','Yoruba'),('ZA','Zhuang'),('ZH','Chinese'),('ZU','Zulu');
/*!40000 ALTER TABLE `language` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ptz_transaction`
--

DROP TABLE IF EXISTS `ptz_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ptz_transaction` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(10) unsigned NOT NULL,
  `ptz_value` smallint(6) NOT NULL,
  `ptz_type_id` smallint(5) unsigned NOT NULL,
  `event_ref_id` int(10) unsigned DEFAULT NULL,
  `date_transaction` datetime NOT NULL,
  `ptz_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `FK_ptz_transaction_user_id` (`uid`),
  CONSTRAINT `FK_ptz_transaction_user_id` FOREIGN KEY (`uid`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ptz_transaction`
--

LOCK TABLES `ptz_transaction` WRITE;
/*!40000 ALTER TABLE `ptz_transaction` DISABLE KEYS */;
/*!40000 ALTER TABLE `ptz_transaction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ptz_type`
--

DROP TABLE IF EXISTS `ptz_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ptz_type` (
  `id` smallint(5) unsigned NOT NULL,
  `type` tinyint(3) unsigned NOT NULL,
  `title` varchar(100) NOT NULL,
  `role_id` tinyint(3) unsigned DEFAULT NULL,
  `ptz_value` mediumint(9) DEFAULT NULL,
  `ptz_value_factor` tinyint(4) NOT NULL DEFAULT '1',
  `ptz_active` tinyint(1) NOT NULL DEFAULT '1',
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_ptz_value_type_role` (`type`,`role_id`),
  KEY `FK_ptz_value_role_id` (`role_id`),
  CONSTRAINT `FK_ptz_value_role_id` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ptz_type`
--

LOCK TABLES `ptz_type` WRITE;
/*!40000 ALTER TABLE `ptz_type` DISABLE KEYS */;
INSERT INTO `ptz_type` VALUES (1,1,'SignUp',1,2,1,1,'2011-08-23 00:10:25'),(2,1,'SignUp',2,2,2,1,'2011-08-23 00:10:25'),(3,2,'SignUpGame',1,NULL,1,1,'2011-08-23 00:10:25'),(4,2,'SignUpGame',2,NULL,2,1,'2011-08-23 00:10:25'),(5,3,'DailyLogin',1,2,1,1,'2011-08-23 00:10:25'),(6,3,'DailyLogin',2,2,2,1,'2011-08-23 00:10:25'),(7,4,'AnswerDaily',1,NULL,1,1,'2011-08-23 00:10:25'),(8,4,'AnswerDaily',2,NULL,2,1,'2011-08-23 00:10:25'),(9,5,'AcceptedInvite',1,2,1,1,'2011-08-23 00:10:25'),(10,5,'AcceptedInvite',2,2,2,1,'2011-08-23 00:10:25'),(11,6,'ManualAdjustment',NULL,NULL,1,1,'2011-08-23 00:10:25'),(12,7,'Redeem',NULL,NULL,1,1,'2011-08-23 00:10:25'),(13,8,'VideoConsumed',1,NULL,1,1,'2011-08-23 00:10:25'),(14,8,'VideoConsumed',2,NULL,2,1,'2011-08-23 00:10:25'),(15,9,'ShopRedeem',NULL,NULL,1,1,'2011-08-23 00:10:25'),(16,10,'ShopAward',NULL,NULL,1,1,'2011-08-23 00:10:25'),(118,14,'DecalClick',1,1,1,1,'2011-08-23 00:10:32'),(119,14,'DecalClick',2,1,2,1,'2011-08-23 00:10:32'),(120,14,'DecalClick',3,1,2,1,'2011-08-23 00:10:32'),(121,14,'DecalClick',4,1,3,1,'2011-08-23 00:10:32'),(122,14,'DecalClick',5,1,3,1,'2011-08-23 00:10:32'),(123,14,'DecalClick',6,1,4,1,'2011-08-23 00:10:32'),(124,15,'DecalClickOwnerPtz',1,1,1,1,'2011-08-23 00:10:32'),(125,15,'DecalClickOwnerPtz',2,1,2,1,'2011-08-23 00:10:32'),(126,15,'DecalClickOwnerPtz',3,1,2,1,'2011-08-23 00:10:32'),(127,15,'DecalClickOwnerPtz',4,1,4,1,'2011-08-23 00:10:32'),(128,15,'DecalClickOwnerPtz',5,1,4,1,'2011-08-23 00:10:32'),(129,15,'DecalClickOwnerPtz',6,1,6,1,'2011-08-23 00:10:32'),(130,17,'DecalShoppedOwnerPtz',1,1,70,1,'2011-08-23 00:10:32'),(131,17,'DecalShoppedOwnerPtz',2,1,127,1,'2011-08-23 00:10:32'),(132,17,'DecalShoppedOwnerPtz',3,1,127,1,'2011-08-23 00:10:32'),(133,17,'DecalShoppedOwnerPtz',4,1,127,1,'2011-08-23 00:10:32'),(134,17,'DecalShoppedOwnerPtz',5,1,127,1,'2011-08-23 00:10:32'),(135,17,'DecalShoppedOwnerPtz',6,1,127,1,'2011-08-23 00:10:32'),(136,18,'ImageUpload',1,1,10,1,'2011-08-23 00:10:32'),(137,18,'ImageUpload',2,1,20,1,'2011-08-23 00:10:32'),(138,18,'ImageUpload',3,1,20,1,'2011-08-23 00:10:32'),(139,18,'ImageUpload',4,1,40,1,'2011-08-23 00:10:32'),(140,18,'ImageUpload',5,1,40,1,'2011-08-23 00:10:32'),(141,18,'ImageUpload',6,1,60,1,'2011-08-23 00:10:32');
/*!40000 ALTER TABLE `ptz_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role` (
  `id` tinyint(3) unsigned NOT NULL,
  `TITLE` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (1,'Regular User'),(2,'ZLister'),(3,'Silver Non-ZLister'),(4,'Silver ZLister'),(5,'Gold Non-ZLister'),(6,'Gold ZLister');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `timezone`
--

DROP TABLE IF EXISTS `timezone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `timezone` (
  `offset` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`offset`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `timezone`
--

LOCK TABLES `timezone` WRITE;
/*!40000 ALTER TABLE `timezone` DISABLE KEYS */;
INSERT INTO `timezone` VALUES (-43200,'(GMT -12:00) Eniwetok, Kwajalein'),(-39600,'(GMT -11:00) Midway Island, Samoa'),(-36000,'(GMT -10:00) Hawaii'),(-32400,'(GMT -9:00) Alaska'),(-28800,'(GMT -8:00) Pacific Time (US & Canada)'),(-25200,'(GMT -7:00) Mountain Time (US & Canada)'),(-21600,'(GMT -6:00) Central Time (US & Canada), Mexico City'),(-18000,'(GMT -5:00) Eastern Time (US & Canada), Bogota, Lima'),(-14400,'(GMT -4:00) Atlantic Time (Canada), Caracas, La Paz'),(-12600,'(GMT -3:30) Newfoundland'),(-10800,'(GMT -3:00) Brazil, Buenos Aires, Georgetown'),(-7200,'(GMT -2:00) Mid-Atlantic'),(-3600,'(GMT -1:00 hour) Azores, Cape Verde Islands'),(0,'(GMT) Western Europe Time, London, Lisbon, Casablanca'),(3600,'(GMT +1:00 hour) Brussels, Copenhagen, Madrid, Paris'),(7200,'(GMT +2:00) Kyiv, Kaliningrad, South Africa'),(10800,'(GMT +3:00) Baghdad, Riyadh, Moscow, St. Petersburg'),(12600,'(GMT +3:30) Tehran'),(14400,'(GMT +4:00) Abu Dhabi, Muscat, Baku, Tbilisi'),(16200,'(GMT +4:30) Kabul'),(18000,'(GMT +5:00) Ekaterinburg, Islamabad, Karachi, Tashkent'),(19800,'(GMT +5:30) Bombay, Calcutta, Madras, New Delhi'),(20700,'(GMT +5:45) Kathmandu'),(21600,'(GMT +6:00) Almaty, Dhaka, Colombo'),(25200,'(GMT +7:00) Bangkok, Hanoi, Jakarta'),(28800,'(GMT +8:00) Beijing, Perth, Singapore, Hong Kong'),(32400,'(GMT +9:00) Tokyo, Seoul, Osaka, Sapporo, Yakutsk'),(34200,'(GMT +9:30) Adelaide, Darwin'),(36000,'(GMT +10:00) Eastern Australia, Guam, Vladivostok'),(39600,'(GMT +11:00) Magadan, Solomon Islands, New Caledonia'),(43200,'(GMT +12:00) Auckland, Wellington, Fiji, Kamchatka');
/*!40000 ALTER TABLE `timezone` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` int(10) unsigned NOT NULL,
  `email` varchar(100) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `password` varchar(200) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL,
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_about_statement`
--

DROP TABLE IF EXISTS `user_about_statement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_about_statement` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(10) unsigned NOT NULL,
  `disp_state` tinyint(3) unsigned NOT NULL,
  `statement_prefix_id` int(11) NOT NULL,
  `statement` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_about_statement`
--

LOCK TABLES `user_about_statement` WRITE;
/*!40000 ALTER TABLE `user_about_statement` DISABLE KEYS */;
INSERT INTO `user_about_statement` VALUES (1,16223375,1,1,'asdf'),(2,16223375,1,2,'ready to start'),(3,16223375,1,3,'3333333'),(4,16223379,1,6,'testing'),(5,16223379,1,2,'ready to start'),(6,16223379,1,3,'Odyss'),(7,16223382,1,1,'asdf'),(8,16223382,1,2,'ready to start'),(9,16223382,1,3,'Odyss'),(10,19638769,1,6,'dfsdfsdfsdf'),(11,19638769,1,7,'sfsffgfefr'),(12,19638769,1,9,'referfef');
/*!40000 ALTER TABLE `user_about_statement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_address`
--

DROP TABLE IF EXISTS `user_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_address` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(10) unsigned NOT NULL,
  `address_label` varchar(15) DEFAULT NULL,
  `address_line_1` varchar(100) DEFAULT NULL,
  `address_line_2` varchar(100) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `country_code` char(2) DEFAULT NULL,
  `postal_code` varchar(15) DEFAULT NULL,
  `is_default_billing` tinyint(3) unsigned DEFAULT '0',
  `is_default_shipping` tinyint(3) unsigned DEFAULT '0',
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `FK_user_address_user_id` (`uid`),
  KEY `FK_user_address_country` (`country_code`),
  CONSTRAINT `FK_user_address_country` FOREIGN KEY (`country_code`) REFERENCES `country` (`code`),
  CONSTRAINT `FK_user_address_user_id` FOREIGN KEY (`uid`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_address`
--

LOCK TABLES `user_address` WRITE;
/*!40000 ALTER TABLE `user_address` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_decal`
--

DROP TABLE IF EXISTS `user_decal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_decal` (
  `uid` int(10) unsigned NOT NULL,
  `decal_id` int(10) unsigned NOT NULL,
  `display_status` tinyint(4) DEFAULT '0',
  `created` datetime DEFAULT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `uid_decalId` (`uid`,`decal_id`),
  CONSTRAINT `FK_user_decal_user_id` FOREIGN KEY (`uid`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_decal`
--

LOCK TABLES `user_decal` WRITE;
/*!40000 ALTER TABLE `user_decal` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_decal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_decal_events`
--

DROP TABLE IF EXISTS `user_decal_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_decal_events` (
  `uid` int(10) unsigned NOT NULL,
  `decal_id` int(10) unsigned NOT NULL,
  `user_decal_viewer_uid` int(10) unsigned NOT NULL,
  `clicked_thru_date` datetime DEFAULT NULL,
  `clicked_thru_ptz` int(10) unsigned DEFAULT NULL,
  `shopped_thru_date` datetime DEFAULT NULL,
  `shopped_thru_ptz` int(10) unsigned DEFAULT NULL,
  UNIQUE KEY `uid_decalId_viewerid` (`uid`,`decal_id`,`user_decal_viewer_uid`),
  CONSTRAINT `FK_user_decal_event_user_id` FOREIGN KEY (`uid`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_decal_events`
--

LOCK TABLES `user_decal_events` WRITE;
/*!40000 ALTER TABLE `user_decal_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_decal_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_email_settings`
--

DROP TABLE IF EXISTS `user_email_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_email_settings` (
  `uid` int(10) unsigned NOT NULL,
  `email_template` varchar(64) NOT NULL DEFAULT '',
  `flag` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`uid`,`email_template`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_email_settings`
--

LOCK TABLES `user_email_settings` WRITE;
/*!40000 ALTER TABLE `user_email_settings` DISABLE KEYS */;
INSERT INTO `user_email_settings` VALUES (16223379,'newFriendRequestEmail',1),(19638770,'newFriendRequestEmail',1);
/*!40000 ALTER TABLE `user_email_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_log`
--

DROP TABLE IF EXISTS `user_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_log` (
  `uid` int(10) unsigned NOT NULL,
  `tokenid` int(10) unsigned NOT NULL,
  `old_email` varchar(100) DEFAULT NULL,
  `new_email` varchar(100) NOT NULL,
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `tokenid_uq` (`tokenid`),
  KEY `FK_user_log_user_id` (`uid`),
  CONSTRAINT `FK_user_log_user_id` FOREIGN KEY (`uid`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_log`
--

LOCK TABLES `user_log` WRITE;
/*!40000 ALTER TABLE `user_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_metric`
--

DROP TABLE IF EXISTS `user_metric`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_metric` (
  `uid` int(10) unsigned NOT NULL,
  `num_accepted_invites` int(10) unsigned NOT NULL DEFAULT '0',
  `ptz_balance` int(11) NOT NULL DEFAULT '0',
  `pending_ptz_balance` int(11) NOT NULL DEFAULT '0',
  `image_upload_count` int(10) unsigned NOT NULL DEFAULT '0',
  `last_login` datetime DEFAULT NULL,
  `risked_ptz_balance` int(11) NOT NULL DEFAULT '0',
  KEY `FK_user_metric_user_id` (`uid`),
  CONSTRAINT `FK_user_metric_user_id` FOREIGN KEY (`uid`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_metric`
--

LOCK TABLES `user_metric` WRITE;
/*!40000 ALTER TABLE `user_metric` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_metric` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_privacy_settings`
--

DROP TABLE IF EXISTS `user_privacy_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_privacy_settings` (
  `uid` int(10) unsigned NOT NULL,
  `privacy_setting_key` varchar(64) NOT NULL DEFAULT '',
  `access_level` int(10) DEFAULT NULL,
  PRIMARY KEY (`uid`,`privacy_setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_privacy_settings`
--

LOCK TABLES `user_privacy_settings` WRITE;
/*!40000 ALTER TABLE `user_privacy_settings` DISABLE KEYS */;
INSERT INTO `user_privacy_settings` VALUES (16223379,'DecalShelf_PLAY',3),(16223379,'DecalShelf_SHOP',3),(16223379,'DecalShelf_VSHOP',3),(16223379,'FriendList',3),(16223379,'PhotoShelf',3),(16223379,'Profile_All',3),(16223379,'Profile_Image',3),(16223379,'Profile_Questions',3),(16223379,'User_Search',3),(19638770,'DecalShelf_PLAY',3),(19638770,'DecalShelf_SHOP',3),(19638770,'DecalShelf_VSHOP',3),(19638770,'FriendList',3),(19638770,'PhotoShelf',1),(19638770,'Profile_All',3),(19638770,'Profile_Image',3),(19638770,'Profile_Questions',3),(19638770,'User_Search',3);
/*!40000 ALTER TABLE `user_privacy_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_profile`
--

DROP TABLE IF EXISTS `user_profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_profile` (
  `uid` int(10) unsigned NOT NULL,
  `tshirt_size` char(3) DEFAULT NULL,
  `cellphone` varchar(20) DEFAULT NULL,
  `birthdate` date DEFAULT NULL,
  `gender` char(1) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `timezone` int(11) NOT NULL DEFAULT '1',
  `language_code` varchar(15) NOT NULL,
  `country_code` char(2) NOT NULL,
  `registration_postal_code` varchar(10) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `profile_image_id` int(10) unsigned DEFAULT NULL,
  `profile_image_url` varchar(256) DEFAULT NULL,
  KEY `FK_user_profile_user_id` (`uid`),
  KEY `FK_user_profile_timezone` (`timezone`),
  KEY `FK_user_profile_language_code` (`language_code`),
  CONSTRAINT `FK_user_profile_language_code` FOREIGN KEY (`language_code`) REFERENCES `language` (`code`),
  CONSTRAINT `FK_user_profile_timezone` FOREIGN KEY (`timezone`) REFERENCES `timezone` (`offset`),
  CONSTRAINT `FK_user_profile_user_id` FOREIGN KEY (`uid`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_profile`
--

LOCK TABLES `user_profile` WRITE;
/*!40000 ALTER TABLE `user_profile` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_role`
--

DROP TABLE IF EXISTS `user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_role` (
  `uid` int(10) unsigned NOT NULL,
  `role_id` tinyint(3) unsigned NOT NULL,
  KEY `FK_user_role_user_id` (`uid`),
  KEY `FK_user_role_role_id` (`role_id`),
  CONSTRAINT `FK_user_role_role_id` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`),
  CONSTRAINT `FK_user_role_user_id` FOREIGN KEY (`uid`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_role`
--

LOCK TABLES `user_role` WRITE;
/*!40000 ALTER TABLE `user_role` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_role_history`
--

DROP TABLE IF EXISTS `user_role_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_role_history` (
  `uid` int(10) unsigned NOT NULL,
  `old_role_id` tinyint(3) unsigned NOT NULL,
  `new_role_id` tinyint(3) unsigned NOT NULL,
  `price` float DEFAULT NULL,
  `payer_email` varchar(50) DEFAULT NULL,
  `customer_name` varchar(50) DEFAULT NULL,
  `transaction_date` varchar(50) DEFAULT NULL,
  `transaction_id` varchar(50) DEFAULT NULL,
  `effective_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expiration_date` datetime DEFAULT NULL,
  `payment_provider_id` tinyint(3) DEFAULT NULL,
  `warn_date` datetime DEFAULT NULL,
  UNIQUE KEY `UQ_transaction` (`transaction_id`,`payment_provider_id`),
  KEY `FK_user_role_hist_user_id` (`uid`),
  KEY `FK_user_role_hist_old_role_id` (`old_role_id`),
  KEY `FK_user_role_hist_new_role_id` (`new_role_id`),
  KEY `FK_payment_type` (`payment_provider_id`),
  CONSTRAINT `FK_user_role_hist_new_role_id` FOREIGN KEY (`new_role_id`) REFERENCES `role` (`id`),
  CONSTRAINT `FK_user_role_hist_old_role_id` FOREIGN KEY (`old_role_id`) REFERENCES `role` (`id`),
  CONSTRAINT `FK_user_role_hist_user_id` FOREIGN KEY (`uid`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_role_history`
--

LOCK TABLES `user_role_history` WRITE;
/*!40000 ALTER TABLE `user_role_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_role_history` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2011-09-26 21:55:14
