import sys
import os
import logging
from config.ignore_list import ignore_files_dirs_with
from config.common_language import help_common_language
from config.autocomplete import autocomplete


#TOBEDELETED100 __all__ = []

DEBUG = True




# Mysql config
mysql = {'host':'localhost','username':'root','password':''}

# Assets CHANGE HERE if u want the assets folder to be somewhere else
assets_folder = os.path.abspath('../example_assets')

# Logger setup values. 
logman = {'default_log_level': logging.DEBUG}


