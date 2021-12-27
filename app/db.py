'''
Created on Jul 28, 2016

@author: Itay

Abstracting the DB connection piece
'''
import mysql.connector as My
import properties
from app import logging as L
from properties.upgrade import upgrade as upgrade_config

_connection = None

def get_connection():
    global _connection
    if not _connection:
        user     = properties.mysql['username']
        password = properties.mysql['password']
        host     = properties.mysql['host']
        L.info("Trying to connect to {}:{}@{}".format(properties.mysql['username'],properties.mysql['password'],properties.mysql['host']))
        _connection = My.connect(user=user, password=password,host=host,buffered=True)
        
    return _connection


def change_db(new_db):
    cnx_r = get_connection()
    if cnx_r.database != new_db and new_db:
        try:
            cnx_r.database = new_db
            
        except My.Error as err:
            if err.errno == My.errorcode.ER_BAD_DB_ERROR:
                return False
        
            else:
                raise err
    return True



def get_test_Server_connection():
    cnx_t = My.connect(user=upgrade_config['test_user'], password=upgrade_config['test_password'],host=upgrade_config['test_host'],buffered=True)
    cnx_t.database = upgrade_config['upgrade_tracking_database']
    return cnx_t
