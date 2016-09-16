'''
Created on Jul 21, 2016

@author: itaymoav
'''
import app.db
from mysql.connector import errorcode as MyErrCode,Error as MyExcp


def parse_to_TestRule_factory(single_rule,left_side_db,right_side_db,verbosity):
    '''
    Factory function to instantiate, parse and return the correct SQL object
    '''

    # extract the rule name and action_params
    class_and_params = single_rule.split('[')
    action_params = []
    ignore_params = []
    try:
        params = class_and_params[1].replace(']','').split(',')
        
        # extract ignore rules
        for param in params:
            if "ignore" in param:
                ignore_params += param.split('(')[1].replace(')','').split('|')
                
            else:
                action_params.append(param)
        
    except IndexError:
        action_params = []
        
    #instantiate the correct class (SqlRule+RuleName)
    try:
        TestRuleClass = globals()[class_and_params[0].capitalize().replace('_','')]
    except KeyError:
        print("The rule [{no_such_rule}] is not yet supported, or you have a syntax error!".format(no_such_rule=class_and_params[0]))
        print("asset folder= [{}]".format(left_side_db))
        print("file name   = [{}]".format(right_side_db))
        exit(-1)

    return TestRuleClass(single_rule,left_side_db,right_side_db,action_params,ignore_params,verbosity)





class TestRule():
    '''
    This class will hold the logic to test rules, including the actual SQL 
    to run for each singular rule parsed.
    Initiated with the rule string.
    '''
    
    def __init__(self,single_rule,left_side_db,right_side_db,params,ignore_params,verbosity):
        '''
        @param single_rule: string this is a single rule token from the file, Each line can have several rules space separated, this is only one.  
        @param right_side_db: string the db name to attach to each sql rule. this is the DB that comes from the file name parsed, left side db
        '''
        self.has_errors    = False
        self.verbosity     = verbosity
        self._single_rule  = single_rule
        self.params        = params
        self.ignore_params = ignore_params
        self.left_side_db  = left_side_db
        self.right_side_db = right_side_db
        self.sql           = ''
        self.left_side_table  = ''
        self.right_side_table = ''
        
    def __str__(self):
        return "{left_side_db} {rule} in {db_name} ({params}) : {sql}".format(left_side_db = self.left_side_db,
                                                                              db_name      = self.right_side_db,
                                                                              rule         = self._single_rule,
                                                                              params       = self.params,sql=self.sql)
    
    def bind_all_to_sql(self,left_side_table):
        '''
        Binds all the values into the SQL.
        Called when rules are hard binded to their relevance db.table
        '''
        self.left_side_table = left_side_table
        self.sql = self._base_sql().replace("[[left_side_db]]",    self.left_side_db)       \
                                   .replace("[[right_side_db]]",   self.right_side_db)      \
                                   .replace("[[left_side_table]]", left_side_table)

        return self

    def test_rule(self,overwrite_right_side_table):
        self.right_side_table = overwrite_right_side_table
        self._table_rename_phase() # overwrite this
        self._prepare_sql_for_running()
        self._internal_test_rule() # overwrite this
        return self.right_side_table

    def _base_sql(self):
        '''
        generates the specific sql that will be used to validate the rule
        Populates __self__.sql
        ''' 
        raise NotImplementedError("You must implement _base_sql in app.schemachk.test_rules.{}".format(self.__class__.__name__))
            
    def _internal_test_rule(self):
        '''
        overwrite this method with the specific logic to modify right side table (post/prefix)
        and to run the tests.
        The method will return a (maybe) modified name of the right side table, and 
        send to the reporting object info as to whether the test passed or not and the error message
        @return string new right side table name
        
        THIS IS AN ABSTRACT METHOD
        '''
        raise NotImplementedError("You must implement _internal_test_rule() in app.schemachk.sql_objects.{}".format(self.__class__.__name__))
     
    def _prepare_sql_for_running(self):
        self.sql = self.sql.replace("[[right_side_table]]",self.right_side_table)
        return self
    
    def _table_rename_phase(self):
        '''
        If you have a "rule" whose purpose is to modify table name
        Implement this here by overwriting this method
        '''
        pass
    
    def get_error_msg(self):
        raise NotImplementedError("You must implement get_error_msg")
    
    def hasErrors(self):
        return self.has_errors
    
    def _get_cursor(self):
        cnx = app.db.get_connection()
        return cnx.cursor()


class Table(TestRule):
    '''
        This special rule, which better come first, will set the table name to 
        something but the default (default assumes table name to check is the same as the right side table name)
    '''
        
    def _table_rename_phase(self):
        self.right_side_table = self.params[0]
    
    def _base_sql(self):
        return self.sql
     
    def _internal_test_rule(self):
        return self
    
    def get_error_msg(self):
        return ''
     
     
   
class Prefix(Table):
    '''
        Adds a prefix to the table name
    '''
        
    def _table_rename_phase(self):
        self.right_side_table = self.params[0] + self.right_side_table



class Postfix(Table):
    '''
        Adds a postfix to the table name
    '''
        
    def _table_rename_phase(self):
        self.right_side_table = self.right_side_table + self.params[0]
 
  
     
     
class Exists(TestRule):
    def _base_sql(self):
        '''
        exists will verify input table exists in this db (just name)
        '''
        self.sql = "DESCRIBE [[right_side_db]].[[right_side_table]]"
        return self.sql
    
    def _internal_test_rule(self):
        '''
        Checks for table existence
        '''
        cursor = self._get_cursor()
        try:
            cursor.execute(self.sql)
            
        except MyExcp as err:
            if err.errno == MyErrCode.ER_NO_SUCH_TABLE:
                print(self.get_error_msg())
                raise err
            else:
                raise err
            
        return self
    
    def get_error_msg(self):
        return "{current_db}.{table_name} does not exists".format(current_db=self.right_side_db,table_name=self.right_side_table)
        

