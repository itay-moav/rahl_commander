'''
Created on Oct 9, 2014

@author: Itay Moav

Specialized DB class to clean all user db objects
functions | stored procedures | views | triggers
'''
import mysql.connector as My
import config

class AllDBObj():
    '''
    Get command line params Loop on all specified DBs and get the objects we need to remove
    '''

    def __init__(self, parser):
        '''
        Stores a dictionary of what to clean
        '''
        # Process arguments
        args = parser.parse_args()
        handle_all = args.handle_all

        if handle_all:
            self.what_to_handle = {'s':'All','w':'All', 't':'All', 'f':'All'}

        else:
            self.what_to_handle = {'s':args.stored_proc,'w':args.views, 't':args.triggers, 'f':args.functions}

        self.dry_run = args.dry_run
        self.verbosity = args.verbosity
        self.connect()

    def connect(self):
        '''
        '''
        # Connect to DB (TODO get DB connection abstracted)
        self.cnx = My.connect(user=config.mysql['username'], password=config.mysql['password'],host=config.mysql['host'])
        self.cursor = self.cnx.cursor()

    def run(self):
        '''
        main entry point. send to processing each type (trigger,sp,func,view,scripts)
        '''
        self.prepareLists()
        self.postProcess()

    def postProcess(self):
        '''
        '''
        # Close connection
        self.cnx.close()

    def prepareLists(self):
        '''
        Iterate on each db and object in the lists
        '''
        self.all_dbs = None
        if self.what_to_handle['s']:
            self.process(self.load_stored_procedures(self.what_to_handle['s']))

        if self.what_to_handle['f']:
            self.process(self.load_functions(self.what_to_handle['f']))

        if self.what_to_handle['t']:
            self.process(self.load_triggers(self.what_to_handle['t']))

        if self.what_to_handle['w']:
            #  self.process(self.load_views(self.what_to_handle['w']))
            pass

    def load_stored_procedures(self,sp_def):
        sql = "SHOW PROCEDURE STATUS "
        where = ()
        if sp_def != 'All':
            sql += "WHERE Db = %s"
            where = (sp_def,)
        self.cursor.execute(sql,where)
        return [(Db,Name,'s') for(Db,Name,a,b,c,d,e,f,g,h,j) in self.cursor]

    def load_functions(self,fn_def):
        sql = "SHOW FUNCTION STATUS "
        where = ()
        if fn_def != 'All':
            sql += "WHERE Db = %s"
            where = (fn_def,)
        self.cursor.execute(sql,where)
        return [(Db,Name,'f') for(Db,Name,a,b,c,d,e,f,g,h,j) in self.cursor]

    def load_triggers(self,trg_def):
        databases = []
        if trg_def == 'All': # go over all DBs except system ones
            self.cursor.execute('SHOW DATABASES')
            databases =  [dbs[0] for dbs in self.cursor if dbs not in [('information_schema',),('performance_schema',)]]

        else:
            databases.append(trg_def)

        for database_name in databases:
            self.cnx.database = database_name
            self.cursor.execute("SHOW TRIGGERS")
            self.process([(database_name,Trigger,'t') for(Trigger,a,b,c,d,e,f,g,h,j,i) in self.cursor])


    def process(self,obj_descriptor_list):
        '''
        according to object type, construct the drop command
        and either run it, or just display it (dry run) + show what u do in
        the first case if verbose is on
        @var obj_descriptor is a touple with three elements in it, db name, type and obj name
        '''
        print(obj_descriptor_list)



