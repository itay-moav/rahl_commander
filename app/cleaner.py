'''
Created on Oct 9, 2014

@author: Itay Moav

Specialized DB class to clean all user db objects
functions | stored procedures | views | triggers
'''
import mysql.connector as My

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
        # Check whther take config values or override from command line
        if self.args.server_connection:
            creds = self.args.server_connection.replace(':','@').split('@')
            user=creds[0]
            password=creds[1]
            host=creds[2]
        else:
            user=config.mysql['username']
            password=config.mysql['password']
            host=config.mysql['host']

        self.cnx = My.connect(user=user, password=password,host=host)
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
            print("Start droping Stored Procedures")
            self._cleanSP()
            
        exit()
        if self.what_to_handle['f']:
            self.process(self._load_functions(self.what_to_handle['f']))

        if self.what_to_handle['t']:
            self._load_and_process_triggers(self.what_to_handle['t'])

        if self.what_to_handle['w']:
            self.process(self._load_and_process_views(self.what_to_handle['w']))

    def _cleanSP(self):
        '''
        Load relevant stored procedures and drop them
        '''
        # first load stored procedures
        sql = "SHOW PROCEDURE STATUS WHERE Db NOT IN(" +self.ignore_dbs_str + ") "
        sql += "AND Db IN('" + "','".join(self.what_to_handle['s']) + "')"
        print(sql)
        self.cursor.execute(sql)
        res = [(Db,Name) for(Db,Name,a,b,c,d,e,f,g,h,j) in self.cursor]
        for sp in res:
            sql = "DROP PROCEDURE {db}.{name}".format(db=sp[0],name=sp[1])
            print(sql)
            if(self.args.dry_run):
                print("Dry dropping {db}.{name}".format(db=sp[0],name=sp[1]))
            else:
                self.cursor.execute(sql)

    def _load_stored_procedures(self,target):
        '''
        @target databases to check, or ALL
        '''
        sql = "SHOW PROCEDURE STATUS WHERE Db NOT IN(" +self.ignore_dbs_str + ") "
        where = ()
        if target != 'All':
            sql += "AND Db = %s"
            where = (target,)
        self.cursor.execute(sql,where)
        return [(Db,Name,'s') for(Db,Name,a,b,c,d,e,f,g,h,j) in self.cursor]


    def _load_functions(self,target):
        '''
        @target databases to check, or ALL
        '''
        sql = "SHOW FUNCTION STATUS WHERE Db NOT IN(" +self.ignore_dbs_str + ") "
        where = ()
        if target != 'All':
            sql += "AND Db = %s"
            where = (target,)
        self.cursor.execute(sql,where)
        return [(Db,Name,'f') for(Db,Name,a,b,c,d,e,f,g,h,j) in self.cursor]


    def _load_and_process_triggers(self,target):
        '''
        @target databases to check, or ALL
        '''
        databases = []
        if target == 'All': # go over all DBs except system ones
            self.cursor.execute('SHOW DATABASES')
            databases =  [dbs[0] for dbs in self.cursor if dbs not in self.ignore_dbs]

        else:
            databases.append(target)

        for database_name in databases:
            self.cnx.database = database_name
            self.cursor.execute("SHOW TRIGGERS")
            self.process([(database_name,trigger,'t') for(trigger,a,b,c,d,e,f,g,h,j,i) in self.cursor])


    def _load_and_process_views(self,target):
        '''
        @target databases to check, or ALL
        '''
        databases = []
        if target == 'All': # go over all DBs except system ones
            self.cursor.execute('SHOW DATABASES')
            databases =  [dbs[0] for dbs in self.cursor if dbs not in self.ignore_dbs]

        else:
            databases.append(target)

        for database_name in databases:
            self.cnx.database = database_name
            self.cursor.execute("SHOW FULL TABLES IN {} WHERE TABLE_TYPE LIKE  'VIEW'".format(database_name))
            self.process([(database_name,view,'w') for(view,a) in self.cursor])


    def process(self,obj_descriptor_list):
        '''
        according to object type, construct the drop command
        and either run it, or just display it (dry run) + show what u do in
        the first case if verbose is on
        @var obj_descriptor is a touple with three elements in it, db name, type and obj name
        '''
        if obj_descriptor_list is None or len(obj_descriptor_list)==0:
            return

        if obj_descriptor_list[0][2] == 'w':
            command = "DROP VIEW "

        elif obj_descriptor_list[0][2] == 's':
            command = "DROP PROCEDURE "

        elif obj_descriptor_list[0][2] == 'f':
            command = "DROP FUNCTION "

        elif obj_descriptor_list[0][2] == 't':
            command = "DROP TRIGGER "

        if self.dry_run:
            print("============= DRY RUN, NOTHING WILL HAPPEN ============")
        # Loop on the input and drop it/echo it
        for obj_descriptor in obj_descriptor_list:
            tmp_command = command + obj_descriptor[0] + "." + obj_descriptor[1]
            if self.dry_run:
                print(tmp_command + ";")
            else:
                if self.verbosity:
                    print(tmp_command)
                if self.verbosity == 2:
                    print (tmp_command)

                self.cursor.execute(tmp_command)

