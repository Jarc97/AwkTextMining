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