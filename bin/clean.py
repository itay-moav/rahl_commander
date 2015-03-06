#!/usr/local/bin/python3.3
# encoding: utf-8
'''
pyverse.bin.clean -- cleans all objects from selected DB

pyverse.bin.clean
While drop handles only objects that are defined in the assests folder, clean
will remove ALL objects in the database, regardless if they came from assets or
where created there manually by others.
U can use dry run to see what will be dropped.


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
import app.cleaner

def main():
    '''Command line options.'''

    try:
        # Setup argument parser
        parser = app.ArgumentParser(description=config.program_license, formatter_class=app.RawDescriptionHelpFormatter)
        parser.add_argument("--version",action="version",version=config.program_version_message)
        parser.add_argument("--all", dest="handle_all", action="store_true", help="Specifying this flag will clean all db object")
        parser.add_argument("-v", "--verbose", dest="verbosity", action="store_true",                               \
                             help="Specifying this flag will echo list of objects being dropped from DB")

        parser.add_argument("-s","--stored_proc", dest="stored_proc", action="store",nargs='?',                     \
                             default=False, const='All', help="drop all stored procedures, or from just the selected DB. in that case, specify DB name.")

        parser.add_argument("-w","--views", dest="views", action="store",nargs='?',                                 \
                            default=False, const='All', help="drop all views, or from just the selected DB. in that case, specify DB name.")

        parser.add_argument("-t","--triggers", dest="triggers", action="store",nargs='?',                           \
                            default=False, const='All', help="drop all triggers, or from just the selected DB. in that case, specify DB name.")

        parser.add_argument("-f","--functions", dest="functions", action="store",nargs='?',                         \
                            default=False, const='All', help="drop all functions, or from just the selected DB. in that case, specify DB name.")

        parser.add_argument("--dryrun", dest="dry_run", action="store_true",                                        \
                            default=False, help="Specifying this flag will generate a list of drop commands, but not execute them.")

        parser.add_argument("--server", dest="server_connection", action="store", nargs='?',                        \
                            help="optional way to specifiy sql connection username:password@server.ip.or.domain")


        Builder = app.cleaner.AllDBObj(parser)
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
