'''
Created on Jul 7, 2016

@author: itaymoav
'''
from app.schemachk.test_rules import parse_to_TestRule_factory
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
        '''
        all_rules_unparsed = self.file_content.split("\n")
        for unparsed_rule_string in all_rules_unparsed:
            unparsed_rule_string = unparsed_rule_string.strip()
            if len(unparsed_rule_string) == 0 or unparsed_rule_string[0] == '#': # this is an empty line or a comment
                continue
            
            '''
            if(self.verbosity):
                print("Reading Rule [{}]".format(unparsed_rule_string))
            '''
            
            #parse the rule
            self._tokenize_parse_single_rule(unparsed_rule_string)
            
        return self
    
    def getRuleList(self):
        '''
        if(self.verbosity):
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
                self._append_rule(table_name=table_name,rule_string=right_side_rules_string)
            
        else:
            self._append_rule(table_name=rule_left_side, rule_string=right_side_rules_string)
         
        return self
         
    def _append_rule(self,table_name,rule_string):
        '''
        Instantiate the rules from string and attche them in a touple to the table name
        and store in the local tble:ruls container
        '''
        self.rule_list.append(
                (table_name,                                                                    # return Tuple right side-array of TestRules
                 [parse_to_TestRule_factory(rule_string,self.left_side_db,self.right_side_db)]) # return Tuple right side-array of TestRules
            )
        return self
        
