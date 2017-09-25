import sys
import os
import logging
from config.ignore_list import ignore_files_dirs_with
from config.common_language import help_common_language
from config.autocomplete import autocomplete


DEBUG = True #you can leave this as is, it is mostly for developers of this module


# Mysql config
mysql = {'host':'localhost','username':'root','password':''}

# Assets CHANGE HERE if u want the assets folder to be somewhere else
# Here you can put absolute values (a full string) 
# or a use python function, like in this example.
assets_folder = os.path.abspath('../example_assets')

# Logger setup values. 
logman = {'default_log_level': logging.DEBUG}


