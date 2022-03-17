'''
Created on Jan 3rd, 2022

@author: Itay

Abstracting mssql DB connection piece
'''
import pymssql 
from app import logging as L
from app import exceptions as exceptions

class Connection():
    '''
    Abstracting the actions on a DB
    '''
    def __init__(self, connection_config):
        dns = 'SERVER='+connection_config['host']+';DATABASE='+connection_config['database']+';UID='+connection_config['username']+';PWD='+ connection_config['password']
        self._debug_connection_info = dns
        L.info("Trying to connect to {}".format(self._debug_connection_info))
        self._connection =pymssql.connect(server=connection_config['host'], user=connection_config['username'], password=connection_config['password'], database=connection_config['database'])  

    def get_connection(self):
        return self._connection

    def change_db(self,new_db):
        return True

    def cursor(self):
        return self.get_connection().cursor()

    def commit(self):
        return self.get_connection().commit()

    def debug_connection(self):
        return "dns: [{}]".format(self.debug_connection_info)

    def execute(self,sql):
        L.debug("Running sql [{}]".format(sql))
        cursor = self.cursor()
        cursor.execute(sql)
        return cursor

    def execute_fetchall(self,sql):
        cursor = self.execute(sql)
        return cursor.fetchall()

    def insert_rcom_sql_upgrades(self,schemaname,file_values):
        sql = "INSERT INTO {}.rcom_sql_upgrades VALUES {}".format(schemaname,file_values)
        self.execute(sql)
        # ??? not sure here yet self.commit()

    def mark_complete_rcom_sql_upgrades(self,schemaname,file_name):
        sql = "UPDATE {}.rcom_sql_upgrades SET execution_status='completed' WHERE file_name = '{}'".format(schemaname,file_name)
        self.execute(sql)
        self.commit()
