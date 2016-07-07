'''
Created on Jul 7, 2016

@author: itaymoav
'''

class ChkFileParser():
    '''
    Main class to get a filename and file content
    and translate that into a rule list, later to be matched
    to the right table
    '''
    def __init__(self,filename,file_content,verbosity):
        self.file_content = file_content
        self.rule_list    = [] # array of toupls (left side table,parsed rule)
        self.verbosity    = verbosity
        
    def parseRules(self):
        '''
        start iterating on each line, send relevant lines 
        to the proper translator
        '''
        all_rules_unparsed = self.file_content.split("\n")
        for unparsed_rule_string in all_rules_unparsed:
            unparsed_rule_string = unparsed_rule_string.strip()
            if len(unparsed_rule_string) == 0 or unparsed_rule_string[0] == '#': # this is an empty line or a comment
                continue
            if(self.verbosity):
                print("Reading Rule [{}]".format(unparsed_rule_string))
            
            #parse the rule
            ParsedRule = RuleParser(unparsed_rule_string,self.verbosity)
            self.rule_list.append((ParsedRule.table_name,ParsedRule.rule_object))
            
        return self
    
    def getRuleList(self):
        print(self.rule_list)
        return self.rule_list
    
    
    
    
    
    
    
class RuleParser():
    '''
    Takes a single rule string, tokenize and parse it
    into something I can make SQL out of
    '''
    
    def __init__(self,unparsed_rule_string,verbosity):
        '''
        do the entire thing here
        '''
        self.verbosity      = verbosity
        self.unparsed_rule_string = unparsed_rule_string
        self.table_name     = 'ALL'
        self.rule_object    = None
        self._do_the_parse_dance()
        
    def _do_the_parse_dance(self):
        '''
        main logic for single rule parsing
        '''
        self.table_name,tokenized_rule_string = tokenize_rule_string(self.unparsed_rule_string)
        print("table lefty")
        
    
   
   
   
   
   
    
def tokenize_rule_string(unparsed_rule_string):
    '''
    break in the : and then break in the spaces
    @return: (,)
    '''
    rule_left_side,right_side_rules_string = unparsed_rule_string.split(':')
    return ("ALL" if rule_left_side.strip().lower() in ["all","*"] else rule_left_side.lower(),right_side_rules_string.split(' '))
    