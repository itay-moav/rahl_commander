<?php
class Commands_ParserOption_All extends Commands_Lib_ParserOption{
	public $optionName = 'all';
	
	protected function defaultMethod(array $parsed_options){
		return ASSETS_PATH;
	}
}