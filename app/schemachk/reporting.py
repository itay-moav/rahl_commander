'''
Reporting classes
Will run the rules and generate a report
'''
from __builtin__ import file

def run_tests(table_name,table_rules):
    if len(table_rules) == 0:
        return
    
    # initiating an error report container
    MyErrorContainer = ErrorContainer(right_side_table_name=table_name)
    print("Checking rules for table [{table_name}]".format(table_name=table_name))
    for rule in table_rules:
        table_name = rule.test_rule(table_name) # Do notice, a rule might change the table name, like prefix[baba_] will add baba_ to the right side
                                                # table name for the rest of the rules.
                                                # same with postfix[_gaga] which would add _gaga to the end of the right side table name.
                                                # Both rules can appear in any combination (both, or just one, in any order, in the BEGINNING)
        
        if rule.hasErrors() == True:
            MyErrorContainer.append(left_side_table_name = table_name,msg=rule.get_error_msg())
            
    return MyErrorContainer
            
 
 
 


def generate_report(many_error_containers):
    '''
    Loops on all the error container classes and
    generate a report from them.
    This is where a Formatter would come in handy in
    the future
    '''
    for MyErrorContainer in many_error_containers:
        print("===") THE SECOND MEMBER IN THIS ARRAY IS OF TYPE NON -NEED TO FIGURE OUT FROM WHERE IT CAME
        print(MyErrorContainer)
        print(MyErrorContainer.right_side_table_name)           
   
   
   
   
            
class ErrorContainer():
    '''
    An abstract of an array to hold all the errors returned from a list 
    of tests on a table entry in the rchk file
    '''
    
    def __init__(self,right_side_table_name):
        self.right_side_table_name=right_side_table_name
        self.error_collection = []
        
    def append(self,error_msg):
        self.error_collection.append(error_msg)  
    