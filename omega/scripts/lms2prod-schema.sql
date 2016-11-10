
DROP TABLE IF EXISTS `billing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `billing` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
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
) ENGINE=InnoDB AUTO_INCREMENT=34264 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `billing_cache`
--

DROP TABLE IF EXISTS `billing_cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `billing_cache` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `billing_cache` longtext CHARACTER SET utf8,
  `status` enum('enabled','disabled','archived','deleted') CHARACTER SET utf8 NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=598294 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `billing_discount_course`
--

DROP TABLE IF EXISTS `billing_discount_course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `billing_discount_course` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
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
) ENGINE=InnoDB AUTO_INCREMENT=749 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `billing_discount_course_entities`
--

DROP TABLE IF EXISTS `billing_discount_course_entities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `billing_discount_course_entities` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `billing_discount_course_id` int(11) unsigned NOT NULL,
  `additional_info` varchar(255) NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1262 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `billing_instances`
--

DROP TABLE IF EXISTS `billing_instances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `billing_instances` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `billing_invoice` text,
  `billing_invoice_items` text,
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=506852 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `billing_invoice_items`
--

DROP TABLE IF EXISTS `billing_invoice_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `billing_invoice_items` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
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
) ENGINE=InnoDB AUTO_INCREMENT=101935 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `billing_invoices`
--

DROP TABLE IF EXISTS `billing_invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `billing_invoices` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
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
) ENGINE=InnoDB AUTO_INCREMENT=52728 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL DEFAULT ' ' COMMENT 'Title for content quiz setting.',
  `lut_content_source_id` int(11) unsigned NOT NULL DEFAULT '0',
  `content_container_id` int(11) unsigned NOT NULL,
  `file_upload_id` int(11) unsigned DEFAULT NULL,
  `file_contains_test` enum('yes','no') DEFAULT NULL COMMENT 'marks if the file-scrom package allready contains a test'' AFTER `file_upload_id',
  `display_ordering` int(11) unsigned NOT NULL DEFAULT '1',
  `number_of_questions` int(11) unsigned NOT NULL DEFAULT '0',
  `randomize_question` enum('0','1') NOT NULL DEFAULT '1',
  `shuffle_question` enum('0','1') NOT NULL DEFAULT '1',
  `shuffle_answer` enum('0','1') NOT NULL DEFAULT '1',
  `passing_value` int(11) unsigned NOT NULL DEFAULT '80' COMMENT 'this is the passing score default to 80',
  `passing_type` enum('point','percentage') NOT NULL DEFAULT 'percentage',
  `submit_type` enum('question','quiz') NOT NULL DEFAULT 'question',
  `enable_time_limit` enum('0','1') NOT NULL DEFAULT '0',
  `time_limit_hour` tinyint(3) unsigned DEFAULT NULL,
  `time_limit_minute` tinyint(3) unsigned DEFAULT NULL,
  `time_limit_second` tinyint(3) unsigned DEFAULT NULL,
  `display_time_type` enum('remaining','elapsed') NOT NULL DEFAULT 'remaining',
  `display_cumulative_score` enum('0','1') NOT NULL DEFAULT '1',
  `display_question_weight` enum('0','1') NOT NULL DEFAULT '1',
  `allow_user_interruption` enum('0','1') NOT NULL DEFAULT '1',
  `default_question_weight` int(11) unsigned NOT NULL DEFAULT '1' COMMENT 'this is the default weight for quiz question default will be 2',
  `attempt_allow` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `allow_partial_answer` enum('0','1') NOT NULL DEFAULT '0',
  `provide_feedback` enum('0','1') NOT NULL DEFAULT '0',
  `display_feedback_icon` enum('0','1') NOT NULL DEFAULT '0',
  `display_feedback_score` enum('0','1') NOT NULL DEFAULT '0',
  `display_feedback_correct` text,
  `display_feedback_incorrect` text,
  `enable_quiz_review` enum('0','1') NOT NULL DEFAULT '0',
  `show_result` enum('0','1') NOT NULL DEFAULT '0',
  `show_correct` enum('0','1') NOT NULL DEFAULT '0',
  `display_user_score` enum('0','1') NOT NULL DEFAULT '0',
  `display_passing_score` enum('0','1') NOT NULL DEFAULT '0',
  `display_result_message` enum('0','1') NOT NULL DEFAULT '0' COMMENT 'should the pass/fail message display for the result',
  `introduction` text COMMENT 'Introduction for pretest or post test content',
  `display_message_pass` text,
  `display_message_fail` text,
  `has_objective` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'this is for reporting purposes. It''s to make so system can display objective in report. Currently only unity content should be save to yes.',
  `publish_needed` enum('0','1') NOT NULL DEFAULT '1' COMMENT 'This indicates that if this content needs to be published or not. if content_cotanier.content_cotanier_status=active it will be 0 otherwise it is 1.',
  `content_category` enum('pre-test','post-test','content','quiz','survey','updater') NOT NULL DEFAULT 'pre-test',
  `version` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `processing_type` enum('quiz','scorm','pdf','aicc','healthstream','simbionix','externalvideo','externallms','surveymonkey') NOT NULL DEFAULT 'scorm',
  `processing_status` enum('pending','success','failed') NOT NULL DEFAULT 'pending',
  `launcher_type` enum('scorm','pdf','aicc','healthstream','simbionix','externalvideo','externallms','unity','surveymonkey') NOT NULL DEFAULT 'scorm' COMMENT 'the type of launcher to use to launcher content. default will be scorm',
  `launcher_data` text COMMENT 'data related to the launcher type. for example course key, course password or aicc url',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`),
  KEY `file_upload_id` (`file_upload_id`),
  KEY `content_container_id` (`content_container_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14501 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_access`
--

DROP TABLE IF EXISTS `content_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_access` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
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
  PRIMARY KEY (`id`),
  UNIQUE KEY `cnt_acc_cnt_cntr_id_std_rbac_usr_id_u` (`content_container_id`,`student_rbac_user_id`),
  UNIQUE KEY `cnt_acc_cnt_cntr_id_org_edu_grp_id_u` (`content_container_id`,`organization_education_group_id`),
  UNIQUE KEY `cnt_acc_cnt_cntr_id_org_dep_id_u` (`content_container_id`,`organization_department_id`),
  UNIQUE KEY `cnt_acc_cnt_cntr_id_org_id_u` (`content_container_id`,`organization_id`),
  KEY `organization_id` (`organization_id`),
  KEY `organization_department_id` (`organization_department_id`),
  KEY `organization_education_group_id` (`organization_education_group_id`),
  KEY `student_rbac_user_id` (`student_rbac_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7087 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_aicc_au`

DROP TABLE IF EXISTS `content_container`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_container` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `organization_id` int(11) unsigned DEFAULT NULL,
  `file_upload_id` int(11) unsigned DEFAULT NULL,
  `rbac_user_id` int(11) unsigned NOT NULL,
  `name` varchar(255) NOT NULL DEFAULT ' ' COMMENT 'The name of the content container(shell)',
  `description` text COMMENT 'The description of content container (shell.)',
  `estimated_hour` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Estimated total hours of this content.',
  `estimated_minute` tinyint(3) unsigned NOT NULL DEFAULT '30' COMMENT 'Estimated total minuts of this content.',
  `estimated_second` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Estimated total seconds of this content.',
  `is_completed` enum('0','1') NOT NULL DEFAULT '0' COMMENT '????????',
  `content_container_status` enum('inactive','active','archived','review') NOT NULL DEFAULT 'inactive' COMMENT 'Status of the content container. It can be INACTIVE,  ACTIVE, ARCHIVED, and REVIEWD.',
  `delivery_type` enum('live','online') NOT NULL DEFAULT 'online',
  `expired_date` date NOT NULL DEFAULT '0000-00-00' COMMENT 'Expiration date of this content container.',
  `access_level` enum('public','private','reviewer','consortium','self') NOT NULL DEFAULT 'public' COMMENT 'Access level of this content container. It can be PUBLIC, PRIVATE, or REVIEWER.',
  `content_type` enum('education','quiz','survey','live_event','survey_template') NOT NULL DEFAULT 'education',
  `processing_status` enum('pending','success','failed') NOT NULL DEFAULT 'pending',
  `publish_error` tinytext COMMENT 'Errors from a publish attempt. When faculty tries to publish the content if the content or the container has any issue it will be saved here so it can be reviewed and fixed later by the creator.',
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
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `rbac_user_id` (`rbac_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15278 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_container_curriculum_routing`
--

DROP TABLE IF EXISTS `content_container_curriculum_routing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_container_curriculum_routing` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `dependant_content_container_id` int(11) unsigned NOT NULL,
  `dependant_content_id` int(11) unsigned DEFAULT NULL,
  `depend_upon_element_id` int(11) unsigned DEFAULT NULL COMMENT 'The element Id that decides what will happen in the dependable, how, is decided in the handler',
  `dependency_handler` varchar(255) NOT NULL COMMENT 'List of class to apply to the container, they host the logic on what goes',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`),
  KEY `dependant_content_container_id` (`dependant_content_container_id`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_enrollment`
--

DROP TABLE IF EXISTS `content_enrollment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_enrollment` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
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
) ENGINE=InnoDB AUTO_INCREMENT=9068723 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_objective`
--

DROP TABLE IF EXISTS `content_objective`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_objective` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `content_container_id` int(11) unsigned NOT NULL COMMENT 'ID of the content container.',
  `content_text` text NOT NULL COMMENT 'The objective of the content.',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8592 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_question`
--

DROP TABLE IF EXISTS `content_question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_question` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `lut_content_question_type_id` int(11) unsigned DEFAULT NULL,
  `content_id` int(11) unsigned DEFAULT NULL,
  `file_upload_id` int(11) unsigned DEFAULT NULL,
  `question_text` text NOT NULL COMMENT 'This is the acutal question.',
  `display_order` int(11) unsigned NOT NULL COMMENT 'showes the display order of the question. This will be used when ramdomized questioning is not in use.',
  `difficulty_level` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'This is containing the weight(level of difficulty) of the question.',
  `correct_feedback` text NOT NULL COMMENT 'This is the correct feedback which has to be showen on the screen in case of selection.',
  `wrong_feedback` varchar(255) NOT NULL COMMENT 'This is the wrong feedback which has to be showed on the screen in case of selection.',
  `score` int(5) DEFAULT NULL,
  `allow_partial_answer` enum('0','1') NOT NULL DEFAULT '0',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`),
  KEY `content_id` (`content_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14377 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_reviewer`
--

DROP TABLE IF EXISTS `content_reviewer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_reviewer` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `content_container_id` int(11) unsigned NOT NULL COMMENT 'ID of the content container.',
  `rbac_user_id` int(11) unsigned NOT NULL COMMENT '????? User ID of the reviewer of the content.',
  `reviewer_organization_id` int(11) NOT NULL COMMENT 'The reviewer organization.  To be used for sending email',
  `reviewer_status` enum('pending','reviewed','completed','archived') NOT NULL DEFAULT 'pending' COMMENT 'Status of reviewer.  PENDING; user first added as reviewer.  REVIEWED: used reviewed the content.  COMPLETED: when review process is done.  ARCHIVED: when reivew process is done and faculty add new reviewer.',
  `reviewer_comments` text COMMENT 'The comment of the content reviewer. ',
  `is_current` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'is this record the current reviewer for the content',
  `due_date` date DEFAULT NULL COMMENT 'when the user must complete the review by',
  `reviewed_date` datetime DEFAULT NULL COMMENT 'This is the review date of the reviewer',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`),
  KEY `rbac_user_id` (`rbac_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=524 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_scorm_sco`
--

DROP TABLE IF EXISTS `content_scorm_sco`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_scorm_sco` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `content_id` int(11) unsigned NOT NULL COMMENT 'Foreign Key of content table',
  `file_upload_id` int(11) unsigned NOT NULL COMMENT 'Foreign key of cron_file_uploaded table',
  `parent_identifier` varchar(100) DEFAULT NULL COMMENT 'Parent identifier from imsmanifest.xml file',
  `identifier` varchar(100) DEFAULT NULL COMMENT 'Child identifier from imsmanifest.xml file',
  `sco_href` text COMMENT 'Sco href from imsmanifest.xml file',
  `title` varchar(100) DEFAULT NULL COMMENT 'Sco title from imsmanifest.xml file',
  `version` int(11) unsigned NOT NULL DEFAULT '1',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT NULL,
  `modified_by` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20157 DEFAULT CHARSET=utf8 COMMENT='Store SCO details of scorm content';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_scorm_sco_log`
--

DROP TABLE IF EXISTS `content_scorm_sco_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_scorm_sco_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key of table',
  `enrollment_id` int(11) unsigned NOT NULL COMMENT 'Contains Content enrollment id',
  `rbac_user_id` int(11) unsigned NOT NULL COMMENT 'Contains User id',
  `content_id` int(11) unsigned NOT NULL COMMENT 'Contains Content id from Content table',
  `content_scorm_sco_id` int(11) unsigned DEFAULT NULL COMMENT 'Primary key of content_scorm_sco',
  `user_model` text COMMENT 'Contains user model data sent by the scorm course',
  `suspend_data` text COMMENT 'Contains suspend data sent by scorm course',
  `lesson_status` enum('passed','completed','failed','incomplete','browsed','not attempted') NOT NULL DEFAULT 'incomplete' COMMENT 'Contains lesson_status from scorm course user model',
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
  PRIMARY KEY (`id`),
  KEY `enrollment_id` (`enrollment_id`),
  KEY `rbac_user_id` (`rbac_user_id`),
  KEY `content_id` (`content_id`),
  KEY `content_scorm_sco_id` (`content_scorm_sco_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5244022 DEFAULT CHARSET=utf8 COMMENT='Contains log of AU ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_topic`
--

DROP TABLE IF EXISTS `content_topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_topic` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `content_container_id` int(11) unsigned NOT NULL COMMENT 'ID of content container or content shell.',
  `content_text` text NOT NULL COMMENT 'Content topic.',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_transcript`
--

DROP TABLE IF EXISTS `content_transcript`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_transcript` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `transcript_group_id` bigint(11) unsigned NOT NULL COMMENT 'This value is created by the content viewer. Its a combination of timestamps and user id.',
  `content_transcript_log_id` int(11) unsigned NOT NULL,
  `content_source_type` enum('survey','content') NOT NULL DEFAULT 'content',
  `rbac_user_id` int(11) unsigned NOT NULL,
  `enrollment_id` int(11) unsigned NOT NULL,
  `content_id` int(11) unsigned NOT NULL,
  `sub_content_id` int(11) unsigned DEFAULT NULL COMMENT 'this id correspond to content_scorm_sco.id or content_aicc_au.id',
  `content_container_id` int(11) unsigned NOT NULL,
  `course_id` int(11) unsigned DEFAULT NULL,
  `course_task_id` int(11) unsigned DEFAULT NULL,
  `course_content_id` int(11) unsigned DEFAULT NULL,
  `content_passing_score` int(11) unsigned NOT NULL DEFAULT '0',
  `raw_score` smallint(6) NOT NULL DEFAULT '0',
  `final_status` enum('incomplete','complete','fail','pass') NOT NULL DEFAULT 'incomplete',
  `time_spent` mediumint(9) NOT NULL DEFAULT '0',
  `final_score` int(3) unsigned NOT NULL DEFAULT '0',
  `final_time` int(11) unsigned NOT NULL DEFAULT '0',
  `version` int(3) unsigned NOT NULL,
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`),
  KEY `rbac_user_id` (`rbac_user_id`),
  KEY `enrollment_id` (`enrollment_id`),
  KEY `content_id` (`content_id`),
  KEY `content_container_id` (`content_container_id`),
  KEY `transcript_group_id` (`transcript_group_id`),
  KEY `sub_content_id` (`sub_content_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9713179 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_transcript_interaction`
--

DROP TABLE IF EXISTS `content_transcript_interaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_transcript_interaction` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `content_transcript_id` int(11) unsigned NOT NULL,
  `interaction_order` int(11) unsigned NOT NULL,
  `content_scorm_sco_id` int(11) unsigned DEFAULT NULL COMMENT 'Primary key of content_scorm_sco',
  `source` varchar(255) NOT NULL COMMENT 'Source Id set by the content',
  `time` varchar(20) DEFAULT NULL,
  `type` varchar(50) NOT NULL,
  `weight` int(10) unsigned NOT NULL DEFAULT '0',
  `result` enum('survey','correct','wrong') NOT NULL DEFAULT 'survey',
  `latency` varchar(200) NOT NULL DEFAULT '',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`),
  KEY `content_transcript_id` (`content_transcript_id`),
  KEY `source` (`source`)
) ENGINE=MyISAM AUTO_INCREMENT=44660676 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_transcript_interaction_response`
--

DROP TABLE IF EXISTS `content_transcript_interaction_response`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_transcript_interaction_response` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `content_transcript_interaction_id` int(11) unsigned NOT NULL,
  `row_id` int(11) unsigned NOT NULL DEFAULT '0',
  `column_id` int(11) unsigned NOT NULL DEFAULT '0',
  `correct_response` varchar(255) DEFAULT NULL,
  `response` varchar(255) DEFAULT NULL,
  `response_text` text,
  `result` varchar(50) DEFAULT NULL,
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`),
  KEY `content_transcript_interaction_id` (`content_transcript_interaction_id`),
  KEY `row_id` (`row_id`),
  KEY `column_id` (`column_id`)
) ENGINE=InnoDB AUTO_INCREMENT=49074785 DEFAULT CHARSET=utf8;
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
  PRIMARY KEY (`id`),
  KEY `date_created` (`date_created`),
  KEY `date_created_2` (`date_created`)
) ENGINE=InnoDB AUTO_INCREMENT=58899945 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_transcript_objective`
--

