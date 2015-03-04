#!/usr/local/bin/python3.3
# encoding: utf-8
'''
Check if the current code base is in sync with the checked database.
for verbosity 1 (default) Will return in sync | not in sync
for verbosity 2 Will give a list of objects not in sync
                 ~ object exists both code and Db but not in sync
                 + object exists only in code
                 - object exists only in db


@author:     Itay Moav

@copyright:  2014 Itay Moav. All rights reserved.

@license:    license

@contact:    itay.malimovka@gmail.com
@deffield    updated: Updated
'''

import sys
import os
path, filename = os.path.split(__file__)
sys.path.insert(0, path+'/..')
import config
import app.status

def main():
    '''Command line options.'''

    try:
        # Setup argument parser
        parser = app.ArgumentParser(description=config.program_license, formatter_class=app.RawDescriptionHelpFormatter)
        parser.add_argument("--version",action="version",version=config.program_version_message)
        parser.add_argument("--all", dest="handle_all", action="store_true", help="Specifying this flag will compare entire project")
        parser.add_argument("-s","--stored_proc", dest="stored_proc", action="store",nargs='?', default=False, const='All', help="compare stored procedures, or the folder/*.sql specified. Root folder is the database name.")
        parser.add_argument("-w","--views", dest="views", action="store",nargs='?', default=False, const='All', help="compare all views, or the folder/*.sql specified. Root folder is the database name.")
        parser.add_argument("-t","--triggers", dest="triggers", action="store",nargs='?',  default=False, const='All', help="compare all triggers, or the folder/*.sql specified. Root folder is the database name.")
        parser.add_argument("-f","--functions", dest="functions", action="store",nargs='?',  default=False, const='All', help="compare all functions, or the folder/*.sql specified. Root folder is the database name.")
        parser.add_argument("-a", "--assets", dest="assets_path", action="store", nargs='?',  help="optional way to specifiy the assets full path (starting from /)")
        parser.add_argument("-v","--verbosity", dest="verbosity", action="store", default=1, nargs='?', choices=['1','2'], help='''
                                                                            1: simple synced or not synced.
                                                                            2: list of files not synced
                                                                                (~) object exists in code and db but not same
                                                                                (+) object exists only in code
                                                                                (-) object exists only in db''')

        Stat = app.status.StatDBObj(parser)
        Stat.run()

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
