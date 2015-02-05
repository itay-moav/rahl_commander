rahl_commander
==============

A command line tool to simplify the managment of DB objects and scripts in your project.

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Dependencies 
1. Python >= 3.3
2. Python mysql.connector
3. Mysql >= 5.1

## Currently supports objects for
1. Mysql

## Currently supports auto completion for
1. PHP + Eclipse

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Description

Many projects requires the usage of Stored Procedurs, Triggers, SQL Functions, Views
and various scripts.  
Rahl Commander (RCom)provides facilities and structure to manage all those pieces of code
used in your project, but are not part of the main code base.  

RCom will do the following for you:  
<ol>
<li>Build for you all or some of the objects into the DB of your choice.</li>
<li>Will generate auto completion files for your IDE (how nice it is to get auto completion for a stored procedure in your PHP, heh?).</li>
<li>Will give easy cleanup of the DB of all or some objects (Great for use in release scritps).</li>
<li>Provide a simple cleanup tool of the code. You write a nice Stored Procedure, all indented and commented, but when u copy it and try to run it threough the command line, it craps out, due to white space characters in the wrong place. RCom will generate a clean version for you to copy paste.</li>
</ol>

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Installation
(I assume you have Python and the necessary mysql connector).

1. Checkout/export the project where ever you want. Lets call the directory DIRECTORY

2. in the assets folder under each object type you wish to maintain, create a folder which is the same name as the
   as related db name. Under this folder you create your sql code, you can use as many subfolders as you want.

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
