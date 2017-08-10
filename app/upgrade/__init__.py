'''
Created on Aug 03, 2017

@author: Itay Moav
'''
__version__ = '1.0'

from app import logging as L
from collections import deque
from config.upgrade import upgrade as upgrade_config
import app.upgrade.commands as Command

def run(args):
    '''
    extract the args and populate with efaults where relevant
    and decide what to run
    This one seems to be procedural in nature hmmmmm 
    '''
    L.debug('INPUT')
    L.debug(args)
    L.debug(upgrade_config.__repr__())
    
    commands = deque([])
    
    #--unblock     -> blocking action, will exit 
    commands.appendleft(Command.Unblock(args.file_name_to_unblock))
    
    #--test
    commands.appendleft(Command.Test(args.test_upgrade,args.handle_all,args.limit_files))
    
    #--with_schema
    commands.appendleft(Command.TestServerSchema(args.with_schema_checker,args.test_upgrade,args))
    
    #--limit=X   ||   --all
    commands.appendleft(Command.Upgrade(args.handle_all,args.limit_files))
    
    #--archive
    commands.appendleft(Command.Archive(args.archive_files))
    
    run_commands(commands)
    





def run_commands(commands):
    '''
    actually running the commands
    '''
    should_i_stop = False
    while commands:
        command = commands.pop()
        should_i_stop = command.action(should_i_stop)