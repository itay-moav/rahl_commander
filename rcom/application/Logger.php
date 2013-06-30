<?php
/**
 * Logger API as a procedural, because procedural is less writing.
 * and less writing is good.
 * I ASSUME YOU INTIALIZED THE LOGGER IN YOUR BOOTSTRAP, AS ONE OF THE FIRST THINGS U DO IN YOUR APP!
 */
 
function debug($inp){
	Logger::$CurrentLogger->debug($inp);
}

function info($inp){
	Logger::$CurrentLogger->info($inp);
}

function warning($inp){
	Logger::$CurrentLogger->warning($inp);
}

function error($inp){
	Logger::$CurrentLogger->error($inp);
}

function fatal($inp){
	Logger::$CurrentLogger->fatal($inp);
}
 
/**
 * for debug purposes only. Echoes stuff to the slog
 *
 * @param mixed $var, preferably an array you want to log
 * @param boolean $die should I die after sloging?
 */
function dbg($var,$die=false){
	debug($var);
	if($die){
		die;
	}
}
function dbgd($var){
	dbg($var,true);
}
function dbgn($n,$die=false){
	dbg("==========================={$n}===============================", $die);
}
function dbgt($var = null, $die = false) {
	$E = new Exception();
	dbg($E->getTraceAsString());
	dbg($var, $die);
}
function dbgh($n,$var,$die = false){
	dbgn($n);
	dbg($var,$die);
}


/**
 * Logger abstract, handles creating logs for systems.
 */
abstract class Logger{
	const	VERBOSITY_LVL_DEBUG		= 4,
			VERBOSITY_LVL_INFO		= 3,
			VERBOSITY_LVL_WARNING	= 2,
			VERBOSITY_LVL_ERROR		= 1,
			VERBOSITY_LVL_FATAL		= 0
	;
	
	/**
	 * @var Logger current Logger to be used in the app.
	 *             To change current Logger, simply use the factory again (or just instantiate 
	 *             the logger you want.
	 */
	static public $CurrentLogger = null;
	
	/**
	 * @param string $log_name		A name for the log output (for example, if this is a file log, this would be part of the file name, usage
	 *								depends on the specific Logger class used.
	 * @param string $logger_type	Logger type, depends on the class names u have under the Logger folder. Use the Logger_[USE_THIS] value
	 * 								as the available types.
	 * @param integer $verbosity_level which type of messages do I actually log, Values are to use the constants Logger::VERBOSITY_LVL_*
	 *								Sadly, in your environment file, you will probably need to use pure numbers, unless u include the Logger.php 
	 *								before you load the environment values (where you should configure the system verbosity level).
	 * @param mixed $target_stream	The target of the Logger, can be any class implementing the Logger_iWrite interface
	 *								that wraps a resource (like a socket/DB connection etc.), File path if writes to file or nothing, is simply Echo's  
	 *             To change current Logger, simply use the factory again (or just instantiate 
	 *             the logger you want.
	 *
	 * @return Logger
	 */
	static public function factory($log_name,$logger_type,$verbosity_level,$target_stream=null){
		$class_name = 'Logger_' . ucfirst($logger_type);
		self::$CurrentLogger = new $class_name($log_name,$verbosity_level,$target_stream);
		return self::$CurrentLogger;
	}
	
	/**
	 * This function writes to the designated output stream/resources.
	 */
	abstract protected function log($txt);
	
	protected function tlog($inp){
		if ($inp === null){
			$inp = 'NULL';
			
		}elseif(!is_string($inp)){
			$inp = print_r($inp,true);
			
		}
		$this->log($inp);
	}
	
	protected	$log_name			= '',
				$verbosity_level	= Logger::VERBOSITY_LVL_DEBUG,
				$target_stream		= null
	;
	
	public function __construct($log_name,$verbosity_level,$target_stream=null){
		$this->log_name = $log_name;
		$this->verbosity_level = $verbosity_level;
		$this->target_stream = $target_stream;
	}
	
	public function debug($inp){
		if($this->verbosity_level >= self::VERBOSITY_LVL_DEBUG){
			$this->tlog($inp);
		}
	}
	
	public function info($inp){
		if($this->verbosity_level >= self::VERBOSITY_LVL_INFO){
			$this->tlog($inp);
		}
	}

	public function warning($inp){
		if($this->verbosity_level >= self::VERBOSITY_LVL_WARNING){
			$this->tlog($inp);
		}
	}
	
	public function error($inp){
		if($this->verbosity_level >= self::VERBOSITY_LVL_ERROR){
			$this->tlog($inp);
		}
	}
	
	public function fatal($inp){
		if($this->verbosity_level >= self::VERBOSITY_LVL_FATAL){
			$this->tlog($inp);
		}
	}

}