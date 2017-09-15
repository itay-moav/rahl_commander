#!/usr/local/bin/python3.4
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
sys.path.insert(0, os.path.dirname(os.path.realpath(__file__)) + '/..')
from app import parser as parser
import app.commands
import traceback

def main(parser):
    '''Command line options.'''

    try:
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

        args = app.init(parser)
        #args = parser.parse_args()
        #app.set_logging(args.verbosity)
        
        Builder = app.commands.BuildDBObj(args)
        Builder.run()


    # TODO if not run from another tool, I should let the exception be thrown so I can see proper error logs
    except Exception:
        traceback.print_exc()
        return 1



#++++++++++++++++++++++++++++++++++++ MAIN ENTRY POINT ++++++++++++++++++++++++++++++++++
sys.exit(main(parser))
