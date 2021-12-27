'''
Created on Jan 15, 2015

@author: Itay Moav

Add lists with common languages, eventually, can be used for
multiple language support.
'''
help = {'verbosity':        'By default, not specifying this will echo only the fatal errors. Specifying it -v to -vvvv will Show more',  \
        'server_connection':'optional way to specifiy sql connection username:password@server.ip.or.domain',                  \
        'assets_path':      'optional way to specify the assets full absolute path,starting from / (root folder)',            \
        'handle_all':       'Specifying this flag will apply command to the entire assets folder',                            \
        'system_profile':   'A predefined profile with data source connection strings, asset path and other params'}