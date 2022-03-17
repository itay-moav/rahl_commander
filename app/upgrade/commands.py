'''
Created on Aug 10, 2017

@author: Itay
'''
from app import logging as L
from app.config import upgrade as upgrade_config
from argparse import ArgumentError

class MarkCompleted:
    '''
    will mark file as completed (sometimes you will run files manually and want the system to know it
    '''
    
    def __init__(self, file_name_to_mark_complete):
        self.file_name_to_mark_complete = file_name_to_mark_complete
        
    def action(self):
        '''
        @return should_i_stop boolean
                the result of the previous action. If it is true
                execution should stop, but I will alert the user this arg was activated, he/she might have done a mistake
                return True will break the command string from fully executing.
                This type of command is a blocking command i.e. nothing happens later if
                this flag was supplied
        '''
        if self.file_name_to_mark_complete != None:
            import app.upgrade.actions #TODO I really need to figure out the order of stuff and remove all I can from __init__py files
            L.info("Marking {} as COMPLETE in upgrade tracking table {}.rcom_sql_upgrades".format(self.file_name_to_mark_complete,upgrade_config['database']))
            app.upgrade.actions.mark_complete(self.file_name_to_mark_complete)
            return True
        return False





class Unblock:
    '''
    Removes a stuck/failed/not ran yet entry of a file from the tracking table
    '''
    
    def __init__(self, file_name_to_unblock):
        self.file_name_to_unblock = file_name_to_unblock
        
    def action(self):
        '''
        @return should_i_stop boolean
                the result of the previous action. If it is true
                execution should stop, but I will alert the user this arg was activated, he/she might have done a mistake
                return True will break the command string from fully executing.
                This type of command is a blocking command i.e. nothing happens later if
                this flag was supplied
        '''
        
        if self.file_name_to_unblock != None:
            import app.upgrade.actions
            app.upgrade.actions.unblock(self.file_name_to_unblock)
            L.info("Removed {}.sql from the upgrade tracking table {}.rcom_sql_upgrades".format(self.file_name_to_unblock,upgrade_config['database']))
            return True
        return False
            






class Archive():
    '''
    MV files from current to archive folder
    Moves all the files that already ran, no if/buts
    '''
    def __init__(self,archive_files):
        self.archive_files = archive_files
        
    def action(self):
        '''
        @return should_i_stop boolean
                the result of the previous action. If it is true
                execution should stop, but I will alert the user this arg was activated, he/she might have done a mistake
                return True will break the command string from fully executing.
                This type of command is a blocking command i.e. nothing happens later if
                this flag was supplied
        '''
        if self.archive_files:
            import app.upgrade.actions
            app.upgrade.actions.archive_all_processed_files()
            return True
        return False





class ValidateSystem:
    '''
    Validate the status of the system (no unhandled failed files, no ...
    '''

        
    def action(self):
        '''
        @return should_i_stop boolean
                the result of the previous action. If it is true
                execution should stop, but I will alert the user this arg was activated, he/she might have done a mistake
                return True will break the command string from fully executing.
                This type of command is a blocking command i.e. nothing happens later if
                this flag was supplied
        '''
        L.info("Validating system files and db entries")
        import app.upgrade.actions
        app.upgrade.actions.validate_system()
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
            raise ArgumentError('--all',"Please use either --all or --limit")
        
        if self.handle_x_files != None and int(self.handle_x_files) <1:
            raise ArgumentError('--limit',"--limit must be at least 1")
            
        return True
    
    
    def  action(self):
        '''
        @return should_i_stop boolean
                the result of the previous action. If it is true
                execution should stop, but I will alert the user this arg was activated, he/she might have done a mistake
                return True will break the command string from fully executing.
                This type of command is a blocking command i.e. nothing happens later if
                this flag was supplied
        '''
        if self.do_test:
            if self.validate_input():
                if self.handle_x_files != None and int(self.handle_x_files) >0:
                    limit_of_files_processed = int(self.handle_x_files)
                    limit_info = self.handle_x_files
                else: #if I do not provide the --all flag, I still run JUST the tests on all the files.
                    limit_of_files_processed = 0 #Inverse loop, 0 means all
                    limit_info = 'all'
                    
                L.info('RUNNING TEST upgrade on {}:{}@{}'.format(upgrade_config['test_user'],upgrade_config['test_password'],upgrade_config['test_host']))
                L.info("WILL TEST upgrade with {} files".format(limit_info))
                import app.upgrade.actions
                files_where_processed = app.upgrade.actions.test(limit_of_files_processed)
                if not files_where_processed:
                    return True
    
        return False
    
        
            
        





class TestServerSchema:
    '''
    Runs the full schema checker with full bailout 
    on the test server
    '''
    def __init__(self,with_schema_checker,test_upgrade,all_args):
        self.do_on_test_server  = test_upgrade  or upgrade_config['force_test']
        self.do_schema_test     = with_schema_checker or upgrade_config['force_schema_test']
        self.all_args           = all_args
        
    def action(self):
        '''
        Runs the schma checker on the test server

        @return should_i_stop boolean
                the result of the previous action. If it is true
                execution should stop, but I will alert the user this arg was activated, he/she might have done a mistake
                return True will break the command string from fully executing.
                This type of command is a blocking command i.e. nothing happens later if
                this flag was supplied
        '''
        if self.do_on_test_server and self.do_schema_test:
            L.info("Running schema checker on test server {}@{}".format(upgrade_config['test_user'],upgrade_config['test_host']))
            import app.upgrade.actions
            app.upgrade.actions.test_with_schema()
        return False
     
     
     
     
     
     


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
            raise ArgumentError('--all',"Please use either --all or --limit") 
        
        if self.handle_x_files != None and int(self.handle_x_files) <1:
            raise ArgumentError('--limit',"--limit must be at least 1")
            
        return True
    
    
    def  action(self):
        '''
        @return should_i_stop boolean
                the result of the previous action. If it is true
                execution should stop, but I will alert the user this arg was activated, he/she might have done a mistake
                return True will break the command string from fully executing.
                This type of command is a blocking command i.e. nothing happens later if
                this flag was supplied
        '''
        if self.validate_input():
            if self.handle_x_files != None and int(self.handle_x_files) >0:
                limit_of_files_processed = -1 * int(self.handle_x_files)
                limit_info = self.handle_x_files
            else: #if I do not provide the --all flag, I still run JUST the tests on all the files.
                limit_of_files_processed = 0 #Invers loop, 0 means all, negative numbers I use to represent how many files more to run
                limit_info = 'all'

            L.info('RUNNING UPGRADE ON ACTUAL SERVER')
            L.info("WILL UPGRADE with {} files".format(limit_info))
            import app.upgrade.actions
            files_where_processed = app.upgrade.actions.upgrade(limit_of_files_processed)
            if not files_where_processed:
                return True

        return False
            
        




        
