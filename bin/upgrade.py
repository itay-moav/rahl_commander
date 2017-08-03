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
import app.upgrade

def main(parser):
    '''Command line options.'''
    try:
        # Setup argument parser
        parser.add_argument("--limit",      dest="limit_files",   action="store",nargs='?', help="Number of files to process")
        parser.add_argument("--archive",    dest="archive_files", action="store_true",      help="Archive all successfully processed files")
        parser.add_argument("--force_test", dest="test_upgrade",  action="store_true",      help="Test the upgrade on a test DB before actual run")
        
        args = app.init(parser)
        app.upgrade.run(args)
        
    except Exception as e:
        print(e)
        return 1


#++++++++++++++++++++++++++++++++++++ MAIN ENTRY POINT ++++++++++++++++++++++++++++++++++
sys.exit(main(parser))
