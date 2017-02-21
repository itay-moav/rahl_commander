#!/usr/local/bin/python3.4
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

sys.path.insert(0, os.path.dirname(os.path.realpath(__file__)) + '/..')

from app import parser as parser
import app.autocompletion

def main(parser):
    '''Command line options.'''


    try:
        # Setup argument parser
        parser.add_argument("-d","--database", dest="database", action="store",nargs='?', default=False, const='All', help="Generate php auto complete file for stored procedures, or the folder/*.sql specified. Root folder is the database name.")
        args = parser.parse_args()
        app.set_logging(args.verbosity)
        Builder = app.autocompletion.SP(args)
        Builder.run()

    except Exception as e:
        print(e)
        return 1


#++++++++++++++++++++++++++++++++++++ MAIN ENTRY POINT ++++++++++++++++++++++++++++++++++
sys.exit(main(parser))
