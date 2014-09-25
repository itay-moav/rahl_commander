<?php
/**
 * DB class purpose is to wrap the actual DB extension we use 
 * So if we change extension, no changes in code will occur beside in this class. 
 * @author Itay Moav
 */
class Connector_MySql_DB extends PDO implements Connector_Interface{

	/**
	 * @var Connector_MySql_DB
	 */
	static private $connections = array();
	/**
	 * Access flag, to prevent users from instantiating this not through the the getInstance
	 */
    static private $accessFlag=false;
	/**
	  * In transaction flag
	  *
	  * @var Boolean
	  */
    protected $inTransaction = false;
	 /**
	  * Last SQL which has been performed
	  *
	  * @var String
	  */
	protected $lastSql = '';
	 /**
	  * Holds the last PDO Statment object
	  *
	  * @var  PDOStatement
	  */
	protected $lastStatement = null;
	 /**
	  * Array of Parameters last used in the last SQL
	  *
	  * @var Array
	  */
	protected $lastBindParams = array();
	 /**
	  * Number of the rows returned or affected
	  *
	  * @var Int
	  */
	public $numRows = 0;
	 /**
	  * Number of fields in returned rowset
	  *
	  * @var Int
	  */
	public $numFields = 0;
	 /**
	  * Holds the last inserted ID
	  *
	  * @var integer
	  */
	public $lastInsertID = false;
	 /**
	  * Wether to execute the query or not.
	  * Good to get back the SQL only, for Pagers, for example.
	  */
	 private $noExecute=false;
	 /**
	  * Sometimes I do not want to fail on error, this is the flag to manage this.
	  * Example - when I try to insert what migth be a duplicate value and I do not want to check it before hand. 
	  */
	 public $failOnError=true;
	 /**
	  * Array of codes not to fail on
	  * When true, as if it is array of all codes
	  * 
	  * @var boolean|array
	  */
	 public $noFailErrorCodes = true;
	 /**
	  * last error code caught with no fail on error
	  * When false, no error was caught
	  * 
	  * @var boolean|integer
	  */
	 public $lastErrorCode = false;
	 /**
	  * Sometimes I want to supress error messages/log entries, like when using error_monitor
	  */
	 public $noMessage=false;
	/**
	 * Creats an instance of the object
	 *
	 * @return Connector_MySql_DB
	 */
	public static function getInstance($db){
		if (!isset(self::$connections[$db]) || self::$connections[$db] == null){
				self::$accessFlag =true;
				self::$connections[$db] = new self($db);
		}//EOF IF
		self::$accessFlag=false;
		return self::$connections[$db];
	}
	
	/**
	 * Get's the last statments all dbs did
	 */
	public static function getDebugData(){
		$db_array=array(
			'last_sql'=>self::$connectionn->getLastSql(),
			'last_binding_params'=>print_r(self::$connectionn->getLastbindParams(),true)
		);
		return $db_array;
	}

