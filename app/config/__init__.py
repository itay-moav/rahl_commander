import sys
import os
import configparser

sys.path.insert(0, os.path.dirname(os.path.realpath(__file__)) + '/../..')
import environment
from app.language import language as language
from app import logging as L
import app.config.cnMysql as cnMysql

ignore_files_dirs_with = environment.ignore_files_dirs_with
assets_folder = ''
upgrade = {}
schema_cheker = {}

_dbConn = None
_dbTestConn = None

def db_connection():
    global _dbConn
    return _dbConn

def db_test_connection():
    global _dbTestConn
    return _dbTestConn

def build_mysql_conn(profile):
    return cnMysql.Connection({'username':profile['username'],'password':profile['password'],'host':profile['host']})

def build_mssql_conn(profile):
    print(profile['datastore'])

def build_upgrade(profile):
    if profile['UPGRADE.TRACKING_DATABASE']:
        return {'database':profile['UPGRADE.TRACKING_DATABASE'] ,'force_test':profile['UPGRADE.FORCE_TEST'] }
    return {}

def read_profile(profile_name):
    '''
    This function is called if the user supplied a profile name to load configuration values from
    A profile must include at the minimum
    DATASTORE = [mysql,mssql]
    ASSETS_FOLDER = /absolute/path/to/assets/folder
    '''
    global _dbConn,_dbTestConn,assets_folder,upgrade
    config = configparser.ConfigParser()
    config.read(os.path.dirname(os.path.realpath(__file__)) + '/../../environment/profiles.ini')
    L.info("Running profile [{}]".format(profile_name))
    
    #START
    assets_folder = config[profile_name]['ASSETS_FOLDER']
    L.info("Asset folder: [{}]".format(assets_folder))

    if config[profile_name]['UPGRADE.TRACKING_DATABASE']:
        upgrade['database'] = config[profile_name]['UPGRADE.TRACKING_DATABASE']
        upgrade['force_test'] = config[profile_name]['UPGRADE.FORCE_TEST'] == 1
        upgrade['force_schema_test'] = config[profile_name]['UPGRADE.FORCE_SCHEMA_TEST'] == 1

    #DATASTORE
    try:
        if config[profile_name]['DATASTORE'] == 'mysql':
            _dbConn = build_mysql_conn(config[profile_name])
            if config[profile_name]['SCHEMA.TEST_HOST']:
                _dbTestConn = build_mysql_conn(\
                    {'host':config[profile_name]['SCHEMA.TEST_HOST'], \
                    'username':config[profile_name]['SCHEMA.TEST_USERNAME'], \
                    'password':config[profile_name]['SCHEMA.TEST_PASSWORD']})
                pass

        elif config[profile_name]['DATASTORE'] == 'mssql':
            _dbConn = build_mssql_conn(config[profile_name])

        else:
            L.critical('You are missing a valid value for [datastore] key in profiles.ini for profile [{}]'.format(profile_name))
            L.critical('Accepted values: [mssql|mysql]')
            L.critical('Good bye!')
            exit()

    except KeyError as e:
        L.critical('You are missing [{}] key-value in profiles.ini for profile [{}]'.format(e,profile_name))
        L.critical('Good bye!')
        exit()
