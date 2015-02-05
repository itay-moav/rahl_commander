#!/usr/local/bin/python3.3
# encoding: utf-8
'''
pyverse.bin.test -- shortdesc

pyverse.bin.test is a description

A test script to verify installation went fine, and ll is ready

@author:     Itay Moav

@copyright:  2015 Itay Moav. All rights reserved.

@license:    license

@contact:    itay.malimovka@gmail.com
@deffield    updated: Updated
'''
# Check all folders in assets exists
# check there is a mysql Connection
# Check all databases defined in assets folder exists

import sys
import os
sys.path.insert(0, os.path.abspath('..'))
import app.Test
Test = app.Test.Install(None)
Test.run()