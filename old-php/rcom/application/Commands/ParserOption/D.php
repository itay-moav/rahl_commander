<?php
class Commands_ParserOption_D extends Commands_Lib_ParserOption{
	public $optionName = 'd';
	
	protected function defaultMethod(array $parsed_options){
		if(empty($parsed_options)){
			return array(
				ASSETS_PATH . DIRECTORY_SEPARATOR . 'sp' . DIRECTORY_SEPARATOR . $this->rawValue,
				ASSETS_PATH . DIRECTORY_SEPARATOR . 'triggers' . DIRECTORY_SEPARATOR . $this->rawValue,
				ASSETS_PATH . DIRECTORY_SEPARATOR . 'views' . DIRECTORY_SEPARATOR . $this->rawValue,
				ASSETS_PATH . DIRECTORY_SEPARATOR . 'functions' . DIRECTORY_SEPARATOR . $this->rawValue,
				ASSETS_PATH . DIRECTORY_SEPARATOR . 'scripts' . DIRECTORY_SEPARATOR . $this->rawValue
			
			);
		}
		foreach($parsed_options as &$option){
			$option .= DIRECTORY_SEPARATOR . $this->rawValue;
		}
		
		return $parsed_options;
	}
}