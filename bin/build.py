#!/usr/local/bin/python3.3
# encoding: utf-8
'''
pyverse.bin.build -- builds DB objects into your database.

pyverse.bin.build Use this command to build the various code generate objects in your DB, like Stored Procedures, Functions, Views and Triggers


@author:     Itay Moav

@copyright:  2014 open source. All rights reserved.

@license:    license

@contact:    itay.malimovka@gmail.com
@deffield    updated: Updated
'''

import sys
import os
sys.path.insert(0, os.path.abspath('..'))
import config
import app.commands

def main():
    '''Command line options.'''

    try:
        # Setup argument parser
        parser = app.ArgumentParser(prog='build.py',description=config.program_license, formatter_class=app.RawDescriptionHelpFormatter)
        parser.add_argument("--version",action="version",version=config.program_version_message)
        parser.add_argument("--all", dest="handle_all", action="store_true", help="Specifying this flag will rebuild the entire project")
        parser.add_argument("-v", "--verbose", dest="verbosity", action="count", help=config.help_common_language['verbosity'])
        parser.add_argument("-s","--stored_proc", dest="stored_proc", action="store",nargs='?', default=False, const='All',                 \
                            help="build all stored procedures, or the folder/*.sql specified. Root folder is the database name.")

        parser.add_argument("-w","--views", dest="views", action="store",nargs='?', default=False, const='All',                             \
                            help="build all views, or the folder/*.sql specified. Root folder is the database name.")

        parser.add_argument("-t","--triggers", dest="triggers", action="store",nargs='?',  default=False, const='All',                      \
                            help="build all triggers, or the folder/*.sql specified. Root folder is the database name.")

        parser.add_argument("-f","--functions", dest="functions", action="store",nargs='?',  default=False, const='All',                    \
                            help="build all functions, or the folder/*.sql config specified. Root folder is the database name.")

        parser.add_argument("-c","--scripts", dest="scripts", action="store",nargs='?', default=False, const='All',                         \
                            help="run all scripts, or the folder/*.sql specified. Root folder is the database name.")

        parser.add_argument("-a", "--assets", dest="assets_path", action="store", nargs='?', default=False,                                 \
                            help=config.help_common_language['assets'])

        parser.add_argument("--server", dest="server_connection", action="store", nargs='?', default=False,                                 \
                            help=config.help_common_language['server_connection'])

        Builder = app.commands.BuildDBObj(parser)
        Builder.run()

    except KeyboardInterrupt:
        ### handle keyboard interrupt ###
        return 0

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
