'''
Created on Oct 23, 2014

@author: Itay Moav
'''
import sys
import os
# import fnmatch
# import shutil
import config
import app.iterator



class Checker(app.iterator.AssetFilesDBConn):
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
        The reporting object are the containers for the SQL we get from a parsed
        rule + a list of checks and/or list of exception on the result of that SQL
        '''
        self.reportingObjects = []


    def process(self,db,file_content,current_subdir):
        '''
            Loops on each rule file (*.rchk), parse each rule and run the checks.
            Each file found, a new looper is instantiated for that file to be
            processed.
        '''
        if(self.verbosity):
            print("Opening db [{}] file [{}]".format(db,file_content))
            
        rules = file_content.split("\n")
        for rule in rules:
            rule = rule.strip()
            if len(rule) == 0 or rule[0] == '#':
                continue
            if(self.verbosity):
                print("Reading Rule [{}]".format(rule))
            
            # Take the rule, PArse it to get the right reporting class
            MyRuleParser = RuleParser(rule,left_side_db=db,right_side_db=current_subdir,left_side_table="*",right_side_table="*")
            MyRuleParser.parseRule()
            self.reportingObjects.append(MyRuleParser.getReportingObject())
            
            
            
            
            
            
            
class RuleParser():
    '''
    Takes one rule and builds from that (with many many little sweet helper classes)
    a Reporting object (see far below the ReportingObject)
    '''
    
    def __init__(self,rule_as_string,left_side_db,right_side_db,left_side_table="*",right_side_table="*"):
        self.ReportingObject = None
        self.rule_as_string = rule_as_string
        self.left_side_db = left_side_db
        self.right_side_db = right_side_db
        self.left_side_table = left_side_table
        self.right_side_table = right_side_table

    def parseRule(self):
        '''
        Main entry point for this class functionality
        - Decide several general things about this rule
        '''
        print("rule [{}]\nleft db [{}] right db [{}]\nleft table [{}] right table [{}]".format(self.rule_as_string,
                                                                                                 self.left_side_db,
                                                                                                 self.right_side_db,
                                                                                                 self.left_side_table,
                                                                                                 self.right_side_table))
        
    def getReportingObject(self):
        return self.ReportingObject