'''
Created on Oct 23, 2014

@author: Itay Moav
'''
# import sys
# import os
# import fnmatch
# import shutil

import config
import app.iterator
from scipy.io.harwell_boeing._fortran_format_parser import Tokenizer



class Looper(app.iterator.AssetFilesDBConn):
    '''
        Iterator class to find schema rules and check them on the live DB
    '''

    def __init__(self, parser,db=None):
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
        self.file_postfix = ".rchk" # rahl check file
        '''
        Object that maintaines the list of tables to be checked
        as read by the current file.
        '''
        self.tableRules = AllTableRules(self.cnx)


    def process(self,db,file_content,filename):
        '''
            Loops on each rule file (*.rchk), parse each rule and run the checks.
            Each file found, a new looper is instantiated for that file to be
            processed.
        '''
        right_side_db = filename.replace('.rchk','')
        
        if(self.verbosity):
            print("\n\nOpening db [{}] file [{}]. \n\nSTART FILE CONTENT\n{}\n\nEOF\n\n".format(db,filename,file_content))
           
        
        
        rules = file_content.split("\n")
        for rule in rules:
            rule = rule.strip()
            if len(rule) == 0 or rule[0] == '#':
                continue
            if(self.verbosity):
                print("Reading Rule [{}]".format(rule))
            
            # Take the rule, Parse it to get the right table to attach to this rule
            self.tableRules.attach(RuleParser.factory_rule_container(rule,left_side_db=db,right_side_db=right_side_db))
            
     
             
                     
            
            
            
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
        Tokenized = Tokenizer.break(self.rule_as_string)
        
        
        
    def getRulebject(self):
        return self.RuleObject