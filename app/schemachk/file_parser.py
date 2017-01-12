'''
Created on Jul 7, 2016

@author: itaymoav
'''
from app.schemachk.test_rules import parse_to_TestRule_factory
from app import logging as L
class ChkFileParser():
    '''
    Main class to get a filename and file content
    and translate that into a rule list, later to be matched
    to the right table
    '''
    def __init__(self,all_tables_names,left_side_db,right_side_db,file_content):
        self.all_tables_names = all_tables_names
        self.file_content     = file_content
        self.left_side_db     = left_side_db
        self.right_side_db    = right_side_db
        self.rule_list        = [] # array of toupls (left side table,parsed rule array of SQLReady )
        
    def parseRules(self):
        '''
        start iterating on each line, send relevant lines 
        to the proper translator
        A line can be a continue of the previews line. The rule I use is the : Each line starts with a "table_identifier:" 
        So, the next time I get to a "table_identifier:" this will mark a new rule/line for me
        '''
        all_rules_unparsed = self.file_content.split("\n")
        current_rule = ''
        for unparsed_rule_string in all_rules_unparsed:
            unparsed_rule_string = unparsed_rule_string.strip()
            if len(unparsed_rule_string) == 0 or unparsed_rule_string[0] == '#': # this is an empty line or a comment
                continue
            
            if(':' in unparsed_rule_string): #We start a new rule, first, let's take care of the previous one
                if len(current_rule) > 0: # I need the condition to handle the first iteration, not nice, but simpler and more robust
                    L.debug("Reading Rule [{}]".format(current_rule))
                    #parse the rule
                    self._tokenize_parse_single_rule(current_rule)
                
                # we have a : so we start a new rule
                current_rule = unparsed_rule_string
                
            else: # we concatenate. we need to be aware of ' ' ':' ',' and '|' separators
                #check the last char type to see how to concatenate
                concat_char = ' '
                if   current_rule.endswith(':') or current_rule.endswith(',') or current_rule.endswith('|'):
                    concat_char = ''
                current_rule = current_rule + concat_char + unparsed_rule_string
    
        #last iteration
        L.debug("Reading Rule [{}]".format(current_rule))
        #parse the rule
        self._tokenize_parse_single_rule(current_rule)
        return self
    
    def getRuleList(self):
        '''
            print("entire rule list")
            for rule in self.rule_list:
                print("{}: ".format(rule[0]))
                for Sql in rule[1]:
                    print("  {}".format(Sql))
        '''            
        return self.rule_list
    
    
    def _tokenize_parse_single_rule(self,unparsed_rule_string):
        '''
        @param unparsed_rle_String: string "tablename: rule rule rule" 
        break in the : and then break in the spaces
        '''
        rule_left_side,right_side_rules_string = unparsed_rule_string.split(':')
        if rule_left_side.strip().lower() in ["all","*"]:
            for table_name in self.all_tables_names:
                self._append_rule(table_name=table_name,rules_string=right_side_rules_string)
            
        else:
            self._append_rule(table_name=rule_left_side, rules_string=right_side_rules_string)
         
        return self
         
    def _append_rule(self,table_name,rules_string):
        '''
        Instantiate the rules from string and attach them in a tuple to the table name
        and store in the local tble:ruls container
        '''
        self.rule_list.append(
                (table_name,                                                                    # return Tuple left table to apply rule on
                 [parse_to_TestRule_factory(single_rule_string,self.left_side_db,self.right_side_db)
                  for single_rule_string in rules_string.split(' ') if len(single_rule_string)>2]) # return Tuple right side-array of TestRules
            )
        return self
        
