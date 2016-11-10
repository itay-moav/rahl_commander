'''
Main calls the Looper once to loop on all rchk and then another looper to loop on all schk
Looper loops on all the files.
For each file it will create a TableList.
For each line in the file it will call the RuleParser
RuleParser will return an object including the SQL that needs to run to validate the rule
TableList will take in the rule object and attach it to a specific tables, or all tables
   
At end of file processing, Main will call a looper on the TableList and run the rules, generate a report (Render Object-> stdio,email,file)
'''
from app.schemachk.looper import ParseLooper
import app.schemachk.reporting
from app import logging as L

def run(parser):
    # MATCH DB RULES
    AllErrors=[]
    SchemCheker = ParseLooper(parser,file_postfix=".rchk")
    SchemCheker.run()
    for TableList in SchemCheker.getTableLists():
        for table_name in TableList.getTables().keys():
            AllErrors.append(app.schemachk.reporting.run_tests(table_name,TableList.getTables()[table_name]))
    app.schemachk.reporting.generate_report(AllErrors) #Right now, output to stdio, later from config

    # SINGLE DB RULES     
    AllErrors=[]
    SchemCheker = ParseLooper(parser,file_postfix=".schk")
    SchemCheker.run()
    for TableList in SchemCheker.getTableLists():
        for table_name in TableList.getTables().keys():
            AllErrors.append(app.schemachk.reporting.run_tests(table_name,TableList.getTables()[table_name]))
    app.schemachk.reporting.generate_report(AllErrors) #Right now, output to stdio, later from config
        