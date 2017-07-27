'''
Created on Oct 23, 2014

@author: Itay Moav
'''
import os
import shutil
import config
import app.iterator
from app import logging as L



class SP(app.iterator.AssetFiles):
    '''
        Iterator class to find SPs and build auto completion for PHP/Eclipse
    '''

    def __init__(self, args,db=None):
        '''
        Stores a dictionary of what to build
        @var cnx_proxy boolean : whether we use an injected DB connection or create our own. True == injected
        '''
        # Process arguments
        if args.handle_all:
            self.what_to_handle = {'s':'All'}
        else:
            L.fatal('You must use --all to run this command!')
        
        self.assets_path = config.assets_folder
        self.folders = []
        self.args = args # Store it in case we need to instantiate other iterators from within an iterator (like the drop it`)
        self.file_postfix = '.sql'
        
        
        if len(config.autocomplete['return']) > 1:
            self._return_type = config.autocomplete['return']
        else:
            self._return_type = "\SP"
        

    def postCalcFolder(self):
        '''Open the output file'''
        self.doc_file = open(self.assets_path + "/autocompletion/php/SP.php","w")
        header = """
<?php
/**
 * Autocompletion stub
 * You call (dbname)_(stored_procedure_name)
 */
class SP{{
        /**
         * @return {}
         */
        static function call(){{
            return new self;
        }}
""".format(self._return_type)
        L.debug(header)
        self.doc_file.write(header)

    def changeDB(self,db,file_content):
        '''
            Shuting down the change DB used in all other iterators
        '''
        pass


    def process(self,db,file_content,filename):
        '''
            Loops on the file itself and parses it (using a parser
            Into the a buffer, letter to be written into the output file
        '''
        looking_for_header        = True
        looking_for_header_args   = False
        looking_for_body          = False
        not_yet_started_args      = True #once I start looking into the args string, I no longer start from (, as it can be the ( in INT(11)
        SP                        = SpDataParser(self._current_path + '/' + filename)

        for line in file_content.splitlines():
            if looking_for_body:
                SP.addBodyLine(line)

            if looking_for_header:
                # method name
                if "CREATE PROCEDURE" in line and len(line)>(len("CREATE PROCEDURE")+8):
                    start_funcname = line.find("CREATE PROCEDURE")
                    end_funcname_location = line.find('(')
                    SP.addSPName(line[start_funcname+len("CREATE PROCEDURE")+1:end_funcname_location],db)
                    looking_for_header = False
                    looking_for_header_args = True

            # method arguments
            if looking_for_header_args:
                if not_yet_started_args:
                    start_args    = line.find('(')
                    not_yet_started_args = False

                else:
                    start_args  = 0

                end_args    = line.find('BEGIN')

                if(end_args > -1): # Means we got to the end of the args section
                    looking_for_header_args = False
                    looking_for_body = True

                SP.addRawArgStr(line[start_args+1:])

        # Write parsed stuff into the output file
        self.doc_file.write(str(SP))
        L.debug(str(SP))



    def postIterate(self):
        '''
        close the output file
        '''
        self.doc_file.write("\n\n}\n")
        self.doc_file.close()
        
        # Copy the file to the editors autocompletion plugin folder. If it has that path setup
        pass #TODO shuting down the copy into the eclipse, should use include project in build path
        # if False and len(config.autocomplete[config.autocomplete['editor']]['plugin_dir']) > 1:
        #    plugin_dir = config.autocomplete['editor_workspace'] + "/" + config.autocomplete[config.autocomplete['editor']]['plugin_dir']
        #    auto_complete_dir = plugin_dir + "/" + sorted(os.listdir(plugin_dir),reverse=True)[0]
        #    L.info("Copy [" + self.assets_path + "/autocompletion/php/SP.php] TO [" + auto_complete_dir + "/SP.php]")
        #    shutil.copyfile(self.assets_path + "/autocompletion/php/SP.php",auto_complete_dir + "/SP.php")















