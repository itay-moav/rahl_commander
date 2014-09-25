<?php
/**
 * @author      Itay Moav
 * @date        6-5-2013
 *
 * Parsing options into code
 */
abstract class Commands_Lib_Parser{
        /**
         * Making sure indexes are same as elements names, will have to make sure about the local ids tooo
         *
         */
        static public function arrayBuilder(){
                $Parser_options=func_get_args();
                $ret=array();
                foreach($Parser_options as $ParserOption){
                        $ret[$ParserOption->optionName]=$ParserOption;
                }
                return $ret;
        }
		
		/**
		 * @var string name or partial name of string/s that has to appear in found files. (grep)
		 */
		protected $search_for_objects = array();
		
		/**
		 * Default initial value for the long params accepted by this Command object
		 * params which are not handled by the Parser
		 */
		protected $long_params = array('command:');

        /**
         * Get back to you with the correct Parser for your report class.
         * If no specific Parser exists it will return the current Parser (self) i.e. default Parser
         *
         * @return MyLib_Reports_Parser_Default
         */
        public static function factory($bl_name){
			dbgn('in Parser for ' . $bl_name);
			//init Parser
			$class_name=$bl_name . 'Parser';//The PARSER class is defined in the same file as the report class itself and should have the exact same name + Parser.
											//The reasoning is to achieve something similar to Assembly in C#

			return new $class_name($bl_name);
        }

        /**
         * @var Commands_Lib_Abstract owner of this parser
         */
        public $owner='';
        /**
         * @var array $rawRequestParams
         */
        public  $rawRequestParams;
        /**
         * @var array multi dim of Parser elements.
         *
         * Actual format must conform to the view file rendering it.
         * Did not went on a general approach, may be in the future
         * given enough reason to do so.
         */
        public  $parserElements=array();

        /**
         * Constructs & Retrieves the Where and Join statment from the Parsers
         * And the parameters of the query
         *
         * @return array of WHERE | JOIN
         */
        public function applyParser(){
			$parsed_options=array();
			foreach ($this->parserElements as $MyParserElement){
				$MyParserElement->initOption();
				/*@var $MyParserElement Commands_Lib_ParserOption */
				if(!$MyParserElement->isActivated()){
						continue;
				}
				$parsed_options = $MyParserElement->getParsedOption($parsed_options);
				if($MyParserElement->getRawValue() !== Commands_Lib_ParserOption::ACTIVE && $v = $MyParserElement->getSearchValue()){
					$this->search_for_objects []= $v;
				}
			}
		
			return $parsed_options;
        }

		/**
		 * Searches the input string for occurrences of $this->search_for_objects
		 * @return boolean
		 */
		public function searchForObjectsIn($content){
			if(empty($this->search_for_objects)){
				return true;
			}
			$check = str_replace($this->search_for_objects,'',$content);
			if($check == $content){
				return false;
			}
			return true;
		}
		
        /**
         * Returns all the Parsers with values formated as a query string
         * (this can be done inside getWhereJoin, but I'll leave it outside for better code maintainability)
         *
         * @return string
         */
        public function getParsersAsQueryString(){
                $query_string='';
                foreach ($this->parserElements as $MyParserElement){
					/*@var $MyParserElement MyLib_Reports_Parser_Element_Abstract */
					$query_string .= $MyParserElement->getAsQueryString();
				}
                return $query_string;
        }

        /**
         * Late additions of parameters to the Parser
         * For now I will assume it is onlu hiddens and group IDs
         *
         * @param string $param_key
         * @param mixed $param_value
         */
        public function addParam($param_key,$param_value){
                foreach ($this->parserElements as $MyParserElement){
						if($MyParserElement->elementName == $param_key){
								$MyParserElement->setRawValue($param_value);
								return $this;
						}
				}
                return $this;
        }

        public function getParam($param_key){
			foreach ($this->parserElements as $MyParserElement){
					if($MyParserElement->elementName == $param_key){
							return $MyParserElement->getRawValue();
					}
			}
			return null;
        }

        /**
         * @param Commands_Lib_Abstract $owner
         */
        public function __construct(Commands_Lib_Abstract $owner){
            $this->owner=$owner;
			$this->init();
			$this->constructElements();
        }//EOF constructor

        protected function init(){
	    }
		
		/**
		 * Feed the parser with the options of the command
		 */
		public function initParams(array $request_params){
			$this->rawRequestParams=$request_params;
			dbgh('RAW PARAMS IN Parser',$this->rawRequestParams);
		}
		
		public function getCMDParams(){
			$ret = new stdClass;
			$ret->short = '';
			$ret->long = $this->long_params;
			foreach($this->parserElements as $k=>$v){
				if(strlen($k) == 1){
					$ret->short .= $k . '::';
				}else{
					$ret->long []= $k . '::';
				}
			}
			return $ret;
		}
		
        /**
         * Construct the Parser elements under three sub categories(who, what, where).
         * The order of elements as created here is the order you will see them in the view!
         *
         *
         */
        abstract protected function constructElements();

}//EOF CLASS

