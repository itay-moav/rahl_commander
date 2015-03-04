#!/usr/local/bin/python3.3
# encoding: utf-8
'''
pyverse.bin.gcode -- gets a normalized version of the code.

pyverse.bin.gcode -- Normalized version of code is all white spaces are translated to ' ' space.
                     All start of line comments are removed.
                     Adds the DELIMITER query at start and end of code.
                     In future version it will also add the databse name to the object name, if missing.

It defines classes_and_methods

@author:     Itay Moav

@copyright:  2008 All rights reserved.

@license:    license

@contact:    user_email
@deffield    updated: Updated
'''

import sys
import os
path, filename = os.path.split(__file__)
sys.path.insert(0, path+'/..')
import config
import app.commands

def main():
    '''Command line options.'''

    try:
        # Setup argument parser
        parser = app.ArgumentParser(description=config.program_license, formatter_class=app.RawDescriptionHelpFormatter)
        parser.add_argument("--version",action="version",version=config.program_version_message)
        parser.add_argument("--all", dest="handle_all", action="store_true", help="Specifying this flag will fetch the entire project")
        parser.add_argument("-v", "--verbose", dest="verbosity", action="store_true", help="Specifying this flag will echo list of files processed")
        parser.add_argument("-s","--stored_proc", dest="stored_proc", action="store",nargs='?', default=False, const='All', help="fetch code for all stored procedures, or the folder/*.sql specified. Root folder is the database name.")
        parser.add_argument("-w","--views", dest="views", action="store",nargs='?', default=False, const='All', help="fetch code for all views, or the folder/*.sql specified. Root folder is the database name.")
        parser.add_argument("-t","--triggers", dest="triggers", action="store",nargs='?',  default=False, const='All', help="fetch code for all triggers, or the folder/*.sql specified. Root folder is the database name.")
        parser.add_argument("-f","--functions", dest="functions", action="store",nargs='?',  default=False, const='All', help="fetch code for all functions, or the folder/*.sql specified. Root folder is the database name.")
        parser.add_argument("-c","--scripts", dest="scripts", action="store",nargs='?', default=False, const='All', help="fetch code for all scripts, or the folder/*.sql specified. Root folder is the database name.")
        parser.add_argument("--db", dest="code_source", action="store",nargs='?', default='assets', const='db', help="If flag specified, will bring the code from the DB.")
        parser.add_argument("--original", dest="dont_clean_code", action="store",nargs='?', default=False, const=True, help="If flag specified, will bring the code as is from Assets folder.")
        parser.add_argument("-a", "--assets", dest="assets_path", action="store", nargs='?',  help="optional way to specifiy the assets full path (starting from /)")

        CodeCleaner = app.commands.CleanCodeObj(parser)
        CodeCleaner.run()

    except Exception as e:
        if config.DEBUG:
            raise(e)
        indent = len(config.program_name) * " "
        sys.stderr.write(config.program_name + ": " + repr(e) + "\n")
        sys.stderr.write(indent + "  for help use --help")
        return 2



#++++++++++++++++++++++++++++++++++++ MAIN ENTRY POINT ++++++++++++++++++++++++++++++++++
if len(sys.argv) == 1: # no params given, do --help
    sys.argv.append("-h")
sys.exit(main())