	/**
	 * Creating an instance
	 * Although this is a type of sigleton, we are using a public modifier here, as we inherit the PDO class
	 * which have a public constructor.
	 */
	public function __construct($db) {
		$C = Config::$Env;
		$this->noMessage = ($C->logger->verbosity > Logger::VERBOSITY_LVL_DEBUG);
		$CDB = $C->database;
		
		//CONNECT!
		$port   = isset($CDB->port) ? $CDB->port : null;
		$p = ($port != null) ? (";port={$port}") : '';
		$dns = 'mysql:dbname=' . $db . ";host=" . $CDB->host . $p;

		
		if(!self::$accessFlag) throw (new Exception('You must use getInstance to instantiate this class'));
		try{
			parent::__construct($dns,$CDB->user,$CDB->pass,array(PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8'));
			$this->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
		 	$this->setAttribute(PDO::MYSQL_ATTR_USE_BUFFERED_QUERY,true);
		}catch (PDOException $E){
			fatal($E);
		}catch (Exception $E){
			fatal($E);
		}
	}

	/**
	 */
	public function closeCursor(){
		$this->lastStatement->closeCursor();
		return $this;
	}

	private $errorRecoveryCycles = 0;
	private function execute($sql, array $params=array()){
		$this->lastSql = $sql;
		$this->lastBindParams=$params;
		if($this->noExecute) return;
		$this->slog();

		//error handling
		try{
			if($params){
				$this->lastStatement = $this->prepare($sql);
				$this->lastStatement->execute($params);
			}else{
				$this->lastStatement = $this->query($sql);
			}
			$this->numFields = $this->lastStatement->columnCount();
			$this->numRows = $this->lastStatement->rowCount();//TODO Not portable to other DBs
		}catch (PDOException $e){
			$code = $this->extractMysqlErrorCode($e->getMessage());
			if($this->errorRecoveryCycles>10){
				$error = 'Can not recover from error by sleeping, error is ' . $e->getMessage() . ' [' . $code . '] I die!';
				$result = $this->query("SHOW PROCESSLIST")->fetchAll();
				$error .= "<p><h1>Showing Process list</h1><div>" . print_r($result, true) . "</div></p>";
				throw new Exception($error);
			}
			if($this->inTransaction){//The transaction was rolled back anyway, we need to stop!
				return $this->error($e);
			}
			
			$this->errorRecoveryCycles++;
			
			//handle each error specificaly			
			switch($code){
				case (1205)://SQLSTATE[HY000]: General error: 1205 Lock wait timeout exceeded; try restarting transaction
				case (1213)://SQLSTATE[40001]: Serialization failure: 1213 Deadlock found when trying to get lock; try restarting transaction
					sleep(3);
					return $this->execute($sql,$params);

				case (1146)://missing table error (place holder)
					return $this->error($e);
					
				case (1062)://duplicate entries, mostl;y happens in the archive/history when we insert two records without waiting (key consists of NOW()
					sleep(1);
					$this->errorRecoveryCycles +=10;
					return $this->execute($sql,$params);
					
				default:
					return $this->error($e);		
			}
		}
		$this->errorRecoveryCycles = 0;
		return true;
	}
	
	/**
	 * extract error code from exception message
	 * 'SQLSTATE[HY000]: General error: 1205 Lock wait timeout exceeded; try restarting transaction'
	 * 
	 * will return 1205
	 * @param string $msg
	 */
	private function extractMysqlErrorCode($msg){
		$p='/\b[0-9][0-9][0-9][0-9]\b/';
		preg_match($p,$msg,$m);
		return $m[0];		
	}
	
	/**
	 * Entry point for select statments.
	 * We have this spread of authorities for future use (like different server verifications)
	 *
	 * @param String $sql
	 * @param Array $param
	 * @return Connector_MySql_DB
	 */
	public function select($sql, array $params=array()){
		$this->execute($sql,$params);
		return $this;
	}

	/**
	 * Insert a record
	 *
	 * @param String $sql
	 * @param Array $bindparam (fieldanme=>value, fieldanme=>value, ...)
	 * @return Connector_MySql_DB
	 */
	public function insert($sql,array $params = array()){
		$this->execute($sql,$params);
		$this->lastInsertID=$this->lastInsertId();
		return $this ;
	}

	/**
	 * Physically deletes a record or records from table
	 *
	 * @param String $sql
	 * @return Connector_MySql_DB
	 */
	public function delete($sql,array $params = array()){
		$this->execute($sql,$params);
		return $this;
	}

	/**
	 * Creates something in the DB
	 *
	 * @param String $sql
	 * @return Connector_MySql_DB
	 */
	public function create($sql){
		$this->execute($sql);
		return $this;
	}

	/**
	 * Updates a record
	 *
	 * @param String $sql
	 * @param Array $bindparam
	 * @return Connector_MySql_DB
	 */
	public function update($sql, $bindparam = NULL){
		$this->execute($sql,$bindparam);
		return $this;
	}

    /**
     * Returns the last statement Object
     *
     * @return string
     */
    public function getLastStatement(){
        return $this->lastStatement;
    }

    /**
     * Returns the last SQL
     *
     * @return String
     */
    public function getLastSql(){
        return $this->lastSql;
    }

    /**
     * Returns the last bind valye array
     *
     * @return array
     */
    public function getLastbindParams(){
        return $this->lastBindParams;
    }

	/**
	 * Fetch the rowset based on the PDO Type (FETCH_ASSOC,...)
	 *
	 * @param integer $fetch_type
	 * @return array
	 */
	public function fetchAll($fetch_type = PDO::FETCH_ASSOC){
		$res=$this->lastStatement->fetchAll($fetch_type);
		return $res?:array();
	}
	
	public function fetchAllObj(){
		return $this->lastStatement->fetchAll(PDO::FETCH_OBJ);
	}
	
	public function fetchAllUserObj($class_name,array $ctor_args=array()){
		return $this->lastStatement->fetchAll(PDO::FETCH_CLASS,$class_name,$ctor_args);
	}
	
	public function fetchAllUserFunc($func){
		return $this->lastStatement->fetchAll(PDO::FETCH_FUNC,$func);
	}
	
	/**
	 * Fetches one column as an array
	 *
	 * @param int $column index in select list
	 * @return array
	 */
	public function fetchAllColumn($column=0){
		return $this->lastStatement->fetchAll(PDO::FETCH_COLUMN, $column);
	}
	
	private function fetchRow($result_type){
		return $this->lastStatement->fetch($result_type);
	}
	
	public function fetchNumericArray(){
		return $this->fetchRow(PDO::FETCH_NUM);
	}

	public function fetchArray(){
		return $this->fetchRow(PDO::FETCH_ASSOC);
	}
	
	public function fetchObj(){
		return $this->fetchRow(PDO::FETCH_OBJ);
	}
	
	/**
	 * This function control the transaction flow & lock the auto commit.
	 *
	 * @return Connector_MySql_DB  It will die if failure happens!
	 */
	public function beginTransaction(){
		$this->lastSql = 'BEGIN TRANSACTION';
		$this->lastBindParams = array();
		$this->slog();
		try{
			if (!$this->inTransaction ) {
				$this->inTransaction = parent::beginTransaction();
			}
		}catch (PDOException $e){
			$this->error($e->getMessage());
		}
		return $this;
	}

	/**
	 * This function commit the transactions, reset the flag and returns
	 * the true. In case of error it rollbacks and returns false flag
	 *
	 * @return Connector_MySql_DB
	 */
	public function endTransaction(){
		$this->lastSql='END TRANSACTION';
		$this->lastBindParams=array();
		$this->slog();
		try{
			if ($this->inTransaction ) {
				parent::commit();
				$this->inTransaction = false;
			}else{
				dbgn("You try to close a closed transaction at {$this->className}::{$this->methodName}");
			}
		}catch (PDOException $e){
			$this->error($e->getMessage());
		}
		return $this;
	}
	
	/**
	 * This function rolls back the transactions, reset the flag and returns
	 * the true.
	 *
	 * @return Connector_MySql_DB
	 */
	public function rollbackTransaction(){
		$this->lastSql='ROLLBACK TRANSACTION';
		$this->lastBindParams=array();
		$this->slog();
		try{
			if ($this->inTransaction ) {
				parent::rollBack();
				$this->inTransaction = false;
			}else{
				$this->error(new Exception("You try to rollback a closed transaction"));
			}
		}catch (PDOException $e){
			$this->error($e->getMessage());
		}catch (Exception $E){
			
		}
		return $this;
	}
	
	/**
	 * Error handeling function
	 *
	 * @param String $error_msg
	 */
	private function error(Exception $E){
		/**
		 * MW - 11/5/10 - Changed to check error codes
		 * If no match, continue normally
		 * always store code
		 */
		$this->lastErrorCode = $E->getCode();
		if(!$this->failOnError && ($this->noFailErrorCodes === true || in_array($this->lastErrorCode, $this->noFailErrorCodes))){ 
			return $this->lastErrorCode;
		}
		if($this->inTransaction){//try to close transaction
			$this->inTransaction=false;
			@parent::rollBack();
			$error_msg.=' ROLLING BACK';
		}
		throw $E;
	}//EOF error

	/**
	 * Attempts to get Caller function.
	 */
	private function getCaller()
	{
		$bt = debug_backtrace();
		$stack = array();
		$i=0;
		foreach ($bt as $trace_line)
		{
			if($i>4 && Config::$Env->database->log_verbosity<4){
				break;
			}
			$function = isset($trace_line['function'])?$trace_line['function']:'';
			//exclude some functions from debug trace
			if(in_array($function,array('getCaller','slog','execute','select','update','delete','insert')) && Config::$Env->database->log_verbosity<4){
				continue;
			}
			
			//unfold args
			$args	 = (Config::$Env->database->log_verbosity>2) && isset($trace_line['args']) && !empty($trace_line['args'])?' args: ' . print_r($trace_line['args'],true):'';
			$stack[] = "{$trace_line['file']} ({$trace_line['line']}) function:{$function}{$args}";
			$i++;
		}

		return implode(PHP_EOL,$stack);
	}
	
	/**
	 * For debug purposes only.
	 * should not work when debug flag is off
	 */
	private function slog(){
		if($this->noMessage){
			return;
		}
		$msg="\n\n";
		if(Config::$Env->database->log_verbosity > 1){
			$msg .= $this->getCaller();	
		} 
		$msg .= "\n{$this->lastSql}\n";

		if($this->lastBindParams){
			$params=print_r($this->lastBindParams,true);
			$msg.="PARAMS: {$params}";
		}

		$msg.="\n\n";
		dbg($msg);
	}
	
	public function recoverOnErrorCodes($codes = true) {
		$this->failOnError = false;
		$this->noFailErrorCodes = $codes;
		return $this;
	}
}