DROP TABLE IF EXISTS `content_transcript_objective`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_transcript_objective` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `content_transcript_id` int(11) unsigned NOT NULL COMMENT 'foreign to the content transcript table',
  `content_scorm_sco_id` int(11) unsigned NOT NULL COMMENT 'Primary key of content_scorm_sco',
  `objective_order` int(11) unsigned NOT NULL COMMENT 'The order the objective was set by contnet',
  `source` varchar(255) NOT NULL COMMENT 'Source Id set by the content',
  `score_max` int(3) unsigned NOT NULL COMMENT 'the maximun score for obj set by content',
  `score_min` int(3) unsigned NOT NULL COMMENT 'the minumun score for obj set by content',
  `score_raw` int(3) unsigned NOT NULL COMMENT 'the actual score for obj set by content',
  `objective_status` enum('complete','incomplete') NOT NULL DEFAULT 'incomplete' COMMENT 'the status of the object set by content',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=234086 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course`
--

DROP TABLE IF EXISTS `course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key and identifier for each record',
  `organization_id` int(11) unsigned NOT NULL COMMENT 'Org that the course belongs to',
  `owner_rbac_user_id` int(11) unsigned NOT NULL COMMENT 'Id of the activity director',
  `file_upload_id` int(11) unsigned DEFAULT NULL COMMENT 'promo material upload ID',
  `title` varchar(255) NOT NULL COMMENT 'title of the course',
  `description` text COMMENT 'description of the course',
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
  `has_online_content` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'whether this course includes online content',
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
) ENGINE=InnoDB AUTO_INCREMENT=20889 DEFAULT CHARSET=utf8;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`sitelrelease`@`172.24.10.137`*/ /*!50003 TRIGGER `course_au` AFTER UPDATE ON `course` FOR EACH ROW 
BEGIN 
	 IF OLD.expiration_date <> NEW.expiration_date THEN
	 	CALL update_auto_enroll_end_date(NEW.`id`, NEW.expiration_date);
	 END IF;
	 
	 IF OLD.publish_status <> NEW.publish_status AND NEW.publish_status = 'Expire' THEN
		 CALL expire_auto_enroll(NEW.`id`);
	 END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `course_access`
--

DROP TABLE IF EXISTS `course_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_access` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `course_id` int(11) unsigned NOT NULL,
  `organization_id` int(11) unsigned DEFAULT NULL,
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `crs_acc_crs_id_org_id_u` (`course_id`,`organization_id`),
  KEY `organization_id` (`organization_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21363 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_assessment`
--

DROP TABLE IF EXISTS `course_assessment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_assessment` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
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
) ENGINE=InnoDB AUTO_INCREMENT=6013 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_auto_enrollment`
--

