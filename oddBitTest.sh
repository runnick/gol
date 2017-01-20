#!/bin/bash

a=01100001		#3
b=01100010		#3
c=01100011		#4
d=01100100		#3
e=01100101		#4
f=01100110		#4
g=01100111		#5
h=01101000		#3
i=01101001		#4
j=01101010		#4
k=01101011		#5
l=01101100		#4
m=01101101		#4
n=01101110		#5
o=01101111		#6
p=01110000		#3
q=01110001		#4
r=01110010		#4
s=01110011		#5
t=01110100		#4
u=01110101		#5
v=01110110		#5
w=01110111		#6
x=01111000		#4
y=01111001		#5
z=01111010		#5

value3=(a b d h p)
value4=(c e f i j l m q r t x)
value5=(g k n s u v y z)
value6=(o w)

letter=""
letterArray=(0 1)
value=0
actualLetter=false
arrays=(${value3[@]} ${value4[@]} ${value5[@]} ${value6[@]})

function getLetter {

for (( i = 2; i < 8; i++ )); do
	((letterArray[$i] = $RANDOM % 2))
done

}

function getValue {

	for (( i = 0; i < 8; i++ )); do
	((value = value + letterArray[$i]))
	done

}

getLetter	#generate a letter in binary
getValue	#get the "numerical value" of that letter

#Make sure the binary value that was generated makes a letter
if ((value >= 3)) && ((value <= 6)); then
	#echo "We have a letter"
	haveLetter=true
else
	#echo "No letter"
	haveLetter=false
	exit #change later
fi

#Turn the verified binary value into a string
for (( i = 0; i < 8; i++ )); do
	letter=$letter${letterArray[$i]}
done


for var in a b c d e f g h i j k l m n o p q r s t u v w x y z; do
	if [[ $letter = ${!var} ]]; then
		echo $var
	else
		exit
	fi
done



