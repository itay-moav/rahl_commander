'''
Created on May 19, 2016

@author: Itay Moav
'''
from types import DictionaryType
from SystemEvents.Text_Suite import attachment

class TableList():
    '''
    Object to hold the list of tables a single config file [.schk | .rchk]
    affects, and the rules attached to each table.
    Object give utilities to add/remove/edit list of tables
                             add/edit/remove list of rules attached to table
                             read the rules for a table.
    '''


    def __init__(self,file_name,log_verbosity,list_of_tables):
        '''
        Constructor
        '''
        self.file_name = file_name
        self.verbosity = log_verbosity
        self.list_of_tables = list_of_tables
        if(self.verbosity):
            print("Initiating TableList for file [{}]".format(self.file_name))
            print(list_of_tables)
        
        
    def attachRules(self,rule):
        '''
        rule is a DictionaryType
        with 'table' which can be ALL or a table name
        and rules, which is the actuall rules to attach
        to the specifc table or to all tables in self.list_of_tables
        '''
        