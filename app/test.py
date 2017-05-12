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
        print("******************************************************************************************************")
        print("                                               START ")
        print("******************************************************************************************************")
        # NOTICE! assets folder is not tested for as there is an intrinsic test for it in the core system, it will throw an EnvironmentException

        # USING THE CONFIG
        print("Using values from config folder!")
        
        # First check the auto completion folder exists
        if not os.path.isdir(config.assets_folder + '/autocompletion'):
            print("WARNING: OH MY GOD!  XX You are missing autocompletion folder [{}]. Please create it and run tests again".format(config.assets_folder + '/autocompletion'))
        else: 
            print(" GOOD! autocompletion folder found [{}]".format(config.assets_folder + '/autocompletion'))

        if not os.path.isdir(config.assets_folder + '/autocompletion/php'):
            print("WARNING: OH MY GOD!  XX You are missing autocompletion folder for PHP [{}] folder FOR PHP. Create it if you plan to use it".format(config.assets_folder + '/autocompletion/php'))
        else:
            print(" GOOD! autocompletion folder found for PHP [{}].".format(config.assets_folder + '/autocompletion/php'))

        if not os.path.isdir(config.assets_folder + '/scripts'):
            print("WARNING: OH MY GOD!  XX You are missing scripts folder [{}]. Please create it if u need it, and run tests again".format(config.assets_folder + '/scripts'))
        else: 
            print(" GOOD! scripts folder found [{}]".format(config.assets_folder + '/scripts'))
            self.folders.append(self.assets_path + '/scripts')
        
        if not os.path.isdir(config.assets_folder + '/schema'):
            print("WARNING: OH MY GOD!  XX You are missing Schema Checker folder [{}]. Please create it if u need it, and run tests again".format(config.assets_folder + '/schema'))
        else: 
            print(" GOOD! Schema Checker folder found [{}]".format(config.assets_folder + '/schema'))
            self.folders.append(self.assets_path + '/schema')

        # Check the db objects folder exist
        for sub_folder in self.folders:
            #check subfolder exists or fail
            if not os.path.isdir(sub_folder):
                print("ERROR: You are missing [{}] folder. Please create it and run tests again".format(sub_folder))
            else:
                print(" GOOD! folder [{}] was found".format(sub_folder))

        # CHECK DBs existance
        print("\n\nNOW! I will test all dbs, you try to work with, exists\n\n")
        databases_tracked = set()
        for sub_folder in self.folders:
        
            # Loop on files and run sql
            for root, dirnames, filenames in os.walk(sub_folder):
                # This is where I apply the filter of the ignored file list.
                if any(ignored_partial_string in root for ignored_partial_string in config.ignore_files_dirs_with):
                    continue

                db_name = self.extractDb(root)
                if db_name=='': continue
                databases_tracked.add(self.extractDb(root))
                print("------------------ DB [{}] in root [{}]".format(db_name,root))
                try:
                    self.changeDB(db_name,'')
                    
                except app.db.My.errors.ProgrammingError:
                    print("FATAL: HOLY CRAP! I am missing DB [{}] in root [{}]".format(db_name,root))
                
                
        for db_name in databases_tracked:
            print(" Tracking db {}".format(db_name))
