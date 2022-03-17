import sys
import os
import logging
from .ignore_list import ignore_files_dirs_with
from .autocomplete import autocomplete
DEBUG = True #you can leave this as is, it is mostly for developers of this module

# Logger setup values. 
logman = {'default_log_level': logging.DEBUG}
