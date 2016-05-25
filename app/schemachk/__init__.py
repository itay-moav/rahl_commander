'''
Main calls the Looper once to loop on all rchk and then another looper to loop on all schk
Looper loops on all the files.
For each file it will create a TableList.
For each line in the file it will call the tokenMaster
TokenMaster will tokenize (an object) Validate (an object) 
   Populate TableList with affected tables, and Translate tokens to rules (object)
   
At end of file processing, Main will call a looper on the TableList and run the rules, generate a report (Render Object-> stdio,email,file)
'''
from app.schemachk.looper import Looper
def run(parser):
    SchemCheker = Looper(parser,file_postfix=".rchk")
    SchemCheker.run()
     
    SchemCheker = Looper(parser,file_postfix=".schk")
    SchemCheker.run()
    