'''
Created on May 19, 2016

@author: Itay Moav
'''
import app.db
from app import logging as L
class TableList():
    '''
    Object to hold the list of tables a single config file [.schk | .rchk]
    affects, and the rules attached to each table.
    The object will hold all the tables of a given DB. 
    If no rule attached to a table, it will still hold it, just no rules attached.
    Object give utilities to add/edit/remove list of rules attached to table
                             read the rules for a table.
    '''


    def __init__(self,db):
        '''
        Constructor
        '''
        self.current_db       = db
        self.tables_list      = {}
        self.right_side_db = ''
        L.info("Initiating TableList for db [{}]".format(db))
        
    def loadTables(self):
        '''
        Load ALL the table names current db has.
        I know I can cache this action, but, I rather have clear code
        than optimized code at this stage.
        '''
        sql = "SELECT table_name FROM information_schema.tables WHERE table_schema='{}'".format(self.current_db)
        cursor = app.db.get_connection().cursor()
        cursor.execute(sql)
        self.tables_list = {res:[] for res, in cursor}
        
        L.debug(str(self.tables_list))
        return self
        
    def bindRulesToTables(self,rules):
        '''
        rule is a DictionaryType
        with 'table' which can be ALL or a table name
        and rules, which is the actual rules to attach
        to the specific table or to all tables in self.list_of_tables
        '''
        for rule in rules:
            if rule[0] == 'ALL': # Attach rule (it is an array of objects) to all tables
                for table in self.tables_list.keys():
                    self.tables_list[table] += [binded_rules.bind_all_to_sql(left_side_table=table) for binded_rules in rule[1]]
            else:                # attach the rule to only one table
                try:
                    self.tables_list[rule[0]] += [binded_rules.bind_all_to_sql(left_side_table=rule[0]) for binded_rules in rule[1]]
                except KeyError as ke:
                    L.fatal("Database [{db_name}] has no such table [{tbl_name}]".format(db_name=self.current_db,tbl_name=ke))
                    L.fatal("Please fix your rule files under database folder [{db_name}]".format(db_name=self.current_db))
                    raise Exception("Missmatch between files and db tables")
                   
    def getTables(self):
        return self.tables_list
    
    def getTablesNames(self):
        return self.tables_list.keys()
        
        
        
