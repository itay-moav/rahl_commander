'''
Created on Jul 28, 2016

@author: Itay

Abstracting the DB connection piece
'''
import mysql.connector as My
import config
from app import logging as L

_connection = None

def get_connection(): #TOBEDELETED100server_connection_override=None):
    global _connection
    if not _connection:
        # Check whther take config values or override from command line
        #if server_connection_override:
        #    creds = server_connection_override.replace(':','@').split('@')
        #    user=creds[0]
        #    password=creds[1]
        #    host=creds[2]
        #else:
            
        user     = config.mysql['username']
        password = config.mysql['password']
        host     = config.mysql['host']
        L.info("Trying to connect to {}:{}@{}".format(config.mysql['username'],config.mysql['password'],config.mysql['host']))
        _connection = My.connect(user=user, password=password,host=host,buffered=True)
        
    return _connection


def change_db(new_db):
    cnx = get_connection()
    if cnx.database != new_db and new_db:
        try:
            cnx.database = new_db
            
        except My.Error as err:
            if err.errno == My.errorcode.ER_BAD_DB_ERROR:
                return False
        
            else:
                raise err
    return True