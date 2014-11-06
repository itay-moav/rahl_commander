#!/usr/local/bin/python3.3
# encoding: utf-8
'''
@author:     Itay Moav

@copyright:  2014 organization_name. All rights reserved.

@license:    license

@contact:    user_email
@deffield    updated: Updated
'''

import sys
import os

sys.path.insert(0, os.path.abspath('..'))
import config
import lib.autocompletion

def main(argv=None): # IGNORE:C0111
    '''Command line options.'''

    if argv is None:
        argv = sys.argv
    else:
        sys.argv.extend(argv)

    try:
        # Setup argument parser
        parser = lib.ArgumentParser(description=config.program_license, formatter_class=lib.RawDescriptionHelpFormatter)
        parser.add_argument("--version",action="version",version=config.program_version_message)
        parser.add_argument("--all", dest="handle_all", action="store_true", help="Specifying this flag will generate SP auto completion for all databases")
        parser.add_argument("-d","--database", dest="database", action="store",nargs='?', default=False, const='All', help="Generate php auto complete file for stored procedures, or the folder/*.sql specified. Root folder is the database name.")

        Builder = lib.autocompletion.SP(parser)
        Builder.run()

    except KeyboardInterrupt:
        ### handle keyboard interrupt ###
        return 0

    except Exception as e:
        if config.DEBUG:
            raise(e)
        indent = len(config.program_name) * " "
        sys.stderr.write(config.program_name + ": " + repr(e) + "\n")
        sys.stderr.write(indent + "  for help use --help")
        return 2


if __name__ == "__main__":
    if len(sys.argv) == 1: # no params given, do --help
        sys.argv.append("-h")
    sys.exit(main())