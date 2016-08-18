'''
Reporting classes
Will run the rules and generate a report
'''

def run_tests(table_name,table_rules):
    if len(table_rules) == 0:
        return
    
    print("Checking rules for table [{table_name}]".format(table_name=table_name))
    for rule in table_rules:
        table_name = rule.test_rule(table_name) # Do notice, a rule might change the table name, like prefix[baba_] will add baba_ to the right side
                                                # table name for the rest of the rules.
                                                # same with postfix[_gaga] which would add _gaga to the end of the right side table name.
                                                # Both rules can appear in any combination (both, or just one, in any order, in the BEGINNING)
            