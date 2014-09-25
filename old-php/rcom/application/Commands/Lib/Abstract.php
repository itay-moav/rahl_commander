<?php
/**
 * This class represents a command.
 * The filter attached will translate the various parameters 
 * into the rest of the syntax of the command
 * 
 * Uses the HentaiLSB system from sitelms.org
 * 
 * @author itaymoav
 */
abstract class Commands_Lib_Abstract{
	/**
	 * @var array the $params in the constructor
	 */
	protected $originalParams=array();
	/**
	 * @var array params I some time need to process.
	 */
	protected $params = array();
	
	/**
	 * @var array of parameter values to use in command
	 */
	protected $paramArray=array(); 
	/**
	 * Current result piece being act upon, usually a file name that 
	 * is being opened and read and stored in memory for further actions.
	 */
	protected $current_row = null;
	/**
	 * @var array $ResultSet
	 */
	protected $result_set = array();
	
	public function __construct(){
		$this->preParser()
			 ->generateParser()
		;
	}
	
	public function initParams($params){
		$this->params = $this->originalParams=$params;
		return $this->initParser()->postParser();
	}
	
	protected function initParser(){
		$this->Parser->initParams($this->params);
		return $this;
	}
	
	/**
	 * @return stdClass
	 */
	public function getCMDParams(){
		return $this->Parser->getCMDParams();
	}
	
	/**
	 * This method populates a list of "something" that the class needs to work on
	 * in $this->result_set to later run the command (internalExecute) on it
	 * 
	 * List will return a array of SplFileInfo which will be processed
	 * OVERRIDE AS NEEDED!
	 */
	protected function getList(){
		$directory_list = $this->Parser->applyParser();
		try {
			foreach($directory_list as $one_directory){
				foreach(self::getFilesRecursive($one_directory) as $File){//SplFileInfo
					if(!$File->isDir()){
						$this->current_row = $File;
						$this->process();
						$this->result_set[] = $this->current_row;
					}
				}
			}
		}catch (UnexpectedValueException $e) {
			printf("Directory [%s] contained a directory we can not recurse into", $one_directory);
		}catch (Exception $e){
			dbg($e.'');
		}
	}
	
	/**
	 * Executes the command on what ever input we got from 
	 * getList. Specifics depends on the command used.
	 */
	protected function internalExecute(){
		return $this;
	}
	
	final public function execute(){
		$this->getList();
		$this->internalExecute();
	}
	
	/**
	 * Place holder for extra things to do at constructor.
	 *
	 * @return Commands_Abstract
	 */
	protected function preParser(){
		return $this;
	}
	
	/**
	 * Holds the specific structure of the command parser, the object knows how
	 * to parse the parameters
	 * This is the default behaviour - feel free to override it
	 * 
	 * @return Commands_Abstract
	 */
	protected function generateParser(){
		$parser_name  = get_class($this) . 'Parser';
		$this->Parser = new $parser_name($this);
		return $this;		
	}
	
	/**
	 * Place holder for extra things to do at constructor, should be used
	 * only by abstract classes inheriting this one.
	 *
	 * @return Commands_Abstract
	 */
	protected function postParser(){
		output("\n\n================================================== BEGIN COMMAND OUTPUT ==================================================\n\n");
		return $this;
	}
	
	/**
	 * The default process of a row - override in each report as necessary
	 * @return Commands_Abstract
	 */
	protected function process(){
		return $this;	
	}
	
	/**
	 * @param string $param_key
	 * @return Commands_Abstract
	 */
	protected function getParam($param_key){
		if(isset($this->params[$param_key])){
			return $this->params[$param_key];
		}
		return null;
	}

	/**
	 * @param string $param_key
	 * @param string $param_value
	 * @return Commands_Abstract
	 */
	protected function setParam($param_key,$param_value){
		$this->params[$param_key] = $param_value;
		return $this;
	}
	
	/**
	 * @param string $param_key
	 * @return Commands_Abstract
	 */
	protected function unsetParam($param_key){
		unset($this->params[$param_key]);
		return $this;
	}
	
	static protected function getFilesRecursive($dir){
		try{
			$r = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($dir,FilesystemIterator::SKIP_DOTS));
		}catch(UnexpectedValueException $e){//most probably directory is not valid/ does not exists.
			dbgn("{$dir}    Has issues, do check if it exists!");
			$r = array();
		}catch(Exception $e){
			dbgd($e);
		}
		return $r;
	}
}//EOF CLASS
