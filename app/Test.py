'''
Created on Oct 23, 2014

@author: Itay Moav
'''
import app.iterator
import os
import config
from app import logging as L


class Install(app.iterator.AssetFilesDBConn):


    def iterate(self):
        '''
        Main iteration processor bala bala
        '''

        # First check the auto completion folder exists
        if not os.path.isdir(config.assets_folder + '/autocompletion'):
            print("WARNING: OH MY GOD!  XX You are missing autocompletion folder [{}]. Please create it and run tests again".format(config.assets_folder + '/autocompletion'))
        else: 
            print("GOOD! autocompletion folder found [{}]".format(config.assets_folder + '/autocompletion'))

        if not os.path.isdir(config.assets_folder + '/autocompletion/php'):
            print("WARNING: OH MY GOD!  XX You are missing autocompletion folder for PHP [{}] folder FOR PHP. Create it if you plan to use it".format(config.assets_folder + '/autocompletion/php'))
        else:
            print("GOOD!  autocompletion folder found for PHP [{}].".format(config.assets_folder + '/autocompletion/php'))

        # Check the db objects folder exist
        sub_filders_to_check = []
        for sub_folder in self.folders:
            #check subfolder exists or fail
            if not os.path.isdir(sub_folder):
                print("ERROR: You are missing [{}] folder. Please create it and run tests again".format(sub_folder))
            else:
                print("GOOD! folder [{}] was found".format(sub_folder))
                sub_filders_to_check.append(sub_folder)

        # CHECK DBs existance
        print("\n\nNOW! Now I will test all dbs you try to work with exists\n\n")
        for sub_folder in sub_filders_to_check:
        
            # Loop on files and run sql
            for root, dirnames, filenames in os.walk(sub_folder):
                # This is where I apply the filter of the ignored file list.
                if any(ignored_partial_string in root for ignored_partial_string in config.ignore_files_dirs_with):
                    continue

                db = self.extractDb(root)
                try:
                    self.changeDB(db,'')

                except app.db.My.errors.ProgrammingError:
                    print("FATAL: HOLY CRAP! I am missing DB [{}] in root [{}]\n".format(db,root))

