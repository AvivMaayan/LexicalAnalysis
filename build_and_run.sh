# script for building and running. run from the main folder

# build
flex scanner.lex
g++ lex.yy.c hw1.cpp -o hw1.out
echo "*********build was successful************"

# run t1
echo "*****************run t1******************"
./hw1.out < tests_in/t1.in >& tests_out/t1.out
diff tests_out/t1.out tests_out_exp/t1.out

# run t2
echo "*****************run t2******************"
./hw1.out < tests_in/t2.in >& tests_out/t2.out
diff tests_out/t2.out tests_out_exp/t2.out