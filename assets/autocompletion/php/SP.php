
<?php
/**
 * Autocompletion stub
 * You call (dbname)_(stored_procedure_name)
 */
class SP{
        /**
         * @return SP
         */
        static function call(){
            return new self;
        }


	   /**
		* Database: Users
		* check_user_has_role
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\aeonflux/check_user_has_role.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT(11)
		* @param integer $in_user_id  :IN in_user_id INT(11)
		* @param integer $in_role_id  :IN in_role_id INT(11)
		*/
		public function Users_check_user_has_role($in_organization_id,$in_user_id,$in_role_id){
			/*
   SELECT 
   			rbac_group.id
   FROM 
	        lms2prod.rbac_group
	     JOIN
	        lms2prod.rbac_user_group
	     ON
	        rbac_group.id = rbac_user_group.rbac_group_id

   WHERE 
	        rbac_group.organization_id=in_organization_id
	     AND
	        rbac_group.rbac_role_id = in_role_id
	     AND
	        rbac_user_group.rbac_user_id = in_user_id;



			*/
		}


	   /**
		* Database: Users
		* get_all_terminated_users
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\aeonflux/get_all_terminated_users.sql
		*
		*/
		public function Users_get_all_terminated_users(){
			/*
	SELECT
			COUNT(*) AS `c`

	FROM 
			lms2prod.rbac_group
		JOIN
			lms2prod.rbac_user_group
		ON
			rbac_group.id = rbac_user_group.rbac_group_id
	WHERE
			rbac_role_id = 12;



			*/
		}


	   /**
		* Database: Users
		* buildUserActivityStream
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\activity_stream/buildUserActivityStream.sql
		*
		* @param integer $user_id  :IN user_id int(11)
		* @param integer $organization_id  :IN organization_id int(11)
		* @param string $output_text  :IN output_text text
		*/
		public function Users_buildUserActivityStream($user_id,$organization_id,$output_text){
			/*
	REPLACE INTO activity_stream_mv VALUES(user_id, organization_id, output_text);



			*/
		}


	   /**
		* Database: Users
		* cronMaterializedViewOrganizationUserStream
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\activity_stream/cronMaterializedViewOrganizationUserStream.sql
		*
		* @param integer $organization_id  :IN organization_id int(11)
		*/
		public function Users_cronMaterializedViewOrganizationUserStream($organization_id){
			/*
	SET @paramsColumn1 = CONCAT('{"organization_id":"', organization_id, '"}');
	REPLACE INTO cron_materialized_view(class_name,params_hash, params) VALUES('Activity_OrganizationUserStream',MD5( @paramsColumn1),@paramsColumn1);


			*/
		}


	   /**
		* Database: Users
		* cronMaterializedViewUserStream
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\activity_stream/cronMaterializedViewUserStream.sql
		*
		* @param integer $user_id  :IN user_id int(11)
		*/
		public function Users_cronMaterializedViewUserStream($user_id){
			/*
	SET @paramsColumn = CONCAT('{"rbac_user_id":"', user_id, '"}');
	REPLACE INTO cron_materialized_view(class_name,params_hash,params) VALUES('Activity_UserStream',MD5(@paramsColumn),@paramsColumn);


			*/
		}


	   /**
		* Database: Users
		* commcenter_email_get_pending
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\CommCenter\Email/pending_batch.sql
		*
		* @param integer $in_page_size  :IN in_page_size SMALLINT(3)
		*/
		public function Users_commcenter_email_get_pending($in_page_size){
			/*

 -- CLEAN sruck processed records 
	UPDATE email
	SET
		send_status = 'pending'
	WHERE
		send_status = 'processing'
	    AND
		date_modified < DATE_SUB(NOW(), INTERVAL 5 MINUTE);

 -- FETCH THE RECORDS 

	SELECT
		email.id,
		email.subject,
	    	email.body,
		email.user_files_id,
		email.urgency_level,

		to_user.id		AS 'recipient_id',
		to_user.username	AS 'recipient_email',
		from_user.username	AS 'sender_email',
	 	CONCAT(from_user.first_name, ' ', from_user.last_name) 	AS recipient_fullname,
	    	CONCAT(to_user.first_name, ' ', to_user.last_name) 	AS sender_fullname

	FROM
		email
	    JOIN
	    	rbac_user to_user 
	    ON
	    	email.to_id=to_user.id
	    LEFT JOIN
	    	rbac_user from_user
	    ON
	    	email.to_id=from_user.id
	    	
	WHERE
	    	email.send_status='pending'
	    	
	ORDER BY
	    	email.urgency_level DESC,
	    	id ASC
	LIMIT in_page_size;



			*/
		}


	   /**
		* Database: Users
		* get_course_wrapper
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Content/get_course_wrapper.sql
		*
		* @param integer $content_container_id  :IN content_container_id INT(11)
		*/
		public function Users_get_course_wrapper($content_container_id){
			/*
  SELECT 
	  	course.id
  FROM
		course_content
	 JOIN
		course
	 ON
		course_content.course_id = course.id
  WHERE
		course_content.content_container_id = content_container_id
	AND
		course.activity_type IN ( 'content_wrapper_education','content_wrapper_quiz','content_wrapper_survey', 'content_wrapper_survey_template')
  LIMIT 1;


			*/
		}


	   /**
		* Database: Users
		* upcoming_content_expiration
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Content\Email/upcoming_content_expiration.sql
		*
		*/
		public function Users_upcoming_content_expiration(){
			/*
 	SELECT
			content_container.id,
			content_container.rbac_user_id
	FROM
			content_container
	WHERE
			((content_container.expired_date > NOW() + INTERVAL 3 MONTH
		AND
			content_container.expired_date < NOW() + INTERVAL 3 MONTH + INTERVAL 1 DAY)
		OR
			(content_container.expired_date > NOW() + INTERVAL 2 MONTH
		AND
			content_container.expired_date < NOW() + INTERVAL 2 MONTH + INTERVAL 1 DAY)
		OR
			(content_container.expired_date > NOW() + INTERVAL 1 MONTH
		AND
			content_container.expired_date < NOW() + INTERVAL 1 MONTH + INTERVAL 1 DAY))
		AND
			content_container.content_container_status = 'Active';


			*/
		}


	   /**
		* Database: Users
		* auto_enroll_reminder_dh
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Course\Email/auto_enroll_reminder_dh.sql
		*
		*/
		public function Users_auto_enroll_reminder_dh(){
			/*
 	SELECT
			course_enrollment_invoice.registerer_rbac_user_id as rbac_user_id,
			course_enrollment_rollout.course_id,
			course_auto_enrollment.id as course_auto_enrollment_id,
			course.owner_rbac_user_id as faculty_id,
			course_enrollment_rollout.id as rollout_id
	FROM
			course_auto_enrollment
	JOIN
			course_enrollment_invoice
		ON
			course_enrollment_invoice.id = course_auto_enrollment.course_enrollment_invoice_id
	JOIN
			course_enrollment_rollout
		ON
			course_enrollment_invoice.course_enrollment_rollout_id = course_enrollment_rollout.id
	JOIN
			course
		ON
			course_auto_enrollment.course_id = course.id
	WHERE
			((course_auto_enrollment.auto_enrollment_end_date > NOW() + INTERVAL 1 MONTH
		AND
			course_auto_enrollment.auto_enrollment_end_date < NOW() + INTERVAL 1 MONTH + INTERVAL 1 DAY)
		OR
			(course_auto_enrollment.auto_enrollment_end_date > NOW() + INTERVAL 1 WEEK
		AND
			course_auto_enrollment.auto_enrollment_end_date < NOW() + INTERVAL 1 WEEK + INTERVAL 1 DAY)
		OR
			(course_auto_enrollment.auto_enrollment_end_date > NOW() + INTERVAL 1 DAY
		AND
			course_auto_enrollment.auto_enrollment_end_date < NOW() + INTERVAL 2 DAY))
		AND
			course_auto_enrollment.check_on_group_enroll > 0
	GROUP BY
			course_enrollment_rollout.id;


			*/
		}


	   /**
		* Database: Users
		* instructor_reminder
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Course\Email/instructor_reminder.sql
		*
		*/
		public function Users_instructor_reminder(){
			/*
 	SELECT DISTINCT
 			c.id,
			edtru.faculty_rbac_user_id,
			c.organization_id,
			ed.id as event_date_id
	FROM
			course as c
	JOIN
			course_enrollment as ce
		ON
			ce.course_id = c.id
	JOIN
			course_enrollment_day ced
		ON
			ced.course_enrollment_id = ce.id
	JOIN
			event_dates ed
		ON
			ced.day_id = ed.id
	JOIN
			event_dates_topics edt
		ON
			ed.id = edt.event_date_id
	JOIN
			event_dates_topics_rbac_user edtru
		ON
			edt.id = edtru.event_dates_topics_id
	WHERE
			((ed.start_date > NOW() + INTERVAL 2 WEEK
		AND
			ed.start_date < NOW() + INTERVAL 2 WEEK + INTERVAL 1 DAY)
		OR
			(ed.start_date > NOW() + INTERVAL 1 WEEK
		AND
			ed.start_date < NOW() + INTERVAL 1 WEEK + INTERVAL 1 DAY)
		OR
			(ed.start_date > NOW() + INTERVAL 2 DAY
		AND
			ed.start_date < NOW() + INTERVAL 3 DAY)
		OR
			(ed.start_date > NOW() + INTERVAL 1 DAY
		AND
			ed.start_date < NOW() + INTERVAL 2  DAY))
		AND
			c.publish_status = 'Active'
	GROUP BY
			ed.id;


			*/
		}


	   /**
		* Database: Users
		* learner_reminder
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Course\Email/learner_reminder.sql
		*
		*/
		public function Users_learner_reminder(){
			/*
 	SELECT DISTINCT
			course_enrollment.student_rbac_user_id AS rbac_user_id,
			course.organization_id,
			course_enrollment.id AS course_enrollment_id,
			course.id AS course_id,
			event_dates.id as event_date_id
	FROM
			course
	JOIN
			course_enrollment
		ON
			course_enrollment.course_id = course.id
	JOIN
			course_enrollment_day
		ON
			course_enrollment_day.course_enrollment_id = course_enrollment.id
	JOIN
			event_dates
		ON
			course_enrollment_day.day_id = event_dates.id
	WHERE
			((event_dates.start_date > NOW() + INTERVAL 2 WEEK
		AND
			event_dates.start_date < NOW() + INTERVAL 2 WEEK + INTERVAL 1 DAY
		AND
			FIND_IN_SET('14',course.reminder_times))
		OR
			(event_dates.start_date > NOW() + INTERVAL 1 WEEK
		AND
			event_dates.start_date < NOW() + INTERVAL 1 WEEK + INTERVAL 1 DAY
		AND
			FIND_IN_SET('7',course.reminder_times))
		OR
			(event_dates.start_date > NOW() + INTERVAL 2 DAY
		AND
			event_dates.start_date < NOW() + INTERVAL 3 DAY
		AND
			FIND_IN_SET('2',course.reminder_times))
		OR
			(event_dates.start_date > NOW() + INTERVAL 1 DAY
		AND
			event_dates.start_date < NOW() + INTERVAL 2 DAY
		AND
			FIND_IN_SET('1',course.reminder_times)))
		AND
			course.publish_status = 'Active'
		AND
			course_enrollment.activity_director_status = 'approved';


			*/
		}


	   /**
		* Database: Users
		* pending_approval_ad
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Course\Email/pending_approval_ad.sql
		*
		*/
		public function Users_pending_approval_ad(){
			/*
 	SELECT DISTINCT
 			c.id,
			c.owner_rbac_user_id,
			c.organization_id
	FROM
			course as c
	JOIN
			course_enrollment as ce
		ON
			ce.course_id = c.id
	WHERE
			ce.activity_director_status = 'pending'
		AND
			ce.enrollment_date > DATE_SUB(NOW(),INTERVAL 1 DAY);


			*/
		}


	   /**
		* Database: Users
		* pending_approval_dh
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Course\Email/pending_approval_dh.sql
		*
		*/
		public function Users_pending_approval_dh(){
			/*
 	SELECT DISTINCT
 			ce.course_id,
			ru.id,
			ce.organization_id
	FROM
			rbac_user as ru
	JOIN
			organization_department as od
		ON
			od.rbac_user_id = ru.id
	JOIN
			organization_user_enrollment as oue
		ON
			oue.organization_department_id = od.id
	JOIN
			course_enrollment as ce
		ON
			ce.student_rbac_user_id = oue.rbac_user_id
	WHERE
			ce.manager_status = 'pending'
		AND
			ce.enrollment_date > DATE_SUB(NOW(),INTERVAL 1 DAY);


			*/
		}


	   /**
		* Database: Users
		* pending_live_approval_ac
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Course\Email/pending_live_approval_ac.sql
		*
		*/
		public function Users_pending_live_approval_ac(){
			/*
 	SELECT
						DISTINCT c.id,
						cr.rbac_user_id,
						c.organization_id,
						(
						SELECT
								COUNT(ce.id) AS enroll_count
						FROM
								course
						JOIN
								course_enrollment
							ON
								course_enrollment.course_id = course.id
						JOIN
								course_enrollment_day
							ON
								course_enrollment_day.course_enrollment_id = course_enrollment.id
						JOIN
								event_dates
							ON
								course_enrollment_day.day_id = event_dates.id
						WHERE
								course_enrollment.activity_director_status = 'approved'
							AND
								event_dates.start_date > NOW()
							AND
								event_dates.start_date < DATE_ADD(NOW(), INTERVAL 1 DAY)
							AND
								course.publish_status = 'Active'
							AND
								event_dates.id = ed.id
						GROUP BY
								event_dates.id
						)AS enroll_count,
						ed.max_registration
						
				FROM
						course as c
				JOIN
						course_enrollment as ce
					ON
						ce.course_id = c.id
				JOIN
						course_role cr
					ON
						cr.course_id = c.id
				JOIN
						course_enrollment_day ced
					ON
						ced.course_enrollment_id = ce.id
				JOIN
						event_dates ed
					ON
						ced.day_id = ed.id
				WHERE
						ce.activity_director_status = 'pending'
					AND
						ed.start_date > NOW()
					AND
						ed.start_date < DATE_ADD(NOW(), INTERVAL 1 DAY)
					AND
						cr.role_id = 6
					AND
						c.publish_status = 'Active'
				GROUP BY
						ed.id,cr.rbac_user_id;


			*/
		}


	   /**
		* Database: Users
		* pending_live_approval_ad
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Course\Email/pending_live_approval_ad.sql
		*
		*/
		public function Users_pending_live_approval_ad(){
			/*
 	SELECT DISTINCT
 		c.id,
		c.owner_rbac_user_id,
		c.organization_id,
		(
			SELECT
					COUNT(ce.id) AS enroll_count
			FROM
					course
			JOIN
					course_enrollment
				ON
					course_enrollment.course_id = course.id
			JOIN
					course_enrollment_day
				ON
					course_enrollment_day.course_enrollment_id = course_enrollment.id
			JOIN
					event_dates
				ON
					course_enrollment_day.day_id = event_dates.id
			WHERE
					course_enrollment.activity_director_status = 'approved'
				AND
					event_dates.start_date > NOW()
				AND
					event_dates.start_date < DATE_ADD(NOW(), INTERVAL 1 DAY)
				AND
					course.publish_status = 'Active'
				AND
					event_dates.id = ed.id
			GROUP BY
					event_dates.id
		)AS enroll_count,
		ed.max_registration
	FROM
			course as c
	JOIN
			course_enrollment as ce
		ON
			ce.course_id = c.id
	JOIN
			course_enrollment_day ced
		ON
			ced.course_enrollment_id = ce.id
	JOIN
			event_dates ed
		ON
			ced.day_id = ed.id
	WHERE
			ce.activity_director_status = 'pending'
		AND
			ed.start_date > NOW()
		AND
			ed.start_date < DATE_ADD(NOW(), INTERVAL 1 DAY)
		AND
			c.publish_status = 'Active'
	GROUP BY
			ed.id;


			*/
		}


	   /**
		* Database: Users
		* under_minimum_live_approval_ad
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Course\Email/under_minimum_live_approval_ad.sql
		*
		*/
		public function Users_under_minimum_live_approval_ad(){
			/*
 	SELECT DISTINCT 
 			c.id,
			c.owner_rbac_user_id,
			c.organization_id,
			ed.id as event_date_id,
			(
				SELECT
						COUNT(ce.id) AS enroll_count
				FROM
						course
				JOIN
						course_enrollment
					ON
						course_enrollment.course_id = course.id
				JOIN
						course_enrollment_day
					ON
						course_enrollment_day.course_enrollment_id = course_enrollment.id
				JOIN
						event_dates
					ON
						course_enrollment_day.day_id = event_dates.id
				WHERE
						course_enrollment.activity_director_status <> 'rejected'
					AND
						((event_dates.start_date > NOW() + INTERVAL 2 WEEK
					AND
						event_dates.start_date < NOW() + INTERVAL 2 WEEK + INTERVAL 1 DAY)
					OR
						(event_dates.start_date > NOW() + INTERVAL 1 WEEK
					AND
						event_dates.start_date < NOW() + INTERVAL 1 WEEK + INTERVAL 1 DAY)
					OR
						(event_dates.start_date > NOW() + INTERVAL 2 DAY
					AND
						event_dates.start_date < NOW() + INTERVAL 3 DAY))
					AND
						course.publish_status = 'Active'
					AND
						event_dates.id = ed.id
				GROUP BY
						event_dates.id
			)AS enroll_count,
			ed.min_registration
	FROM
			course as c
	JOIN
			course_enrollment as ce
		ON
			ce.course_id = c.id
	JOIN
			course_enrollment_day ced
		ON
			ced.course_enrollment_id = ce.id
	JOIN
			event_dates ed
		ON
			ced.day_id = ed.id
	WHERE
			((ed.start_date > NOW() + INTERVAL 2 WEEK
		AND
			ed.start_date < NOW() + INTERVAL 2 WEEK + INTERVAL 1 DAY)
		OR
			(ed.start_date > NOW() + INTERVAL 1 WEEK
		AND
			ed.start_date < NOW() + INTERVAL 1 WEEK + INTERVAL 1 DAY)
		OR
			(ed.start_date > NOW() + INTERVAL 2 DAY
		AND
			ed.start_date < NOW() + INTERVAL 3 DAY))
		AND
			c.publish_status = 'Active'
	GROUP BY
			ed.id;


			*/
		}


	   /**
		* Database: Users
		* course_wizard_scheduler_dates 
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Course\Wizard/scheduler_dates.sql
		*
		* @param integer $in_course_id  :IN in_course_id INT
		* @param integer $in_repeat_1  :IN in_repeat_1 INT
		* @param integer $in_repeat_2  :IN in_repeat_2 INT
		* @param integer $in_repeat_3  :IN in_repeat_3 INT
		* @param integer $in_repeat_4  :IN in_repeat_4 INT
		* @param integer $in_repeat_5  :IN in_repeat_5 INT
		* @param integer $in_repeat_6  :IN in_repeat_6 INT
		* @param integer $in_repeat_7  :IN in_repeat_7 INT
		* @param integer $in_repeat_8  :IN in_repeat_8 INT
		* @param integer $in_repeat_9  :IN in_repeat_9 INT
		* @param integer $in_repeat_10  :IN in_repeat_10 INT
		*/
		public function Users_course_wizard_scheduler_dates ($in_course_id,$in_repeat_1,$in_repeat_2,$in_repeat_3,$in_repeat_4,$in_repeat_5,$in_repeat_6,$in_repeat_7,$in_repeat_8,$in_repeat_9,$in_repeat_10){
			/*
			SELECT
					event_dates.event_repeat_group_id,
					event_dates.id,
					DATE_FORMAT(event_dates.start_date, '%M %e, %Y')	AS 'date',
					TIME_FORMAT(event_dates.start_date,'%l:%i %p')		AS 'start_time',
					TIME_FORMAT(event_dates.end_date,'%l:%i %p')		AS 'end_time',
					logistics_room.title								AS 'location_title',
					CONCAT(logistics_room.city,', ', logistics_room.state) AS 'location_area',
					logistics_room.name									AS 'full_address'
			
			FROM
					event_dates
				LEFT JOIN
					logistics_room
				ON
					event_dates.location_id = logistics_room.id 
		
			WHERE
					event_dates.course_id = in_course_id
				AND
					event_dates.event_repeat_group_id IN (in_repeat_1,in_repeat_2,in_repeat_3,in_repeat_4,in_repeat_5,in_repeat_6,in_repeat_7,in_repeat_8,in_repeat_9,in_repeat_10)
			;



			*/
		}


	   /**
		* Database: Users
		* course_wizard_scheduler_topics 
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Course\Wizard/scheduler_topics.sql
		*
		* @param integer $in_event_date_id  :IN in_event_date_id INT
		*/
		public function Users_course_wizard_scheduler_topics ($in_event_date_id){
			/*
			SELECT
					event_dates_topics.id, 
					TIME_FORMAT(event_dates_topics.start_time,"%l:%i %p")	AS 'start_time', 
					TIME_FORMAT(event_dates_topics.end_time,"%l:%i %p")		AS 'end_time',
					content_container.name,
					event_dates_topics.location_room,
					logistics_room.title									AS 'location',
					GROUP_CONCAT(DISTINCT CONCAT(rbac_user.first_name, ' ', rbac_user.last_name) SEPARATOR '</br>') AS 'faculty',
					MAX(course_enrollment_topic.is_attended)				AS 'attended'
			
			FROM
					event_dates_topics
				JOIN
					content_container
				ON
					event_dates_topics.content_container_id = content_container.id
				LEFT JOIN
					logistics_room
				ON
					event_dates_topics.location_id = logistics_room.id
				LEFT JOIN
					course_enrollment
				ON
					event_dates_topics.course_id = course_enrollment.course_id
					AND
					course_enrollment.activity_director_status <> 'rejected'
				LEFT JOIN
					course_enrollment_topic
				ON
					event_dates_topics.id = course_enrollment_topic.topic_id
					AND
					course_enrollment_topic.course_enrollment_id = course_enrollment.id
				LEFT JOIN
					event_dates_topics_rbac_user
				ON
					event_dates_topics.id = event_dates_topics_rbac_user.event_dates_topics_id
				LEFT JOIN
					rbac_user
				ON
					event_dates_topics_rbac_user.faculty_rbac_user_id  = rbac_user.id
				
			WHERE
					event_dates_topics.event_date_id = in_event_date_id

			GROUP BY
					event_dates_topics.id;


			*/
		}


