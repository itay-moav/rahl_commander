'''
Created on Jul 21, 2016

@author: itaymoav
'''
import app.db
from app import logging as L
from mysql.connector import errorcode as MyErrCode,Error as MyExcp


def parse_to_TestRule_factory(single_rule,left_side_db,right_side_db):
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
        file_name = right_side_db
        if left_side_db == right_side_db:
            file_name = "*.schk"
        L.fatal("The rule [{no_such_rule}] is not yet supported, or you have a syntax error! " + \
                "Folder [{asset_folder}] File [{file_name}]".format(\
                                                no_such_rule = class_and_params[0],\
                                                asset_folder = left_side_db,\
                                                file_name=file_name))
        exit(-1)

    return TestRuleClass(single_rule,left_side_db,right_side_db,action_params,ignore_params)





class TestRule():
    '''
    This class will hold the logic to test rules, including the actual SQL 
    to run for each singular rule parsed.
    Initiated with the rule string.
    '''
    
    def __init__(self,single_rule,left_side_db,right_side_db,params,ignore_params):
        '''
        @param single_rule: string this is a single rule token from the file, Each line can have several rules space separated, this is only one.  
        @param right_side_db: string the db name to attach to each sql rule. this is the DB that comes from the file name parsed, left side db
        '''
        self.has_errors    = False
        self._single_rule  = single_rule
        self.params        = params
        self.ignore_params = ignore_params
        self.left_side_db  = left_side_db
        self.right_side_db = right_side_db
        self.sql           = ''
        self.left_side_table  = ''
        self.right_side_table = ''
        self.dynamic_error_str = ''
        self.bail_out = False
        
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
    
    def _get_error_msg(self):
        raise NotImplementedError("You must implement _get_error_msg")
    
    def get_error_msg(self):
        return self._get_error_msg() + ' ' + self.dynamic_error_str
    
    def hasErrors(self):
        return self.has_errors
    
    def dontContinue(self):
        '''
        Will flag the test runner to stop testing further rules for the current table
        '''
        return self.bail_out
    
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
    
    def _get_error_msg(self):
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
 
 
 
 
 
 
class Ignoretables(TestRule):
    '''
    Table names in params, if they match current table
    will cause the test runner to skip further tests.
    USefull when using all:rules and want to avoid one or two tables
    '''
    def _base_sql(self):
        return self.sql
     
    def _internal_test_rule(self):
        if self.right_side_table in self.params:
            self.bail_out = True
        else:
            self.bail_out = False
        
        return self
    
    def _get_error_msg(self):
        return ''    
     
     
     
     
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
                self.has_errors = True
            else:
                raise err
            
        return self
    
    def _get_error_msg(self):
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
            L.info('doing full comparison')
            self._do_full_comparison(left_side_table, right_side_table)
        else:
            L.info('doing ' + str(self.params))
            self._do_partial_comparison(left_side_table, right_side_table)
        
        return self
    
    def _do_full_comparison(self,left_side_table,right_side_table):
        '''
        I check number of fields match (I removed ignored fields in previous steps)
        I check structure is exact same
        '''
        
        if len(left_side_table) != len(right_side_table):
            self.has_errors = True
            self.dynamic_error_str = "number of fields does not match between both tables"
            return
        
        for field_name in left_side_table.keys():
            L.info("checking field {}".format(field_name))
            try:
                if left_side_table[field_name] != right_side_table[field_name]: #full array comparison
                    self.has_errors = True
                    self.dynamic_error_str = "schema for field {} is not same".format(field_name)
                    return
                
            except IndexError:
                self.has_errors = True
                self.dynamic_error_str = "Field {} does not exists in right side table".format(field_name)
                return
                
            
      
    def _do_partial_comparison(self,left_side_table,right_side_table):
        '''
        Loops on the fields,
        For each field (record) compare just the traits (columns) I need to.
        I need to do it that way to have a detailed report as to what is not matching
        Columns in records come in this order: Field,Type,Nul,Key,Default,Extra
        '''
        if len(left_side_table) != len(right_side_table):
            self.has_errors = True
            self.dynamic_error_str += "number of fields do not match between both tables\n"

        for field_name in left_side_table.keys():
            L.info("checking field {}".format(field_name))
            try:
                for compare_type in self.params:
                    if left_side_table[field_name][Same.comapre[compare_type]] != right_side_table[field_name][Same.comapre[compare_type]]:
                        self.has_errors = True
                        self.dynamic_error_str += "field [{}] is not same for comparison param [{}]".format(field_name,compare_type) + "\n"
                
            except IndexError:
                self.has_errors = True
                self.dynamic_error_str += "Field [{}] does not exists in right side table".format(field_name) + "\n"
                
            except KeyError:
                self.has_errors = True
                self.dynamic_error_str += "Field [{}] does not exists in table [{}.{}]".format(field_name,self.right_side_db,self.right_side_table) + "\n"
        
        
    def _get_error_msg(self):
        return "[{left_side_db}.{left_side_table}] does not match [{right_side_db}.{right_side_table}]: ".format(left_side_db     = self.left_side_db,
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
        E = Exists(self._single_rule,self.left_side_db,self.right_side_db,self.params,self.ignore_params)
        E.bind_all_to_sql(self.left_side_table)
        
        self.right_side_table = E.test_rule(self.right_side_table)
        if E.hasErrors():
            self.dynamic_error_str = E.get_error_msg()
            self.has_errors = True
            return
            
        # if I got here, table exists, now I need to run the Same test
        S = Same(self._single_rule,self.left_side_db,self.right_side_db,self.params,self.ignore_params)
        S.bind_all_to_sql(self.left_side_table)
        self.right_side_table = S.test_rule(self.right_side_table)
        if S.hasErrors():
            self.dynamic_error_str = S.get_error_msg()
            self.has_errors = True
        
        return
     
    def _prepare_sql_for_running(self):
        return self
    
    def _get_error_msg(self):
        return ""



class Fieldexists(Exist):
    '''
    makes sense to use in a single db rule file (schk) but, can also be used in 
    match rule file (rchk)
    It verifies the existence of the fields sent as params to this rule
    '''
    
    def _base_sql(self):
        '''
        '''
        self.sql = "DESCRIBE [[right_side_db]].[[right_side_table]]"
        return self.sql
    
    def _internal_test_rule(self):
        '''
        Remember! the results of describe [table_name] are:
        Field,Type,Nul,Key,Default,Extra
        '''
        cursor = self._get_cursor()
        cursor.execute(self.sql)
        fields = [all_fields[0] for all_fields in cursor]
        
        for check_field in self.params:
            L.info("checking field [{}] exists in".format(check_field))
            L.debug(str(fields))
            if check_field not in fields:
                self.has_errors = True
                self.dynamic_error_str += " [" + check_field + "]"
        return self
    
    def _get_error_msg(self):
        return "[{right_side_db}.{right_side_table}] is missing".format(  right_side_db    = self.right_side_db,
                                                                          right_side_table = self.right_side_table)
        