DROP TABLE IF EXISTS `course_auto_enrollment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_auto_enrollment` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
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
  PRIMARY KEY (`id`),
  KEY `organization_id` (`organization_id`),
  KEY `organization_department_id` (`organization_department_id`),
  KEY `organization_education_group_id` (`organization_education_group_id`),
  KEY `course_id` (`course_id`),
  KEY `course_enrollment_invoice_id` (`course_enrollment_settings_id`),
  KEY `student_rbac_user_id` (`student_rbac_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=631135 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_barrier`
--

DROP TABLE IF EXISTS `course_barrier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_barrier` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `course_id` int(11) unsigned NOT NULL,
  `barrier_text` text NOT NULL,
  `strategy` varchar(50) NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_certificate`
--

DROP TABLE IF EXISTS `course_certificate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_certificate` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
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
) ENGINE=InnoDB AUTO_INCREMENT=317 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_contact`
--

DROP TABLE IF EXISTS `course_contact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_contact` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `course_id` int(11) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `address` text NOT NULL,
  `fax` varchar(30) NOT NULL,
  `phone` varchar(30) NOT NULL,
  `email` varchar(100) NOT NULL,
  `has_funding` enum('0','1') NOT NULL DEFAULT '0',
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
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `course_id` int(11) unsigned NOT NULL COMMENT 'The course that the content is attached to',
  `content_container_id` int(11) unsigned NOT NULL COMMENT 'The content that is attached to the course',
  `pre_session_course_content_id` int(11) unsigned DEFAULT NULL COMMENT 'course content that must be complete before this live content - LIVE content ONLY',
  `passing_score` tinyint(3) unsigned NOT NULL DEFAULT '80' COMMENT 'passing score for the content on this course only',
  `show_score` enum('Yes','No') NOT NULL DEFAULT 'No' COMMENT 'whether to display to cummulative score',
  `number_of_attempts` smallint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Number of attempts the user an make to complete the content on this course',
  `content_type` enum('Pretest','Content','Pre Event Content','Live Content','Return Demo','Post Event Content','Post Test','Evaluation','Post Evaluation') DEFAULT NULL COMMENT 'Where the content is on this course',
  `when_do` enum('immediate','later') NOT NULL DEFAULT 'immediate' COMMENT 'whether to wait a period before allowing user to take this content',
  `valid_after` tinyint(3) unsigned DEFAULT NULL COMMENT 'after how long should this content be taken',
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
) ENGINE=InnoDB AUTO_INCREMENT=45097 DEFAULT CHARSET=utf8 COMMENT='course create->curriculum->settings';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_content_access`
--

DROP TABLE IF EXISTS `course_content_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_content_access` (
  `course_id` int(11) unsigned NOT NULL,
  `course_wrapper_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`course_id`,`course_wrapper_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_content_settings`
--

