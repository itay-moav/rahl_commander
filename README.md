rhal_commander
==============

Rahl Commander, or rcom is a tool to manage DB objects

Rahl commander is meant to be used as a command line tool, 
although it has a simple web interface, mostly for debugging purposes and future support of REST
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Dependencies:
php 5.4 + pdo extenstion

Currenlty supports:
Mysql >= 5.1
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Installation+ setup on Windows (quick version)
1. Checkout/export the project where ever you want. Lets call the directory DIRECTORY

2. Modify DIRECTORY\rcom\config\environments\windows.json
         Modify the [database] section, pretty self explanatory.

3. The same process apply for triggers,stored procedures,functions,views and scripts
    3.1 Under  DIRECTORY\rcom\assets\sp    Create a new directory and name it exactly as the 
           DB you want to manage Stored Procedures for. RCOM can support many DBs.
           For example, if u call your DB "sales_db" Create DIRECTORY\rcom\assets\sp\sales_db\

    3.2  Under that new directory (created in 3.1) you can use what ever directory structure u want, OR NONE! 
        (i. e. work directly under the directory created in 3.1)

     3.3 Under the directory structure created in 3.2 create *.sql files with the stored procedures 
            code in them.


RUNNING IT

1. Find the path to your php bin. if it is xampp u use, then it will be C:\xampp\php\php
      wampp should be similar.
2. CD to DIRECTORY\com\bin
3. to see simple manual: 
                  C:\xampp\php\php main.php --comand build
                  C:\xampp\php\php main.php --comand list

4. Example of clean all DBs from triggers/stored procedures/functions/views
                  C:\xampp\php\php main.php --comand build --cleanall
5. Example of building all DBs triggers/stored procedures/functions/views
                  C:\xampp\php\php main.php --comand build --all


+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Installation+ setup on Linux (quick version) as a command line tool.

1. Checkout/export the project where ever you want. Lets call the directory DIRECTORY

2. Modify DIRECTORY/rcom/config/environments/windows.json (in more advanced tutorials, I'll show how to manage envs)
         Modify the [database] section, pretty self explanatory.

3. The same process apply for triggers,stored procedures,functions,views and scripts
    3.1 Under  DIRECTORY/rcom/assets/sp    Create a new directory and name it exactly as the 
           DB you want to manage Stored Procedures for. RCOM can support many DBs.
           For exampple, if u call your DB "sales_db" Create DIRECTORY/rcom/assets/sp/sales_db/

    3.2  Under that new directory (created in 3.1) you can use what ever directory structure u want, OR NONE! 
        (i. e. work directly under the directory created in 3.1)

     3.3 Under the directory structure created in 3.2 create *.sql files with the stored procedures 
            code in them.


RUNNING IT

1. CD to DIRECTORY/com/bin
2. to see simple manual type: 
                  ./build
                  ./list

4. Example of clean all DBs from triggers/stored procedures/functions/views
                  ./build --cleanall
5. Example of building all DBs triggers/stored procedures/functions/views
                  ./build --all


