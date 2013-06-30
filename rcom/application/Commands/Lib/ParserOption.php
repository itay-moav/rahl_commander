<?php
/**
 * @author      Itay Moav
 * @date        06-05-2013
 *
 * Option object for the command generator
 * Each class represents one option, 
 * for each command there will be different 
 * implementation of that option
 */
abstract class Commands_Lib_ParserOption{
		const ACTIVE	 = true,
			  NOT_ACTIVE = false;
		

        /**
         * I use this to cache the values I get in getSqlWhere() for the mysql binding
         */
        protected $params=array();
        /**
         * @var Commands_Lib_Parser Owner Parser
         */
        protected $Owner=null;
        /**
         * Needs to be overidden in each concrete usage
         * @var string $optionName key in the input array of values.
         */
        public $optionName='';
        /**
         * @var mixed $rawValue the raw value from the input array to the constructor.
         */
        protected $rawValue;

        //----------------------------------------------------------------- methods -----------------------------------------------------

        /**
         * Stores the relevant data piece to this element from an array of input data (like a POST array)
         */
        public function __construct(Commands_Lib_Parser $Parser){
                $this->Owner=$Parser;
        }//EOF constructor

		public function initOption(){
			$this->rawValue=isset($this->Owner->rawRequestParams[$this->optionName])?
								($this->Owner->rawRequestParams[$this->optionName]?:self::ACTIVE):self::NOT_ACTIVE;
			return $this->rawValue;
		}
		
        /**
         * @return string relevant sql `where` statment.
         */
        public function getParsedOption(array $current_list_of_dirs){
                if(!$this->isActivated()) return '';
                $method = get_class($this->Owner->owner);
                if(method_exists($this,$method)){
                        $r = $this->{$method}($current_list_of_dirs);
                }
				$r = $this->defaultMethod($current_list_of_dirs);
				return is_array($r)?$r:array($r);
        }

        public function getOwner(){
                return $this->owner;
        }

        /**
         * The default action for this option, if there is one.
         */
        protected function defaultMethod(array $parsed_options){
			return null;
		}

        public function getAsQueryString(){
                if(is_array($this->rawValue)){
                        $ret='';
                        foreach($this->rawValue as $k=>$v){
                                $ret .= "&{$this->optionName}[{$k}]={$v}";
                        }
                        return $ret;
                }
                if($this->rawValue){
                        return '&' . $this->optionName . '=' . $this->rawValue;
                }
                return '';
        }

        /**
         * @return boolean if to activate this Parser element or not
         */
        public function isActivated(){
                return $this->rawValue;
        }

        public function getRawValue(){
                return $this->rawValue;
        }
		
		/**
		 * Not all filters have a value the main commnad object nead to search by.
		 * So, by default, return false. Tun it on in each filter element that is searchable
		 * by returniong the raw valuw
		 */
		public function getSearchValue(){
			return false;
		}
		
        public function setRawValue($param_value){
                $this->rawValue = $param_value;
                return $this;
        }
}//EOF CLASS