DROP TABLE IF EXISTS `course_content_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_content_settings` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
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
) ENGINE=InnoDB AUTO_INCREMENT=8955 DEFAULT CHARSET=utf8 COMMENT='course create->curriculum->settings';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_email`
--

DROP TABLE IF EXISTS `course_email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_email` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` int(11) NOT NULL,
  `subject` varchar(255) NOT NULL COMMENT 'subject of the email',
  `body` text NOT NULL COMMENT 'body of the email',
  `delay_send_day` tinyint(4) NOT NULL COMMENT 'only applies to only live courses.  How many days before the event should this email be sent',
  `send_to_group_id` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'NOTES - This should not a course group',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_enrollment`
--

DROP TABLE IF EXISTS `course_enrollment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_enrollment` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `course_enrollment_settings_id` int(11) unsigned NOT NULL,
  `course_id` int(11) unsigned NOT NULL,
  `student_rbac_user_id` int(11) unsigned NOT NULL,
  `organization_id` int(11) unsigned NOT NULL,
  `type` enum('self','group','department','organization') NOT NULL,
  `enrolled_by_role` int(11) NOT NULL COMMENT 'shows under what role the registrer was at the time of role out',
  `previous_action` enum('create_new','expire_old','use_old') NOT NULL COMMENT 'the action taken when this record was created',
  `previously_updated_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'the id of the record that was modified',
  `allow_previous` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Does enrollment allow previous score',
  `start_accept_score` datetime DEFAULT NULL COMMENT 'This is when scores start being accepted',
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
  KEY `student_rbac_user_id` (`student_rbac_user_id`),
  KEY `due_date` (`due_date`)
) ENGINE=InnoDB AUTO_INCREMENT=2193723 DEFAULT CHARSET=utf8;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`lmsuser`@`172.24.10.137`*/ /*!50003 TRIGGER `course_enrollment_ad` AFTER DELETE ON `course_enrollment` FOR EACH ROW 
BEGIN 
	DELETE FROM lms2prod.cron_event_tasks
	WHERE record_json LIKE CONCAT('%"course_enrollment_id":"',OLD.id,'"%');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `course_enrollment_comments`
--

DROP TABLE IF EXISTS `course_enrollment_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_enrollment_comments` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `course_enrollment_id` int(11) unsigned NOT NULL,
  `comment` text,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_rbac_user_id` int(11) unsigned NOT NULL COMMENT 'User who generated the comment',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) unsigned NOT NULL,
  `modified_by` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1933 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_enrollment_credit_claimed`
--

DROP TABLE IF EXISTS `course_enrollment_credit_claimed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_enrollment_credit_claimed` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `course_enrollment_id` int(11) unsigned NOT NULL,
  `course_certificate_id` int(11) unsigned NOT NULL,
  `credit_claimed` decimal(4,2) unsigned NOT NULL DEFAULT '0.00' COMMENT 'how many credit were claimed by the user',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `crs_enl_credit_claimed_crs_enl_id_crs_cert_id_u` (`course_enrollment_id`,`course_certificate_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3518 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_enrollment_day`
--

DROP TABLE IF EXISTS `course_enrollment_day`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_enrollment_day` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
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
) ENGINE=InnoDB AUTO_INCREMENT=370800 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_enrollment_event`
--

DROP TABLE IF EXISTS `course_enrollment_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_enrollment_event` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `course_enrollment_id` int(11) unsigned NOT NULL,
  `event_repeat_group_id` int(11) unsigned NOT NULL,
  `student_rbac_user_id` int(11) unsigned NOT NULL,
  `is_attended` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'did user attended the event. if user attended any day for the event than event should be marked to attended',
  `status` enum('enabled','disabled','deleted') NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) NOT NULL,
  `modified_by` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `course_enrollment_id` (`course_enrollment_id`),
  KEY `event_repeat_group_id` (`event_repeat_group_id`),
  KEY `student_rbac_user_id` (`student_rbac_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=275419 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_enrollment_fields`
--

DROP TABLE IF EXISTS `course_enrollment_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_enrollment_fields` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `course_id` int(11) unsigned NOT NULL,
  `field_name` varchar(255) NOT NULL,
  `field_description` varchar(255) NOT NULL,
  `field_data_type` enum('text','numeric','date') NOT NULL DEFAULT 'text',
  `lut_course_enrollment_field_id` int(11) unsigned NOT NULL,
  `display` tinyint(1) NOT NULL,
  `mandatory` tinyint(1) NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_enrollment_instances`
--

DROP TABLE IF EXISTS `course_enrollment_instances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_enrollment_instances` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `course_id` int(11) unsigned DEFAULT NULL,
  `course_enroll_group` varchar(100) DEFAULT NULL,
  `course_enroll_billing` int(11) unsigned DEFAULT NULL COMMENT 'Foreign Key to billing_instance session table naming different due to internal code naming',
  `course_billing_invoice_id` int(11) unsigned DEFAULT NULL,
  `course_enroll_group_info` text,
  `course_enroll_event` text,
  `course_enroll_skip` text,
  `course_enroll_remove_ids` mediumtext,
  `course_enroll_price` int(11) unsigned DEFAULT NULL COMMENT 'Foreign Key to billing_cache session table naming different due to internal code naming',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3455423 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_enrollment_rollout`
--

DROP TABLE IF EXISTS `course_enrollment_rollout`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_enrollment_rollout` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
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
) ENGINE=InnoDB AUTO_INCREMENT=381343 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_enrollment_rollout_status`
--

DROP TABLE IF EXISTS `course_enrollment_rollout_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_enrollment_rollout_status` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned NOT NULL,
  `organization_id` int(11) unsigned NOT NULL,
  `course_id` int(11) unsigned DEFAULT NULL,
  `storage_id` int(11) unsigned DEFAULT NULL,
  `settings_id` int(11) unsigned DEFAULT NULL,
  `type` enum('new','edit','paid','clean_up') DEFAULT NULL COMMENT 'Type of Rollout action to be performed',
  `rollout_status` enum('in_progress','success','failure','waiting') DEFAULT NULL,
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2133 DEFAULT CHARSET=utf8;
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
) ENGINE=InnoDB AUTO_INCREMENT=511828 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_enrollment_topic`
--

DROP TABLE IF EXISTS `course_enrollment_topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_enrollment_topic` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
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
) ENGINE=InnoDB AUTO_INCREMENT=400607 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_objective`
--

DROP TABLE IF EXISTS `course_objective`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_objective` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `course_id` int(11) unsigned NOT NULL,
  `objective_text` text NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`),
  KEY `course_id` (`course_id`)
) ENGINE=InnoDB AUTO_INCREMENT=56312 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_prerequisite`
--

DROP TABLE IF EXISTS `course_prerequisite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_prerequisite` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `course_id` int(11) unsigned NOT NULL,
  `prereq_course_id` int(11) unsigned DEFAULT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_reference`
--

DROP TABLE IF EXISTS `course_reference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_reference` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
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
) ENGINE=InnoDB AUTO_INCREMENT=6076 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_return_demo_tmp`
--

DROP TABLE IF EXISTS `course_return_demo_tmp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_return_demo_tmp` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
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
) ENGINE=InnoDB AUTO_INCREMENT=259 DEFAULT CHARSET=utf8 COMMENT='course create->curriculum->settings';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_role`
--

DROP TABLE IF EXISTS `course_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_role` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
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
) ENGINE=InnoDB AUTO_INCREMENT=30286 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_saved`
--

DROP TABLE IF EXISTS `course_saved`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_saved` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `course_id` int(11) unsigned NOT NULL,
  `rbac_user_id` int(11) unsigned NOT NULL,
  `organization_id` int(11) unsigned NOT NULL,
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `date_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) unsigned NOT NULL,
  `modified_by` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=139268 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_sponsors`
--

DROP TABLE IF EXISTS `course_sponsors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_sponsors` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_tag`
--

DROP TABLE IF EXISTS `course_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_tag` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `course_id` int(11) unsigned NOT NULL,
  `target_id` int(11) unsigned NOT NULL,
  `target_type` varchar(100) NOT NULL,
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
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
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
) ENGINE=InnoDB AUTO_INCREMENT=168429 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_task`
--

DROP TABLE IF EXISTS `course_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_task` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `course_id` int(11) unsigned NOT NULL COMMENT 'The course this task belongs to',
  `task_name` varchar(255) NOT NULL COMMENT 'The name of the task',
  `number_content_complete` int(3) unsigned NOT NULL COMMENT 'the number of content that needs to be complete to pass this task',
  `task_order` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'the position of the task in the curriculum',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`),
  KEY `course_id` (`course_id`)
) ENGINE=InnoDB AUTO_INCREMENT=30553 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_task_content`
--

DROP TABLE IF EXISTS `course_task_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_task_content` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `course_task_id` int(11) unsigned NOT NULL,
  `course_content_id` int(11) unsigned NOT NULL,
  `is_mandatory` enum('0','1') NOT NULL DEFAULT '0' COMMENT 'This indicates whether the content must be completed to pass the task',
  `rec_order` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`),
  KEY `course_task_id` (`course_task_id`),
  KEY `course_content_id` (`course_content_id`)
) ENGINE=InnoDB AUTO_INCREMENT=44669 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cron`
--

DROP TABLE IF EXISTS `cron`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cron` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `description` text NOT NULL,
  `command` varchar(128) NOT NULL,
  `is_locking` tinyint(1) NOT NULL COMMENT 'A locking cron will not run with other crons.',
  `is_standalone` tinyint(1) NOT NULL COMMENT 'Does this command needs a wrapper to load LMS library or not',
  `depends_on_job_id` int(10) unsigned DEFAULT NULL,
  `start_time` datetime NOT NULL,
  `interval_seconds` int(12) unsigned NOT NULL,
  `last_run` datetime NOT NULL,
  `hour_of_day` tinyint(4) NOT NULL COMMENT '24 hours day Meta data to capture the hour of day this query needs to be run at. Will be used when the script try to fix itself',
  `minutes` tinyint(4) NOT NULL DEFAULT '0',
  `last_status` enum('OK','FAIL','RUNNING','RESCHEDULE','WAITING','STOPPED') NOT NULL,
  `last_status_message` varchar(255) NOT NULL,
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cron_event_tasks`
--

DROP TABLE IF EXISTS `cron_event_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cron_event_tasks` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `class` varchar(50) NOT NULL COMMENT 'php class to call to perform task',
  `record_json` varchar(200) DEFAULT NULL COMMENT 'record to have task performed on based on class',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=464694 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cron_file_copy`
--

DROP TABLE IF EXISTS `cron_file_copy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cron_file_copy` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `source` varchar(255) NOT NULL,
  `destination` varchar(255) NOT NULL,
  `move_status` enum('pending','processing','fail','success','retry') NOT NULL DEFAULT 'pending',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cron_file_uploaded`
--

DROP TABLE IF EXISTS `cron_file_uploaded`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cron_file_uploaded` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `rbac_user_id` int(11) unsigned DEFAULT NULL,
  `file_name` varchar(255) NOT NULL DEFAULT '' COMMENT 'The name of the uploaded file.',
  `file_size` int(11) unsigned NOT NULL COMMENT 'The size of the uploaded file.',
  `file_type` varchar(40) NOT NULL COMMENT 'The extension of the uploaded file.',
  `file_extension` varchar(10) NOT NULL,
  `file_thumbnail` varchar(255) NOT NULL DEFAULT '' COMMENT 'The name of the thumbnail\nof the uploaded file.',
  `xml_type` enum('image','audio','video','document') NOT NULL DEFAULT 'image',
  `version` varchar(255) NOT NULL DEFAULT ' ' COMMENT 'The version for this uploaded file.',
  `destination` varchar(255) NOT NULL COMMENT '????????',
  `process_type` varchar(255) NOT NULL DEFAULT '' COMMENT '???????????',
  `file_status` enum('pending','processing','failed','success') NOT NULL DEFAULT 'pending' COMMENT '????????',
  `process_status` enum('pending','processing','failed','success') NOT NULL DEFAULT 'pending' COMMENT '????????',
  `last_status_message` varchar(100) NOT NULL DEFAULT ' ',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8729 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cron_materialized_viewTOBEDELETED216`
--

DROP TABLE IF EXISTS `cron_materialized_viewTOBEDELETED216`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cron_materialized_viewTOBEDELETED216` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `class_name` varchar(50) NOT NULL COMMENT 'class name for materized view model',
  `params_hash` char(32) NOT NULL,
  `params` text NOT NULL,
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cron_mat_vw_cls_name_params_has_u` (`class_name`,`params_hash`)
) ENGINE=InnoDB AUTO_INCREMENT=10290072 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `email`
--

DROP TABLE IF EXISTS `email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `urgency_level` smallint(6) NOT NULL DEFAULT '1' COMMENT 'The lower the number, the more urgent is this email',
  `subject` varchar(255) NOT NULL COMMENT 'subject of the email',
  `body` text NOT NULL COMMENT 'body of the email',
  `from_id` int(11) NOT NULL COMMENT 'who send the request',
  `to_id` int(11) NOT NULL COMMENT 'who receives the request',
  `user_files_id` int(11) unsigned DEFAULT NULL COMMENT 'The ids of files attached to emails',
  `send_status` enum('pending','processing','sent','fail','fail_processed') NOT NULL DEFAULT 'pending' COMMENT 'Status of the sent email. fail processed is faild and dev took care of it',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`),
  KEY `urgency_level` (`urgency_level`)
) ENGINE=InnoDB AUTO_INCREMENT=3462503 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `error_monitoring`
--

DROP TABLE IF EXISTS `error_monitoring`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `error_monitoring` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `severity` tinyint(4) unsigned DEFAULT NULL,
  `exception_message` text NOT NULL,
  `exception_trace` text NOT NULL,
  `request` mediumtext NOT NULL,
  `session` mediumtext NOT NULL,
  `server` text NOT NULL,
  `queries` text NOT NULL,
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=87678 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `event`
--

DROP TABLE IF EXISTS `event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `course_id` int(11) unsigned NOT NULL,
  `consecutive_days` enum('Yes','No') NOT NULL DEFAULT 'Yes',
  `number_of_days` smallint(6) NOT NULL,
  `skip_weekend` enum('dont Skip','Move to Friday','Move To Monday','Delete') NOT NULL DEFAULT 'dont Skip',
  `start_end_equal` enum('Yes','No') DEFAULT 'Yes' COMMENT 'Means equal times for all the event days.',
  `repeat_type` enum('Does not repeat','Daily','Weekly','Monthly-Dates','Monthly-Days','Yearly') DEFAULT 'Does not repeat',
  `repeat_cycle_type` tinyint(3) unsigned NOT NULL,
  `repeat_days` tinyint(3) unsigned NOT NULL,
  `repeat_end_date` date DEFAULT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1060 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `event_dates`
--

DROP TABLE IF EXISTS `event_dates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event_dates` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `course_id` int(11) unsigned NOT NULL,
  `location_id` int(11) unsigned NOT NULL DEFAULT '0',
  `location_comment` text,
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
  PRIMARY KEY (`id`),
  KEY `course_id` (`course_id`,`event_repeat_group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=40689 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `event_dates_topics`
--

DROP TABLE IF EXISTS `event_dates_topics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event_dates_topics` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `course_id` int(11) unsigned NOT NULL,
  `event_date_id` int(11) unsigned NOT NULL,
  `content_container_id` int(11) unsigned NOT NULL,
  `location_id` int(11) unsigned DEFAULT NULL,
  `cne_number` varchar(50) DEFAULT NULL,
  `min_registration` smallint(5) unsigned NOT NULL DEFAULT '1',
  `max_registration` smallint(5) unsigned NOT NULL DEFAULT '1',
  `location_room` varchar(100) DEFAULT NULL,
  `registration_status` enum('open','close') NOT NULL DEFAULT 'open',
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `recording_metadata` text,
  `recording_url` text COMMENT 'This is what identifies the movie on cast tv servers',
  `recording2_url` text,
  `recording3_url` text,
  `machine_type` varchar(10) DEFAULT NULL,
  `machine_log` mediumtext,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`),
  KEY `event_date_id` (`event_date_id`)
) ENGINE=InnoDB AUTO_INCREMENT=42899 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `event_dates_topics_rbac_user`
--

DROP TABLE IF EXISTS `event_dates_topics_rbac_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event_dates_topics_rbac_user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `event_dates_topics_id` int(11) unsigned NOT NULL COMMENT 'This is PK to event_dates_topics Table.',
  `faculty_rbac_user_id` int(11) unsigned NOT NULL COMMENT 'This is PK to rbac_user Table.',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`),
  KEY `event_dates_topics_id` (`event_dates_topics_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19996 DEFAULT CHARSET=utf8;
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
  `min_registration` smallint(5) unsigned NOT NULL DEFAULT '1',
  `max_registration` smallint(5) unsigned NOT NULL DEFAULT '1',
  `registration_status` enum('open','close') NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `event_rpt_crs_id_event_rpt_grp_id_u` (`course_id`,`event_repeat_group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=81745 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `location`
--

DROP TABLE IF EXISTS `location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `location` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `organization_id` int(11) unsigned NOT NULL,
  `location_name` char(200) NOT NULL COMMENT 'The name of the location that address is pointing at.',
  `address1` char(200) NOT NULL,
  `address2` char(200) NOT NULL,
  `city` char(100) NOT NULL,
  `state` char(20) NOT NULL,
  `zip` char(20) NOT NULL COMMENT 'Location''s zip code',
  `country` char(3) NOT NULL,
  `room_number` varchar(10) NOT NULL COMMENT 'Location''s room number',
  `google_map_link` varchar(255) NOT NULL COMMENT 'Google map link to the location of this address.',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `location_favorite`
--

DROP TABLE IF EXISTS `location_favorite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `location_favorite` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `location_id` int(11) unsigned NOT NULL COMMENT 'This is a PK to Location Table and it holds the ID of the location.',
  `rbac_user_id` int(11) unsigned NOT NULL COMMENT 'This is a PK to RBAC_USER Table and will hold the ID of the creator of this location.',
  `organization_id` int(11) unsigned NOT NULL COMMENT 'This field will FK to the Organization table and will relates this record to the spesific organization.',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COMMENT='This table will link locations to organizations & users';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lock_queue`
--

DROP TABLE IF EXISTS `lock_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lock_queue` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `lock_status` enum('Ready','in_progress','waiting') NOT NULL,
  `dbg` varchar(255) NOT NULL COMMENT 'debug info, put what u want',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8 COMMENT='manage queue for different process so they do not collide with each other';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `logistics_building`
--

DROP TABLE IF EXISTS `logistics_building`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logistics_building` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `organization_id` int(11) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `comments` text NOT NULL,
  `address` text NOT NULL,
  `city` varchar(64) NOT NULL,
  `state` varchar(10) NOT NULL,
  `postal` varchar(24) NOT NULL,
  `country` varchar(24) NOT NULL,
  `phone` varchar(24) NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `logistics_room`
--

DROP TABLE IF EXISTS `logistics_room`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logistics_room` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
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
  PRIMARY KEY (`id`),
  FULLTEXT KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=5842 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lut_association`
--

DROP TABLE IF EXISTS `lut_association`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lut_association` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'PK of lut_association.',
  `lut_organization_type_id` int(11) DEFAULT NULL,
  `association_name` varchar(255) NOT NULL COMMENT 'Name of the association. It can be changed. in order to delete that from the system you need only disable it and it won''t be counted.',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=786 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='All possible organization associations in the system. ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lut_content_question_type`
--

DROP TABLE IF EXISTS `lut_content_question_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lut_content_question_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `content_question_type_name` varchar(255) NOT NULL COMMENT 'The name of the type of question in the content',
  `xml_code` varchar(50) NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lut_content_source`
--

DROP TABLE IF EXISTS `lut_content_source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lut_content_source` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL COMMENT 'The source title of the content.',
  `description` text NOT NULL COMMENT 'Discription of the content.',
  `name_key` varchar(30) NOT NULL COMMENT 'This is the commercial name or actual name the content source has.',
  `is_scorm` enum('0','1') NOT NULL DEFAULT '0' COMMENT '????????',
  `display` enum('0','1') NOT NULL DEFAULT '1' COMMENT 'Should the content be displayed or not.',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lut_contract_type`
--

DROP TABLE IF EXISTS `lut_contract_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lut_contract_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `rbac_tool_ids` varchar(255) DEFAULT NULL,
  `contract_name` varchar(255) NOT NULL COMMENT 'Name of the contract',
  `contract_max_users` int(11) unsigned DEFAULT NULL COMMENT 'number of the users who are allowed in this type of contract',
  `contract_max_courses` int(11) unsigned DEFAULT NULL COMMENT 'Number of the courses who are allowed in this type of contract',
  `contract_sponsor` enum('0','1') NOT NULL DEFAULT '1' COMMENT 'Contract_Sponsor to hold the information on sponsor in the home page (Flag)',
  `contract_outreach` smallint(6) NOT NULL DEFAULT '1' COMMENT 'Contract_Outreach holds the number of allawed outreach cordinators in an organization.',
  `contract_help_desk` enum('0','1') NOT NULL DEFAULT '1' COMMENT 'Contract_Help_desk to hold the information on displaying helpdesk information(Flag)',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of this record',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lut_course_content_type`
--

DROP TABLE IF EXISTS `lut_course_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lut_course_content_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `content_text` varchar(255) NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lut_course_enrollment_fields`
--

DROP TABLE IF EXISTS `lut_course_enrollment_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lut_course_enrollment_fields` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `display_name` varchar(255) NOT NULL,
  `field_table` varchar(255) NOT NULL,
  `field` varchar(255) NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lut_education`
--

DROP TABLE IF EXISTS `lut_education`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lut_education` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `education_name` varchar(255) NOT NULL COMMENT 'Type of education (degree.)',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lut_enrollment_option`
--

DROP TABLE IF EXISTS `lut_enrollment_option`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lut_enrollment_option` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `enrollment_option` enum('employee','employee-custom','contractor','contractor-custom') NOT NULL DEFAULT 'employee' COMMENT 'Type of the employement in the organization EMPLOYEE, EMPLOYEE-CUSTOM ,CONTRACTOR, CONTRACTOR-CUSTOM',
  `label` varchar(48) DEFAULT NULL COMMENT 'If customer wants to give a different name (lable) to this fields they can define it here.',
  `field_name` varchar(50) NOT NULL COMMENT 'Fields name of this enrollment option.',
  `data_type` varchar(65) DEFAULT NULL COMMENT 'Data type of the field.',
  `lookup_table` varchar(65) DEFAULT NULL COMMENT 'Stores the name of the table that this field is referring to.',
  `lookup_field` varchar(65) DEFAULT NULL COMMENT 'Stores the field name that data should be retrieved from.',
  `lookup_field_value` varchar(255) DEFAULT NULL COMMENT '???Defines the value that field will be retrieved.',
  `lookup_criteria` varchar(16) DEFAULT NULL COMMENT '????????',
  `display_during_enrollment` enum('0','1') DEFAULT '1' COMMENT 'If this should be showed during enrollment.',
  `is_required` enum('0','1') DEFAULT '0' COMMENT 'If this is required during enrollment and it should be filled out.',
  `language` varchar(2) DEFAULT 'EN' COMMENT 'Language of the field.',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lut_institute`
--

DROP TABLE IF EXISTS `lut_institute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lut_institute` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `lut_organization_type_id` int(11) DEFAULT NULL,
  `institute_name` varchar(255) NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lut_language`
--

DROP TABLE IF EXISTS `lut_language`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lut_language` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID key',
  `code` varchar(2) NOT NULL COMMENT '2 code letter complay with 639-1 laguage coding',
  `language` varchar(255) NOT NULL COMMENT 'Language name complay with 639-1 laguage coding',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `lut_lng_code_u` (`code`)
) ENGINE=MyISAM AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lut_organization_type`
--

DROP TABLE IF EXISTS `lut_organization_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lut_organization_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `organization_type` varchar(255) NOT NULL COMMENT 'Type of organization that LMS will provide and determine. This gets used in the creation of organization so, organizations can be seperated based on type for future use.',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of this record',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lut_position`
--

DROP TABLE IF EXISTS `lut_position`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lut_position` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `lut_organization_type_id` int(11) unsigned NOT NULL,
  `name` varchar(255) DEFAULT NULL COMMENT 'Title of the poistions in the system. They all get defined here for future can be used during registration.',
  `description` varchar(255) DEFAULT NULL COMMENT 'Position''s description.',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=300 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lut_predefine_data_field`
--

DROP TABLE IF EXISTS `lut_predefine_data_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lut_predefine_data_field` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `display_name` varchar(100) NOT NULL COMMENT 'this is the name that will display on the screen',
  `key_name` varchar(100) NOT NULL,
  `method_name` varchar(100) NOT NULL COMMENT 'call the method inside the predefine data class',
  `id_name` varchar(100) NOT NULL COMMENT 'Field id name to get this value from the table. This is the id name developer should use when it uses the certificate Generation process. Id name should be same through all so we needed to store them at one place. But Still open for discussion.... ',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `lut_prdf_data_fld_method_name_u` (`method_name`),
  UNIQUE KEY `lut_prdf_data_fld_key_name_u` (`key_name`)
) ENGINE=MyISAM AUTO_INCREMENT=66 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lut_predefine_data_source`
--

DROP TABLE IF EXISTS `lut_predefine_data_source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lut_predefine_data_source` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `predefine_data_field_id` int(11) unsigned NOT NULL COMMENT 'forgeign key to the predefine data field table',
  `source` varchar(30) NOT NULL COMMENT 'which module use the predefine data',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `lut_prdf_data_src_prdf_data_fld_id_src_u` (`predefine_data_field_id`,`source`)
) ENGINE=MyISAM AUTO_INCREMENT=65 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lut_security_question`
--

DROP TABLE IF EXISTS `lut_security_question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lut_security_question` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `question_text` varchar(255) NOT NULL COMMENT 'During registration one fo the options will be security question which will be define here.',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lut_specialities`
--

DROP TABLE IF EXISTS `lut_specialities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lut_specialities` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'PK of lut_association.',
  `lut_organization_type_id` int(11) DEFAULT NULL,
  `speciality_name` varchar(255) NOT NULL COMMENT 'Name of the association. It can be changed. in order to delete that from the system you need only disable it and it won''t be counted.',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=137 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lut_state`
--

DROP TABLE IF EXISTS `lut_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lut_state` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT 'Name of the state.',
  `state_code` varchar(100) NOT NULL COMMENT 'State code.',
  `country_code` char(3) NOT NULL COMMENT 'We use teh country code in order to reduce the jion query and faster response.',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`),
  KEY `state` (`name`),
  KEY `country_code` (`country_code`)
) ENGINE=MyISAM AUTO_INCREMENT=205 DEFAULT CHARSET=utf8 PACK_KEYS=1 CHECKSUM=1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lut_survey_custom_fields`
--

DROP TABLE IF EXISTS `lut_survey_custom_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lut_survey_custom_fields` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `choice_id` int(11) DEFAULT NULL,
  `custom_name` varchar(200) NOT NULL,
  `field_type` varchar(50) NOT NULL,
  `table_name` varchar(40) DEFAULT NULL,
  `choice_value` varchar(40) DEFAULT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lut_survey_question_type`
--

DROP TABLE IF EXISTS `lut_survey_question_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lut_survey_question_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `question_type` varchar(200) NOT NULL,
  `scorm_type` varchar(30) NOT NULL,
  `display_key` varchar(30) NOT NULL,
  `display_type` varchar(30) NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lut_survey_validation_type`
--

DROP TABLE IF EXISTS `lut_survey_validation_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lut_survey_validation_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `validation_name` varchar(200) NOT NULL DEFAULT 'text',
  `has_between` enum('0','1') NOT NULL DEFAULT '1',
  `is_dropdown` enum('0','1') NOT NULL DEFAULT '1' COMMENT 'Is the row part of the downdown',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `organization`
--

DROP TABLE IF EXISTS `organization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organization` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `consortium_id` int(10) unsigned NOT NULL DEFAULT '0',
  `file_upload_id` int(11) unsigned DEFAULT NULL,
  `lut_layout_template_id` int(11) unsigned DEFAULT NULL,
  `lut_contract_type_id` int(11) unsigned NOT NULL DEFAULT '1' COMMENT 'FK to lut_contract_type Table',
  `lut_organization_type_id` int(11) unsigned NOT NULL DEFAULT '2' COMMENT 'FK to lut_organization_type_id Table',
  `rbac_tool_ids` varchar(255) DEFAULT NULL,
  `organization_name` varchar(124) NOT NULL DEFAULT ' ' COMMENT 'Organization name which should be uniqe also.',
  `organization_url` varchar(124) DEFAULT NULL COMMENT 'The URL to the organization.',
  `path` varchar(124) DEFAULT NULL COMMENT 'The path which will be setup for the organization. later this path will be used in the url of this organization.',
  `contract_max_user` int(11) unsigned DEFAULT '0' COMMENT 'Maximum number of users in the organization based on the contract. This can be changed during organization setup seperatly.',
  `contract_max_course` int(11) unsigned DEFAULT '0' COMMENT 'Maximum number of courses in the organization based on the contract. This can be changed during organization setup seperatly.',
  `rbac_user_account_manager_primary` int(11) unsigned DEFAULT NULL COMMENT 'ID of the outreach coordinator for this organization based on the contract. This can be changed during organization setup seperatly.',
  `rbac_user_account_manager_secondary` int(11) unsigned DEFAULT NULL,
  `contract_help_desk` enum('0','1') NOT NULL DEFAULT '1' COMMENT 'Contract_Help_desk to hold the information on displaying helpdesk information(Flag)',
  `contract_remove_sponsor` enum('yes','no') NOT NULL DEFAULT 'no' COMMENT 'Determine if sponsor should be remove from the main page of this organization.',
  `contract_start_date` date DEFAULT NULL COMMENT 'Start date of the contract for this organization',
  `contract_end_date` date DEFAULT NULL COMMENT 'End date of the contract for this organization.',
  `contract_renewal_notice` int(11) unsigned NOT NULL DEFAULT '180',
  `contract_status` enum('active','inactive') NOT NULL DEFAULT 'inactive' COMMENT 'Contract''s status',
  `contract_notes` text COMMENT 'Contract notes',
  `organization_enrollment_options` varchar(200) NOT NULL COMMENT 'Organization can have Enrollment options : Employee , Contractor , Pre-Contractor ',
  `hr_feeds` varchar(200) DEFAULT NULL COMMENT 'Enrollment process will be automatic or manual for employee / contractor',
  `is_announcement` enum('enabled','disabled') NOT NULL DEFAULT 'disabled' COMMENT 'If announcement has been activated for this organization or not.',
  `auto_approve` tinyint(1) NOT NULL DEFAULT '0',
  `status` enum('enabled','disabled','suspended') NOT NULL DEFAULT 'disabled' COMMENT 'Organizations'' status',
  `address1` varchar(124) DEFAULT NULL COMMENT 'Address to the organization.',
  `address2` varchar(124) DEFAULT NULL COMMENT 'Address to the organization.',
  `city` varchar(64) DEFAULT NULL COMMENT 'City of the organization.',
  `state_code` varchar(10) DEFAULT NULL COMMENT 'Code of the Satet which comes from lut_state',
  `postal` varchar(24) DEFAULT NULL COMMENT 'Zip code of the organization.',
  `country_code` varchar(10) DEFAULT NULL COMMENT 'code of the Country which comes from lut_country',
  `phone1` varchar(24) DEFAULT NULL COMMENT 'First phone number to the organization.',
  `phone2` varchar(24) DEFAULT NULL COMMENT 'Second phone number to the organization.',
  `email` varchar(124) DEFAULT NULL COMMENT 'Email address to the organization.',
  `helpdesk_phone` varchar(24) DEFAULT NULL COMMENT 'Help desk phone number of the organization.',
  `helpdesk_email` varchar(124) DEFAULT NULL COMMENT 'Help desk email address of the organization.',
  `fiscal_year_start_month` smallint(5) unsigned NOT NULL DEFAULT '7',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `org_org_name_u` (`organization_name`),
  UNIQUE KEY `org_path_u` (`path`),
  KEY `country` (`country_code`),
  KEY `lut_contract_type_id` (`lut_contract_type_id`),
  KEY `lut_organization_type_id` (`lut_organization_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `organization_department`
--

DROP TABLE IF EXISTS `organization_department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organization_department` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
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
) ENGINE=InnoDB AUTO_INCREMENT=6617 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `organization_department_proxy`
--

DROP TABLE IF EXISTS `organization_department_proxy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organization_department_proxy` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `rbac_user_id` int(11) unsigned NOT NULL COMMENT 'User ID. Associates a user as a proxy with this table.',
  `organization_department_id` int(11) unsigned NOT NULL COMMENT 'Dept ID. Associates a user as a proxy with this table.',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `org_dep_proxy_org_dep_id_rbac_usr_id_u` (`organization_department_id`,`rbac_user_id`),
  KEY `rbac_user_id` (`rbac_user_id`),
  KEY `organization_department_id` (`organization_department_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6831 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `organization_enrollment_options`
--

DROP TABLE IF EXISTS `organization_enrollment_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organization_enrollment_options` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `organization_id` int(11) unsigned DEFAULT NULL,
  `lut_enrollment_option_id` int(11) unsigned DEFAULT NULL,
  `enrollment_option` enum('employee','employee-custom','contractor','contractor-custom') NOT NULL DEFAULT 'employee',
  `label` varchar(64) DEFAULT NULL,
  `data_type` varchar(10) DEFAULT NULL,
  `display_during_enrollment` enum('0','1') DEFAULT '1',
  `is_required` enum('0','1') DEFAULT '0',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`),
  KEY `lut_enrollment_option_id` (`lut_enrollment_option_id`),
  KEY `organization_id` (`organization_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1077 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `organization_position`
--

DROP TABLE IF EXISTS `organization_position`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organization_position` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `organization_id` int(11) unsigned NOT NULL,
  `lut_position_id` int(11) unsigned DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `feed_position_code` int(11) unsigned DEFAULT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `org_pos_org_id_lut_pos_id_u` (`organization_id`,`lut_position_id`),
  KEY `lut_position_id` (`lut_position_id`),
  KEY `feed_position_code` (`feed_position_code`)
) ENGINE=InnoDB AUTO_INCREMENT=66405 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `organization_top_enrollment`
--

DROP TABLE IF EXISTS `organization_top_enrollment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organization_top_enrollment` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `enroll_count` int(11) unsigned NOT NULL,
  `organization_id` int(11) unsigned NOT NULL,
  `course_id` int(11) unsigned NOT NULL,
  `activity_type` enum('On Demand','Clinical Simulation','Conference','Instructor-led class','content_wrapper_education','content_wrapper_quiz','content_wrapper_survey','generic','content_wrapper_survey_template') NOT NULL,
  `title` varchar(100) NOT NULL,
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `date_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) unsigned NOT NULL,
  `modified_by` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `organization_user_enrollment`
--


--
-- Table structure for table `rbac_role`
--

DROP TABLE IF EXISTS `rbac_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rbac_role` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rbac_role_tasks`
--

DROP TABLE IF EXISTS `rbac_role_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rbac_role_tasks` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `rbac_role_id` int(11) unsigned NOT NULL,
  `rbac_task_id` int(11) unsigned NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(1) NOT NULL DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3359 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rbac_task`
--

DROP TABLE IF EXISTS `rbac_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rbac_task` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `path` varchar(255) DEFAULT NULL,
  `type` enum('flag','org','target','owner','orgowner') NOT NULL DEFAULT 'flag',
  `target_table` varchar(255) DEFAULT NULL,
  `internal` enum('0','1') NOT NULL DEFAULT '0',
  `visible` enum('0','1') NOT NULL DEFAULT '0',
  `delegatable` enum('0','1') NOT NULL DEFAULT '1',
  `icon_path` varchar(255) DEFAULT NULL,
  `task_order` int(11) NOT NULL DEFAULT '0' COMMENT 'order to display',
  `url` varchar(255) DEFAULT NULL COMMENT 'path of where system should take the user from menu',
  `activity` enum('learn','educate','manage','admin') DEFAULT NULL COMMENT 'which acitivty should user this task have',
  `group_name` varchar(100) DEFAULT NULL COMMENT 'group task together under one name',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`),
  KEY `target` (`target_table`)
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `rbac_user_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rbac_user_group` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `rbac_user_id` int(11) unsigned NOT NULL COMMENT 'User ID. Associates a user to a group with this table.',
  `rbac_group_id` int(11) unsigned NOT NULL COMMENT 'Group ID. Associates a user to a group with this table.',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`),
  KEY `rbac_user_id` (`rbac_user_id`),
  KEY `rbac_group_id` (`rbac_group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=171399 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rbac_user_login_log`
--

DROP TABLE IF EXISTS `rbac_user_login_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rbac_user_login_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `rbac_user_id` int(11) NOT NULL,
  `ip` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `expired` tinyint(1) NOT NULL DEFAULT '1',
  `status` enum('enabled','disabled','archived','deleted') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `rbac_user_id` (`rbac_user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2761067 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Table logs a user login and enables a unified login in the s';
/*!40101 SET character_set_client = @saved_cs_client */;

