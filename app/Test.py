'''
Created on Oct 23, 2014

@author: Itay Moav
'''
import app.iterator
import os
import config
from app import logging as L

class Install(app.iterator.AssetFilesDBConn):
    '''
    Iterate on all folders and checks DBs defined do exists
    in the given database
    '''

    def __init__(self, parser,db=None):
        '''
        init for testing
        '''
        self.folders = []
        self.what_to_handle = {'s':'All','w':'All', 't':'All', 'f':'All', 'c':'All'}
        self.connect(db)

    def iterate(self):
        '''
        Main iteration processor bala bala
        '''

        # First check the auto completion folder exists
        if not os.path.isdir(config.assets_folder + '/autocompletion'):
            L.fatal("You are missing [{}] folder. Please create it and run tests again".format(config.assets_folder + '/autocompletion'))
            exit()

        if not os.path.isdir(config.assets_folder + '/autocompletion/php'):
            L.fatal("You are missing [{}] folder. Please create it and run tests again".format(config.assets_folder + '/autocompletion/php'))
            exit()


        # Check the db objects folder exist
        for sub_folder in self.folders:
            #check subfolder exists or fail
            if not os.path.isdir(sub_folder):
                L.fatal("You are missing [{}] folder. Please create it and run tests again".format(sub_folder))
                exit()


            # Loop on files and run sql
            for root, dirnames, filenames in os.walk(sub_folder):
                # This is where I apply the filter of the ignored file list.
                if any(ignored_partial_string in root for ignored_partial_string in config.ignore_files_dirs_with):
                    continue

                db = self.extractDb(root)
                L.info("Checking root [{}] and DB  [{}]\n".format(root,db))
                try:
                    self.changeDB(db,'')

                except app.db.My.errors.ProgrammingError:
                    L.fatal("Missing DB [{}] in root [{}]\n".format(db,root))

