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

    # extract the rule name and params
    class_and_params = single_rule.split('[')
    try:
        params = class_and_params[1].replace(']','').split(',')
        
    except IndexError:
        params = []
        
    #instantiate the correct class (SqlRule+RuleName)
    try:
        TestRuleClass = globals()[class_and_params[0].capitalize().replace('_','')]
    except KeyError:
        print("The rule [{no_such_rule}] is not yet supported, or you have a syntax error!".format(no_such_rule=class_and_params[0]))
        print("asset folder= [{}]".format(left_side_db))
        print("file name   = [{}]".format(right_side_db))
        exit(-1)

    return TestRuleClass(single_rule,left_side_db,right_side_db,params,verbosity)





class TestRule():
    '''
    This class will hold the logic to test rules, including the actual SQL 
    to run for each singular rule parsed.
    Initiated with the rule string.
    '''
    
    def __init__(self,single_rule,left_side_db,right_side_db,params,verbosity):
        '''
        @param single_rule: string this is a single rule token from the file, Each line can have several rules space separated, this is only one.  
        @param right_side_db: string the db name to attach to each sql rule. this is the DB that comes from the file name parsed, left side db
        '''
        self.verbosity     = verbosity
        self._single_rule  = single_rule
        self.params        = params
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
        send to the reporting object info as to whther the test passed or not and the error message
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
            else:
                raise err
            
        return self
    
    def get_error_msg(self):
        return "{current_db}.{table_name} does not exists".format(current_db=self.right_side_db,table_name=self.right_side_table)
        

#just aliasing to prevent needless errors
class Exist(Exists):
    pass

                 
                 
                 
I STOPPED HERE, I NEED TO RUN BOTH QUERIES sql 0 and sql 1 AND COMPARE THE FIELDS IN THE RESULTS
I NEED TO TEST WITH TABLES OF DIFFERENT AUTO INCREMENT VALUES
BELOW I HAVE SOME QUERIES WITH OUTPUT EXAMPLE                  
class Same(TestRule):
    def _base_sql(self):
        '''
        '''
        self.sql = "DESCRIBE [[left_side_db]].[[left_side_table]];DESCRIBE [[right_side_db]].[[right_side_table]]"
        return self.sql
    
    def _internal_test_rule(self):
        cursor = self._get_cursor()
        sql=self.sql.split(sep=";")
        cursor.execute(sql[0])
        for allof in cursor:
            print(allof)
        for (field_name,type,*_) in cursor:
            print(field_name)
        exit()
        left_table_structure = [l for l in cursor]
        print(left_table_structure);
        exit()
        cursor.execute(sql[1])
        return self
    
    def get_error_msg(self):
        return "[{left_side_db}.{left_side_table}] does not match [{right_side_db}.{right_side_table}]".format(left_side_db     = self.left_side_db,
                                                                                                               left_side_table  = self.left_side_table,
                                                                                                               right_side_db    = self.right_side_db,
                                                                                                               right_side_table = self.right_side_table)
    
