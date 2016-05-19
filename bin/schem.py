#!/usr/local/bin/python3.4
# encoding: utf-8
'''
@author:     Itay Moav

@copyright:  2016 Itay Moav.

@license:    license

@contact:    itay.malimovka@gmail.com
@deffield    updated: Updated
'''

import sys
import os

sys.path.insert(0, os.path.dirname(os.path.realpath(__file__)) + '/..')

import config
import app
import app.schemachk

def main():
    '''Command line options.'''


    try:
        # Setup argument parser
        parser = app.ArgumentParser(description=config.program_license, formatter_class=app.RawDescriptionHelpFormatter)
        parser.add_argument("--version",action="version",version=config.program_version_message)
        parser.add_argument("--all", dest="handle_all", action="store_true", \
                                        help="Specifying this flag will Schema Check the entire project")
        parser.add_argument("-v", "--verbose", dest="verbosity", action="store_true", \
                                        help="By default, not specifying this will echo only the errors. Specifying it -v will show compared elements. -vv will Show what rules are applied for each element")
        parser.add_argument("-d","--database", dest="database", action="store",nargs='?', default=False, const='All', \
                                        help="Schema check the specified database name rules, or the folder/*.chk specified. Root folder is the database name.")
        parser.add_argument("-a", "--assets", dest="assets_path", action="store", nargs='?',  \
                                        help="optional way to specifiy the assets full path (starting from /)")
        parser.add_argument("--server", dest="server_connection", action="store", nargs='?', default=False,                                 \
                            help=config.help_common_language['server_connection'])

        # app.schemachk.run(parser)

    except Exception as e:
        if config.DEBUG:
            raise(e)
        indent = len(config.program_name) * " "
        sys.stderr.write(config.program_name + ": " + repr(e) + "\n")
        sys.stderr.write(indent + "  for help use --help")
        return 2
    app.schemachk.run(parser)


#++++++++++++++++++++++++++++++++++++ MAIN ENTRY POINT ++++++++++++++++++++++++++++++++++

if len(sys.argv) == 1: # no params given, do --help
    sys.argv.append("-h")
sys.exit(main())
