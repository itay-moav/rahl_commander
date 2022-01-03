'''
Created on Aug 10, 2017

@author: Itay

The actual actions to be performed by the commands
'''
import os
from app import logging as L
import app.schemachk
import app.config
import subprocess

class TheBabaClass:
    '''
    on the fly object data structure
    '''
    pass



def mark_complete(file_name_to_mark_complete):
    '''
    Marking a single file as complete and stopping
    '''
    sql = "UPDATE {}.rcom_sql_upgrades SET execution_Status='completed' WHERE file_name = %s LIMIT 1".format(app.config.upgrade['database'])
    cnx = app.config.db_connection()
    cursor = cnx.cursor()
    cursor.execute(sql,(file_name_to_mark_complete,))
    cnx.commit()

    
    
    
def unblock(file_name_to_unblock):
    '''
    Deleted from the upgrade db an upgrade file that failed.
    this will cause the file to be re-run if he is in the CURRENT folder
    '''
    sql = "DELETE FROM {}.rcom_sql_upgrades WHERE file_name='{}' AND execution_status<>'completed'".format(app.config.upgrade['database'], \
                                                                                                      file_name_to_unblock)
    cnx = app.config.db_connection()
    cursor = cnx.cursor()
    res = cursor.execute(sql)
    cnx.commit()
    if cursor.rowcount == 0:
        raise Exception('File [{}] does not exists or is marked [completed]. I do not touch those!'.format(file_name_to_unblock))
        




def archive_all_processed_files():
    '''
    runs on all files in the CURRENT folder and moves any previously processed files (status=completed in db)
    to the ARCHIVE folder
    
    Load all file names into memeory, fetch all of those with stat completed
    '''
    #Loop on upgrade tracking DB until all files are accounted for and moved
    files_in_file_system = os.listdir(app.config.assets_folder + "/upgrades/current")
    [_move_file_if_completed(file_name) for file_name in files_in_file_system if not any(ignored_partial_string in file_name for ignored_partial_string in app.config.ignore_files_dirs_with)] # ignored files list filter
    
    
    



def validate_system():
    '''
    Checking for failed files in the upgrade DB, Failed files will immediatly fail -> fix those before upgrades can continue
    '''
    actual_db_cnx = app.config.db_connection() # need this to know which files I already processed
    actual_db_cnx.change_db(app.config.upgrade['database'])
    actual_cursor = actual_db_cnx.cursor()
    failed_files_sql = "SELECT COUNT(*) FROM rcom_sql_upgrades WHERE execution_status IN ('failed','failed_in_test')"
    actual_cursor.execute(failed_files_sql)
    res = actual_cursor.fetchall()
    if res[0][0] > 0:
        L.fatal('There are failed files in [{}.rcom_sql_upgrades] Execution stops until you fix it!'.format(app.config.upgrade['database']))
        raise Exception('We have failed sql upgrade files, fix them!')    





def test(limit_of_files_processed):
    '''
    runs the upgrade SQLs on the test server
    limit_of_files_process can be 0 -> all un processed files
    or a number.
    If a number, Will run that number on the files, sorted by execution order ASC
        process file
        if fail, mark with [failed_in_test]  && crash! 
        
    @return boolean True for files where processed, false for none
    '''
    upgrade_db_name = app.config.upgrade['database']
    test_cnx      = app.config.cnMysql.get_test_Server_connection()
    actual_db_cnx = app.config.db_connection() # need this to know which files I already processed
    actual_db_cnx.change_db(upgrade_db_name)
    test_cursor   = test_cnx.cursor()
    actual_cursor = actual_db_cnx.cursor()
    upgrade_folder = app.config.assets_folder + "/upgrades/current"
    L.info('Reading files from {}'.format(upgrade_folder))
    
    # Get all files ready for running from the DB
    limit = ''
    if limit_of_files_processed > 0:
        limit = "LIMIT " + limit_of_files_processed
        
    sql = "SELECT file_name FROM {}.rcom_sql_upgrades WHERE execution_status ='pending_completion' ORDER BY execute_order ASC {}".format(upgrade_db_name,limit)
    actual_cursor.execute(sql)
    res = actual_cursor.fetchall()
    
    # check there actually are files to work with
    if len(res) == 0:
        L.info("No files to test upon where found")
        return False
    
    for file_to_run, in res:
        real_file_path_name = upgrade_folder + '/' + file_to_run
        L.info("About to execute [{}]".format(real_file_path_name))
        f = open(real_file_path_name,'r')
        file_content = f.read()
        f.close()
        
        sql_string_for_debug = ''
        try:
            for one_sql in file_content.split(';'):
                if len(one_sql)>6:
                    sql_string_for_debug = one_sql
                    L.info("\n----------\nabout to run test SQL:\n{}\n".format(one_sql))
                    test_cursor.execute(one_sql)
                    test_cnx.commit()
                    
        except Exception as err:
            err_msg = str(err)
            L.fatal('The last SQL has caused an error. Aborting, and marking file as failed with Error:\n{}'.format(err))
            L.fatal('File: [{}]'.format(real_file_path_name))
            L.fatal("SQL: \n{}\n".format(sql_string_for_debug))
            
            update_failed_sql = "UPDATE {}.rcom_sql_upgrades SET execution_Status='failed_in_test',error_message=%s WHERE file_name = %s".format(upgrade_db_name)
            params = (err_msg,file_to_run)
            actual_cursor.execute(update_failed_sql,params)
            actual_db_cnx.commit()
            raise err
            
        else:
            L.debug('marking file as completed_in_test')
            update_sql = "UPDATE {}.rcom_sql_upgrades SET execution_Status='completed_in_test' WHERE file_name = %s".format(upgrade_db_name)
            params = (file_to_run,)
            actual_cursor.execute(update_sql,params)
            actual_db_cnx.commit()
            
    return True
        
                
                
    
    
    
