# script for building and running. run from the main folder

# Define colors for printing
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# build
flex scanner.lex
g++ lex.yy.c hw1.cpp -o hw1.out 
# check if was successful
if [ $? -eq 0 ]; then
  # If the exit code is 0, the build was successful
  echo -e "build ${GREEN} SUCCESS${NC}"
  # Now we perform the tests:
    cd tests_in
    for TEST in *.in 
    do 
        name=${TEST%.in} # remove the .in at the end from the name of the test
        ../hw1.out < $TEST >& ../tests_out/$name.out # run the code
        # Check if two files are identical
        if cmp -s "../tests_out/$name.out" "../tests_out_exp/$name.out"; then
        # If the files are identical, print "PASSED" in green
        echo -e "TEST $name ${GREEN}PASSED${NC}"
        else
        # If the files are different, print "FAILED" in red and the lines that were different
        echo -e "TEST $name ${RED}FAILED:${NC}"
        diff ../tests_out/$name.out ../tests_out_exp/$name.out 
        fi
    done
    cd ../
else
  # If the exit code is not 0, the build failed
  echo -e "${RED}build FAILED${NC}"
fi


