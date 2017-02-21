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
from app import parser as parser
import app.schemachk

def main(parser):
    ''' Specific command line options.'''

    # Setup argument parser
    parser.add_argument("-d","--database", dest="database", action="store",nargs='?', default=False, const='All', \
                                    help="Schema check the specified database name rules, or the folder/*.[s|r]chk specified. Root folder is the database name.")
    args = parser.parse_args()
    app.set_logging(args.verbosity)
    app.schemachk.run(args)

   


#++++++++++++++++++++++++++++++++++++ MAIN ENTRY POINT ++++++++++++++++++++++++++++++++++s
sys.exit(main(parser))
