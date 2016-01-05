#!/usr/local/bin/python3.4
# encoding: utf-8
'''
pyverse.bin.build -- shortdesc

pyverse.bin.build is a description

It defines classes_and_methods

@author:     Itay Moav

@copyright:  2014 Itay Moav. All rights reserved.

@license:    license

@contact:    itay.malimovka@gmail.com
@deffield    updated: Updated
'''

import sys
import os
path, filename = os.path.split(__file__)
sys.path.insert(0, os.path.abspath(path+'/..'))
import config
import app.commands

def main():
    '''Command line options.'''

    try:
        # Setup argument parser
        parser = app.ArgumentParser(description=config.program_license, formatter_class=app.RawDescriptionHelpFormatter)
        parser.add_argument("--version",action="version",version=config.program_version_message)
        parser.add_argument("--all", dest="handle_all", action="store_true", help="Specifying this flag will drop all db object")
        parser.add_argument("-v", "--verbose", dest="verbosity", action="store_true", help=config.help_common_language['verbosity'])

        parser.add_argument("-s","--stored_proc", dest="stored_proc", action="store",nargs='?', default=False, const='All',             \
                                help="drop all stored procedures, or the folder/*.sql specified. Root folder is the database name.")

        parser.add_argument("-w","--views", dest="views", action="store",nargs='?', default=False, const='All',                         \
                                help="drop all views, or the folder/*.sql specified. Root folder is the database name.")

        parser.add_argument("-t","--triggers", dest="triggers", action="store",nargs='?',  default=False, const='All',                  \
                                help="drop all triggers, or the folder/*.sql specified. Root folder is the database name.")

        parser.add_argument("-f","--functions", dest="functions", action="store",nargs='?',  default=False, const='All',                \
                                help="drop all functions, or the folder/*.sql specified. Root folder is the database name.")

        parser.add_argument("-a", "--assets", dest="assets_path", action="store", nargs='?',  help=config.help_common_language['assets'])
        parser.add_argument("--server", dest="server_connection", action="store", nargs='?',  help=config.help_common_language['server_connection'])

        Builder = app.commands.DropDBObj(parser)
        Builder.run()

    except Exception as e:
        if config.DEBUG:
            raise(e)
        indent = len(config.program_name) * " "
        sys.stderr.write(config.program_name + ": " + repr(e) + "\n")
        sys.stderr.write(indent + "  for help use --help")
        return 2

#++++++++++++++++++++++++++++++++++++ MAIN ENTRY POINT ++++++++++++++++++++++++++++++++++
if len(sys.argv) == 1:
    sys.argv.append("-h")
sys.exit(main())
