'''
Check if the current code base is in sync with the checked database.
for verbosity 1 (default) Will return in sync | not in sync
for verbosity 2 Will give a list of objects not in sync
                 ~ object exists both code and Db but not in sync
                 + object exists only in code
                 - object exists only in db


@author:     Itay Moav

@copyright:  2014 Itay Moav. All rights reserved.

@license:    Do what ever you want, I am not responsible in any way,

@contact:    itay.malimovka@gmail.com
@deffield    updated: Updated
'''

import sys
import os
import traceback
sys.path.insert(0, os.path.dirname(os.path.realpath(__file__)) + '/..')
from app import parser as parser
#import app.commands

# import argparse
#if len(sys.argv) == 1: # no params given, do --help
#    sys.argv.append("--all")
import app.test

def main(parser):
    '''Command line options.'''
    print("start\n")
    try:
        args = app.init(parser)
        Tester = app.test.Install(args)
        Tester.run()


    except Exception:
        traceback.print_exc()
        return 1



#++++++++++++++++++++++++++++++++++++ MAIN ENTRY POINT ++++++++++++++++++++++++++++++++++
sys.exit(main(parser))