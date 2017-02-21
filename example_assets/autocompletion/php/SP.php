
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
		* Database: dhara
		* clean_palace_from_dead_soldiers 
		* File: C:\Users\Itay\Documents\github\rahl_commander\example_assets/sp\dhara\palace\soldiers/clean_palace_from_dead_soldiers.sql
		*
		* @param integer $in_member_id  :IN in_member_id INT
		*
		* @return Return_Data_Type
		*/
		public function dhara_clean_palace_from_dead_soldiers ($in_member_id){
			/*
	DELETE FROM first_file_members
	WHERE member_id = in_member_id;


			*/
		}


}
