'''
Created on Oct 9, 2014

@author: Itay Moav
'''
class BuildAction():
    '''
    Get command line params and build the db objects.
    Loop on all specified folders and get the files we need to run
    '''

    PATH = '\\'
    arg_to_foldername = {'t':'triggers','f':'functions','c':'scripts','s':'sp','w':'views'}

    def __init__(self, parser):
        '''
        Stores a dictionary of what to build
        '''
        # Process arguments
        args = parser.parse_args()
        build_all = args.build_all
        if build_all:
            self.what_to_build = {'s':'All','w':'All', 't':'All', 'f':'All', 'c':'All'}
        else:
            self.what_to_build = {'s':args.stored_proc,'w':args.views, 't':args.triggers, 'f':args.functions, 'c':args.scripts}

    def process(self):
        '''
        main entry point. send to processing each type (trigger,sp,func,view,scripts)
        '''
        for obj_type,dest in self.what_to_build.items():
            self.typeBuild(obj_type,dest)

    def typeBuild(self,obj_type,dest):
        '''
        For each type, build.
        First decide if build is needed
        Then on what (all/subfolder/one file only) is the dest
        '''
        if(self.what_to_build[obj_type]):
            self.loopOnFolders("../assets/" + self.arg_to_foldername[obj_type],dest)

    def loopOnFolders(self,object_folder,sub_folder):
        '''
        Just another procedural step in parsing the args into which folder to Run
        and on which database to
        '''
        if(sub_folder == "All"):
            sub_folder = object_folder
        else:
            sub_folder = object_folder + '/' + sub_folder

        self.run(sub_folder)

    def extractDb(self,sub_folder):
        '''
        get the database name from the folder input
        '''
        t = (sub_folder+'/All').replace('../assets/','').replace('\\','/').split('/')[1]
        return t

    def run(self,sub_folder):
        '''
        Here we are file level
        So I just run the sql in each file I find
        '''
        # Connect to DB (TODO get DB connection abstracted)
        cnx = My.connect(user='root', password='',
                      host='127.0.0.1')
        cursor = cnx.cursor()

        # Loop on files and run sql
        for root, dirnames, filenames in os.walk(sub_folder):
            for filename in fnmatch.filter(filenames, '*.sql'):
                db = self.extractDb(root)
                print("doing root [{}] file [{}] in database [{}]\n".format(root,filename,cnx.database))
                f = open(root + '/' + filename,'r')
                sql = f.read()
                f.close()
                print(sql)

                if cnx.database != db:
                    try:
                        cnx.database = db
                    except My.Error as err:
                        if err.errno == My.errorcode.ER_BAD_DB_ERROR:
                            if "CREATE DATABASE" in sql:
                                cursor.execute(sql)
                        else:
                            print(err)

                    else:
                        cursor.execute(sql)

        # Close connection
        cnx.close()











