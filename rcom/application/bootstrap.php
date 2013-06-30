<?php
/**
 * Bootstrap.
 * Loads environment
 * Define constants
 * bla bla
 */
//error reporting. "light is the best disinfectant"  																		(U CAN MODIFY)
ini_set('error_reporting', E_ALL|E_STRICT);
ini_set('display_errors', true);

//some folder definitions 																									(DO NOT MODIFY)
define('CORE_PATH',		dirname(__FILE__) . DIRECTORY_SEPARATOR . '..');
define('APP_PATH',		CORE_PATH . DIRECTORY_SEPARATOR . 'application');
define('CONFIG_PATH',	CORE_PATH . DIRECTORY_SEPARATOR . 'config');
define('ASSETS_PATH',	CORE_PATH . DIRECTORY_SEPARATOR . 'assets');

define('ASSETS_SP_PATH',		ASSETS_PATH . DIRECTORY_SEPARATOR . 'sp' 		. DIRECTORY_SEPARATOR);
define('ASSETS_TRIGGERS_PATH',	ASSETS_PATH . DIRECTORY_SEPARATOR . 'triggers' 	. DIRECTORY_SEPARATOR);
define('ASSETS_FUNCTIONS_PATH',	ASSETS_PATH . DIRECTORY_SEPARATOR . 'functions' . DIRECTORY_SEPARATOR);
define('ASSETS_VIEWS_PATH',		ASSETS_PATH . DIRECTORY_SEPARATOR . 'views' 	. DIRECTORY_SEPARATOR);
define('ASSETS_SCRIPTS_PATH',	ASSETS_PATH . DIRECTORY_SEPARATOR . 'scripts' 	. DIRECTORY_SEPARATOR);



//core functions 																											(DO NOT MODIFY)
require_once APP_PATH . DIRECTORY_SEPARATOR . 'functions.php';

//get environment name - MODIFY TO YOUR PREFERED DIRECTORY IF U WISH TO PUT rahl_environment_name IN A DIFFERENT PLACE     (U CAN MODIFY) 
//FOR LINUX define('ENV_NAME',file_get_contents(DIRECTORY_SEPARATOR . 'etc' . DIRECTORY_SEPARATOR . 'rahl_environment_name'));
//FOR WINDOWS
define('ENV_NAME',file_get_contents(CORE_PATH . DIRECTORY_SEPARATOR . 'rahl_environment_name.txt'));

//autoloader																												(DO NOT MODIFY)
spl_autoload_register('autoload');

//set the environment																										(DO NOT MODIFY)
Config::factory(ENV_NAME);																									

//TODO configurable from command line paramsn
//set the logger																											(U CAN MODIFY)
//STDIO_LOGGER = "simple echo" u can add more types																			override with different logger class. must implement log
Logger::factory(null,'stdio',Config::$Env->logger->verbosity);

//Know your initiator!
Config::setBin($command);

if($command_line){
	//help!																													(DO NOT MODIFY)
	if($argc < 4){//no params 1=main.php 2=--command 3=value of command, so, up to 3 counts as no params
		get_help();
		exit;
	}
	$Class = translate_bin_to_class();
	$C = new $Class();
	$p = $C->getCMDParams();
	$params = getopt($p->short,$p->long);

}else{
	if(empty($_GET)){
		get_browser_help();
		exit;
	}
	$params = $_GET;
	$Class = translate_bin_to_class();
	$C = new $Class();
}

$C->initParams($params);
$C->execute();