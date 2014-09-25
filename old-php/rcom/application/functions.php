<?php
/**
 * General functions PROCEDURAL, BABY!
 */

/**
 * In order to support lazy loading of classes within PHP, an autoload "magic"
 * function is defined and installed in
 * PHP's execution stack.
 *
 * @param String $class
 * @throws Exception If the file does not exist or the class was not found in the file.
 * @return string full path used to include.
 */
function autoload($class) {
	$file = APP_PATH . DIRECTORY_SEPARATOR . str_replace('_',DIRECTORY_SEPARATOR,$class) . '.php';
	require_once $file;
	return $file;
}

/**
 * This enables us to decouple the output from a specific way
 * and be able to redirect it to wherever I want.
 */
function output($string){
	echo $string;
}

/**
 * Prototype to handle severity levels
 * 0-info
 * 1-bad, recoverable
 * 2-critical we die
 *
 * @param unknown_type $E
 * @param unknown_type $severity
 */
function error_monitor($E,$severity=0){
	dbg($E);
	if($severity>1)die;
}

/**
 * Prints the help page of activated command
 * TODO make it open in a read only editor, so we have search functionality, if file is big enough
 */
function get_help(){
	echo file_get_contents(APP_PATH . DIRECTORY_SEPARATOR . 'Commands' . DIRECTORY_SEPARATOR . translate_bin_to_name() . DIRECTORY_SEPARATOR . 'help');
}

/**
 * Prints the help page of activated command to browser
 * TODO make it open in a read only editor, so we have search functionality, if file is big enough
 */
function get_browser_help(){
	echo '<pre>' . trim(file_get_contents(APP_PATH . DIRECTORY_SEPARATOR . 'Commands' . DIRECTORY_SEPARATOR . translate_bin_to_name() . DIRECTORY_SEPARATOR . 'help'));
}

function translate_bin_to_name(){
	return ucfirst(str_replace(array(DIRECTORY_SEPARATOR,'.'),'',Config::getBin()));
}

function translate_bin_to_class(){
	return 'Commands_' . translate_bin_to_name() . '_Main';
}

function get_db_from_assets_path($path){
	return explode(DIRECTORY_SEPARATOR,str_replace(ASSETS_PATH,'',$path))[2];
}