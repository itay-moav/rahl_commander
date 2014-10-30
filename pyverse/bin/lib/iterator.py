'''
Created on Oct 9, 2014

@author: Itay Moav

Basic iteration functionality on the right folders.
'''
import fnmatch
import os
import mysql.connector as My

class AssetFiles():
    '''
    Get command line params Loop on all specified folders and get the files we need to run
    '''

    PATH = '\\'
    arg_to_foldername = {'t':'triggers','f':'functions','c':'scripts','s':'sp','w':'views'}



    def __init__(self, parser,db=None):
        '''
        Stores a dictionary of what to build
        @var cnx_proxy boolean : whther we use an injected DB connection or create our own. True == injected
        '''
        # Process arguments
        args = parser.parse_args()
        handle_all = args.handle_all
        if handle_all:
            self.what_to_handle = {'s':'All','w':'All', 't':'All', 'f':'All', 'c':'All'}
        else:
            self.what_to_handle = {'s':args.stored_proc,'w':args.views, 't':args.triggers, 'f':args.functions, 'c':args.scripts}

        # Connect to DB (TODO get DB connection abstracted)
        if db:
            self.cnx = db
            self.cnx_proxy = True

        else:
            self.cnx = My.connect(user='root', password='',host='127.0.0.1')
            self.cnx_proxy = False

        self.cursor = self.cnx.cursor()
        self.folders = []
        self.parser = parser # Store it in case we need to instantiate other iterators from within an iterator (like the drop it`)



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
                db_object_folder = "../assets/" + self.arg_to_foldername[db_obj_type]
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
        for sub_folder in self.folders:
            # Loop on files and run sql
            for root, dirnames, filenames in os.walk(sub_folder):
                for filename in fnmatch.filter(filenames, '*.sql'):
                    db = self.extractDb(root)
                    print("doing root [{}] file [{}] in database [{}]\n".format(root,filename,db))
                    f = open(root + '/' + filename,'r')
                    file_content = f.read()
                    f.close()

                    if self.cnx.database != db:
                        try:
                            self.cnx.database = db
                        except My.Error as err:
                            if err.errno == My.errorcode.ER_BAD_DB_ERROR:
                                if "CREATE DATABASE" in file_content:
                                    pass

                            else:
                                raise err

                    self.process(db,file_content)


    def extractDb(self,sub_folder):
        '''
        get the database name from the folder input
        '''
        t = (sub_folder+'/All').replace('../assets/','').replace('\\','/').split('/')[1]
        return t



    def process(self,db,file_content):
        '''
        Technicaly, this is an abstract method which needs overiding

        '''
        raise Exception('Implement this!')



    def postIterate(self):
        '''
        '''
        # Close connection
        if not self.cnx_proxy:
            self.cnx.close()