class SpDataParser:
    """
        Get a hold of the raw data of the class,
        parse it and provide methods to extract the data in PHP mode
        TODO later to have language
        translation as a plug-in
    """
    def __init__(self,file_name):
        self.file_name = file_name
        self.ArgList    = []
        self.body       = ''
        self.right_side_db    = ''
        self.sp_name    = ''
        self.raw_args   = ''
        if len(config.autocomplete['db_name_separator']) > 1:
            self._db_name_separator = config.autocomplete['db_name_separator']    
        else:
            self._db_name_separator = "__"

    def addSPName(self,sp_name,db_name):
        """Get the stored procedure name and performes all needed cleanup on the string to be a legal php func name"""
        self.right_side_db = db_name
        self.sp_name = sp_name.replace('`','')

    def addRawArgStr(self,arg_str):
        """Add the raw param string pieces, cleanup will be done later, as this might span multiple lines"""
        self.raw_args += arg_str

    def addBodyLine(self,line):
        """Adds the body, no real clean-up is needed here (maybe remove the END at the end"""
        self.body += line + "\n"

    def _paramsComments(self):
        params = ''

        return params

    def comments(self):
        """formats the comment secion of the function, phpdoc wize"""
        comments = "\t   /**\n"
        comments += "\t\t* Database: " + self.right_side_db + "\n"
        comments += "\t\t* " + self.sp_name + "\n"
        comments += "\t\t* File: " + self.file_name + "\n\t\t*\n"
        comments += self._paramsComments()
        for Arg in self.ArgList:
            comments += "\t\t* @param " + Arg.php_data_type + " $" + Arg.name + "  :" + ' '.join([Arg.type,Arg.name,Arg.data_type]) + "\n"

        comments += "\t\t*\n\t\t* @return " + config.autocomplete['return'] + "\n\t\t*/\n"
        return comments

    def prepareArgs(self):
        """splits the arg string into specific arguments. Each arg is an Object, special care needs to be given to ENUM types here..."""
        in_enum = False
        pack_enum = ''
        for arg in self.raw_args.split(','):
            if arg.find('ENUM') > -1:
                in_enum = True

            if in_enum:
                pack_enum += arg
            else:
                try:
                    ArgObj = SpArguments(arg)
                except ArgError:
                    continue

                self.ArgList.append(ArgObj)

            if in_enum and arg.find(')') > -1:
                self.ArgList.append(SpArguments(pack_enum))
                pack_enum = ''
                in_enum = False

    def getArgsAsPHP(self):
        """The function header in PHP, the arguments part"""
        return "(" + ','.join(["$" + Arg.name for Arg in self.ArgList]) + ")"

    def __str__(self):
        """run al the cleanups and formatting, returns the methid as PHP code"""
        self.prepareArgs()
        # db_name sp_name separator TODO should come from config file
        return "\n\n" + self.comments() + "\t\tpublic function {DB}{SEP}{SP_NAME}{ARGS}".format(DB = self.right_side_db,\
                                                                                   SEP = self._db_name_separator,\
                                                                                   SP_NAME = self.sp_name,\
                                                                                   ARGS = self.getArgsAsPHP()) + "{\n\t\t\t/*\n" + self.body.replace('END','') + "\n\t\t\t*/\n\t\t}\n"




class ArgError(Exception):
    pass




class SpArguments:
    """Represents one argument, has arg name, type, in or out"""
    def __init__(self,raw_arg):
        self.type,self.data_type,self.php_data_type,self.name = self.parse(raw_arg)

    def parse(self,raw_arg):
        arg_type = ''
        data_type = ''

        loc1 = raw_arg.find('IN ')
        loc2 = raw_arg.find('OUT ')

        if loc1 > -1:
            arg_type = 'IN'

        elif loc2 > -1:
            arg_type = 'OUT'

        else: # this is not a legal argument
            raise ArgError()

        raw_arg = raw_arg.split(arg_type + ' ')[1].split(' ')
        arg_name = raw_arg[0]
        temp_type = ''.join(raw_arg[1:]).replace("\n",'')

        loc3 = temp_type.find('))')
        loc4 = temp_type.find(')')
        if(loc3>-1):
            data_type = temp_type[:loc3+1]
        elif(loc4>-1):
            if(temp_type.find('(') > -1):
                loc4 += 1

            data_type = temp_type[:loc4]
        else:
            data_type = temp_type

        if(data_type.upper().find('INT') > -1):
            php_data_type = 'integer'
        elif(data_type.upper().find('ENUM') > -1):
            php_data_type = 'integer'
        elif(data_type.upper().find('CHAR') > -1):
            php_data_type = 'string'
        elif(data_type.upper().find('TEXT') > -1):
            php_data_type = 'string'
        elif(data_type.upper().find('TIME') > -1):
            php_data_type = 'string'
        elif(data_type.upper().find('DATE') > -1):
            php_data_type = 'string'
        else:
            php_data_type = 'baba'

        return [arg_type,data_type,php_data_type,arg_name]

