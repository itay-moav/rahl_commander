'''
Created on Jun 9, 2016

@author: Itay Moav

Functionality to get meta data on the assests.
For example: 
    Which databases each section (SP/Triggers/Functions/Views) tracks.
'''
import os
import config
from app import logging as L

TRIGGERS          = 'triggers'
FUNCTIONS         = 'functions'
STORED_PROCEDURES = 'sp'
VIEWS             = 'views'
SCHEMA            = 'schema'
SCRIPTS           = 'scripts'
AUTOCOMPLETION    = 'autocompletion'

def tracked_dbs(object_type,assets_path=False):
    '''
    Reads the object type and returns the list of DBs maintained under this object type
    Object type: View, Trigger, Stored Procedure, Function
    '''
    if assets_path:
        object_path = assets_path + '/' + object_type
    else:
        object_path = config.assets_folder + '/' + object_type

    L.debug("Meta for folder [{}]".format(object_path))
    return [right_side_db for right_side_db in os.listdir(object_path) if '.' not in right_side_db] #TODO see if I need to add here the ignore list


def extract_from_folder(sub_folder,index):
    '''
    get the folder part the folder input
    '''
    return sub_folder.split(config.assets_folder)[1].replace('\\','/').split('/')[index]


def extract_db_name(sub_folder):
    '''
    get the database name from the folder input
    '''
    try:
        return extract_from_folder(sub_folder,2)
    except IndexError:
        return ''
    

