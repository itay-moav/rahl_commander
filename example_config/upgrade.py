'''
Created on Aug 3, 2017

@author: Itay Moav

config for the upgrade component


upgrade_tracking_database                 The database where you keep the table that tracks sql upgrade file statuses
upgrade_tracking_table'                   The table name where you keep the sql upgrade file statuses

test_host                                  A test database which should be a replica of the actual system. 
                                           You should run the upgrades there before running on real server

test_user                                  db user for the above test server

test_password                              db password for the above test server

force_test (True|False)                    Whether to force test run regardless of the cli switch provided
'''


upgrade = {   'upgrade_tracking_database': 'dhara',                 \
              'upgrade_tracking_table':    'sql_upgrades',          \
              'test_host':                 'localhost',             \
              'test_user':                 'root',                  \
              'test_password':             '',                      \
              'force_test':                True,                    \
              'force_schema_test':         True}