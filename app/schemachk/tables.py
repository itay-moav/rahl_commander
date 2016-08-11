'''
Created on May 19, 2016

@author: Itay Moav
'''
import app.db
class TableList():
    '''
    Object to hold the list of tables a single config file [.schk | .rchk]
    affects, and the rules attached to each table.
    The object will hold all the tables of a given DB. 
    If no rule attached to a table, it will still hold it, just no rules attached.
    Object give utilities to add/edit/remove list of rules attached to table
                             read the rules for a table.
    '''


    def __init__(self,db,log_verbosity):
        '''
        Constructor
        '''
        self.verbosity        = log_verbosity
        self.current_db       = db
        self.tables_list      = {}
        self.right_side_db = ''
        if(self.verbosity):
            print("Initiating TableList for db [{}]".format(db))
        
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
        
        if(self.verbosity):
            print(self.tables_list)
        return self
        
    def bindRulesToTables(self,rules):
        '''
        rule is a DictionaryType
        with 'table' which can be ALL or a table name
        and rules, which is the actuall rules to attach
        to the specifc table or to all tables in self.list_of_tables
        '''
        for rule in rules:
            if rule[0] == 'ALL': # Attach rule (it is an array of objects) to all tables
                for table in self.tables_list.keys():
                    self.tables_list[table] += rule[1]
            else:                # attach the rule to only one table
                self.tables_list[rule[0]] += rule[1]
            
            
    def getTables(self):
        return self.tables_list
    
    
        