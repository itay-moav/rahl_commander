<?php
/**
 * Builds/runs the right element/script according to input params.
 * If it is an element it will first try to drop it.
 * If u want a complete DB cleanup, u need to use the clean command.
 */
class Commands_Build_Main extends Commands_Lib_Abstract{

	protected function postParser(){
	//TODO remove to the clean command
		if($this->getParam('cleanall') !== null || $this->getParam('all') !== null){
			output("I am going to clean dbs under assets for everything. STARTING...\n");
			output("\nRemoving stored procedures for:\n");
			$sp_dbs = glob(ASSETS_SP_PATH . '*');
			foreach($sp_dbs as $db_name){
				$db_name = get_db_from_assets_path($db_name);
				output('-' . $db_name . "\n");
				$sql = "SELECT routine_name FROM information_schema.routines WHERE routine_schema = '{$db_name}' AND routine_type = 'procedure'";
				$sps = Connector_MySql_DB::getInstance('information_schema')->select($sql)->fetchAllColumn();
				foreach($sps as $sp){
					Connector_MySql_DB::getInstance($db_name)->delete("DROP PROCEDURE IF EXISTS {$db_name}.{$sp}");
					output("....removed {$sp}\n");
				}
				
			}
			
			
			output("\nRemoving triggers for:\n");
			$triggers_dbs = glob(ASSETS_TRIGGERS_PATH . '*');
			foreach($triggers_dbs as $db_name){
				$db_name = get_db_from_assets_path($db_name);
				output('-' . $db_name . "\n");
				$sql = "SELECT trigger_name FROM information_schema.triggers WHERE trigger_schema = '{$db_name}'";
				$triggers = Connector_MySql_DB::getInstance('information_schema')->select($sql)->fetchAllColumn();
				foreach($triggers as $trigger){
					Connector_MySql_DB::getInstance($db_name)->delete("DROP TRIGGER IF EXISTS {$db_name}.{$trigger}");
					output("....removed {$trigger}\n");
				}
				
			}


			output("\nRemoving functions for:\n");
			$function_dbs = glob(ASSETS_FUNCTIONS_PATH . '*');
			foreach($function_dbs as $db_name){
				$db_name = get_db_from_assets_path($db_name);
				output('-' . $db_name . "\n");
				$sql = "SELECT routine_name FROM information_schema.routines WHERE routine_schema = '{$db_name}' AND `ROUTINE_TYPE` = 'function'";
				$functions = Connector_MySql_DB::getInstance('information_schema')->select($sql)->fetchAllColumn();
				foreach($functions as $function){
					Connector_MySql_DB::getInstance($db_name)->delete("DROP FUNCTION IF EXISTS {$db_name}.{$function}");
					output("....removed {$function}\n");
				}
				
			}
			
			
			output("\nRemoving views for:\n");
			$view_dbs = glob(ASSETS_VIEWS_PATH . '*');
			foreach($view_dbs as $db_name){
				$db_name = get_db_from_assets_path($db_name);
				output('-' . $db_name . "\n");
				$sql = "SELECT table_name FROM information_schema.tables WHERE table_type = 'view' AND table_schema = '{$db_name}';";
				$views = Connector_MySql_DB::getInstance('information_schema')->select($sql)->fetchAllColumn();
				foreach($views as $view){
					Connector_MySql_DB::getInstance($db_name)->delete("DROP VIEW IF EXISTS {$db_name}.{$view}");
					output("....removed {$view}\n");
				}
				
			}
			
			
		}
		return $this;
	}
	
	protected function process(){
		$content = file_get_contents($this->current_row->getPathname());
		if($this->Parser->searchForObjectsIn($content)){
			output("\n\n\nBEGIN FILE: {$this->current_row->getFilename()}          PATH: {$this->current_row->getPath()}\n");
			Connector_MySql_DB::getInstance(get_db_from_assets_path($this->current_row->getPath()))->create($content);
			output("\n\n\n");
		}
	}
}