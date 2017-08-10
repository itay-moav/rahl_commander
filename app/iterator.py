'''
Created on Oct 9, 2014

@author: Itay Moav

Basic iteration functionality on the right folders.
'''
import fnmatch
import os
import config
import app.db
from app import logging as L
import app.meta as meta

class AssetFiles():
    '''
    Get command line params Loop on all specified folders and get the files we need to run
    No DB usage is expected in inheriting classes
    '''

    PATH = '\\'
    arg_to_foldername = {'t':'triggers','f':'functions','c':'scripts','s':'sp','w':'views','d':'schema'}



    def __init__(self, args):
        '''
        Stores a dictionary of what to build
        '''
        # Process arguments
        if args.handle_all:
            self.what_to_handle = {'s':'All','w':'All', 't':'All', 'f':'All'}

        else:
            self.what_to_handle = {'s':args.stored_proc,'w':args.views, 't':args.triggers, 'f':args.functions}

        # the scripts (c) option exist only in some commands.
        # since c (scripts) is not a db object, and can be dangerous to run, I enforce this to always be called explicitly 
        try:
            args.scripts

        except AttributeError:
            pass

        else:
            self.what_to_handle['c'] = args.scripts

        self.assets_path = config.assets_folder
        
        #TOBEDELETED100 if args.assets_path:
        #    self.assets_path = args.assets_path
        #    config.assets_folder = args.assets_path

        self.folders = []
        self.args = args # for later use
        
        self.validateSelf()
        self.file_postfix = '.sql'
        
        
    def validateSelf(self):
        '''
        Verify we have the right values.
        Validates the existance of the assets path
        '''
        if not os.path.isdir(self.assets_path):
            # error message regardless of verbosity, this is a game stopper
            raise EnvironmentError("Assets folder [{}] was not found. Go find your assets folder (or fix your config)".format(self.assets_path))
        


    def run(self):
        '''
        main entry point. send to processing each type (trigger,sp,func,view,scripts)
        '''
        self.preCalcFolder()
        self.calcFolder()
        self.postCalcFolder()
        self.iterate()
        self.postIterate()



    def preCalcFolder(self):
        pass



    def calcFolder(self):
        '''
        @param db_obj_type : triggers | sp | functions | scripts | views
        @param db_obj_type_subfolder: the subfolder (or ALL) under the db object type folder.

        For each type, build the folder to iterate over.
        While we could have done everything in one pass,
        performance is not the issue here.

        1. First decide if build is needed
        2. Then on what (all/subfolder/one file only) is the dest
        3. Store the folder to iterate over
        '''
        for db_obj_type,db_obj_type_subfolder in self.what_to_handle.items():
            if(self.what_to_handle[db_obj_type]):
                # assets/triggers ... assets/sp ... etc
                db_object_folder = self.assets_path + '/' + self.arg_to_foldername[db_obj_type]
                if(db_obj_type_subfolder == "All"):
                    sub_folder = db_object_folder
                else:
                    sub_folder = db_object_folder + '/' + db_obj_type_subfolder

                self.folders.append(sub_folder)


    def postCalcFolder(self):
        pass


    def iterate(self):
        '''
        Main iteration processor bala bala
        '''
        print(self.folders)
        print('------------------')
        for sub_folder in self.folders:
            # If this is actually just a sql file, do it directly. Otherwise do loop next
            if self.file_postfix in sub_folder:
                db = meta.extract_db_name(sub_folder)
                # TOBEDELETED once verified not used self._current_file = sub_folder
                self._current_path = sub_folder # NOT SURE IT IS USED!
                L.info("handler is [{}] doing root [{}] file [{}] in database [{}]\n".format(self.__class__.__name__,sub_folder,sub_folder,db))
                f = open(sub_folder,'r')
                file_content = f.read()
                f.close()
                self.changeDB(db,file_content)
                self.process(db,file_content,sub_folder)

                continue

            else:
                # Loop on files and run sql
                for root, dirnames, filenames in os.walk(sub_folder):
                    # This is where I apply the filter of the ignored file list.
                    if any(ignored_partial_string in root for ignored_partial_string in config.ignore_files_dirs_with):
                        continue

                    for filename in fnmatch.filter(filenames, '*'+self.file_postfix):
                        # print(filenames)
                        # print(dirnames)
                        # print("----------------------------------")
                        # print(root)
                        db = meta.extract_db_name(root)
                        # print(db+"\n")
                        # print(config.ignore_files_dirs_with)
                        self._current_path = root
                        L.info("handler is [{}] doing root [{}] file [{}] in database [{}]\n".format(self.__class__.__name__,root,filename,db))
                        f = open(root + '/' + filename,'r')
                        file_content = f.read()
                        f.close()
                        self.changeDB(db,file_content)
                        self.process(db,file_content,filename)


    def changeDB(self,db,file_content):
        '''
            DO NOTHING HERE
        '''
        pass
    

    def process(self,db,file_content,current_subdir):
        '''
        Technicaly, this is an abstract method which needs overiding

        '''
        raise Exception('Implement this!')



    def postIterate(self):
        '''
            OVERWRITE THIS!
        '''
        pass






class AssetFilesDBConn(AssetFiles):

    def __init__(self, args):
        '''
        Stores a dictionary of what to build
        '''
        AssetFiles.__init__(self, args)
        self.connect()


    def connect(self):
        '''
            overwrite this, if no DB connection is needed
        '''
        # Allow for dependency injection of the connection
        # This will allow the use of test server in conjunction with the actual server
        if self.args.cnx: 
            self.cnx = self.args.cnx
        else: 
            self.cnx = app.db.get_connection()
            self.cursor = self.cnx.cursor()


    def changeDB(self,db,file_content):
        '''
            Changes the DB connected too
        '''
        # This means the DB is going to be created in the script
        if "CREATE DATABASE" in file_content:
            return
        
        if not app.db.change_db(db):
            L.debug("CODE:\n{}".format(file_content))
            raise app.db.My.errors.ProgrammingError("ERROR: Could not run command. db [{}] does not exists. use -v to get more info.".format(db))


    def postIterate(self):
        '''
        '''
        pass

