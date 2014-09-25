# Class to hold one sp data in the right place
# sp name
# sp params
# sp code
class SpData:
	"""Get a hold of the raw data of the class, parse it and provide methods to extract the data in PHP mode TODO later to have language 
	translation as a plug-in"""
	file_name	= ''
	sp_name		= ''
	raw_args	= ''
	body		= ''
	ArgList		= []
	
	def __init__(self,file_name):
		self.file_name = file_name
		
	def addSPName(self,sp_name):
		"""Get the stored procedure name and performes all needed cleanup on the string to be a legal php func name"""
		self.sp_name = sp_name.replace('`','')
	
	def addRawArgStr(self,arg_str):
		"""Add the raw param string pieces, cleanup will be done later, as this might span multiple lines"""
		self.raw_args += arg_str
		
	def addBodyLine(self,line):
		"""Adds the body, no real clean-up is needed here (maybe remove the END at the end"""
		self.body += line
		
	def _paramsComments(self):
		params = ''
		
		return params
	
	def comments(self):
		"""formats the comment secion of the function, phpdoc wize"""
		comments = "\t   /**\n"
		comments += "\t\t* " + self.sp_name + "\n"
		comments += "\t\t* File: " + self.file_name + "\n\t\t*\n"
		comments += self._paramsComments()
		for Arg in self.ArgList:
			comments += "\t\t* @param " + Arg.php_data_type + " $" + Arg.name + "  :" + ' '.join([Arg.type,Arg.name,Arg.data_type]) + "\n"
		
		comments += "\t\t*/\n"
		return comments
		
	def prepareArgs(self):
		"""splits the arg string into specific arguments. Each arg is an Object, special care needs to be given to ENUM types here..."""
		in_enum = False
		pack_enum = ''
		for arg in self.raw_args.split(','):
			if arg.find('ENUM') > -1:
				in_enum = True
				
			if in_enum:
				pack_enum += arg
			else:
				try:
					ArgObj = SpArguments(arg)
				except ArgError:
					continue
					
				self.ArgList.append(ArgObj)
				
			if in_enum and arg.find(')') > -1:
				self.ArgList.append(SpArguments(pack_enum))
				pack_enum = ''
				in_enum = False
		
	def getArgsAsPHP(self):
		"""The function header in PHP, the arguments part"""
		return "(" + ','.join(["$" + Arg.name for Arg in self.ArgList]) + ")"
	
	def __str__(self):
		"""run al the cleanups and formatting, returns the methid as PHP code"""
		self.prepareArgs()
		return "\n\n" + self.comments() + "\t\tpublic function " + self.sp_name + self.getArgsAsPHP() + "{\n\t\t\t/*\n" + self.body.replace('END','') + "\n\t\t\t*/\n\t\t}\n"
		
		
class ArgError(Exception):
	pass
		
class SpArguments:
	"""Represents one argument, has arg name, type, in or out"""
	type		= '' # either IN or OUT
	data_type	= '' # varchar, int, boolean etc
	name		= '' # arg name
	php_data_type = '' 
	
	def __init__(self,raw_arg):
		self.type,self.data_type,self.php_data_type,self.name = self.parse(raw_arg)
		
	def parse(self,raw_arg):
		type = ''
		data_type = ''
		name = ''
		
		loc1 = raw_arg.find('IN ')
		loc2 = raw_arg.find('OUT ')
		
		if loc1 > -1:
			type = 'IN'
			
		elif loc2 > -1:
			type = 'OUT'
		
		else: # this is not a legal argument
			raise ArgError()
		
		raw_arg = raw_arg.split(type + ' ')[1].split(' ')
		name = raw_arg[0]
		temp_type = ''.join(raw_arg[1:]).replace("\n",'')
		
		loc3 = temp_type.find('))')
		loc4 = temp_type.find(')')
		if(loc3>-1):
			data_type = temp_type[:loc3+1]
		elif(loc4>-1):
			if(temp_type.find('(') > -1):
				loc4 += 1
			
			data_type = temp_type[:loc4]
		else:
			data_type = temp_type
	
		if(data_type.upper().find('INT') > -1):
			php_data_type = 'integer'
		elif(data_type.upper().find('ENUM') > -1):
			php_data_type = 'integer'
		elif(data_type.upper().find('CHAR') > -1):
			php_data_type = 'string'
		elif(data_type.upper().find('TEXT') > -1):
			php_data_type = 'string'
		elif(data_type.upper().find('TIME') > -1):
			php_data_type = 'string'
		elif(data_type.upper().find('DATE') > -1):
			php_data_type = 'string'
		else:
			php_data_type = 'baba'
			
		return [type,data_type,php_data_type,name]
		