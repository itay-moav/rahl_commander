UPGRADES folder hosts your (for now, only mysql) upgrade schema scripts.  
It will also run data manipulation, not just schema manipulation code.  
The system relies on the existance of a table with three fields in it (structure below).  
The table captures which changes where run already and when, and if the code was fully appplied or failed in the middle.  
You need to configure in the config/upgrades.py the name of the table and the database name it resides in.

The files are lexically ordered by their names.
So, the following files will be run in this ascending order

0_do_some_stuff.sql
1_oops.sql
11_another_oops.sql
2a_lala.sql


Each file name is recorded in the DB and is being run.  
Before a file starts running it is marked in the DB as ready to run.
If it finished running with no errors, it is marked change complete, if it failes it is marked failed upgrades.  
Currently, once there is a failed upgrade, system will be prevented from continuing running.  
U will need to fix the wrong file and clean the DB of the failed ticket.  

**NOTICE!**
This means u must test the upgrades first on a staging environment **NEVER run** them first on production
  
  
There are two subfolders current and archive.  
[archive] is a simply a folder to store previous changes, u can keep them, or delete them over time, or store them wherever you want.  
[current] is the working folder, this is where the system will look for files not ran yet.  
**NOTICE!** if a file in [current] was executed, it will not be executed again, even though it is in the [current] folder.

**upgrade** provides the following utilities:

--limit=X [x is the number of files to run in one go]
--archive [will remove to the archive folder ALL files in [current] folder that where successfully ran].
--all [upgrade all files previously not executed]
--unblock [removes a none completed entry from the DB, BE VERY CAREFULL WHAT U DO HERE, make sure u also undo any changes in the DB that where caused by the script  
           if it was partially run. It takes the file name (no postfix) as an argument]
--force_test [runs the queries on a test database defined in the config, and return on the first error,
              NOTICE! To run just tests, do not use the --all or --limit args with this flag]

You can run the following combinations too:  
--limit=X --archive [will archive the X files]
--all --archive     [will run and archive all]

--limit=X --test [runs test first on X files in the test db, and then run on the actual db]
--all --test     [runs test first on all files in the test db, and then run on the actual db]

--limit=X --test --archive
--all --test --archive


CONFIGURATION
=============
file: config/upgrade.py  
  
values:  
database:          'data base u will build this table in YOU MUST MODIFY THIS'
table:             'table name u wish to give it, default will be sql_upgrades'
test_host:         'host/db server to run tests on before running on actual db'
test_user:         'username for the test server'
test_password:     'password for test server'
force_test         True|False true will force the test run regardless of the switches provided in the CLI



DATABASE TABLE STRUCTURE
========================
CREATE TABLE IF NOT EXISTS sql_upgrades (
  time_runned timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  file_name varchar(255) CHARACTER SET utf8 NOT NULL,
  execution_status enum('pending_completion','failed','completed') CHARACTER SET utf8 NOT NULL DEFAULT 'pending_completion',
  error_message varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (time_runned,file_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;