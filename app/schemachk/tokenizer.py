'''
Created on May 19, 2016
TODO TOBEDELETED AFTER IMLMENTED IN THE PARSER PACKAGE

@author: itaymoav
'''

def tokenizer_factory(single_rule):
    '''
    breaks the line into it's different parts
    and return it as a dictionary object
    '''
    print(single_rule)
    if single_rule == "": return None
    
    return None
    
    
class TokenMaster():
    '''
    Tokenize each line rule, Validate each Token. Get the table(s) affected by the rule,
    Pass responsebility to the Token Translator system.
    '''


    def __init__(self, rule,related_db,file_type,log_verbosity):
        '''
        Constructor
        '''
        self.verbosity = log_verbosity
        self.related_db = related_db
        self.file_type = file_type
        self.rule_as_string = rule
        self.affected_table = ""
        self.rules_right_side = [] # not sure about this, let's see how it goes.
        
    def parse(self):
        '''
        main action. 
        Instantiate a tokenizer
        Tokenizes the rule.
        Instantiate a validator (accorindg to file type) and validate the tokens ?????????
        create a list of affected tables (or ALL)
        '''
        
        # split by :
        rule_left_side,right_side_rules_string = self.rule_as_string.split(':')
        
        # calc affected tables
        self.affected_table = "ALL" if rule_left_side.strip().lower() in ["all","*"] else rule_left_side.lower()
        print("{} ---> {}".format(self.affected_table,right_side_rules_string)) 
        
        # tokenize right side of rule string
        self.rules_right_side = [tokenizer_factory(single_rule) for single_rule in right_side_rules_string.split(' ')]
        