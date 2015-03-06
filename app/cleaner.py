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
        self.args = parser.parse_args()
        handle_all = self.args.handle_all

        if handle_all:
            self.what_to_handle = {'s':'All','w':'All', 't':'All', 'f':'All'}

        else:
            self.what_to_handle = {'s':self.args.stored_proc,'w':self.args.views, 't':self.args.triggers, 'f':self.args.functions}

        self.dry_run = self.args.dry_run
        self.verbosity = self.args.verbosity
        self.ignore_dbs = [('information_schema',),('performance_schema',)]
        self.ignore_dbs_str = "'information_schema','performance_schema'"
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
        self.prepareLists()
        self.postProcess()

    def postProcess(self):
        '''
        Clean resources
        '''
        # Close connection
        self.cnx.close()

    def prepareLists(self):
        '''
        For each element kind (function,view,sp,trigger etc)
        I check if an action is needed.
        If so, I call a method to load the list of objects
        to clean, and send those to the PROCESS method which delets.
        Sometime, the load has to call the process, if it has a loop in it
        '''
        self.all_dbs = None
        if self.what_to_handle['s']:
            self.process(self.load_stored_procedures(self.what_to_handle['s']))

        if self.what_to_handle['f']:
            self.process(self.load_functions(self.what_to_handle['f']))

        if self.what_to_handle['t']:
            self.load_and_process_triggers(self.what_to_handle['t'])

        if self.what_to_handle['w']:
            self.process(self.load_and_process_views(self.what_to_handle['w']))


    def load_stored_procedures(self,target):
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


    def load_functions(self,target):
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


    def load_and_process_triggers(self,target):
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


    def load_and_process_views(self,target):
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
                self.cursor.execute(tmp_command)

