<?php
class Config{
	/**
	 * @var Config
	 */
	static public $Env = null;
	static public function factory($env){
		$W = new self($env);
		self::$Env =  $W->json;
		return self::$Env; 
	}
	
	/**
	 * Binary called/parent script/command
	 * @var string
	 */
	static private $initiator = '';
	static public function setBin($bin){
		self::$initiator = str_replace('.php','',$bin);
	}
	
	static public function getBin(){
		return self::$initiator;
	}
	
	/**
	 * instantiate a new config object
	 * @param unknown_type $env
	 */
	private function __construct($env){
		$conf = file_get_contents(CONFIG_PATH . DIRECTORY_SEPARATOR . 'environments' . DIRECTORY_SEPARATOR . ENV_NAME . '.json');
		$this->json =  json_decode($conf);
	}
	
	public $json;
}