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


    def process(self,db,file_content):
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
            
            print("[{}]".format(rule))

