'''
Created on Oct 23, 2014

@author: Itay Moav
'''

import app.config as config
import app.iterator
from app.schemachk.tables      import TableList
from app.schemachk.file_parser import ChkFileParser
from app                       import logging as L




class ParseLooper(app.iterator.AssetFilesDBConn):
    '''
        Iterator class to find schema rules and check them on the live DB
        Each iteration is one file opened and parsed into a file specific TableList object
        the process() function is where the main logic happens.
        The result of the rules parsed will be stored in a TableList object.
        At the end, TableList object will be returned.
        Who ever wants to, can run the rules stored in the TableList object/s
    '''

    def __init__(self, args,file_postfix=".rchk"):
        '''
        Stores a dictionary of what to build
        @var cnx_proxy boolean : whether we use an injected DB connection or create our own. True == injected
        '''
        # Process arguments
        handle_all = args.handle_all
        if handle_all:
            self.what_to_handle = {'d':'All'}

        else:
            self.what_to_handle = {'d':args.database}


        self.assets_path = config.assets_folder
        self.folders = []
        self.args = args # for later use
        self.validateSelf()
        self.connect()
        self.file_postfix = file_postfix
        '''
        list of Objects that maintaines the list of tables to be checked
        One object per file found
        '''
        self.store_table_lists = []
        #self.per_db_all_tables = {}


    def process(self,db,file_content,filename):
        '''
            Loops on each folder, Each PROCESS call handles one rule file (*.rchk | .schk),
            Calls the following actions: 
            - Parses each rule and run the checks.
            - Each file found, a new table list object is instantiated for that file to be
              processed.
            - Run the tests in the TableList object
            @param db is the current database name, the left side db name: string 
        '''
        L.info("\n\nOpening db [{}] file [{}].\n".format(db,filename))
        
        # INITIALIZE THE LIST OF TABLES OBJECT, load tbls, set the DB name with which current DB is checked.
        DBTableList = (TableList(db)).loadTables()
        RuleParser  = (ChkFileParser(all_tables_names=DBTableList.getTablesNames(),
                                     left_side_db=db,
                                     right_side_db=self.getRightSideDB(filename,db),
                                     file_content=file_content)).parseRules()
        DBTableList.bindRulesToTables(RuleParser.getRuleList())
        self.store_table_lists.append(DBTableList)
         
            
    def getTableLists(self):
        '''
        @return: [TableList]
        '''
        return self.store_table_lists
    
    def getRightSideDB(self,file_name,current_db):
        '''
        Check which DB name (right side) the rule file currently parsed is
        pointing to. rchk is to compare current db with a different db (file name is the db name)
        .schk is a rule file for current db only (for example, all tables must have a field called 'id')
        '''
        if('.rchk' in file_name):
            return file_name.replace('.rchk','')
        else:
            return current_db    
        
