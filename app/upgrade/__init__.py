'''
Created on Aug 03, 2017

@author: Itay Moav
'''
__version__ = '1.0'

from app import logging as L
from collections import deque
from config.upgrade import upgrade as upgrade_config
import config
import app.upgrade.commands
import os

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
    commands.appendleft(app.upgrade.commands.Unblock(args.file_name_to_unblock))
    
    #--test
    commands.appendleft(app.upgrade.commands.Test(args.test_upgrade,args.handle_all,args.limit_files))
    
    #--with_schema
    commands.appendleft(app.upgrade.commands.TestServerSchema(args.with_schema_checker,args.test_upgrade,args))
    
    #--limit=X   ||   --all
    commands.appendleft(app.upgrade.commands.Upgrade(args.handle_all,args.limit_files))
    
    #--archive
    commands.appendleft(app.upgrade.commands.Archive(args.archive_files))
    
    # Sync sql_upgrades table with the file system
    sync_files_to_db()
    
    # go go go
    #run_commands(commands)
    





def run_commands(commands):
    '''
    actually running the commands
    '''
    should_i_stop = False
    while commands:
        command = commands.pop()
        should_i_stop = command.action(should_i_stop)
        
        
        
def sync_files_to_db():
    '''
    Check all NONE completed files in the db, if no longer exist in file system -> delete Entry
    
    Check file system for any file not yet in db, create an entry with [pending_completion] STATUS
    '''
    
    
    # db boilerplate
    cnx = app.db.get_connection() # need this to know which files I already processed
    cnx.database = upgrade_config['upgrade_tracking_database']
    cursor = cnx.cursor()
    
    # read all files
    files_in_file_system = os.listdir(config.assets_folder + "/upgrades/current")
    
    # -------------------------------------------------------------------------------------------------------------------------------------------------
    # Check all NONE completed files in the db, if no longer exist in file system -> delete Entry
    # -------------------------------------------------------------------------------------------------------------------------------------------------
    find_files_sql = "SELECT file_name FROM {}.sql_upgrades WHERE execution_status <> 'completed'".format(upgrade_config['upgrade_tracking_database'])
    cursor.execute(find_files_sql)
    res = cursor.fetchall()
    
    files_to_delete_from_db = []
    for db_file, in res: # the extra , is to directly unpack the touple here, in this line
        if db_file in files_in_file_system:
            # ALL GOOD, DO NOTHING
            continue; # to next file
        else:
            files_to_delete_from_db.append(db_file)
    
    if len(files_to_delete_from_db) > 0:
        sql_in = "('" + "','" .join(files_to_delete_from_db) + "')"
        cursor = cnx.cursor()
        sql = "DELETE FROM {}.sql_upgrades WHERE file_name IN {}".format(upgrade_config['upgrade_tracking_database'],sql_in)
        L.debug(sql)
        cursor.execute(sql)
    
    
    # -------------------------------------------------------------------------------------------------------------------------------------------------
    # Check file system for any file not yet in db, create an entry with [pending_completion] STATUS
    # -------------------------------------------------------------------------------------------------------------------------------------------------
    values =["('"+file_name+"','','pending_completion',NULL)" for file_name in files_in_file_system  \
             if not (any(ignored_partial_string in file_name for ignored_partial_string in config.ignore_files_dirs_with))] # ignored files list filter
             
    values = ','.join(values)
    print(values)
        
    THIS IS WHERE I STOPPED -> I NEED TO RUN THE DELETE COMMAND ON THE DABASE OF THE FILES NO LONGER IN FILE SYSTEM AND NOT COMPLETED
    AND I THEN NEED TO INSERT NEW FILES INTO THE UPGRADE_TABLE
    THERN I NEED TO REWRITE THE ACTION FILE, I STOPPED AT TEST, I CAN REMOVE A LOT OF CHECKS NOW ON THE FILE SYSTEM AND I CAN SORT LIST IN
    THE DATABASE AND FETCH IT LIMITED AND SORTED
        
    #find_file_sql = "SELECT file_name FROM {}.sql_upgrades WHERE file_name '{}'".format(upgrade_config['upgrade_tracking_database'],file_name)
        
    