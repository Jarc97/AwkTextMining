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
	if(newLineCriteria(isValidCode($0),isSubjectCode()))
		newLine()
}
function newLineCriteria(validCode,firstCount){
	return validCode&&firstCount
}
function newLine(){
	if($0~/^Optativa/)
		optCount+=1
	code_count+=1
	line_count+=1
	lineOpened=1
}
function isValidCode(_code){
	isRegularCode=_code~/^[A-Z]{3}\s?-?([X]{3}|[0-9]{3}\s?O?)$/
	isEgCode=_code~/^Estudios Generales/
	isOptCode=_code~/^Optativa/
	return isRegularCode||isEgCode||isOptCode
}
function isFixableCode(_code){
return _code~/[A-Z]{3}\s?-?([X]{3}|[0-9]{3}\s?O?)/
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
	if(subject_info_count==2 &&level=="_"){
		subject_info[2]="3"
		subject_info_count+=1
	}
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
	appendSubjectInfo()
	clearSubjectInfo()
	line=line OFS academicDegree(credSum) OFS level OFS term
	print line
}
function buildLine(){
	if(level=="_"){
		s=subject_info[0]
		gsub (" ", "",s)
		subject_info[0]=s
	}
	if(missingData()&&level!="_"){
		completeSubjectData()
		credSum=credSum+subject_info[1]
	}else{
		line=line_count
		credSum=credSum+subject_info[2]
	}
}

function appendSubjectInfo(){
	for(lf in subject_info){
		setAdmissionRequirements()
		checkCodeForm()
		line=line OFS subject_info[lf]
	}	
}
function clearSubjectInfo(){
	for(lf in subject_info)
		delete subject_info[lf]
}
function checkCodeForm(){
	if(isFixableCode(subject_info[lf])){
			match(subject_info[lf],/[A-Z]{3}\s?-?([X]{3}|[0-9]{3}\s?O?)/ ) 
			subject_info[lf]=substr(subject_info[lf], RSTART, RLENGTH)
			s=subject_info[lf]
			gsub (" ", "",s)
			gsub ("-", "",s)
			subject_info[lf]=s
	}
}

function setAdmissionRequirements(){
	if(subject_info[lf]=="Ingreso a Carrera"||subject_info[lf]=="Ver cursos generales"||subject_info[lf]=="Ver cursos optativos"||subject_info[lf]=="")
		subject_info[lf]="Admission"
}

function academicDegree(credSum){
	return credSum<=88? "dipl": "bsc"
}
function missingData(){
	return length(subject_info)<4
}
function completeSubjectData(){
	s=subject_info[0]
	fixOptionalCode(s)
	gsub (" ", "",s)
	line=line_count OFS s
}
function fixOptionalCode(o_code){
if(o_code=="Optativa "){
		switch(optCount){
			case 1:
				s=s"I"
				break;
			case 2:
				s=s"II"
				break;
			case 3:
				s=s"III"
				break;
			case 4:
				s=s"IV"
				break;
		}
	}
}


