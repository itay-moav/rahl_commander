Mysql schema cheking rules 
==============================

RCOM gives us the ability to validate certain schema rules on your DB via the `schem` command (u can do schem -h for doc on the command line).
 
Example:
A database who has a user_profile table, where each user has only one entry.  
There is also a delta database, that keeps an audit of the data changes in user_profiles.
Copy current record from main db, as is, into the delta db, and then modifies the main db user_profiles table.
Or, an archive database, where, instead of deleting records, you "move" them to a copy of the table in the archive database, where they wont 
clutter the main db.

In all of those cases, the main db tables and the delta or archive db tables must match in all or most field names and datatypes.  
This can be very tedious to maintain manually. 

This is where this module come in place, you need just to build the right rules into it, and then run it.  
The output can be anything between alerts to missmatches or even create the SQL change statment to fix the missmatch.

Tutorial
==============================
Directory structure and file names:
Each database will have a directory in the assets folder, under the schema folder.  
If there are no rules for the DB, no need to create that folder.  
The system will itterate on a folder and it's contents, So u can either separate each table rules to a separate file, in which case, the file name must be tablename.rchk (Rahl Check Format)
Or one file for the entire DB, in which case, the file has to be named rahl_main.rchk  
You can have subfolders for easier organization of rule files, you can have more than one file per table, you can have several main.chkr files (obviously, not under the same folder).
You can have both main.chkr + tablename.tblchkr files
Any combination of the above


File structure in main.chkr
[table in current database]::[target database, can be same database]:[target table name]::[rul1]:[rule2]...[rulen]
If u ommit the target databse, system will assume current database.
If u ommit the target table name, System will assume same name
DO TRY NOT to syncompare a table to itself

[rule] has the following structure: 
* for table level or field name<>rule

Example:
(Under the folder dhara)
first_file_profile::dhara_delta:dhara_first_file_profile::sameall:nodefaults    --- This will compare table first_file_profile in database dhara to table dhara_first_file_profile in database dhara_delta.  
                                                                                --- It will enforce both tables to be exactly the same, with the exception of there should be no default values in target
                                                                                --- table (dhara_delta.dhara_first_file_profile)


File structure in tablename.tblchkr



Simple table matching: All fields must have the same name, the same order, the same datatype, same default vbalues. Both schema must be 100% same

Table matching, no default values in one table: Schema of both tables must match with the exception of one table should not have any default values for any of it's fields
                                                This is important for audit tables, where you do not want some default values populating by accident which did not come from parent
                                                table.

                                              
Table matching, no indexes or constraints on one table: A unique key which would make sense on a main table, will not work on an audit table,where there are many copies of the same record.


Table matching, exclude some fields from the comparison: In an audit table, we might want to add an explanation field, to note the reason why this record was changed.
                                                         No need for that field to be in the main table, so we need to exclude this field from the comparison
                                                         
                                                         
Table matching, tables have different names.


Table matching, Tables are in same database.


Table matching, Tables are in different database.


