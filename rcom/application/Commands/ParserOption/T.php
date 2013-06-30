<?php
class Commands_ParserOption_T extends Commands_Lib_ParserOption{
	public $optionName = 't';
	protected function defaultMethod(array $parsed_options){
		$parsed_options []= ASSETS_PATH . DIRECTORY_SEPARATOR . 'triggers';
		return $parsed_options;
	}
}