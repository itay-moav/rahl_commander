#!/usr/local/bin/python3.8
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
import traceback
sys.path.insert(0, os.path.dirname(os.path.realpath(__file__)) + '/..')
from app import parser as parser
import app.upgrade

def main(parser):
    '''Command line options.'''
    try:
        # Setup argument parser
        parser.add_argument("--limit",      dest="limit_files",   action="store",nargs='?', help="Number of files to process")
        parser.add_argument("--archive",    dest="archive_files", action="store_true",      help="Archive all successfully processed files")
        parser.add_argument("--force_test", dest="test_upgrade",  action="store_true",      help="Test the upgrade on a test DB before actual run. " + \
                                                                                                 "NOTICE! To run just tests, do not use the --all or --limit args")
        parser.add_argument("--with_schema",dest="with_schema_checker",  \
                                                                  action="store_true",      help="Runs the full schema checker. If u have a test server, " + \
                                                                                                 "will do it there first, right after running the tests. " + \
                                                                                                 "Otherwise, will run only on real server.")
        parser.add_argument("--unblock",    dest="file_name_to_unblock",  \
                                                                  action="store",nargs='?', help="DANGEROUS! Takes an upgrade file name as arg. " + \
                                                                                                 "If it is not completed, it will remove it from the tracking DB")
        parser.add_argument("--mark_completed", dest="file_name_to_mark_complete",  \
                                                                  action="store",nargs='?', help="DANGEROUS! Takes an upgrade file name as arg. " + \
                                                                                                 "If it is in the file system, it will mark it completed in the tracking DB")
        parser.add_argument("--mark_complete",  dest="file_name_to_mark_complete",  \
                                                                  action="store",nargs='?', help="DANGEROUS! Takes an upgrade file name as arg. " + \
                                                                                                 "If it is in the file system, it will mark it completed in the tracking DB")
        
        args = app.init(parser)
        app.upgrade.run(args)
        
    except Exception:
        traceback.print_exc()
        return 1


#++++++++++++++++++++++++++++++++++++ MAIN ENTRY POINT ++++++++++++++++++++++++++++++++++
sys.exit(main(parser))
