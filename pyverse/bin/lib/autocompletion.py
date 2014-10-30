'''
Created on Oct 23, 2014

@author: Itay Moav
'''


import lib.iterator
import sys
import os
import fnmatch



class SP(lib.iterator.AssetFiles):
    '''
        Iterator class to build ALL by input params
    '''

    def __init__(self, parser,db=None):
        '''
        Stores a dictionary of what to build
        @var cnx_proxy boolean : whther we use an injected DB connection or create our own. True == injected
        '''
        # Process arguments
        args = parser.parse_args()
        handle_all = args.handle_all
        if handle_all:
            self.what_to_handle = {'s':'All','w':False, 't':False, 'f':False, 'c':False}
        else:
            self.what_to_handle = {'s':args.database,'w':False, 't':False, 'f':False, 'c':False}

        self.folders = []
        self.parser = parser # Store it in case we need to instantiate other iterators from within an iterator (like the drop it`)

    def postCalcFolder(self):
        '''Open the output file'''
        self.doc_file = open("docfile.php","w")
        self.doc_file.write("""
    class SP{
        /**
         * @return SP
         */
        static function call(){
            return new self;
        }
""")

    def iterate(self):
        '''
        Main iteration processor bala bala
        '''
        for sub_folder in self.folders:
            # Loop on files and run sql
            for root, dirnames, filenames in os.walk(sub_folder):
                for filename in fnmatch.filter(filenames, '*.sql'):
                    db = self.extractDb(root)
                    print("doing root [{}] file [{}] in database [{}]\n".format(root,filename,db))
                    f = open(root + '/' + filename,'r')
                    file_content = f.read()
                    f.close()
                    self.process(db,file_content)

    def process(self,db,file_content):
        '''
            Just run the sqls

        '''
        pass;

    def postIterate(self):
        '''
        close the output file
        '''
        self.doc_file.write("\n\n}\n")
        self.doc_file.close()