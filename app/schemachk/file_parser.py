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
    def __init__(self,check_against_db,file_content,verbosity):
        self.file_content = file_content
        self.check_against_db = check_against_db
        self.rule_list    = [] # array of toupls (left side table,parsed rule array of SQLReady )
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
            self.rule_list.append(self._tokenize_parse_single_rule(unparsed_rule_string))
            
        return self
    
    def getRuleList(self):
        print("entire rule list")
        print(self.rule_list)
        return self.rule_list
    
    
    def _tokenize_parse_single_rule(self,unparsed_rule_string):
        '''
        @param unparsed_rle_String: string "tablename: rule rule rule" 
        break in the : and then break in the spaces
        @return: (,)
        '''
        rule_left_side,right_side_rules_string = unparsed_rule_string.split(':')
        return ("ALL" if rule_left_side.strip().lower() in ["all","*"] else rule_left_side.lower(),          
                [SQLReady(rule_string,self.check_against_db,self.verbosity) for rule_string in right_side_rules_string.split(' ') if len(rule_string)>2])
    

        


class SQLReady():
    '''
    This class will hold the actual SQL to run for each singular rule parsed.
    '''
    
    def __init__(self,single_rule,db_name,verbosity):
        '''
        @param single_rule: string this is a single rule token from the file, Each line can have several rules space separated, this is only one.  
        @param db_name: string the db name to attach to each sql rule. this is the DB that comes from the file name parsed
        '''
        self.verbosity = verbosity
        self._single_rule = single_rule
        self.db_name = db_name
        