'''
Created on Jun 9, 2016

@author: Itay Moav

Functionality to get meta data on the assests.
For example: 
    Which databases each section (SP/Triggers/Functions/Views) tracks.
'''
import os
import config

TRIGGERS          = 'triggers'
FUNCTIONS         = 'functions'
STORED_PROCEDURES = 'sp'
VIEWS             = 'views'

class TrackedDBs():
    '''
    Reads the object type and returns the list of DBs maintained under this object type
    Object type: View, Trigger, Stored Procedure, Function
    '''

    PATH = '\\'

    def __init__(self, object_type,assets_path=False):
        '''
        TODO there is no error handling here on what is sent, so I better call it right
        '''
        if assets_path:
            object_path = assets_path + '/' + object_type
        else:
            object_path = config.assets_folder + '/' + object_type

        print("Meta for folder [{}]".format(object_path))
        self.folders = [db_name for db_name in os.listdir(object_path) if '.' not in db_name]
        