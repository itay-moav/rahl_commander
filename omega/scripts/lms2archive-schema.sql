-- MySQL dump 10.13  Distrib 5.6.23, for Linux (x86_64)
--
-- Host: 172.24.10.155    Database: lms2archive
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
-- Table structure for table `archive_course_enrollment_invoice_old_214`
--

DROP TABLE IF EXISTS `archive_course_enrollment_invoice_old_214`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `archive_course_enrollment_invoice_old_214` (
  `id` int(11) unsigned NOT NULL,
  `course_enrollment_rollout_id` int(11) NOT NULL,
  `invoice` text NOT NULL,
  `registerer_rbac_user_id` int(11) unsigned NOT NULL,
  `invoice_status` enum('pending','paid') NOT NULL DEFAULT 'pending',
  `invoice_total` decimal(8,2) NOT NULL,
  `payment_date` timestamp NULL DEFAULT NULL,
  `allow_previous` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Does enrollment allow previous score',
  `start_accept_score` datetime NOT NULL COMMENT 'This is when scores start being accepted',
  `allow_reenroll` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'allow re-enrollment for student',
  `time_until_reregister` int(4) NOT NULL DEFAULT '0' COMMENT 'Number of months to allow re-enrollment',
  `date_of_reregister` datetime DEFAULT NULL COMMENT 'The date when reenrollment begins',
  `status` enum('enabled','disabled','deleted') NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned NOT NULL,
  `modified_by` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `course_enrollment_rollout_id` (`course_enrollment_rollout_id`),
  KEY `registerer_rbac_user_id` (`registerer_rbac_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `archive_course_enrollment_rollout_old_214`
--

DROP TABLE IF EXISTS `archive_course_enrollment_rollout_old_214`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `archive_course_enrollment_rollout_old_214` (
  `id` int(11) unsigned NOT NULL,
  `course_id` int(11) unsigned NOT NULL,
  `type` enum('self','group') NOT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned NOT NULL,
  `modified_by` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `billing`
--

DROP TABLE IF EXISTS `billing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `billing` (
  `id` int(11) unsigned NOT NULL,
  `invoice_id` int(11) unsigned NOT NULL COMMENT 'foreign key to billing invoices table',
  `paid_by_rbac_user_id` int(11) unsigned NOT NULL COMMENT 'who paid for this bill',
  `type` enum('groupcode','paypal','check','charged') NOT NULL DEFAULT 'charged' COMMENT 'type of payment used to reduce the billing invoice amount',
  `balance_amount` decimal(11,2) NOT NULL COMMENT 'how much is the reduction amount',
  `billing_details` text COMMENT 'data related for the reduction amount.',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `billing_discount_course`
--

DROP TABLE IF EXISTS `billing_discount_course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `billing_discount_course` (
  `id` int(11) unsigned NOT NULL,
  `course_id` int(11) unsigned NOT NULL,
  `discount_type` enum('amount','percentage') NOT NULL DEFAULT 'amount',
  `discount` decimal(8,2) NOT NULL,
  `special_pricing_type` enum('Early Registration','Organization','Department','Position','Group') NOT NULL DEFAULT 'Early Registration',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `billing_discount_course_entities`
--

DROP TABLE IF EXISTS `billing_discount_course_entities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `billing_discount_course_entities` (
  `id` int(11) unsigned NOT NULL,
  `billing_discount_course_id` int(11) unsigned NOT NULL,
  `additional_info` varchar(255) NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `billing_invoice_items`
--

DROP TABLE IF EXISTS `billing_invoice_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `billing_invoice_items` (
  `id` int(11) unsigned NOT NULL,
  `billing_invoice_id` int(11) unsigned NOT NULL COMMENT 'foreign key to invoice table',
  `item_description` text NOT NULL COMMENT 'short diescription of what is being sold',
  `quantity` int(11) unsigned NOT NULL COMMENT 'it of users enroll or discounted for course',
  `amount_total` decimal(11,2) NOT NULL COMMENT 'amount of the invidual item',
  `amount_tax` decimal(11,2) NOT NULL COMMENT 'how much tax was applied to total',
  `amount_shipping` decimal(11,2) NOT NULL,
  `amount_grand_total` decimal(11,2) NOT NULL COMMENT 'total plus tax amount',
  `item_status` enum('pending','shipped','cancel') NOT NULL DEFAULT 'pending',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `billing_invoices`
--

DROP TABLE IF EXISTS `billing_invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `billing_invoices` (
  `id` int(11) unsigned NOT NULL,
  `created_by_rbac_user_id` int(11) unsigned NOT NULL COMMENT 'The person who created the invoice',
  `bill_to_entity_type` enum('rbac_user','organization','organization_department','organization_education_group') NOT NULL DEFAULT 'rbac_user' COMMENT 'which of the invoice should this go to',
  `bill_to_entity_id` int(11) unsigned NOT NULL COMMENT 'entity id is based on entity type, data could come from, rbac_user, organization, organization_department, organization_education_group.',
  `amount_total` decimal(11,2) NOT NULL DEFAULT '0.00' COMMENT 'total amount of invoice items before tax',
  `amount_tax` decimal(11,2) NOT NULL DEFAULT '0.00' COMMENT 'tax amount of all items',
  `amount_shipping` decimal(11,2) NOT NULL DEFAULT '0.00' COMMENT 'shipping amount of all invoice items',
  `amount_discounted` decimal(11,2) NOT NULL DEFAULT '0.00' COMMENT 'total discounted price based on items.',
  `amount_grand_total` decimal(11,2) NOT NULL DEFAULT '0.00' COMMENT 'total amount include shipping and tax',
  `amount_due` decimal(11,2) NOT NULL DEFAULT '0.00' COMMENT 'how much is currently due. for partial payment',
  `amount_remaining` decimal(11,2) NOT NULL DEFAULT '0.00' COMMENT 'based on payment, how much is left on the invoice if partial payment',
  `date_due` date NOT NULL COMMENT 'amount due date based on amount due',
  `display_header_class` varchar(100) NOT NULL COMMENT 'what goes in the header of the invoice',
  `display_footer_class` varchar(100) NOT NULL COMMENT 'what should go into the footer of the invoice',
  `invoice_status` enum('unpaid','paid','partially_paid','cancel') NOT NULL DEFAULT 'unpaid' COMMENT 'overall status of the invoice',
  `purchase_order_serialized` text NOT NULL,
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_enrollment`
--

DROP TABLE IF EXISTS `content_enrollment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_enrollment` (
  `id` int(11) unsigned NOT NULL,
  `organization_id` int(11) unsigned NOT NULL,
  `student_rbac_user_id` int(11) unsigned NOT NULL DEFAULT '1',
  `content_container_id` int(11) unsigned NOT NULL,
  `course_enrollment_id` int(11) NOT NULL DEFAULT '0',
  `pretest_score` int(11) DEFAULT NULL COMMENT 'This is the pretest score of the container.',
  `final_score` tinyint(3) unsigned DEFAULT NULL COMMENT 'overall score of the content',
  `content_container_status` enum('incomplete','complete') NOT NULL COMMENT 'whether this container is complete',
  `content_container_date_completed` datetime DEFAULT NULL COMMENT 'date container was completed',
  `transcript_group_id` bigint(20) unsigned DEFAULT NULL COMMENT 'ID that groups all the transcript records related to the enrollment',
  `trigger_completion_content_enrollment_id` int(11) DEFAULT NULL COMMENT 'id of the enrollment that trigger completion of this enrollment',
  `enrolled_date` date NOT NULL,
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`),
  KEY `student_rbac_user_id` (`student_rbac_user_id`),
  KEY `course_enrollment_id` (`course_enrollment_id`),
  KEY `content_container_id` (`content_container_id`),
  KEY `organization_id` (`organization_id`),
  KEY `transcript_group_id` (`transcript_group_id`),
  KEY `trigger_completion_content_enrollment_id` (`trigger_completion_content_enrollment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_enrollment_migration`
--

DROP TABLE IF EXISTS `content_enrollment_migration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_enrollment_migration` (
  `id` int(11) unsigned NOT NULL,
  `organization_id` int(11) unsigned DEFAULT NULL,
  `student_rbac_user_id` int(11) unsigned NOT NULL,
  `content_container_id` int(11) unsigned NOT NULL,
  `course_enrollment_id` int(11) NOT NULL DEFAULT '0',
  `final_score` int(11) NOT NULL,
  `content_container_status` enum('incomplete','complete') NOT NULL,
  `content_container_date_completed` date DEFAULT NULL,
  `transcript_group_id` bigint(20) NOT NULL,
  `enrolled_date` date NOT NULL,
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_scorm_sco_log`
--

DROP TABLE IF EXISTS `content_scorm_sco_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_scorm_sco_log` (
  `id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Primary Key of table',
  `enrollment_id` int(11) unsigned NOT NULL COMMENT 'Contains Content enrollment id',
  `rbac_user_id` int(11) unsigned NOT NULL COMMENT 'Contains User id',
  `content_id` int(11) unsigned NOT NULL COMMENT 'Contains Content id from Content table',
  `content_scorm_sco_id` int(11) unsigned DEFAULT NULL COMMENT 'Primary key of content_scorm_sco',
  `user_model` text CHARACTER SET utf8 COMMENT 'Contains user model data sent by the scorm course',
  `suspend_data` text CHARACTER SET utf8 COMMENT 'Contains suspend data sent by scorm course',
  `lesson_status` enum('passed','completed','failed','incomplete','browsed','not attempted') CHARACTER SET utf8 NOT NULL DEFAULT 'incomplete' COMMENT 'Contains lesson_status from scorm course user model',
  `lesson_location` varchar(100) CHARACTER SET utf8 DEFAULT NULL COMMENT 'Contains lesson_location from scorm course user model',
  `raw_score` int(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Contains raw Score from scorm course user model',
  `max_score` int(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Contains raw Score from scorm course user model',
  `time_spent` varchar(10) CHARACTER SET utf8 DEFAULT NULL COMMENT 'Contains time spent on sco',
  `total_interaction` int(3) unsigned DEFAULT NULL,
  `status` enum('enabled','disabled','archived','deleted') CHARACTER SET utf8 NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_transcript_log`
--

DROP TABLE IF EXISTS `content_transcript_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_transcript_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `transcript_group_id` bigint(11) unsigned NOT NULL COMMENT 'This value is created by the content viewer. Its a combination of timestamps and user id.',
  `log_type` enum('content','attendance','return_demo','survey') NOT NULL DEFAULT 'content' COMMENT 'this is for counting and the number of times a content is viewed',
  `rbac_user_id` int(11) unsigned NOT NULL,
  `enrollment_id` int(11) unsigned NOT NULL,
  `content_id` int(11) unsigned NOT NULL,
  `content_container_id` int(11) unsigned NOT NULL,
  `identifier` varchar(100) NOT NULL,
  `course_id` int(11) unsigned DEFAULT NULL,
  `total_interaction` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `server_ip` char(20) NOT NULL,
  `user_ip` char(20) NOT NULL,
  `time_spent` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `suspend_data` text,
  `user_model` text,
  `raw_score` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `max_score` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `passing_score` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `content_status` varchar(30) NOT NULL DEFAULT 'initialize',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=57394300 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course`
--

DROP TABLE IF EXISTS `course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course` (
  `id` int(11) unsigned NOT NULL COMMENT 'Primary Key and identifier for each record',
  `organization_id` int(11) unsigned NOT NULL COMMENT 'Org that the course belongs to',
  `owner_rbac_user_id` int(11) unsigned NOT NULL COMMENT 'Id of the activity director',
  `file_upload_id` int(11) unsigned DEFAULT NULL COMMENT 'promo material upload ID',
  `title` varchar(255) NOT NULL COMMENT 'title of the course',
  `description` text COMMENT 'description of the course',
  `activity_type` enum('On Demand','Clinical Simulation','Conference','Instructor-led class','content_wrapper_education','content_wrapper_quiz','content_wrapper_survey','content_wrapper_survey_template') NOT NULL COMMENT 'The type of course this is',
  `allow_edit_curriculum` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'if true, course can be editted any time',
  `has_payment` tinyint(1) NOT NULL,
  `allowed_payment_types` set('cash','check','credit_card','promotional_code','access_code') DEFAULT NULL COMMENT 'These are the ways a user can pay for the course',
  `base_price` decimal(8,0) NOT NULL,
  `allow_previous` enum('0','1') NOT NULL COMMENT 'weather allow previous score or not',
  `previous_window` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'days before enrollment to count previous scroe',
  `allow_reenroll` tinyint(1) NOT NULL,
  `time_until_reregister` mediumint(8) NOT NULL,
  `allow_reschedule` tinyint(1) NOT NULL,
  `activity_director_approval` tinyint(1) NOT NULL,
  `has_online_content` tinyint(1) NOT NULL COMMENT 'whether this course includes online content',
  `requires_return_demo` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'whether this has a return demo or not',
  `has_certificate` enum('0','1') NOT NULL DEFAULT '0' COMMENT 'whether the course has credit',
  `certificate_type` set('cme','cne','others') DEFAULT NULL COMMENT 'the type of certificate the course has',
  `department_funds` enum('0','1') NOT NULL DEFAULT '0' COMMENT 'is course paid for with department funds',
  `join_sponsorship` varchar(255) DEFAULT NULL COMMENT 'does course have joint sponsorship',
  `is_completed` enum('0','1') NOT NULL DEFAULT '0' COMMENT 'I dont know',
  `screening_practices` enum('0','1') NOT NULL DEFAULT '0' COMMENT 'whether content is based on best practices',
  `screening_gap` enum('0','1') NOT NULL DEFAULT '0' COMMENT 'whether a gap exists between current and best practices',
  `screening_result` enum('0','1') NOT NULL DEFAULT '0' COMMENT 'whether closing the gap will improve outcomes',
  `screening_education` enum('0','1') NOT NULL DEFAULT '0' COMMENT 'whether the intervention will improve practices',
  `statement_of_need` text COMMENT 'a statement describing the need for the course',
  `result_competance` enum('0','1') NOT NULL DEFAULT '0' COMMENT 'whether improved competance is to be achieved',
  `result_performance` enum('0','1') NOT NULL DEFAULT '0' COMMENT 'whether better performance is to be achieved',
  `result_patient_outcomes` enum('0','1') NOT NULL DEFAULT '0' COMMENT 'whether better outcomes is to be achieved',
  `barrier_type` enum('0','1') NOT NULL DEFAULT '0' COMMENT 'whether barriers exist to achieve goal',
  `task_type` enum('mandatory','custom') NOT NULL DEFAULT 'mandatory' COMMENT 'Mandatory makes all content mandatory while custom allows the user to set up tasks',
  `is_featured_course` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'indicate if course is featured on front page',
  `approve_email` text COMMENT 'email to send to uses who are approved for the course',
  `reject_email` text COMMENT 'email the users receives when rejected from the course',
  `pending_email` text COMMENT 'email the user receives when pending in the course',
  `reminder_email` text COMMENT 'text of the reminder email for event attendees',
  `reminder_times` set('1','2','7','14') DEFAULT NULL COMMENT 'days before event to send reminder email',
  `expiration_date` date NOT NULL COMMENT 'date the course expires and enrollment stops',
  `view_level` enum('catalog','course_creation_wizard') NOT NULL DEFAULT 'catalog' COMMENT 'Show course in catalog, or not',
  `access` enum('public','private','consortium','self') NOT NULL DEFAULT 'public' COMMENT 'access level of the course, who can see and enroll',
  `access_stored` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'Says whether accessible content is stored for this course',
  `version` int(11) unsigned NOT NULL DEFAULT '1' COMMENT 'version of the course',
  `publish_status` enum('Active','Inactive','Review','Expire') NOT NULL DEFAULT 'Inactive' COMMENT 'status of the course, state of creation',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`),
  KEY `date_created` (`date_created`),
  KEY `owner_rbac_user_id` (`owner_rbac_user_id`),
  KEY `view_level` (`view_level`),
  KEY `course_tbl_title` (`title`),
  KEY `publish_status` (`publish_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_access`
--

DROP TABLE IF EXISTS `course_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_access` (
  `id` int(11) unsigned NOT NULL,
  `course_id` int(11) unsigned NOT NULL,
  `organization_id` int(11) unsigned DEFAULT NULL,
  `organization_department_id` int(11) unsigned DEFAULT NULL,
  `organization_education_group_id` int(11) unsigned DEFAULT NULL,
  `student_rbac_user_id` int(11) unsigned DEFAULT NULL,
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `organization_id` (`organization_id`),
  KEY `organization_department_id` (`organization_department_id`),
  KEY `organization_education_group_id` (`organization_education_group_id`),
  KEY `student_rbac_user_id` (`student_rbac_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_assessment`
--

DROP TABLE IF EXISTS `course_assessment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_assessment` (
  `id` int(11) unsigned NOT NULL,
  `course_id` int(11) unsigned NOT NULL,
  `current_practice` text NOT NULL,
  `best_practice` text NOT NULL,
  `resulting_gap` text NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_auto_enrollment`
--

DROP TABLE IF EXISTS `course_auto_enrollment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_auto_enrollment` (
  `id` int(11) unsigned NOT NULL,
  `course_id` int(11) unsigned DEFAULT NULL COMMENT 'FK to lut_contract_type Table',
  `organization_id` int(11) unsigned DEFAULT NULL,
  `organization_department_id` int(11) unsigned DEFAULT NULL,
  `organization_education_group_id` int(11) unsigned DEFAULT NULL,
  `student_rbac_user_id` int(11) unsigned DEFAULT NULL COMMENT 'For individuals grouped enrolls',
  `course_enrollment_settings_id` int(11) unsigned NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of this record',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_barrier`
--

DROP TABLE IF EXISTS `course_barrier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_barrier` (
  `id` int(11) unsigned NOT NULL,
  `course_id` int(11) unsigned NOT NULL,
  `barrier_text` text NOT NULL,
  `strategy` varchar(50) NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_certificate`
--

DROP TABLE IF EXISTS `course_certificate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_certificate` (
  `id` int(11) unsigned NOT NULL,
  `course_id` int(11) unsigned NOT NULL,
  `certificate_id` int(10) unsigned NOT NULL,
  `number_of_credits` decimal(5,2) NOT NULL DEFAULT '0.00' COMMENT 'number of credit for the course',
  `cne_number` varchar(50) NOT NULL DEFAULT '',
  `disclosure` text,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_content`
--

DROP TABLE IF EXISTS `course_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_content` (
  `id` int(11) unsigned NOT NULL,
  `course_id` int(11) unsigned NOT NULL COMMENT 'The course that the content is attached to',
  `content_container_id` int(11) unsigned NOT NULL COMMENT 'The content that is attached to the course',
  `pre_session_course_content_id` int(11) unsigned DEFAULT NULL COMMENT 'course content that must be complete before this live content - LIVE content ONLY',
  `passing_score` tinyint(3) unsigned NOT NULL DEFAULT '80' COMMENT 'passing score for the content on this course only',
  `show_score` enum('Yes','No') NOT NULL DEFAULT 'No' COMMENT 'whether to display to cummulative score',
  `number_of_attempts` smallint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Number of attempts the user an make to complete the content on this course',
  `content_type` enum('Pretest','Content','Pre Event Content','Live Content','Return Demo','Post Event Content','Post Test','Evaluation','Post Evaluation') DEFAULT NULL COMMENT 'Where the content is on this course',
  `when_do` enum('immediate','later') NOT NULL DEFAULT 'immediate' COMMENT 'whether to wait a period before allowing user to take this content',
  `valid_after` tinyint(3) unsigned NOT NULL COMMENT 'after how long should this content be taken',
  `take_content_evaluation` enum('Yes','No') NOT NULL DEFAULT 'Yes' COMMENT 'take the evaluation for the content or no',
  `move_to_evaluation` enum('Yes','No') NOT NULL DEFAULT 'No' COMMENT 'whether passing the pretest will pass the content',
  `trigger_completion_course_content_id` int(11) DEFAULT NULL COMMENT 'Id of the course content that will trigger completion',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`),
  KEY `content_container_id` (`content_container_id`),
  KEY `course_id` (`course_id`),
  KEY `trigger_completion_course_content_id` (`trigger_completion_course_content_id`),
  KEY `pre_session_course_content_id` (`pre_session_course_content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='course create->curriculum->settings';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_content_settings`
--

DROP TABLE IF EXISTS `course_content_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_content_settings` (
  `id` int(11) unsigned NOT NULL,
  `course_id` int(11) unsigned NOT NULL,
  `content_id` int(11) unsigned NOT NULL,
  `passing_score` tinyint(3) unsigned NOT NULL DEFAULT '80',
  `show_score` tinyint(1) NOT NULL DEFAULT '0',
  `number_of_attempts` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `move_to_evaluation` tinyint(1) NOT NULL DEFAULT '0',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`),
  KEY `content_id` (`content_id`),
  KEY `course_id` (`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='course create->curriculum->settings';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_enrollment`
--

DROP TABLE IF EXISTS `course_enrollment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_enrollment` (
  `id` int(11) unsigned NOT NULL,
  `course_enrollment_settings_id` int(11) unsigned NOT NULL,
  `course_id` int(11) unsigned NOT NULL,
  `student_rbac_user_id` int(11) unsigned NOT NULL,
  `organization_id` int(11) unsigned NOT NULL,
  `type` enum('self','group','department','organization') NOT NULL,
  `enrolled_by_role` int(11) NOT NULL COMMENT 'shows under what role the registrer was at the time of role out',
  `previous_action` enum('create_new','expire_old','use_old') NOT NULL COMMENT 'the action taken when this record was created',
  `previously_updated_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'the id of the record that was modified',
  `allow_previous` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Does enrollment allow previous score',
  `start_accept_score` datetime NOT NULL COMMENT 'This is when scores start being accepted',
  `allow_reenroll` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'allow re-enrollment for student',
  `time_until_reregister` int(4) NOT NULL DEFAULT '0' COMMENT 'Number of months to allow re-enrollment',
  `date_of_reregister` datetime DEFAULT NULL COMMENT 'The date when reenrollment begins',
  `activity_director_status` enum('pending','approved','rejected','on hold') NOT NULL COMMENT 'whether the activity director has approved the student',
  `activity_director_approved_date` datetime DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `due_date` date DEFAULT NULL COMMENT 'Due data is set by the educator. If self enrollment, use course expiration date.',
  `viewed` enum('0','1') NOT NULL,
  `online_prework_status` enum('incomplete','complete','N/A') NOT NULL DEFAULT 'incomplete' COMMENT 'prework are all the mandatory tasks before the live task',
  `online_course_status` enum('incomplete','complete','n/a') NOT NULL DEFAULT 'incomplete' COMMENT 'whether the online portion of this course is complete',
  `online_course_date_completed` date DEFAULT NULL COMMENT 'date the online portion was completed',
  `live_course_status` enum('incomplete','complete','n/a') NOT NULL DEFAULT 'incomplete' COMMENT 'whether the live portion is complete',
  `live_course_date_completed` date DEFAULT NULL COMMENT 'date the live postion was completed',
  `course_status` enum('incomplete','complete') NOT NULL DEFAULT 'incomplete' COMMENT 'whether the overall course is complete',
  `course_date_completed` date DEFAULT NULL COMMENT 'date the whole course was completed',
  `status` enum('enabled','expired','canceled','archived') NOT NULL COMMENT 'expired means that you can''t launch the course anymore, enrolment was expired by manager, canceled means it was used in a new enrollment',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned NOT NULL,
  `modified_by` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `organization_id` (`organization_id`),
  KEY `course_enrollment_invoice_id` (`course_enrollment_settings_id`),
  KEY `course_id` (`course_id`),
  KEY `student_rbac_user_id` (`student_rbac_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_enrollment_day`
--

DROP TABLE IF EXISTS `course_enrollment_day`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_enrollment_day` (
  `id` int(11) NOT NULL,
  `course_enrollment_id` int(11) unsigned NOT NULL,
  `day_id` int(11) unsigned NOT NULL,
  `student_rbac_user_id` int(11) unsigned NOT NULL,
  `type` enum('event','day') NOT NULL,
  `is_attended` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'did the user attended the day. if user attended any topic for the day then day should be marked to attended',
  `status` enum('enabled','disabled','deleted') NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) NOT NULL,
  `modified_by` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `day_id` (`day_id`),
  KEY `course_enrollment_id` (`course_enrollment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_enrollment_event`
--

DROP TABLE IF EXISTS `course_enrollment_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_enrollment_event` (
  `id` int(11) NOT NULL,
  `course_enrollment_id` int(11) unsigned NOT NULL,
  `event_repeat_group_id` int(11) unsigned NOT NULL,
  `student_rbac_user_id` int(11) unsigned NOT NULL,
  `is_attended` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'did user attended the event. if user attended any day for the event than event should be marked to attended',
  `status` enum('enabled','disabled','deleted') NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) NOT NULL,
  `modified_by` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_enrollment_settings`
--

DROP TABLE IF EXISTS `course_enrollment_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_enrollment_settings` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `course_id` int(11) unsigned NOT NULL COMMENT 'Course Id associated with enrollments',
  `type` enum('self','group') NOT NULL COMMENT 'Self Enrollment or Rollout',
  `enrolled_by_role` int(11) NOT NULL COMMENT 'Role of the user performing enrollment last',
  `registerer_rbac_user_id` int(11) unsigned NOT NULL,
  `invoice_status` enum('pending','paid') NOT NULL DEFAULT 'pending',
  `invoice_total` decimal(8,2) NOT NULL,
  `payment_date` timestamp NULL DEFAULT NULL,
  `allow_previous` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Does enrollment allow previous score',
  `start_accept_score` datetime NOT NULL COMMENT 'This is when scores start being accepted',
  `allow_reenroll` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'allow re-enrollment for student',
  `time_until_reregister` int(4) NOT NULL DEFAULT '0' COMMENT 'Number of months to allow re-enrollment',
  `date_of_reregister` datetime DEFAULT NULL COMMENT 'The date when reenrollment begins',
  `enrollment_date` datetime DEFAULT NULL,
  `auto_enroll_users` tinyint(1) NOT NULL COMMENT 'True if course has auto-enroolment',
  `auto_enrollment_end_date` date NOT NULL DEFAULT '0000-00-00',
  `course_due_date` date DEFAULT NULL COMMENT 'Indicate by date when the course must be complete',
  `course_due_days` int(11) DEFAULT NULL COMMENT 'Indicate by number of days from time of registration when the course must be complete',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record or enrollment',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned NOT NULL,
  `modified_by` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `course_id` (`course_id`),
  KEY `registerer_rbac_user_id` (`registerer_rbac_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_enrollment_topic`
--

DROP TABLE IF EXISTS `course_enrollment_topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_enrollment_topic` (
  `id` int(11) unsigned NOT NULL,
  `course_enrollment_id` int(11) unsigned NOT NULL,
  `topic_id` int(11) unsigned NOT NULL,
  `student_rbac_user_id` int(11) unsigned NOT NULL,
  `type` enum('event','day','topic') NOT NULL,
  `is_attended` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'did user attended the event. if user attended any day for the event than event should be marked to attended',
  `status` enum('enabled','disabled','deleted') NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) NOT NULL,
  `modified_by` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `topic_id` (`topic_id`),
  KEY `course_enrollment_id` (`course_enrollment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_objective`
--

DROP TABLE IF EXISTS `course_objective`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_objective` (
  `id` int(11) unsigned NOT NULL,
  `course_id` int(11) unsigned NOT NULL,
  `objective_text` text NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`),
  KEY `course_id` (`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_reference`
--

DROP TABLE IF EXISTS `course_reference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_reference` (
  `id` int(11) unsigned NOT NULL,
  `course_id` int(11) unsigned NOT NULL,
  `title` varchar(255) NOT NULL,
  `key_points` text NOT NULL,
  `location` varchar(255) NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_return_demo_tmp`
--

DROP TABLE IF EXISTS `course_return_demo_tmp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_return_demo_tmp` (
  `id` int(11) unsigned NOT NULL,
  `course_id` int(11) unsigned NOT NULL,
  `content_container_id` int(11) unsigned NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`),
  KEY `content_container_id` (`content_container_id`),
  KEY `course_id` (`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='course create->curriculum->settings';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_role`
--

DROP TABLE IF EXISTS `course_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_role` (
  `id` int(11) unsigned NOT NULL,
  `course_id` int(11) unsigned NOT NULL,
  `rbac_user_id` int(11) unsigned NOT NULL,
  `role_id` int(11) unsigned NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`),
  KEY `course_id` (`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_saved`
--

DROP TABLE IF EXISTS `course_saved`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_saved` (
  `id` int(11) unsigned NOT NULL,
  `course_id` int(11) unsigned NOT NULL,
  `rbac_user_id` int(11) unsigned NOT NULL,
  `organization_id` int(11) unsigned NOT NULL,
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `date_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) unsigned NOT NULL,
  `modified_by` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_sponsors`
--

DROP TABLE IF EXISTS `course_sponsors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_sponsors` (
  `id` int(11) unsigned NOT NULL,
  `course_id` int(11) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `fax` varchar(50) NOT NULL,
  `phone` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `provide_commercial_support` enum('0','1') NOT NULL DEFAULT '0',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_target`
--

DROP TABLE IF EXISTS `course_target`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_target` (
  `id` int(11) unsigned NOT NULL,
  `course_id` int(11) unsigned NOT NULL,
  `target_id` int(11) unsigned NOT NULL,
  `target_source` varchar(100) NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`),
  KEY `course_id` (`course_id`),
  KEY `target_id` (`target_id`),
  KEY `target_source` (`target_source`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_task`
--

DROP TABLE IF EXISTS `course_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_task` (
  `id` int(11) unsigned NOT NULL,
  `course_id` int(11) unsigned NOT NULL COMMENT 'The course this task belongs to',
  `task_name` varchar(255) NOT NULL COMMENT 'The name of the task',
  `number_content_complete` int(3) unsigned NOT NULL COMMENT 'the number of content that needs to be complete to pass this task',
  `task_order` int(10) unsigned NOT NULL COMMENT 'the position of the task in the curriculum',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`),
  KEY `course_id` (`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_task_content`
--

DROP TABLE IF EXISTS `course_task_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_task_content` (
  `id` int(11) unsigned NOT NULL,
  `course_task_id` int(11) unsigned NOT NULL,
  `course_content_id` int(11) unsigned NOT NULL,
  `is_mandatory` enum('0','1') NOT NULL DEFAULT '0' COMMENT 'This indicates whether the content must be completed to pass the task',
  `rec_order` tinyint(3) unsigned NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`),
  KEY `course_task_id` (`course_task_id`),
  KEY `course_content_id` (`course_content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `delta_course_auto_enrollment_old_214`
--

DROP TABLE IF EXISTS `delta_course_auto_enrollment_old_214`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `delta_course_auto_enrollment_old_214` (
  `id` int(11) unsigned NOT NULL,
  `course_id` int(11) unsigned DEFAULT NULL COMMENT 'FK to lut_contract_type Table',
  `enrolled_by_role` int(11) NOT NULL COMMENT 'shows under what role the registrer was at the time of role out',
  `organization_id` int(11) unsigned DEFAULT NULL,
  `organization_department_id` int(11) unsigned DEFAULT NULL,
  `organization_education_group_id` int(11) unsigned DEFAULT NULL,
  `student_rbac_user_id` int(11) unsigned DEFAULT NULL COMMENT 'For individuals grouped enrolls',
  `course_enrollment_invoice_id` int(11) unsigned DEFAULT NULL,
  `check_on_group_enroll` tinyint(1) NOT NULL,
  `allow_previous` tinyint(1) NOT NULL COMMENT 'Does enrollment allow previous score',
  `start_accept_score` datetime NOT NULL COMMENT 'This is when scores start being accepted',
  `allow_reenroll` tinyint(1) NOT NULL COMMENT 'allow re-enrollment for student',
  `time_until_reregister` int(4) NOT NULL COMMENT 'Number of months to allow re-enrollment',
  `date_of_reregister` datetime DEFAULT NULL COMMENT 'The date when reenrollment begins',
  `auto_enroll` tinyint(1) NOT NULL COMMENT 'True if enrollment is free and online',
  `auto_enrollment_end_date` date NOT NULL DEFAULT '0000-00-00',
  `course_due_date` date DEFAULT NULL COMMENT 'Indicate by date when the course must be complete',
  `course_due_days` int(11) DEFAULT NULL COMMENT 'Indicate by number of days from time of registration when the course must be complete',
  `status` enum('enabled','disabled','deleted') NOT NULL COMMENT 'Status of this record',
  `date_created` timestamp NULL DEFAULT NULL,
  `date_modified` timestamp NULL DEFAULT NULL,
  `created_by` int(11) unsigned DEFAULT NULL COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT NULL COMMENT 'The ID of the creator of this record.',
  `date_stored` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `delta_type` enum('delete','edit','create') DEFAULT NULL,
  `delta_note` text NOT NULL,
  `delta_rbac_user_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`date_stored`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `delta_course_enrollment_invoice_old_214`
--

DROP TABLE IF EXISTS `delta_course_enrollment_invoice_old_214`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `delta_course_enrollment_invoice_old_214` (
  `id` int(11) unsigned NOT NULL,
  `course_enrollment_rollout_id` int(11) NOT NULL,
  `invoice` text NOT NULL,
  `registerer_rbac_user_id` int(11) unsigned NOT NULL,
  `invoice_status` enum('pending','paid') NOT NULL DEFAULT 'pending',
  `invoice_total` decimal(8,2) NOT NULL,
  `payment_date` timestamp NULL DEFAULT NULL,
  `allow_previous` tinyint(1) NOT NULL COMMENT 'Does enrollment allow previous score',
  `start_accept_score` datetime NOT NULL COMMENT 'This is when scores start being accepted',
  `allow_reenroll` tinyint(1) NOT NULL COMMENT 'allow re-enrollment for student',
  `time_until_reregister` int(4) NOT NULL COMMENT 'Number of months to allow re-enrollment',
  `date_of_reregister` datetime DEFAULT NULL COMMENT 'The date when reenrollment begins',
  `status` enum('enabled','disabled','deleted') NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) unsigned NOT NULL,
  `modified_by` int(11) unsigned NOT NULL,
  `date_stored` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `delta_type` enum('delete','edit','create') DEFAULT NULL,
  `delta_note` text NOT NULL,
  `delta_rbac_user_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`date_stored`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `delta_course_enrollment_rollout_old_214`
--

DROP TABLE IF EXISTS `delta_course_enrollment_rollout_old_214`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `delta_course_enrollment_rollout_old_214` (
  `id` int(11) unsigned NOT NULL DEFAULT '0',
  `course_id` int(11) unsigned DEFAULT NULL,
  `type` enum('self','group') DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `status` enum('enabled','disabled','deleted') DEFAULT NULL,
  `date_created` timestamp NULL DEFAULT NULL,
  `date_modified` timestamp NULL DEFAULT NULL,
  `created_by` int(11) unsigned DEFAULT NULL,
  `modified_by` int(11) unsigned DEFAULT NULL,
  `date_stored` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `delta_type` enum('delete','edit','create') DEFAULT NULL,
  `delta_note` text NOT NULL,
  `delta_rbac_user_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`date_stored`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `email`
--

DROP TABLE IF EXISTS `email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email` (
  `id` int(11) NOT NULL,
  `urgency_level` smallint(6) NOT NULL DEFAULT '1' COMMENT 'The lower the number, the more urgent is this email',
  `subject` varchar(255) CHARACTER SET utf8 NOT NULL COMMENT 'subject of the email',
  `body` text CHARACTER SET utf8 NOT NULL COMMENT 'body of the email',
  `from_id` int(11) NOT NULL COMMENT 'who send the request',
  `to_id` int(11) NOT NULL COMMENT 'who receives the request',
  `user_files_id` int(11) unsigned DEFAULT '0' COMMENT 'files to attach to this email',
  `send_status` enum('pending','processing','sent','fail','fail_processed') CHARACTER SET utf8 NOT NULL COMMENT 'Status of the sent email. fail processed is faild and dev took care of it',
  `status` enum('enabled','disabled','archived','deleted') CHARACTER SET utf8 NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `event_dates`
--

DROP TABLE IF EXISTS `event_dates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event_dates` (
  `id` int(11) unsigned NOT NULL,
  `course_id` int(11) unsigned NOT NULL,
  `location_id` int(11) unsigned DEFAULT NULL,
  `location_comment` text NOT NULL,
  `cne_number` varchar(50) DEFAULT NULL,
  `min_registration` smallint(5) unsigned NOT NULL,
  `max_registration` smallint(5) unsigned NOT NULL,
  `registration_status` enum('open','close') NOT NULL DEFAULT 'open',
  `event_repeat_group_id` int(11) unsigned NOT NULL COMMENT 'all dates of the same group id are part of the same event',
  `all_day_event` enum('Yes','No') NOT NULL DEFAULT 'Yes',
  `start_date` datetime NOT NULL COMMENT 'Start date of the event',
  `end_date` datetime DEFAULT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `event_dates_topics`
--

DROP TABLE IF EXISTS `event_dates_topics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event_dates_topics` (
  `id` int(11) unsigned NOT NULL,
  `course_id` int(11) unsigned NOT NULL,
  `event_date_id` int(11) unsigned NOT NULL,
  `content_container_id` int(11) unsigned NOT NULL,
  `location_id` int(11) unsigned DEFAULT NULL,
  `cne_number` varchar(50) DEFAULT NULL,
  `min_registration` smallint(5) unsigned NOT NULL,
  `max_registration` smallint(5) unsigned NOT NULL,
  `location_room` varchar(100) DEFAULT NULL,
  `registration_status` enum('open','close') NOT NULL DEFAULT 'open',
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `recording_metadata` text,
  `recording_url` text COMMENT 'This is what identifies the movie on cast tv servers',
  `recording2_url` text,
  `recording3_url` text,
  `machine_type` varchar(10) NOT NULL,
  `machine_log` mediumtext,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `event_dates_topics_rbac_user`
--

DROP TABLE IF EXISTS `event_dates_topics_rbac_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event_dates_topics_rbac_user` (
  `id` int(11) unsigned NOT NULL,
  `event_dates_topics_id` int(11) unsigned NOT NULL COMMENT 'This is PK to event_dates_topics Table.',
  `faculty_rbac_user_id` int(11) unsigned NOT NULL COMMENT 'This is PK to rbac_user Table.',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `event_repeats`
--

DROP TABLE IF EXISTS `event_repeats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event_repeats` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `course_id` int(11) unsigned NOT NULL,
  `event_repeat_group_id` int(11) unsigned NOT NULL,
  `cne_number` varchar(50) DEFAULT NULL,
  `min_registration` smallint(5) unsigned NOT NULL,
  `max_registration` smallint(5) unsigned NOT NULL,
  `registration_status` enum('open','close') NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21701 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lms2archive_course_enrollment_settings_old_214`
--

DROP TABLE IF EXISTS `lms2archive_course_enrollment_settings_old_214`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lms2archive_course_enrollment_settings_old_214` (
  `id` int(11) unsigned NOT NULL COMMENT 'This is one to one relationship to course Table',
  `has_payment` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'does course have payment',
  `allowed_payment_types` set('cash','check','credit_card','promotional_code','access_code') DEFAULT NULL COMMENT 'These are the ways a user can pay for the course',
  `base_price` decimal(8,0) NOT NULL DEFAULT '0' COMMENT 'This is the price to enroll to the course',
  `activity_director_approval` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'whether the Ad needs to approve enrollments',
  `department_head_approvalTOBEDELETED211` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'del',
  `allow_reenroll` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'whether the user can enroll again to the course',
  `time_until_reregister` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Time until a user can reenroll',
  `allow_reschedule` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Whether the user can reschedule their enrollment',
  `enrollment_levelTOBEDELETED211` set('course','event','day','topic') NOT NULL DEFAULT 'course' COMMENT 'del',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `organization_department`
--

DROP TABLE IF EXISTS `organization_department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organization_department` (
  `id` int(11) unsigned NOT NULL,
  `organization_id` int(11) unsigned NOT NULL COMMENT 'Organization ID. By this field we will idetified this department belongs to which organization. FK from organization TABLE.',
  `parent_id` int(11) unsigned NOT NULL,
  `rbac_user_id` int(11) unsigned DEFAULT NULL COMMENT 'User ID. This is the user ID who is going to be the department head of thsi department.',
  `code` varchar(100) DEFAULT NULL COMMENT 'Department Code. Each organization might assign a different code to their departments and it can be stored here.',
  `name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL COMMENT 'Description of the department which associated to this organization.',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `org_dep_org_id_code_u` (`organization_id`,`code`),
  KEY `organization_id` (`organization_id`),
  KEY `rbac_user_id` (`rbac_user_id`),
  KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `organization_education_group`
--

DROP TABLE IF EXISTS `organization_education_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organization_education_group` (
  `id` int(11) unsigned NOT NULL,
  `organization_id` int(11) unsigned NOT NULL,
  `organization_department_id` int(11) unsigned NOT NULL COMMENT 'This Education Group will falls under associated department which has been associated to the organization.',
  `rbac_user_id` int(11) unsigned DEFAULT NULL COMMENT 'This user id Education Specialist',
  `name` varchar(100) DEFAULT NULL COMMENT 'Name of the Edication group.',
  `description` varchar(255) DEFAULT ' ' COMMENT 'Description of this Education Group.',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`),
  KEY `rbac_user_id` (`rbac_user_id`),
  KEY `organization_id` (`organization_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `organization_education_group_user`
--

DROP TABLE IF EXISTS `organization_education_group_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organization_education_group_user` (
  `id` int(11) unsigned NOT NULL,
  `organization_education_group_id` int(11) unsigned NOT NULL COMMENT 'The ID of the Education Group which already has been created and associated to the department.',
  `rbac_user_id` int(11) unsigned NOT NULL COMMENT 'Student of this Education Group.',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`),
  KEY `rbac_user_id` (`rbac_user_id`),
  KEY `organization_education_group_id` (`organization_education_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `organization_user_enrollment`
--

DROP TABLE IF EXISTS `organization_user_enrollment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organization_user_enrollment` (
  `id` int(11) unsigned NOT NULL,
  `organization_id` int(11) unsigned NOT NULL,
  `rbac_user_id` int(11) unsigned NOT NULL,
  `organization_department_id` int(11) unsigned DEFAULT NULL,
  `organization_position_id` int(11) unsigned DEFAULT NULL,
  `employment_id` varchar(20) DEFAULT NULL,
  `employment_type` enum('employee','preemployment','contractor','student','employee-unverified') NOT NULL,
  `feed_verified` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'whether this entry was feed verified or not.',
  `status_comment` varchar(255) NOT NULL,
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rbac_user`
--

DROP TABLE IF EXISTS `rbac_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rbac_user` (
  `id` int(11) unsigned NOT NULL DEFAULT '0',
  `file_upload_id` int(11) unsigned DEFAULT NULL,
  `username` varchar(255) CHARACTER SET utf8 NOT NULL COMMENT 'Username of the user of the system which has to be uniqe and should be a valid email address.',
  `password` varchar(255) CHARACTER SET utf8 NOT NULL COMMENT 'User''s password which is hashed in SH1.',
  `open_id_uid` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `first_name` varchar(255) CHARACTER SET utf8 DEFAULT '  ' COMMENT 'User''s first name.',
  `middle_name` varchar(255) CHARACTER SET utf8 DEFAULT ' ' COMMENT 'User''s middle name.',
  `last_name` varchar(255) CHARACTER SET utf8 DEFAULT ' ' COMMENT 'User''s last name.',
  `gender` enum('m','f') CHARACTER SET utf8 DEFAULT NULL COMMENT 'User''s gender.',
  `lut_ethnicity_id` int(11) DEFAULT NULL COMMENT 'forgeirn key of lut ethnicity table',
  `email_1` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT 'User''s first alternative email address.',
  `email_2` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT 'User''s second alternative email address.',
  `address` varchar(255) CHARACTER SET utf8 DEFAULT ' ' COMMENT 'User''s address.',
  `city` varchar(255) CHARACTER SET utf8 DEFAULT ' ' COMMENT 'User''s city location.',
  `province` varchar(255) CHARACTER SET utf8 DEFAULT ' ' COMMENT 'User''s state location.',
  `postal` varchar(20) CHARACTER SET utf8 DEFAULT ' ' COMMENT 'User''s zip code.',
  `country_code` varchar(5) CHARACTER SET utf8 NOT NULL DEFAULT 'US' COMMENT '225 id the default ID of the US Country. ',
  `phone` varchar(255) CHARACTER SET utf8 DEFAULT ' ' COMMENT 'User''s phone number.',
  `date_of_birth` date DEFAULT NULL COMMENT 'User date of birth',
  `cvac_position_type` enum('Pharmacist','Technician','Nursing') CHARACTER SET utf8 DEFAULT NULL COMMENT 'User cvac position for pharmacy form',
  `language_code` varchar(5) CHARACTER SET utf8 NOT NULL DEFAULT 'en' COMMENT 'English is default value for language which is coming from lut_laguage Table',
  `last_login` date DEFAULT '0000-00-00' COMMENT 'Last time that user has logged in to the system.',
  `reset_password` enum('0','1') CHARACTER SET utf8 NOT NULL DEFAULT '0' COMMENT 'Flag that indicates if user has to reset his/her password on next login.',
  `biosketch` text CHARACTER SET utf8 COMMENT '????????',
  `is_email_fraud` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'If set to true, the email has been identified as fraudulent',
  `was_email_validated` tinyint(1) NOT NULL COMMENT 'validate email through migration or validation process or openid',
  `require_password_update` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'see if user is required to update the password after password reset.',
  `require_password_approval` tinyint(1) NOT NULL COMMENT 'Determines if the user needs approval by their deparment head to access their account',
  `require_profile_update` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'boolean: does user need a profile update',
  `last_require_profile_update` date DEFAULT NULL COMMENT 'last time the user did a require profile update',
  `status` enum('enabled','disabled','deleted') CHARACTER SET utf8 DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NULL DEFAULT NULL COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rbac_user_group`
--

DROP TABLE IF EXISTS `rbac_user_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rbac_user_group` (
  `id` int(11) unsigned NOT NULL,
  `rbac_user_id` int(11) unsigned NOT NULL COMMENT 'User ID. Associates a user to a group with this table.',
  `rbac_group_id` int(11) unsigned NOT NULL COMMENT 'Group ID. Associates a user to a group with this table.',
  `status` enum('enabled','disabled','deleted') CHARACTER SET utf8 NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rbac_user_login_log`
--

DROP TABLE IF EXISTS `rbac_user_login_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rbac_user_login_log` (
  `id` int(11) NOT NULL DEFAULT '0',
  `rbac_user_id` int(11) NOT NULL,
  `ip` varchar(25) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `expired` tinyint(1) NOT NULL DEFAULT '1',
  `status` enum('enabled','disabled','archived','deleted') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tag_used_course`
--

DROP TABLE IF EXISTS `tag_used_course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tag_used_course` (
  `id` int(11) NOT NULL,
  `tag_available_id` int(11) NOT NULL COMMENT 'foreign key to tag_available table',
  `target_id` int(11) NOT NULL COMMENT 'course id',
  `added_by_rbac_user_id` int(11) NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `target_id` (`target_id`),
  KEY `tag_available_id` (`tag_available_id`),
  KEY `target_id_2` (`target_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
-- Table structure for table `user_merge_course_enrollment_invoice_old_214`
--

DROP TABLE IF EXISTS `user_merge_course_enrollment_invoice_old_214`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_merge_course_enrollment_invoice_old_214` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `course_enrollment_rollout_id` int(11) NOT NULL,
  `invoice` text NOT NULL,
  `registerer_rbac_user_id` int(11) unsigned NOT NULL,
  `invoice_status` enum('pending','paid') NOT NULL DEFAULT 'pending',
  `invoice_total` decimal(8,2) NOT NULL,
  `payment_date` timestamp NULL DEFAULT NULL,
  `allow_previous` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Does enrollment allow previous score',
  `start_accept_score` datetime NOT NULL COMMENT 'This is when scores start being accepted',
  `allow_reenroll` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'allow re-enrollment for student',
  `time_until_reregister` int(4) NOT NULL DEFAULT '0' COMMENT 'Number of months to allow re-enrollment',
  `date_of_reregister` datetime DEFAULT NULL COMMENT 'The date when reenrollment begins',
  `status` enum('enabled','disabled','deleted') NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned NOT NULL,
  `modified_by` int(11) unsigned NOT NULL,
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
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

-- Dump completed on 2016-10-31  4:32:25
