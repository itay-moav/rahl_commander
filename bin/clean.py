#!/usr/local/bin/python3.4
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
import traceback
sys.path.insert(0, os.path.dirname(os.path.realpath(__file__)) + '/..')
from app import parser as parser
import app.cleaner

def main(parser):
    '''Command line options.'''

    try:
        # Setup argument parser
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

        args = app.init(parser)
        Builder = app.cleaner.AllDBObj(args)
        Builder.run()
        return 0

    except Exception:
        print("----------------------------------------------- LAST ERROR CAUGHT -----------------------------------------------")
        traceback.print_exc()
        print("----------------------------------------------- ----------------- -----------------------------------------------")
        return -1

#++++++++++++++++++++++++++++++++++++ MAIN ENTRY POINT ++++++++++++++++++++++++++++++++++
sys.exit(main(parser))
