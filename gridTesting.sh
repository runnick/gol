#!/bin/bash

#I=$RANDOM
#userName=Fif
#tArray3=( Zero 1 2 Three Four Fif Six Se7en )
#tick=3

#echo ${tArray[@]}					## Echo contents of the array

#((tArray[1] = tArray[1] + 22)) 	## Manipulate values within an array

#echo "What is the user's name?
#read userName						## Read user input from stdin
#echo "Is $userName correct?"

#if [ "$?" ] ; then					## If the last command completed successfully

#((tick--))							## Use (()) for increment/decrement

#for (( i = 0; i < 7; i++ )); do
#	if [[ "$userName" = "${tArray[$i]}" ]]; then
#		echo "Found a match" ${tArray[$i]}
#	else
#		echo "No match here" ${tArray[$i]}
#	fi
#
#done

#for var in a b c d e; do
#	echo $var ${!var}				## Echo the variable AND variable name
#done

I=("I" 1 3) #("Name" Value Energy)
O=("O" 0 3) #("Name" Value Energy)

grid0=()
grid1=()
grid2=()
grid3=()
grid4=()
grid5=()
grid6=()
grid7=()
grid8=()
grid9=()
grid10=()
grid11=()


function displayGrid {

  echo "[${grid0[0]}]""[${grid1[0]}]""[${grid2[0]}]""[${grid3[0]}]"
  echo "[${grid4[0]}]""[${grid5[0]}]""[${grid6[0]}]""[${grid7[0]}]"
  echo "[${grid8[0]}]""[${grid9[0]}]""[${grid10[0]}]""[${grid11[0]}]"

}


displayGrid
echo "----------"
echo "Nothing here."
echo ""

grid0+=(${I[@]})

displayGrid
echo "----------"
echo "I spawned at 0"
echo "Stats are: "${grid0[@]}
echo ""

grid4+=(${grid0[@]})
grid0=()

displayGrid
echo "----------"
echo "I moved from 0 to 4"
echo "Stats at 0 are: "${grid0[@]}
echo "Stats at 4 are: "${grid4[@]}
echo ""

grid4[2]=$(( ${grid4[2]} - 1 ))

echo "----------"
echo "Reduced I in grid4s energy by 1"
echo "Checking energy: "${grid4[@]}
echo ""
grid0+=(${I[@]})
echo "Spawned a new I at 0"
echo "Lets make sure the values are correct"
echo "Stats are: "${grid0[@]}
echo "----------" 
echo ""
displayGrid

exit

















































#case $userName in
#	${tArray3[0]})
#		echo $userName matches ${tArray3[0]}
#		;;
#	${tArray3[1]})
#		echo $userName matches ${tArray3[1]}
#		;; 
#	${tArray3[2]})
#		echo $userName matches ${tArray3[2]}
#		;; 
#	${tArray3[3]})
#		echo $userName matches ${tArray3[3]}
#		;; 
#	${tArray3[4]})
#		echo $userName matches ${tArray3[4]}
#		;; 
#	${tArray3[5]})
#		echo $userName matches ${tArray3[5]}
#		;; 
#	${tArray3[6]})
#		echo $userName matches ${tArray3[6]}
#		;; 
#	${tArray3[7]})
#		echo $userName matches ${tArray3[7]}
#		;; 
#esac

















exit