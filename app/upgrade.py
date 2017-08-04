'''
Created on Aug 03, 2017

@author: Itay Moav
'''
#import os
#import shutil
import config
from app import logging as L
from config.upgrade import upgrade as upgrade_config
from email.message import Message


def run(args):
    '''
    extract the args and populate with efaults where relevant
    and decide what to run
    This one seems to be procedural in nature hmmmmm 
    '''
    L.debug('INPUT')
    L.debug(args)
    L.debug(upgrade_config.__repr__())
    
    commands = []
    
    #--restore_all -> blocking action, will exit 
    
    
    #--unblock     -> blocking action, will exit 
    
    
    #--test
    
    
    #--limit=X   ||   --all
    
    
    #--archive
    
    
    run_commands(commands)
    
    
    
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



TODO WRITE FIRST THE ACTUAL FILE ITTERATR WITH A BLANK ACTION TO DO ON EACH FILE
     ACTION SHOULD GET A CHAIN OF COMMAND OBJECT TO RUN ON EACH FILE.
     ONE OF THOSE WOULD BE THE LIVE SQL CONNECTION, SO NO NEED TO RECONNECT EACH TIME
     HE MAIN COMMAND (run) WILL CREATE THE CHAIN OF COMMANDS FROM THE INPUT 

     EACH COMMAND WILL BE ENCAPS IN A CLASS FACTORY WICH WILL READ PARAMS AND EITHER RETURN NOTHIN,ACTIUAL OBJECT OR ERROR Message
     