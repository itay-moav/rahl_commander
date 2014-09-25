# Reads the Omega Supreme stored procedures
# and translates them  to an eclipse standard lib
# document/phpdoc file

import sys
import os
import fnmatch
import sp_data



PATH = '\\'
matches = []
for root, dirnames, filenames in os.walk('app_db'):
	for filename in fnmatch.filter(filenames, '*.sql'):
		#print("root [{}]  dirname [{}] file [{}]\n\n".format(root,dirnames,filename))
		matches.append(root + PATH + filename)
	 
# print("Parsing the following files" + "\n".join(matches))

# open the doc file
doc_file = open("docfile.php","w")
doc_file.write("""

	class SP{
		/**
		 * @return SP
		 */
		static function call(){
			return new self;
		}
""")
to_break = False #for debug purposes, to later break after a specific SP

for fn in matches:
	# print(fn)
	
	
	sp_file = open(fn,'r')
	
	looking_for_header		= True
	looking_for_header_args = False
	looking_for_body   		= False
	not_yet_started_args	= True #once I start looking into the args string, I no longer start from (, as it can be the ( in INT(11)
	SP						= sp_data.SpData(fn)
	
	for line in sp_file:
		if looking_for_body:
			SP.addBodyLine(line)
	
		if looking_for_header:
			# method name
			if "CREATE PROCEDURE" in line and len(line)>(len("CREATE PROCEDURE")+8):
				start_funcname = line.find("CREATE PROCEDURE")
				end_funcname_location = line.find('(')
				SP.addSPName(line[start_funcname+len("CREATE PROCEDURE")+1:end_funcname_location])
				# TODO move this into the addSPName : function_header = "\tpublic function %s("%func_name.replace('`','').strip()
				looking_for_header = False
				looking_for_header_args = True
				
		# method arguments
		if looking_for_header_args:
			if not_yet_started_args:
				start_args	= line.find('(')
				not_yet_started_args = False
				
			else:
				start_args  = 0
			end_args	= line.find('BEGIN')
			
			if(end_args > -1): # Means we got to the end of the args section
				looking_for_header_args = False
				looking_for_body = True
			
			SP.addRawArgStr(line[start_args+1:])
			# clean_args += '$' + argstr.replace('IN ','').replace('OUT ','').replace(',',', $').replace('$ ','$')
	
	

	#print phpdoc
	doc_file.write(str(SP))
	
	#print the function header
	# doc_file.write(function_header)
	
	#print the function argument part
	# doc_file.write(clean_args)
			
			
	#print(SP.sp_name)
	#print(SP.raw_args)
			
			
		
	sp_file.close()
	if to_break:
		break
	
	# for debug, enter SP file name + path u want to break one SP after...
	#if fn == 'app_db\Course\Wizard\scheduler_dates.sql':
	#	to_break = True
		
# doc_file.write("\n\n}\n")
# doc_file.close()


input('\n\rEnter your input:')