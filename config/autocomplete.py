'''
Created on Jan 5, 2016

@author: Itay Moav

config for the autocompletion component
Right now we support only PHP + Eclipse
so all is implicitly for this combo.

1. Return type from stored procedure (will translate in the PHPDoc commnets to @return [Return_Type]
2. Location of the Eclipse installation (by which way it will know where to put the SP.php file created. If it can't write to this directory,
   it will write it to the assests folder under the autocompletion folder / php /eclipse
'''

autocomplete = {   'language':         'php',      \
                   'editor':           'eclipse',  \
                   'editor_workspace': '/home/admin/dev',    \
                   'return':           'Data_MySQL_DB',    \
                                                              \
                   'eclipse':          {     \
                       'plugin_dir':  '.metadata/.plugins/org.eclipse.php.core/__language__'    \
                   }    \
}


