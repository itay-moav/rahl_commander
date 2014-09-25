<?php
class Commands_ParserOption_R extends Commands_Lib_ParserOption{
	public $optionName = 'r';
	protected function defaultMethod(array $parsed_options){
		$parsed_options []= ASSETS_PATH . DIRECTORY_SEPARATOR . 'scripts';
		return $parsed_options;
	}
	
	/**
	 * Not all filters have a value the main command object need to search by.
	 * So, by default, return false. Tun it on in each filter element that is searchable
	 * by returning the raw value
	 */
	public function getSearchValue(){
		return $this->rawValue;
	}
}