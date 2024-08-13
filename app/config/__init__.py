import sys
import os
import configparser

sys.path.insert(0, os.path.dirname(os.path.realpath(__file__)) + '/../..')
import environment
from app.language import language as language
from app import logging as L

ignore_files_dirs_with = environment.ignore_files_dirs_with
assets_folder = ''
upgrade = {}
schema_cheker = {}
autocomplete = environment.autocomplete

_log_level   = L.DEBUG
_raw_profile = None
_dbConn = None
_dbTestConn = None

def log_level():
    global _log_level
    return _log_level

def profile():
    global _raw_profile
    return _raw_profile

def data_store():
    '''
    this is the db type we connect tp
    '''
    return profile()['DATASTORE']

def db_connection():
    global _dbConn
    return _dbConn

def db_test_connection():
    global _dbTestConn
    return _dbTestConn

def build_upgrade(profile):
    if profile['UPGRADE.TRACKING_DATABASE']:
        return {'database':profile['UPGRADE.TRACKING_DATABASE'] ,'force_test':profile['UPGRADE.FORCE_TEST'] }
    return {}


def build_mysql_conn(profile):
    import app.config.cnMysql as cnMysql
    return cnMysql.Connection({'username':profile['username'],'password':profile['password'],'host':profile['host']})

def build_mssql_conn(profile):
    import app.config.cnMssql as cnMssql
    return cnMssql.Connection({'username':profile['username'],'password':profile['password'],'host':profile['host'],'database':profile['database']})

def read_profile(profile_name):
    '''
    This function is called if the user supplied a profile name to load configuration values from
    A profile must include at the minimum
    DATASTORE = [mysql,mssql]
    ASSETS_FOLDER = /absolute/path/to/assets/folder
    '''
    global _raw_profile,_dbConn,_dbTestConn,assets_folder,upgrade
    config = configparser.ConfigParser()
    config.read(os.path.dirname(os.path.realpath(__file__)) + '/../../environment/profiles.ini')
    L.info("Running profile [{}]".format(profile_name))
    
    #START
    try:
        _raw_profile = config[profile_name]
    except KeyError:
        L.fatal("Profile [{}] does not exists. Bye!".format(profile_name))
        exit()
        
    if log_level() == L.DEBUG:
        L.debug("******************************************************************************************************")
        L.debug("Profile values")
        L.debug("******************************************************************************************************\n\n")
        for key in _raw_profile:
            print("{} = {}".format(key,_raw_profile[key]))
        L.debug("\n******************************************************************************************************\n\n")
    
    assets_folder = profile()['ASSETS_FOLDER']
    L.info("Asset folder: [{}]".format(assets_folder))

    if 'UPGRADE.TRACKING_DATABASE' in profile() or 'UPGRADE.TRACKING_SCHEMA' in profile():
        if data_store() == 'mysql':
            upgrade['database'] = profile()['UPGRADE.TRACKING_DATABASE']
        elif data_store() == 'mssql':
            upgrade['database'] = profile()['UPGRADE.TRACKING_SCHEMA']
        upgrade['force_test'] = profile()['UPGRADE.FORCE_TEST'] == 1
        upgrade['force_schema_test'] = profile()['UPGRADE.FORCE_SCHEMA_TEST'] == 1
        if log_level() == L.DEBUG:
            L.debug("******************************************************************************************************")
            L.debug("UPGRADE DATA BASE")
            L.debug("******************************************************************************************************\n\n")
            for key in upgrade:
                print("{} = {}".format(key,upgrade[key]))
            L.debug("\n******************************************************************************************************\n\n")
    


    #DATASTORE
    try:
        if data_store() == 'mysql':
            _dbConn = build_mysql_conn(profile())
            if 'SCHEMA.TEST_HOST' in profile():
                _dbTestConn = build_mysql_conn(\
                    {'host':profile()['SCHEMA.TEST_HOST'], \
                    'username':profile()['SCHEMA.TEST_USERNAME'], \
                    'password':profile()['SCHEMA.TEST_PASSWORD']})

        elif data_store() == 'mssql':
            _dbConn = build_mssql_conn(profile())
            if 'SCHEMA.TEST_HOST' in profile():
                _dbTestConn = build_mysql_conn(\
                    {'host':profile()['SCHEMA.TEST_HOST'], \
                    'username':profile()['SCHEMA.TEST_USERNAME'], \
                    'password':profile()['SCHEMA.TEST_PASSWORD'], \
                    'database':profile()['SCHEMA.TEST_DATABASE']})

        else:
            L.critical('You are missing a valid value for [datastore] key in profiles.ini for profile [{}]'.format(profile_name))
            L.critical('Accepted values: [mssql|mysql]')
            L.critical('Good bye!')
            exit()

    except KeyError as e:
        L.critical('You are missing [{}] key-value in profiles.ini for profile [{}]'.format(e,profile_name))
        L.critical('Good bye!')
        exit()

def set_logging(verbosity):
    global _log_level
    #setup the logger
    log_verbosity_tmp = verbosity
    log_verbosity     = L.FATAL
    if(log_verbosity_tmp is None):
        log_verbosity = L.ERROR
    elif(log_verbosity_tmp == 'v'):
        log_verbosity = L.WARNING
    elif(log_verbosity_tmp == 'vv'):
        log_verbosity = L.INFO
    elif(log_verbosity_tmp == 'vvv'):
        log_verbosity = L.DEBUG
    else:
        log_verbosity = L.DEBUG
    _log_level = log_verbosity
    L.basicConfig(level=log_verbosity)
    