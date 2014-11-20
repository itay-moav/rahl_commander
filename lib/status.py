'''
Created on Nov 20, 2014

@author: Itay Moav
'''
import lib.iterator
from distutils.sysconfig import project_base

class StatDBObj:
    '''
        Iterator class to check sync stat ALL by input params
    '''
    def __init__(self, parser):
        '''
            decides which stat class to use
        '''
        args = parser.parse_args()
        if args.verbosity == '2':
            self.__StatObj = FullStatDBObj(parser)
        else:
            self.__StatObj = QuickStatDBObj(parser)



    def run(self):
        #shutdown the verbosity of the default behavior
        self.__StatObj.verbosity = False

        do_all = True
        for check in self.__StatObj.what_to_handle.items():
            if check[1]:
                do_all = False
                break

        if do_all:
            self.__StatObj.what_to_handle = {'s':'All','w':'All', 't':'All', 'f':'All'}

        self.__StatObj.run()









class FullStatDBObj(lib.iterator.AssetFiles):
    '''
        Do a full status sweep of the project base
        + object in project only
        - object on DB only
        ~ objects do not match between db and project
    '''


    def process(self,db,file_content):
        '''
            Just run the sqls
        '''
        raise Exception('baba')
        print(self._current_file)






class QuickStatDBObj(lib.iterator.AssetFiles):
    '''
        A simple synced / not synced result.
        Will bail out on the first inconsistency

    '''


    def process(self,db,file_content):
        '''
            Just run the sqls
        '''
        raise Exception('gogo')
        print(self._current_file)