--
--
-- Table structure for table `rbac_user_password_reset`
--

DROP TABLE IF EXISTS `rbac_user_password_reset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rbac_user_password_reset` (
  `rbac_user_id` int(11) unsigned NOT NULL COMMENT 'rbac_user_id',
  `hash` varchar(100) NOT NULL COMMENT 'hash of user_id',
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Time that the system checks against when verifying the page validity',
  `status` enum('enabled','disabled') NOT NULL DEFAULT 'enabled' COMMENT 'Necessary status column',
  `created_by` int(11) unsigned NOT NULL COMMENT 'Necessary created by column',
  `modified_by` int(11) unsigned NOT NULL COMMENT 'Necessary modified by column',
  KEY `rbac_user_id` (`rbac_user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='This table tracks the temporary login pages that exist and a';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rbac_user_security_question`
--

DROP TABLE IF EXISTS `rbac_user_security_question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rbac_user_security_question` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `rbac_user_id` int(11) unsigned DEFAULT NULL,
  `order_key` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `lut_security_question_id` int(11) unsigned DEFAULT NULL,
  `answer` varchar(255) DEFAULT NULL COMMENT 'The answer to the security question.',
  `status` enum('enabled','disabled','deleted') DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `rbac_usr_sec_qus_rbac_usr_id_order_key_u` (`rbac_user_id`,`order_key`),
  KEY `security_question_id` (`lut_security_question_id`),
  KEY `rbac_user_id` (`rbac_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=162522 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reports_drilldown_semaphores`
--

DROP TABLE IF EXISTS `reports_drilldown_semaphores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reports_drilldown_semaphores` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `rbac_user_id` int(11) unsigned NOT NULL,
  `organization_id` int(11) unsigned NOT NULL,
  `entity_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'For single entity reports, can be user id, course id or content id',
  `procedure_name` varchar(255) CHARACTER SET utf8 NOT NULL,
  `report_build_status` enum('In Progress','Ready','Failed') CHARACTER SET utf8 NOT NULL,
  `status` enum('enabled','disabled','archived','deleted') CHARACTER SET utf8 NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reports_sharing`
--

DROP TABLE IF EXISTS `reports_sharing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reports_sharing` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=946 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reports_user_standard`
--

DROP TABLE IF EXISTS `reports_user_standard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reports_user_standard` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `rbac_user_id` int(11) unsigned NOT NULL,
  `organization_id` int(11) unsigned NOT NULL,
  `report_name` enum('Educator All Courses','Educator All Content','Educator All Presentations','Educator All Quizzes','Educator All Returndemonstrations','Educator All Surveys','Manage All Courses','Manage Users Hrfeedregistration','Manage All Learners','Manage All Content','Manage All Presentations','Manage All Quizzes','Manage All Returndemonstrations','Manage All Surveys','Educator Specialist All Learners','Educator Specialist All Courses','Educator Specialist All Content','Admin Users Feed','Admin SingleCourse','Manage RA SingleCourse','Manage DHDHC SingleCourse','Manage ES SingleCourse') NOT NULL,
  `entity_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'For single entity reports, can be user id, course id or content id',
  `visible_report_title` varchar(255) NOT NULL,
  `report_build_status` enum('In Progress','Ready','Failed','Viewed') NOT NULL DEFAULT 'In Progress',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`),
  KEY `rbac_user_id` (`rbac_user_id`,`organization_id`,`report_name`,`entity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `specialty`
--

DROP TABLE IF EXISTS `specialty`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `specialty` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `specialty_name` varchar(255) NOT NULL DEFAULT '',
  `specialty_description` varchar(255) NOT NULL DEFAULT '',
  `position_id` int(10) unsigned NOT NULL DEFAULT '0',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2150 DEFAULT CHARSET=latin1 COMMENT='Specialty table';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `survey`
--

DROP TABLE IF EXISTS `survey`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `survey` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `file_upload_id` int(11) unsigned DEFAULT NULL,
  `parent_survey_template_id` int(11) unsigned DEFAULT NULL COMMENT 'the template id of where the survey is copied from',
  `content_container_id` int(11) unsigned NOT NULL,
  `survey_name` varchar(255) DEFAULT NULL,
  `processing_status` enum('pending','processing','success','failed') NOT NULL DEFAULT 'pending',
  `version` int(11) unsigned NOT NULL DEFAULT '1',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11955 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `survey_category`
--

DROP TABLE IF EXISTS `survey_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `survey_category` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `survey_id` int(11) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text,
  `cat_order` smallint(5) unsigned NOT NULL DEFAULT '0',
  `type` enum('none','template') NOT NULL DEFAULT 'none',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22305 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `survey_question`
--

DROP TABLE IF EXISTS `survey_question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `survey_question` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `survey_id` int(11) unsigned DEFAULT NULL,
  `lut_survey_question_type_id` int(11) unsigned NOT NULL,
  `survey_category_id` int(11) unsigned NOT NULL,
  `display_order` smallint(5) unsigned NOT NULL DEFAULT '0',
  `question_text` text NOT NULL,
  `sum_numeric` int(11) unsigned DEFAULT NULL,
  `required` enum('1','0') NOT NULL DEFAULT '0',
  `required_feedback_text` varchar(200) NOT NULL DEFAULT ' ',
  `validation_feedback` varchar(255) DEFAULT NULL,
  `comment` enum('1','0') NOT NULL DEFAULT '1',
  `sort_row_type` enum('alphabet','shuffle','none') NOT NULL DEFAULT 'none',
  `forced_ranking` enum('0','1') NOT NULL DEFAULT '0',
  `na_column` enum('0','1') NOT NULL DEFAULT '0',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20024 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `survey_question_column`
--

DROP TABLE IF EXISTS `survey_question_column`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `survey_question_column` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `survey_question_id` int(11) unsigned NOT NULL,
  `column_text` text NOT NULL,
  `column_value` varchar(255) NOT NULL DEFAULT ' ',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `survey_question_id` (`survey_question_id`)
) ENGINE=InnoDB AUTO_INCREMENT=89101 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `survey_question_row`
--

DROP TABLE IF EXISTS `survey_question_row`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `survey_question_row` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `lut_survey_custom_fields_id` int(11) unsigned DEFAULT NULL,
  `survey_question_id` int(11) unsigned NOT NULL,
  `row_text` text NOT NULL,
  `row_value` varchar(200) NOT NULL DEFAULT ' ',
  `is_required` enum('0','1') NOT NULL DEFAULT '0',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `survey_question_id` (`survey_question_id`)
) ENGINE=InnoDB AUTO_INCREMENT=71612 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `survey_question_validation`
--

DROP TABLE IF EXISTS `survey_question_validation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `survey_question_validation` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `lut_survey_validation_type_id` int(11) unsigned DEFAULT NULL,
  `survey_question_id` int(11) unsigned NOT NULL,
  `field_type` varchar(100) NOT NULL,
  `start_point` varchar(100) NOT NULL,
  `end_point` varchar(100) NOT NULL,
  `invalid_text` varchar(200) NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `survey_question_id` (`survey_question_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `survey_result`
--

DROP TABLE IF EXISTS `survey_result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `survey_result` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `survey_id` int(11) unsigned NOT NULL,
  `target_id` int(11) unsigned NOT NULL COMMENT 'It should be either content or course id. Depends upon what we decided for surver template questions.',
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `survey_result_interaction`
--

DROP TABLE IF EXISTS `survey_result_interaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `survey_result_interaction` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `survey_result_id` int(11) unsigned NOT NULL,
  `survey_question_id` int(11) unsigned NOT NULL,
  `survey_question_row_id` int(11) unsigned DEFAULT NULL,
  `survey_question_column_id` int(11) unsigned DEFAULT NULL,
  `column_value` varchar(255) NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `survey_template`
--

DROP TABLE IF EXISTS `survey_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `survey_template` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `file_upload_id` int(11) unsigned DEFAULT NULL,
  `parent_survey_id` int(11) unsigned DEFAULT NULL,
  `content_container_id` int(11) unsigned NOT NULL,
  `survey_name` varchar(255) DEFAULT NULL,
  `processing_status` enum('pending','processing','success','failed') NOT NULL DEFAULT 'pending',
  `allow_edit` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Those this template allow editting',
  `version` int(11) unsigned NOT NULL DEFAULT '1',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=134 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `survey_template_category`
--

DROP TABLE IF EXISTS `survey_template_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `survey_template_category` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `survey_id` int(11) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `cat_order` tinyint(4) NOT NULL DEFAULT '0',
  `type` enum('none','template') NOT NULL DEFAULT 'none',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=207 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `survey_template_question`
--

DROP TABLE IF EXISTS `survey_template_question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `survey_template_question` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `survey_id` int(11) unsigned DEFAULT NULL,
  `lut_survey_question_type_id` int(11) unsigned NOT NULL,
  `survey_category_id` int(11) unsigned NOT NULL,
  `display_order` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `question_text` text NOT NULL,
  `sum_numeric` int(11) unsigned DEFAULT NULL,
  `required` enum('1','0') NOT NULL DEFAULT '0',
  `required_feedback_text` varchar(200) NOT NULL,
  `validation_feedback` varchar(255) NOT NULL,
  `comment` enum('1','0') NOT NULL DEFAULT '1',
  `sort_row_type` enum('alphabet','shuffle','none') NOT NULL DEFAULT 'none',
  `forced_ranking` enum('0','1') NOT NULL DEFAULT '0',
  `na_column` enum('0','1') NOT NULL DEFAULT '0',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=335 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `survey_template_question_column`
--

DROP TABLE IF EXISTS `survey_template_question_column`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `survey_template_question_column` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `survey_question_id` int(11) unsigned NOT NULL,
  `column_text` text NOT NULL,
  `column_value` varchar(255) DEFAULT '',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `survey_question_id` (`survey_question_id`)
) ENGINE=InnoDB AUTO_INCREMENT=408 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `survey_template_question_row`
--

DROP TABLE IF EXISTS `survey_template_question_row`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `survey_template_question_row` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `lut_survey_custom_fields_id` int(11) unsigned DEFAULT NULL,
  `survey_question_id` int(11) unsigned NOT NULL,
  `row_text` text NOT NULL,
  `row_value` varchar(200) DEFAULT '',
  `is_required` enum('0','1') NOT NULL DEFAULT '0',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `survey_question_id` (`survey_question_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2196 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `survey_template_question_validation`
--

DROP TABLE IF EXISTS `survey_template_question_validation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `survey_template_question_validation` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `lut_survey_validation_type_id` int(11) unsigned DEFAULT NULL,
  `survey_question_id` int(11) unsigned NOT NULL,
  `field_type` varchar(100) NOT NULL,
  `start_point` varchar(100) NOT NULL,
  `end_point` varchar(100) NOT NULL,
  `invalid_text` varchar(200) NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `survey_question_id` (`survey_question_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tag_available`
--

DROP TABLE IF EXISTS `tag_available`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tag_available` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `parent_tag_available_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'parent id of the tag.  use for tree generation',
  `added_by_rbac_user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'if we decide to limit users to can add tag',
  `target_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'the id of the source tag.  This is here for updating purposes (BLOOMID:1)',
  `target_source` varchar(50) NOT NULL COMMENT 'The source tag.  For example the source came from bloom.  This is here for updating purposes.',
  `is_category` enum('0','1') NOT NULL DEFAULT '1' COMMENT 'indicate if this tag is a category not',
  `can_tag` enum('0','1') NOT NULL DEFAULT '1' COMMENT 'decide if this can use to tag',
  `number_used` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'how many times this tag was used in the system',
  `tag_tree` varchar(800) NOT NULL DEFAULT ' ' COMMENT 'the tree structure of the tag represent by dot 000000001.00000000.2',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3863 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tag_statistic`
--

DROP TABLE IF EXISTS `tag_statistic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tag_statistic` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `combination_keys` varchar(50) NOT NULL COMMENT 'combination key of key1 and key 2',
  `key1_tag_available_id` int(11) unsigned NOT NULL COMMENT 'key 1 of the tag.  always smaller and key2',
  `key2_tag_available_id` int(11) unsigned NOT NULL COMMENT 'key 2 of the tag.  always bigger than key 1',
  `combination_usage` int(11) unsigned NOT NULL COMMENT 'How many times the combination keys were used together.',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `tag_stat_comb_keys_u` (`combination_keys`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tag_used_content`
--

DROP TABLE IF EXISTS `tag_used_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tag_used_content` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tag_available_id` int(11) unsigned NOT NULL COMMENT 'foreign key to tag_available table',
  `target_id` int(11) unsigned NOT NULL COMMENT 'content container id',
  `added_by_rbac_user_id` int(11) unsigned NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `tag_used_cnt_tag_avbl_id_target_id_u` (`tag_available_id`,`target_id`)
) ENGINE=InnoDB AUTO_INCREMENT=463 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tag_used_course`
--

DROP TABLE IF EXISTS `tag_used_course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tag_used_course` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tag_available_id` int(11) NOT NULL COMMENT 'foreign key to tag_available table',
  `target_id` int(11) NOT NULL COMMENT 'course id',
  `added_by_rbac_user_id` int(11) NOT NULL,
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) unsigned DEFAULT '0',
  `modified_by` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `tag_used_crs_tag_avbl_id_target_id_u` (`tag_available_id`,`target_id`),
  KEY `target_id` (`target_id`),
  KEY `tag_available_id` (`tag_available_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11439 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


DROP TABLE IF EXISTS `template_email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `template_email` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `template_key` varchar(60) NOT NULL COMMENT 'name of the template',
  `template_subject` varchar(255) NOT NULL,
  `template_body` text NOT NULL COMMENT 'actual text of the template',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `temp_email_temp_key_u` (`template_key`)
) ENGINE=MyISAM AUTO_INCREMENT=65 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `template_todo`
--

