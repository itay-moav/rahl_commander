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

@license:    license

@contact:    itay.malimovka@gmail.com
@deffield    updated: Updated
'''

import sys
import os
path, filename = os.path.split(__file__)
sys.path.insert(0, path+'/..')
import config
print("start\n")
print(config.autocomplete['language'])