	   /**
		* Database: Users
		* cron_failsafe_fix_starttime_status
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Cron/failsafe_fix_starttime_status.sql
		*
		*/
		public function Users_cron_failsafe_fix_starttime_status(){
			/*
	UPDATE cron
			set start_time = IF(
								interval_seconds<86400,
								CONVERT(DATE_ADD(last_run, INTERVAL 30 SECOND),DATETIME),
								CONVERT(DATE_ADD(CONVERT(DATE_ADD(last_run, INTERVAL 1 DAY),DATE), INTERVAL hour_of_day HOUR),DATETIME) 
								) 
	WHERE
			start_time < last_run

		AND
			last_status<> 'RESCHEDULE';
    


			*/
		}


	   /**
		* Database: Users
		* cron_get_jobs_readyto_run
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Cron/get_jobs_readyto_run.sql
		*
		*/
		public function Users_cron_get_jobs_readyto_run(){
			/*
	SELECT	*
		FROM	lms2prod.cron
		WHERE
				status = 'enabled'
			AND
				last_status = 'OK'
			AND
				start_time < Now()
			AND
				last_run <= start_time
			AND
				depends_on_job_id IS NULL
				
				
	UNION
	
	
		SELECT	A.*
		FROM
				cron A
			JOIN
				cron B
			ON
				A.depends_on_job_id = B.id
		WHERE
				A.status = 'enabled'
			AND
				A.last_status = 'OK'
			AND
				A.start_time < Now()
			AND
				A.last_run <= A.start_time
			AND
				B.last_status = 'OK'
			AND
				B.last_run > A.last_run
			AND 
				A.depends_on_job_id IS NOT NULL
				
	ORDER BY
				last_run ASC;
	


			*/
		}


	   /**
		* Database: Users
		* cron_get_stuck_jobs
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Cron/get_stuck_jobs.sql
		*
		*/
		public function Users_cron_get_stuck_jobs(){
			/*
SELECT
			id
	FROM
			cron
	WHERE
			CONVERT(DATE_ADD(date_modified, INTERVAL 2 HOUR),DATETIME) < Now()
		AND
			last_status NOT IN ('FAIL','OK','RESCHEDULE','STOPPED'); 
	


			*/
		}


	   /**
		* Database: Users
		* cron_timeout_async_actions
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Cron/timeout_async_actions.sql
		*
		* @param integer $roleouts_faild  :OUT roleouts_faild INT(11)
		*/
		public function Users_cron_timeout_async_actions($roleouts_faild){
			/*

	-- reports main
	DELETE FROM
				reports_user_standard
			WHERE
					reports_user_standard.report_build_status <> 'Ready'
				AND
					reports_user_standard.date_created < DATE_SUB(NOW(), INTERVAL 40 MINUTE);
	
	-- reports drilldowns
	DELETE FROM
					reports_drilldown_semaphores
			WHERE
					reports_drilldown_semaphores.report_build_status <> 'Ready'
				AND
					reports_drilldown_semaphores.date_created < DATE_SUB(NOW(), INTERVAL 40 MINUTE);
					
	-- User file generation
	DELETE FROM
					user_files
			WHERE
					user_files.file_status <> 'Ready'
				AND
					user_files.date_created < DATE_SUB(NOW(), INTERVAL 40 MINUTE);
					

	-- world lock, clean suspected stuck
	DELETE FROM
					lock_queue
			WHERE
					lock_queue.lock_status IN('in_progress','Ready')
				AND
					lock_queue.date_created < DATE_SUB(NOW(), INTERVAL 15 MINUTE);

					
	-- world lock, old waiting
	DELETE FROM
					lock_queue
			WHERE
					lock_queue.lock_status IN('waiting')
				AND
					lock_queue.date_created < DATE_SUB(NOW(), INTERVAL 40 MINUTE);

	-- roleouts
	DELETE FROM
				course_enrollment_rollout_status
		WHERE
				course_enrollment_rollout_status.rollout_status = 'in_progress'
			AND
				course_enrollment_rollout_status.date_created < DATE_SUB(NOW(), INTERVAL 90 MINUTE);
				
	SELECT ROW_COUNT()
	INTO roleouts_faild;	
	


			*/
		}


	   /**
		* Database: Users
		* cron_update_next_schedule
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Cron/update_next_schedule.sql
		*
		*/
		public function Users_cron_update_next_schedule(){
			/*
	UPDATE cron
 SET 
start_time =         IF(
                                        hour_of_day =0,
                                        DATE_FORMAT(CONVERT(DATE_ADD(last_run, INTERVAL interval_seconds SECOND),DATETIME), '%Y-%m-%d %H:%i:00'),

                                        IF( (curdate() + INTERVAL (hour_of_day*60)+minutes MINUTE) > now(),
											(curdate() + INTERVAL (hour_of_day*60)+minutes MINUTE),
											(curdate() + INTERVAL (hour_of_day*60)+minutes+1440 MINUTE)
										)
                                ),
            last_status = 'OK',
            last_status_message = ''
   
    WHERE
            last_status = 'RESCHEDULE'; 


			*/
		}


	   /**
		* Database: Users
		* curriculum_cache_enrollment_per_repeat 
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Curriculum/cache_enrollment_per_repeat.sql
		*
		* @param integer $in_course_id  :IN in_course_id INT
		*/
		public function Users_curriculum_cache_enrollment_per_repeat ($in_course_id){
			/*

			CREATE TEMPORARY TABLE lms2prod.this_course_registration
			SELECT
					course_enrollment_calendar_tree_mv.event_repeat_group_id,
					COUNT(*)	AS 'c'
			FROM
					lms2views.course_enrollment_calendar_tree_mv
			WHERE
					course_id = in_course_id
				AND
					course_enrollment_calendar_tree_mv.day_id = 0
				AND
					course_enrollment_calendar_tree_mv.start_date >= NOW()
				AND
					course_enrollment_calendar_tree_mv.activity_director_status = 'approved'
			GROUP BY
					course_enrollment_calendar_tree_mv.event_repeat_group_id;



			*/
		}


	   /**
		* Database: Users
		* curriculum_get_topics_enrolled 
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Curriculum/get_topic_enrolled.sql
		*
		* @param integer $in_course_enrollment_id  :IN in_course_enrollment_id INT
		*/
		public function Users_curriculum_get_topics_enrolled ($in_course_enrollment_id){
			/*

	SELECT
			event_dates.id									AS 'event_day_id',
			DATE_FORMAT(event_dates.start_date, '%Y-%m-%d') AS 'session_date',
			event_dates_topics.start_time,
			event_dates_topics.end_time,
			event_dates_topics.content_container_id,
			logistics_room.name								AS 'location_info',
			logistics_room.latitude							AS 'latitude',
			logistics_room.longitude						AS 'longitude',
			event_dates_topics.location_room				AS 'room_info',
			logistics_room.comments							AS 'instructions',
			GROUP_CONCAT(CONCAT(rbac_user.first_name,' ',rbac_user.last_name))
															AS 'instructors'
			
			
	FROM
			course_enrollment_topic
		JOIN
			event_dates_topics
		ON
			course_enrollment_topic.topic_id=event_dates_topics.id
		JOIN
			event_dates
		ON
			event_dates_topics.event_date_id=event_dates.id
		LEFT JOIN
			logistics_room
		ON 
			event_dates.location_id = logistics_room.id
		LEFT JOIN
			event_dates_topics_rbac_user
		ON
			event_dates_topics.id = event_dates_topics_rbac_user.event_dates_topics_id
		LEFT JOIN
			rbac_user
		ON
			event_dates_topics_rbac_user.faculty_rbac_user_id = rbac_user.id			

	WHERE
			course_enrollment_topic.course_enrollment_id = in_course_enrollment_id
			
	GROUP BY course_enrollment_topic.id;



			*/
		}


	   /**
		* Database: Users
		* curriculum_home_dashboard 
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Curriculum/home_dashboard.sql
		*
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		*/
		public function Users_curriculum_home_dashboard ($in_rbac_user_id){
			/*
		SELECT 
				course.id				AS 'course_id',
				course.title			AS course_title,
				course.activity_type	AS 'course_activity_type',
				course_enrollment.id	AS 'course_enrollment_id',
				CONCAT(ad.first_name,' ',ad.last_name)	AS `ad_full_name`,
				organization.organization_name,
				(
					SELECT COUNT(*)
					FROM
							course_content
					WHERE 
							course_content.course_id = course.id
				)						AS 'num_content_mandatory',
				
				(
					SELECT COUNT(*)
					FROM
							content_enrollment
					WHERE 
							content_enrollment.course_enrollment_id = course_enrollment.id
						AND
							content_enrollment.content_container_status = 'complete'
				)						AS `num_content_completed`
				
				
		FROM
				course_enrollment
			JOIN
				course
			ON
				course_enrollment.course_id = course.id
			JOIN
				rbac_user ad
			ON
				course.owner_rbac_user_id = ad.id
			JOIN
				organization
			ON
				course.organization_id = organization.id
		WHERE
				student_rbac_user_id = in_rbac_user_id
			AND
				course_enrollment.activity_director_status = 'approved'
			AND
				course_enrollment.manager_status = 'approved'
			AND
				course_status = 'incomplete'
			AND
				course_enrollment.status = 'enabled'
			AND
				(course_enrollment.due_date IS NULL OR DATE(course_enrollment.due_date) >= DATE(NOW()))
		ORDER BY
				course_enrollment.due_date ASC
		LIMIT 6;
	


			*/
		}


	   /**
		* Database: Users
		* curriculum_launcher_external_data_for_transcript
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Curriculum\Launcher\External/data_for_transcript.sql
		*
		* @param integer $in_student_rbac_user_id  :IN in_student_rbac_user_id INT
		* @param string $in_external_course_id  :IN in_external_course_id VARCHAR(255)
		*/
		public function Users_curriculum_launcher_external_data_for_transcript($in_student_rbac_user_id,$in_external_course_id){
			/*
  SELECT
		content.id						AS 'content_id',
		content.content_container_id,
		content.version,
		
		content_enrollment.id					AS 'content_enrollment_id',
		content_enrollment.student_rbac_user_id			AS 'rbac_user_id',
										
		course_enrollment.course_id
		
  FROM
		content
	JOIN
		content_enrollment
	ON
		content.content_container_id = content_enrollment.content_container_id
	JOIN
		course_enrollment
	ON
		content_enrollment.course_enrollment_id = course_enrollment.id
		
  WHERE
		content.launcher_data LIKE in_external_course_id
	AND
		content_enrollment.student_rbac_user_id = in_student_rbac_user_id
		
  ORDER BY
		content_enrollment.id DESC
		
  LIMIT 1;


			*/
		}


	   /**
		* Database: Users
		* curriculum_myeducation_enrollment_event 
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Curriculum\MyEducation/EnrollmentEvent.sql
		*
		* @param integer $in_course_enrollment_id  :IN in_course_enrollment_id INT
		*/
		public function Users_curriculum_myeducation_enrollment_event ($in_course_enrollment_id){
			/*
	SELECT
				DATE_FORMAT(course_enrollment_calendar_tree_mv.start_date,'%c/%e') AS start_date,
				DATE_FORMAT(course_enrollment_calendar_tree_mv.start_date,'%b %e, %Y') AS format_start_date,
				DATE_FORMAT(course_enrollment_calendar_tree_mv.end_date,'%b %e, %Y') AS format_end_date,
				DATE_FORMAT(course_enrollment_calendar_tree_mv.start_date, '%l:%i %p') AS format_start_time,
				DATE_FORMAT(course_enrollment_calendar_tree_mv.end_date, '%l:%i %p') AS format_end_time,
				course_enrollment_calendar_tree_mv.start_date AS start_date_full,
				course_enrollment_calendar_tree_mv.day_id AS event_date_id,
				IFNULL(logistics_room.name,'') AS location,
				IFNULL(course_enrollment_calendar_tree_mv.location_room, '') AS room,
				IFNULL(logistics_room.comments,'') AS location_comments,
				IFNULL(logistics_room.latitude,'') AS location_latitude,
				IFNULL(logistics_room.longitude, '') AS location_longitude
		FROM
				lms2views.course_enrollment_calendar_tree_mv
			LEFT JOIN
				lms2prod.logistics_room
			ON
				course_enrollment_calendar_tree_mv.location_id = logistics_room.id
		WHERE
				course_enrollment_calendar_tree_mv.enrollment_id = in_course_enrollment_id
			AND
				course_enrollment_calendar_tree_mv.day_id <> 0
		GROUP BY
				course_enrollment_calendar_tree_mv.day_id
		ORDER BY
				course_enrollment_calendar_tree_mv.start_date;
 

			*/
		}


	   /**
		* Database: Users
		* curriculum_myeducation_enrollment_posttask 
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Curriculum\MyEducation/EnrollmentPostTask.sql
		*
		* @param integer $in_course_enrollment_id  :IN in_course_enrollment_id INT
		*/
		public function Users_curriculum_myeducation_enrollment_posttask ($in_course_enrollment_id){
			/*
	SELECT
				COUNT(course_task.id) as post_task,	
				SUM(course_task_content.is_mandatory) as required
		FROM
				course_enrollment
			JOIN
				content_enrollment
			ON
				course_enrollment.id = content_enrollment.course_enrollment_id
			JOIN
				course_content
			ON
				content_enrollment.content_container_id = course_content.content_container_id
			AND
				course_enrollment.course_id = course_content.course_id
			JOIN
				course_task
			ON
				course_enrollment.course_id = course_task.course_id
			JOIN
				course_task_content
			ON
				course_task.id = course_task_content.course_task_id
			AND
				course_content.id = course_task_content.course_content_id
		WHERE
				course_task.task_order >= 2000
			AND
				content_enrollment.content_container_status = 'incomplete'
			AND
				course_enrollment.id = in_course_enrollment_id;


			*/
		}


	   /**
		* Database: Users
		* curriculum_myeducation_enrollment_pretask 
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Curriculum\MyEducation/EnrollmentPreTask.sql
		*
		* @param integer $in_course_enrollment_id  :IN in_course_enrollment_id INT
		*/
		public function Users_curriculum_myeducation_enrollment_pretask ($in_course_enrollment_id){
			/*
	SELECT
				COUNT(course_task.id) as pre_task,	
				SUM(course_task_content.is_mandatory) as required
		FROM
				course_enrollment
			JOIN
				content_enrollment
			ON
				course_enrollment.id = content_enrollment.course_enrollment_id
			JOIN
				course_content
			ON
				content_enrollment.content_container_id = course_content.content_container_id
			AND
				course_enrollment.course_id = course_content.course_id
			JOIN
				course_task
			ON
				course_enrollment.course_id = course_task.course_id
			JOIN
				course_task_content
			ON
				course_task.id = course_task_content.course_task_id
			AND
				course_content.id = course_task_content.course_content_id
			JOIN
				course
			ON
				course_enrollment.course_id = course.id
		WHERE
				course_task.task_order BETWEEN 1 AND 999
			AND
				content_enrollment.content_container_status = 'incomplete'
			AND
				course.activity_type IN('Clinical Simulation','Conference','Instructor-led class')
			AND
				course_enrollment.id = in_course_enrollment_id;
 

			*/
		}


	   /**
		* Database: Users
		* data_pusher_get_activity_coordinators 
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\DataPusher/get_activity_coordinator.sql
		*
		* @param integer $in_course_id  :IN in_course_id INT
		*/
		public function Users_data_pusher_get_activity_coordinators ($in_course_id){
			/*

	SELECT DISTINCT
			CONCAT(rbac_user.first_name,' ',rbac_user.last_name)	AS 'full_name',
			rbac_user.username
			
	FROM
			rbac_user
		JOIN
			course_role
		ON
			rbac_user.id = course_role.rbac_user_id
			
	WHERE
			course_role.course_id = in_course_id
		AND
			role_id = 6;


			*/
		}


	   /**
		* Database: Users
		* data_pusher_get_certificates
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\DataPusher/get_certificates.sql
		*
		* @param integer $in_course_id  :IN in_course_id INT
		*/
		public function Users_data_pusher_get_certificates($in_course_id){
			/*

	SELECT
			course_certificate.id				AS 'certificate_lms_id',
			course_certificate.certificate_id	AS 'certificate_generic_id',
			course_certificate.number_of_credits,
			certificate.certificate_name
	FROM
			course_certificate
		JOIN
			certificate
		ON
			course_certificate.certificate_id=certificate.id
	
	WHERE
			course_certificate.course_id=in_course_id
		AND
			course_certificate.status='enabled'
		AND
			certificate.status='enabled';


			*/
		}


	   /**
		* Database: Users
		* data_pusher_get_curriculum 
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\DataPusher/get_curriculum.sql
		*
		* @param integer $in_course_id  :IN in_course_id INT
		*/
		public function Users_data_pusher_get_curriculum ($in_course_id){
			/*

	SELECT
			course_task.id 									AS task_id,
			course_task.task_order,
			course_task.number_content_complete,
			course_task.task_name,
			course_task_content.id 							AS task_content_id,
			course_task_content.is_mandatory,
			course_content.passing_score,
			course_content.id 								AS course_content_id,
			course_content.show_score,
			course_content.number_of_attempts,
			course_content.when_do,
			course_content.valid_after,
			course_content.take_content_evaluation,
			course_content.move_to_evaluation,
			course_content.content_container_id,
			course_content.trigger_completion_course_content_id,
			content_container.name 							AS container_name,
			content_container.description,
			content_container.delivery_type,
			content_container.content_container_status		AS 'content_container_published_status',
			content_container.content_type,
			content_container.has_return_demo,
			content_container.version,
			content.file_upload_id,
			processing_type,
			CONCAT(first_name,' ',last_name)				AS 'faculty'
			
	FROM
			course_task
		JOIN
			course_task_content
		ON
			course_task.id = course_task_content.course_task_id
		JOIN
			course_content
		ON
			course_task_content.course_content_id=course_content.id
		JOIN
			content_container
		ON
			course_content.content_container_id=content_container.id
		JOIN
			rbac_user
		ON
			content_container.rbac_user_id = rbac_user.id
		LEFT JOIN
			content
		ON
			(content.content_container_id = content_container.id AND content_container.delivery_type = 'live')
			
	WHERE
			course_task.course_id = in_course_id
		
	ORDER BY
			course_task.task_order,course_task_content.rec_order,course_task_content.id;



			*/
		}


	   /**
		* Database: Users
		* data_pusher_get_dates_data 
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\DataPusher/get_dates_data.sql
		*
		* @param integer $in_course_id  :IN in_course_id INT
		*/
		public function Users_data_pusher_get_dates_data ($in_course_id){
			/*

	SELECT 	MIN(event_dates.id)				AS 'id',
			MIN(start_date)					AS 'start_date',
			COUNT(DISTINCT event_dates.id)						AS 'duration',
			logistics_room.name				AS 'location_name',
			logistics_room.address_1		AS 'location_address_1',
			logistics_room.address_2		AS 'location_address_2',
			logistics_room.title			AS 'location_title',
			logistics_room.city				AS 'location_city',
			logistics_room.state			AS 'location_state',
			logistics_room.zipcode			AS 'location_zipcode'
			
	FROM 
			event_dates
		JOIN
			event_dates_topics
		ON
			event_dates.id=event_dates_topics.event_date_id
		LEFT JOIN
			logistics_room
		ON 
			event_dates.location_id = logistics_room.id
	WHERE
			event_dates.course_id = in_course_id
	GROUP BY
			event_dates.event_repeat_group_id
	HAVING 
			-- MIN(start_date)>NOW()
			MAX(end_date)>=NOW()
			
	ORDER BY start_date ASC;



			*/
		}


	   /**
		* Database: Users
		* data_pusher_get_target_audience 
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\DataPusher/get_target_audience.sql
		*
		* @param integer $in_course_id  :IN in_course_id INT
		*/
		public function Users_data_pusher_get_target_audience ($in_course_id){
			/*

	SELECT DISTINCT
			lut_position.name
			
	FROM
			lut_position
		JOIN
			course_target
		ON
			lut_position.id = course_target.target_id
	
	WHERE
			course_target.course_id = in_course_id
		AND
			course_target.target_source = 'position';


			*/
		}


	   /**
		* Database: Users
		* expire_auto_enroll 
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\enrollment/expire_auto_enroll.sql
		*
		* @param integer $c_id  :IN c_id INT
		*/
		public function Users_expire_auto_enroll ($c_id){
			/*
	-- UPDATE 
	--		`course` 
	-- SET 
	--		`expiration_date` = NOW()
	-- WHERE
	--		id = c_id;
	
	UPDATE
			`course_auto_enrollment`
	SET
			`auto_enrollment_end_date` = DATE_SUB(NOW(), INTERVAL 1 DAY)
	WHERE
			course_id = c_id
		AND
			`auto_enrollment_end_date` >= DATE_SUB(NOW(), INTERVAL 1 DAY);


			*/
		}


	   /**
		* Database: Users
		* update_auto_enroll_end_date 
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\enrollment/update_auto_enroll_end_date.sql
		*
		* @param integer $c_id  :IN c_id INT
		* @param string $new_end_date  :IN new_end_date TIMESTAMP
		*/
		public function Users_update_auto_enroll_end_date ($c_id,$new_end_date){
			/*
	-- INSERT INTO cron_events_manager (cron_id,params)
	-- VALUES (21, CONCAT('{"course_id":"',c_id,'"}'));
	UPDATE course_auto_enrollment
	SET auto_enrollment_end_date = new_end_date
	WHERE auto_enrollment_end_date >= new_end_date
	AND course_id = c_id;
 

			*/
		}


