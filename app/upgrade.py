'''
Created on Aug 03, 2017

@author: Itay Moav
'''
#import os
#import shutil
import config
from app import logging as L
import app.db
from config.upgrade import upgrade as upgrade_config
from collections import deque


def run(args):
    '''
    extract the args and populate with efaults where relevant
    and decide what to run
    This one seems to be procedural in nature hmmmmm 
    '''
    L.debug('INPUT')
    L.debug(args)
    L.debug(upgrade_config.__repr__())
    
    commands = deque([])
    
    #--unblock     -> blocking action, will exit 
    commands.appendleft(UnblockCommand(args.file_name_to_unblock))
    
    #--test
    commands.appendleft(TestCommand(args.test_upgrade,args.handle_all,args.limit_files))
    
    #--limit=X   ||   --all
    commands.appendleft(UpgradeCommand(args.handle_all,args.limit_files))
    
    #--archive
    commands.appendleft(ArchiveCommand(args.archive_files))
    
    run_commands(commands)
    

class UnblockCommand:
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
            
            sql = "DELETE FROM {}.sql_upgrades WHERE file_name='{}' AND execution_status<>'completed'".format(upgrade_config['upgrade_tracking_database'], \
                                                                                                       self.file_name_to_unblock)
            cnx = app.db.get_connection()
            cursor = cnx.cursor()
            cursor.execute(sql)
            return True
        return False
            
        
        
        
    
def something(args):    
    # check for conflicts
    if args.handle_all and args.limit_files != None:
        L.fatal("Please use either --all or --limit")
        exit(-1) 
        
    if args.limit_files != None and int(args.limit_files) <1:
        L.fatal("--limit must be at least 1")
        exit(-1)
        
    run_upgrades = False
    if args.limit_files != None and int(args.limit_files) >0:
        run_upgrades = True
        limit_of_files_processed = int(args.limit_files)
        limit_info = args.limit_files
        
    if args.handle_all:
        run_upgrades = True
        limit_of_files_processed = 0
        limit_info = 'all'
    
    if run_upgrades:
        L.info("Will upgrade with {} files".format(limit_info))
    
        if args.test_upgrade or upgrade_config['force_test']:
            L.info('Running test upgrade on {}:{}@{}'.format(upgrade_config['test_user'],upgrade_config['test_password'],upgrade_config['test_host']))
            conn_config = {'user':upgrade_config['test_user'],'password':upgrade_config['test_password'],'host':upgrade_config['test_host']}
            run_upgrade(limit_of_files_processed,conn_config)
            
        

def run_commands(commands):
    pass

def run_upgrade(limit_of_files_processed,conn_config):
    pass


