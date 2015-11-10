#!/usr/local/bin/python3.3
# encoding: utf-8
'''
@author:     Itay Moav

@copyright:  2014 organization_name. All rights reserved.

@license:    license

@contact:    user_email
@deffield    updated: Updated
'''

import sys
import os
sys.path.insert(0, os.path.abspath('..'))
import config
import app.autocompletion

def main():
    '''Command line options.'''


    try:
        # Setup argument parser
        parser = app.ArgumentParser(description=config.program_license, formatter_class=app.RawDescriptionHelpFormatter)
        parser.add_argument("--version",action="version",version=config.program_version_message)
        parser.add_argument("--all", dest="handle_all", action="store_true", help="Specifying this flag will generate SP auto completion for all databases")
        parser.add_argument("-v", "--verbose", dest="verbosity", action="store_true", help="Specifying this flag will echo list of files processed")
        parser.add_argument("-d","--database", dest="database", action="store",nargs='?', default=False, const='All', help="Generate php auto complete file for stored procedures, or the folder/*.sql specified. Root folder is the database name.")
        parser.add_argument("-a", "--assets", dest="assets_path", action="store", nargs='?',  help="optional way to specifiy the assets full path (starting from /)")

        Builder = app.autocompletion.SP(parser)
        Builder.run()

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
