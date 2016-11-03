-- MySQL dump 10.13  Distrib 5.6.23, for Linux (x86_64)
--
-- Host: 172.24.10.155    Database: user_merge
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
  `billing_details` text NOT NULL COMMENT 'data related for the reduction amount.',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
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
  `bill_to_entity_type` enum('rbac_user','organization','organization_department','organization_education_group') NOT NULL DEFAULT 'rbac_user' COMMENT 'which of the invoice \nshould this go to',
  `bill_to_entity_id` int(11) unsigned NOT NULL COMMENT 'entity id is based on entity type, data could come from, rbac_user, organization, organization_department, \norganization_education_group.',
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
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `certificate`
--

DROP TABLE IF EXISTS `certificate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `certificate` (
  `id` int(11) unsigned NOT NULL,
  `ce_director_rbac_user_id` int(11) unsigned NOT NULL COMMENT 'owner of the certificate',
  `file_upload_id` int(11) unsigned NOT NULL COMMENT 'base image for certificate',
  `organization_id` int(11) unsigned NOT NULL COMMENT 'null value is public certificate.  anyone can use it.  If it''s set, only that organization can use it.',
  `certificate_name` varchar(200) NOT NULL COMMENT 'name of certificate inputed by ce director',
  `disclosure_text` text NOT NULL COMMENT 'discloure comments for certificate',
  `template_output` text NOT NULL COMMENT 'html out of the template. This output will lay over the top of the file_upload',
  `certificate_type` enum('cme','cne','others') NOT NULL DEFAULT 'others' COMMENT 'type of certifcate that the authoring body is issuing',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_access`
--

