rahl_commander
==============

Rahl Commander, or rcom is a tool to manage DB objects

Rahl commander is meant to be used as a command line tool
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Dependencies:
Python 3.3 + mysql.connector

Currenlty supports:
Mysql >= 5.1
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Installation+ setup on Windows (quick version)
1. Checkout/export the project where ever you want. Lets call the directory DIRECTORY

2. in the assets folder under each object type you wish to maintain, create a folder which is the same name as the
   as related db name. Under this folder you create your sql code, you can use as many subfolders as you want.

3. Available command (find them under the bin folder)
    3.1 build : builds the elements, use help to see options
    3.1 drop : drops the elements, use help to see options
    3.1 autocomp : builds an auto completion file for php

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Examples:
CD to bin

1. build all elements
   build.py --all

2. drop all elements
   drop.py --all

3. build all stored procedures
   build.py -s

4. drop all triggers in DB dhara
   drop -t -ddhara
