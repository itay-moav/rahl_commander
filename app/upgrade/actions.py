'''
Created on Aug 10, 2017

@author: Itay

The actual actions to be performed by the commands
'''
import os
# import shutil
from app import logging as L
from config.upgrade import upgrade as upgrade_config
import app.db
import app.schemachk
import config
import fnmatch

class TheBabaClass:
    '''
    on the fly object data structure
    '''
    pass

def unblock(file_name_to_unblock):
    '''
    Deleted from the upgrade db an upgrade file that failed.
    this will cause the file to be re-run if he is in the CURRENT folder
    '''
    sql = "DELETE FROM {}.rcom_sql_upgrades WHERE file_name='{}' AND execution_status<>'completed'".format(upgrade_config['upgrade_tracking_database'], \
                                                                                                      file_name_to_unblock)
    cnx = app.db.get_connection()
    cursor = cnx.cursor()
    cursor.execute(sql)



def test(limit_of_files_processed):
    '''
    runs the upgrade SQLs on the test server
    limit_of_files_process can be 0 -> all un processed files
    or a number.
    If a number, Will run that number on the files, dictionary sorted ASC
    Reads and sorts all the files in the [current] folder
    loops on the sorted list bottom to top
     if file was not processed, and I did not pass the limit of files to process
        process file
        if fail, mark with [failed_in_test]  && crash! 
    '''
    L.info('Running test upgrade on {}:{}@{}'.format(upgrade_config['test_user'],upgrade_config['test_password'],upgrade_config['test_host']))
    test_cnx      = app.db.get_test_Server_connection()
    actual_db_cnx = app.db.get_connection() # need this to know which files I already processed
    actual_db_cnx.database = upgrade_config['upgrade_tracking_database']
    test_cursor   = test_cnx.cursor()
    actual_cursor = actual_db_cnx.cursor()
    
    # Checking for failed files in the upgrade DB, Failed files will immediatly fail -> fix those before upgrades can continue
    failed_files_sql = "SELECT COUNT(*) FROM {}.rcom_sql_upgrades WHERE execution_status IN ('failed','failed_in_test')".format(upgrade_config['upgrade_tracking_database'])
    actual_cursor.execute(failed_files_sql)
    res = actual_cursor.fetchall()
    if res[0][0] > 0:
        L.fatal('There are failed files in [{}.rcom_sql_upgrades] Execution stops until you fix it!'.format(upgrade_config['upgrade_tracking_database']))
        exit(1)
                
    
    upgrade_folder = config.assets_folder + "/upgrades/current"
    L.info('Reading files from {}'.format(upgrade_folder))
    
    # loop on each file under the current folder, dictionary sorted asc, 
    # and checking each file in ACTUAL db upgrades and run the file on test server
    
    no_files_found = True
    for root, dirnames, filenames in os.walk(upgrade_folder):
        # This is where I apply the filter of the ignored file list.
        if any(ignored_partial_string in root for ignored_partial_string in config.ignore_files_dirs_with):
            continue
        
        for filename in fnmatch.filter(filenames, '*sql'):
            
            #Check file was not previously handled 
            find_file_sql = "SELECT file_name,execution_status FROM {}.rcom_sql_upgrades WHERE file_name= %s".format(upgrade_config['upgrade_tracking_database'])
            actual_cursor.execute(find_file_sql,(filename,))
            res = actual_cursor.fetchall()
            try:
                #This file was marked ready to be run, but a previous failure got it stuck
                if res[0][1] != 'pending_completion':
                    continue
            except IndexError: # I found no entry -> new or unblocked file
                pass
            
            
            # Create the pending completion entry for the file
            L.info("\n----------------------------------------\nDoing file {}\n----------------------------------------".format(filename))
            insert = "INSERT IGNORE INTO {}.rcom_sql_upgrades VALUES(%s,NOW(),'pending_completion','')".format(upgrade_config['upgrade_tracking_database'])
            params = (filename,)
            actual_cursor.execute(insert,params)
            actual_db_cnx.commit()

                        
            no_files_found = False
            f = open(root + '/' + filename,'r')
            file_content = f.read()
            f.close()
            try:
                for one_sql in file_content.split(';'):
                    if len(one_sql)>6:
                        L.info("\n----------\nabout to run SQL:\n{}\n".format(one_sql))
                        test_cursor.execute(one_sql)
            except Exception as err:
                err_msg = str(err)
                L.fatal('The last SQL has caused an error. Aborting, and marking file as failed with Error:\n{}'.format(err))
                insert = "INSERT INTO {}.rcom_sql_upgrades VALUES(%s,NOW(),'failed',%s) ON DUPLICATE KEY UPDATE execution_status='failed_in_test',time_runned=NOW(),error_message=%s".format(\
                                                                                      upgrade_config['upgrade_tracking_database'])
                params = (filename,err_msg,err_msg)
                actual_cursor.execute(insert,params)
                actual_db_cnx.commit()
                exit(1)
                
            else:
                L.debug('marking file as completed_in_test')
                update_sql = "UPDATE {}.rcom_sql_upgrades SET execution_Status='completed_in_test' WHERE file_name = %s".format(upgrade_config['upgrade_tracking_database'])
                params = (filename,)
                actual_cursor.execute(update_sql,params)
                actual_db_cnx.commit()
            
                
                
    if no_files_found:
        L.error('There are no files to upgrade with! upgrades/current folder is empty')
    exit(1)
    
    
    
def test_with_schema():
    '''
    runs the entire schema checker on the test server
    no params needed
    '''
    args= TheBabaClass()
    args.handle_all = True
    args.cnx = app.db.get_test_Server_connection()
    L.debug(args)
    app.schemachk.run(args)
    
    
def upgrade(limit_of_files_processed):
    '''
    run the upgrade SQLs on the real server
    '''
    pass


def archive_all_processed_files():
    '''
    runs on all files in the CURRENT folder and moves any previously processed files (status=completed in db)
    to the ARCHIVE folder
    '''
    #Loop on upgrade tracking DB until all files are accounted for and moved
    cnx = app.db.get_connection()
    cursor = cnx.cursor()
    sql = "SELECT file_name FROM {}.rcom_sql_upgrades WHERE execution_status = 'completed' ORDER BY time_runned DESC, file_name DESC".format(upgrade_config['upgrade_tracking_database'])
    cursor.execute(sql)
    for file_name in cursor:
        print(file_name) #TODO in=mplement archive