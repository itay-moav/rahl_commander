'''
Created on Oct 23, 2014

@author: Itay Moav
'''

import config
import app.iterator
from app.schemachk.tables import TableList
from app.schemachk.tokenizer import TokenMaster




class Looper(app.iterator.AssetFilesDBConn):
    '''
        Iterator class to find schema rules and check them on the live DB
    '''

    def __init__(self, parser,db=None,file_postfix=".rchk"):
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
        self.parser = parser # Store it in case we need to instantiate other iterators from within an iterator (like the drop it`)
        self.args = args # for later use
        
        self.validateSelf()
        self.connect(db)
        self.file_postfix = file_postfix
        '''
        list of Objects that maintaines the list of tables to be checked
        One object per file found
        '''
        self.store_table_lists = []
        self.per_db_all_tables = {}


    def process(self,db,file_content,filename):
        '''
            Loops on each rule file (*.rchk | .schk), parse each rule and run the checks.
            Each file found, a new table list is instantiated for that file to be
            processed.
        '''
        
        # If I did not load the list of tables for this DB, I load it now.
        if(not self.per_db_all_tables.has_key(db)):
            self.per_db_all_tables[db] = {}
            if(self.verbosity): print("Loading all table names from [{}]".format(db))
            sql = "SELECT table_name FROM information_schema.tables WHERE table_schema='{}'".format(db)
            self.cursor.execute(sql)
            for(table_name) in self.cursor:
                if(self.verbosity): print(table_name[0])
                self.per_db_all_tables[db][table_name[0]] = ''
      
        
        # start the overall parsing process
        right_side_db = ''
        if(self.file_postfix == '.rchk'):
            right_side_db = filename.replace('.rchk','')
        
        #if(self.verbosity):
            #print("\n\nOpening db [{}] file [{}]. \n\nSTART FILE CONTENT\n{}\n\nEOF\n\n".format(db,filename,file_content))
        
        # Table list object for current file -> sending the file name for debug purposes   
        MyTableList = TableList(filename,self.verbosity,self.per_db_all_tables[db])
        
        
        rules_str = file_content.split("\n")
        for rule in rules_str:
            rule = rule.strip()
            if len(rule) == 0 or rule[0] == '#':
                continue
            if(self.verbosity):
                print("Reading Rule [{}]".format(rule))
            
            # Parse the read line
            T = TokenMaster(rule,related_db=right_side_db,file_type=self.file_postfix,log_verbosity=self.verbosity)
            T.parse()
            MyTableList.attchRules(T.tables_and_rules())
         
        self.store_table_lists.append(MyTableList)
         
            
    def getTableLists(self):
        return self.store_table_lists
             
                     
            
            
            
class RuleParser():
    '''
    Parses a specific line in the rule file, and translates 
    to an Object + meta data (like which tables this rule applies to)
    + assigns an overwrite type, in case a later rule of the same type comes
    and it then overwrites this one.
    '''
    
    @staticmethod
    def factory_rule_container(rule_as_string,left_side_db,right_side_db):
        '''
        static method to run this one rule parsing.
        '''
        Parser = RuleParser(rule_as_string,left_side_db,right_side_db)
        Parser.parseRule()
        return Parser.getRuleObject()
        
        
    '''
    Takes one rule and builds from that (with many many little sweet helper classes)
    a Reporting object (see far below the ReportingObject)
    '''
    
    def __init__(self,rule_as_string,left_side_db,right_side_db):
        self.ReportingObject = None
        self.rule_as_string = rule_as_string
        self.left_side_db = left_side_db
        self.right_side_db = right_side_db
        

    def parseRule(self):
        '''
        Main entry point for this class functionality
        - tokenize rule (Tokenaizer)
        - Decide which tables are affected from this rule and load them to memeory as TableRule object
        - Attach the right side rule to each TableRule object.
        TODO this (prints) really has to move into a logger, Will try finding an existing one before doing my own ...
        '''
        print("rule [{}]\nleft db [{}] right db [{}]\n".format(self.rule_as_string,
                                                                                                 self.left_side_db,
                                                                                                 self.right_side_db,
                                                                                                 ))
        
        # Break the rule into related tokens, for example all:exists same exclude_field[f1] the [exclude_field]
        # is a subpart of the [same] rule, they have to be read together.
        #Tokenized = Tokenizer.break(self.rule_as_string)
        
        
        
    def getRulebject(self):
        return self.RuleObject