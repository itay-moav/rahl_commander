'''
Created on Dec 28, 2021

@author: Itay

Abstracting the DB connection piece
'''
import mysql.connector as My
from app import logging as L
from app import exceptions as exceptions

class Connection():
    '''
    Abstracting the actions on a DB
    '''
    def __init__(self, connection_config):
        L.info("Trying to connect to {}:{}@{}".format(connection_config['username'],connection_config['password'],connection_config['host']))
        self.connection = My.connect(user=connection_config['username'], password=connection_config['password'],host=connection_config['host'],buffered=True)

    def get_connection(self):
        return self.connection

    def change_db(self,new_db):
        connection = self.get_connection()
        if connection.database != new_db and new_db:
            try:
                connection.database = new_db
                
            except My.Error as err:
                if err.errno == My.errorcode.ER_BAD_DB_ERROR:
                    return False
            
                else:
                    msg = "Error occured while changing DB in mysql connection [{}]".format(err)
                    L.fatal(msg)
                    raise exceptions.SQLError(msg)
        return True

    def cursor(self):
        return self.get_connection().cursor()

    def commit(self):
        return self.get_connection().commit()
