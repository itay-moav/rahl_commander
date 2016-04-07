import sys
import os
from config.ignore_list import ignore_files_dirs_with
from config.common_language import help_common_language
from config.autocomplete import autocomplete


__all__ = []
__version__ = 1.0
__date__ = '2014-09-24'
__updated__ = '2015-03-17'
DEBUG = True

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

# Mysql config
mysql = {'host':'localhost','username':'root','password':''} # '123456!!'

# Assets CHANGE HERE if u want the assets folder to be somewhere else
assets_folder = '../example_assets'
