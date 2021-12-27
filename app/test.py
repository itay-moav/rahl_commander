'''
Created on Oct 23, 2014

@author: Itay Moav
'''
import app.iterator
import os
import app.config as config
import app.meta as meta
from app.config import upgrade as config_upgrade

class Install(app.iterator.AssetFilesDBConn):

    def iterate(self):
        '''
        Main iteration processor bala bala
        '''
        print("\n\n\n\n******************************************************************************************************")
        print("                                               START ")
        print("******************************************************************************************************")
        # NOTICE! assets folder is not tested for as there is an intrinsic test for it in the core system, it will throw an EnvironmentException

        self.folders.append(self.assets_path + '/schema')
        
        other_folder_to_check =[ \
                    self.assets_path + '/upgrades',              \
                    self.assets_path + '/upgrades/current',      \
                    self.assets_path + '/upgrades/archive',      \
                    self.assets_path + '/autocompletion',        \
                    self.assets_path + '/autocompletion/php'     \
        ]
        


        # Check the db objects folder exist
        for sub_folder in self.folders:
            #check subfolder exists or fail
            if not os.path.isdir(sub_folder):
                print("ERROR: You are missing [{}] folder. Please create it and run tests again".format(sub_folder))
            else:
                print(" GOOD! folder [{}] was found".format(sub_folder))

        # Check the db objects folder exist - I do a second checj on a seprate array, as the group above also have dbs it needs to check which i
        # a subfolder in those folders
        for sub_folder in other_folder_to_check:
            #check subfolder exists or fail
            if not os.path.isdir(sub_folder):
                print("ERROR: You are missing [{}] folder. Please create it and run tests again".format(sub_folder))
            else:
                print(" GOOD! folder [{}] was found".format(sub_folder))

        
        # CHECK DBs existance
        print("\n\n******************************************************************************************************")
        print("NOW! I will test all dbs, you try to work with, exists")
        print("******************************************************************************************************\n\n")
        
        # I am not using the meta here to hard code the assets I check
        # This is to catch errors in the folder structure.
        # Meta assumes all is correct
        databases_tracked = dict()
        for sub_folder in self.folders:
        
            # Loop on files and run sql
            for root, dirnames, filenames in os.walk(sub_folder):
                # This is where I apply the filter of the ignored file list.
                if any(ignored_partial_string in root for ignored_partial_string in config.ignore_files_dirs_with):
                    continue
                
                db_name = meta.extract_db_name(root)
                if db_name=='': continue
                
                try:
                    self.changeDB(db_name,'')
                    # Getting asset type for each DB we track, to show what we track for
                    if db_name not in databases_tracked:
                        databases_tracked[db_name] = set()
                    databases_tracked[db_name].add(meta.extract_from_folder(root,1)) # 1 means the asset type folder sp, views,schema etc
                    
                except app.db.My.errors.ProgrammingError:
                    print("FATAL: HOLY CRAP! I am missing DB [{}] in folder [{}]".format(db_name,root))
                
                
        for db_name in databases_tracked:
            print(" Tracking db {} for the following asset types {}".format(db_name,databases_tracked[db_name]))

        print("\n\n******************************************************************************************************")
        print("Checking SQL UPGRADES config values")
        print("******************************************************************************************************")
        # check ignore list includes *.md files
        if '.md' not in config.ignore_files_dirs_with:
            print("ERROR: You must add '.md' to your file ignore list config/ignore_list.py")
        else:
            print(" GOOD! ['.md'] found in file ignore list under config/ignore_list.py")
            
        # check theupgrades config and tracking table is properly defined
        try:
            self.changeDB(config_upgrade.upgrade['upgrade_tracking_database'],'')
            
        except app.db.My.errors.ProgrammingError:
            print("FATAL: HOLY CRAP! I am missing DB [{}] which your SQL UPGRRADES is configued to use.".format(config_upgrade.upgrade['upgrade_tracking_database']))
            
        else:
            #db exists, check table rcom_sql_upgrades exists
            sql = "SELECT COUNT(*) FROM {}.rcom_sql_upgrades".format(config_upgrade.upgrade['upgrade_tracking_database'])
            try:
                self.cursor.execute(sql)
            except app.db.My.errors.ProgrammingError:
                print("FATAL: Problems with table rcom_sql_upgrades, I am unable to run [{}]".format(sql))
            else:
                print(" GOOD: table rcom_sql_upgrades was found")
                  