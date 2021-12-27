'''
Created on Jan 5, 2016

@author: Itay Moav

config for the autocompletion component
Right now we support only PHP + Eclipse
so all is implicitly for this combo.

1. [return] Return type from stored procedure (will translate in the PHPDoc commnets to @return [Return_Type]
2. [db_name_separator]  When the auto completer will created the stored procedure pseudo php code, it will name the methods db_name[db_name_separator]stored_procedue_name
'''


autocomplete = {   'language':          'php',      \
                   'return':            '\SP',      \
                   'db_name_separator': '__'        \
                   }    \

