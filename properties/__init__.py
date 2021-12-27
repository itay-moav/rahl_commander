import sys
import os
import logging
from properties.ignore_list import ignore_files_dirs_with
from properties.autocomplete import autocomplete


DEBUG = True #you can leave this as is, it is mostly for developers of this module


# Mysql config
# mysql = {'host':'localhost','username':'root','password':'ItayMoav007!!'}

# Assets CHANGE HERE if u want the assets folder to be somewhere else
# Here you can put absolute values (a full string) 
# or a use python function, like in this example.
# assets_folder = '/home/itay/dev-workspace-php/lms-core/anahita/omega_supreme'
#assets_folder = '/home/itay/dev-repositories/emerald/emerald-core/db_gems'


# Logger setup values. 
logman = {'default_log_level': logging.DEBUG}
