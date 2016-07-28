'''
Reporting classes
Will run the rules and generate a report
'''

def run_tests(table_name,table_rules):
    if len(table_rules) == 0:
        return
    
    print("Checking table {table_name}".format(table_name=table_name))
    for rule in table_rules:
        table_name = rule.test_rule(table_name)
            