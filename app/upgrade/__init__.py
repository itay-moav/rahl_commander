'''
Created on Aug 03, 2017

@author: Itay Moav
'''
__version__ = '1.0'

from app import logging as L
from collections import deque
from app.config import upgrade as upgrade_config
import app.config as config
import app.upgrade.commands
import os

def run(args):
    '''
    extract the args and populate with efaults where relevant
    and decide what to run
    This one seems to be procedural in nature hmmmmm 
    '''
    
    # Start
    #L.debug('INPUT')
    #L.debug(args)
    #L.debug(upgrade_config.__repr__())
    L.debug("\n\n--------------------------------------------------- START UPGRADING --------------------------------------------------------\n\n")

    # Sync rcom_sql_upgrades table with the file system
    sync_files_to_db()
    
    commands = deque([])

    #--mark_completed     -> will mark file as completed (sometimes you will run files manually and want the system to know it 
    commands.appendleft(app.upgrade.commands.MarkCompleted(args.file_name_to_mark_complete))
        
    #--unblock     -> blocking action, will exit 
    commands.appendleft(app.upgrade.commands.Unblock(args.file_name_to_unblock))
    
    #--archive
    commands.appendleft(app.upgrade.commands.Archive(args.archive_files))
    
    # Validate System -> no command = this always happens, unless blocking/unblocking happens (then we dont get here)
    #-- After unlblock, which might remove problematic files, I am doing validations on the system, no point continuing 
    #if issues found
    commands.appendleft(app.upgrade.commands.ValidateSystem())
    
    #--test
    commands.appendleft(app.upgrade.commands.Test(args.test_upgrade,args.handle_all,args.limit_files))
    
    #--with_schema
    commands.appendleft(app.upgrade.commands.TestServerSchema(args.with_schema_checker,args.test_upgrade,args))
    
    #--limit=X   ||   --all
    commands.appendleft(app.upgrade.commands.Upgrade(args.handle_all,args.limit_files))
    
    # go go go
    run_commands(commands)
    





def run_commands(commands):
    '''
    actually running the commands

        @var should_i_stop is boolean, the result of the previous action. If it is true
         execution should stop, but I will alert the user this arg was activated, he/she might have done a mistake
        return True will break the command string from fully executing.
        This type of command is a blocking command i.e. nothing happens later if
        this flag was supplied

    '''
    should_i_stop = False
    while commands:
        if should_i_stop:
            L.info("Either no files to work with where found, OR You have used a solo command like --unblock, --mark_complete or --archive.\nNo further actions will take place.\nBye Bye!")
            return
        command = commands.pop()
        should_i_stop = command.action()
        
        
        
def sync_files_to_db():
    '''
    Check all NONE completed files in the db, if no longer exist in file system -> delete Entry
    
    Check file system for any file not yet in db, create an entry with [pending_completion] STATUS
    
    Reset status of all [completed in test] files to be [pending completion]
    '''
    
    
    # db boilerplate
    cnx = config.db_connection() # need this to know which files I already processed
    cnx.change_db(upgrade_config['database'])
    cursor = cnx.cursor()
    
    # read all files
    files_in_file_system = os.listdir(config.assets_folder + "/upgrades/current")
    
    # -------------------------------------------------------------------------------------------------------------------------------------------------
    # Check all NONE completed files in the db, if no longer exist in file system -> delete Entry
    # -------------------------------------------------------------------------------------------------------------------------------------------------
    find_files_sql = "SELECT file_name FROM {}.rcom_sql_upgrades WHERE execution_status <> 'completed'".format(upgrade_config['database'])
    cursor.execute(find_files_sql)
    res = cursor.fetchall()
    
    files_to_delete_from_db = []
    for db_file, in res: # the extra , is to directly unpack the touple here, in this line
        if db_file in files_in_file_system:
            # ALL GOOD, DO NOTHING
            continue; # to next file
        else:
            L.warning('No longer in file system, deleting from rcom_sql_upgrades [{}]'.format(db_file))
            files_to_delete_from_db.append(db_file)
    
    if len(files_to_delete_from_db) > 0:
        sql_in = "('" + "','" .join(files_to_delete_from_db) + "')"
        cursor = cnx.cursor()
        sql = "DELETE FROM {}.rcom_sql_upgrades WHERE file_name IN {}".format(upgrade_config['database'],sql_in)
        #L.debug(sql)
        cursor.execute(sql)
    
    
    # -------------------------------------------------------------------------------------------------------------------------------------------------
    # Check file system for any file not yet in db, create an entry with [pending_completion] STATUS
    # -------------------------------------------------------------------------------------------------------------------------------------------------
    values =["('"+file_name+"'," + get_file_execution_order(file_name) + ",NULL,'pending_completion',NULL)" for file_name in files_in_file_system  \
             if not any(ignored_partial_string in file_name for ignored_partial_string in config.ignore_files_dirs_with)] # ignored files list filter
    
    if len(values) > 0:         
        values = ','.join(values)
        sql = "INSERT IGNORE INTO {}.rcom_sql_upgrades VALUES {}".format(upgrade_config['database'],values)
        #L.debug(sql)
        cursor.execute(sql)
    
    # -------------------------------------------------------------------------------------------------------------------------------------------------
    # Reset status of all [completed in test] files to be [pending completion]
    # -------------------------------------------------------------------------------------------------------------------------------------------------
    L.debug('reset completed in test to be pending completion')
    update_sql = "UPDATE {}.rcom_sql_upgrades SET execution_Status='pending_completion' WHERE execution_Status='completed_in_test'".format(upgrade_config['database'])
    cursor.execute(update_sql)
    
    # SAVING ALL CHANGES TO DB
    cnx.commit()
    
    
    
        
     
def get_file_execution_order(file_name):
    '''
    Checks that xxx in  xxx_fff_ggg.sql file name is a number.
    If it is, will use that as the expected running order of the file,
    otherwise, return "1"
    '''
    parts = file_name.split('_')
    try: 
        int(parts[0])
        return parts[0]
    except ValueError:
        return 1

