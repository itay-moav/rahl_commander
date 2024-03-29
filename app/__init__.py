import sys
import os
__version__ = 1.1
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
from app import config as config

if len(sys.argv) == 1: # no params given, do --help
    sys.argv.append("-h")
    
parser = ArgumentParser(description=program_license, formatter_class=RawDescriptionHelpFormatter)
parser.add_argument("-v", dest="verbosity", action="store",nargs='?', default=False, help=config.language['help']['verbosity'])
parser.add_argument("--version",action="version",version=program_version_message)
parser.add_argument("--all", dest="handle_all", action="store_true", help=config.language['help']['handle_all'])
parser.add_argument("--profile", dest="system_profile", action="store", nargs='?', default=False,help=config.language['help']['system_profile'])

def init(parser):
    '''
        populate the config object with proper value
        Order of precedence is 
        - user input
        - profile 
    '''
    args = parser.parse_args()

    #loggin
    config.set_logging(args.verbosity)
    
    # go by profile first
    if args.system_profile:
        config.read_profile(args.system_profile)
    else:
        config.read_profile('DEFAULT')
   
    # FIN
    return args
        