#just aliasing to prevent needless errors
class Exist(Exists):
    pass

                 
                 
                 
                
class Same(TestRule):
    
    comapre = { #fields returned in DESCRIBE, and the comparison type that will use that field
               'type':      1,
               'keys':      3,
               'defaults':  4,
               'incr':      5}
    
    def _base_sql(self):
        '''
        '''
        self.sql = "DESCRIBE [[left_side_db]].[[left_side_table]];DESCRIBE [[right_side_db]].[[right_side_table]]"
        return self.sql
    
    def _internal_test_rule(self):
        '''
        Remember! the results of describe [table_name] are:
        Field,Type,Nul,Key,Default,Extra
        '''
        sql=self.sql.split(';')
        cursor = self._get_cursor()
        cursor.execute(sql[0])
        left_side_table = {all_fields[0]:all_fields for all_fields in cursor if all_fields[0] not in self.ignore_params}
        del cursor
        cursor = self._get_cursor()
        cursor.execute(sql[1])
        
        right_side_table = {all_fields[0]:all_fields for all_fields in cursor if all_fields[0] not in self.ignore_params}
        del cursor
        
        # print(left_side_table)
        # print(right_side_table)
        # exit()
        
        if(self.params[0] in ['*','All','all'] or sorted(['type','defaults','incr','keys']) == sorted(self.params)): # Do a full comparison
            print('doing full comparison')
            self._do_full_comparison(left_side_table, right_side_table)
        else:
            print('doing ' + str(self.params))
            self._do_partial_comparison(left_side_table, right_side_table)
        
        return self
    
    def _do_full_comparison(self,left_side_table,right_side_table):
        '''
        I check number of fields match (I removed ignored fields in previous steps)
        I check structure is exact same
        '''
        
        if len(left_side_table) != len(right_side_table):
            raise Exception("REPORTLOGGER: number of fields does not match between both tables")
        
        for field_name in left_side_table.keys():
            print("checking field {}".format(field_name))
            try:
                if left_side_table[field_name] != right_side_table[field_name]: #full array comparison
                    raise Exception("REPORTLOGGER: schema for field {} is not same".format(field_name))
            except IndexError:
                raise Exception("REPORTLOGGERREPORTLOGGER: Field {} does not exists in right side table".format(field_name))
            
      
    def _do_partial_comparison(self,left_side_table,right_side_table):
        '''
        Loops on the fields,
        For each field (record) compare just the traits (columns) I need to.
        I need to do it that way to have a detailed report as to what is not matching
        Columns in records come in this order: Field,Type,Nul,Key,Default,Extra
        '''
        if len(left_side_table) != len(right_side_table):
            raise Exception("REPORTLOGGER: number of fields does not match between both tables")

        for field_name in left_side_table.keys():
            print("checking field {}".format(field_name))
            try:
                for compare_type in self.params:
                    if left_side_table[field_name][Same.comapre[compare_type]] != right_side_table[field_name][Same.comapre[compare_type]]:
                        raise Exception("REPORTLOGGER: field {} is not same for comparison param {}".format(field_name,compare_type))
                
            except IndexError:
                raise Exception("REPORTLOGGER: Field {} does not exists in right side table".format(field_name))
        
        
    def get_error_msg(self):
        return "[{left_side_db}.{left_side_table}] does not match [{right_side_db}.{right_side_table}]".format(left_side_db     = self.left_side_db,
                                                                                                               left_side_table  = self.left_side_table,
                                                                                                               right_side_db    = self.right_side_db,
                                                                                                               right_side_table = self.right_side_table)
    
    
class Sameifexists(TestRule):
    '''
    a compound rule, container, will run exists, if exists does not fail
    will run same.
    if exists fail, we just continue
    '''
    
    def _base_sql(self):
        '''
        no need for this
        '''
        return ''
            
    def _internal_test_rule(self):
        '''
        overwrite this method with the specific logic to modify right side table (post/prefix)
        and to run the tests.
        The method will return a (maybe) modified name of the right side table, and 
        send to the reporting object info as to whether the test passed or not and the error message
        @return string new right side table name
        
        TO MAKE THIS HAPPEN PROPERLY I ALSO NEED TO BIND ALL THAT MATTERS TO THE E AND S classes
        IF I DO NOT DO IT, THE SQL WILL BE EMPTY IN THOSE INEER CLASSES.
        I CAN (ND SHOULD) PROBABLY DO THIS IN THIS METHOD ONLY
        
        '''
        
        
        E = Exists(self._single_rule,self.left_side_db,self.right_side_db,self.params,self.ignore_params,self.verbosity)
        E.bind_all_to_sql(self.left_side_table)
        
        try:
            self.right_side_table = E.test_rule(self.right_side_table)
        except MyExcp as err:
            if err.errno == MyErrCode.ER_NO_SUCH_TABLE:
                return self # no such table, no need to do the same
            else:
                raise err
            
        # if I got here, table exists, now I need to run the Same test
        S = Same(self._single_rule,self.left_side_db,self.right_side_db,self.params,self.ignore_params,self.verbosity)
        S.bind_all_to_sql(self.left_side_table)
        return S.test_rule(self.right_side_table)
     
    def _prepare_sql_for_running(self):
        return self
    
    def get_error_msg(self):
        return "[{left_side_db}.{left_side_table}] does not match [{right_side_db}.{right_side_table}]".format(left_side_db     = self.left_side_db,
                                                                                                               left_side_table  = self.left_side_table,
                                                                                                               right_side_db    = self.right_side_db,
                                                                                                               right_side_table = self.right_side_table)
    

