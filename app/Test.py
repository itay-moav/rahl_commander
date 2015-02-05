'''
Created on Oct 23, 2014

@author: Itay Moav
'''
import app.iterator
import os
import config

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
        for sub_folder in self.folders:
            # Loop on files and run sql
            for root, dirnames, filenames in os.walk(sub_folder):
                # This is where I apply the filter of the ignored file list.
                if any(ignored_partial_string in root for ignored_partial_string in config.ignore_files_dirs_with):
                    continue

                db = self.extractDb(root)
                print("Checking root [{}] and DB  [{}]\n".format(root,db))
                self.changeDB(db,'')
