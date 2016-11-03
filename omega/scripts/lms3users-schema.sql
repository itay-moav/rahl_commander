-- MySQL dump 10.13  Distrib 5.6.23, for Linux (x86_64)
--
-- Host: 172.24.10.155    Database: lms3users
-- ------------------------------------------------------
-- Server version	5.6.23-enterprise-commercial-advanced-log

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
-- Table structure for table `duplicates`
--

DROP TABLE IF EXISTS `duplicates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `duplicates` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `matched_fields` varchar(255) NOT NULL COMMENT 'put a comment for matched fields in Feed and LMS data',
  `rbac_user_id1` int(11) unsigned NOT NULL COMMENT 'rbac_user id should be merged',
  `rbac_user_id2` int(11) unsigned NOT NULL COMMENT 'rbac_user id should be merged',
  `was_merged` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `created_by` int(11) unsigned NOT NULL,
  `date_created` datetime NOT NULL,
  `modified_by` int(11) unsigned DEFAULT NULL,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `rbac_user_ids` (`rbac_user_id1`,`rbac_user_id2`)
) ENGINE=InnoDB AUTO_INCREMENT=5325 DEFAULT CHARSET=utf8 COMMENT='This table is for recording duplicicate accounts that should';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `duplicates_appTOBEDELETED217`
--

DROP TABLE IF EXISTS `duplicates_appTOBEDELETED217`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `duplicates_appTOBEDELETED217` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `rbac_user_id1` int(11) unsigned NOT NULL COMMENT 'rbac_user id should be merged',
  `rbac_user_id2` int(11) unsigned NOT NULL COMMENT 'rbac_user id should be merged',
  `was_merged` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'show if this record was merged',
  `created_by` int(11) unsigned NOT NULL,
  `date_created` datetime NOT NULL,
  `modified_by` int(11) unsigned DEFAULT NULL,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=819 DEFAULT CHARSET=utf8 COMMENT='This table is for recording duplicicate accounts that should be merged';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `external_user_register`
--

DROP TABLE IF EXISTS `external_user_register`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `external_user_register` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `rbac_user_id` int(11) unsigned NOT NULL,
  `code_blue_name_id` varchar(255) NOT NULL DEFAULT 'buba',
  `status` enum('enabled') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `rbac_user_id` (`rbac_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=375642 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `login_log`
--

DROP TABLE IF EXISTS `login_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `login_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `token` char(32) COLLATE utf8_unicode_ci NOT NULL COMMENT 'one time token user logs in with',
  `rbac_user_id` int(11) unsigned NOT NULL,
  `pupetmaster_rbac_user_id` int(11) unsigned NOT NULL COMMENT 'If user take over, this will store the user id of the taking over user id',
  `user_agent` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'user agent browser used by user',
  `ip` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `expired` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'means whther token was used or not. expiration time is in datecreated',
  `status` enum('enabled','disabled','archived','deleted') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `rbac_user_id` (`rbac_user_id`),
  KEY `token` (`token`)
) ENGINE=InnoDB AUTO_INCREMENT=4051 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Table logs a user login and enables a unified login in the s';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `organization_user_enrollment`
--

