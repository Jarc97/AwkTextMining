# Authors
#	Jose Javier Arce Zeledon
#	Julio Rodriguez Chavarria
#	Kevin Venegas Loria
#	Aaron Villalobos Arguedas

function handleCarriageReturn(){
	$0=substr($0, 1, length($0)-1)
}
function sharedLineFields(){
	assignLevelAndTerm()	
}
function assignLevelAndTerm(){
	if($2~/Nivel/)
		level=$1
	if($2~/Ciclo/)
		term=$1;
	if($1~/OPTATIVOS/)
		level=term="_"
}

# Functions related to new line case
#	caseNewLine()
#	newLineCriteria(validCode,firstCount)
#	newLine()

function caseNewLine(){
	if(newLineCriteria(isValidCode(),isSubjectCode()))
		newLine()
}
function newLineCriteria(validCode,firstCount){
	return validCode&&firstCount
}
function newLine(){
	code_count+=1
	line_count+=1
	lineOpened=1
}
function isValidCode(){
	isRegularCode=$0~/^[A-Z]{3}\s?-?([X]{3}|[0-9]{3}\s?O?)$/
	isEgCode=$0~/^Estudios Generales/
	isOptCode=$0~/^Optativa/
	return isRegularCode||isEgCode||isOptCode
}
function isSubjectCode(){
	return code_count==0
}

# Functions related to line field case
#	caseLineField()
#	lineFieldCriteria()
#	collectLineField()

function caseLineField(){
	if(lineFieldCriteria())
		collectLineField()
}
function lineFieldCriteria(){
	return lineOpened==1 && !lineDoneCriteria()
}
function collectLineField(){
	subject_info[subject_info_count]=$0
	subject_info_count+=1
}

