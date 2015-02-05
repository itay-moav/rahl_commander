RAHL COMMANDER for SQL
======================

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
<li>Provide a simple cleanup tool of the code. You write a nice Stored Procedure. All indented and commented. But, when u copy it and try to run it through the command line, it craps out. All due to white space characters in the wrong place.  RCom will generate a clean version for you to copy paste into the command line.</li>
</ol>

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Naming Conventions 
<ul>
<li> <b>APPDIR</b> is where you checked out <b>Rahl Commander</b>.</li>
<li> <b>ASSETS</b> is the <code>assets</code> folder, right under <b>APPDIR</b>.</li>  
<li> <b>BIN</b> is the <code>bin</code> folder right under <b>APPDIR</b></li>
<li> <b>CONFIG</b> is <b>APPDIR</b><code>/config/__init__.py</code></li>
<li> <b>IGNOREDIR</b> is <b>APPDIR</b><code>/config/ignore_list.py</code></li>
</ul>

## Installation
(I assume you have Python and the necessary mysql connector).  
Currently supporting only manual (very simple) installation.  

<ol>
<li>Checkout/export the project where ever you want. This folder becomes <b>APPDIR</b>.</li>
<li>Check your <b>ASSETS</b> folder has the following subfolders: <code>autocompletion, functions, scripts, sp, triggers, views</code></li>
<li>Open <b>CONFIG</b> and make sure the DB credentials are correct</li>
<li>If not existing, create DB folders. For example, if u have a database named <b>proddb</b> and it has stored procedures and triggers, go to <code><b>ASSETS</b>/sp</code> and create folder <code><b>proddb</b></code>. Then go to folder <code><b>ASSETS</b>/triggers</code> and create folder <code><b>proddb</b></code>.  
So you end with <code><b>ASSETS</b>/sp/proddb</code> and <code><b>ASSETS</b>/sp/triggers</code>.  
(Check the <b>examle_assets</b> structure, which is setup for DBs <b>dhara</b> and <b>dhara_views</b>).
</li>
<li>Run the <code>test.py</code> under the <b>BIN</b> to see all is good.</li>
</ol>
<b>You Are Done!</b>

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
