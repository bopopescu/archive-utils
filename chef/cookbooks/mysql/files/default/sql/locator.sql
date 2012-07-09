-- MySQL dump 10.13  Distrib 5.1.43, for unknown-linux-gnu (x86_64)
--
-- Host: localhost    Database: locator
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
-- Table structure for table `hydra_mapping`
--

DROP TABLE IF EXISTS `hydra_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hydra_mapping` (
  `hydra_uid` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `drupal_uid` int(10) unsigned DEFAULT NULL,
  `pod` int(11) NOT NULL,
  PRIMARY KEY (`hydra_uid`),
  UNIQUE KEY `user_id_email_uq` (`email`),
  UNIQUE KEY `drupal_uid_uq` (`drupal_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pod`
--

DROP TABLE IF EXISTS `pod`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pod` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `location` varchar(255) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `signup` tinyint(4) NOT NULL DEFAULT '0',
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tokenable`
--

DROP TABLE IF EXISTS `tokenable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tokenable` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `token` varchar(200) NOT NULL,
  `creator_uid` int(10) unsigned NOT NULL,
  `reference_id` int(10) unsigned NOT NULL,
  `reference_type` tinyint(3) unsigned NOT NULL,
  `date_expires` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token_uq` (`token`),
  KEY `FK_tokenable_user_id` (`creator_uid`),
  CONSTRAINT `FK_tokenable_user_id` FOREIGN KEY (`creator_uid`) REFERENCES `user_id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=82397287 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_id`
--

DROP TABLE IF EXISTS `user_id`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_id` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `drupal_uid` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id_email_uq` (`email`),
  UNIQUE KEY `drupal_uid_uq` (`drupal_uid`)
) ENGINE=InnoDB AUTO_INCREMENT=19173081 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_lookup`
--

DROP TABLE IF EXISTS `user_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_lookup` (
  `uid` int(10) unsigned NOT NULL,
  `pid` int(10) unsigned NOT NULL,
  `email` varchar(100) NOT NULL,
  `normalized_email` varchar(100) NOT NULL,
  `created` datetime DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `norm_email_uq` (`normalized_email`),
  UNIQUE KEY `user_id_email_uq` (`email`),
  KEY `FK_user_lookup_user_id` (`uid`),
  KEY `FK_user_lookup_pod` (`pid`),
  CONSTRAINT `FK_user_lookup_user_id` FOREIGN KEY (`uid`) REFERENCES `user_id` (`id`)
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

-- Dump completed on 2011-07-21  5:58:01
