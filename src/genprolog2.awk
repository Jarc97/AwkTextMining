# Authors
#	Jose Javier Arce Zeledon
#	Julio Rodriguez Chavarria
#	Kevin Venegas Loria
#	Aaron Villalobos Arguedas

# Generates prolog file from compose.awk output
# loriacarlos@gmail.com
# compose_output/composed_plan.txt --> prolog_output/study_plan.pl
# To run
# awk -f src/prolog.awk output/composed_plan.txt > prolog_output/study_plan.pl

#Head
BEGIN {
	
	
	FS="::";
	RS=ORS="\r\n";
	
	numeros["_"] = "none";
	numeros["I"] = "1";
	numeros["II"] = "2";
	numeros["III"] = "3";
	numeros["IV"] = "4";
	numeros["V"] = "5";

	
	print "%%%%% Study Plan %%%%%"
	print ":- discontiguous course/1.";
	print ":- discontiguous course/8.";
	print ":- discontiguous course_req/2.";
	
}


# Expected input record format generated by compose
# nn::code::description::credits[2345](::req)*::(bsc|dipl)::(level|_)::(cycle|_)
# req ~ EI(F|G)...O? | LIX...


#Body
{
	
	printf "%%---  '%s' --- \n", $2;
	printf "course('%s'). \n", $2;
	

	if($3 ~ /Optativa|Generales/){
	
		primer_numero = numeros[$7];
		segundo_numero = numeros[$8];
		
		printf "course('%s', %d, regular, %s, %d, %s, %s, '%s'). ", $2, $1, $6, $4, primer_numero, segundo_numero, $3;
		printf "\n";
		printf "course_req('%s', '%s'). \n", $2, $5;
	} 
	else{

		if($6 ~ /dipl|bsc/){
		
			primer_numero = numeros[$7];
			segundo_numero = numeros[$8];
		
			printf "course('%s', %d, regular, %s, %d, %s, %s, '%s'). \n", $2, $1, $6, $4, primer_numero, segundo_numero, $3;
			printf "course_req('%s', '%s'). \n", $2, $5; 
		}
		else if ($7 ~ /dipl|bsc/){
		
			primer_numero = numeros[$8];
			segundo_numero = numeros[$9];
		
			printf "course('%s', %d, regular, %s, %d, %s, %s, '%s').\n", $2, $1, $7, $4, primer_numero, segundo_numero, $3 ;
			printf "course_req('%s', '%s'). \n", $2, $5;
			printf "course_req('%s', '%s'). \n", $2, $6; 
		}
		else if ($8 ~ /dipl|bsc/){
		
			primer_numero = numeros[$9];
			segundo_numero = numeros[$10];
		
			printf "course('%s', %d, regular, %s, %d, %s, %s, '%s').\n", $2, $1, $8, $4, primer_numero, segundo_numero, $3 ;
			printf "course_req('%s', '%s'). \n", $2, $5;
			printf "course_req('%s', '%s'). \n", $2, $6; 
			printf "course_req('%s', '%s'). \n", $2, $7; 
		}
	}

	
}

#Footer
END{

}
