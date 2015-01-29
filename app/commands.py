'''
Created on Oct 23, 2014

@author: Itay Moav
'''
import app.iterator
import re
from mysql.connector import errorcode as MyErrCode,Error as MyExcp


class BuildDBObj(app.iterator.AssetFiles):
    '''
        Iterator class to build ALL by input params
    '''

    def postCalcFolder(self):
        '''
            Delete what we build. Check the Wheel of Time books, The Dragon had to destroy the
            existing seals first to built better ones
        '''
        DropDBObj(self.parser,self.cnx).run()

    def process(self,db,file_content):
        '''
            Just run the sqls
        '''
        self.cursor.execute(file_content)


# ============================================================================================================================

class DropDBObj(app.iterator.AssetFiles):
    '''
        Iterates on all files found, extract the element
        name and type
        drop it
    '''

    def process(self,db,file_content):
        '''
            Read the file and extract from the CREATE stmt the type and name
        '''
        lines = file_content.split("\n")
        sql_elm_info = None
        for line in lines: # For now, I assume CREATE and all in same line
            if "CREATE " in line:
                sql_elm_info = line.split(' ')
                break

        # Maybe file is empty? TODO should I log / report this?
        if(sql_elm_info):
            name = sql_elm_info[2].split('(')[0].replace('`','')
            command = "DROP {type} {name} ".format(type=sql_elm_info[1],name=name)

            try:
                self.cursor.execute(command)

            except MyExcp as err:
                if (
                        err.errno == MyErrCode.ER_SP_DOES_NOT_EXIST or
                        err.errno == MyErrCode.ER_TRG_DOES_NOT_EXIST
                    ):
                    pass



# ============================================================================================================================


class CleanCodeObj(app.iterator.AssetFiles):
    '''
        Iterator class to fetch sql code without problematic
        white characters.
        Will also remove full line comments.
        Good to use when u want to copy paste the code and run it manually without \t\t\t
        developers might use in formating the code.
    '''

    def process(self,db,file_content):
        '''
           Prints a copy of the procedure which
           can be copy-pasted into the CLI of MySQL without
           problematic white spaces like TABS \t

           or print it as is
        '''
        print("\n===================================\n")
        if self.args.dont_clean_code:
            print(file_content)
        else:
            pattern = re.compile('(--.*\n|\s)') # remove SQL comments and then white spaces. Replace with ' '
            print(pattern.sub(' ',file_content))



# ============================================================================================================================




class StatDBObj(app.iterator.AssetFiles):
    '''
        Iterator class to check sync stat ALL by input params
    '''


    def process(self,db,file_content):
        '''
            Just run the sqls
        '''
        print("not functional yet")
        exit()


# ============================================================================================================================