def test_with_schema():
    '''
    runs the entire schema checker on the test server
    no params needed
    '''
    args = TheBabaClass()
    args.handle_all = True
    args.cnx = app.config.get_test_Server_connection()
    L.debug(args)
    app.schemachk.run(args)
    
    
def upgrade(limit_of_files_processed):
    '''
    runs the upgrade SQLs on the actual server
    limit_of_files_process can be 0 -> all un processed files
    or a number.
    If a number, Will run that number on the files, sorted by execution order ASC
        process file
        if fail, mark with [failed_in_test]  && crash! 
    '''
    actual_db_cnx = app.config.db_connection()# need this to know which files I already processed
    upgrade_db_name = app.config.upgrade['database']
    actual_db_cnx.change_db(upgrade_db_name)
    actual_cursor = actual_db_cnx.cursor()
    upgrade_folder = app.config.assets_folder + "/upgrades/current"
    L.info('Reading files from {}'.format(upgrade_folder))
    
    # Get all files ready for running from the DB
    limit = ''
    if limit_of_files_processed > 0:
        limit = "LIMIT " + limit_of_files_processed
        
    sql = "SELECT file_name FROM {}.rcom_sql_upgrades WHERE execution_status IN ('pending_completion','completed_in_test') ORDER BY execute_order ASC {}".format(upgrade_db_name,limit)
    actual_cursor.execute(sql)
    res = actual_cursor.fetchall()
    
    # check there actually are files to work with
    if len(res) == 0:
        L.info("No files to UPGRADE DB with where found")
        return False

    
    for file_to_run, in res:
        real_file_path_name = upgrade_folder + '/' + file_to_run
        L.info("About to execute [{}]".format(real_file_path_name))
        f = open(real_file_path_name,'r')
        file_content = f.read()
        f.close()
        sql_string_for_debug = ''
        try:
            for one_sql in file_content.split(';'):
                if len(one_sql)>6:
                    sql_string_for_debug = one_sql
                    L.info("\n----------\nabout to run SQL:\n{}\n".format(one_sql))
                    actual_cursor.execute(one_sql)
                    actual_db_cnx.commit()
                    
        except Exception as err:
            err_msg = str(err)
            L.fatal('The last upgrade SQL has caused an error. Aborting, and marking file as failed with Error:\n{}'.format(err))
            L.fatal('File: [{}]'.format(real_file_path_name))
            L.fatal("SQL: \n{}\n".format(sql_string_for_debug))
            update_failed_sql = "UPDATE {}.rcom_sql_upgrades SET execution_Status='failed',error_message=%s WHERE file_name = %s".format(upgrade_db_name)
            params = (err_msg,file_to_run)
            actual_cursor.execute(update_failed_sql,params)
            actual_db_cnx.commit()
            raise err
            
        else:
            L.debug('marking file as completed')
            update_sql = "UPDATE {}.rcom_sql_upgrades SET execution_Status='completed' WHERE file_name = %s".format(upgrade_db_name)
            params = (file_to_run,)
            actual_cursor.execute(update_sql,params)
            actual_db_cnx.commit()
    
    return True



    
def _move_file_if_completed(file_name):
    '''
    used in archive, moves the file if is completed
    '''
    upgrade_db_name = app.config.upgrade['database']
    cnx = app.config.db_connection()
    cursor = cnx.cursor()
    sql = "SELECT COUNT(*) FROM {}.rcom_sql_upgrades WHERE file_name=%s AND execution_status = 'completed' ".format(upgrade_db_name)
    cursor.execute(sql,(file_name,))
    res = cursor.fetchall()
    if res[0][0] == 1:
        L.info("About to ARCHIVE [{}]".format(file_name))
        subprocess.check_call(['mv',app.config.assets_folder + "/upgrades/current/" + file_name,app.config.assets_folder + "/upgrades/archive/."])
        
        
        
        
        
        
        
        
#demo - dont delete
#find_file_sql = "SELECT file_name,execution_status FROM {}.rcom_sql_upgrades WHERE file_name= %s".format(upgrade_config['upgrade_tracking_database'])
#actual_cursor.execute(find_file_sql,(filename,))
#    res = actual_cursor.fetchall()
#    try:
#This file was marked ready to be run, but a previous failure got it stuck
#         if res[0][1] != 'pending_completion':
#            continue
#         except IndexError: # I found no entry -> new or unblocked file
#            pass
            