<?php
class Logger_Stdio extends Logger{
	protected function log($inp){
		echo $inp . "\n";
	}
}