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


# Functions related to line done case
#	caseLineDone()
#	lineDoneCriteria()
#	lineDone()

function caseLineDone(){
	if(lineDoneCriteria())
		lineDone()
}
function lineDoneCriteria(){
	return $0==""&&line_count>0&&code_count>0
}

function lineDone(){
	buildLine()
	code_count=subject_info_count=lineOpened=0
	appendAndClear()
	line=line OFS academicDegree(credSum) OFS level OFS term
	print line
}

function appendAndClear(){
	for(lf in subject_info){
		line=line OFS subject_info[lf]
		delete subject_info[lf]
	}
}

function buildLine(){
	if(missingData()){
		completeSubjectData()
		credSum=credSum+subject_info[1]
	}else{
		line=line_count
		credSum=credSum+subject_info[2]
	}
}

function academicDegree(credSum){
	return credSum<=88? "dipl": "bsc"
}

function missingData(){
	return length(subject_info)<4
}
function completeSubjectData(){
	s=subject_info[0]
	gsub (" ", "",s)
	line=line_count OFS s
}


