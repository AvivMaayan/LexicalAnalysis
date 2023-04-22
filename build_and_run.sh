# script for building and running. run from the main folder

# build
flex scanner.lex
g++ lex.yy.c hw1.cpp -o hw1.out
echo "*********build was successful************"

cd tests_in
for TEST in *.in 
do 
name=${TEST%.in} # remove the .in at the end
echo "*****************run $name******************"
../hw1.out < $TEST >& ../tests_out/$name.out
diff ../tests_out/$name.out ../tests_out_exp/$name.out 
done
cd ../