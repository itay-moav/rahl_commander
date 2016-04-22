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







- COMMENTS: Line that starts with a # is a comment and will be ignored by the parser.





?????????????????????????
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


