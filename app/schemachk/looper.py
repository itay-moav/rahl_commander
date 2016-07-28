'''
Created on Oct 23, 2014

@author: Itay Moav
'''

import config
import app.iterator
from app.schemachk.tables      import TableList
from app.schemachk.file_parser import ChkFileParser




class ParseLooper(app.iterator.AssetFilesDBConn):
    '''
        Iterator class to find schema rules and check them on the live DB
        Each iteration is one file opened and parsed into a file specific TableList object
        the process() function is where the main logic happens.
        The result of the rules parsed will be stored in a TableList object.
        At the end, TableList object will be returned.
        Who ever wants to, can run the rules stored in the TableList object/s
    '''

    def __init__(self, parser,file_postfix=".rchk"):
        '''
        Stores a dictionary of what to build
        @var cnx_proxy boolean : whether we use an injected DB connection or create our own. True == injected
        '''
        # Process arguments
        args = parser.parse_args()
        handle_all = args.handle_all
        if handle_all:
            self.what_to_handle = {'d':'All'}

        else:
            self.what_to_handle = {'d':args.database}


        self.assets_path = config.assets_folder
        if args.assets_path:
            self.assets_path = args.assets_path

        self.folders = []
        self.verbosity = args.verbosity
        #self.parser = parser # Store it in case we need to instantiate other iterators from within an iterator (like the drop it`)
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
        '''
        if(self.verbosity):
            print("\n\nOpening db [{}] file [{}].\n".format(db,filename))
            
        
        # INITIALIZE THE LIST OF TABLES OBJECT, load tbls, set the DB name with which current DB is checked.
        DBTableList = (TableList(db,self.verbosity)).loadTables().setCheckAgainstDB(filename)
        RuleParser  = (ChkFileParser(DBTableList.check_against_db ,file_content, self.verbosity)).parseRules()
        DBTableList.attachRuleList(RuleParser.getRuleList())
        self.store_table_lists.append(DBTableList)
         
            
    def getTableLists(self):
        '''
        @return: [TableList]
        '''
        return self.store_table_lists
        
