-- MySQL dump 10.13  Distrib 5.1.43, for unknown-linux-gnu (x86_64)
--
-- Host: localhost    Database: bits
-- ------------------------------------------------------
-- Server version	5.1.43-enterprise-gpl-advanced-log

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
-- Table structure for table `about_statement_prefix`
--

DROP TABLE IF EXISTS `about_statement_prefix`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `about_statement_prefix` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `prefix` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `prefix` (`prefix`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `banned_email_domain`
--

DROP TABLE IF EXISTS `banned_email_domain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `banned_email_domain` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `domain` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `domain_uq` (`domain`)
) ENGINE=InnoDB AUTO_INCREMENT=968 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_decal_lookup`
--

DROP TABLE IF EXISTS `content_decal_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_decal_lookup` (
  `release_id` varchar(50) NOT NULL,
  `decal_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`release_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_providers`
--

DROP TABLE IF EXISTS `content_providers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_providers` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `access_key` varchar(64) NOT NULL,
  `secret_key` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `access_key` (`access_key`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_video_catalog`
--

DROP TABLE IF EXISTS `content_video_catalog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_video_catalog` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `release_id` varchar(50) DEFAULT NULL,
  `provider_id` int(10) unsigned DEFAULT NULL,
  `third_party_id` varchar(64) DEFAULT NULL,
  `date_effective` datetime NOT NULL,
  `date_expire` datetime DEFAULT NULL,
  `ptz_value` int(10) unsigned NOT NULL,
  `duration_seconds` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `video_id_release_id_uq` (`release_id`),
  UNIQUE KEY `release_id` (`release_id`)
) ENGINE=InnoDB AUTO_INCREMENT=31049 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_video_catalog_bak`
--

DROP TABLE IF EXISTS `content_video_catalog_bak`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_video_catalog_bak` (
  `id` int(10) unsigned NOT NULL DEFAULT '0',
  `release_id` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `provider_id` int(10) unsigned DEFAULT NULL,
  `third_party_id` varchar(64) CHARACTER SET utf8 DEFAULT NULL,
  `date_effective` datetime NOT NULL,
  `date_expire` datetime DEFAULT NULL,
  `ptz_value` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `duration_seconds` int(10) unsigned DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_video_category`
--

DROP TABLE IF EXISTS `content_video_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_video_category` (
  `id` smallint(5) unsigned NOT NULL,
  `parent_id` smallint(5) unsigned NOT NULL,
  `title` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_content_category_parent_id` (`parent_id`),
  CONSTRAINT `FK_content_category_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `content_video_category` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_video_metadata`
--

DROP TABLE IF EXISTS `content_video_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_video_metadata` (
  `content_id` int(10) unsigned NOT NULL,
  `media_id` varchar(100) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `description` text,
  `approved` tinyint(1) NOT NULL DEFAULT '0',
  `remote_updated` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY `FK_metadata_content_id` (`content_id`),
  CONSTRAINT `FK_metadata_content_id` FOREIGN KEY (`content_id`) REFERENCES `content_video_catalog` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_video_ptz_defaults`
--

DROP TABLE IF EXISTS `content_video_ptz_defaults`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_video_ptz_defaults` (
  `min_duration` int(10) unsigned NOT NULL,
  `default_ptz` int(10) unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `daily_post`
--

DROP TABLE IF EXISTS `daily_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `daily_post` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `date_post` datetime NOT NULL,
  `banner_image` varchar(100) NOT NULL,
  `daily_post_type_id` tinyint(3) unsigned NOT NULL,
  `ptz_value` smallint(5) unsigned NOT NULL,
  `expose_statistics` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK_daily_post_type_id` (`daily_post_type_id`),
  CONSTRAINT `FK_daily_post_type_id` FOREIGN KEY (`daily_post_type_id`) REFERENCES `daily_post_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=933 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `daily_post_option`
--

DROP TABLE IF EXISTS `daily_post_option`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `daily_post_option` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `post_id` mediumint(8) unsigned NOT NULL,
  `caption` varchar(100) NOT NULL,
  `ptz_value` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_daily_post_option_post_id` (`post_id`),
  CONSTRAINT `FK_daily_post_option_post_id` FOREIGN KEY (`post_id`) REFERENCES `daily_post` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1911 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `daily_post_statistic`
--

DROP TABLE IF EXISTS `daily_post_statistic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `daily_post_statistic` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `daily_post_id` int(10) unsigned NOT NULL,
  `daily_post_option_id` int(10) unsigned NOT NULL,
  `votes` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_daily_post_statistic` (`daily_post_id`,`daily_post_option_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1755 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `daily_post_type`
--

DROP TABLE IF EXISTS `daily_post_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `daily_post_type` (
  `id` tinyint(3) unsigned NOT NULL,
  `title` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `decal_bundle_info`
--

DROP TABLE IF EXISTS `decal_bundle_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `decal_bundle_info` (
  `bundle_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created` datetime NOT NULL,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`bundle_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `decal_bundle_map`
--

DROP TABLE IF EXISTS `decal_bundle_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `decal_bundle_map` (
  `bundle_id` int(10) unsigned NOT NULL,
  `decal_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`bundle_id`,`decal_id`),
  KEY `FK_decal_bundle_decal_id` (`decal_id`),
  CONSTRAINT `FK_decal_bundle_bundle_id` FOREIGN KEY (`bundle_id`) REFERENCES `decal_bundle_info` (`bundle_id`),
  CONSTRAINT `FK_decal_bundle_decal_id` FOREIGN KEY (`decal_id`) REFERENCES `decal_master` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `decal_bundle_meta_info`
--

DROP TABLE IF EXISTS `decal_bundle_meta_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `decal_bundle_meta_info` (
  `bundle_id` int(10) unsigned NOT NULL,
  `name` varchar(50) NOT NULL,
  `info` varchar(50) NOT NULL,
  KEY `FK_meta_bundle_id` (`bundle_id`),
  CONSTRAINT `FK_decal_bundle_meta_bundle_id` FOREIGN KEY (`bundle_id`) REFERENCES `decal_bundle_info` (`bundle_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `decal_bundle_type_map`
--

DROP TABLE IF EXISTS `decal_bundle_type_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `decal_bundle_type_map` (
  `bundle_id` int(10) unsigned NOT NULL,
  `bundle_type` int(10) unsigned NOT NULL,
  KEY `FK_decal_bundle_type_bundle_id` (`bundle_id`),
  KEY `FK_decal_bundle_type_type` (`bundle_type`),
  CONSTRAINT `FK_decal_bundle_type_bundle_id` FOREIGN KEY (`bundle_id`) REFERENCES `decal_bundle_info` (`bundle_id`),
  CONSTRAINT `FK_decal_bundle_type_type` FOREIGN KEY (`bundle_type`) REFERENCES `decal_bundle_types` (`bundle_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `decal_bundle_types`
--

DROP TABLE IF EXISTS `decal_bundle_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `decal_bundle_types` (
  `bundle_type` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type_name` varchar(50) NOT NULL,
  PRIMARY KEY (`bundle_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `decal_master`
--

DROP TABLE IF EXISTS `decal_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `decal_master` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `decal_type_category_id` int(10) unsigned NOT NULL,
  `name` varchar(100) DEFAULT 'UNNAMED DECAL',
  `decal_image_url` varchar(256) NOT NULL,
  `decal_detail_image_url` varchar(256) NOT NULL,
  `decal_click_url` varchar(256) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '1',
  `created` datetime DEFAULT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `FK_user_decal_type_category_id` (`decal_type_category_id`),
  CONSTRAINT `FK_user_decal_type_category_id` FOREIGN KEY (`decal_type_category_id`) REFERENCES `decal_type_category` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9794 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `decal_type_category`
--

DROP TABLE IF EXISTS `decal_type_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `decal_type_category` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `decal_type` varchar(100) NOT NULL,
  `category` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQUE_type_category` (`decal_type`,`category`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `giftcards`
--

DROP TABLE IF EXISTS `giftcards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `giftcards` (
  `id` char(43) NOT NULL,
  `ptz` int(11) DEFAULT NULL,
  `creator` varchar(64) DEFAULT NULL,
  `created` bigint(20) DEFAULT NULL,
  `redeemed` bigint(20) DEFAULT NULL,
  `start` bigint(20) DEFAULT NULL,
  `end` bigint(20) DEFAULT NULL,
  `uid` bigint(20) DEFAULT NULL,
  `email` varchar(64) DEFAULT NULL,
  `event` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `halloween_pid_duration`
--

DROP TABLE IF EXISTS `halloween_pid_duration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `halloween_pid_duration` (
  `pid` varchar(200) NOT NULL DEFAULT '',
  `duration` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`pid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
-- Table structure for table `hallway_lockerz_message`
--

DROP TABLE IF EXISTS `hallway_lockerz_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hallway_lockerz_message` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `message` longtext NOT NULL,
  `date_posted` datetime NOT NULL,
  `event_type_id` tinyint(3) unsigned NOT NULL,
  `is_required` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK_hallway_lockerz_message_event_type_id` (`event_type_id`),
  CONSTRAINT `FK_hallway_lockerz_message_event_type_id` FOREIGN KEY (`event_type_id`) REFERENCES `hallway_event_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3024 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hallway_lockerz_message_bak`
--

DROP TABLE IF EXISTS `hallway_lockerz_message_bak`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hallway_lockerz_message_bak` (
  `id` int(10) unsigned NOT NULL DEFAULT '0',
  `message` longtext CHARACTER SET utf8 NOT NULL,
  `date_posted` datetime NOT NULL,
  `event_type_id` tinyint(3) unsigned NOT NULL,
  `is_required` tinyint(3) unsigned NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `network`
--

DROP TABLE IF EXISTS `network`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `network` (
  `id` varchar(100) NOT NULL,
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `node`
--

DROP TABLE IF EXISTS `node`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `node` (
  `ip` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL DEFAULT '',
  `hostname` varchar(100) DEFAULT NULL,
  `service_class_id` int(10) unsigned NOT NULL,
  `proxy_string` varchar(100) NOT NULL,
  `scalr_farm` varchar(100) DEFAULT NULL,
  `enabled` tinyint(4) NOT NULL DEFAULT '1',
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id` int(10) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_ip_name_serviceclassid` (`ip`,`name`,`service_class_id`),
  KEY `FK_node_service_class` (`service_class_id`),
  CONSTRAINT `FK_node_service_class` FOREIGN KEY (`service_class_id`) REFERENCES `service_class` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=167 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notes`
--

DROP TABLE IF EXISTS `notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `text` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `optout_email`
--

DROP TABLE IF EXISTS `optout_email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `optout_email` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `ip_address` varchar(15) NOT NULL,
  `date_submitted` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_uq` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=108350 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ptz_type`
--

DROP TABLE IF EXISTS `ptz_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ptz_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint(3) unsigned NOT NULL,
  `title` varchar(100) NOT NULL,
  `role_id` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `ptz_value` smallint(6) NOT NULL DEFAULT '0',
  `ptz_value_factor` float unsigned NOT NULL DEFAULT '1',
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ptz_subtype` smallint(6) unsigned NOT NULL DEFAULT '0',
  `use_supplied_ptz_value` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK_ptz_value_role_id` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ptz_type_bak`
--

DROP TABLE IF EXISTS `ptz_type_bak`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ptz_type_bak` (
  `id` smallint(5) unsigned NOT NULL,
  `type` tinyint(3) unsigned NOT NULL,
  `title` varchar(100) CHARACTER SET utf8 NOT NULL,
  `role_id` tinyint(3) unsigned DEFAULT NULL,
  `ptz_value` smallint(6) DEFAULT NULL,
  `ptz_value_factor` float unsigned DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ptz_subtype` int(10) unsigned DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ptz_type_bk1121`
--

DROP TABLE IF EXISTS `ptz_type_bk1121`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ptz_type_bk1121` (
  `id` smallint(5) unsigned NOT NULL,
  `type` tinyint(3) unsigned NOT NULL,
  `title` varchar(100) CHARACTER SET utf8 NOT NULL,
  `role_id` tinyint(3) unsigned DEFAULT NULL,
  `ptz_value` smallint(6) DEFAULT NULL,
  `ptz_value_factor` float unsigned DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ptz_subtype` int(10) unsigned DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ptz_type_bk_3`
--

DROP TABLE IF EXISTS `ptz_type_bk_3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ptz_type_bk_3` (
  `id` smallint(5) unsigned NOT NULL,
  `type` tinyint(3) unsigned NOT NULL,
  `title` varchar(100) CHARACTER SET utf8 NOT NULL,
  `role_id` tinyint(3) unsigned DEFAULT NULL,
  `ptz_value` smallint(6) DEFAULT NULL,
  `ptz_value_factor` float unsigned DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ptz_subtype` int(10) unsigned DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ptz_type_bk_login40`
--

DROP TABLE IF EXISTS `ptz_type_bk_login40`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ptz_type_bk_login40` (
  `id` smallint(5) unsigned NOT NULL,
  `type` tinyint(3) unsigned NOT NULL,
  `title` varchar(100) CHARACTER SET utf8 NOT NULL,
  `role_id` tinyint(3) unsigned DEFAULT NULL,
  `ptz_value` smallint(6) DEFAULT NULL,
  `ptz_value_factor` float unsigned DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ptz_subtype` int(10) unsigned DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ptz_type_bk_v5x`
--

DROP TABLE IF EXISTS `ptz_type_bk_v5x`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ptz_type_bk_v5x` (
  `id` smallint(5) unsigned NOT NULL,
  `type` tinyint(3) unsigned NOT NULL,
  `title` varchar(100) CHARACTER SET utf8 NOT NULL,
  `role_id` tinyint(3) unsigned DEFAULT NULL,
  `ptz_value` smallint(6) DEFAULT NULL,
  `ptz_value_factor` float unsigned DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ptz_subtype` int(10) unsigned DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ptz_type_bk_v5x1127`
--

DROP TABLE IF EXISTS `ptz_type_bk_v5x1127`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ptz_type_bk_v5x1127` (
  `id` smallint(5) unsigned NOT NULL,
  `type` tinyint(3) unsigned NOT NULL,
  `title` varchar(100) CHARACTER SET utf8 NOT NULL,
  `role_id` tinyint(3) unsigned DEFAULT NULL,
  `ptz_value` smallint(6) DEFAULT NULL,
  `ptz_value_factor` float unsigned DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ptz_subtype` int(10) unsigned DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
-- Table structure for table `service_class`
--

DROP TABLE IF EXISTS `service_class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_class` (
  `id` int(10) unsigned NOT NULL,
  `name` varchar(100) NOT NULL,
  `network_id` varchar(100) NOT NULL,
  `scalr_farm` varchar(100) NOT NULL,
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_service_class_network` (`name`,`network_id`),
  KEY `FK_service_class_network` (`network_id`),
  CONSTRAINT `FK_service_class_network` FOREIGN KEY (`network_id`) REFERENCES `network` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `temp_halloween_pid`
--

DROP TABLE IF EXISTS `temp_halloween_pid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temp_halloween_pid` (
  `pid` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`pid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `temp_hallway_lockerz_message`
--

DROP TABLE IF EXISTS `temp_hallway_lockerz_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temp_hallway_lockerz_message` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `message` longtext NOT NULL,
  `date_posted` datetime NOT NULL,
  `event_type_id` tinyint(3) unsigned NOT NULL,
  `is_required` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK_hallway_lockerz_message_event_type_id` (`event_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=370 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `template`
--

DROP TABLE IF EXISTS `template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `template` (
  `name` varchar(100) NOT NULL,
  `content` longtext NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2011-07-21  5:58:39
