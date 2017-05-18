#!/usr/local/bin/python3.4
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

@license:    Do what ever you want, I am not responsible in any way,

@contact:    itay.malimovka@gmail.com
@deffield    updated: Updated
'''

import sys
import os
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
        #parser = argparse.ArgumentParser(description="testing ...", formatter_class=argparse.RawDescriptionHelpFormatter)
        #parser.add_argument("--all", dest="handle_all", action="store_true",help=argparse.SUPPRESS)
        #parser.add_argument("-a", "--assets", dest="assets_path", action="store", nargs='?', default=False,help="optional way to specify the assets full path (starting from /)")
        #parser.add_argument("--server", dest="server_connection", action="store", nargs='?', default=False,help="server_connection")
        args = app.init(parser)
        #args = parser.parse_args()
        Tester = app.test.Install(args)
        Tester.run()


    except Exception as e:
        print(e)
        return 1



#++++++++++++++++++++++++++++++++++++ MAIN ENTRY POINT ++++++++++++++++++++++++++++++++++
sys.exit(main(parser))