DROP TABLE IF EXISTS `template_todo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `template_todo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_key` varchar(60) NOT NULL COMMENT 'role key from rbac_role table',
  `template_key` varchar(60) NOT NULL COMMENT 'name of the template',
  `template_text` text NOT NULL COMMENT 'actual text of the template',
  `status` enum('enabled','disabled','archived','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the modifier of this record.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `temp_todo_temp_key_u` (`template_key`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `todo`
--

DROP TABLE IF EXISTS `todo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `todo` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
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
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=8760 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `todo_cycle1`
--

DROP TABLE IF EXISTS `todo_cycle1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `todo_cycle1` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
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
  PRIMARY KEY (`id`),
  KEY `rbac_user_id` (`rbac_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=33607 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `todo_cycle2`
--

DROP TABLE IF EXISTS `todo_cycle2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `todo_cycle2` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
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
  PRIMARY KEY (`id`),
  KEY `rbac_user_id` (`rbac_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=65536 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `todo_messages`
--

DROP TABLE IF EXISTS `todo_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `todo_messages` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8447508 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_association`
--

DROP TABLE IF EXISTS `user_association`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_association` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `rbac_user_id` int(11) unsigned NOT NULL COMMENT 'User ID.',
  `lut_association_id` int(11) unsigned DEFAULT NULL COMMENT 'Association ID which come from lut_association TABLE.',
  `association_name` varchar(255) NOT NULL COMMENT 'The name of the association. This also comes from the lut_association TABLE and can be changed to different name and it is here to reduce the join in query.',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=332 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_certificate`
