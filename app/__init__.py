import sys
import os

__version__ = 1.0
__date__ = '2014-09-24'
__updated__ = '2017-05-17'
program_name = os.path.basename(sys.argv[0])
program_version = "v%s" % __version__
program_build_date = str(__updated__)
program_version_message = '%%(prog)s %s (%s)' % (program_version, program_build_date)
program_shortdesc = __import__('__main__').__doc__.split("\n")[1]
program_license = '''%s

  Created by Itay Moav on %s.
  Copyright 2014 organization_name. All rights reserved.

  Licensed under the Apache License 2.0
  http://www.apache.org/licenses/LICENSE-2.0

  Distributed on an "AS IS" basis without warranties
  or conditions of any kind, either express or implied.

USAGE
''' % (program_shortdesc, str(__date__))





from argparse import ArgumentParser
from argparse import RawDescriptionHelpFormatter
import logging
sys.path.insert(0, os.path.dirname(os.path.realpath(__file__)) + '/..')
import config

if len(sys.argv) == 1: # no params given, do --help
    sys.argv.append("-h")
    
parser = ArgumentParser(description=program_license, formatter_class=RawDescriptionHelpFormatter)
parser.add_argument("-v", dest="verbosity", action="store",nargs='?', default=False, \
                                 help="By default, not specifying this will echo only the fatal errors. Specifying it -v to -vvvv will Show more.")
parser.add_argument("--version",action="version",version=program_version_message)
parser.add_argument("--all", dest="handle_all", action="store_true", help="Specifying this flag will apply command to the entire project")
parser.add_argument("-a", "--assets", dest="assets_path", action="store", nargs='?',help="optional way to specify the assets full path (starting from /)")
parser.add_argument("--server", dest="server_connection", action="store", nargs='?', default=False,help=config.help_common_language['server_connection'])

def init(parser):
    '''
        Take out config override.
        populate the config object with proper value
    '''
    args = parser.parse_args()
    
    # assets path
    if args.assets_path:
        config.assets_folder = args.assets_path
        
    # server connection
    if args.server_connection:
        creds = args.server_connection.replace(':','@').split('@')
        config.mysql['username'] = creds[0]
        config.mysql['password'] = creds[1]
        config.mysql['host']     = creds[2]

    #loggin
    set_logging(args.verbosity)
    
    # FIN
    return args
    
def set_logging(verbosity):
    #setup the logger
    log_verbosity_tmp = verbosity
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