DROP TABLE IF EXISTS `organization_user_enrollment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organization_user_enrollment` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `organization_id` int(11) unsigned NOT NULL,
  `rbac_user_id` int(11) unsigned NOT NULL,
  `organization_department_id` int(11) unsigned DEFAULT NULL,
  `organization_position_id` int(11) unsigned DEFAULT NULL,
  `employment_id` varchar(20) DEFAULT NULL,
  `employment_type` enum('employee','preemployment','contractor','student','employee-unverified') NOT NULL,
  `feed_verified` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'whether this entry was feed verified or not.',
  `status_comment` varchar(255) DEFAULT NULL,
  `status` enum('pending','approved','rejected','expired') NOT NULL DEFAULT 'pending' COMMENT 'Status of the record.',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT NULL COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT NULL COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `org_usr_enr_org_id_rbac_usr_id_u` (`organization_id`,`rbac_user_id`),
  UNIQUE KEY `org_usr_enr_org_id_emp_id_u` (`organization_id`,`employment_id`),
  KEY `organization_department_id` (`organization_department_id`),
  KEY `rbac_user_id` (`rbac_user_id`),
  KEY `employment_id` (`employment_id`),
  KEY `organization_position_id` (`organization_position_id`)
) ENGINE=InnoDB AUTO_INCREMENT=163472 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sitelrelease`@`172.24.10.137`*/ /*!50003 TRIGGER `organization_user_enrollment_ai` AFTER INSERT ON `organization_user_enrollment`
FOR EACH ROW
BEGIN
	
 	DECLARE new_user_id VARCHAR(25);
 	DECLARE feed_email VARCHAR(200);
 	
	-- If user is now feed mapped -> catch it's medstar user id and eployee id in user identifier
	IF NEW.feed_verified > 0 THEN

	 	-- INSERT employee id -> we might have other orgs for this user, ala IGNORE
		INSERT IGNORE INTO lms3users.user_identifier (user_identifier,rbac_user_id,password,identifier_type,status,date_created,date_modified,created_by,modified_by)
		VALUES(NEW.employment_id,NEW.rbac_user_id,'','employee_id','enabled',NOW(),NOW(),NEW.modified_by,NEW.modified_by);

		-- INSERT medstar user id (fetch it first) -> we might have other orgs for this user, ala IGNORE
		SELECT user_id INTO new_user_id FROM lms3feed.employee_mv WHERE employee_id = NEW.employment_id LIMIT 1;

		IF new_user_id IS NOT NULL AND new_user_id <> '' THEN
			INSERT IGNORE INTO lms3users.user_identifier (user_identifier,rbac_user_id,password,identifier_type,status,date_created,date_modified,created_by,modified_by)
			VALUES(new_user_id,NEW.rbac_user_id,'','medstar_user_id','enabled',NOW(),NOW(),NEW.modified_by,NEW.modified_by);
		END IF;
		
		-- INSERT employee work email (fetch it first) -> we might have other orgs for this user, ala IGNORE
		SELECT employee_work_email INTO feed_email FROM lms3feed.employee_mv WHERE employee_id = NEW.employment_id LIMIT 1;
		
		IF feed_email IS NOT NULL AND feed_email <> '' AND LENGTH(feed_email) > 5 THEN
			INSERT IGNORE INTO lms3users.user_identifier (user_identifier, rbac_user_id, password, identifier_type,status,date_created, date_modified,created_by,modified_by)
			VALUES(feed_email,NEW.rbac_user_id,NULL,'email','enabled',NOW(),NOW(),NEW.modified_by,NEW.modified_by);
		END IF;

	END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sitelrelease`@`172.24.10.137`*/ /*!50003 TRIGGER `organization_user_enrollment_au` AFTER UPDATE ON `organization_user_enrollment`
FOR EACH ROW
BEGIN
	
	DECLARE new_user_id VARCHAR(25);
	DECLARE feed_email VARCHAR(200);

	-- If user is now feed mapped -> catch it's medstar user id and eployee id in user identifier
	IF NEW.feed_verified = 1 AND OLD.feed_verified <> 1 THEN
	
	 	-- INSERT employee id -> we might have other orgs for this user, ala IGNORE
		INSERT IGNORE INTO lms3users.user_identifier (user_identifier,rbac_user_id,password,identifier_type,status,date_created,date_modified,created_by,modified_by)
		VALUES(NEW.employment_id,NEW.rbac_user_id,'','employee_id','enabled',NOW(),NOW(),NEW.modified_by,NEW.modified_by);

		-- INSERT medstar user id (fetch it first) -> we might have other orgs for this user, ala IGNORE
		SELECT user_id INTO new_user_id FROM lms3feed.employee_mv WHERE employee_id = NEW.employment_id LIMIT 1;
		
		IF new_user_id IS NOT NULL AND new_user_id <> '' THEN
			INSERT IGNORE INTO lms3users.user_identifier (user_identifier,rbac_user_id,password,identifier_type,status,date_created,date_modified,created_by,modified_by)
			VALUES(new_user_id,NEW.rbac_user_id,'','medstar_user_id','enabled',NOW(),NOW(),NEW.modified_by,NEW.modified_by);
		END IF;
		
		-- INSERT employee work email (fetch it first) -> we might have other orgs for this user, ala IGNORE
		SELECT employee_work_email INTO feed_email FROM lms3feed.employee_mv WHERE employee_id = NEW.employment_id LIMIT 1;
		
		IF feed_email IS NOT NULL AND feed_email <> '' AND LENGTH(feed_email) > 5 THEN
			INSERT IGNORE INTO lms3users.user_identifier (user_identifier, rbac_user_id, password, identifier_type,status,date_created, date_modified,created_by,modified_by)
			VALUES(feed_email,NEW.rbac_user_id,NULL,'email','enabled',NOW(),NOW(),NEW.modified_by,NEW.modified_by);
		END IF;
		
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `rbac_user`
--

DROP TABLE IF EXISTS `rbac_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rbac_user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `file_upload_id` int(11) unsigned DEFAULT NULL,
  `username` varchar(255) NOT NULL COMMENT 'Username of the user of the system which has to be uniqe and should be a valid email address.',
  `password` varchar(255) NOT NULL COMMENT 'User''s password which is hashed in SH1.',
  `open_id_uid` varchar(255) DEFAULT NULL,
  `first_name` varchar(255) DEFAULT '  ' COMMENT 'User''s first name.',
  `middle_name` varchar(255) DEFAULT ' ' COMMENT 'User''s middle name.',
  `last_name` varchar(255) DEFAULT ' ' COMMENT 'User''s last name.',
  `gender` enum('m','f') DEFAULT NULL COMMENT 'User''s gender.',
  `lut_ethnicity_id` int(11) DEFAULT NULL COMMENT 'forgeirn key of lut ethnicity table',
  `email_1` varchar(255) DEFAULT NULL COMMENT 'User''s first alternative email address.',
  `email_2` varchar(255) DEFAULT NULL COMMENT 'User''s second alternative email address.',
  `address` varchar(255) DEFAULT ' ' COMMENT 'User''s address.',
  `city` varchar(255) DEFAULT ' ' COMMENT 'User''s city location.',
  `province` varchar(255) DEFAULT ' ' COMMENT 'User''s state location.',
  `postal` varchar(20) DEFAULT ' ' COMMENT 'User''s zip code.',
  `country_code` varchar(5) NOT NULL DEFAULT 'US' COMMENT '225 id the default ID of the US Country. ',
  `phone` varchar(255) DEFAULT ' ' COMMENT 'User''s phone number.',
  `date_of_birth` date DEFAULT NULL COMMENT 'User date of birth',
  `cvac_position_type` enum('Pharmacist','Technician','Nursing') DEFAULT NULL COMMENT 'User cvac position for pharmacy form',
  `language_code` varchar(5) NOT NULL DEFAULT 'en' COMMENT 'English is default value for language which is coming from lut_laguage Table',
  `last_login` date DEFAULT '0000-00-00' COMMENT 'Last time that user has logged in to the system.',
  `reset_password` enum('0','1') NOT NULL DEFAULT '0' COMMENT 'Flag that indicates if user has to reset his/her password on next login.',
  `biosketch` text COMMENT '????????',
  `is_email_fraud` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'If set to true, the email has been identified as fraudulent',
  `was_email_validated` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'validate email through migration or validation process or openid',
  `require_password_update` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'see if user is required to update the password after password reset.',
  `require_password_approval` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Determines if the user needs approval by their deparment head to access their account',
  `require_profile_update` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'boolean: does user need a profile update',
  `last_require_profile_update` date DEFAULT NULL COMMENT 'last time the user did a require profile update',
  `status` enum('enabled','disabled','deleted') DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `rbac_usr_usrnam_u` (`username`),
  KEY `last_name` (`last_name`),
  KEY `phone` (`phone`),
  KEY `first_name` (`first_name`)
) ENGINE=InnoDB AUTO_INCREMENT=139768 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sitelrelease`@`172.24.10.137`*/ /*!50003 TRIGGER `rbac_user_ai` AFTER INSERT ON `rbac_user`
FOR EACH ROW
BEGIN
 	INSERT INTO lms3users.user_identifier (user_identifier,rbac_user_id,password,identifier_type,status,date_created,date_modified,created_by,modified_by)
 	VALUES(NEW.username,NEW.id,NEW.password,'email','enabled',NOW(),NOW(),NEW.created_by,NEW.modified_by);
	
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sitelrelease`@`172.24.10.137`*/ /*!50003 TRIGGER `rbac_user_au` AFTER UPDATE ON `rbac_user`
FOR EACH ROW
BEGIN
	-- If user changed his email, I will add it to user identifier
	IF NEW.username <> OLD.username THEN
		UPDATE lms3users.user_identifier
		SET password = NULL
		WHERE rbac_user_id = OLD.id AND identifier_type = 'email';
		
		INSERT INTO lms3users.user_identifier (user_identifier,rbac_user_id,password,identifier_type,status,date_created,date_modified,created_by,modified_by)
		VALUES(NEW.username,OLD.id,NEW.password,'email','enabled',NOW(),NOW(),NEW.modified_by,NEW.modified_by)
		ON DUPLICATE KEY UPDATE password=NEW.password;
	
	-- If user changed only his password, I will update user identifier with new password	
	ELSEIF  NEW.password <> OLD.password THEN
		UPDATE lms3users.user_identifier
		SET password = NEW.password,modified_by=NEW.modified_by
		WHERE user_identifier = NEW.username;
		
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `temp_user_jobs`
--

DROP TABLE IF EXISTS `temp_user_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temp_user_jobs` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `rbac_user_id` int(11) unsigned NOT NULL,
  `organization_id` int(11) unsigned NOT NULL,
  `job_code` varchar(20) NOT NULL COMMENT 'job''s Code',
  `job_name` varchar(100) NOT NULL COMMENT 'job''s Name',
  `job_description` varchar(255) DEFAULT NULL COMMENT 'job''s Description',
  `job_func` varchar(20) DEFAULT NULL,
  `job_func_desc` varchar(100) DEFAULT NULL,
  `job_subfunc` varchar(20) DEFAULT NULL,
  `job_subfunc_desc` varchar(100) DEFAULT NULL,
  `manager_level` varchar(3) DEFAULT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `rbac_user_id` (`rbac_user_id`,`job_code`,`organization_id`)
) ENGINE=InnoDB AUTO_INCREMENT=65536 DEFAULT CHARSET=utf8 COMMENT='keeps all employee jobs';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_identifier`
--

DROP TABLE IF EXISTS `user_identifier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_identifier` (
  `user_identifier` varchar(255) NOT NULL,
  `rbac_user_id` int(10) unsigned NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `identifier_type` enum('email','medstar_user_id','employee_id') NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`user_identifier`) COMMENT 'User identifier will always be unique and I also search by it',
  KEY `lms3users_user_identifier_rbac_user_id` (`rbac_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='table to map various user identifiers to a single rbac_user entry';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_jobs`
--

DROP TABLE IF EXISTS `user_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_jobs` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `rbac_user_id` int(11) unsigned NOT NULL,
  `organization_id` int(11) unsigned NOT NULL,
  `job_id` int(11) unsigned NOT NULL COMMENT 'job''s id',
  `job_function_id` int(11) unsigned NOT NULL COMMENT 'job''s function id',
  `job_sub_function_id` int(11) unsigned NOT NULL COMMENT 'job''s sub function id',
  `manager_level` varchar(3) DEFAULT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `rbac_user_id` (`rbac_user_id`,`job_id`,`organization_id`),
  KEY `job_id` (`job_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='keeps all employee jobs';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_roles`
--

DROP TABLE IF EXISTS `user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_roles` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `rbac_user_id` int(11) unsigned NOT NULL COMMENT 'User ID from lms2prod.',
  `role_id` smallint(3) unsigned NOT NULL COMMENT 'The role class ID associated to the user',
  `organization_id` smallint(3) unsigned NOT NULL,
  `role_scope` enum('system','org','mnow','TES','watershed','pathygiene') NOT NULL DEFAULT 'org' COMMENT 'Whether the role is for the current org, or for all',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `usr_roles_rbac_usr_id_role_id_org_id_u` (`rbac_user_id`,`role_id`,`organization_id`,`role_scope`),
  KEY `rbac_user_id` (`rbac_user_id`),
  KEY `role_id` (`role_id`),
  KEY `organization_id` (`organization_id`)
) ENGINE=InnoDB AUTO_INCREMENT=621195 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-10-31  4:32:26
