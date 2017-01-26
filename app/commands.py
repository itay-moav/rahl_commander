'''
Created on Oct 23, 2014

@author: Itay Moav
'''
import app.iterator
import re
from mysql.connector import errorcode as MyErrCode,Error as MyExcp
from app import logging as L

class BuildDBObj(app.iterator.AssetFilesDBConn):
    '''
        Iterator class to build ALL by input params
    '''

    def postCalcFolder(self):
        '''
            Delete what we build. Check the Wheel of Time books, The Dragon had to destroy the
            existing seals first to built better ones
        '''
        DropDBObj(self.args).run()

    def process(self,db,file_content,filename):
        '''
            Just run the sqls
        '''
        L.debug(file_content)
        self.cursor.execute(file_content)


# ============================================================================================================================

class DropDBObj(app.iterator.AssetFilesDBConn):
    '''
        Iterates on all files found, extract the element
        name and type
        drop it
    '''

    def process(self,db,file_content,filename):
        '''
            Read the file and extract from the CREATE stmt the type and name
        '''
        command = ""
        db_object_search = re.search("CREATE\W*(\w*)\W*(\w*)\W*(\w*)\W*(\w*)",file_content,re.I)
        try:
            db_obj_type = db_object_search.group(1)
            db_obj_name = db_object_search.group(2)
            if(db_obj_type == "ALGORITHM"):
                db_obj_type = db_object_search.group(3)
                db_obj_name = db_object_search.group(4)

            command = "DROP {type} {name} ".format(type=db_obj_type,name=db_obj_name)
            L.info(command)
                
        except IndexError:
            L.fatal("Error parsing file contents [{}]".format(file_content))
            raise Exception("Error parsing file contents")
            
        
        try:
            self.cursor.execute(command)

        except MyExcp as err:
            if (
                    err.errno == MyErrCode.ER_SP_DOES_NOT_EXIST or
                    err.errno == MyErrCode.ER_TRG_DOES_NOT_EXIST
                ):
                pass
                


# ============================================================================================================================



