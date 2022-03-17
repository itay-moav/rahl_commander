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
import traceback
sys.path.insert(0, os.path.dirname(os.path.realpath(__file__)) + '/..')
from app import parser as parser
import app.commands

def main(parser):
    '''Command line options.'''

    try:
        # Setup argument parser
        parser.add_argument("-s","--stored_proc", dest="stored_proc", action="store",nargs='?', default=False, const='All',             \
                                help="drop all stored procedures, or the folder/*.sql specified. Root folder is the database name.")

        parser.add_argument("-w","--views", dest="views", action="store",nargs='?', default=False, const='All',                         \
                                help="drop all views, or the folder/*.sql specified. Root folder is the database name.")

        parser.add_argument("-t","--triggers", dest="triggers", action="store",nargs='?',  default=False, const='All',                  \
                                help="drop all triggers, or the folder/*.sql specified. Root folder is the database name.")

        parser.add_argument("-f","--functions", dest="functions", action="store",nargs='?',  default=False, const='All',                \
                                help="drop all functions, or the folder/*.sql specified. Root folder is the database name.")

        args = app.init(parser)
        Builder = app.commands.DropDBObj(args)
        Builder.run()

    except Exception:
        traceback.print_exc()
        return 1

#++++++++++++++++++++++++++++++++++++ MAIN ENTRY POINT ++++++++++++++++++++++++++++++++++
sys.exit(main(parser))
