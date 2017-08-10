'''
Created on Aug 10, 2017

@author: Itay

The actual actions to be performed by the commands
'''
#import os
#import shutil
from app import logging as L
from config.upgrade import upgrade as upgrade_config
import app.db

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
    sql = "DELETE FROM {}.sql_upgrades WHERE file_name='{}' AND execution_status<>'completed'".format(upgrade_config['upgrade_tracking_database'], \
                                                                                                      file_name_to_unblock)
    cnx = app.db.get_connection()
    cursor = cnx.cursor()
    cursor.execute(sql)



def test(limit_of_files_processed):
    '''
    runs the upgrade SQLs in the test server
    '''
    L.info('Running test upgrade on {}:{}@{}'.format(upgrade_config['test_user'],upgrade_config['test_password'],upgrade_config['test_host']))
    
    
def test_with_schema():
    '''
    runs the entire schema checker on the test server
    no params needed
    '''
    args= TheBabaClass()
    args.handle_all = True
    args.server_connection = "{}:{}@{}".format(upgrade_config['test_user'],upgrade_config['test_password'],upgrade_config['test_host'])
    L.debug(args)
    
    
def upgrade(limit_of_files_processed):
    '''
    run the upgrade SQLs on the real server
    '''
    pass


def arcive_all_processed_files():
    '''
    runs on all files in the CURRENT folder and moves any previously processed files (status=completed in db)
    to the ARCHIVE folder
    '''
    #Loop on upgrade tracking DB until all files are accounted for and moved
    cnx = app.db.get_connection()
    cursor = cnx.cursor()
    sql = "SELECT file_name FROM {}.sql_upgrades WHERE execution_status = 'completed' ORDER BY time_runned DESC, file_name DESC".format(upgrade_config['upgrade_tracking_database'])
    cursor.execute(sql)
    for file_name in cursor:
        print(file_name) #TODO in=mplement archive