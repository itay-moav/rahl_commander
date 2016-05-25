'''
Created on May 19, 2016

@author: itaymoav
'''

def tokenizer(rule_line):
    '''
    breaks the line into it's different parts
    and return it as a dictionary object
    '''
    
    
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
        
    def parse(self):
        '''
        main action. 
        Instantiate a tokenizer
        Tokenizes the rule.
        Instantiate a validator (accorindg to file type)
         and validate the tokens
        create a list of affected tables (or ALL)
        '''
        pass
        