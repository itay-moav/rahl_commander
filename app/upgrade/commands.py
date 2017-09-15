'''
Created on Aug 10, 2017

@author: Itay
'''
from app import logging as L
from config.upgrade import upgrade as upgrade_config
import app.upgrade.actions

class Unblock:
    '''
    Removes a stuck/failed/not ran yet entry of a file from the tracking table
    '''
    
    def __init__(self, file_name_to_unblock):
        self.file_name_to_unblock = file_name_to_unblock
        
    def action(self,should_i_stop):
        '''
        @var should_i_stop is boolean, the result of the previous action. If it is true
             execution should stop, but I will alert the user this ar was activated, he/she might have done a mistake
        return True will break the command string from fully executing.
        This type of command is a blocking command i.e. nothing happens later if
        this flag was supplied
        '''
        
        if self.file_name_to_unblock != None:
            if should_i_stop:
                L.error("Check your arguments --unblock was ignored. --unblock can not be used with other flags!")
                return True
            app.upgrade.actions.unblock(self.file_name_to_unblock)
            L.info("Removed {}.sql from the upgrade tracking table {}.rcom_sql_upgrades".format(self.file_name_to_unblock,upgrade_config['upgrade_tracking_database']))
            return True
        return False
            
        
    
    
        
        
        
        

class Test:
    '''
    Runs the files on the test db supplied, Will crash in case of failure, but will not 
    mark the file as failed.
    It will break the files into sql segmets by ';' to provide a better error message (in the actual command)
    '''
    def __init__(self,test_upgrade,handle_all,limit_files):
        self.do_test          = test_upgrade  or upgrade_config['force_test']
        self.handle_all_files = handle_all
        self.handle_x_files   = limit_files
        
    def validate_input(self):
        if not self.do_test:
            return False
        
        # check for conflicts
        if self.handle_all_files and self.handle_x_files != None:
            L.fatal("Please use either --all or --limit")
            exit(-1) 
        
        if self.handle_x_files != None and int(self.handle_x_files) <1:
            L.fatal("--limit must be at least 1")
            exit(-1)
            
        return True
    
    
    def  action(self,should_i_stop):
        '''
        @var should_i_stop is boolean, the result of the previous action. If it is true
             execution should stop, but I will alert the user this arg was activated, he/she might have done a mistake
        '''
        if self.do_test:
            if should_i_stop:
                L.error("Check your arguments --force_test was ignored. --force_test was used with another stand alone flag (probably --unblock)")
                return True
            
            if self.validate_input():
                if self.handle_x_files != None and int(self.handle_x_files) >0:
                    limit_of_files_processed = int(self.handle_x_files)
                    limit_info = self.handle_x_files
                else: #if I do not provide the --all flag, I still run JUST the tests on all the files.
                    limit_of_files_processed = 0 #Inverse loop, 0 means all
                    limit_info = 'all'
                    
                L.info("Will TEST upgrade with {} files".format(limit_info))
                app.upgrade.actions.test(limit_of_files_processed)   
    
        return should_i_stop
    
        
            
        





class TestServerSchema:
    '''
    Runs the full schema checker with full bailout 
    on the test server
    '''
    def __init__(self,with_schema_checker,test_upgrade,all_args):
        self.do_on_test_server  = test_upgrade  or upgrade_config['force_test']
        self.do_schema_test     = with_schema_checker or upgrade_config['force_schema_test']
        self.all_args           = all_args
        
    def action(self,should_i_stop):
        '''
        Runs the schma checker on the test server
        '''
        if self.do_on_test_server and self.do_schema_test:
            if should_i_stop:
                L.error("Check your arguments --with_schema was ignored. --with_schema was used with another stand alone flag (probably --unblock)")
                return True
            L.info("Running schema checker on test server {}@{}".format(upgrade_config['test_user'],upgrade_config['test_host']))
            app.upgrade.actions.test_with_schema()
        return should_i_stop
     
     
     
     
     
     


class Upgrade():
    '''
    Runs the actual upgrades and marks the files in the tracking DB
    '''
    def __init__(self,handle_all,limit_files):
        self.handle_all_files = handle_all
        self.handle_x_files   = limit_files
        
    def validate_input(self):
        
        # check for conflicts
        if self.handle_all_files and self.handle_x_files != None:
            L.fatal("Please use either --all or --limit")
            exit(-1) 
        
        if self.handle_x_files != None and int(self.handle_x_files) <1:
            L.fatal("--limit must be at least 1")
            exit(-1)
            
        return True
    
    
    def  action(self,should_i_stop):
        '''
        @var should_i_stop is boolean, the result of the previous action. If it is true
             execution should stop, but I will alert the user this arg was activated, he/she might have done a mistake
        '''
        if should_i_stop:
            L.error("Check your arguments running upgrades has stopped as it was used with another stand alone flag (probably --unblock)")
            return True
        
        if self.validate_input():
            if self.handle_x_files != None and int(self.handle_x_files) >0:
                limit_of_files_processed = -1 * int(self.handle_x_files)
                limit_info = self.handle_x_files
            else: #if I do not provide the --all flag, I still run JUST the tests on all the files.
                limit_of_files_processed = 0 #Invers loop, 0 means all, negative numbers I use to represent how many files more to run
                limit_info = 'all'
            L.info("Will TEST upgrade with {} files".format(limit_info))
            L.info('Running test upgrade on actual server')
            app.upgrade.actions.upgrade(limit_of_files_processed)    
    
        return should_i_stop
            
        






class Archive():
    '''
    MV files from current to archive folder
    Moves all the files that already ran, no if/buts
    '''
    def __init__(self,archive_files):
        self.archive_files = archive_files
        
    def action(self,should_i_stop):
        if should_i_stop:
            L.error("Check your arguments running --archive_files has stopped as it was used with a stand alone flag (probably --unblock)")
            return True 
        app.upgrade.actions.archive_all_processed_files()
        
