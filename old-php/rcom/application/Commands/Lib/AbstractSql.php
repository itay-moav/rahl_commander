<?php
/**
 * This class represents a command.
 * The filter attached will translate the various parameters 
 * into the rest of the syntax of the command
 * This are commands that are to be translated to a main query
 * 
 * @author itaymoav
 */
abstract class Commands_Lib_AbstractSql extends Commands_Lib_Abstract{
	/**
	 * @return stdClass
	 */
	public function getCMDParams(){
		return $this->Parser->getCMDParams();
	}
	
	/**
	 * This method populates a list of "something" via a SQL query and processes it
	 * and stores it in $this->result_set 
	 * OVERRIDE IS a MUST
	 */
	protected function getList(){
		$where = $this->Parser->applyParser();
		throw new Exception('You need to implement this method by putting here some "select" SQL');
	}
}//EOF CLASS
