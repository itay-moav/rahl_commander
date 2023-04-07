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
import traceback

sys.path.insert(0, os.path.dirname(os.path.realpath(__file__)) + '/..')

from app import parser as parser
import app.autocompletion

def main(parser):
    '''Command line options.'''
    try:
        # Setup argument parser
        args = app.init(parser)
        Builder = app.autocompletion.SP(args)
        Builder.run()
        return 0

    except Exception:
        print("----------------------------------------------- LAST ERROR CAUGHT -----------------------------------------------")
        traceback.print_exc()
        print("----------------------------------------------- ----------------- -----------------------------------------------")
        return -1


#++++++++++++++++++++++++++++++++++++ MAIN ENTRY POINT ++++++++++++++++++++++++++++++++++
sys.exit(main(parser))
