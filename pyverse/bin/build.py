#!/usr/local/bin/python3.3
# encoding: utf-8
'''
pyverse.bin.build -- shortdesc

pyverse.bin.build is a description

It defines classes_and_methods

@author:     Itay Moav

@copyright:  2014 organization_name. All rights reserved.

@license:    license

@contact:    user_email
@deffield    updated: Updated
'''

import sys
import os
import commands

from argparse import ArgumentParser
from argparse import RawDescriptionHelpFormatter

__all__ = []
__version__ = 0.1
__date__ = '2014-09-25'
__updated__ = '2014-09-25'

def main(argv=None): # IGNORE:C0111
    '''Command line options.'''

    if argv is None:
        argv = sys.argv
    else:
        sys.argv.extend(argv)

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

    try:
        # Setup argument parser
        parser = ArgumentParser(description=program_license, formatter_class=RawDescriptionHelpFormatter)

        parser.add_argument("--version",action="version",version=program_version_message)

        parser.add_argument("--all", dest="handle_all", action="store_true", help="Specifying this flag will rebuild the entire project")
        parser.add_argument("-s","--stored_proc", dest="stored_proc", action="store",nargs='?', default=False, const='All', help="build all stored procedures, or the folder/*.sql specified. Root folder is the database name.")
        parser.add_argument("-w","--views", dest="views", action="store",nargs='?', default=False, const='All', help="build all views, or the folder/*.sql specified. Root folder is the database name.")
        parser.add_argument("-t","--triggers", dest="triggers", action="store",nargs='?',  default=False, const='All', help="build all triggers, or the folder/*.sql specified. Root folder is the database name.")
        parser.add_argument("-f","--functions", dest="functions", action="store",nargs='?',  default=False, const='All', help="build all functions, or the folder/*.sql specified. Root folder is the database name.")
        parser.add_argument("-c","--scripts", dest="scripts", action="store",nargs='?', default=False, const='All', help="run all scripts, or the folder/*.sql specified. Root folder is the database name.")

        Builder = commands.BuildDBObj(parser)
        Builder.run()

    except KeyboardInterrupt:
        ### handle keyboard interrupt ###
        return 0

    except Exception as e:
        if DEBUG or TESTRUN:
            raise(e)
        indent = len(program_name) * " "
        sys.stderr.write(program_name + ": " + repr(e) + "\n")
        sys.stderr.write(indent + "  for help use --help")
        return 2



if __name__ == "__main__":
    if len(sys.argv) == 1: # no params given, do --help
        sys.argv.append("-h")
    sys.exit(main())