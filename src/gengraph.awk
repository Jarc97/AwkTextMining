# Generates graphviz file from the compose.awk output
# loriacarlos@gmail.com
# compose_output/composed_plan.txt --> gv_output/study_plan.gv
# To run
# awk -f gengraph.awk compose_output/composed_plan.txt > gv_output/study_plan.gv

BEGIN {
    FS="::";
    course_regex = /(^EIF|^MAY)/;
	print "digraph Plan {";
    print "    node [shape=\"box\", nodesep=2];";
    print "    Admission [shape=\"invtriangle\", color=\"green\", style=\"filled\"];";
    print "    ranksep = 1;";
    print "    { rank=same; Admission }\n";
    
    currentCycle = 1;
    allCoursesRegex = /((EI(F|G)|MAT|MAY|LIX)[0-9][0-9][0-9])|(Admission)/;
    coursesToShowRegex = /((EI(F|G))[0-9][0-9][0-9])/;
    requirementsToShowRegex = /((EI(F|G))[0-9][0-9][0-9])|(Admission)/;

    ranker = "    { rank=same; ";
    # opt_ranker = "    { rank=sink; ";
}

# Expected input record format generated by compose
# nn::code::description::[2345](::req)*::(bsc|dipl)::(level|_)::(cycle|_)

function romanToDecimal(romanNumber) {
    if (romanNumber == "I") { return 1; }
    if (romanNumber == "II") { return 2; }
    if (romanNumber == "III") { return 3; }
    if (romanNumber == "IV") { return 4; }
    if (romanNumber == "V") { return 5; }
}

{
    # Check for new rank
    lastField = NF;         # get the last field (NF = number of fields)
    curr = romanToDecimal($lastField);
    
    # If we read a course on a new cycle
    if (curr != currentCycle) {
        # print the graphviz rank buffer
        ranker = substr(ranker, 1, length(ranker)-1);
        printf "%s };\n", ranker;

        # reset the rank buffer
        ranker = "";
        ranker = "    { rank=same; ";
        currentCycle = curr;
    }

    # Verify if we want to show the current course
    if ($2 ~ /((EI(F|G))[0-9][0-9][0-9])/) {
        # field where the required courses start
        courseField = 5;
        # verify if any required courses are left
        while ($courseField ~ /((EI(F|G)|MAT|MAY|LIX)[0-9][0-9][0-9])|(Admission)/) {
            # only print required courses we want to show
            if ($courseField ~ /((EI(F|G))[0-9][0-9][0-9])|(Admission)/) {
                # print output for graphviz
                printf "    %s -> %s;\n", $courseField, $2;
                # add course to ranker
                ranker = ranker $2 ",";
            }
            courseField++;
        }
    }

    # Only used to rank the optional courses
    ##
    # if ($2 ~ /(EI(F|G)[0-9][0-9][0-9]O)/) {
    #     opt_ranker = opt_ranker $2 ";";
    # }
}

END {
    # printf "%s };\n", opt_ranker;
    
    print "    START -> I_I -> I_II -> II_I -> II_II -> III_I -> III_II -> IV_I -> IV_II -> END [color=\"blue\", style=\"filled\"];"
	print "}\n";
}
