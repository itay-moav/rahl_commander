'''
Created on Oct 9, 2014

@author: Itay Moav

Specialized DB class to clean all user db objects
functions | stored procedures | views | triggers
'''
import app.db
import config
import app.meta as meta

class AllDBObj():
    '''
    Get command line params Loop on all specified DBs and get the objects we need to remove
    '''

    def __init__(self, parser):
        '''
        Stores a dictionary of what to clean
        '''
        # Process arguments
        self.args = parser.parse_args()
        
        # Loads the database names rcom is tracking. This will be used in case of --all, this will also be used in case a specific db 
        # is targeted to make sure i is a tracked DB.
        sp_dbs       = meta.TrackedDBs(meta.STORED_PROCEDURES,self.args.assets_path).folders
        trigger_dbs  = meta.TrackedDBs(meta.TRIGGERS,self.args.assets_path).folders
        function_dbs = meta.TrackedDBs(meta.FUNCTIONS,self.args.assets_path).folders
        views_dbs    = meta.TrackedDBs(meta.VIEWS,self.args.assets_path).folders
        
        # decide which DBs I am going to clean. --all means EVERYTHING,
        #  -s,-w,-t,-f means every thing for each of those types
        #  -s db name, -f db name -w db name -tdb name means JUST THAT db name 
        #      for the specified object type, u can have several object types
        if self.args.handle_all:
            self.what_to_handle = {'s':sp_dbs,'w':views_dbs, 't':trigger_dbs, 'f':function_dbs}

        else:
            self.what_to_handle = {'s': sp_dbs       if self.args.stored_proc == 'All' else ([self.args.stored_proc] if self.args.stored_proc in sp_dbs       else []),
                                   'w': views_dbs    if self.args.views       == 'All' else ([self.args.views]       if self.args.views       in views_dbs    else []), 
                                   't': trigger_dbs  if self.args.triggers    == 'All' else ([self.args.triggers]    if self.args.triggers    in trigger_dbs  else []), 
                                   'f': function_dbs if self.args.functions   == 'All' else ([self.args.functions]   if self.args.functions   in function_dbs else [])}
        print("cleaning the following:")
        print(self.what_to_handle)
       
        # More config values for later
        self.dry_run = self.args.dry_run
        self.verbosity = self.args.verbosity
        self.ignore_dbs = [('information_schema',),('performance_schema',),('sys',)]
        self.ignore_dbs_str = "'information_schema','performance_schema','sys'"
        self.connect()

        
    def connect(self):
        '''
        '''
        self.cnx = app.db.get_connection(self.args.server_connection)
        self.cursor = self.cnx.cursor()


    def run(self):
        '''
        main entry point. send to processing each type (trigger,sp,func,view,scripts)
        '''
        self.cleanMain()
        self.postProcess()

    def postProcess(self):
        '''
        Clean resources
        '''
        # Close connection
        self.cnx.close()

    def cleanMain(self):
        '''
        Just call each specific cleaner -> very procedural and simple
        '''
        if(len(self.what_to_handle['s']) > 0):
            print("Start dropping Stored Procedures")
            self._cleanSP()
            
        if(len(self.what_to_handle['f']) > 0):
            print("Start dropping Functions")
            self._cleanFunctions()

        if(len(self.what_to_handle['t']) > 0):
            print("Start dropping Triggers")
            self._cleanTriggers()

        if(len(self.what_to_handle['w']) > 0):
            print("Start dropping Views")
            self._cleanViews()


    def _cleanSP(self):
        '''
        Load relevant stored procedures and drop them
        '''
        # first load stored procedures
        sql = "SHOW PROCEDURE STATUS WHERE Db NOT IN(" +self.ignore_dbs_str + ") "
        sql += "AND Db IN('" + "','".join(self.what_to_handle['s']) + "')"
        print(sql)
        self.cursor.execute(sql)
        res = [(Db,Name) for (Db,Name,*_) in self.cursor]
        for sp in res:
            sql = "DROP PROCEDURE {db}.{name}".format(db=sp[0],name=sp[1])
            print(sql)
            if(self.args.dry_run):
                print("Dry dropping sp {db}.{name}".format(db=sp[0],name=sp[1]))
            else:
                self.cursor.execute(sql)

    def _cleanFunctions(self):
        '''
        Load relevant mysql functions and drop them
        '''
        # first load functions
        sql = "SHOW FUNCTION STATUS WHERE Db NOT IN(" +self.ignore_dbs_str + ") "
        sql += "AND Db IN('" + "','".join(self.what_to_handle['f']) + "')"
        print(sql)
        self.cursor.execute(sql)
        res = [(Db,Name) for (Db,Name,*_) in self.cursor]
        for mysql_func in res:
            sql = "DROP FUNCTION {db}.{name}".format(db=mysql_func[0],name=mysql_func[1])
            print(sql)
            if(self.args.dry_run):
                print("Dry dropping function {db}.{name}".format(db=mysql_func[0],name=mysql_func[1]))
            else:
                self.cursor.execute(sql)


    def _cleanTriggers(self):
        '''
        Load relevant mysql triggers and drop them
        '''
        # iterate on each db to get the list of triggers
        for database_name in self.what_to_handle['t']:
            self.cnx.database = database_name
            self.cursor.execute("SHOW TRIGGERS")
            for trigger_name in [trigger for (trigger,*_) in self.cursor]:
                sql = "DROP TRIGGER {db}.{name}".format(db=database_name,name=trigger_name)
                print(sql)
                if(self.args.dry_run):
                    print("Dry dropping function {db}.{name}".format(db=database_name,name=trigger_name))
                else:
                    self.cursor.execute(sql)

    
    def _cleanViews(self):
        '''
        Load relevant mysql views and drop them
        '''
        # iterate on each db to get the list of triggers
        for database_name in self.what_to_handle['w']:
            self.cnx.database = database_name
            self.cursor.execute("SHOW FULL TABLES IN {} WHERE TABLE_TYPE LIKE 'VIEW'".format(database_name))
            for view_name in [view for (view,*_) in self.cursor]:
                sql = "DROP VIEW {db}.{name}".format(db=database_name,name=view_name)
                print(sql)
                if(self.args.dry_run):
                    print("Dry dropping view {db}.{name}".format(db=database_name,name=view_name))
                else:
                    self.cursor.execute(sql)
