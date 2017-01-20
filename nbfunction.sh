#!/bin/bash
gridSquares=0

function createGrid () {

	a=0
	gridSquares=$1
	echo "$gridSquares"

	while (( "$a" < $1 )); do
		
		declare -a grid$a=
		((a++))

	done

	rows=$(echo sqrt \($(($gridSquares))\) | bc)
	columns=$(( ($gridSquares) / $rows ))

	#echo "$rows"
	#echo "$columns"
}

function displayGrid () {

	dG=0

	for (( c = 0; c < $rows; c++ )); do

		for (( d = 0; d < $columns; d++ )); do

			if eval [ -n \"\${grid$dG[0]}\" ]; then 

				printf $(tput setaf 2)"["; eval printf "%s' '" \${grid$dG[0]}; printf \\b; printf "]"; tput sgr 0
				printf " "
			
			else

				eval printf "%s " $(tput setaf 0)"["; printf " "; printf "]"; tput sgr 0
				printf " "

			fi

			((dG++))

		done

		printf \\n

	done

}

function spawnBit () {

	for (( b = 0; b < $gridSquares; b++ )); do

		spawnChance=$1
		spawnCheck=$(( ($RANDOM % 99) + 1 ))

		if (( $spawnCheck <= $spawnChance )) && eval [ -z \"\${grid$b[0]}\" ]; then

			if (( ($RANDOM % 2) == 0 )) ; then

				eval grid$b="O"

			else

				eval grid$b="I"

			fi

		fi

	done

}

function getBits () {

	bitLocations=()

	for (( e = 0; e < $gridSquares; e++ )); do
		
		if eval [[ -n "\${grid$e[0]}" ]]; then

			bitLocations+=( "grid$e" )

		fi

	done

}

function getGridValue () {

	eval echo "\${$1[@]}"

}

function localAreaBits () {

	emptyGrid=()
	mUp=0
	mRight=0
	mDown=0
	mLeft=0

	if (( $1 - $columns >= 0 )) && eval [[ -z \"\$grid$(($1 - $columns))\" ]]; then
		emptyGrid+=( "top" )
		mUp=grid$(($1 - $columns))
	fi

	if  (( ($1 + 1) % $columns != 0 )) && eval [[ -z \"\$grid$(($1 + 1))\" ]]; then
		emptyGrid+=( "right" )
		mRight=grid$(($1 + 1))
	fi

	if (( $1 + $columns <= ($gridSquares - 1) )) && eval [[ -z \"\$grid$(($1 + $columns))\" ]]; then
		emptyGrid+=( "bottom" )
		mDown=grid$(($1 + $columns))
	fi

	if (( $1 != 0)) && (( $1 % $columns != 0 )) && eval [[ -z \"\$grid$(($1 - 1))\" ]]; then
		emptyGrid+=( "left" )
		mLeft=grid$(($1 - 1))
	fi
	#echo "${emptyGrid[@]}"

}

function wideAreaBits () {

	foundBits=0

	if (( $1 - $columns >= 0 )) && eval [[ -n \"\$grid$(($1 - $columns))\" ]]; then
		((foundBits++))
	fi

	if  (( ($1 + 1) % $columns != 0 )) && eval [[ -n \"\$grid$(($1 + 1))\" ]]; then
		((foundBits++))
	fi

	if (( $1 + $columns <= ($gridSquares - 1) )) && eval [[ -n \"\$grid$(($1 + $columns))\" ]]; then
		((foundBits++))
	fi

	if (( $1 % $columns != 0 )) && eval [[ -n \"\$grid$(($1 - 1))\" ]]; then
		((foundBits++))
	fi

}

function selectMove {

	moveArray=()
	moveLoc=()
	moving=
	moveSelected=0

	if (( ${#emptyGrid[@]} >= 1 )); then

		directionChance=$(( 100 / ${#emptyGrid[@]} ))
		
		for (( f = 0; f < ${#emptyGrid[@]}; f++ )); do
			
			case ${emptyGrid[$f]} in
				top ) wideAreaBits $(( ${bitLocations[0]:4} - 6 )); tCount=$(($foundBits - 1)); up=$(( ($RANDOM % $directionChance) + ($tCount * 5) )); moveArray+=( "$up" ); moveLoc+=( "$mUp" )
					;;
				right ) wideAreaBits $(( ${bitLocations[0]:4} + 1 )); rCount=$(($foundBits - 1)); right=$(( ($RANDOM % $directionChance) + ($rCount * 5) )); moveArray+=( "$right" ); moveLoc+=( "$mRight" )
					;;
				bottom ) wideAreaBits $(( ${bitLocations[0]:4} + 6 )); bCount=$(($foundBits - 1)); down=$(( ($RANDOM % $directionChance) + ($bCount * 5) )); moveArray+=( "$down" ); moveLoc+=( "$mDown" )
					;;
				left ) wideAreaBits $(( ${bitLocations[0]:4} - 1 )); lCount=$(($foundBits - 1)); left=$(( ($RANDOM % $directionChance) + ($lCount * 5) )); moveArray+=( "$left" ); moveLoc+=( "$mLeft" )
					;; 
			esac

		done

	fi

	#echo "mAr: ${moveArray[@]}"
	#echo "mLo: ${moveLoc[@]}"

	for (( i = 0; i < ${#moveArray[@]}; i++ )); do
		if (( "${moveArray[$i]}" > "$moveSelected" )); then
			moveSelected=${moveArray[$i]}
			moving=${moveLoc[$i]}
		fi
	done

	#echo "move: $moving"

}

function moveBit () {
	
	if (( ${#emptyGrid[@]} >= 1 )); then
		eval $2[0]=\$$1
		eval $1[0]=
	fi

}



