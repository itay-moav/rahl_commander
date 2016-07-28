'''
Created on Jul 21, 2016

@author: itaymoav
'''
import app.db
from mysql.connector import errorcode as MyErrCode,Error as MyExcp


def parse_to_sql_factory(single_rule,check_against_db_name,verbosity):
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
    SqlClass = globals()[class_and_params[0].capitalize().replace('_','')]
    return SqlClass(single_rule,check_against_db_name,params,verbosity)



class SQLReady():
    '''
    This class will hold the actual SQL to run for each singular rule parsed.
    Parses the string token into a SQL command
    '''
    
    def __init__(self,single_rule,check_against_db,params,verbosity):
        '''
        @param single_rule: string this is a single rule token from the file, Each line can have several rules space separated, this is only one.  
        @param check_against_db: string the db name to attach to each sql rule. this is the DB that comes from the file name parsed
        '''
        self.verbosity = verbosity
        self._single_rule = single_rule
        self.params = params
        self.check_against_db = check_against_db
        self.sql = ''
        self._generate_sql()
        
    def __str__(self):
        return "{rule} in {db_name} ({params}) : {sql}".format(db_name=self.check_against_db,rule=self._single_rule,params=self.params,sql=self.sql)
    
    def _generate_sql(self):
        '''
        generates the specific sql that will be used to validate the rule
        Populates __self__.sql
        ''' 
        raise NotImplementedError("You must implement _generate_sql in app.schemachk.sql_objects.{}".format(self.__class__.__name__))
    
    def test_rule(self,right_side_table_name):
        '''
        adds the origin table name -> The table name that is on the right side of
        the rule string [table name]:rule 
        This makes the assumptions you match tables to same name tables in other DBs.
        
        runs the sql
        tests the result to see the rule has been complied to
        @return boolean
        
        THIS IS AN ABSTRACT METHOD
        '''
        raise NotImplementedError("You must implement test_rule(table_name) in app.schemachk.sql_objects.{}".format(self.__class__.__name__))
     
    def _prepare_sql_for_running(self,right_side_table_name):
        self.right_side_table_name = right_side_table_name
        return self.sql.replace('[[table_name]]', right_side_table_name)
    
    def get_error_msg(self):
        raise NotImplementedError("You must implement get_error_msg")
    
    def _get_cursor(self):
        cnx = app.db.get_connection()
        return cnx.cursor()


class Table(SQLReady):
    def _generate_sql(self):
        '''
        This special rule, which better come first, will set the table name to 
        something but the default (assumes table name to check is the same as the right side table name)
        '''
        self.sql = self.params[0]
        return self
     
    def test_rule(self,right_side_table_name):
        return self.sql
    
    def get_error_msg(self):
        return ''
     
     
     
     
class Exists(SQLReady):
    def _generate_sql(self):
        '''
        exists will verify input table exists in this db (just name)
        '''
        self.sql = "DESCRIBE {current_db}.[[table_name]]".format(current_db=self.check_against_db)
        return self
    
    def test_rule(self,right_side_table_name):
        '''
        Checks for table existance
        '''
        
        sql    = self._prepare_sql_for_running(right_side_table_name)
        cursor = self._get_cursor()
        try:
            cursor.execute(sql)
            
        except MyExcp as err:
            if err.errno == MyErrCode.ER_NO_SUCH_TABLE:
                print(self.get_error_msg())
            else:
                raise err
            
        return right_side_table_name
    
    def get_error_msg(self):
        return "{current_db}.{table_name} does not exists".format(current_db=self.check_against_db,table_name=self.right_side_table_name)
        

#just aliasing to prevent needless errors
class Exist(Exists):
    pass

                 
                 
                 
                  
class Same(SQLReady):
    def _generate_sql(self):
        '''
        exists will verify input table exists in this db (just name)
        '''
        self.sql = "DESCRIBE {current_db}.[[table_name]]".format(current_db=self.check_against_db)
        return self
    
    def test_rule(self,right_side_table_name):
        sql = self._prepare_sql_for_running(right_side_table_name)
        cursor = self._get_cursor()
        
        try:
            cursor.execute(sql)
        except Exception as e: # build error object
            raise e
            
        return self.right_side_table_name
    
    def get_error_msg(self):
        return "{current_db}.{table_name} does not match".format(current_db=self.check_against_db,table_name=self.right_side_table_name)
    
    
    
class Notexists(SQLReady):
    def _generate_sql(self):
        '''
        exists will verify input table exists in this db (just name)
        '''
        self.sql = "DESCRIBE {current_db}.[[table_name]]".format(current_db=self.check_against_db)
        return self
    
    
    
    

    
class Fieldexists(SQLReady):
    def _generate_sql(self):
        '''
        exists will verify input table exists in this db (just name)
        '''
        self.sql = "DESCRIBE {current_db}.[[table_name]]".format(current_db=self.check_against_db)
        return self
    