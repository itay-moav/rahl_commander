from argparse import ArgumentParser
from argparse import RawDescriptionHelpFormatter
import sys
import os
import logging
sys.path.insert(0, os.path.dirname(os.path.realpath(__file__)) + '/..')
import config

if len(sys.argv) == 1: # no params given, do --help
    sys.argv.append("-h")
    
parser = ArgumentParser(description=config.program_license, formatter_class=RawDescriptionHelpFormatter)
parser.add_argument("-v", dest="verbosity", action="store",nargs='?', default=False, \
                                 help="By default, not specifying this will echo only the fatal errors. Specifying it -v to -vvvv will Show more.")
parser.add_argument("--version",action="version",version=config.program_version_message)
parser.add_argument("--all", dest="handle_all", action="store_true", help="Specifying this flag will apply command to the entire project")
parser.add_argument("-a", "--assets", dest="assets_path", action="store", nargs='?',help="optional way to specify the assets full path (starting from /)")
parser.add_argument("--server", dest="server_connection", action="store", nargs='?', default=False,help=config.help_common_language['server_connection'])
args = parser.parse_args()
#setup the logger
log_verbosity_tmp = args.verbosity
log_verbosity     = logging.FATAL
if(log_verbosity_tmp is None):
    log_verbosity = logging.ERROR
elif(log_verbosity_tmp == 'v'):
    log_verbosity = logging.WARNING
elif(log_verbosity_tmp == 'vv'):
    log_verbosity = logging.INFO
elif(log_verbosity_tmp == 'vvv'):
    log_verbosity = logging.DEBUG
else:
    try:
        if(config.logman['default_log_level']):
            log_verbosity = config.logman['default_log_level']
    except Exception:
        pass #do nothing, use the default fatal level
    
logging.basicConfig(level=log_verbosity)
