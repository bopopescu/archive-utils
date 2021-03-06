-- MySQL dump 10.13  Distrib 5.5.13, for Linux (x86_64)
--
-- Host: ENV_NAME1.cmmbbmwrrirf.us-east-1.rds.amazonaws.com    Database: locator
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
-- Current Database: `locator`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `locator` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `locator`;

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
-- Dumping data for table `hydra_mapping`
--

LOCK TABLES `hydra_mapping` WRITE;
/*!40000 ALTER TABLE `hydra_mapping` DISABLE KEYS */;
/*!40000 ALTER TABLE `hydra_mapping` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `network`
--

LOCK TABLES `network` WRITE;
/*!40000 ALTER TABLE `network` DISABLE KEYS */;
INSERT INTO `network` VALUES ('ENV_NAME','2011-07-24 19:15:07');
/*!40000 ALTER TABLE `network` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `node`
--

LOCK TABLES `node` WRITE;
/*!40000 ALTER TABLE `node` DISABLE KEYS */;
INSERT INTO `node` VALUES ('user0.phoenix.ENV_NAME.lockerz.int','','user0.phoenix.ENV_NAME.lockerz.int',1,'',NULL,1,'2011-07-24 19:19:02',1),('user1.phoenix.ENV_NAME.lockerz.int','','user1.phoenix.ENV_NAME.lockerz.int',1,'',NULL,1,'2011-07-24 19:19:02',2),('authentication0.phoenix.ENV_NAME.lockerz.int','','authentication0.phoenix.ENV_NAME.lockerz.int',2,'',NULL,1,'2011-07-24 19:19:21',3),('authentication1.phoenix.ENV_NAME.lockerz.int','','authentication1.phoenix.ENV_NAME.lockerz.int',2,'',NULL,1,'2011-07-24 19:19:21',4),('locator0.phoenix.ENV_NAME.lockerz.int','','locator0.phoenix.ENV_NAME.lockerz.int',3,'',NULL,1,'2011-07-24 19:19:21',5),('locator1.phoenix.ENV_NAME.lockerz.int','','locator1.phoenix.ENV_NAME.lockerz.int',3,'',NULL,1,'2011-07-24 19:19:21',6);
/*!40000 ALTER TABLE `node` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pod`
--

LOCK TABLES `pod` WRITE;
/*!40000 ALTER TABLE `pod` DISABLE KEYS */;
INSERT INTO `pod` VALUES (1,'PodService: tcp -h service0.phoenix.ENV_NAME.lockerz.int -p 10300 -t 5000 : tcp -h service1.phoenix.ENV_NAME.lockerz.int -p 10300 -t 5000',1,1,'2011-09-26 21:38:21');
/*!40000 ALTER TABLE `pod` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_class`
--

DROP TABLE IF EXISTS `service_class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_class` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `network_id` varchar(100) NOT NULL,
  `scalr_farm` varchar(100) NOT NULL,
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_service_class_network` (`name`,`network_id`),
  KEY `FK_service_class_network` (`network_id`),
  CONSTRAINT `FK_service_class_network` FOREIGN KEY (`network_id`) REFERENCES `network` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_class`
--

LOCK TABLES `service_class` WRITE;
/*!40000 ALTER TABLE `service_class` DISABLE KEYS */;
INSERT INTO `service_class` VALUES (1,'user','ENV_NAME','user-java','2011-07-24 19:15:07'),(2,'authentication','ENV_NAME','authentication-java','2011-07-24 19:19:21'),(3,'locator','ENV_NAME','locator-java','2011-07-24 19:19:21');
/*!40000 ALTER TABLE `service_class` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tokenable`
--

LOCK TABLES `tokenable` WRITE;
/*!40000 ALTER TABLE `tokenable` DISABLE KEYS */;
/*!40000 ALTER TABLE `tokenable` ENABLE KEYS */;
UNLOCK TABLES;

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
  UNIQUE KEY `user_id_email_uq` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_id`
--

LOCK TABLES `user_id` WRITE;
/*!40000 ALTER TABLE `user_id` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_id` ENABLE KEYS */;
UNLOCK TABLES;

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
  CONSTRAINT `FK_user_lookup_pod` FOREIGN KEY (`pid`) REFERENCES `pod` (`id`),
  CONSTRAINT `FK_user_lookup_user_id` FOREIGN KEY (`uid`) REFERENCES `user_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_lookup`
--

LOCK TABLES `user_lookup` WRITE;
/*!40000 ALTER TABLE `user_lookup` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_lookup` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2011-09-26 21:40:43
