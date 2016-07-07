'''
Created on May 19, 2016

@author: Itay Moav
'''
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
        self.check_against_db = ''
        if(self.verbosity):
            print("Initiating TableList for db [{}]".format(db))
        
    def loadTables(self,cursor):
        '''
        Load ALL the table names current db has.
        I know I can cache this action, but, I rather have clear code
        than optimized code at this stage.
        '''
        sql = "SELECT table_name FROM information_schema.tables WHERE table_schema='{}'".format(self.current_db)
        cursor.execute(sql)
        self.tables_list = {res:[] for res, in self.cursor}
        if(self.verbosity):
            print(self.tables_list)
        return self
    
    def setCheckAgainstDB(self,file_name):
        '''
        Check which DB name the rule file currently parsed is
        pointing to. rchk is to compare current db with a different db (file name is the db name)
        .schk is a rule file for current db only (for example, all tables must have a field called 'id')
        '''
        if('.rchk' in file_name):
            self.check_against_db = filename.replace('.rchk','')
        else:
            self.check_against_db = self.current_db    
        return self
        
    def attachRules(self,rule):
        '''
        rule is a DictionaryType
        with 'table' which can be ALL or a table name
        and rules, which is the actuall rules to attach
        to the specifc table or to all tables in self.list_of_tables
        '''
        pass
    
        