DROP TABLE IF EXISTS `content_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_access` (
  `id` int(11) unsigned NOT NULL,
  `content_container_id` int(11) unsigned NOT NULL,
  `organization_id` int(11) unsigned DEFAULT NULL,
  `organization_department_id` int(11) unsigned DEFAULT NULL,
  `organization_education_group_id` int(11) unsigned DEFAULT NULL,
  `student_rbac_user_id` int(11) unsigned DEFAULT NULL,
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_aicc_au_log`
--

DROP TABLE IF EXISTS `content_aicc_au_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_aicc_au_log` (
  `id` int(11) unsigned NOT NULL,
  `enrollment_id` int(11) unsigned NOT NULL COMMENT 'Contains Content enrollment id',
  `rbac_user_id` int(11) unsigned NOT NULL COMMENT 'Contains User id',
  `content_id` int(11) unsigned NOT NULL COMMENT 'Contains Content id from Content table',
  `au_id` int(11) unsigned NOT NULL COMMENT 'Contains id from content_aicc_au',
  `aicc_data` text COMMENT 'Contains aicc _data send with hacp putParam command',
  `lesson_status` varchar(100) DEFAULT NULL COMMENT 'Contains lesson_status from aicc_data',
  `lesson_location` varchar(100) DEFAULT NULL COMMENT 'Contains lesson_location from aicc_data',
  `score` int(11) unsigned DEFAULT NULL COMMENT 'Contains Score from aicc_data',
  `duration` varchar(10) DEFAULT NULL COMMENT 'Contains course time from aicc_data',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Contains log of AU ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_container`
--

DROP TABLE IF EXISTS `content_container`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_container` (
  `id` int(11) unsigned NOT NULL,
  `organization_id` int(11) unsigned DEFAULT NULL,
  `file_upload_id` int(11) unsigned DEFAULT NULL,
  `rbac_user_id` int(11) unsigned NOT NULL,
  `name` varchar(255) NOT NULL COMMENT 'The name of the content container(shell)',
  `description` text NOT NULL COMMENT 'The description of content container (shell.)',
  `estimated_hour` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Estimated total hours of this content.',
  `estimated_minute` tinyint(3) unsigned NOT NULL DEFAULT '30' COMMENT 'Estimated total minuts of this content.',
  `estimated_second` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Estimated total seconds of this content.',
  `is_completed` enum('0','1') NOT NULL DEFAULT '0' COMMENT '????????',
  `content_container_status` enum('inactive','active','archived','review') NOT NULL DEFAULT 'inactive' COMMENT 'Status of the content container. It can be INACTIVE,  ACTIVE, \nARCHIVED, and REVIEWD.',
  `delivery_type` enum('live','online') NOT NULL DEFAULT 'online',
  `expired_date` date NOT NULL DEFAULT '0000-00-00' COMMENT 'Expiration date of this content container.',
  `access_level` enum('public','private','reviewer','consortium','self') NOT NULL DEFAULT 'public' COMMENT 'Access level of this content container. It can be PUBLIC, PRIVATE, or REVIEWER.',
  `content_type` enum('education','quiz','survey','live_event','survey_template') NOT NULL DEFAULT 'education',
  `processing_status` enum('pending','success','failed') NOT NULL DEFAULT 'pending',
  `publish_error` tinytext COMMENT 'Errors from a publish attempt. When faculty tries to publish the content if the content or the container has any issue it will be saved here \nso it can be reviewed and fixed later by the creator.',
  `version` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `posttest_type` enum('None','Create','Upload','Copy','Catalog') DEFAULT 'None',
  `pretest_type` enum('None','Create','Upload','Catalog') NOT NULL DEFAULT 'None',
  `has_return_demo` tinyint(1) NOT NULL DEFAULT '0',
  `created_from_course_id` int(11) DEFAULT NULL COMMENT 'what courses was this content created from',
  `created_from_task_order` int(11) DEFAULT NULL COMMENT 'what task did this content create from',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
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
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_reviewer`
--

DROP TABLE IF EXISTS `content_reviewer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_reviewer` (
  `id` int(11) unsigned NOT NULL,
  `content_container_id` int(11) unsigned NOT NULL COMMENT 'ID of the content container.',
  `rbac_user_id` int(11) unsigned NOT NULL COMMENT '????? User ID of the reviewer of the content.',
  `reviewer_organization_id` int(11) NOT NULL COMMENT 'The reviewer organization.  To be used for sending email',
  `reviewer_status` enum('pending','reviewed','completed','archived') NOT NULL DEFAULT 'pending' COMMENT 'Status of reviewer.  PENDING; user first added as reviewer.  REVIEWED: \nused reviewed the content.  COMPLETED: when review process is done.  ARCHIVED: when reivew process is done and faculty add new reviewer.',
  `reviewer_comments` text NOT NULL COMMENT 'The comment of the content reviewer. ',
  `is_current` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'is this record the current reviewer for the content',
  `due_date` date DEFAULT NULL COMMENT 'when the user must complete the review by',
  `reviewed_date` datetime DEFAULT NULL COMMENT 'This is the review date of the reviewer',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_scorm_sco_log`
--

DROP TABLE IF EXISTS `content_scorm_sco_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_scorm_sco_log` (
  `id` int(11) unsigned NOT NULL,
  `enrollment_id` int(11) unsigned NOT NULL COMMENT 'Contains Content enrollment id',
  `rbac_user_id` int(11) unsigned NOT NULL COMMENT 'Contains User id',
  `content_id` int(11) unsigned NOT NULL COMMENT 'Contains Content id from Content table',
  `content_scorm_sco_id` int(11) unsigned DEFAULT NULL COMMENT 'Primary key of content_scorm_sco',
  `user_model` text COMMENT 'Contains user model data sent by the scorm course',
  `suspend_data` text COMMENT 'Contains suspend data sent by scorm course',
  `lesson_status` enum('passed','completed','failed','incomplete','browsed','not attempted') NOT NULL DEFAULT 'incomplete' COMMENT 'Contains lesson_status from scorm course user \nmodel',
  `lesson_location` varchar(100) DEFAULT NULL COMMENT 'Contains lesson_location from scorm course user model',
  `raw_score` int(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Contains raw Score from scorm course user model',
  `max_score` int(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Contains raw Score from scorm course user model',
  `time_spent` varchar(10) DEFAULT NULL COMMENT 'Contains time spent on sco',
  `total_interaction` int(3) unsigned DEFAULT NULL,
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Contains log of AU ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_transcript`
--

DROP TABLE IF EXISTS `content_transcript`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_transcript` (
  `id` int(11) unsigned NOT NULL,
  `transcript_group_id` bigint(11) unsigned NOT NULL COMMENT 'This value is created by the content viewer. Its a combination of timestamps and user id.',
  `content_transcript_log_id` int(11) unsigned NOT NULL,
  `content_source_type` enum('survey','content') NOT NULL DEFAULT 'content',
  `rbac_user_id` int(11) unsigned NOT NULL,
  `enrollment_id` int(11) unsigned NOT NULL,
  `content_id` int(11) unsigned NOT NULL,
  `sub_content_id` int(11) unsigned DEFAULT NULL,
  `content_container_id` int(11) unsigned NOT NULL,
  `course_id` int(11) unsigned DEFAULT NULL,
  `course_task_id` int(11) unsigned DEFAULT NULL,
  `course_content_id` int(11) unsigned DEFAULT NULL,
  `content_passing_score` int(11) unsigned NOT NULL,
  `raw_score` smallint(6) NOT NULL DEFAULT '0',
  `final_status` enum('incomplete','complete','fail','pass') NOT NULL DEFAULT 'incomplete',
  `time_spent` mediumint(9) NOT NULL DEFAULT '0',
  `final_score` int(3) unsigned NOT NULL,
  `final_time` int(11) unsigned NOT NULL,
  `version` int(3) unsigned NOT NULL,
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_transcript_log`
--

DROP TABLE IF EXISTS `content_transcript_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_transcript_log` (
  `id` int(11) unsigned NOT NULL,
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
  `suspend_data` text NOT NULL,
  `user_model` text NOT NULL,
  `raw_score` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `max_score` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `passing_score` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `content_status` varchar(30) NOT NULL DEFAULT 'initialize',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course`
--

DROP TABLE IF EXISTS `course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course` (
  `id` int(11) unsigned NOT NULL,
  `organization_id` int(11) unsigned NOT NULL COMMENT 'Org that the course belongs to',
  `owner_rbac_user_id` int(11) unsigned NOT NULL COMMENT 'Id of the activity director',
  `file_upload_id` int(11) unsigned DEFAULT NULL COMMENT 'promo material upload ID',
  `title` varchar(255) NOT NULL COMMENT 'title of the course',
  `description` text NOT NULL COMMENT 'description of the course',
  `activity_type` enum('On Demand','Clinical Simulation','Conference','Instructor-led class','content_wrapper_education','content_wrapper_quiz','content_wrapper_survey','content_wrapper_survey_template') NOT NULL COMMENT 'The type of course this is',
  `allow_edit_curriculum` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'if true, course can be editted any time',
  `has_payment` tinyint(1) NOT NULL DEFAULT '0',
  `allowed_payment_types` set('cash','check','credit_card','promotional_code','access_code') DEFAULT NULL COMMENT 'These are the ways a user can pay for the course',
  `base_price` decimal(8,0) NOT NULL DEFAULT '0',
  `allow_previous` enum('0','1') NOT NULL COMMENT 'weather allow previous score or not',
  `previous_window` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'days before enrollment to count previous scroe',
  `allow_reenroll` tinyint(1) NOT NULL DEFAULT '0',
  `time_until_reregister` mediumint(8) NOT NULL DEFAULT '0',
  `allow_reschedule` tinyint(1) NOT NULL DEFAULT '0',
  `activity_director_approval` tinyint(1) NOT NULL DEFAULT '0',
  `has_online_content` tinyint(1) NOT NULL COMMENT 'whether this course includes online content',
  `requires_return_demo` tinyint(1) NOT NULL COMMENT 'whether this has a return demo or not',
  `has_certificate` enum('0','1') NOT NULL DEFAULT '0' COMMENT 'whether the course has credit',
  `certificate_type` set('cme','cne','others') DEFAULT NULL COMMENT 'the type of certificate the course has',
  `department_funds` enum('0','1') NOT NULL DEFAULT '0' COMMENT 'is course paid for with department funds',
  `join_sponsorship` varchar(255) NOT NULL DEFAULT 'NULL' COMMENT 'does course have joint sponsorship',
  `is_completed` enum('0','1') NOT NULL DEFAULT '0' COMMENT 'I dont know',
  `screening_practices` enum('0','1') NOT NULL DEFAULT '0' COMMENT 'whether content is based on best practices',
  `screening_gap` enum('0','1') NOT NULL DEFAULT '0' COMMENT 'whether a gap exists between current and best practices',
  `screening_result` enum('0','1') NOT NULL DEFAULT '0' COMMENT 'whether closing the gap will improve outcomes',
  `screening_education` enum('0','1') NOT NULL DEFAULT '0' COMMENT 'whether the intervention will improve practices',
  `statement_of_need` text NOT NULL COMMENT 'a statement describing the need for the course',
  `result_competance` enum('0','1') NOT NULL DEFAULT '0' COMMENT 'whether improved competance is to be achieved',
  `result_performance` enum('0','1') NOT NULL DEFAULT '0' COMMENT 'whether better performance is to be achieved',
  `result_patient_outcomes` enum('0','1') NOT NULL DEFAULT '0' COMMENT 'whether better outcomes is to be achieved',
  `barrier_type` enum('0','1') NOT NULL DEFAULT '0' COMMENT 'whether barriers exist to achieve goal',
  `task_type` enum('mandatory','custom') NOT NULL DEFAULT 'mandatory' COMMENT 'Mandatory makes all content mandatory while custom allows the user to set up tasks',
  `is_featured_course` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'indicate if course is featured on front page',
  `approve_email` text NOT NULL COMMENT 'email to send to uses who are approved for the course',
  `reject_email` text NOT NULL COMMENT 'email the users receives when rejected from the course',
  `pending_email` text NOT NULL COMMENT 'email the user receives when pending in the course',
  `reminder_email` text NOT NULL COMMENT 'text of the reminder email for event attendees',
  `reminder_times` set('1','2','7','14') NOT NULL COMMENT 'days before event to send reminder email',
  `expiration_date` date NOT NULL COMMENT 'date the course expires and enrollment stops',
  `view_level` enum('catalog','course_creation_wizard') NOT NULL DEFAULT 'catalog' COMMENT 'Show course in catalog, or not',
  `access` enum('public','private','consortium','self') NOT NULL DEFAULT 'public' COMMENT 'access level of the course, who can see and enroll',
  `access_stored` tinyint(1) unsigned NOT NULL COMMENT 'Says whether accessible content is stored for this course',
  `version` int(11) unsigned NOT NULL DEFAULT '1' COMMENT 'version of the course',
  `publish_status` enum('Active','Inactive','Review','Expire') NOT NULL DEFAULT 'Inactive' COMMENT 'status of the course, state of creation',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
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
  `course_enrollment_settings_id` int(11) unsigned DEFAULT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of this record',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
  `status` enum('enabled','expired','canceled','archived') NOT NULL COMMENT 'expired means that you can''t launch the course anymore, enrolment was expired by manager, canceled \nmeans it was used in a new enrollment',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned NOT NULL,
  `modified_by` int(11) unsigned NOT NULL,
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_enrollment_comments`
--

DROP TABLE IF EXISTS `course_enrollment_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_enrollment_comments` (
  `id` int(11) unsigned NOT NULL,
  `course_enrollment_id` int(11) unsigned NOT NULL,
  `comment` text,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_rbac_user_id` int(11) unsigned NOT NULL COMMENT 'User who generated the comment',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) unsigned NOT NULL,
  `modified_by` int(11) unsigned NOT NULL,
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1402 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_enrollment_day`
--

DROP TABLE IF EXISTS `course_enrollment_day`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_enrollment_day` (
  `id` int(11) unsigned NOT NULL,
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
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_enrollment_event`
--

DROP TABLE IF EXISTS `course_enrollment_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_enrollment_event` (
  `id` int(11) unsigned NOT NULL,
  `course_enrollment_id` int(11) unsigned NOT NULL,
  `event_repeat_group_id` int(11) unsigned NOT NULL,
  `student_rbac_user_id` int(11) unsigned NOT NULL,
  `is_attended` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'did user attended the event. if user attended any day for the event than event should be marked to attended',
  `status` enum('enabled','disabled','deleted') NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) NOT NULL,
  `modified_by` int(11) NOT NULL,
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_enrollment_rollout_status`
--

DROP TABLE IF EXISTS `course_enrollment_rollout_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_enrollment_rollout_status` (
  `id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `organization_id` int(11) unsigned NOT NULL,
  `course_id` int(11) unsigned DEFAULT NULL,
  `storage_id` int(11) unsigned DEFAULT NULL,
  `rollout_id` int(11) DEFAULT NULL COMMENT ' The Course Enrollment Rollout Id',
  `type` enum('new','edit','paid','clean_up') DEFAULT NULL,
  `rollout_status` enum('in_progress','success','failure','waiting') DEFAULT NULL,
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_enrollment_settings`
--

DROP TABLE IF EXISTS `course_enrollment_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_enrollment_settings` (
  `id` int(11) unsigned NOT NULL,
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
  `merge_id` int(11) NOT NULL,
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
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
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
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cron_file_uploaded`
--

DROP TABLE IF EXISTS `cron_file_uploaded`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cron_file_uploaded` (
  `id` int(11) unsigned NOT NULL,
  `rbac_user_id` int(11) unsigned DEFAULT NULL,
  `file_name` varchar(255) NOT NULL COMMENT 'The name of the uploaded file.',
  `file_size` int(11) unsigned NOT NULL COMMENT 'The size of the uploaded file.',
  `file_type` varchar(40) NOT NULL COMMENT 'The extension of the uploaded file.',
  `file_extension` varchar(10) NOT NULL,
  `file_thumbnail` varchar(255) NOT NULL COMMENT 'The name of the thumbnail of the uploaded file.',
  `xml_type` enum('image','audio','video','document') NOT NULL DEFAULT 'image',
  `version` varchar(255) NOT NULL COMMENT 'The version for this uploaded file.',
  `destination` varchar(255) NOT NULL COMMENT '????????',
  `process_type` varchar(255) NOT NULL COMMENT '???????????',
  `file_status` enum('pending','processing','failed','success') NOT NULL DEFAULT 'pending' COMMENT '????????',
  `process_status` enum('pending','processing','failed','success') NOT NULL DEFAULT 'pending' COMMENT '????????',
  `last_status_message` varchar(100) NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `email`
--

DROP TABLE IF EXISTS `email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email` (
  `id` int(11) unsigned NOT NULL,
  `urgency_level` smallint(6) NOT NULL DEFAULT '1' COMMENT 'The lower the number, the more urgent is this email',
  `subject` varchar(255) NOT NULL COMMENT 'subject of the email',
  `body` text NOT NULL COMMENT 'body of the email',
  `from_id` int(11) NOT NULL COMMENT 'who send the request',
  `to_id` int(11) NOT NULL COMMENT 'who receives the request',
  `user_files_id` int(11) unsigned DEFAULT '0' COMMENT 'files to attach to this email',
  `send_status` enum('pending','processing','sent','fail','fail_processed') NOT NULL COMMENT 'Status of the sent email. fail processed is faild and dev took care of it',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
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
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lms2groups_coordinator`
--

DROP TABLE IF EXISTS `lms2groups_coordinator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lms2groups_coordinator` (
  `id` int(11) unsigned NOT NULL,
  `group_id` int(11) unsigned NOT NULL,
  `coordinator_rbac_user_id` int(11) unsigned NOT NULL COMMENT 'user who can manage this group role edu, add users',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lms2groups_group`
--

DROP TABLE IF EXISTS `lms2groups_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lms2groups_group` (
  `id` int(11) unsigned NOT NULL,
  `creator_rbac_user_id` int(11) unsigned NOT NULL COMMENT 'This user owns this group and can later modify its settings, can change as opposed to created_by field',
  `ownership_level` enum('OC','RA','DH','DHC') DEFAULT 'DH' COMMENT 'The highest role of the edu grp creator',
  `title` varchar(100) DEFAULT NULL COMMENT 'Name of the Edication group.',
  `description` varchar(255) DEFAULT NULL COMMENT 'A short description of the Education Group.',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lms2groups_user`
--

DROP TABLE IF EXISTS `lms2groups_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lms2groups_user` (
  `id` int(11) unsigned NOT NULL,
  `group_id` int(11) unsigned NOT NULL,
  `student_rbac_user_id` int(11) unsigned NOT NULL COMMENT 'users in this group',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lms3cron_file_uploaded`
--

DROP TABLE IF EXISTS `lms3cron_file_uploaded`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lms3cron_file_uploaded` (
  `id` int(11) unsigned NOT NULL,
  `rbac_user_id` int(11) unsigned DEFAULT NULL,
  `file_name` varchar(255) NOT NULL COMMENT 'The name of the uploaded file.',
  `file_size` int(11) unsigned NOT NULL COMMENT 'The size of the uploaded file.',
  `file_type` varchar(40) NOT NULL COMMENT 'The extension of the uploaded file.',
  `file_extension` varchar(10) NOT NULL,
  `file_thumbnail` varchar(255) NOT NULL COMMENT 'The name of the thumbnail of the uploaded file.',
  `xml_type` enum('image','audio','video','document') NOT NULL DEFAULT 'image',
  `version` varchar(255) NOT NULL DEFAULT ' ' COMMENT 'The version for this uploaded file.',
  `destination` varchar(255) NOT NULL COMMENT '????????',
  `process_type` varchar(255) NOT NULL COMMENT '???????????',
  `file_status` enum('pending','processing','failed','success') NOT NULL DEFAULT 'pending' COMMENT '????????',
  `process_status` enum('pending','processing','failed','success') NOT NULL DEFAULT 'pending' COMMENT '????????',
  `last_status_message` varchar(100) NOT NULL DEFAULT ' ',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lms3users_external_user_register`
--

DROP TABLE IF EXISTS `lms3users_external_user_register`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lms3users_external_user_register` (
  `id` int(11) unsigned NOT NULL,
  `rbac_user_id` int(11) unsigned NOT NULL,
  `code_blue_name_id` varchar(255) NOT NULL,
  `status` enum('enabled') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lms3users_user_identifier`
--

DROP TABLE IF EXISTS `lms3users_user_identifier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lms3users_user_identifier` (
  `user_identifier` varchar(255) NOT NULL,
  `rbac_user_id` int(10) unsigned NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `identifier_type` enum('email','medstar_user_id','employee_id') NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`user_identifier`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='table to map various user identifiers to a single rbac_user entry';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lms3users_user_roles`
--

DROP TABLE IF EXISTS `lms3users_user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lms3users_user_roles` (
  `id` int(11) unsigned NOT NULL,
  `rbac_user_id` int(11) unsigned NOT NULL COMMENT 'User ID from lms2prod.',
  `role_id` smallint(3) unsigned NOT NULL COMMENT 'The role class ID associated to the user',
  `organization_id` smallint(3) unsigned NOT NULL,
  `role_scope` enum('system','org','mnow','TES','watershed','pathygiene') NOT NULL DEFAULT 'org' COMMENT 'Whether the role is for the current org, or for all',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lms3zull_progress_log`
--

DROP TABLE IF EXISTS `lms3zull_progress_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lms3zull_progress_log` (
  `id` int(11) unsigned NOT NULL,
  `rbac_user_id` int(11) DEFAULT NULL,
  `organization_id` text,
  `session_id` text,
  `scenario` text,
  `data` mediumblob,
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lms3zull_transcript`
--

DROP TABLE IF EXISTS `lms3zull_transcript`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lms3zull_transcript` (
  `id` int(11) unsigned NOT NULL,
  `rbac_user_id` int(11) DEFAULT NULL,
  `organization_id` text,
  `session_id` text,
  `scenario` text,
  `completed` tinyint(1) NOT NULL,
  `percent` float NOT NULL,
  `elapsed` float NOT NULL,
  `laststep` int(1) NOT NULL,
  `data` mediumblob,
  `timeData` varchar(64) DEFAULT NULL,
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `location_favorite`
--

DROP TABLE IF EXISTS `location_favorite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `location_favorite` (
  `id` int(11) unsigned NOT NULL,
  `location_id` int(11) unsigned NOT NULL COMMENT 'This is a PK to Location Table and it holds the ID of the location.',
  `rbac_user_id` int(11) unsigned NOT NULL COMMENT 'This is a PK to RBAC_USER Table and will hold the ID of the creator of this location.',
  `organization_id` int(11) unsigned NOT NULL COMMENT 'This field will FK to the Organization table and will relates this record to the spesific organization.',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='This table will link locations to organizations & users';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `logistics_room`
--

DROP TABLE IF EXISTS `logistics_room`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logistics_room` (
  `id` int(11) unsigned NOT NULL,
  `area_id` int(11) unsigned NOT NULL,
  `name` text NOT NULL,
  `address_1` varchar(255) NOT NULL COMMENT 'Location''s street Address',
  `address_2` varchar(255) NOT NULL COMMENT 'Location''s Suite or Apt. Number',
  `title` varchar(255) NOT NULL COMMENT 'Name of the location',
  `city` varchar(255) NOT NULL COMMENT 'Location''s city',
  `state` varchar(255) NOT NULL COMMENT 'Location''s state',
  `zipcode` char(5) NOT NULL COMMENT 'Location''s zipcode',
  `capacity` int(11) unsigned NOT NULL DEFAULT '1',
  `comments` text,
  `longitude` float NOT NULL,
  `latitude` float NOT NULL,
  `rbac_user_id_favorites` int(11) unsigned DEFAULT NULL COMMENT 'Defines user favorites by adding rbac_user_id',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `merge`
--

DROP TABLE IF EXISTS `merge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `merge` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `merge_item_id` int(11) unsigned NOT NULL,
  `merge_into_id` int(11) unsigned NOT NULL,
  `place` varchar(75) NOT NULL,
  `status` enum('merged','unmerged') NOT NULL DEFAULT 'merged',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`),
  KEY `merge_item_id` (`merge_item_id`),
  KEY `merge_into_id` (`merge_into_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4577 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `organization_department`
--

DROP TABLE IF EXISTS `organization_department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organization_department` (
  `id` int(11) unsigned NOT NULL,
  `organization_id` int(11) unsigned NOT NULL COMMENT 'Organization ID. By this field we will idetified this department belongs to which organization. FK from organization \nTABLE.',
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
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `organization_department_proxy`
--

DROP TABLE IF EXISTS `organization_department_proxy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organization_department_proxy` (
  `id` int(11) unsigned NOT NULL,
  `rbac_user_id` int(11) unsigned NOT NULL COMMENT 'User ID. Associates a user as a proxy with this table.',
  `organization_department_id` int(11) unsigned NOT NULL COMMENT 'Dept ID. Associates a user as a proxy with this table.',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
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
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
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
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
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
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rbac_user`
--

DROP TABLE IF EXISTS `rbac_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rbac_user` (
  `id` int(11) unsigned NOT NULL,
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
  `was_email_validated` tinyint(1) NOT NULL COMMENT 'validate email through migration or validation process or openid',
  `require_password_update` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'see if user is required to update the password after password reset.',
  `require_password_approval` tinyint(1) NOT NULL COMMENT 'Determines if the user needs approval by their deparment head to access their account',
  `require_profile_update` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'boolean: does user need a profile update',
  `last_require_profile_update` date DEFAULT NULL COMMENT 'last time the user did a require profile update',
  `status` enum('enabled','disabled','deleted') DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rbac_user_login_log`
--

DROP TABLE IF EXISTS `rbac_user_login_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rbac_user_login_log` (
  `id` int(11) unsigned NOT NULL,
  `rbac_user_id` int(11) NOT NULL,
  `ip` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `expired` tinyint(1) NOT NULL DEFAULT '1',
  `status` enum('enabled','disabled','archived','deleted') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1891870 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Table logs a user login and enables a unified login in the s';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rbac_user_security_question`
--

DROP TABLE IF EXISTS `rbac_user_security_question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rbac_user_security_question` (
  `id` int(11) unsigned NOT NULL,
  `rbac_user_id` int(11) unsigned DEFAULT NULL,
  `order_key` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `lut_security_question_id` int(11) unsigned DEFAULT NULL,
  `answer` varchar(255) DEFAULT NULL COMMENT 'The answer to the security question.',
  `status` enum('enabled','disabled','deleted') DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reports_sharing`
--

DROP TABLE IF EXISTS `reports_sharing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reports_sharing` (
  `id` int(11) unsigned NOT NULL,
  `owner_rbac_user_id` int(11) unsigned NOT NULL,
  `share_with_rbac_user_id` int(11) unsigned NOT NULL,
  `organization_id` int(11) unsigned NOT NULL,
  `entity_id` int(11) unsigned NOT NULL COMMENT 'used for single entiry report sharing',
  `report_identifier` varchar(255) NOT NULL,
  `visible_report_title` varchar(255) NOT NULL,
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reports_user_standard`
--

DROP TABLE IF EXISTS `reports_user_standard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reports_user_standard` (
  `id` int(11) unsigned NOT NULL,
  `rbac_user_id` int(11) unsigned NOT NULL,
  `organization_id` int(11) unsigned NOT NULL,
  `report_name` enum('Educator All Courses','Educator All Content','Educator All Presentations','Educator All Quizzes','Educator All Returndemonstrations','Educator All Surveys','Manage All Courses','Manage Users Hrfeedregistration','Manage All Learners','Manage All Content','Manage All Presentations','Manage All Quizzes','Manage All Returndemonstrations','Manage All Surveys','Educator Specialist All Learners','Educator Specialist All Courses','Educator Specialist All Content') NOT NULL,
  `entity_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'For single entity reports, can be user id, course id or content id',
  `visible_report_title` varchar(255) NOT NULL,
  `report_build_status` enum('In Progress','Ready','Failed','Viewed') NOT NULL DEFAULT 'In Progress',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tag_available`
--

DROP TABLE IF EXISTS `tag_available`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tag_available` (
  `id` int(11) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `parent_tag_available_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'parent id of the tag.  use for tree generation',
  `added_by_rbac_user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'if we decide to limit users to can add tag',
  `target_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'the id of the source tag.  This is here for updating purposes (BLOOMID:1)',
  `target_source` varchar(50) NOT NULL COMMENT 'The source tag.  For example the source came from bloom.  This is here for updating purposes.',
  `is_category` enum('0','1') NOT NULL DEFAULT '1' COMMENT 'indicate if this tag is a category not',
  `can_tag` enum('0','1') NOT NULL DEFAULT '1' COMMENT 'decide if this can use to tag',
  `number_used` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'how many times this tag was used in the system',
  `tag_tree` varchar(800) NOT NULL COMMENT 'the tree structure of the tag represent by dot 000000001.00000000.2',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tag_used_content`
--

DROP TABLE IF EXISTS `tag_used_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tag_used_content` (
  `id` int(11) unsigned NOT NULL,
  `tag_available_id` int(11) unsigned NOT NULL COMMENT 'foreign key to tag_available table',
  `target_id` int(11) unsigned NOT NULL COMMENT 'content container id',
  `added_by_rbac_user_id` int(11) unsigned NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tag_used_course`
--

DROP TABLE IF EXISTS `tag_used_course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tag_used_course` (
  `id` int(11) unsigned NOT NULL,
  `tag_available_id` int(11) NOT NULL COMMENT 'foreign key to tag_available table',
  `target_id` int(11) NOT NULL COMMENT 'course id',
  `added_by_rbac_user_id` int(11) NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `todo`
--

DROP TABLE IF EXISTS `todo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `todo` (
  `id` int(11) unsigned NOT NULL,
  `task_class` varchar(255) NOT NULL,
  `organization_id` int(11) unsigned NOT NULL,
  `source_rbac_user_id` int(11) unsigned NOT NULL,
  `target_rbac_user_id` int(11) unsigned NOT NULL,
  `data` int(11) unsigned NOT NULL,
  `title` varchar(255) NOT NULL,
  `link` varchar(255) DEFAULT NULL,
  `onclick` varchar(256) DEFAULT NULL,
  `messege` varchar(255) NOT NULL,
  `activity` varchar(20) NOT NULL,
  `is_completed` enum('0','1') NOT NULL DEFAULT '0',
  `commets` text NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `todo_cycle1`
--

DROP TABLE IF EXISTS `todo_cycle1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `todo_cycle1` (
  `id` int(11) unsigned NOT NULL,
  `rbac_user_id` int(11) unsigned NOT NULL COMMENT 'Person assigned the todo',
  `organization_id` int(11) unsigned NOT NULL,
  `type` varchar(100) NOT NULL COMMENT 'Gives the validation function',
  `shortcut` int(11) unsigned NOT NULL COMMENT 'Gives the validation id',
  `viewed` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Determines if the todo has been viewed or not',
  `todo_status` enum('enabled','greenlit','disabled') NOT NULL DEFAULT 'enabled',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled',
  `todo_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Date when the todo should have existed',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) unsigned NOT NULL,
  `modified_by` int(11) unsigned NOT NULL,
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `todo_cycle2`
--

DROP TABLE IF EXISTS `todo_cycle2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `todo_cycle2` (
  `id` int(11) unsigned NOT NULL,
  `rbac_user_id` int(11) unsigned NOT NULL COMMENT 'Person assigned the todo',
  `organization_id` int(11) unsigned NOT NULL,
  `type` varchar(100) NOT NULL COMMENT 'Gives the validation function',
  `shortcut` int(11) unsigned NOT NULL COMMENT 'Gives the validation id',
  `viewed` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Determines if the todo has been viewed or not',
  `todo_status` enum('enabled','greenlit','disabled') NOT NULL DEFAULT 'enabled',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled',
  `todo_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Date when the todo should have existed',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) unsigned NOT NULL,
  `modified_by` int(11) unsigned NOT NULL,
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `todo_messages`
--

DROP TABLE IF EXISTS `todo_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `todo_messages` (
  `id` int(11) unsigned NOT NULL,
  `todo_id` int(11) unsigned NOT NULL,
  `rbac_user_id` int(11) unsigned NOT NULL COMMENT 'Person assigned the todo',
  `organization_id` int(11) unsigned NOT NULL,
  `todo_message` varchar(200) NOT NULL COMMENT 'message seen in the todo',
  `todo_link` varchar(100) NOT NULL COMMENT 'link for sending the todo where action is needed',
  `viewed` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Determines if the todo has been viewed or not',
  `todo_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Date when the todo should have existed',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) unsigned NOT NULL,
  `modified_by` int(11) unsigned NOT NULL,
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_association`
--

DROP TABLE IF EXISTS `user_association`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_association` (
  `id` int(11) unsigned NOT NULL,
  `rbac_user_id` int(11) unsigned NOT NULL COMMENT 'User ID.',
  `lut_association_id` int(11) unsigned DEFAULT NULL COMMENT 'Association ID which come from lut_association TABLE.',
  `association_name` varchar(255) NOT NULL COMMENT 'The name of the association. This also comes from the lut_association TABLE and can be changed to different name and it is \nhere to reduce the join in query.',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_certificate`
--

DROP TABLE IF EXISTS `user_certificate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_certificate` (
  `id` int(11) unsigned NOT NULL,
  `file_upload_id` int(11) unsigned DEFAULT NULL,
  `rbac_user_id` int(11) unsigned NOT NULL COMMENT 'User ID. the owner of the certificate.',
  `issued_body` varchar(100) NOT NULL COMMENT '????????',
  `type` varchar(100) NOT NULL COMMENT '????????',
  `certificate_number` varchar(50) NOT NULL COMMENT 'Certificate number',
  `date_issued` date NOT NULL DEFAULT '0000-00-00' COMMENT 'Date that certificate was issued.',
  `date_expired` date NOT NULL DEFAULT '0000-00-00' COMMENT 'Date that certificate will be expire.',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_disclosure`
--

DROP TABLE IF EXISTS `user_disclosure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_disclosure` (
  `id` int(11) unsigned NOT NULL,
  `rbac_user_id` int(11) unsigned NOT NULL COMMENT 'User ID.',
  `salary` text NOT NULL,
  `royalty` text NOT NULL,
  `intellectual_property` text NOT NULL,
  `consulting` text NOT NULL,
  `services` text NOT NULL,
  `contracted_research` text NOT NULL,
  `other_name` varchar(100) NOT NULL,
  `other_information` text NOT NULL,
  `impact` enum('yes','no') NOT NULL,
  `no_conflict` enum('yes','no') NOT NULL,
  `reference` enum('yes','no') NOT NULL,
  `signature` varchar(100) NOT NULL,
  `date_signed` date NOT NULL DEFAULT '0000-00-00',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_education`
--

DROP TABLE IF EXISTS `user_education`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_education` (
  `id` int(11) unsigned NOT NULL,
  `rbac_user_id` int(11) unsigned NOT NULL COMMENT 'User ID. Define who is getting this education.',
  `lut_education_id` int(11) unsigned DEFAULT NULL COMMENT 'This is the Id of the education from lut_education TABLE. Determine the type of the education from that table.',
  `institute_name` varchar(255) NOT NULL COMMENT 'The name of the user institutation that the user attended.',
  `education_name` varchar(255) DEFAULT NULL COMMENT 'The name of the education that student will get.',
  `years_of_education` smallint(5) unsigned NOT NULL DEFAULT '0',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_files`
--

DROP TABLE IF EXISTS `user_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_files` (
  `id` int(11) unsigned NOT NULL,
  `owner_rbac_user_id` int(11) unsigned NOT NULL,
  `owner_organization_id` int(11) unsigned NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `file_additional_info` text,
  `file_type` enum('txt','pdf','xls','sql') DEFAULT NULL,
  `file_status` enum('In Progress','Ready','Failed','Viewed') NOT NULL DEFAULT 'In Progress',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_form`
--

DROP TABLE IF EXISTS `user_form`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_form` (
  `id` int(11) unsigned NOT NULL,
  `rbac_user_id` int(11) unsigned NOT NULL COMMENT 'User completing the form',
  `form_identifier` varchar(100) NOT NULL COMMENT 'Name of the form being completed',
  `do_hide` tinyint(1) unsigned NOT NULL COMMENT 'Determines if form should be displayed again or hidden',
  `status` enum('enabled','disabled','deleted') NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `date_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) unsigned NOT NULL,
  `modified_by` int(11) unsigned NOT NULL,
  `merge_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
-- Table structure for table `user_license`
--

DROP TABLE IF EXISTS `user_license`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_license` (
  `id` int(11) unsigned NOT NULL,
  `rbac_user_id` int(11) unsigned NOT NULL COMMENT 'User ID. Define who has this license.',
  `country_code` varchar(3) NOT NULL COMMENT 'the code of the country.',
  `state_code` varchar(5) NOT NULL COMMENT 'Code of the state.',
  `type` varchar(100) NOT NULL COMMENT '????????',
  `number` varchar(50) NOT NULL COMMENT '????????',
  `date_issued` date NOT NULL DEFAULT '0000-00-00' COMMENT 'Date that the license has been issued to the user.',
  `date_expired` date NOT NULL DEFAULT '0000-00-00' COMMENT 'Date that the license will be expire.',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `merge_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`,`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_specialty`
--

DROP TABLE IF EXISTS `user_specialty`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_specialty` (
  `id` int(11) unsigned NOT NULL,
  `rbac_user_id` int(11) unsigned NOT NULL COMMENT 'User ID.',
  `specialty_id` int(11) unsigned NOT NULL COMMENT 'This is the Id of the specialty from specialty TABLE.',
  `experience` int(1) NOT NULL DEFAULT '1' COMMENT 'Years of experience in this speciality.',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
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

-- Dump completed on 2016-10-31  4:32:26