	   /**
		* Database: Users
		* pending_department_approval_dh
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Manager\Department\Email/pending_department_approval_dh.sql
		*
		*/
		public function Users_pending_department_approval_dh(){
			/*
 	SELECT
			organization_department.id AS dep,
			organization_department.organization_id AS org,
			organization_department.rbac_user_id AS DH
	FROM
			organization_department
		JOIN
			organization_user_enrollment
		ON
			organization_department.id = organization_user_enrollment.organization_department_id
		JOIN
			organization
		ON
			organization_department.organization_id = organization.id
	WHERE
			organization_user_enrollment.status = 'pending'
		AND
			organization.auto_approve = 0
		AND
			organization.id NOT IN(13,0)
	GROUP BY
			organization_department.id;


			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_admin_statistics_build_all
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Admin\Statistics/build_all.sql
		*
		* @param integer $in_type  :IN in_type ENUM('full''day')
		*/
		public function Users_reportsBuilder_admin_statistics_build_all($in_type){
			/*
	CALL reportsBuilder_admin_statistics_course_enrollment(in_type);
	CALL reportsBuilder_admin_statistics_login(in_type);
	CALL reportsBuilder_admin_statistics_launcher(in_type);


			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_admin_statistics_course_enrollment
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Admin\Statistics/course_enrollment.sql
		*
		* @param integer $in_type  :IN in_type ENUM('full''day')
		*/
		public function Users_reportsBuilder_admin_statistics_course_enrollment($in_type){
			/*
	-- PRESTON COMMENTS
	SET @date := '0000-00-00';
	SET @max_date := DATE(CURRENT_TIMESTAMP - INTERVAL 1 DAY);

	-- PRESTON COMMENTS
	IF in_type = 'full' THEN
		TRUNCATE TABLE data_whurehouse.reports_admin_statistics_course_enrollment;
		
	ELSEIF in_type = 'day' THEN
		SELECT @date := DATE(CONCAT(iyear,'-',imonth,'-',iday)) + INTERVAL 1 DAY 
		FROM data_whurehouse.reports_admin_statistics_course_enrollment 
		ORDER BY 
				iyear DESC,
				imonth DESC,
				iday DESC 
		LIMIT 1;
		
	 IF;

	-- PRESTON COMMENTS
	INSERT INTO data_whurehouse.reports_admin_statistics_course_enrollment
			SELECT
					DATE_FORMAT(course_enrollment.enrollment_date,'%Y'),
					DATE_FORMAT(course_enrollment.enrollment_date,'%m'),
					DATE_FORMAT(course_enrollment.enrollment_date,'%d'),
					course_enrollment.organization_id,
					course_enrollment.course_id,
					IF(course.activity_type = 'On Demand', 'On Demand',
							IF(course.activity_type IN('Clinical Simulation','Conference','Instructor-led class'),'Live','Content')) AS aggr_activity_type,
					course_enrollment.course_status,
					course_enrollment_rollout.type,
					COUNT(course_enrollment.id)
			FROM
					lms2prod.course_enrollment
				JOIN
					lms2prod.course
				ON
					course_enrollment.course_id = course.id
				JOIN
					lms2prod.course_enrollment_invoice
				ON
					course_enrollment.course_enrollment_invoice_id = course_enrollment_invoice.id
				JOIN
					lms2prod.course_enrollment_rollout
				ON
					course_enrollment_invoice.course_enrollment_rollout_id = course_enrollment_rollout.id
			WHERE
					course_enrollment.status IN('enabled','archived')
				AND
					course_enrollment.enrollment_date BETWEEN @date AND @max_date
			GROUP BY
					DATE(course_enrollment.enrollment_date),
					course_enrollment.organization_id,
					course_enrollment.course_id,
					aggr_activity_type,
					course_enrollment_rollout.type,
					course_enrollment.course_status;
	


			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_admin_statistics_launcher
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Admin\Statistics/launcher.sql
		*
		* @param integer $in_type  :IN in_type ENUM('full''day')
		*/
		public function Users_reportsBuilder_admin_statistics_launcher($in_type){
			/*
	-- PRESTON COMMENTS
	SET @date := '0000-00-00';
	SET @max_date := DATE(CURRENT_TIMESTAMP - INTERVAL 1 DAY);
	
	-- PRESTON COMMENTS
	IF in_type = 'full' THEN
		TRUNCATE TABLE data_whurehouse.reports_admin_statistics_launcher;
	
	ELSEIF in_type = 'day' THEN
		SELECT @date := DATE(CONCAT(iyear,'-',imonth,'-',iday)) + INTERVAL 1 DAY
		FROM data_whurehouse.reports_admin_statistics_launcher 
		ORDER BY 
				iyear DESC,
				imonth DESC,
				iday DESC 
		LIMIT 1;
	
	 IF;

	
	-- PRESTON COMMENTS
	INSERT INTO data_whurehouse.reports_admin_statistics_launcher
		SELECT
				DATE_FORMAT(content_transcript_log.date_created, '%Y'),
				DATE_FORMAT(content_transcript_log.date_created, '%m'),
				DATE_FORMAT(content_transcript_log.date_created, '%d'),
				content_transcript_log.content_container_id,
				content_transcript_log.content_status,
				COUNT(content_transcript_log.id)
		FROM
				lms2prod.content_transcript_log
		WHERE
				content_transcript_log.status = 'enabled'
			AND
				content_transcript_log.date_created BETWEEN @date AND @max_date
		GROUP BY
				DATE(content_transcript_log.date_created),
				content_transcript_log.content_container_id,
				content_transcript_log.content_status;


			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_admin_statistics_login
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Admin\Statistics/login.sql
		*
		* @param integer $in_type  :IN in_type ENUM('full''day')
		*/
		public function Users_reportsBuilder_admin_statistics_login($in_type){
			/*
	
	-- PRESTON TO PUT COMMENTS!
	SET @date := '0000-00-00';
	SET @max_date := DATE(CURRENT_TIMESTAMP - INTERVAL 1 DAY);
	
	-- PRESTON TO PUT COMMENTS!
	IF in_type = 'full' THEN
		TRUNCATE TABLE data_whurehouse.reports_admin_statistics_login;
	
	ELSEIF in_type = 'day' THEN
		SELECT @date := DATE(CONCAT(iyear,'-',imonth,'-',iday)) + INTERVAL 1 DAY 
		FROM data_whurehouse.reports_admin_statistics_login 
		ORDER BY
				iyear DESC,
				imonth DESC,
				iday DESC 
		LIMIT 1;
	 IF;
	
	-- PRESTON TO PUT COMMENTS!
	INSERT INTO data_whurehouse.reports_admin_statistics_login
		SELECT
				DATE_FORMAT(login_log.date_created, '%Y'),
				DATE_FORMAT(login_log.date_created, '%m'),
				DATE_FORMAT(login_log.date_created, '%d'),
				DATE_FORMAT(login_log.date_created, '%H'),
				login_log.organization_id,
				COUNT(login_log.id)
		FROM
				(SELECT
						rbac_user_login_log.id,				
						organization_user_enrollment.organization_id,
						rbac_user_login_log.date_created
				FROM
						lms2prod.rbac_user_login_log
					JOIN
						lms2prod.organization_user_enrollment
					ON
						rbac_user_login_log.rbac_user_id = organization_user_enrollment.rbac_user_id
				WHERE
						organization_user_enrollment.organization_id NOT IN(1,30,35)
				GROUP BY
						rbac_user_login_log.id) AS login_log
		WHERE
				login_log.date_created BETWEEN @date AND @max_date
		GROUP BY
				DATE_FORMAT(login_log.date_created, '%Y-%m-%d %H'),
				login_log.organization_id;


			*/
		}


	   /**
		* Database: Users
		* reports_admin_user_org_normalized_usage
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Admin\users/org_normalized_usage.sql
		*
		*/
		public function Users_reports_admin_user_org_normalized_usage(){
			/*

	SELECT
			organization.id,
			organization_name,
			COUNT(DISTINCT rbac_user_login_log.rbac_user_id) AS 'system_usage',
			COUNT(DISTINCT organization_user_enrollment.rbac_user_id) AS 'total_users'
	FROM
			organization_user_enrollment
		JOIN
			organization
		ON
			organization_user_enrollment.organization_id = organization.id
		LEFT JOIN
			rbac_user_login_log
		ON
			rbac_user_login_log.rbac_user_id = organization_user_enrollment.rbac_user_id

			
	WHERE
			organization_user_enrollment.rbac_user_id > 1000
		AND
			organization.id NOT IN(1,13,35,25,30)
			
			
	GROUP BY
			organization.id
	ORDER BY 
			system_usage DESC;
			


			*/
		}


	   /**
		* Database: Users
		* reports_admin_user_usage
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Admin\users/usage.sql
		*
		* @param integer $in_page  :IN in_page INT
		* @param integer $in_size  :IN in_size INT
		*/
		public function Users_reports_admin_user_usage($in_page,$in_size){
			/*
	SELECT
			first_name,
			last_name,
			COUNT(*) AS 'system_usage' 
	FROM
			rbac_user_login_log
			
		JOIN
			rbac_user
		ON
			rbac_user_id = rbac_user.id
	WHERE
			rbac_user_id > 1000
	GROUP BY
			rbac_user_id
	ORDER BY 
			system_usage DESC
	LIMIT
			in_page,in_size;


			*/
		}


	   /**
		* Database: Users
		* reports_admin_user_enrollments_org_normalized_usage
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Admin\users\enrollments/org_normalized_usage.sql
		*
		*/
		public function Users_reports_admin_user_enrollments_org_normalized_usage(){
			/*
	CREATE TEMPORARY TABLE tmp_enrollment_org_usage
	SELECT
			organization.id,
			organization.organization_name,
			COUNT(DISTINCT course_id)				AS 'courses_being_used',
			COUNT(DISTINCT student_rbac_user_id)	AS 'users_enrolled_to_courses'
			
	FROM
			course_enrollment
		JOIN
			course
		ON
			course_enrollment.course_id = course.id
		JOIN
			organization
		ON
			course_enrollment.organization_id = organization.id
			
	WHERE
			(course.created_by > 199 OR course.created_by < 101) 
		AND
			(course_enrollment.created_by > 199 OR course_enrollment.created_by < 101)
		AND
			course_enrollment.status IN ('enabled','archived')
		AND
			course.publish_status IN ('Active','Expire')
		AND
			course.activity_type IN ('On Demand','Clinical Simulation','Conference','Instructor-led class')
		AND
			organization.id NOT IN(1,13,35,25,30)

			
	GROUP BY
			organization.id
	;
	

	SELECT 
			*,
			(	SELECT 
						COUNT(*) 
				FROM
						course
				WHERE
						course.organization_id = tmp_enrollment_org_usage.id
					AND
						course.publish_status IN ('Active','Expire')
					AND
						course.activity_type IN ('On Demand','Clinical Simulation','Conference','Instructor-led class')) 
																												AS 'courses_created_for',
			(	SELECT 
						COUNT(DISTINCT student_rbac_user_id) 
				FROM
						course_enrollment
					JOIN
						course
					ON
						course_enrollment.course_id = course.id
				WHERE
						(course.created_by > 199 OR course.created_by < 101) 
					AND
						(course_enrollment.created_by > 199 OR course_enrollment.created_by < 101)
					AND
						course_enrollment.organization_id = tmp_enrollment_org_usage.id
					AND
						course_status ='complete'
					AND
						course_enrollment.status IN ('enabled','archived')
					AND
						course.publish_status IN ('Active','Expire')
					AND
						course.activity_type IN ('On Demand','Clinical Simulation','Conference','Instructor-led class')
						
			) 																									AS 'users_completed_courses'
	FROM tmp_enrollment_org_usage;
		


			*/
		}


	   /**
		* Database: Users
		* reports_admin_user_enrollments_summaries
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Admin\users\enrollments/summaries.sql
		*
		*/
		public function Users_reports_admin_user_enrollments_summaries(){
			/*
	CREATE TEMPORARY TABLE tmp_admin_enrollment_reports
	SELECT
			course_id,
			student_rbac_user_id,
			course_status
	FROM
			course_enrollment
		JOIN
			course
		ON
			course_enrollment.course_id = course.id
			
	WHERE
			(course.created_by > 199 OR course.created_by < 101) 
		AND
			(course_enrollment.created_by > 199 OR course_enrollment.created_by < 101)
		AND
			course_enrollment.status IN ('enabled','archived')
		AND
			course.publish_status IN ('Active','Expire')
		AND
			course.activity_type IN ('On Demand','Clinical Simulation','Conference','Instructor-led class')
		AND
			course_enrollment.organization_id NOT IN(1,13,35,25,30)

	;
	
	SELECT COUNT(*) INTO @total_enrollments FROM tmp_admin_enrollment_reports;
	SELECT COUNT(DISTINCT course_id) INTO @distinct_courses_with_enrollments FROM tmp_admin_enrollment_reports;
	SELECT COUNT(DISTINCT student_rbac_user_id) INTO @distinct_users_with_enrollments FROM tmp_admin_enrollment_reports;
	SELECT COUNT(*) INTO @courses FROM course WHERE		(course.created_by > 199 OR course.created_by < 101)
													AND
														course.publish_status IN ('Active','Expire')
													AND
														course.activity_type IN ('On Demand','Clinical Simulation','Conference','Instructor-led class')
													AND
														organization_id NOT IN(1,13,35,25,30);
														
														
	SELECT 
		@total_enrollments AS 'total_enrollments',
		@distinct_courses_with_enrollments AS 'distinct_courses_with_enrollments',
		@distinct_users_with_enrollments AS 'distinct_users_with_enrollments',
		@courses AS 'courses';
		


			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_manage_all_content_actual
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Drilldowns\Content/manage_all_content_actual.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_manage_all_content_actual($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*
	
	-- Lockdown
	CALL reports_start_semaphore(in_organization_id,in_rbac_user_id,in_entity_id,'reportsBuilder_manage_all_content_actual');

	-- Delete previeous report for this user/org
	IF in_entity_id = 0  THEN
	
		DELETE FROM data_whurehouse.reports_user_standard_manage_all_content
		WHERE rbac_user_id = in_rbac_user_id AND organization_id = in_organization_id;
		
	ELSE
	
		DELETE FROM data_whurehouse.reports_user_standard_manage_all_content
		WHERE rbac_user_id = in_rbac_user_id AND organization_id = in_organization_id AND wrapper_course_id = in_entity_id;
		
	 IF;
	
	-- MAIN QUERY
	
	INSERT INTO data_whurehouse.reports_user_standard_manage_all_content
	(	rbac_user_id,
		organization_id,
		content_container_id,
		date_created,
		wrapper_course_id,
		content_title,
		content_type,
		faculty_rbac_user_id,
		faculty_name,
		enrolled,
		complete,
		average_final_score,
		average_time_to_complete
	)
	
		SELECT
			in_rbac_user_id,
			in_organization_id,
			content_container.id,
			NOW(),
			course.id,
			content_container.name,
			course.activity_type,
			rbac_user.id,
			CONCAT(rbac_user.first_name,' ',rbac_user.last_name),
			COUNT(reports_user_standard_manage_all_content_enrollments.student_rbac_user_id),
			SUM(IF(reports_user_standard_manage_all_content_enrollments.completion_status='complete',1,0)),
			SUM(reports_user_standard_manage_all_content_enrollments.final_score)/
				SUM(IF(reports_user_standard_manage_all_content_enrollments.completion_status='complete',1,0)), -- to exclude users who did not complete from avg calc
			NULL -- For now I calculate this in the report itself. as I do not wish to do cursors right now.
		
		FROM 
				content_container
			JOIN
				course_content
			ON
				content_container.id = course_content.content_container_id
			JOIN
				course
			ON
				course_content.course_id = course.id
			JOIN
				data_whurehouse.reports_user_standard_manage_all_content_enrollments
			ON
				content_container.id = reports_user_standard_manage_all_content_enrollments.content_container_id
			JOIN
				rbac_user
			ON
				content_container.rbac_user_id = rbac_user.id						
			
			WHERE
					((in_entity_id>0 AND course.id = in_entity_id) OR in_entity_id = 0)
				AND
					course.activity_type IN ('content_wrapper_education','content_wrapper_quiz')
				AND
					reports_user_standard_manage_all_content_enrollments.organization_id = in_organization_id
				AND
					reports_user_standard_manage_all_content_enrollments.rbac_user_id = in_rbac_user_id
			
			GROUP BY
					content_container.id;
	
	-- release lockdown
	CALL reports_release_semaphore(in_organization_id,in_rbac_user_id,in_entity_id,'reportsBuilder_manage_all_content_actual');

	-- CALL DEPENCIES!!!!
	SELECT 'no-depnedencies' INTO out_drilldowns;
	





					

			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_manage_all_content_enrollments
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Drilldowns\Content/manage_all_enrollments.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_manage_all_content_enrollments($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*
	
	-- Lockdown
	CALL reports_start_semaphore(in_organization_id,in_rbac_user_id,in_entity_id,'reportsBuilder_manage_all_content_enrollments');
	
	-- Delete previeous report for this user/org
	IF in_entity_id = 0  THEN
	
		DELETE FROM data_whurehouse.reports_user_standard_manage_all_content_enrollments
		WHERE rbac_user_id = in_rbac_user_id AND organization_id = in_organization_id;
		
	ELSE
	
		DELETE FROM data_whurehouse.reports_user_standard_manage_all_content_enrollments
		WHERE rbac_user_id = in_rbac_user_id AND organization_id = in_organization_id AND course_id = in_entity_id;
		
	 IF;
	
	-- We have different queries to fetch data for RA or other manager
	
	CALL is_user_ra(in_organization_id,in_rbac_user_id,@is_ra);
	
	IF @is_ra>0 THEN

		INSERT INTO data_whurehouse.reports_user_standard_manage_all_content_enrollments
		(	id,
			rbac_user_id,
			organization_id,
			date_created,
			content_container_id,
			course_id,
			transcript_group_id,
			course_enrollment_id,
			student_rbac_user_id,
			last_name,
			first_name,
			email,
			position,
			department_name,
			department_code,
			edu_group_name,
			pre_test_score,
			final_score,
			completion_status,
			enrollment_date,
			date_completed
		)
		
			SELECT
					null,
					in_rbac_user_id,
					in_organization_id,
					NOW(),
					content_enrollment.content_container_id,
					course_enrollment.course_id,
					transcript_group_id,
					course_enrollment.id,
					content_enrollment.student_rbac_user_id,
					rbac_user.last_name,
					rbac_user.first_name,
					rbac_user.username,
					organization_position.name,
					organization_department.name,
					organization_department.code,
					null,
					content_enrollment.pretest_score,
					content_enrollment.final_score,
					content_enrollment.content_container_status,
					course_enrollment.enrollment_date,
					content_enrollment.content_container_date_completed
			
			FROM 
					course_enrollment
				JOIN
					content_enrollment
				ON
					course_enrollment.id = content_enrollment.course_enrollment_id 
				JOIN
					rbac_user
				ON
					course_enrollment.student_rbac_user_id = rbac_user.id
				JOIN
					organization_user_enrollment
				ON
					course_enrollment.student_rbac_user_id = organization_user_enrollment.rbac_user_id
					AND
					organization_user_enrollment.organization_id = in_organization_id
				JOIN
					organization_department
				ON
					organization_user_enrollment.organization_department_id = organization_department.id 
				LEFT JOIN
					organization_position
				ON
					organization_user_enrollment.organization_position_id = organization_position.id
	
				WHERE
						((in_entity_id>0 AND course_enrollment.course_id = in_entity_id) OR in_entity_id = 0)
					AND
						course_enrollment.organization_id = in_organization_id
					AND
						course_enrollment.status <> 'canceled'
					AND
						course_enrollment.activity_director_status <> 'rejected'
					AND
						course_enrollment.manager_status <> 'rejected';
					
		
						
	ELSE

	
	
		INSERT INTO data_whurehouse.reports_user_standard_manage_all_content_enrollments
		(	id,
			rbac_user_id,
			organization_id,
			date_created,
			content_container_id,
			course_id,
			transcript_group_id,
			course_enrollment_id,
			student_rbac_user_id,
			last_name,
			first_name,
			email,
			position,
			department_name,
			department_code,
			edu_group_name,
			pre_test_score,
			final_score,
			completion_status,
			enrollment_date,
			date_completed
		)
		
			SELECT
					null,
					in_rbac_user_id,
					in_organization_id,
					NOW(),
					content_enrollment.content_container_id,
					course_enrollment.course_id,
					transcript_group_id,
					course_enrollment.id,
					content_enrollment.student_rbac_user_id,
					rbac_user.last_name,
					rbac_user.first_name,
					rbac_user.username,
					organization_position.name,
					organization_department.name,
					organization_department.code,
					null,
					content_enrollment.pretest_score,
					content_enrollment.final_score,
					content_enrollment.content_container_status,
					course_enrollment.enrollment_date,
					content_enrollment.content_container_date_completed
			
			FROM 
					course_enrollment
				JOIN
					content_enrollment
				ON
					course_enrollment.id = content_enrollment.course_enrollment_id 
				JOIN
					rbac_user
				ON
					course_enrollment.student_rbac_user_id = rbac_user.id
				JOIN
					organization_user_enrollment
				ON
					course_enrollment.student_rbac_user_id = organization_user_enrollment.rbac_user_id
					AND
					organization_user_enrollment.organization_id = in_organization_id
				JOIN
					organization_department
				ON
					organization_user_enrollment.organization_department_id = organization_department.id 
				LEFT JOIN
					organization_position
				ON
					organization_user_enrollment.organization_position_id = organization_position.id
	
				WHERE
						((in_entity_id>0 AND course_enrollment.course_id = in_entity_id) OR in_entity_id = 0)
					AND
						course_enrollment.organization_id = in_organization_id
					AND
						course_enrollment.status <> 'canceled'
					AND
						course_enrollment.activity_director_status <> 'rejected'
					AND
						course_enrollment.manager_status <> 'rejected'
					AND
						course_enrollment.student_rbac_user_id IN(
							SELECT organization_user_enrollment.rbac_user_id
							FROM 
									organization_user_enrollment
								JOIN
									organization_department
								ON
									organization_user_enrollment.organization_department_id = organization_department.id
								LEFT JOIN
									organization_department_proxy
								ON
									organization_department.id = organization_department_proxy.organization_department_id
							WHERE
									organization_department.organization_id = in_organization_id
								AND
									(
									organization_department.rbac_user_id = in_rbac_user_id
									OR
									organization_department_proxy.rbac_user_id = in_rbac_user_id
									)
					);
						


	 IF;
		
	-- release lockdown
	CALL reports_release_semaphore(in_organization_id,in_rbac_user_id,in_entity_id,'reportsBuilder_manage_all_content_enrollments');

	-- CALL DEPENCIES!!!!
	SELECT 'no-depnedencies' INTO out_drilldowns;
	



			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_educator_all_content_enrollments
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Educator\Content/all_enrollments.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_educator_all_content_enrollments($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*
	
	-- Lockdown
	CALL reports_start_semaphore(0,in_rbac_user_id,in_entity_id,'reportsBuilder_educator_all_content_enrollments');
	
	-- Delete previeous report for this user/org
	
	IF in_entity_id = 0  THEN
	
		DELETE FROM data_whurehouse.reports_user_standard_educator_all_content_enrollments
		WHERE rbac_user_id = in_rbac_user_id;
		
	ELSE
	
		DELETE FROM data_whurehouse.reports_user_standard_educator_all_content_enrollments
		WHERE rbac_user_id = in_rbac_user_id AND course_id = in_entity_id;
		
	 IF;
	
	-- We have different queries to fetch data for RA or other manager
	
		INSERT INTO data_whurehouse.reports_user_standard_educator_all_content_enrollments
		(	id,
			rbac_user_id,
			organization_id,
			date_created,
			content_container_id,
			course_id,
			course_content_type,
			transcript_group_id,
			course_enrollment_id,
			student_rbac_user_id,
			last_name,
			first_name,
			email,
			position,
			department_name,
			department_code,
			edu_group_name,
			pre_test_score,
			final_score,
			completion_status,
			enrollment_date,
			date_completed
		)
		
			SELECT
					null,
					in_rbac_user_id,
					in_organization_id,
					NOW(),
					content_enrollment.content_container_id,
					course_enrollment.course_id,
					course_content.content_type,
					transcript_group_id,
					course_enrollment.id,
					content_enrollment.student_rbac_user_id,
					rbac_user.last_name,
					rbac_user.first_name,
					rbac_user.username,
					organization_position.name,
					organization_department.name,
					organization_department.code,
					null,
					content_enrollment.pretest_score,
					content_enrollment.final_score,
					content_enrollment.content_container_status,
					course_enrollment.enrollment_date,
					content_enrollment.content_container_date_completed
			
			FROM
					course
				JOIN
					course_enrollment
				ON
					course.id = course_enrollment.course_id
				JOIN
					content_enrollment
				ON
					course_enrollment.id = content_enrollment.course_enrollment_id 
				JOIN
					course_content
				ON
					course.id = course_content.course_id 
					AND
					content_enrollment.content_container_id = course_content.content_container_id
				JOIN
					rbac_user
				ON
					course_enrollment.student_rbac_user_id = rbac_user.id
				LEFT JOIN
					organization_user_enrollment
				ON
					course_enrollment.student_rbac_user_id = organization_user_enrollment.rbac_user_id
					AND
					course_enrollment.organization_id = organization_user_enrollment.organization_id 
				LEFT JOIN
					organization_department
				ON
					organization_user_enrollment.organization_department_id = organization_department.id
					
				LEFT JOIN
					organization_position
				ON
					organization_user_enrollment.organization_position_id = organization_position.id

				WHERE
						((in_entity_id>0 AND course.id = in_entity_id) OR in_entity_id = 0)
					AND
						course_enrollment.activity_director_status <> 'rejected'
					AND
						course_enrollment.manager_status <> 'rejected'
					AND
						course_enrollment.status <> 'canceled'
					AND
						(
							course.owner_rbac_user_id = in_rbac_user_id
						OR
							course.id IN (
								SELECT
										course_id
								FROM 
										course_role
								WHERE 
										course_role.rbac_user_id = in_rbac_user_id
									AND
										course_role.role_id = 6						
							)
						)
						
				ORDER BY
						content_enrollment.content_container_id;
	
	-- release lockdown
	CALL reports_release_semaphore(0,in_rbac_user_id,in_entity_id,'reportsBuilder_educator_all_content_enrollments');

	-- CALL DEPENCIES!!!!
	SELECT 'no-depnedencies' INTO out_drilldowns;
	


			*/
		}


	   /**
		* Database: Users
		* reports_miniset_live_sessions
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Educator\Content/live_sessions_miniset.sql
		*
		* @param integer $in_course_id  :IN in_course_id INT
		*/
		public function Users_reports_miniset_live_sessions($in_course_id){
			/*
 	SELECT
 		DISTINCT
 		content_container.id,
 		content_container.name,
 		content_container.has_return_demo
 	FROM
 			course_content
 		JOIN
 			content_container
 		ON
 			course_content.content_container_id = content_container.id
 		JOIN
 			course_task_content
 		ON
 			course_content.id = course_task_content.course_content_id 
 	WHERE
 			course_id = in_course_id
 		AND
 			course_content.content_type = 'Live Content'
 		AND
 			course_content.status = 'enabled';	
	


			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_educator_all_courses
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Educator\Course/all_courses.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_educator_all_courses($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*
	
	-- CALL DEPENCIES!!!!
	SELECT 'reportsBuilder_educator_all_content_enrollments,reportsBuilder_educator_all_enrollments,reportsBuilder_educator_all_courses_actual,reportsBuilder_educator_all_course_content' INTO out_drilldowns;
	
	


			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_educator_all_courses_actual
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Educator\Course/all_courses_actual.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_educator_all_courses_actual($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*
	
	-- Lockdown
	CALL reports_start_semaphore(0,in_rbac_user_id,in_entity_id,'reportsBuilder_educator_all_courses_actual');

	-- Delete previeous report for this user/org
	IF in_entity_id = 0  THEN
	
		DELETE FROM data_whurehouse.reports_user_standard_educator_all_courses
		WHERE rbac_user_id = in_rbac_user_id;
		
	ELSE
	
		DELETE FROM data_whurehouse.reports_user_standard_educator_all_courses
		WHERE rbac_user_id = in_rbac_user_id AND course_id = in_entity_id;
		
	 IF;
	
	
	INSERT INTO data_whurehouse.reports_user_standard_educator_all_courses
	(	rbac_user_id,
		organization_id,
		date_created,
		course_id,
		course_title,
		date_course_created,
		activity_type,
		role_id,
		no_of_dates,
		no_of_ond_modules,
		enrolled,
		complete,
		pretest_completed,
		posttest_completed,
		evaluation_completed,
		publish_status,
		certificate_printed,
		credit_offered)
	
		SELECT
				in_rbac_user_id,
				in_organization_id,
				NOW(),
				course.id,
				course.title,
				course.date_created,
				course.activity_type,
				IF(in_rbac_user_id = course.owner_rbac_user_id,5,6),
				0,
				0,
				COUNT(DISTINCT reports_user_standard_educator_all_enrollments.id),
				
				0, -- ***************** how many completed,., maybe after ... SUM(IF(reports_user_standard_educator_all_enrollments.course_completion_status='complete',1,0)),
				
				SUM(IF(content_enrollment.content_container_status='complete' AND course_content.content_type = 'Pretest',1,0)),
				SUM(IF(content_enrollment.content_container_status='complete' AND course_content.content_type = 'Post Test',1,0)),
				SUM(IF(content_enrollment.content_container_status='complete' AND course_content.content_type = 'Evaluation',1,0)),
				course.publish_status,
				0,
				0
				
		
		FROM 
				course
			LEFT JOIN
				data_whurehouse.reports_user_standard_educator_all_enrollments
			ON
				reports_user_standard_educator_all_enrollments.rbac_user_id = in_rbac_user_id
				AND
				reports_user_standard_educator_all_enrollments.organization_id = in_organization_id
				AND
				reports_user_standard_educator_all_enrollments.course_id = course.id
			LEFT JOIN -- We have a bug? where content enrollment are created ONLY after course is launched
				content_enrollment
			ON
				reports_user_standard_educator_all_enrollments.course_enrollment_id = content_enrollment.course_enrollment_id
			LEFT JOIN
				course_content
			ON
				 content_enrollment.content_container_id = course_content.content_container_id
				 AND
				 course_content.course_id = course.id
			
		WHERE
				((in_entity_id>0 AND course.id = in_entity_id) OR in_entity_id = 0)
			AND
				course.activity_type NOT IN('content_wrapper_education','content_wrapper_quiz','content_wrapper_survey','content_wrapper_survey_template','generic')
			AND
				(
					course.owner_rbac_user_id = in_rbac_user_id
				OR
					course.id IN (
						SELECT
								course_id
						FROM 
								course_role
						WHERE 
								course_role.rbac_user_id = in_rbac_user_id
							AND
								course_role.role_id = 6						
					)
				)
				
		GROUP BY
				course.id;

				
				
		-- calculate completion
		
				
				
		UPDATE
				data_whurehouse.reports_user_standard_educator_all_courses
		SET
				complete = (SELECT COUNT(id)
							FROM data_whurehouse.reports_user_standard_educator_all_enrollments
							WHERE 
									reports_user_standard_educator_all_enrollments.course_id = reports_user_standard_educator_all_courses.course_id
								AND
									reports_user_standard_educator_all_enrollments.course_completion_status = 'complete'
								AND
									reports_user_standard_educator_all_enrollments.rbac_user_id = in_rbac_user_id
									),
									
									
				average_time_to_complete = (SELECT AVG(reports_user_standard_educator_all_enrollments.final_time)
											FROM data_whurehouse.reports_user_standard_educator_all_enrollments
											WHERE 
													reports_user_standard_educator_all_enrollments.course_id = reports_user_standard_educator_all_courses.course_id
												AND
													reports_user_standard_educator_all_enrollments.course_completion_status = 'complete'
												AND
													reports_user_standard_educator_all_enrollments.rbac_user_id = in_rbac_user_id),	
									
				no_of_dates = 				(SELECT COUNT(*)
											FROM event_dates
											WHERE 
													event_dates.course_id = reports_user_standard_educator_all_courses.course_id
											),
				no_of_ond_modules = 		IFNULL((SELECT
													IFNULL(COUNT(DISTINCT course_content.id),0)
											FROM
													course_content
											WHERE
													course_content.course_id = reports_user_standard_educator_all_courses.course_id
											GROUP BY
												course_content.course_id),0)

		WHERE
				reports_user_standard_educator_all_courses.rbac_user_id = in_rbac_user_id;
				
		
							
				
				
				

	
	-- release lockdown
	CALL reports_release_semaphore(0,in_rbac_user_id,in_entity_id,'reportsBuilder_educator_all_courses_actual');

	-- CALL DEPENCIES!!!!
	SELECT 'no-depnedencies' INTO out_drilldowns;



			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_educator_all_course_content
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Educator\Course/all_course_content.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_educator_all_course_content($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*
	
	-- Lockdown
	CALL reports_start_semaphore(0,in_rbac_user_id,in_entity_id,'reportsBuilder_educator_all_course_content');

	-- Delete previeous report for this user/org
	
	IF in_entity_id = 0  THEN
	
		DELETE FROM data_whurehouse.reports_user_standard_educator_all_course_content
		WHERE rbac_user_id = in_rbac_user_id;
		
	ELSE
	
		DELETE FROM data_whurehouse.reports_user_standard_educator_all_course_content
		WHERE rbac_user_id = in_rbac_user_id AND course_id = in_entity_id;
		
	 IF;

	
	INSERT INTO data_whurehouse.reports_user_standard_educator_all_course_content
	(	rbac_user_id,
		organization_id,
		content_container_id,
		course_id,
		date_created,
		content_title,
		content_type,
		faculty_rbac_user_id,
		faculty_name,
		enrolled,
		complete,
		average_final_score,
		average_time_to_complete
	)
	
		SELECT
			in_rbac_user_id,
			in_organization_id,
			content_container.id,
			REPORTS_THE_COURSES.course_id,
			NOW(),
			content_container.name,
			CASE
					WHEN content_container.content_type = 'survey' 	THEN 'survey'
					WHEN content_container.content_type = 'live_event' AND has_return_demo = 1 THEN 'live_return_demo'
					WHEN content_container.content_type = 'live_event' THEN 'live'
			ELSE
					content_container.content_type
			,
			rbac_user.id,
			CONCAT(rbac_user.first_name,' ',rbac_user.last_name),
			COUNT(REPORTS_CONTENT_ENROLLMENT.student_rbac_user_id),
			SUM(IF(REPORTS_CONTENT_ENROLLMENT.completion_status='complete',1,0)),
			SUM(REPORTS_CONTENT_ENROLLMENT.final_score)/SUM(IF(REPORTS_CONTENT_ENROLLMENT.completion_status = 'complete',1,0)), -- to exclude users who did not complete from avg calc
			NULL -- For now I calculate this in the report itself. as I do not wish to do cursors right now.
		
		FROM 
				data_whurehouse.reports_user_standard_educator_all_courses REPORTS_THE_COURSES
			JOIN
				course_content
			ON
				REPORTS_THE_COURSES.course_id = course_content.course_id				
			JOIN
				content_container
			ON
				course_content.content_container_id = content_container.id
			JOIN
				rbac_user
			ON
				content_container.rbac_user_id = rbac_user.id
			LEFT JOIN
				data_whurehouse.reports_user_standard_educator_all_content_enrollments REPORTS_CONTENT_ENROLLMENT
			ON
				course_content.course_id = REPORTS_CONTENT_ENROLLMENT.course_id
				AND
				course_content.content_container_id = REPORTS_CONTENT_ENROLLMENT.content_container_id
				AND
				REPORTS_CONTENT_ENROLLMENT.rbac_user_id = in_rbac_user_id
			
			WHERE
					((in_entity_id>0 AND REPORTS_THE_COURSES.course_id = in_entity_id) OR in_entity_id = 0)
				AND
					REPORTS_THE_COURSES.rbac_user_id = in_rbac_user_id
			
			GROUP BY
					REPORTS_THE_COURSES.course_id,
					course_content.content_container_id;
		
	
	-- release lockdown
	CALL reports_release_semaphore(0,in_rbac_user_id,in_entity_id,'reportsBuilder_educator_all_course_content');

	-- CALL DEPENCIES!!!!
	SELECT 'no-depnedencies' INTO out_drilldowns;
	


			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_educator_all_enrollments
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Educator\Course/all_enrollments.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_educator_all_enrollments($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*
	
	-- Lockdown
	CALL reports_start_semaphore(0,in_rbac_user_id,in_entity_id,'reportsBuilder_educator_all_enrollments');

	-- Delete previeous report for this user/org
	
	IF in_entity_id = 0  THEN
	
		DELETE FROM data_whurehouse.reports_user_standard_educator_all_enrollments
		WHERE rbac_user_id = in_rbac_user_id;
		
	ELSE
	
		DELETE FROM data_whurehouse.reports_user_standard_educator_all_enrollments
		WHERE rbac_user_id = in_rbac_user_id AND course_id = in_entity_id;
		
	 IF;
	
	INSERT INTO data_whurehouse.reports_user_standard_educator_all_enrollments
	(	id,
		rbac_user_id,
		organization_id,
		date_created,
		course_id,
		event_repeat_group_id,
		student_organization_id,
		student_organization_name,
		student_rbac_user_id,
		last_name,
		first_name,
		username,
		employee_id,
		department_name,
		department_code,
		department_head,
		edu_group_name,
		pre_test_score,
		post_test_score,
		course_evaluation_stat,
		email,
		start_date,
		end_date,
		date_enrolled,
		date_completed,
		due_date,
		enrolled_by,
		final_time,
		position,
		has_attended_all_sessions,
		course_completion_status,
		course_enrollment_id
	)
	
		SELECT
				null,
				in_rbac_user_id,
				in_organization_id,
				NOW(),
				course.id,
				course_enrollment_calendar_tree_mv.event_repeat_group_id,
				organization.id,
				organization.organization_name,
				course_enrollment.student_rbac_user_id,
				rbac_user.last_name,
				rbac_user.first_name,
				rbac_user.username,
				organization_user_enrollment.employment_id,
				organization_department.name,
				organization_department.code,
				CONCAT(dh_rbac_user.first_name,' ',dh_rbac_user.last_name),
				
				null,
				
				IFNULL(
					(SELECT  MAX(final_score)
					FROM 	
							data_whurehouse.reports_user_standard_educator_all_content_enrollments
						
					WHERE
							course_enrollment_id = course_enrollment.id
						AND
							course_content_type = 'Post Test'
						AND
							completion_status = 'complete'),0),
						
			  IFNULL(
				(SELECT  MAX(final_score)
				FROM 	
						data_whurehouse.reports_user_standard_educator_all_content_enrollments
					
				WHERE
						course_enrollment_id = course_enrollment.id
					AND
						course_content_type = 'Post Test'
					AND
						completion_status = 'complete'),0),
			  IFNULL(
				(SELECT count(*)
				FROM 	
						data_whurehouse.reports_user_standard_educator_all_content_enrollments
					
				WHERE
						course_enrollment_id = course_enrollment.id
					AND
						course_content_type = 'Evaluation'
					AND
						completion_status = 'complete'),0),
			
			rbac_user.username,
			lms2views.course_enrollment_calendar_tree_mv.start_date,
			lms2views.course_enrollment_calendar_tree_mv.end_date,
			course_enrollment.enrollment_date,
			course_enrollment.course_date_completed,
			course_enrollment.due_date,
			IF(	course_enrollment.type = 'self', 
				'self', 
				(SELECT 
					CONCAT(last_name, ', ', first_name )
				FROM 
					course_enrollment_invoice
				JOIN
					rbac_user
				ON
					course_enrollment_invoice.registerer_rbac_user_id=rbac_user.id
				WHERE 
					course_enrollment_invoice.id=course_enrollment.course_enrollment_invoice_id)
			),
			IFNULL(
				(SELECT 
						SUM(content_transcript.final_time)
				FROM 	
						content_enrollment
					JOIN
						content_transcript
					ON
						content_enrollment.id = content_transcript.enrollment_id
					
				WHERE
						content_enrollment.course_enrollment_id = course_enrollment.id
				),0
			),
			organization_position.name,
			IF(
				(SELECT 
						COUNT(*)
				FROM 	
						course_enrollment_topic
				WHERE
						course_enrollment_topic.course_enrollment_id = course_enrollment.id
					AND
						course_enrollment_topic.is_attended = 0
				)>0,0,1
			),
			course_enrollment.course_status,
			course_enrollment.id
	
	FROM 
			course_enrollment
		JOIN
			course
		ON
			course_enrollment.course_id = course.id
		JOIN
			organization
		ON
			course_enrollment.organization_id = organization.id
		JOIN
			rbac_user
		ON
			course_enrollment.student_rbac_user_id = rbac_user.id
		LEFT JOIN
			organization_user_enrollment
		ON
			course_enrollment.student_rbac_user_id = organization_user_enrollment.rbac_user_id
			AND
			course_enrollment.organization_id = organization_user_enrollment.organization_id
		LEFT JOIN
			organization_department
		ON
			organization_user_enrollment.organization_department_id = organization_department.id 
		LEFT JOIN
			rbac_user dh_rbac_user
		ON
			organization_department.rbac_user_id = dh_rbac_user.id 
		LEFT JOIN
			organization_position
		ON
			organization_user_enrollment.organization_position_id = organization_position.id
		LEFT JOIN
			lms2views.course_enrollment_calendar_tree_mv
		ON
			course_enrollment.id = lms2views.course_enrollment_calendar_tree_mv.enrollment_id
			AND 
			lms2views.course_enrollment_calendar_tree_mv.day_id = 0 
			AND 
			lms2views.course_enrollment_calendar_tree_mv.topic_id = 0
		
		WHERE
				((in_entity_id>0 AND course.id = in_entity_id) OR in_entity_id = 0)
			AND
				course_enrollment.activity_director_status <> 'rejected'
			AND
				course_enrollment.manager_status <> 'rejected'
			AND
				course_enrollment.status <> 'canceled'
			AND
				(
					course.owner_rbac_user_id = in_rbac_user_id
				OR
					course.id IN (
						SELECT
								course_id
						FROM 
								course_role
						WHERE 
								course_role.rbac_user_id = in_rbac_user_id
							AND
								course_role.role_id = 6						
					)
				)
;	
	
	-- release lockdown
	CALL reports_release_semaphore(0,in_rbac_user_id,in_entity_id,'reportsBuilder_educator_all_enrollments');

	-- CALL DEPENCIES!!!!
	SELECT 'no-depnedencies' INTO out_drilldowns;



			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_educator_specialist_all_content
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Educator\Specialist/all_content.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_educator_specialist_all_content($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*
	-- CALL DEPENCIES!!!!
	SELECT 'reportsBuilder_educator_specialist_all_content_enroll,reportsBuilder_educator_specialist_all_content_actual' INTO out_drilldowns;
	


			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_educator_specialist_all_content_actual
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Educator\Specialist/all_content_actual.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_educator_specialist_all_content_actual($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*
	
	-- Lockdown
	CALL reports_start_semaphore(in_organization_id,in_rbac_user_id,in_entity_id,'reportsBuilder_educator_specialist_all_content_actual');

	-- Delete previeous report for this user/org
	IF in_entity_id = 0  THEN
	
		DELETE FROM data_whurehouse.reports_user_standard_educator_specialist_all_content
		WHERE rbac_user_id = in_rbac_user_id AND organization_id = in_organization_id;
		
	ELSE
	
		DELETE FROM data_whurehouse.reports_user_standard_educator_specialist_all_content
		WHERE rbac_user_id = in_rbac_user_id AND organization_id = in_organization_id AND wrapper_course_id = in_entity_id;
		
	 IF;
	
	-- MAIN QUERY
	
	INSERT INTO data_whurehouse.reports_user_standard_educator_specialist_all_content
	(	rbac_user_id,
		organization_id,
		content_container_id,
		date_created,
		wrapper_course_id,
		content_title,
		content_type,
		faculty_rbac_user_id,
		faculty_name,
		enrolled,
		complete,
		average_final_score,
		average_time_to_complete
	)
	
		SELECT
			in_rbac_user_id,
			in_organization_id,
			content_container.id,
			NOW(),
			course.id,
			content_container.name,
			course.activity_type,
			rbac_user.id,
			CONCAT(rbac_user.first_name,' ',rbac_user.last_name),
			COUNT(reports_user_standard_educator_specialist_all_content_enroll.student_rbac_user_id),
			SUM(IF(reports_user_standard_educator_specialist_all_content_enroll.completion_status='complete',1,0)),
			SUM(reports_user_standard_educator_specialist_all_content_enroll.final_score)/
				SUM(IF(reports_user_standard_educator_specialist_all_content_enroll.completion_status='complete',1,0)), -- to exclude users who did not complete from avg calc
			NULL -- For now I calculate this in the report itself. as I do not wish to do cursors right now.
		
		FROM 
				content_container
			JOIN
				course_content
			ON
				content_container.id = course_content.content_container_id
			JOIN
				course
			ON
				course_content.course_id = course.id
			JOIN
				data_whurehouse.reports_user_standard_educator_specialist_all_content_enroll
			ON
				content_container.id = reports_user_standard_educator_specialist_all_content_enroll.content_container_id
			JOIN
				rbac_user
			ON
				content_container.rbac_user_id = rbac_user.id						
			
			WHERE
					((in_entity_id>0 AND course.id = in_entity_id) OR in_entity_id = 0)
				AND
					course.activity_type IN ('content_wrapper_education','content_wrapper_quiz')
				AND
					reports_user_standard_educator_specialist_all_content_enroll.rbac_user_id = in_rbac_user_id
			
			GROUP BY
					content_container.id;
	
	-- release lockdown
	CALL reports_release_semaphore(in_organization_id,in_rbac_user_id,in_entity_id,'reportsBuilder_educator_specialist_all_content_actual');

	-- CALL DEPENCIES!!!!
	SELECT 'no-depnedencies' INTO out_drilldowns;
	





					

			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_educator_specialist_all_content_enroll
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Educator\Specialist/all_content_enroll.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_educator_specialist_all_content_enroll($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*
	
	-- Lockdown
	CALL reports_start_semaphore(in_organization_id,in_rbac_user_id,in_entity_id,'reportsBuilder_educator_specialist_all_content_enroll');
	
	-- Delete previeous report for this user/org
	IF in_entity_id = 0  THEN
	
		DELETE FROM data_whurehouse.reports_user_standard_educator_specialist_all_content_enroll
		WHERE rbac_user_id = in_rbac_user_id AND organization_id = in_organization_id;
		
	ELSE
	
		DELETE FROM data_whurehouse.reports_user_standard_educator_specialist_all_content_enroll
		WHERE rbac_user_id = in_rbac_user_id AND organization_id = in_organization_id AND course_id = in_entity_id;
		
	 IF;
	
	-- We have different queries to fetch data for RA or other manager
	

		INSERT INTO data_whurehouse.reports_user_standard_educator_specialist_all_content_enroll
		(	id,
			rbac_user_id,
			organization_id,
			date_created,
			content_container_id,
			course_id,
			transcript_group_id,
			course_enrollment_id,
			student_rbac_user_id,
			last_name,
			first_name,
			email,
			group_id,
			group_title,
			pre_test_score,
			final_score,
			completion_status,
			enrollment_date,
			date_completed
		)
		
			SELECT
					null,
					in_rbac_user_id,
					in_organization_id,
					NOW(),
					content_enrollment.content_container_id,
					course_enrollment.course_id,
					transcript_group_id,
					course_enrollment.id,
					content_enrollment.student_rbac_user_id,
					rbac_user.last_name,
					rbac_user.first_name,
					rbac_user.username,
					GROUP_CONCAT(DISTINCT lms2groups.group.id SEPARATOR ','),
					GROUP_CONCAT(DISTINCT lms2groups.group.title SEPARATOR '</br>'),
					content_enrollment.pretest_score,
					content_enrollment.final_score,
					content_enrollment.content_container_status,
					course_enrollment.enrollment_date,
					content_enrollment.content_container_date_completed
			
			FROM 
					course_enrollment
				JOIN
					content_enrollment
				ON
					course_enrollment.id = content_enrollment.course_enrollment_id 
				JOIN
					rbac_user
				ON
					course_enrollment.student_rbac_user_id = rbac_user.id
				JOIN
					lms2groups.user
				ON
					rbac_user.id = user.student_rbac_user_id
				JOIN
					lms2groups.group
				ON
					user.group_id = group.id
	
				WHERE
						((in_entity_id>0 AND course_enrollment.course_id = in_entity_id) OR in_entity_id = 0)
					AND
						course_enrollment.status <> 'canceled'
					AND
						course_enrollment.activity_director_status <> 'rejected'
					AND
						course_enrollment.manager_status <> 'rejected'
					AND
							(group.creator_rbac_user_id = in_rbac_user_id
						OR
							in_rbac_user_id IN(
								SELECT
										coordinator.coordinator_rbac_user_id
								FROM
										lms2groups.coordinator
								WHERE
										coordinator.group_id = group.id
										
										))
				GROUP BY
						course_enrollment.course_id,
				 		content_enrollment.content_container_id,
				 		course_enrollment.student_rbac_user_id;
					
		
						
	
	-- release lockdown
	CALL reports_release_semaphore(in_organization_id,in_rbac_user_id,in_entity_id,'reportsBuilder_educator_specialist_all_content_enroll');

	-- CALL DEPENCIES!!!!
	SELECT 'no-depnedencies' INTO out_drilldowns;
	



			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_educator_specialist_all_courses
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Educator\Specialist/all_courses.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_educator_specialist_all_courses($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*
	-- SELECT 'reportsBuilder_educator_specialist_all_enrollments,reportsBuilder_educator_specialist_all_content_enrollments,reportsBuilder_educator_specialist_all_course_content,reportsBuilder_manage_all_courses_actual' INTO out_drilldowns;
	SELECT 'reportsBuilder_educator_specialist_all_enrollments,reportsBuilder_educator_specialist_all_content_enroll,reportsBuilder_educator_specialist_all_courses_actual,reportsBuilder_educator_specialist_all_course_content' INTO out_drilldowns;
 

			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_educator_specialist_all_courses_actual
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Educator\Specialist/all_courses_actual.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_educator_specialist_all_courses_actual($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*

	
	-- Lockdown
	CALL reports_start_semaphore(in_organization_id,in_rbac_user_id,in_entity_id,'reportsBuilder_educator_specialist_all_courses_actual');

	
	-- Delete previeous report for this user/org
	IF in_entity_id = 0  THEN
	
		DELETE FROM data_whurehouse.reports_user_standard_educator_specialist_all_courses
		WHERE rbac_user_id = in_rbac_user_id AND organization_id = in_organization_id;
		
	ELSE
	
		DELETE FROM data_whurehouse.reports_user_standard_educator_specialist_all_courses
		WHERE rbac_user_id = in_rbac_user_id AND organization_id = in_organization_id AND course_id = in_entity_id;
		
	 IF;
	
	
	INSERT INTO data_whurehouse.reports_user_standard_educator_specialist_all_courses
	(	rbac_user_id,
		organization_id,
		course_id,
		date_created,
		course_title,
		date_course_created,
		activity_type,
		activity_director_rbac_user_id,
		no_of_ond_modules,
		enrolled,
		complete,
		pretest_completed,
		posttest_completed,
		evaluation_completed,
		publish_status,
		certificate_printed,
		credit_offered,
		group_id,
		group_title)
	
			SELECT
				in_rbac_user_id,
				in_organization_id,
				course.id,
				NOW(),
				course.title,
				course.date_created,
				course.activity_type,
				course.owner_rbac_user_id,
				0,
				COUNT(DISTINCT reports_user_standard_educator_specialist_all_enrollments.id),
				
				0, -- ***************** how many completed,., maybe after ... SUM(IF(reports_user_standard_educator_all_enrollments.course_completion_status='complete',1,0)),
				
				SUM(IF(content_enrollment.content_container_status='complete' AND course_content.content_type = 'Pretest',1,0)),
				SUM(IF(content_enrollment.content_container_status='complete' AND course_content.content_type = 'Post Test',1,0)),
				SUM(IF(content_enrollment.content_container_status='complete' AND course_content.content_type = 'Evaluation',1,0)),
				course.publish_status,
				0,
				0,
				group_id,
				group_title
			
			FROM 
					data_whurehouse.reports_user_standard_educator_specialist_all_enrollments
				JOIN
					course
				ON
					reports_user_standard_educator_specialist_all_enrollments.course_id = course.id
				LEFT JOIN -- We have a bug? where content enrollment are created ONLY after course is launched
					content_enrollment
				ON
					reports_user_standard_educator_specialist_all_enrollments.course_enrollment_id = content_enrollment.course_enrollment_id
				LEFT JOIN
					course_content
				ON
					 content_enrollment.content_container_id = course_content.content_container_id
					 AND
					 course_content.course_id = course.id
			WHERE
					((in_entity_id>0 AND course.id = in_entity_id) OR in_entity_id = 0)
				AND
					reports_user_standard_educator_specialist_all_enrollments.rbac_user_id = in_rbac_user_id
				AND
					course.activity_type NOT IN('content_wrapper_education','content_wrapper_quiz','content_wrapper_survey','generic')
			
			GROUP BY
					course.id;

				
				
		-- calculate completion
		
				
				
		UPDATE
				data_whurehouse.reports_user_standard_educator_specialist_all_courses
		SET
				complete = (SELECT COUNT(id)
							FROM data_whurehouse.reports_user_standard_educator_specialist_all_enrollments
							WHERE 
									reports_user_standard_educator_specialist_all_enrollments.course_id = reports_user_standard_educator_specialist_all_courses.course_id
								AND
									reports_user_standard_educator_specialist_all_enrollments.course_completion_status = 'complete'
								AND
									reports_user_standard_educator_specialist_all_enrollments.rbac_user_id = in_rbac_user_id
								
							),
									
				average_time_to_complete = (SELECT AVG(reports_user_standard_educator_specialist_all_enrollments.final_time)
											FROM data_whurehouse.reports_user_standard_educator_specialist_all_enrollments
											WHERE 
													reports_user_standard_educator_specialist_all_enrollments.course_id = reports_user_standard_educator_specialist_all_courses.course_id
												AND
													reports_user_standard_educator_specialist_all_enrollments.course_completion_status = 'complete'
												AND
													reports_user_standard_educator_specialist_all_enrollments.rbac_user_id = in_rbac_user_id
										
											),
				no_of_ond_modules = IFNULL((SELECT
											IFNULL(COUNT(DISTINCT course_content.id),0)
									FROM
											course_content
									WHERE
											reports_user_standard_educator_specialist_all_courses.course_id = course_content.course_id
									GROUP BY
											course_content.course_id),0)
									
		WHERE
				reports_user_standard_educator_specialist_all_courses.rbac_user_id = in_rbac_user_id;





	-- release lockdown
	CALL reports_release_semaphore(in_organization_id,in_rbac_user_id,in_entity_id,'reportsBuilder_educator_specialist_all_courses_actual');
					
	-- CALL DEPENCIES!!!!
	SELECT 'no-depnedencies' INTO out_drilldowns;
	


			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_educator_specialist_all_course_content
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Educator\Specialist/all_course_content.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_educator_specialist_all_course_content($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*
	
	-- Lockdown
	CALL reports_start_semaphore(in_organization_id,in_rbac_user_id,in_entity_id,'reportsBuilder_educator_specialist_all_course_content');

	-- Delete previeous report for this user/org
	IF in_entity_id = 0  THEN
	
		DELETE FROM data_whurehouse.reports_user_standard_educator_specialist_all_course_content
		WHERE rbac_user_id = in_rbac_user_id AND organization_id = in_organization_id;
		
	ELSE
	
		DELETE FROM data_whurehouse.reports_user_standard_educator_specialist_all_course_content
		WHERE rbac_user_id = in_rbac_user_id AND organization_id = in_organization_id AND course_id = in_entity_id;
		
	 IF;


	-- ACTUAL!	

	INSERT INTO data_whurehouse.reports_user_standard_educator_specialist_all_course_content
	(	rbac_user_id,
		organization_id,
		content_container_id,
		course_id,
		date_created,
		content_title,
		content_type,
		faculty_rbac_user_id,
		faculty_name,
		enrolled,
		complete,
		average_final_score,
		average_time_to_complete
	)
	
		SELECT
			in_rbac_user_id,
			in_organization_id,
			content_container.id,
			course_content.course_id,
			NOW(),
			content_container.name,
			CASE
					WHEN content_container.content_type = 'survey' 	THEN 'survey'
					WHEN content_container.content_type = 'live_event' AND has_return_demo = 1 THEN 'live_return_demo'
					WHEN content_container.content_type = 'live_event' THEN 'live'
			ELSE
					content_container.content_type
			,
			rbac_user.id,
			CONCAT(rbac_user.first_name,' ',rbac_user.last_name),
			COUNT(REPORTS_CONTENT_ENROLLMENT.student_rbac_user_id),
			SUM(IF(IFNULL(REPORTS_CONTENT_ENROLLMENT.completion_status,'incomplete')='complete',1,0)),
			SUM(IFNULL(REPORTS_CONTENT_ENROLLMENT.final_score,0))/SUM(IF(IFNULL(REPORTS_CONTENT_ENROLLMENT.completion_status,'incomplete')='complete',1,0)), -- to exclude users who did not complete from avg calc
			NULL -- For now I calculate this in the report itself. as I do not wish to do cursors right now.
		
		FROM 
				data_whurehouse.reports_user_standard_educator_specialist_all_courses REPORTS_COURSES
			JOIN
				course_content
			ON
				REPORTS_COURSES.course_id = course_content.course_id				
			LEFT JOIN
				data_whurehouse.reports_user_standard_educator_specialist_all_content_enroll REPORTS_CONTENT_ENROLLMENT
			ON
				course_content.content_container_id = REPORTS_CONTENT_ENROLLMENT.content_container_id
			AND
				course_content.course_id = REPORTS_CONTENT_ENROLLMENT.course_id
			AND
				REPORTS_CONTENT_ENROLLMENT.rbac_user_id = in_rbac_user_id
			JOIN
				content_container
			ON
				course_content.content_container_id = content_container.id
			JOIN
				rbac_user
			ON
				content_container.rbac_user_id = rbac_user.id
		WHERE
				((in_entity_id>0 AND REPORTS_COURSES.course_id = in_entity_id) OR in_entity_id = 0)
			AND
				REPORTS_COURSES.rbac_user_id = in_rbac_user_id
		
		GROUP BY
				course_content.course_id,
				course_content.content_container_id;
					
					
	
	-- release lockdown
	CALL reports_release_semaphore(in_organization_id,in_rbac_user_id,in_entity_id,'reportsBuilder_educator_specialist_all_course_content');

	-- CALL DEPENCIES!!!!
	SELECT 'no-depnedencies' INTO out_drilldowns;
	


			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_educator_specialist_all_enrollments
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Educator\Specialist/all_enrollments.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_educator_specialist_all_enrollments($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*
	
	-- Lockdown
	CALL reports_start_semaphore(in_organization_id,in_rbac_user_id,in_entity_id,'reportsBuilder_educator_specialist_all_enrollments');
	
	-- Delete previeous report for this user/org
	
	IF in_entity_id = 0  THEN
	
		DELETE FROM data_whurehouse.reports_user_standard_educator_specialist_all_enrollments
		WHERE rbac_user_id = in_rbac_user_id AND organization_id = in_organization_id;
		
	ELSE
	
		DELETE FROM data_whurehouse.reports_user_standard_educator_specialist_all_enrollments
		WHERE rbac_user_id = in_rbac_user_id AND organization_id = in_organization_id AND course_id = in_entity_id;
		
	 IF;
	
	-- We have different queries to fetch data for RA or other manager
	
			INSERT INTO data_whurehouse.reports_user_standard_educator_specialist_all_enrollments
			(	id,
				rbac_user_id,
				organization_id,
				date_created,
				course_id,
				student_rbac_user_id,
				last_name,
				first_name,
				group_id,
				group_title,
				pre_test_score,
				post_test_score,
				email,
				start_date,
				end_date,
				date_enrolled,
				date_completed,
				due_date,
				final_time,
				course_completion_status,
				course_enrollment_id
			)
			
				SELECT
						null,
						in_rbac_user_id,
						in_organization_id,
						NOW(),
						course_enrollment.course_id,
						course_enrollment.student_rbac_user_id,
						rbac_user.last_name,
						rbac_user.first_name,
						GROUP_CONCAT(DISTINCT lms2groups.group.id SEPARATOR ','),
						GROUP_CONCAT(DISTINCT lms2groups.group.title SEPARATOR '</br>'),
						
						IFNULL(
							(SELECT content_enrollment.final_score
							FROM 	content_enrollment
								JOIN
									course_content
								ON
									content_enrollment.content_container_id = course_content.content_container_id
								
							WHERE
									course_enrollment_id = course_enrollment.id
								AND
									content_type = 'Pretest'),0),
									
						IFNULL(
							(SELECT  content_enrollment.final_score
							FROM 	content_enrollment
								JOIN
									course_content
								ON
									content_enrollment.content_container_id = course_content.content_container_id
								
							WHERE
									course_enrollment_id = course_enrollment.id
								AND
									content_type = 'Post Test'),0),
						
						rbac_user.username,
						lms2views.course_enrollment_calendar_tree_mv.start_date,
						lms2views.course_enrollment_calendar_tree_mv.end_date,
						course_enrollment.enrollment_date,
						course_enrollment.course_date_completed,
						course_enrollment.due_date,
						IFNULL(
							(SELECT 
									SUM(content_transcript.final_time)
							FROM 	
									content_enrollment
								JOIN
									content_transcript
								ON
									content_enrollment.id = content_transcript.enrollment_id
								
							WHERE
									content_enrollment.course_enrollment_id = course_enrollment.id
							),0
						),
						
						course_enrollment.course_status,
						course_enrollment.id
				
				FROM 
						course_enrollment
					JOIN
						rbac_user
					ON
						course_enrollment.student_rbac_user_id = rbac_user.id
					JOIN
						lms2groups.user
					ON
						rbac_user.id = user.student_rbac_user_id
					JOIN
						lms2groups.group
					ON
						user.group_id = group.id
					LEFT JOIN
						lms2views.course_enrollment_calendar_tree_mv
					ON
						course_enrollment.id = lms2views.course_enrollment_calendar_tree_mv.enrollment_id
						AND
						lms2views.course_enrollment_calendar_tree_mv.activity_director_status = 'approved'
						AND 
						lms2views.course_enrollment_calendar_tree_mv.day_id = 0 
						AND 
						lms2views.course_enrollment_calendar_tree_mv.topic_id = 0
		
					
				WHERE
							((in_entity_id>0 AND course_enrollment.course_id = in_entity_id) OR in_entity_id = 0)
						AND
							course_enrollment.status <> 'canceled'
						AND
							course_enrollment.activity_director_status <> 'rejected'
						AND
							course_enrollment.manager_status <> 'rejected'
						AND
							(group.creator_rbac_user_id = in_rbac_user_id
						OR
							in_rbac_user_id IN(
								SELECT
										coordinator.coordinator_rbac_user_id
								FROM
										lms2groups.coordinator
								WHERE
										coordinator.group_id = group.id
										
										))
				GROUP BY
						course_enrollment.id;
	
						
					
					
	
	-- release lockdown
	CALL reports_release_semaphore(in_organization_id,in_rbac_user_id,in_entity_id,'reportsBuilder_educator_specialist_all_enrollments');

	-- CALL DEPENCIES!!!!
	SELECT 'no-depnedencies' INTO out_drilldowns;
	


			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_educator_specialist_all_learners
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Educator\Specialist/all_learners.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_educator_specialist_all_learners($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*
	
	-- Delete previeous report for this user/org
	IF in_entity_id = 0  THEN
	
		DELETE FROM data_whurehouse.reports_user_standard_educator_specialist_all_learners
		WHERE rbac_user_id = in_rbac_user_id AND organization_id = in_organization_id;
		
	ELSE
	
		DELETE FROM data_whurehouse.reports_user_standard_educator_specialist_all_learners
		WHERE rbac_user_id = in_rbac_user_id AND organization_id = in_organization_id AND learner_rbac_user_id = in_entity_id;
		
	 IF;

		INSERT INTO data_whurehouse.reports_user_standard_educator_specialist_all_learners
		(	rbac_user_id,
			organization_id,
			learner_rbac_user_id,
			date_created,
			group_id,
			group_title,
			first_name,
			last_name,
			course_enrolled,
			course_enrolled_completed
		)
			
			SELECT
					in_rbac_user_id,
					in_organization_id,
					rbac_user.id AS learner_rbac_user_id,
					NOW(),
					GROUP_CONCAT(DISTINCT lms2groups.group.id SEPARATOR ','),
					GROUP_CONCAT(DISTINCT lms2groups.group.title SEPARATOR '</br>'),
					rbac_user.first_name,
					rbac_user.last_name,
					(
						SELECT COUNT(*) 
						FROM course_enrollment
						JOIN lms2groups.user
						ON course_enrollment.student_rbac_user_id = user.student_rbac_user_id
						WHERE course_enrollment.student_rbac_user_id = learner_rbac_user_id 
							  	AND course_enrollment.status = 'enabled'
							  	AND user.group_id = group.id
					),
					(
						SELECT COUNT(*) 
						FROM course_enrollment 
						
						JOIN lms2groups.user
						ON course_enrollment.student_rbac_user_id = user.student_rbac_user_id
						WHERE course_enrollment.student_rbac_user_id = learner_rbac_user_id 
							  	AND
							  course_enrollment.status = 'enabled'
							  	AND
							  course_enrollment.course_status = 'complete'
							  AND
							  user.group_id = group.id
					)				
			
			FROM 
					rbac_user
				JOIN	
					organization_user_enrollment
				ON
					rbac_user.id = organization_user_enrollment.rbac_user_id
				JOIN
					lms2groups.user
				ON
					organization_user_enrollment.rbac_user_id = user.student_rbac_user_id
				JOIN
					lms2groups.group
				ON
					user.group_id = group.id
				
			WHERE
					((in_entity_id>0 AND rbac_user.id = in_entity_id) OR in_entity_id = 0)
				AND
					(group.creator_rbac_user_id = in_rbac_user_id
				OR
					in_rbac_user_id IN(
						SELECT
								coordinator.coordinator_rbac_user_id
						FROM
								lms2groups.coordinator
						WHERE
								coordinator.group_id = group.id
								
								))
			GROUP BY
						learner_rbac_user_id;
					
	
				
	-- CALL DEPENCIES!!!!
	SELECT 'no-depnedencies' INTO out_drilldowns;

	





			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_educator_all_content
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Faculty/all_content.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_educator_all_content($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*
	-- CALL DEPENCIES!!!!
	SELECT 'reportsBuilder_faculty_all_content_enrollments,reportsBuilder_faculty_all_content_actual' INTO out_drilldowns;
	


			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_faculty_all_content_actual
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Faculty/all_content_actual.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_faculty_all_content_actual($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*
	
	-- Lockdown
	CALL reports_start_semaphore(0,in_rbac_user_id,in_entity_id,'reportsBuilder_faculty_all_content_actual');

	-- Delete previeous report for this user/org

	IF in_entity_id = 0  THEN
	
		DELETE FROM data_whurehouse.reports_user_standard_educator_all_content
		WHERE rbac_user_id = in_rbac_user_id;
		
	ELSE
	
		DELETE FROM data_whurehouse.reports_user_standard_educator_all_content
		WHERE rbac_user_id = in_rbac_user_id AND wrapper_course_id = in_entity_id;
		
	 IF;
	
	INSERT INTO data_whurehouse.reports_user_standard_educator_all_content
	(	rbac_user_id,
		organization_id,
		content_container_id,
		date_created,
		wrapper_course_id,
		content_title,
		content_type,
		courses_adopted,
		enrolled,
		complete,
		average_final_score,
		average_time_to_complete
	)
	
		SELECT
			in_rbac_user_id,
			in_organization_id,
			content_container.id,
			NOW(),
			course.id,
			content_container.name,
			course.activity_type,
			(
				SELECT COUNT(*)
				FROM 
						course_content
					JOIN
						course
					ON
						course_content.course_id = course.id
	
				WHERE
						course_content.content_container_id = content_container.id
					AND
						course.activity_type NOT IN ('content_wrapper_education','content_wrapper_quiz','content_wrapper_survey','generic','content_wrapper_survey_template')
			
			),
			COUNT(reports_user_standard_faculty_all_content_enrollments.student_rbac_user_id),
			SUM(IF(reports_user_standard_faculty_all_content_enrollments.completion_status='complete',1,0)),
			SUM(reports_user_standard_faculty_all_content_enrollments.final_score)/SUM(IF(reports_user_standard_faculty_all_content_enrollments.completion_status='complete',1,0)), -- to exclude users who did not complete from avg calc
			NULL -- For now I calculate this in the report itself. as I do not wish to do cursors right now.
		
		FROM 
				content_container
			JOIN
				course_content
			ON
				content_container.id = course_content.content_container_id
			JOIN
				course
			ON
				course_content.course_id = course.id
			LEFT JOIN
				data_whurehouse.reports_user_standard_faculty_all_content_enrollments
			ON
				content_container.id = reports_user_standard_faculty_all_content_enrollments.content_container_id
			
			WHERE
					((in_entity_id>0 AND course.id = in_entity_id) OR in_entity_id = 0)
				AND
					content_container.rbac_user_id = in_rbac_user_id
				AND
					course.activity_type IN ('content_wrapper_education','content_wrapper_quiz','content_wrapper_survey','content_wrapper_survey_template')
				AND
					course.publish_status = 'Active'

				
			
			GROUP BY
					content_container.id;
	
	-- release lockdown
	CALL reports_release_semaphore(0,in_rbac_user_id,in_entity_id,'reportsBuilder_faculty_all_content_actual');

	-- CALL DEPENCIES!!!!
	SELECT 'no-depnedencies' INTO out_drilldowns;
	





					

			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_faculty_all_content_enrollments
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Faculty/all_enrollments.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_faculty_all_content_enrollments($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*
	
	-- Lockdown
	CALL reports_start_semaphore(0,in_rbac_user_id,in_entity_id,'reportsBuilder_faculty_all_content_enrollments');
	
	-- Delete previeous report for this user/org
	
	IF in_entity_id = 0  THEN
	
		DELETE FROM data_whurehouse.reports_user_standard_faculty_all_content_enrollments
		WHERE rbac_user_id = in_rbac_user_id;
		
	ELSE
	
		DELETE FROM data_whurehouse.reports_user_standard_faculty_all_content_enrollments
		WHERE rbac_user_id = in_rbac_user_id AND course_id = in_entity_id;
		
	 IF;
	
	-- We have different queries to fetch data for RA or other manager
	
		INSERT INTO data_whurehouse.reports_user_standard_faculty_all_content_enrollments
		(	id,
			rbac_user_id,
			organization_id,
			date_created,
			content_container_id,
			course_id,
			transcript_group_id,
			course_enrollment_id,
			student_rbac_user_id,
			last_name,
			first_name,
			email,
			position,
			department_name,
			department_code,
			edu_group_name,
			pre_test_score,
			final_score,
			completion_status,
			enrollment_date,
			date_completed
		)
		
			SELECT
					null,
					in_rbac_user_id,
					in_organization_id,
					NOW(),
					content_enrollment.content_container_id,
					course_enrollment.course_id,
					transcript_group_id,
					course_enrollment.id,
					content_enrollment.student_rbac_user_id,
					rbac_user.last_name,
					rbac_user.first_name,
					rbac_user.username,
					organization_position.name,
					organization_department.name,
					organization_department.code,
					null,
					content_enrollment.pretest_score,
					content_enrollment.final_score,
					content_enrollment.content_container_status,
					course_enrollment.enrollment_date,
					content_enrollment.content_container_date_completed
			
			FROM
					course
				JOIN
					course_enrollment
				ON
					course.id = course_enrollment.course_id
				JOIN
					content_enrollment
				ON
					course_enrollment.id = content_enrollment.course_enrollment_id
				JOIN
					content_container
				ON
					content_enrollment.content_container_id = content_container.id
				JOIN
					rbac_user
				ON
					course_enrollment.student_rbac_user_id = rbac_user.id
				LEFT JOIN
					organization_user_enrollment
				ON
					course_enrollment.student_rbac_user_id = organization_user_enrollment.rbac_user_id
					AND
					organization_user_enrollment.organization_id = course_enrollment.organization_id
				LEFT JOIN
					organization_department
				ON
					organization_user_enrollment.organization_department_id = organization_department.id 
				LEFT JOIN
					organization_position
				ON
					organization_user_enrollment.organization_position_id = organization_position.id

				WHERE
						((in_entity_id>0 AND course.id = in_entity_id) OR in_entity_id = 0)
					AND
						content_container.rbac_user_id = in_rbac_user_id
					AND
						course_enrollment.status <> 'canceled'
				ORDER BY
						rbac_user.last_name,
						rbac_user.first_name;
	
	-- release lockdown
	CALL reports_release_semaphore(0,in_rbac_user_id,in_entity_id,'reportsBuilder_faculty_all_content_enrollments');

	-- CALL DEPENCIES!!!!
	SELECT 'no-depnedencies' INTO out_drilldowns;
	



			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_educator_all_presentations
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Faculty/all_presentations.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_educator_all_presentations($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*
	-- CALL DEPENCIES!!!!
	SELECT 'reportsBuilder_faculty_all_content_actual,reportsBuilder_faculty_all_content_enrollments' INTO out_drilldowns;


			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_educator_all_quizzes
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Faculty/all_quizzes.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_educator_all_quizzes($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*
	-- CALL DEPENCIES!!!!
	SELECT 'reportsBuilder_faculty_all_content_actual,reportsBuilder_faculty_all_content_enrollments' INTO out_drilldowns;
	


			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_educator_all_returndemonstrations
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Faculty/all_return_demonstrations.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_educator_all_returndemonstrations($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*
	-- CALL DEPENCIES!!!!
	SELECT 'reportsBuilder_educator_all_content_actual,reportsBuilder_faculty_all_content_enrollments' INTO out_drilldowns;
	


			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_educator_all_surveys
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Faculty/all_surveys.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_educator_all_surveys($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*
	-- CALL DEPENCIES!!!!
	SELECT 'reportsBuilder_educator_all_content_actual,reportsBuilder_faculty_all_content_enrollments' INTO out_drilldowns;


			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_manage_all_content
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Manage\Content/all_content.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_manage_all_content($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*
	-- CALL DEPENCIES!!!!
	SELECT 'reportsBuilder_manage_all_content_enrollments,reportsBuilder_manage_all_content_actual' INTO out_drilldowns;
	


			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_manage_all_presentations
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Manage\Content/all_presentations_ONHOLD.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_manage_all_presentations($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*
	-- CALL DEPENCIES!!!!
	SELECT 'reportsBuilder_manage_all_content_actual,reportsBuilder_manage_all_content_enrollments' INTO out_drilldowns;


			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_manage_all_quizzes
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Manage\Content/all_quizzes_ONHOLD.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_manage_all_quizzes($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*
	-- CALL DEPENCIES!!!!
	SELECT 'reportsBuilder_manage_all_content_actual,reportsBuilder_manage_all_content_enrollments' INTO out_drilldowns;
	


			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_manage_all_courses
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Manage\Course/all_courses.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_manage_all_courses($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*
	SELECT 'reportsBuilder_manage_all_enrollments,reportsBuilder_manage_all_content_enrollments,reportsBuilder_manage_all_courses_actual,reportsBuilder_manage_all_course_content' INTO out_drilldowns;
	
 

			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_manage_all_courses_actual
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Manage\Course/all_courses_actual.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_manage_all_courses_actual($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*

	
	-- Lockdown
	CALL reports_start_semaphore(in_organization_id,in_rbac_user_id,in_entity_id,'reportsBuilder_manage_all_courses_actual');

	
	-- Delete previeous report for this user/org
	IF in_entity_id = 0  THEN
	
		DELETE FROM data_whurehouse.reports_user_standard_manage_all_courses
		WHERE rbac_user_id = in_rbac_user_id AND organization_id = in_organization_id;
		
	ELSE
	
		DELETE FROM data_whurehouse.reports_user_standard_manage_all_courses
		WHERE rbac_user_id = in_rbac_user_id AND organization_id = in_organization_id AND course_id = in_entity_id;
		
	 IF;
	
	
	INSERT INTO data_whurehouse.reports_user_standard_manage_all_courses
	(	rbac_user_id,
		organization_id,
		course_id,
		date_created,
		course_title,
		date_course_created,
		activity_type,
		activity_director_rbac_user_id,
		no_of_ond_modules,
		enrolled,
		complete,
		pretest_completed,
		posttest_completed,
		evaluation_completed,
		publish_status,
		certificate_printed,
		credit_offered)
	
			SELECT
				in_rbac_user_id,
				in_organization_id,
				course.id,
				NOW(),
				course.title,
				course.date_created,
				course.activity_type,
				course.owner_rbac_user_id,
				0,
				COUNT(DISTINCT reports_user_standard_manage_all_enrollments.id),
				
				0, -- ***************** how many completed,., maybe after ... SUM(IF(reports_user_standard_educator_all_enrollments.course_completion_status='complete',1,0)),
				
				SUM(IF(content_enrollment.content_container_status='complete' AND course_content.content_type = 'Pretest',1,0)),
				SUM(IF(content_enrollment.content_container_status='complete' AND course_content.content_type = 'Post Test',1,0)),
				SUM(IF(content_enrollment.content_container_status='complete' AND course_content.content_type = 'Evaluation',1,0)),
				course.publish_status,
				0,
				0
			
			FROM 
					data_whurehouse.reports_user_standard_manage_all_enrollments
				JOIN
					course
				ON
					reports_user_standard_manage_all_enrollments.course_id = course.id
				LEFT JOIN -- We have a bug? where content enrollment are created ONLY after course is launched
					content_enrollment
				ON
					reports_user_standard_manage_all_enrollments.course_enrollment_id = content_enrollment.course_enrollment_id
				LEFT JOIN
					course_content
				ON
					 content_enrollment.content_container_id = course_content.content_container_id
					 AND
					 course_content.course_id = course.id
				LEFT JOIN
					(SELECT
							COUNT(DISTINCT course_content.id) as content_count,
							course_content.course_id
					FROM
							course_content
					GROUP BY
							course_content.course_id) cc
				ON
					cc.course_id =  course.id
				
			WHERE
					((in_entity_id>0 AND course.id = in_entity_id) OR in_entity_id = 0)
				AND
					reports_user_standard_manage_all_enrollments.rbac_user_id = in_rbac_user_id
				AND
					reports_user_standard_manage_all_enrollments.organization_id = in_organization_id
				AND
					course.activity_type NOT IN('content_wrapper_education','content_wrapper_quiz','content_wrapper_survey','generic')
			
			GROUP BY
					course.id;

				
				
		-- calculate completion
		
				
				
		UPDATE
				data_whurehouse.reports_user_standard_manage_all_courses
		SET
				complete = (SELECT COUNT(id)
							FROM data_whurehouse.reports_user_standard_manage_all_enrollments
							WHERE 
									reports_user_standard_manage_all_enrollments.course_id = reports_user_standard_manage_all_courses.course_id
								AND
									reports_user_standard_manage_all_enrollments.course_completion_status = 'complete'
								AND
									reports_user_standard_manage_all_enrollments.rbac_user_id = in_rbac_user_id
								AND
									reports_user_standard_manage_all_enrollments.organization_id = in_organization_id
							),
									
				average_time_to_complete = (SELECT AVG(reports_user_standard_manage_all_enrollments.final_time)
											FROM data_whurehouse.reports_user_standard_manage_all_enrollments
											WHERE 
													reports_user_standard_manage_all_enrollments.course_id = reports_user_standard_manage_all_courses.course_id
												AND
													reports_user_standard_manage_all_enrollments.course_completion_status = 'complete'
												AND
													reports_user_standard_manage_all_enrollments.rbac_user_id = in_rbac_user_id
												AND
													reports_user_standard_manage_all_enrollments.organization_id = in_organization_id
											),
				no_of_ond_modules		= IFNULL((SELECT
													IFNULL(COUNT(DISTINCT course_content.id),0)
											FROM
													course_content
											WHERE
													reports_user_standard_manage_all_courses.course_id = course_content.course_id
											GROUP BY
													course_content.course_id),0)
									
		WHERE
				reports_user_standard_manage_all_courses.rbac_user_id = in_rbac_user_id
			AND
				reports_user_standard_manage_all_courses.organization_id = in_organization_id;





	-- release lockdown
	CALL reports_release_semaphore(in_organization_id,in_rbac_user_id,in_entity_id,'reportsBuilder_manage_all_courses_actual');
					
	-- CALL DEPENCIES!!!!
	SELECT 'no-depnedencies' INTO out_drilldowns;
	


			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_manage_all_course_content
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Manage\Course/all_course_content.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_manage_all_course_content($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*
	
	-- Lockdown
	CALL reports_start_semaphore(in_organization_id,in_rbac_user_id,in_entity_id,'reportsBuilder_manage_all_course_content');

	-- Delete previeous report for this user/org
	IF in_entity_id = 0  THEN
	
		DELETE FROM data_whurehouse.reports_user_standard_manage_all_course_content
		WHERE rbac_user_id = in_rbac_user_id AND organization_id = in_organization_id;
		
	ELSE
	
		DELETE FROM data_whurehouse.reports_user_standard_manage_all_course_content
		WHERE rbac_user_id = in_rbac_user_id AND organization_id = in_organization_id AND course_id = in_entity_id;
		
	 IF;


	-- ACTUAL!	

	INSERT INTO data_whurehouse.reports_user_standard_manage_all_course_content
	(	rbac_user_id,
		organization_id,
		content_container_id,
		course_id,
		date_created,
		content_title,
		content_type,
		faculty_rbac_user_id,
		faculty_name,
		enrolled,
		complete,
		average_final_score,
		average_time_to_complete
	)
	
		SELECT
			in_rbac_user_id,
			in_organization_id,
			content_container.id,
			course_content.course_id,
			NOW(),
			content_container.name,
			CASE
					WHEN content_container.content_type = 'survey' 	THEN 'survey'
					WHEN content_container.content_type = 'live_event' AND has_return_demo = 1 THEN 'live_return_demo'
					WHEN content_container.content_type = 'live_event' THEN 'live'
			ELSE
					content_container.content_type
			,
			rbac_user.id,
			CONCAT(rbac_user.first_name,' ',rbac_user.last_name),
			COUNT(REPORTS_CONTENT_ENROLLMENT.student_rbac_user_id),
			SUM(IF(IFNULL(REPORTS_CONTENT_ENROLLMENT.completion_status,'incomplete')='complete',1,0)),
			SUM(IFNULL(REPORTS_CONTENT_ENROLLMENT.final_score,0))/SUM(IF(IFNULL(REPORTS_CONTENT_ENROLLMENT.completion_status,'incomplete')='complete',1,0)), -- to exclude users who did not complete from avg calc
			NULL -- For now I calculate this in the report itself. as I do not wish to do cursors right now.
		
		FROM 
				data_whurehouse.reports_user_standard_manage_all_courses REPORTS_COURSES
			JOIN
				course_content
			ON
				REPORTS_COURSES.course_id = course_content.course_id				
			LEFT JOIN
				data_whurehouse.reports_user_standard_manage_all_content_enrollments REPORTS_CONTENT_ENROLLMENT
			ON
				course_content.content_container_id = REPORTS_CONTENT_ENROLLMENT.content_container_id
			AND
				course_content.course_id = REPORTS_CONTENT_ENROLLMENT.course_id
			AND
				REPORTS_CONTENT_ENROLLMENT.organization_id = REPORTS_COURSES.organization_id
			JOIN
				content_container
			ON
				course_content.content_container_id = content_container.id
			JOIN
				rbac_user
			ON
				content_container.rbac_user_id = rbac_user.id
		WHERE
				((in_entity_id>0 AND REPORTS_COURSES.course_id = in_entity_id) OR in_entity_id = 0)
			AND
				REPORTS_COURSES.organization_id = in_organization_id
			AND
				REPORTS_COURSES.rbac_user_id = in_rbac_user_id
		
		GROUP BY
				course_content.course_id,
				course_content.content_container_id;
					
					
	
	-- release lockdown
	CALL reports_release_semaphore(in_organization_id,in_rbac_user_id,in_entity_id,'reportsBuilder_manage_all_course_content');

	-- CALL DEPENCIES!!!!
	SELECT 'no-depnedencies' INTO out_drilldowns;
	


			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_manage_all_departments
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Manage\Course/all_departments.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_manage_all_departments($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*
	
	-- Delete previeous report for this user/org
	
	DELETE FROM data_whurehouse.reports_user_standard_manage_all_departments
	WHERE rbac_user_id = in_rbac_user_id AND organization_id = in_organization_id;
	
	CALL is_user_ra(in_organization_id,in_rbac_user_id,@is_ra);
	
	IF @is_ra>0 THEN
	
	INSERT INTO data_whurehouse.reports_user_standard_manage_all_departments
	(	rbac_user_id,
		organization_id,
		department_id,
		department_name,
		department_code,
		sub_dept_count,
		edu_group_count,
		dept_enroll_count,
		course_rollout_count)
	
		SELECT
				in_rbac_user_id,
				in_organization_id,
				id AS department_id,
				organization_department.name AS department_name,
				organization_department.code AS department_code,
				(SELECT COUNT(*) FROM organization_department WHERE organization_department.parent_id = department_id GROUP BY organization_department.id LIMIT 1) AS sub_dept_count,
				(SELECT COUNT(*) FROM organization_education_group WHERE organization_education_group.organization_department_id = department_id GROUP BY organization_education_group.organization_department_id LIMIT 1) AS edu_group_count,
				(SELECT COUNT(*) FROM organization_user_enrollment WHERE organization_user_enrollment.organization_department_id = department_id GROUP BY organization_user_enrollment.organization_department_id LIMIT 1) AS dept_enroll_count,
				(SELECT COUNT(*) FROM course_enrollment_rollout JOIN organization_user_enrollment ON organization_user_enrollment.rbac_user_id = course_enrollment_rollout.created_by WHERE organization_user_enrollment.organization_department_id = department_id GROUP BY organization_user_enrollment.organization_department_id LIMIT 1) AS course_rollout_count
				
		
		FROM 
				organization_department
			
			
			
			WHERE
					organization_department.organization_id = in_organization_id
				AND
					(organization_department.rbac_user_id = in_rbac_user_id
				OR
					organization_department.rbac_user_id IS NULL);	
	
	ELSE
		
		INSERT INTO data_whurehouse.reports_user_standard_manage_all_departments
	(	rbac_user_id,
		organization_id,
		department_id,
		department_name,
		department_code,
		sub_dept_count,
		edu_group_count,
		dept_enroll_count,
		course_rollout_count)
	
		SELECT
				in_rbac_user_id,
				in_organization_id,
				organization_department.id AS department_id,
				organization_department.name AS department_name,
				organization_department.code AS department_code,
				(SELECT COUNT(*) FROM organization_department WHERE organization_department.parent_id = department_id GROUP BY organization_department.id LIMIT 1) AS sub_dept_count,
				(SELECT COUNT(*) FROM organization_education_group WHERE organization_education_group.organization_department_id = department_id GROUP BY organization_education_group.organization_department_id LIMIT 1) AS edu_group_count,
				(SELECT COUNT(*) FROM organization_user_enrollment WHERE organization_user_enrollment.organization_department_id = department_id GROUP BY organization_user_enrollment.organization_department_id LIMIT 1) AS dept_enroll_count,
				(SELECT COUNT(*) FROM course_enrollment_rollout JOIN organization_user_enrollment ON organization_user_enrollment.rbac_user_id = course_enrollment_rollout.created_by WHERE organization_user_enrollment.organization_department_id = department_id GROUP BY organization_user_enrollment.organization_department_id LIMIT 1) AS course_rollout_count
				
		
		FROM 
				organization_department
			
			WHERE
					organization_department.organization_id = in_organization_id
				AND
					organization_department.rbac_user_id = in_rbac_user_id;
					
	
	 IF;

	-- CALL DEPENCIES!!!!
	SELECT 'no-depnedencies' INTO out_drilldowns;
	


			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_manage_all_enrollments
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Manage\Course/all_enrollments.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_manage_all_enrollments($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*
	
	-- Lockdown
	CALL reports_start_semaphore(in_organization_id,in_rbac_user_id,in_entity_id,'reportsBuilder_manage_all_enrollments');
	
	-- Delete previeous report for this user/org
	
	IF in_entity_id = 0  THEN
	
		DELETE FROM data_whurehouse.reports_user_standard_manage_all_enrollments
		WHERE rbac_user_id = in_rbac_user_id AND organization_id = in_organization_id;
		
	ELSE
	
		DELETE FROM data_whurehouse.reports_user_standard_manage_all_enrollments
		WHERE rbac_user_id = in_rbac_user_id AND organization_id = in_organization_id AND course_id = in_entity_id;
		
	 IF;
	
	-- We have different queries to fetch data for RA or other manager
	
	CALL is_user_ra(in_organization_id,in_rbac_user_id,@is_ra);
	
	IF @is_ra>0 THEN
			INSERT INTO data_whurehouse.reports_user_standard_manage_all_enrollments
			(	id,
				rbac_user_id,
				organization_id,
				date_created,
				course_id,
				student_rbac_user_id,
				last_name,
				first_name,
				employee_id,
				department_name,
				department_code,
				department_head,
				employee_hired_date,
				edu_group_name,
				pre_test_score,
				post_test_score,
				email,
				start_date,
				end_date,
				date_enrolled,
				date_completed,
				due_date,
				final_time,
				position,
				course_completion_status,
				course_enrollment_id
			)
			
				SELECT
						null,
						in_rbac_user_id,
						in_organization_id,
						NOW(),
						course_enrollment.course_id,
						course_enrollment.student_rbac_user_id,
						rbac_user.last_name,
						rbac_user.first_name,
						organization_user_enrollment.employment_id,
						organization_department.name,
						organization_department.code,
						CONCAT(dh_rbac_user.first_name,' ',dh_rbac_user.last_name),
						employee_mv.employee_hired_date,
						null,
						
						IFNULL(
							(SELECT content_enrollment.final_score
							FROM 	content_enrollment
								JOIN
									course_content
								ON
									content_enrollment.content_container_id = course_content.content_container_id
								
							WHERE
									course_enrollment_id = course_enrollment.id
								AND
									content_type = 'Pretest'),0),
									
						IFNULL(
							(SELECT  content_enrollment.final_score
							FROM 	content_enrollment
								JOIN
									course_content
								ON
									content_enrollment.content_container_id = course_content.content_container_id
								
							WHERE
									course_enrollment_id = course_enrollment.id
								AND
									content_type = 'Post Test'),0),
						
						rbac_user.username,
						lms2views.course_enrollment_calendar_tree_mv.start_date,
						lms2views.course_enrollment_calendar_tree_mv.end_date,
						course_enrollment.enrollment_date,
						course_enrollment.course_date_completed,
						course_enrollment.due_date,
						IFNULL(
							(SELECT 
									SUM(content_transcript.final_time)
							FROM 	
									content_enrollment
								JOIN
									content_transcript
								ON
									content_enrollment.id = content_transcript.enrollment_id
								
							WHERE
									content_enrollment.course_enrollment_id = course_enrollment.id
							),0
						),
						
						organization_position.name,
						course_enrollment.course_status,
						course_enrollment.id
				
				FROM 
						course_enrollment
					JOIN
						rbac_user
					ON
						course_enrollment.student_rbac_user_id = rbac_user.id
					JOIN
						organization_user_enrollment
					ON
						course_enrollment.student_rbac_user_id = organization_user_enrollment.rbac_user_id
						AND
						organization_user_enrollment.organization_id = in_organization_id
					JOIN
						organization_department
					ON
						organization_user_enrollment.organization_department_id = organization_department.id
					LEFT JOIN
						rbac_user dh_rbac_user
					ON
						organization_department.rbac_user_id = dh_rbac_user.id 
					LEFT JOIN
						sitel_feed.employee_mv
					ON
						organization_user_enrollment.employment_id = employee_mv.employee_id
						AND
						organization_user_enrollment.organization_id = employee_mv.sitel_org_id						
					LEFT JOIN
						organization_position
					ON
						organization_user_enrollment.organization_position_id = organization_position.id
					LEFT JOIN
						lms2views.course_enrollment_calendar_tree_mv
					ON
						course_enrollment.id = lms2views.course_enrollment_calendar_tree_mv.enrollment_id
						AND
						lms2views.course_enrollment_calendar_tree_mv.activity_director_status = 'approved'
						AND 
						lms2views.course_enrollment_calendar_tree_mv.day_id = 0 
						AND 
						lms2views.course_enrollment_calendar_tree_mv.topic_id = 0
		
					
				WHERE
							((in_entity_id>0 AND course_enrollment.course_id = in_entity_id) OR in_entity_id = 0)
						AND
							course_enrollment.organization_id = in_organization_id
						AND
							course_enrollment.status <> 'canceled'
						AND
							course_enrollment.activity_director_status <> 'rejected'
						AND
							course_enrollment.manager_status <> 'rejected';
	
						
	ELSE
	
	
			INSERT INTO data_whurehouse.reports_user_standard_manage_all_enrollments
			(	id,
				rbac_user_id,
				organization_id,
				date_created,
				course_id,
				student_rbac_user_id,
				last_name,
				first_name,
				employee_id,
				department_name,
				department_code,
				department_head,
				employee_hired_date,
				edu_group_name,
				pre_test_score,
				post_test_score,
				email,
				start_date,
				end_date,
				date_enrolled,
				date_completed,
				due_date,
				final_time,
				position,
				course_completion_status,
				course_enrollment_id
			)
			
				SELECT
						null,
						in_rbac_user_id,
						in_organization_id,
						NOW(),
						course_enrollment.course_id,
						course_enrollment.student_rbac_user_id,
						rbac_user.last_name,
						rbac_user.first_name,
						organization_user_enrollment.employment_id,
						organization_department.name,
						organization_department.code,
						CONCAT(dh_rbac_user.first_name,' ',dh_rbac_user.last_name),
						employee_mv.employee_hired_date,
						null,
						
						IFNULL(
							(SELECT content_enrollment.final_score
							FROM 	content_enrollment
								JOIN
									course_content
								ON
									content_enrollment.content_container_id = course_content.content_container_id
								
							WHERE
									course_enrollment_id = course_enrollment.id
								AND
									content_type = 'Pretest'),0),
									
						IFNULL(
							(SELECT  content_enrollment.final_score
							FROM 	content_enrollment
								JOIN
									course_content
								ON
									content_enrollment.content_container_id = course_content.content_container_id
								
							WHERE
									course_enrollment_id = course_enrollment.id
								AND
									content_type = 'Post Test'),0),
						
						rbac_user.username,
						lms2views.course_enrollment_calendar_tree_mv.start_date,
						lms2views.course_enrollment_calendar_tree_mv.end_date,
						course_enrollment.enrollment_date,
						course_enrollment.course_date_completed,
						course_enrollment.due_date,
						IFNULL(
							(SELECT 
									SUM(content_transcript.final_time)
							FROM 	
									content_enrollment
								JOIN
									content_transcript
								ON
									content_enrollment.id = content_transcript.enrollment_id
								
							WHERE
									content_enrollment.course_enrollment_id = course_enrollment.id
							),0
						),
						organization_position.name,
						course_enrollment.course_status,
						course_enrollment.id
				
				FROM 
						course_enrollment
					JOIN
						rbac_user
					ON
						course_enrollment.student_rbac_user_id = rbac_user.id
					JOIN
						organization_user_enrollment
					ON
						course_enrollment.student_rbac_user_id = organization_user_enrollment.rbac_user_id
						AND
						organization_user_enrollment.organization_id = in_organization_id
					JOIN
						organization_department
					ON
						organization_user_enrollment.organization_department_id = organization_department.id 
					LEFT JOIN
						rbac_user dh_rbac_user
					ON
						organization_department.rbac_user_id = dh_rbac_user.id 
					LEFT JOIN
						sitel_feed.employee_mv
					ON
						organization_user_enrollment.employment_id = employee_mv.employee_id
						AND
						organization_user_enrollment.organization_id = employee_mv.sitel_org_id
					LEFT JOIN
						organization_position
					ON
						organization_user_enrollment.organization_position_id = organization_position.id
					LEFT JOIN
						lms2views.course_enrollment_calendar_tree_mv
					ON
						course_enrollment.id = lms2views.course_enrollment_calendar_tree_mv.enrollment_id
						AND
						lms2views.course_enrollment_calendar_tree_mv.activity_director_status = 'approved'
						AND 
						lms2views.course_enrollment_calendar_tree_mv.day_id = 0 
						AND 
						lms2views.course_enrollment_calendar_tree_mv.topic_id = 0
		
					
				WHERE
							((in_entity_id>0 AND course_enrollment.course_id = in_entity_id) OR in_entity_id = 0)
						AND
							course_enrollment.organization_id = in_organization_id
						AND
							course_enrollment.status <> 'canceled'
						AND
							course_enrollment.activity_director_status <> 'rejected'
						AND
							course_enrollment.manager_status <> 'rejected'
						AND
							course_enrollment.student_rbac_user_id IN (
									SELECT organization_user_enrollment.rbac_user_id
									FROM 
											organization_user_enrollment
										JOIN
											organization_department
										ON
											organization_user_enrollment.organization_department_id = organization_department.id
										LEFT JOIN
											organization_department_proxy
										ON
											organization_department.id = organization_department_proxy.organization_department_id
									WHERE
											organization_department.organization_id = in_organization_id
										AND
											(
											organization_department.rbac_user_id = in_rbac_user_id
											OR
											organization_department_proxy.rbac_user_id = in_rbac_user_id
											)
											);

								
	
	 IF;						
					
					
	
	-- release lockdown
	CALL reports_release_semaphore(in_organization_id,in_rbac_user_id,in_entity_id,'reportsBuilder_manage_all_enrollments');

	-- CALL DEPENCIES!!!!
	SELECT 'no-depnedencies' INTO out_drilldowns;
	


			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_manage_all_learners
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Manage\learner/all_learners.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_manage_all_learners($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*
	
	-- Delete previeous report for this user/org
	IF in_entity_id = 0  THEN
	
		DELETE FROM data_whurehouse.reports_user_standard_manage_all_learners
		WHERE rbac_user_id = in_rbac_user_id AND organization_id = in_organization_id;
		
	ELSE
	
		DELETE FROM data_whurehouse.reports_user_standard_manage_all_learners
		WHERE rbac_user_id = in_rbac_user_id AND organization_id = in_organization_id AND learner_rbac_user_id = in_entity_id;
		
	 IF;

	
	CALL is_user_ra(in_organization_id,in_rbac_user_id,@is_ra);
	
	IF @is_ra>0 THEN

		INSERT INTO data_whurehouse.reports_user_standard_manage_all_learners
		(	rbac_user_id,
			organization_id,
			learner_rbac_user_id,
			date_created,
			dh_id,
			dh_name,
			dh_code,
			first_name,
			last_name,
			course_enrolled,
			course_enrolled_completed
		)
			
			SELECT
					in_rbac_user_id,
					in_organization_id,
					rbac_user.id AS learner_rbac_user_id,
					NOW(),
					organization_department.id,
					organization_department.name,
					organization_department.code,
					rbac_user.first_name,
					rbac_user.last_name,
					(
						SELECT COUNT(*) 
						FROM course_enrollment 
						WHERE course_enrollment.student_rbac_user_id = learner_rbac_user_id 
								AND 
							  course_enrollment.organization_id = in_organization_id 
							  	AND course_enrollment.status = 'enabled'
					),
					(
						SELECT COUNT(*) 
						FROM course_enrollment 
						WHERE course_enrollment.student_rbac_user_id = learner_rbac_user_id 
								AND 
							  course_enrollment.organization_id = in_organization_id 
							  	AND
							  course_enrollment.status = 'enabled'
							  	AND
							  course_enrollment.course_status = 'complete'
					)				
			
			FROM 
					rbac_user
				JOIN	
					organization_user_enrollment
				ON
					rbac_user.id = organization_user_enrollment.rbac_user_id
					AND
					organization_user_enrollment.organization_id = in_organization_id
				JOIN
					organization_department
				ON
					organization_user_enrollment.organization_department_id = organization_department.id
			WHERE
					((in_entity_id>0 AND rbac_user.id = in_entity_id) OR in_entity_id = 0);
					
	
	ELSE
	
	
	
		INSERT INTO data_whurehouse.reports_user_standard_manage_all_learners
		(	rbac_user_id,
			organization_id,
			learner_rbac_user_id,
			date_created,
			dh_id,
			dh_name,
			dh_code,
			first_name,
			last_name,
			course_enrolled,
			course_enrolled_completed
		)
			
			SELECT
					in_rbac_user_id,
					in_organization_id,
					rbac_user.id AS learner_rbac_user_id,
					NOW(),
					organization_department.id,
					organization_department.name,
					organization_department.code,
					rbac_user.first_name,
					rbac_user.last_name,
					(
						SELECT COUNT(*) 
						FROM course_enrollment 
						WHERE course_enrollment.student_rbac_user_id = learner_rbac_user_id 
								AND 
							  course_enrollment.organization_id = in_organization_id 
							  	AND course_enrollment.status = 'enabled'
					),
					(
						SELECT COUNT(*) 
						FROM course_enrollment 
						WHERE course_enrollment.student_rbac_user_id = learner_rbac_user_id 
								AND 
							  course_enrollment.organization_id = in_organization_id 
							  	AND
							  course_enrollment.status = 'enabled'
							  	AND
							  course_enrollment.course_status = 'complete'
					)				
			
			FROM 
					rbac_user
				JOIN	
					organization_user_enrollment
				ON
					rbac_user.id = organization_user_enrollment.rbac_user_id
					AND
					organization_user_enrollment.organization_id = in_organization_id
				JOIN
					organization_department
				ON
					organization_user_enrollment.organization_department_id = organization_department.id
				
			WHERE
					((in_entity_id>0 AND rbac_user.id = in_entity_id) OR in_entity_id = 0)
				AND
					organization_user_enrollment.rbac_user_id IN (
							SELECT organization_user_enrollment.rbac_user_id
							FROM 
									organization_user_enrollment
								JOIN
									organization_department
								ON
									organization_user_enrollment.organization_department_id = organization_department.id
								LEFT JOIN
									organization_department_proxy
								ON
									organization_department.id = organization_department_proxy.organization_department_id
							WHERE
									organization_department.organization_id = in_organization_id
								AND
									(
									organization_department.rbac_user_id = in_rbac_user_id
									OR
									organization_department_proxy.rbac_user_id = in_rbac_user_id
									)
					);
	
	 IF;
				
	-- CALL DEPENCIES!!!!
	SELECT 'no-depnedencies' INTO out_drilldowns;

	





			*/
		}


	   /**
		* Database: Users
		* reportsBuilder_Manage_Users_Hrfeedregistration
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Manage\Users/hr_feed_registration.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $out_drilldowns  :OUT out_drilldowns VARCHAR(255)
		*/
		public function Users_reportsBuilder_Manage_Users_Hrfeedregistration($in_organization_id,$in_rbac_user_id,$in_entity_id,$out_drilldowns){
			/*
	
	-- Delete previeous report for this user/org
	IF in_entity_id = 0  THEN
	
		DELETE FROM data_whurehouse.reports_user_standard_manage_users_hrfeedregistration
		WHERE rbac_user_id = in_rbac_user_id AND organization_id = in_organization_id;
		
	ELSE
	
		DELETE FROM data_whurehouse.reports_user_standard_manage_users_hrfeedregistration
		WHERE rbac_user_id = in_rbac_user_id AND organization_id = in_organization_id AND learner_rbac_user_id = in_entity_id;
		
	 IF;

	-- We have different queries to fetch data for RA or other manager
	
	CALL is_user_ra(in_organization_id,in_rbac_user_id,@is_ra);
	
	IF @is_ra>0 THEN
	
	
	
				INSERT INTO data_whurehouse.reports_user_standard_manage_users_hrfeedregistration
				(	rbac_user_id,
					organization_id,
					learner_rbac_user_id,
					employee_id,
					date_created,
					last_name,
					first_name,
					email,
					department_name,
					department_code,
					registration_status					
				)

					
					
				SELECT 
						in_rbac_user_id,
						in_organization_id,
						organization_user_enrollment.rbac_user_id,
						sitel_feed.employee_mv.employee_id,
						NOW(),
						sitel_feed.employee_mv.employee_last_name,
						sitel_feed.employee_mv.employee_first_name,
						sitel_feed.client_employee.employee_work_email,
						sitel_feed.client_department.department_name,
						sitel_feed.client_department.department_code,
						IFNULL(organization_user_enrollment.status,'unregistered')
				
				FROM
						sitel_feed.employee_mv
					JOIN
						sitel_feed.client_employee
					ON
						sitel_feed.employee_mv.employee_id = sitel_feed.client_employee.employee_id
						AND
						sitel_feed.employee_mv.user_id = sitel_feed.client_employee.user_id
					JOIN
						sitel_feed.client_department
					ON
						sitel_feed.employee_mv.sitel_department_id = sitel_feed.client_department.sitel_dep_id
					JOIN
						organization_user_enrollment
					ON
						sitel_feed.employee_mv.sitel_department_id = organization_user_enrollment.organization_department_id
						AND
						sitel_feed.employee_mv.employee_id = organization_user_enrollment.employment_id
			
				WHERE
						sitel_feed.employee_mv.sitel_org_id = in_organization_id
					AND
						((in_entity_id>0 AND organization_user_enrollment.rbac_user_id = in_entity_id) OR in_entity_id = 0)
					AND
						(sitel_feed.employee_mv.employee_employment_status = 'ACTIVE' OR organization_user_enrollment.id IS NOT NULL)
						
				GROUP BY
						sitel_feed.employee_mv.id;
	 IF;
	
	-- CALL DEPENCIES!!!!
	SELECT 'no-depnedencies' INTO out_drilldowns;
	


			*/
		}


	   /**
		* Database: Users
		* reports_release_semaphore
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Utilities/release_semaphore.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $in_sp  :IN in_sp varchar(255)
		*/
		public function Users_reports_release_semaphore($in_organization_id,$in_rbac_user_id,$in_entity_id,$in_sp){
			/*
	
	-- Delete previeous report for this user/org
	
	UPDATE reports_drilldown_semaphores
	SET report_build_status='Ready'
	WHERE rbac_user_id = in_rbac_user_id AND organization_id = in_organization_id AND entity_id = in_entity_id AND procedure_name = in_sp;



			*/
		}


	   /**
		* Database: Users
		* reports_start_semaphore
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Reports\Utilities/start_semaphore.sql
		*
		* @param integer $in_organization_id  :IN in_organization_id INT
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_entity_id  :IN in_entity_id INT
		* @param string $in_sp  :IN in_sp varchar(255)
		*/
		public function Users_reports_start_semaphore($in_organization_id,$in_rbac_user_id,$in_entity_id,$in_sp){
			/*
	-- Delete previeous report for this user/org
	DELETE FROM reports_drilldown_semaphores
	WHERE rbac_user_id = in_rbac_user_id AND organization_id = in_organization_id AND entity_id = in_entity_id AND procedure_name = in_sp;
	
	
	INSERT INTO reports_drilldown_semaphores
	(	
	  rbac_user_id,
	  organization_id,
	  entity_id,
	  procedure_name,
	  report_build_status,
	  date_created
  	)
	VALUES(
		in_rbac_user_id,
		in_organization_id,
		in_entity_id,
		in_sp,
		'In Progress',
		NOW()
	);



			*/
		}


	   /**
		* Database: Users
		* all_user_orgs_data
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\users/all_user_orgs_data.sql
		*
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		*/
		public function Users_all_user_orgs_data($in_rbac_user_id){
			/*
 	SELECT
 			organization.id									AS 'id',
 			organization.path,
			organization_name,
			organization.hr_feeds,
			organization_department.id						AS 'dep_id',
			organization_department.name					AS 'dep_name',
			rbac_user.first_name							AS 'dh_first_name',
			rbac_user.last_name								AS 'dh_last_name',
			organization_position.id						AS 'pos_id',
			organization_position.name						AS 'pos_name',
			organization_user_enrollment.employment_id,
			organization_user_enrollment.feed_verified,
			GROUP_CONCAT(user_roles.role_id)				AS 'user_roles',
			organization_user_enrollment.status
			
 	FROM 
			lms3users.user_roles
		JOIN
			lms2prod.organization
		ON
			user_roles.organization_id = organization.id  
		LEFT JOIN
			lms2prod.organization_user_enrollment
		ON
			organization.id = organization_user_enrollment.organization_id AND organization_user_enrollment.rbac_user_id = in_rbac_user_id
		LEFT JOIN
			lms2prod.organization_department
		ON
			organization_user_enrollment.organization_department_id = organization_department.id
		LEFT JOIN
			lms2prod.organization_position
		ON
			organization_user_enrollment.organization_position_id = organization_position.id
		LEFT JOIN
			lms2prod.rbac_user
		ON
			organization_department.rbac_user_id = rbac_user.id
			
	WHERE
			user_roles.rbac_user_id = in_rbac_user_id

	GROUP BY
			organization.id
			

UNION DISTINCT

-- PING USERS ONLY
 	SELECT
 			organization.id									AS 'id',
			organization.path,
			organization_name,
			organization.hr_feeds,
			organization_department.id						AS 'dep_id',
			organization_department.name					AS 'dep_name',
			rbac_user.first_name							AS 'dh_first_name',
			rbac_user.last_name								AS 'dh_last_name',
			organization_position.id						AS 'pos_id',
			organization_position.name						AS 'pos_name',
			organization_user_enrollment.employment_id,
			organization_user_enrollment.feed_verified,
			GROUP_CONCAT(user_roles.role_id)				AS 'user_roles',
			organization_user_enrollment.status

	FROM 
			lms2prod.organization_user_enrollment
		JOIN
			lms2prod.organization
		ON
			organization_user_enrollment.organization_id = organization.id AND organization_user_enrollment.rbac_user_id = in_rbac_user_id
		LEFT JOIN
			lms2prod.organization_department
		ON
			organization_user_enrollment.organization_department_id = organization_department.id
		LEFT JOIN
			lms2prod.rbac_user
		ON
			organization_department.rbac_user_id = rbac_user.id
		LEFT JOIN
			lms2prod.organization_position
		ON
			organization_user_enrollment.organization_position_id = organization_position.id
		LEFT JOIN
			lms3users.user_roles
		ON
			organization.id = user_roles.organization_id
			
	WHERE
			organization_user_enrollment.rbac_user_id = in_rbac_user_id
		AND
			user_roles.rbac_user_id IS NULL
	
	GROUP BY
			organization.id
	;	


			*/
		}


	   /**
		* Database: Users
		* all_user_orgs_paths
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\users/all_user_orgs_paths.sql
		*
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		*/
		public function Users_all_user_orgs_paths($in_rbac_user_id){
			/*
 	SELECT
 			organization.path,
			organization_name
 	FROM 
			lms3users.user_roles
		JOIN
			organization
		ON
			user_roles.organization_id = organization.id
		LEFT JOIN
			organization_user_enrollment
		ON
			organization.id = organization_user_enrollment.organization_id
			
	WHERE
			user_roles.rbac_user_id = in_rbac_user_id
			
UNION DISTINCT

	SELECT
			organization.path,
			organization_name
 	FROM 
			organization_user_enrollment
		JOIN
			organization
		ON
			organization_id = organization.id
			
	WHERE
			organization_user_enrollment.rbac_user_id = in_rbac_user_id
		AND
			organization_user_enrollment.status IN ('pending','rejected','expired');
	


			*/
		}


	   /**
		* Database: Users
		* user_roles
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\users/user_roles.sql
		*
		* @param integer $in_rbac_user_id  :IN in_rbac_user_id INT
		* @param integer $in_org_id  :IN in_org_id INT
		*/
		public function Users_user_roles($in_rbac_user_id,$in_org_id){
			/*
 	SELECT
 			DISTINCT role_id
 			
 	FROM
 			lms3users.user_roles
 			
 	WHERE
 			rbac_user_id = in_rbac_user_id
 		AND (
 			(role_scope = 'system') OR (role_scope = 'org' AND organization_id = in_org_id)
 		);	


			*/
		}


	   /**
		* Database: Users
		* is_user_ra
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Utilities/is_user_ra.sql
		*
		* @param integer $organization_id  :IN organization_id INT
		* @param integer $rbac_user_id  :IN rbac_user_id INT
		* @param integer $is_ra  :OUT is_ra SMALLINT
		*/
		public function Users_is_user_ra($organization_id,$rbac_user_id,$is_ra){
			/*
	SELECT
		COUNT(*) AS 'is_ra'
	INTO
		is_ra
	FROM
			rbac_user_group
		JOIN
			rbac_group
		ON
			rbac_user_group.rbac_group_id = rbac_group.id
	WHERE
			rbac_group.organization_id = organization_id
		AND
			rbac_user_group.rbac_user_id = rbac_user_id
		AND
			rbac_group.rbac_role_id = 3;


			*/
		}


	   /**
		* Database: Users
		* reset_master_password
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Utilities/reset_master_password.sql
		*
		* @param string $user_name  :IN user_name VARCHAR(255)
		* @param string $password  :IN password VARCHAR(255)
		*/
		public function Users_reset_master_password($user_name,$password){
			/*
	UPDATE rbac_user
	SET `password`=SHA1(password)
	WHERE username=user_name
	LIMIT 1;



			*/
		}


	   /**
		* Database: Users
		* reset_master_password_by_id
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Utilities/reset_master_password_by_id.sql
		*
		* @param integer $user_id  :IN user_id INT(11)
		* @param string $password  :IN password VARCHAR(255)
		*/
		public function Users_reset_master_password_by_id($user_id,$password){
			/*
	UPDATE rbac_user
	SET `password`=SHA1(password)
	WHERE `id`=user_id;



			*/
		}


	   /**
		* Database: Users
		* truncate_q
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Utilities/truncate_q.sql
		*
		*/
		public function Users_truncate_q(){
			/*
	TRUNCATE TABLE reports_user_standard;
	TRUNCATE TABLE reports_drilldown_semaphores;
	TRUNCATE TABLE lock_queue;


			*/
		}


	   /**
		* Database: Users
		* truncate_reports
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Utilities/truncate_reports.sql
		*
		*/
		public function Users_truncate_reports(){
			/*
	CALL truncate_q();

	TRUNCATE data_whurehouse.reports_user_standard_educator_all_content;
	TRUNCATE data_whurehouse.reports_user_standard_educator_all_content_enrollments;
	TRUNCATE data_whurehouse.reports_user_standard_educator_all_courses;
	TRUNCATE data_whurehouse.reports_user_standard_educator_all_course_content;
	TRUNCATE data_whurehouse.reports_user_standard_educator_all_enrollments;
	TRUNCATE data_whurehouse.reports_user_standard_faculty_all_content_enrollments;
	TRUNCATE data_whurehouse.reports_user_standard_manage_all_content;
	TRUNCATE data_whurehouse.reports_user_standard_manage_all_content_enrollments;
	TRUNCATE data_whurehouse.reports_user_standard_manage_all_courses;
	TRUNCATE data_whurehouse.reports_user_standard_manage_all_course_content;
	TRUNCATE data_whurehouse.reports_user_standard_manage_all_departments;
	TRUNCATE data_whurehouse.reports_user_standard_manage_all_enrollments;
	TRUNCATE data_whurehouse.reports_user_standard_manage_all_learners;
	TRUNCATE data_whurehouse.reports_user_standard_manage_users_hrfeedregistration;


			*/
		}


	   /**
		* Database: Users
		* un_org_users
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms2prod\Utilities/un_attached_users.sql
		*
		* @param integer $limit_me  :IN limit_me INT
		*/
		public function Users_un_org_users($limit_me){
			/*
	SELECT
			rbac_user.id,
			rbac_user.username
	FROM 
			rbac_user 
		
		JOIN
			organization_user_enrollment 
		ON
			rbac_user.id = organization_user_enrollment.rbac_user_id 
		
		LEFT JOIN
			rbac_user_group 
		ON
			rbac_user.id = rbac_user_group.rbac_user_id
	WHERE 
			organization_user_enrollment.rbac_user_id IS NULL
		AND
			rbac_user_group.rbac_user_id IS NULL
	
	LIMIT limit_me;


			*/
		}


	   /**
		* Database: Users
		* load_que
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms3feed/load_que.sql
		*
		*/
		public function Users_load_que(){
			/*
TRUNCATE TABLE que;
INSERT INTO que( source_id, feed_file_info_id, path, feed_file_name, inque, outque, empty, parse_type,
STATUS )
SELECT source_id AS source_id, feed_file_info.id AS feed_id, feed_file_location AS feed_path, feed_file_name AS feed_name, NOW( ) , NULL , empty AS feed_empty, parse_type AS parse_type, 'pending'
FROM lms3feed.feed_file_info
JOIN lms3feed.source ON source.id = feed_file_info.source_id
WHERE
STATUS = 'active'
ORDER BY feed_file_info.feed_order ASC , feed_file_info.source_id ASC ;



			*/
		}


	   /**
		* Database: Users
		* load_users
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms3feed/load_users.sql
		*
		* @param integer $org_id  :IN org_id INT
		* @param string $empl_id  :IN empl_id VARCHAR(255)
		*/
		public function Users_load_users($org_id,$empl_id){
			/*
	SELECT 
		employee_employment_status,
		position_unified_map_id,
		sitel_department_id,
		sitel_organization_position_id
	FROM  
		lms3feed.employee_mv
	WHERE 
		sitel_org_id=org_id
	AND 
		(
			employee_id= empl_id
			OR 
			old_employee_id=empl_id
		);		


			*/
		}


	   /**
		* Database: Users
		* modified_records_in_department
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms3feed/modified_records_in_department.sql
		*
		* @param integer $feed_id  :IN feed_id INT
		*/
		public function Users_modified_records_in_department($feed_id){
			/*
	SELECT 
		count(*) as modifiled_counts
	FROM lms3feed.client_department_staging
	join lms3feed.client_department
	on 	
		lms3feed.client_department_staging.department_code=lms3feed.client_department.department_code 
		and
		lms3feed.client_department_staging.department_organization_code =lms3feed.client_department.department_organization_code 
		and 
		lms3feed.client_department_staging.sitel_org_id=lms3feed.client_department.sitel_org_id 
		and
		lms3feed.client_department_staging.feed_file_info_id=lms3feed.client_department.feed_file_info_id
	where   
		(lms3feed.client_department.feed_file_info_id=feed_id) and
		 (
			 lms3feed.client_department_staging.department_name<>client_department.department_name 
			or 
			 lms3feed.client_department_staging.department_status<>client_department.department_status 
		 );


			*/
		}


	   /**
		* Database: Users
		* modified_records_in_employee
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms3feed/modified_records_in_employee.sql
		*
		* @param integer $feed_id  :IN feed_id INT
		*/
		public function Users_modified_records_in_employee($feed_id){
			/*
	SELECT 
			count(*) as modifiled_counts
	from 	lms3feed.client_employee_staging
 	join	lms3feed.client_employee
	on 
			lms3feed.client_employee.employee_id=lms3feed.client_employee_staging.employee_id
		and
			lms3feed.client_employee.sitel_org_id=lms3feed.client_employee_staging.sitel_org_id
		and	
			lms3feed.client_employee_staging.feed_file_info_id = lms3feed.client_employee_staging.feed_file_info_id
	where  
			(client_employee.feed_file_info_id=feed_id) 
		and 
			(
				lms3feed.client_employee_staging.user_id != lms3feed.client_employee.user_id
			or
				lms3feed.client_employee_staging.`employee_first_name` != lms3feed.client_employee.`employee_first_name`
			or
				lms3feed.client_employee_staging.`employee_last_name` != lms3feed.client_employee.`employee_last_name`	
			or
				lms3feed.client_employee_staging.`employee_hired_date` != lms3feed.client_employee.`employee_hired_date`
			or
				lms3feed.client_employee_staging.`employee_terminated_date` != lms3feed.client_employee.`employee_terminated_date`
			or
				lms3feed.client_employee_staging.`employee_employment_status` != lms3feed.client_employee.`employee_employment_status`
			);


			*/
		}


	   /**
		* Database: Users
		* modified_records_in_organization
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms3feed/modified_records_in_organization.sql
		*
		* @param integer $feed_id  :IN feed_id INT
		*/
		public function Users_modified_records_in_organization($feed_id){
			/*
	SELECT 
		count(*) as modifiled_counts
	FROM lms3feed.client_organization_staging
join lms3feed.client_organization
on client_organization_staging.organization_code=client_organization.organization_code and

client_organization_staging.source_id=client_organization.source_id
where   (client_organization.feed_file_info_id=feed_id) and (
client_organization_staging.organization_name <> client_organization.organization_name or

client_organization_staging.organization_description <> client_organization.organization_description or
client_organization_staging.organization_status <> client_organization.organization_status);


			*/
		}


	   /**
		* Database: Users
		* modified_records_in_position
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms3feed/modified_records_in_position.sql
		*
		* @param integer $feed_id  :IN feed_id INT
		*/
		public function Users_modified_records_in_position($feed_id){
			/*
	SELECT 
		count(*) as modifiled_counts
	FROM lms3feed.client_position_staging
	join lms3feed.client_position
	on 	
		lms3feed.client_position_staging.position_code=lms3feed.client_position.position_code 
		and
		lms3feed.client_position_staging.position_organization_code =lms3feed.client_position.position_organization_code 
		and 
		lms3feed.client_position_staging.sitel_org_id=lms3feed.client_position.sitel_org_id 
		and
		lms3feed.client_position_staging.feed_file_info_id=lms3feed.client_position.feed_file_info_id
	where   
		(lms3feed.client_position.feed_file_info_id=feed_id) and
		 (
			 lms3feed.client_position_staging.position_name<>client_position.position_name 
			 or 
			 lms3feed.client_position_staging.position_unified_map_id<>client_position.position_unified_map_id 
			 or 
			 lms3feed.client_position_staging.position_status<>client_position.position_status 
		 );


			*/
		}


	   /**
		* Database: Users
		* refresh_employee_mv_now
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms3feed/refresh_employee_mv_now.sql
		*
		*/
		public function Users_refresh_employee_mv_now(){
			/*
	TRUNCATE TABLE employee_mv;
	
	INSERT INTO employee_mv
		SELECT DISTINCT
			`client_employee`.`id`,
			`client_employee`.`sitel_org_id`,
			`client_employee`.`source_id`,
			`client_employee`.`feed_file_info_id`,
			`client_employee`.`user_id`,
			`client_employee`.`employee_id`,
			`client_employee`.`original_employee_id`,
			`client_employee`.`old_employee_id`,
			`client_employee`.`employee_first_name`,
			`client_employee`.`employee_middle_name`,
			`client_employee`.`employee_last_name`,
			`client_employee`.`employee_employment_status`,
			`client_employee`.`employee_hired_date`,
			`client_employee`.`employee_supervisor_user_id`,
			`client_employee`.`employee_supervisor_employee_id`,
			`client_employee`.`employee_department_code`,
			`client_employee`.`employee_old_department_code`,
			`client_employee`.`employee_job_code` ,
			`client_employee`.`employee_job_class`,
			`client_employee`.`employee_position_code` ,
			`client_position`.`position_unified_map_id`,
			`client_employee`.`employee_organization_code`,
			`client_employee`.`employee_old_organization_code`,
			`client_employee`.`employee_feed_source`,
			MAX(`client_department`.`sitel_dep_id`) AS 'sitel_department_id',
			`client_department`.`department_description` AS 'department_description',
			`client_department`.`department_status` AS 'department_status',
			MAX(`client_job`.`sitel_lut_specialities_id`) AS 'sitel_lut_specialities_id',
			`client_job`.`job_description` AS 'job_description',
			`client_job`.`job_status` AS 'job_status',
			MAX(`client_position`.`sitel_pos_id`) AS 'sitel_organization_position_id',
			`client_position`.`position_description` AS 'position_description',
			`client_position`.`position_status` AS 'position_status',
			`client_employee`.`date_created` ,
			`client_employee`.`date_modified`
		FROM
			`client_employee`
			JOIN
			`client_department`
			ON
				client_department.department_code = client_employee.employee_department_code
				AND
				client_department.department_organization_code = client_employee.employee_organization_code
				AND
				client_department.department_status = 'ACTIVE'
			LEFT JOIN
			`client_job`
			ON
				client_job.job_code = client_employee.employee_job_code
				AND
				client_job.job_organization_code = client_employee.employee_organization_code
			LEFT JOIN
			`client_position`
			ON
				client_position.position_code = client_employee.employee_position_code
				AND
				client_position.sitel_org_id = client_employee.sitel_org_id
			LEFT JOIN
			`client_division`
			ON
			client_division.division_code = client_employee.employee_division_code
		group by id;



			*/
		}


	   /**
		* Database: Users
		* truncate_clients_tables
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms3feed/truncate_clients_tables.sql
		*
		*/
		public function Users_truncate_clients_tables(){
			/*
	
	TRUNCATE TABLE lms3feed.feed_log;
	TRUNCATE table lms3feed.client_organization_staging;	
	TRUNCATE TABLE lms3feed.client_position_staging;
	TRUNCATE table lms3feed.client_department_staging;
	TRUNCATE table lms3feed.client_employee_staging;
	


			*/
		}


	   /**
		* Database: Users
		* update_departments_from_staging
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms3feed/update_departments_from_staging.sql
		*
		* @param integer $feed_id  :IN feed_id INT
		*/
		public function Users_update_departments_from_staging($feed_id){
			/*
INSERT INTO lms3feed.client_department (
	sitel_org_id,  
	source_id,
	feed_file_info_id, 
   	department_code,
   	department_name,	
	department_description,
	department_organization_code,
	sitel_generated_department_code,
	department_status,
	status
)
	SELECT 
		sitel_org_id,  
		source_id,
		feed_file_info_id, 
	   	department_code,
	   	department_name,	
		department_description,
		department_organization_code,
		sitel_generated_department_code,
		department_status,
		status
	FROM lms3feed.client_department_staging
	WHERE feed_file_info_id=feed_id

	ON DUPLICATE KEY UPDATE  
		client_department.sitel_org_id=client_department_staging.sitel_org_id,  
		client_department.source_id=client_department_staging. source_id, 
		client_department.feed_file_info_id=client_department_staging.feed_file_info_id,    
	   	client_department.department_code=client_department_staging.department_code,  
	   	client_department.department_name=client_department_staging.department_name,  	
		client_department.department_description=client_department_staging.department_description,  
		client_department.department_organization_code=client_department_staging.department_organization_code,  
		client_department.sitel_generated_department_code=client_department_staging.sitel_generated_department_code,  
		client_department.department_status=client_department_staging.department_status,  
		client_department.status=client_department_staging.status;


			*/
		}


	   /**
		* Database: Users
		* update_employees_from_staging
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms3feed/update_employees_from_staging.sql
		*
		* @param integer $feed_id  :IN feed_id INT
		*/
		public function Users_update_employees_from_staging($feed_id){
			/*
INSERT INTO lms3feed.client_employee (
	sitel_org_id,  
	source_id,
	feed_file_info_id, 
   	user_id,
   	employee_id,
   	original_employee_id,
   	employee_first_name,
   	employee_middle_name,
   	employee_last_name,
   	employee_hired_date,
   	employee_terminated_date,
   	employee_employment_status,
   	employee_supervisor_user_id,
   	employee_supervisor_employee_id,
   	employee_department_code,
   	employee_job_code,
   	employee_position_code,
   	employee_organization_code,
   	employee_feed_source,
   	status
   	
)
	SELECT 
	sitel_org_id,  
		source_id,
		feed_file_info_id, 
	   	user_id,
	   	employee_id,
	   	original_employee_id,
	   	employee_first_name,
	   	employee_middle_name,
	   	employee_last_name,
	   	employee_hired_date,
	   	employee_terminated_date,
	   	employee_employment_status,
	   	employee_supervisor_user_id,
	   	employee_supervisor_employee_id,
	   	employee_department_code,
	   	employee_job_code,
	   	employee_position_code,
	   	employee_organization_code,
	   	employee_feed_source,
	   	status	
	FROM lms3feed.client_employee_staging	
	WHERE feed_file_info_id=feed_id
	
	ON DUPLICATE KEY UPDATE  
		
		client_employee.sitel_org_id						=client_employee_staging.sitel_org_id,  
		client_employee.sitel_org_id						=client_employee_staging.sitel_org_id,
		client_employee.feed_file_info_id					=client_employee_staging.feed_file_info_id, 
	   	client_employee.user_id								=client_employee_staging.user_id,
	   	client_employee.employee_id							=client_employee_staging.employee_id,
	   	client_employee.original_employee_id				=client_employee_staging.original_employee_id,
	   	client_employee.employee_first_name					=client_employee_staging.employee_first_name,
	   	client_employee.employee_middle_name				=client_employee_staging.employee_middle_name,
	   	client_employee.employee_last_name					=client_employee_staging.employee_last_name,
	   	client_employee.employee_hired_date					=client_employee_staging.employee_hired_date,
	   	client_employee.employee_terminated_date			=client_employee_staging.employee_terminated_date,
	   	client_employee.employee_employment_status			=client_employee_staging.employee_employment_status,
	   	client_employee.employee_supervisor_user_id			=client_employee_staging.employee_supervisor_user_id,
	   	client_employee.employee_supervisor_employee_id		=client_employee_staging.employee_supervisor_employee_id,
	   	client_employee.employee_department_code			=client_employee_staging.employee_department_code,
	   	client_employee.employee_job_code					=client_employee_staging.employee_job_code,
	   	client_employee.employee_position_code				=client_employee_staging.employee_position_code,
	   	client_employee.employee_organization_code			=client_employee_staging.employee_organization_code,
	   	client_employee.employee_feed_source				=client_employee_staging.employee_feed_source,
	   	client_employee.status								=client_employee_staging.status;		



			*/
		}


	   /**
		* Database: Users
		* update_organizations_from_staging
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms3feed/update_organizations_from_staging.sql
		*
		* @param integer $feed_id  :IN feed_id INT
		*/
		public function Users_update_organizations_from_staging($feed_id){
			/*
INSERT INTO lms3feed.client_organization (
	sitel_org_id,  
	source_id,
	feed_file_info_id, 
    organization_code,
    organization_name,
	organization_description,
	organization_status,
	status
)
	SELECT 
		sitel_org_id,
		source_id,
		feed_file_info_id,    
		organization_code,
		organization_name,
		organization_description,
		organization_status,
		status
	FROM lms3feed.client_organization_staging
	WHERE feed_file_info_id=feed_id

	ON DUPLICATE KEY UPDATE  
		lms3feed.client_organization.source_id			=lms3feed.client_organization_staging.source_id, 
		lms3feed.client_organization.feed_file_info_id		=lms3feed.client_organization_staging.feed_file_info_id,
		lms3feed.client_organization.sitel_org_id		=lms3feed.client_organization_staging.sitel_org_id,
		lms3feed.client_organization.organization_code		=lms3feed.client_organization_staging.organization_code,
		lms3feed.client_organization.organization_name		=lms3feed.client_organization_staging.organization_name,
		lms3feed.client_organization.organization_description	=lms3feed.client_organization_staging.organization_description,
		lms3feed.client_organization.organization_status	=lms3feed.client_organization_staging.organization_status,
		lms3feed.client_organization.status			=lms3feed.client_organization_staging.status;
			


			*/
		}


	   /**
		* Database: Users
		* update_positions_from_staging
		* File: C:\Users\SiTEL\Documents\GitHub\rahl_commander\assets/sp\lms3feed/update_positions_from_staging.sql
		*
		* @param integer $feed_id  :IN feed_id INT
		*/
		public function Users_update_positions_from_staging($feed_id){
			/*
INSERT INTO lms3feed.client_position (
	sitel_org_id,  
	source_id,
	feed_file_info_id, 
    position_code,
    position_name,
	position_unified_map_id,
	position_description,
	position_organization_code,
	position_status,
	status
)
	SELECT 
		sitel_org_id,  
		source_id,
		feed_file_info_id, 
	    position_code,
	    position_name,
		position_unified_map_id,
		position_description,
		position_organization_code,
		position_status,
		status
	FROM lms3feed.client_position_staging
	WHERE feed_file_info_id=feed_id
	ON DUPLICATE KEY UPDATE  
		client_position.sitel_org_id=client_position_staging.sitel_org_id,
		client_position.source_id=client_position_staging.source_id,
		client_position.feed_file_info_id=client_position_staging.feed_file_info_id,
		client_position.position_code=client_position_staging.position_code,
		client_position.position_name=client_position_staging.position_name,
		client_position.position_unified_map_id=client_position_staging.position_unified_map_id,
		client_position.position_description=client_position_staging.position_description,
		client_position.position_organization_code=client_position_staging.position_organization_code,
		client_position.position_status=client_position_staging.position_status,
		client_position.status=client_position_staging.status;


			*/
		}


}