--

DROP TABLE IF EXISTS `user_certificate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_certificate` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=893 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_disclosure`
--

DROP TABLE IF EXISTS `user_disclosure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_disclosure` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_education`
--

DROP TABLE IF EXISTS `user_education`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_education` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `rbac_user_id` int(11) unsigned NOT NULL COMMENT 'User ID. Define who is getting this education.',
  `lut_education_id` int(11) unsigned DEFAULT NULL COMMENT 'This is the Id of the education from lut_education TABLE. Determine the type of the education from that table.',
  `institute_name` varchar(255) NOT NULL DEFAULT ' ' COMMENT 'The name of the user institutation that the user attended.',
  `education_name` varchar(255) DEFAULT NULL COMMENT 'The name of the education that student will get.',
  `years_of_education` smallint(5) unsigned NOT NULL DEFAULT '0',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `usr_edu_rbac_usr_id_lut_edu_id_u` (`rbac_user_id`,`lut_education_id`)
) ENGINE=InnoDB AUTO_INCREMENT=24344 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_files`
--

DROP TABLE IF EXISTS `user_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_files` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4718 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_form`
--

DROP TABLE IF EXISTS `user_form`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_form` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `rbac_user_id` int(11) unsigned NOT NULL COMMENT 'User completing the form',
  `form_identifier` varchar(100) NOT NULL COMMENT 'Name of the form being completed',
  `do_hide` tinyint(1) unsigned NOT NULL COMMENT 'Determines if form should be displayed again or hidden',
  `status` enum('enabled','disabled','deleted') NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `date_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) unsigned NOT NULL,
  `modified_by` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=185 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_license`
--

DROP TABLE IF EXISTS `user_license`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_license` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1403 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_specialty`
--

DROP TABLE IF EXISTS `user_specialty`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_specialty` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `rbac_user_id` int(11) unsigned NOT NULL COMMENT 'User ID.',
  `specialty_id` int(11) unsigned NOT NULL COMMENT 'This is the Id of the specialty from specialty TABLE.',
  `experience` int(1) NOT NULL DEFAULT '1' COMMENT 'Years of experience in this speciality.',
  `status` enum('enabled','disabled','deleted') NOT NULL DEFAULT 'enabled' COMMENT 'Status of the record.',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Data and time record has been created.',
  `date_modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data and time record has been modified.',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  `modified_by` int(11) unsigned DEFAULT '0' COMMENT 'The ID of the creator of this record.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

