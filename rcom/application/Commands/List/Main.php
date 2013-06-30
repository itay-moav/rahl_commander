<?php
class Commands_List_Main extends Commands_Lib_Abstract{
	protected function process(){
		$content = file_get_contents($this->current_row->getPathname());
		if($this->Parser->searchForObjectsIn($content)){
			output("\n\n\n==================== BEGIN FILE: {$this->current_row->getFilename()}          PATH: {$this->current_row->getPath()} =================================\n\n");
			output($content);
			output("\n\n\n\n");
		}
	}
}