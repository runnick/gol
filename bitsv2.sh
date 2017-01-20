#!/bin/bash

#--------------------------------------------------------------------------------------------------------

I=("I" 2 30 1) 
O=("O" 2 30 1) 

tick=0					#main() variable for determining how many cycles to run
cycle=0					#main() iterator Compared against $tick
cont=					#main() variable for awaiting user input
a=0						#main() loop iterator

noAge=false				#age boolean for calling energyReductionV2()
agedBits=()
t=0						#age iterator
u=0						#age spawned() check iterator

reproValue=0 			#spawnBit random repro value
ranBit=0 				#spawnBit random Bit selector 
spawnChance=0			#spawnBit random spawn chanceq
spawnCheck=0			#spawnBit random spawn roll check
l=0						#spawnBit iterator

bitsRecheck=			#turnOrder
lastBit=				#turnOrder
bitsWithAction=()		#turnOrder
e=0						#turnOrder iterator
h=0						#turnOrder iterator
j=0						#turnOrder iterator

currentLoc=()			#movingBit array for storing current grid's values
bitCheck=true			#movingBit boolean for checking current grid's values
bitFound=false			#movingBit boolean for returning whether or not current grid is empty
m=0						#movingBit iterator

friendUp=()				#searchFriend array for storing nearby grid values
friendDown=()			#searchFriend array for storing nearby grid values
friendRight=()			#searchFriend array for storing nearby grid values
friendLeft=()			#searchFriend array for storing nearby grid values

ranFriend=()			#makeFriend array used to store randomly selected nearby grid values
gridsToIgnore=()		#makeFriend array used to store grids not to check while selecting a Bit to merge
gridsToHold=()			#makeFriend array used to store non-optimal grids to merge with
f0=()					#makeFriend array used to store friend*() grid values
f1=()					#makeFriend array used to store friend*() grid values
f2=()					#makeFriend array used to store friend*() grid values
f3=()					#makeFriend array used to store friend*() grid values
possibleFriends=()		#makeFriend array used to store nearby grid names
ranFriendSL=			#makeFriend varible for selected grid's string length
currentLocSL=			#makeFriend varible for current grid's string length
ran=0					#makeFriend random varible used for random grid selection
numOfFriends=0			#makeFriend variable used to store number of grids with Bits in them
notFound=true			#makeFriend boolean for selecting another Bit to merge with
completed=true			#makeFriend boolean for returning successful grid selection
attempt=11 				#makeFriend loop attempts (so it doesn't get stuck in an infinite)
b=0						#makeFriend iterator

gridFound=false			#migrateBit boolean for ending the search loop
possibleGrids=()		#migrateBit array for storing possible grids to migrate to
d=0						#migratBiy iterator

recentlyMerged=()		#Multi-function array used for grid display, movingBit, makeFriend and mergeFriend
spawned=()				#Multi-function array used for grid display and movingBit
migrated=()				#Multi-function array used for grid display
ranGrid=()				#Multi-function array used for storing a random grid values
dump=0					#Multi-use variable for iterating junk branches
skip=false				#Multi-use boolean for grid checking

checkingGrid=0			#reproCheck variable used to store the current grid being checked
gridsToCheck=()			#reproCheck array for storing grids that need to be checked for Bits
z=0						#reproCheck iterator

freeGrids=()			#repro & reproCheck array used to store nearby grids that are empty
canRepro=false			#repro & reproCheck boolean for returning if a Bit can repro

size=0					#repro variable for storing the current grid's string size
splitBit=0				#repro variable for storing the current grid's string size / 2

reproGrid1=()			#repro variable for storing the value of the selected empty repro grid
reproGrid2=()			#repro variable for storing the value of the selected empty repro grid

gridPrinted=false		#colorChart and colorChartBasic variable for ending the grid color selection
colorSpawned=()			#colorChart and colorChartBasic array for storing grids that need coloring
colorMerged=()			#colorChart and colorChartBasic array for storing grids that need coloring
colorMigrated=()		#colorChart and colorChartBasic array for storing grids that need coloring
g=0						#colorChart and colorChartBasic iterator

c=0						#clearGrid iterator

k=
n=
p=
next=
printArray=()
pArrayLength=
eLoop=
nLoop=

r=0
s=0
v=0

#--------------------------------------------------------------------------------------------------------
# List of iterators - a b c d e g h j k l m n p q r s t u v w x z - 
# Do not use - i o f -
#--------------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------------


## 0.3.1 New
function createGrid {

	w=0

	while (( "$w" < 65 )); do
		
		declare -a grid$w=
		#echo "grid$w created" >> ~/Desktop/create.txt
		((w++))

	done

}

## 0.3.1 Bug Fix - Moved $reproValue into the random loop and repro check as it was giving all 
## Bits the same value. 
## Arguments: 1) ran or repro 2) integer or grid
function spawnBit () {

	if [ "$1" = "" ] || [ "$2" = "" ]; then

		echo "ERROR: Line 74 - Argument missing for spawnBit"
		echo "Exiting..."
		sleep 2
		exit

	fi

	reproValue=
	ranBit=

	if [ "$1" = "ran" ]; then

	  for (( l = 0; l < 65; l++ )); do

	    spawnChance=$2
	    spawnCheck=$(( ($RANDOM % 99) + 1 ))

	    if (( $spawnCheck <= $spawnChance )) ; then

	      if eval [ -z \"\${grid$l[0]}\" ] ; then

	        ranBit=$(($RANDOM % 2))
	        reproValue=$(( ($RANDOM % 50) + 1 ))

	        if (( $ranBit == 0 )) ; then

	          eval grid$l+=${O[0]}
	          eval grid$l[1]=${O[1]}
	          eval grid$l[2]=${O[2]}
	          eval grid$l[3]=$reproValue
	          #eval echo "Spawned grid\$l[\${grid$l[@]}]" >> ~/Desktop/out.txt

	        else

	          eval grid$l+=${I[0]}
	          eval grid$l[1]=${I[1]}
	          eval grid$l[2]=${I[2]}
	          eval grid$l[3]=$reproValue
	          #eval echo "Spawned grid\$l[\${grid$l[@]}]" >> ~/Desktop/out.txt

	        fi

	      fi

	    fi

	  done

	elif [ "$1" = "repro" ]; then

		ranBit=$(($RANDOM % 2))	
		reproValue=$(( ($RANDOM % 50) + 1 ))
		
		if (( $ranBit == 0 )) ; then

          eval $2+=${O[0]}
          eval $2[1]=${O[1]}
          eval $2[2]=${O[2]}
          eval $2[3]=$reproValue

        else

          eval $2+=${I[0]}
          eval $2[1]=${I[1]}
          eval $2[2]=${I[2]}
          eval $2[3]=$reproValue

         fi

    else

    	echo "ERROR: Line 141 - Invalid argument passed to spawnBit."
    	echo "Exiting..."
    	sleep 2
    	exit

    fi

}

## 0.3.1 New
function turnOrder {

	for (( e = 0; e < 65; e++ )); do
		
		if eval [ -n \"\${grid$e[0]}\" ]; then

			if (( ${#bitsWithAction[@]} == 0 )); then

				#echo ""
				#echo "No Bits in the array."
				bitsWithAction+=( grid$e )
				#echo "bitsWithAction["${bitsWithAction[@]}"]"
				#sleep 1
				#echo ""
				
			else

				bitsRecheck=

				for (( h = 0; h < ${#bitsWithAction[@]}; h++ )); do

					if eval [ \"\${grid$e[2]}\" -gt \"\${${bitsWithAction[$h]}[2]}\" ]; then
						
						#echo "Energy of grid"$e" is higher than "${bitsWithAction[$h]}"."
						bitsRecheck=${bitsWithAction[$h]}
						bitsWithAction[$h]=grid$e
						h=${#bitsWithAction[@]}
						#echo "bitsWithAction array contains "${#bitsWithAction[@]}" Bits."
						#echo "bitsWithAction["${bitsWithAction[@]}"]"
						#echo ""

					fi

				done

				if [ -z "$bitsRecheck" ]; then

					#echo "Energy of grid"$e" is lower."
					bitsWithAction+=( grid$e )
					#echo "bitsWithAction array contains "${#bitsWithAction[@]}" Bits."
					#echo "bitsWithAction["${bitsWithAction[@]}"]"
					#sleep 1
					#echo ""

				else

					checkAgain=
					lastBit=$(( ${#bitsWithAction[@]} - 1 ))
					#echo "Checking displaced Bit "$bitsRecheck
					#eval echo \${$bitsRecheck[@]}
					#echo "Last array index: "$lastBit
					#echo ""

					while [ -n "$bitsRecheck" ]; do

						if  eval [[ \${$bitsRecheck[2]} -lt \${${bitsWithAction[$lastBit]}[2]} ]] || eval [[ \${$bitsRecheck[2]} -eq \${${bitsWithAction[$lastBit]}[2]} ]]; then

							#echo "Found a home for displaced Bit "$bitsRecheck
							#eval echo "recheck: "\${bitsRecheck[2]}
							#eval echo "bWA: "\${${bitsWithAction[$lastBit]}[2]}
							bitsWithAction+=( $bitsRecheck )
							bitsRecheck=
							#echo "bitsWithAction["${bitsWithAction[@]}"]"
							#echo ""

						else

							for (( j = 1; j < ${#bitsWithAction[@]}; j++ )); do

								if eval [[ \"\${$bitsRecheck[2]}\" -gt \"\${${bitsWithAction[$j]}[2]}\" ]]; then

									checkAgain=${bitsWithAction[$j]}
									bitsWithAction[$j]=$bitsRecheck
									bitsRecheck=$checkAgain
									checkAgain=true
									j=${#bitsWithAction[@]}
									#echo "Found a home for displaced Bit. Now moving next displaced Bit "$bitsRecheck

								fi

							done

							if [ "$checkAgain" = false ]; then

							bitsWithAction+=( $bitsRecheck )
							bitsRecheck=
							#echo "Found a home for "$bitsRecheck

							fi

						fi

					done

				fi

			fi

		fi

	done

}

## 0.2 Needs Update
function movingBit () {

	if [[ -n "$1" ]]; then

		bitFound=false
		bitCheck=true

		for (( m = 0; m < 65; m++ )); do
			
			if [ "$1" = "${spawned[$m]}" ] || [ "$1" = "${recentlyMerged[$m]}" ]; then

				bitFound=false
				m=65
				bitCheck=false

			fi

		done

		if [ "$bitCheck" = true ]; then

			currentLoc=() 
			currentLoc+=($1)
			#echo "cL, no eval: "${currentLoc[@]}
			#eval echo "cL, with eval: "\${$currentLoc[@]}					#		   	"grid#" "Name" Value  Energy
			eval currentLoc+=(\${$1[@]})		# currentLoc=(grid1  I      1      3)
			
			if eval [ -n \"\${currentLoc[1]}\" ]; then
				
				bitFound=true
			
			else
				
				bitFound=false
			
			fi

		fi

	else

		echo "movingBit argument missing."

	fi

}

## 0.3 Updated - Moved friend check from makeFriend() to here in order to improve makeFriend()
function searchFriend () {

	if [ "$bitFound" = true ]; then

		friendLoc=
		friendUp=
		friendRight=
		friendDown=
		friendLeft=

		if ((${currentLoc[0]:4} - 4 >= 0)) ; then

			
			((friendLoc = ${currentLoc[0]:4} - 4))
			
			friendUp=(grid$friendLoc)
			eval friendUp+=(\${grid$friendLoc[@]})
			

		fi

		if (((${currentLoc[0]:4} + 1) % 4 == 0)) ; then 

			friendRight=()

		else

			
			((friendLoc=${currentLoc[0]:4} + 1))
			
			friendRight=(grid$friendLoc)
			eval friendRight+=(\${grid$friendLoc[@]})
			

		fi

		if ((${currentLoc[0]:4} + 4 <= 15)) ; then

			((friendLoc=${currentLoc[0]:4} + 4))
			friendDown=(grid$friendLoc)
			eval friendDown+=(\${grid$friendLoc[@]})

		fi

		if ((${currentLoc[0]:4} % 4 == 0)) ; then

			friendLeft=()

		else

			((friendLoc=${currentLoc[0]:4} - 1))
			friendLeft=(grid$friendLoc)
			eval friendLeft+=(\${grid$friendLoc[@]})

		fi

	fi

}

## 0.3 Updated - Moved friend check to searchFriend() removed several branches and consolidated  
## them into loops. makeFriend() also checks ${spawned[@]} for grids to ignore
function makeFriend {

	if [ "$bitFound" = true ]; then
	
		#echo ${friendUp[0]} "|" ${friendRight[0]} "|" ${friendDown[0]} "|" ${friendLeft[0]}
		notFound=true
		attempt=11
		#echo "attempts: "$attempt
		ran=0
		gridsToIgnore=()
		#echo "pF before assignment: "${possibleFriends[@]}
		ranFriend=0
		skip=false
		numOfFriends=3
		possibleFriends=( ${friendUp[0]} ${friendRight[0]} ${friendDown[0]} ${friendLeft[0]} )
		#echo "pF after assignment: "${possibleFriends[@]}
		#echo "Num pF: "${#possibleFriends[@]}

		while [ "$notFound" = true ] && (( $attempt > 0 )); do

			if (( ${#possibleFriends[@]} >= 1 )); then

				((ran = $RANDOM % ${#possibleFriends[@]} ))

				#echo "ran: "$ran
				ranFriend=${possibleFriends[$ran]}
				#echo "Intial ranFriend: "$ranFriend
				eval ranFriend=( \$ranFriend \${$ranFriend[@]} )
				#echo "ranFriend after eval: "${ranFriend[@]}
				unset possibleFriends[$ran]
				possibleFriends=( ${possibleFriends[@]} )
				#echo "possibleFriends after unset: "${possibleFriends[@]}

			elif (( ${#gridsToHold[@]} >= 1 )); then

				((ran = $RANDOM % ${#gridsToHold[@]} ))

				ranFriend=${gridsToHold[$ran]}
				eval ranFriend=( \$ranFriend \${$ranFriend[@]} )
				attempt=1

			else

				notFound=false
				attempt=0
				completed=false

			fi

			for (( b = 0; b < 65; b++ )); do

				if [ "${ranFriend[0]}" = "${recentlyMerged[$b]}" ] || [ "${ranFriend[0]}" = "${spawned[$b]}" ]; then

					gridsToIgnore+=(${ranFriend[0]})
					skip=true
					b=65
					ran=
					ranFriend=

				else

					skip=false

				fi
				
			done
			
			if [ "$skip" = false ] && (( $attempt > 1 )); then

				if [ "${ranFriend[0]}" != "" ] && (( ${#ranFriend[1]} > 0 )); then
				  		
				  	ranFriendSL=$(( ${#ranFriend[1]} - 1 ))
				  	currentLocSL=$(( ${#currentLoc[1]} - 1 ))

				  	if eval [ "\${currentLoc[1]:$currentLocSL}" == "\${ranFriend[1]:$ranFriendSL}" ]; then

				  		((attempt--))
				  		ran=
				  		gridsToHold+=(${ranFriend[0]})
				  		ranFriend=

				  	else

				  		if (( ${currentLoc[2]} == ${ranFriend[2]} )); then

			  				notFound=false
			  				attempt=0

				  		elif (( ${currentLoc[2]} != ${ranFriend[2]} )) && (( ${currentLoc[3]} > 11 )); then

				  			((attempt--))
				  			ran=
				  			gridsToHold+=${ranFriend[0]}
				  			ranFriend=

				  		else 

				  			notFound=false
				  			attempt=0

				  		fi

			  		fi

			  	else

			  		((attempt--))
			  		ran=
			  		gridsToIgnore+=(${ranFriend[0]})
			  		ranFriend=

				fi

			elif [ "$skip" = false ] && (( $attempt == 1 )); then

				if [ "${ranFriend[0]}" != "" ] && (( ${#ranFriend[1]} > 0 )) ; then			

						notFound=false
						attempt=0

				else

					((attempt--))
					ran=
					gridsToIgnore+=(${ranFriend[0]}) ##May need to remove
					ranFriend=

				fi

			else

				((attempt--))
				
			fi

		done

	fi

}

## 0.2.1.1 Needs Update
function mergeFriends {	 

	if [[ "$completed" == true ]] && [[ "$notFound" == false ]]; then 

		# Check to make sure there is enough energy to merge
		if (( ( (${currentLoc[3]} + ${ranFriend[3]}) - 10 ) > 0 )); then

			if (( ${currentLoc[2]} >= ${ranFriend[2]} )); then

				if [ "${currentLoc[1]}" = "${ranFriend[1]}" ]; then #If the name is the same : Need to update for multi-character names

					currentLoc[1]=${currentLoc[1]}${ranFriend[1]}
					currentLoc[2]=$(( (${currentLoc[2]} + ${ranFriend[2]}) - 1 )) #Value
					currentLoc[3]=$(( ${currentLoc[3]} + (${ranFriend[3]} - 10) )) #Energy
					currentLoc[4]=$(( (${currentLoc[4]} + ${ranFriend[4]}) / 2 ))	#Repro
					eval ${currentLoc[0]}=${currentLoc[1]}
					eval ${currentLoc[0]}[1]=${currentLoc[2]}
					eval ${currentLoc[0]}[2]=${currentLoc[3]}
					eval ${currentLoc[0]}[3]=${currentLoc[4]}
					eval ${ranFriend[0]}="()"
					recentlyMerged+=(${currentLoc[0]})
					colorMerged+=(${currentLoc[0]})
					colorMerged+=(${ranFriend[0]})

				else
					
					currentLoc[1]=${currentLoc[1]}${ranFriend[1]}
					currentLoc[2]=$(( ${currentLoc[2]} + ${ranFriend[2]} )) #Value
					currentLoc[3]=$(( ${currentLoc[3]} + (${ranFriend[3]} - 5) )) #Energy
					currentLoc[4]=$(( ${currentLoc[4]} + ${ranFriend[4]} ))	#Repro
					eval ${currentLoc[0]}=${currentLoc[1]}
					eval ${currentLoc[0]}[1]=${currentLoc[2]}
					eval ${currentLoc[0]}[2]=${currentLoc[3]}
					eval ${currentLoc[0]}[3]=${currentLoc[4]}
					eval ${ranFriend[0]}="()"
					recentlyMerged+=(${currentLoc[0]})
					colorMerged+=(${currentLoc[0]})
					colorMerged+=(${ranFriend[0]})

				fi

			elif (( ${currentLoc[2]} < ${ranFriend[2]} )); then

				if [ "${currentLoc[1]}" = "${ranFriend[1]}" ]; then

					ranFriend[1]=${ranFriend[1]}${currentLoc[1]}
					ranFriend[2]=$(( (${ranFriend[2]} + ${currentLoc[2]}) - 1 )) #Value
					ranFriend[3]=$(( ${ranFriend[3]} + (${currentLoc[3]} - 10) )) #Energy
					ranFriend[4]=$(( (${ranFriend[4]} + ${currentLoc[4]}) / 2 )) #Repro
					eval ${ranFriend[0]}=${ranFriend[1]}
					eval ${ranFriend[0]}[1]=${ranFriend[2]}
					eval ${ranFriend[0]}[2]=${ranFriend[3]}
					eval ${ranFriend[0]}[3]=${ranFriend[4]}
					eval ${currentLoc[0]}="()"
					recentlyMerged+=(${ranFriend[0]})
					colorMerged+=(${ranFriend[0]})
					colorMerged+=(${currentLoc[0]})

				else
					
					ranFriend[1]=${ranFriend[1]}${currentLoc[1]}
					ranFriend[2]=$(( ${ranFriend[2]} + ${currentLoc[2]} )) #Value
					ranFriend[3]=$(( ${ranFriend[3]} + (${currentLoc[3]} - 5) )) #Energy
					ranFriend[3]=$(( ${ranFriend[4]} + ${currentLoc[4]} )) #Repro
					eval ${ranFriend[0]}=${ranFriend[1]}
					eval ${ranFriend[0]}[1]=${ranFriend[2]}
					eval ${ranFriend[0]}[2]=${ranFriend[3]}
					eval ${ranFriend[0]}[3]=${ranFriend[4]}
					eval ${currentLoc[0]}="()"
					recentlyMerged+=(${ranFriend[0]})
					colorMerged+=(${ranFriend[0]})
					colorMerged+=(${currentLoc[0]})

				fi

			else

				echo "An error occurred with assigning the varible to the array."
			
			fi

		fi

	fi

}

## 0.3 New - Causing issues
function reproCheck {

	if [ "$bitFound" = true ]; then

		canRepro=

		for (( e = 0; e < 65; e++ )); do
			
			if [ "${currentLoc[0]}" = "${recentlyMerged[$e]}" ] || [ "${currentLoc[0]}" = "${spawned[$e]}" ]; then
				
				canRepro=false
				e=65
				#echo "currentLoc not found in recentlyMerged or spawned." >> ~/Desktop/out.txt
				#echo "-" >> ~/Desktop/out.txt

			fi

		done
		
		if (( "${currentLoc[2]}" >= 3)) && [ "$canRepro" != false ]; then	

			#echo "currentLocs value is greater than 2." >> ~/Desktop/out.txt
			#echo "-" >> ~/Desktop/out.txt
		
			if (( ($RANDOM % 101) < ${currentLoc[4]} )); then

				#echo "Passed the random repro check." >> ~/Desktop/out.txt
				#echo "-" >> ~/Desktop/out.txt
			
				if (( "${currentLoc[3]}" > 10 )) && (( ("${currentLoc[3]}" - 10) > 0 )); then

					#echo "currentLoc has enough energy to repro." >> ~/Desktop/out.txt
					#echo "-" >> ~/Desktop/out.txt
					gridsToCheck=( ${friendUp[0]} ${friendRight[0]} ${friendDown[0]} ${friendLeft[0]} )
					#echo "gridsToCheck: "${gridsToCheck[@]} >> ~/Desktop/out.txt
					#echo "-" >> ~/Desktop/out.txt
					freeGrids=()
					canRepro=true

					for (( z = 0; z < 4; z++ )); do
							
						checkingGrid=${gridsToCheck[$z]}
						#echo "checkingGrid: "$checkingGrid >> ~/Desktop/out.txt
						#eval echo "checkingGrids value: "\${$checkingGrid[@]} >> ~/Desktop/out.txt
						#echo "-" >> ~/Desktop/out.txt

						if eval [[ -z \${$checkingGrid[0]} ]] 2>/dev/null ; then

							freeGrids+=( ${gridsToCheck[$z]} )
							#echo "freeGrids: "${freeGrids[@]} >> ~/Desktop/out.txt
							#echo "-" >> ~/Desktop/out.txt

						fi

					done

				else

					#echo "currentLoc does not have enough energy to repro." >> ~/Desktop/out.txt
					#echo "-" >> ~/Desktop/out.txt
					canRepro=false

				fi

			else

				#echo "Failed to pass the random repro check." >> ~/Desktop/out.txt
				#echo "-" >> ~/Desktop/out.txt
				canRepro=false

			fi

		else

			#echo "currentLocs value is not greater than 2 or canRepro is "$canRepro >> ~/Desktop/out.txt
			#echo "-" >> ~/Desktop/out.txt
			canRepro=false

		fi

	fi

}

## 0.3.1 New 
function repro {

	if [[ "$canRepro" == true ]] && (( ${#freeGrids[@]} >= 2 )); then

		size=$((`expr "${currentLoc[1]}" : '.*'`))
		splitBit=$(($size / 2))
		ranGrid=$(($RANDOM % ${#freeGrids[@]}))
		reproGrid1=${freeGrids[$ranGrid]}
		unset freeGrids[$ranGrid]
		freeGrids=( ${freeGrids[@]} )

		eval ${reproGrid1[0]}[0]=${currentLoc[1]:0:$splitBit}
		eval ${reproGrid1[0]}[1]=$(( ${currentLoc[2]} / 2 ))
		eval ${reproGrid1[0]}[2]=$(( (${currentLoc[3]} / 2) + 30 ))
		eval ${reproGrid1[0]}[3]=$(( ${currentLoc[4]} / 2 ))

		eval ${currentLoc[0]}[0]=${currentLoc[1]:$splitBit}
		eval ${currentLoc[0]}[1]=$(( ${currentLoc[2]} / 2 ))
		eval ${currentLoc[0]}[2]=$(( (${currentLoc[3]} / 2) + 30 ))
		eval ${currentLoc[0]}[3]=$(( ${currentLoc[4]} / 2 ))

		eval currentLoc=( ${currentLoc[0]} \${${currentLoc[0]}[@]} )

		ranGrid=$(($RANDOM % ${#freeGrids[@]}))
		reproGrid2=${freeGrids[$ranGrid]}

		eval ${reproGrid2[0]}[0]=${currentLoc[1]}
		eval ${reproGrid2[0]}[1]=$(( ${currentLoc[2]} ))
		eval ${reproGrid2[0]}[2]=$(( ${currentLoc[3]} ))
		eval ${reproGrid2[0]}[3]=$(( ${currentLoc[4]} ))

		spawned+=( ${currentLoc[0]} )
		spawned+=( $reproGrid1 )
		spawned+=( $reproGrid2 )

		colorSpawned+=( ${currentLoc[0]} )
		colorSpawned+=( $reproGrid1 )
		colorSpawned+=( $reproGrid2 )

		eval unset $currentLoc[@]

		spawnBit repro ${currentLoc[0]}
		
	fi

}

## 0.2.1 In Progress - Removed ${currentLoc[@]} from ${merged[@]} and now += ${ranFriend[@]}
## in order to better display the Grids.
function migrateBit {

	if [ "$bitFound" = true ]; then

		skip=false

		for (( d = 0; d < 65; d++ )); do
			
			if [ "${currentLoc[0]}" = "${migrated[$d]}" ] || [ "${currentLoc[0]}" = "${recentlyMerged[$d]}" ] || [ "${currentLoc[0]}" = "${spawned[$d]}" ] ; then

				skip=true
				d=65

			fi

		done


		if (( ( ${currentLoc[3]} - 5 ) > 0 )) && [ "$skip" = false ]; then

			gridFound=false
			possibleGrids=( ${friendUp[0]} ${friendRight[0]} ${friendDown[0]} ${friendLeft[0]} )

			while [ "$gridFound" = false ] && (( ${#possibleGrids[@]} >= 1 )); do

				ran=$(( $RANDOM % ${#possibleGrids[@]} ))
				ranGrid=${possibleGrids[$ran]}
				
				eval ranGrid=( \$ranGrid \${$ranGrid[@]} )

				unset possibleGrids[$ran]
				possibleGrids=( ${possibleGrids[@]} )

				if [[ -z "${ranGrid[0]}" ]] || [[ -n "${ranGrid[1]}" ]]; then

					gridFound=false

				else

					migrated+=( ${ranGrid[0]} )

					colorMigrated+=( ${ranGrid[0]} )
					colorMigrated+=( ${currentLoc[0]} )

					ranGrid[1]=${currentLoc[1]}
					ranGrid[2]=${currentLoc[2]} #Value
					ranGrid[3]=$(( ${currentLoc[3]} - 5 )) #Energy
					ranGrid[4]=${currentLoc[4]}	#Repro
					eval ${ranGrid[0]}=${ranGrid[1]}
					eval ${ranGrid[0]}[1]=${ranGrid[2]}
					eval ${ranGrid[0]}[2]=${ranGrid[3]}
					eval ${ranGrid[0]}[3]=${ranGrid[4]}
					eval ${currentLoc[0]}="()"

					gridFound=true

				fi

			done

		fi

	fi
	
}

## 0.3 Updated - Added ${spawned[@]} check to prevent aging new Bits before then could do anything
function age {

	agedBits=()

	#echo ""
	#displayEnhancedGrid
	#echo ""

	#echo "spawned(): "${spawned[@]}

	for (( t = 0; t < 65; t++ )); do

		#echo "t: "$t

		if eval [ -n \"\${grid$t[0]}\" ]; then

			#echo "Bit found at grid"$t
			#echo "Checking spawned()..."

			for (( u = 0; u < 65; u++ )); do
		
				if [ "grid$t" = "${spawned[$u]}" ]; then

				noAge=true
				#echo "Bit recently spawned: "${spawned[$u]}
				#echo "Iterator was at: "$u
				u=65

				fi

			done

			if [ "$noAge" = false ]; then

				#echo "Bit not found in spawned()"
				#eval echo "grid is: "\${grid$t[@]}

				eval energyReductionV2 \${grid$t[@]}
				
				eval grid$t[2]="$?"

				#eval echo "grid energy after reductionV2: "\${grid$t[@]}
				agedBits+=( "grid$t" )

				if (( grid$t[2] <= 0 )); then

					eval grid$t="()"
					#echo "grid$t ran out of energy..." >> ~/Desktop/energyout.txt

				else

					eval reproChange grid$t \${grid$t[@]}

					eval grid$t[3]="$?"

				fi
			
			fi

		fi

	done

}

## 0.2.1 Needs Update
function energyReductionV2 () {

	#echo "Arguments: "$2 $3

	if (( $2 == 2 )) || (( $2 == 3 )) || (( $2 == 4 )); then

		if (( ($3 - 10) <= 0 )); then

			return "0"

		else

			return $(( $3 - 10 ))

		fi

	else

		if (( ( ($2 * (3 + $2) ) / 2) <= 0 )); then

			#echo "Return Energy is: "$(( ($2 * (3 + $2) ) / 2 ))

			return "0"

		else

			#echo "Return Energy is: "$(( ($2 * (3 + $2) ) / 2 ))

			return $(( ($2 * (3 + $2) ) / 2 ))

		fi

	fi

}

## 0.2.1.1 Needs Update
function reproChange () {

	if (( $3 >= 3 )); then
	
		return $(( $5 + ((50 - $4) - $3) )) #Increases or decreases reproValue based on Value and Energy
	
	else

		if (( (($RANDOM % 99) + 1) > 50 )); then

			return $(( $5 + 1 ))

		else

			return $(( $5 - 1 ))

		fi

	fi

}

## 0.3 Updated - Verified all variables here to ensure nothing was getting cleared accidentally
function clearTurnVariables {

	noAge=false				#age boolean for calling energyReductionV2()
	t=0						#age iterator
	u=0						#age spawned() check iterator

	reproValue=0 			#spawnBit random repro value
	ranBit=0 				#spawnBit random Bit selector 
	spawnChance=0			#spawnBit random spawn chance
	spawnCheck=0			#spawnBit random spawn roll check
	l=0						#spawnBit iterator

	currentLoc=()			#movingBit array for storing current grid's values
	bitCheck=true			#movingBit boolean for checking current grid's values
	bitFound=false			#movingBit boolean for returning whether or not current grid is empty
	m=0						#movingBit iterator

	friendUp=()				#searchFriend array for storing nearby grid values
	friendDown=()			#searchFriend array for storing nearby grid values
	friendRight=()			#searchFriend array for storing nearby grid values
	friendLeft=()			#searchFriend array for storing nearby grid values

	ranFriend=()			#makeFriend array used to store randomly selected nearby grid values
	gridsToIgnore=()		#makeFriend array used to store grids not to check while selecting a Bit to merge
	gridsToHold=()			#makeFriend array used to store non-optimal grids to merge with
	f0=()					#makeFriend array used to store friend*() grid values
	f1=()					#makeFriend array used to store friend*() grid values
	f2=()					#makeFriend array used to store friend*() grid values
	f3=()					#makeFriend array used to store friend*() grid values
	possibleFriends=()		#makeFriend array used to store nearby grid names
	ranFriendSL=			#makeFriend varible for selected grid's string length
	currentLocSL=			#makeFriend varible for current grid's string length
	ran=0					#makeFriend random varible used for random grid selection
	numOfFriends=0			#makeFriend variable used to store number of grids with Bits in them
	notFound=true			#makeFriend boolean for selecting another Bit to merge with
	completed=true			#makeFriend boolean for returning successful grid selection
	attempt=11 				#makeFriend loop attempts (so it doesn't get stuck in an infinite)
	b=0						#makeFriend iterator

	gridFound=false			#migrateBit boolean for ending the search loop
	possibleGrids=()		#migrateBit array for storing possible grids to migrate to
	d=0						#migratBiy iterator

	ranGrid=()				#Multi-function array used for storing a random grid values
	dump=0					#Multi-use variable for iterating junk branches
	skip=false				#Multi-use boolean for grid checking

	checkingGrid=0			#reproCheck variable used to store the current grid being checked
	gridsToCheck=()			#reproCheck array for storing grids that need to be checked for Bits
	z=0						#reproCheck iterator

	freeGrids=()			#repro & reproCheck array used to store nearby grids that are empty
	canRepro=false			#repro & reproCheck boolean for returning if a Bit can repro

	size=0					#repro variable for storing the current grid's string size
	splitBit=0				#repro variable for storing the current grid's string size / 2

	reproGrid1=()			#repro variable for storing the value of the selected empty repro grid
	reproGrid2=()			#repro variable for storing the value of the selected empty repro grid

	gridPrinted=false		#colorChart and colorChartBasic variable for ending the grid color selection
	colorSpawned=()			#colorChart and colorChartBasic array for storing grids that need coloring
	colorMerged=()			#colorChart and colorChartBasic array for storing grids that need coloring
	colorMigrated=()		#colorChart and colorChartBasic array for storing grids that need coloring
	g=0						#colorChart and colorChartBasic iterator

	c=0						#clearGrid iterator
	
}

## 0.3.1 New
function clearTickVariables {

	bitsRecheck=			#turnOrder
	lastBit=				#turnOrder
	bitsWithAction=()		#turnOrder
	e=0						#turnOrder iterator
	h=0						#turnOrder iterator
	j=0						#turnOrder iterator

	recentlyMerged=()		#Multi-function array used for grid display, movingBit, makeFriend and mergeFriend
	spawned=()				#Multi-function array used for grid display and movingBit
	migrated=()				#Multi-function array used for grid display

}

## 0.2 Needs Update 
function clearGrid {

	for (( c = 0; c < 65; c++ )); do

		if eval [ -n \"\${grid$c[0]}\" ]; then
			
			eval grid$c="()"
		
		fi

	done

}

function colorChartV3 () {

		if eval [ -n \"\${grid$1[0]}\" ]; then 

			printf $(tput setaf 2)"["; eval printf "%s' '" \${grid$1[0]}; printf \\b; printf "]"; tput sgr 0
			printf " "
		
		else

			eval printf "%s " $(tput setaf 0)"["\${grid$1[0]}; printf "]"; tput sgr 0
			printf " "
			gridPrinted=true

		fi

}

## 0.3.1 New - Not Finished
function printOrder {

	for (( k = 0; k < 65; k++ )); do

		if (( k == 0 )); then

			printArray=( grid0 )

		elif eval [ \${#grid$k[0]} -gt \${#${printArray[0]}[0]} ]; then

			pArrayLength=${#printArray[@]}
			eLoop=$(( $pArrayLength + 1 ))

			for (( n = 1; n < $eLoop; n++ )); do
				
				printArray[$(( $pArrayLength - ($n - 1) ))]=${printArray[$(( $pArrayLength - $n ))]}

			done

			printArray[0]=grid$k

		else

			pArrayLength=${#printArray[@]}
			nLoop=$(( $pArrayLength ))

			for (( p = 1; p < $nLoop; p++ )); do

				next=${printArray[$p]}

				if eval [ \${#grid$k[0]} -gt \${#$next[0]} ]; then
					
					eLoop=$(( $pArrayLength + 1 ))

					for (( n = $p; n < $eLoop; n++ )); do
				
						printArray[$(( $pArrayLength - ($n - 1) ))]=${printArray[$(( $pArrayLength - $n ))]}

					done

					printArray[$p]=grid$k
					p=$nLoop

				fi

			done

			if (( ${#printArray[@]} <= $pArrayLength )); then

				printArray[$pArrayLength]=grid$k

			fi

		fi

	done

}

## 0.3.1 New
function displayGridV3 { 

	s=0
	v=0
	r=0

	for (( s = 0; s < 8; s++ )); do

		#echo "Loop $s" >> ~/Desktop/out.txt
		declare line$s=
		v=0
		while (( "$v" < 8 )); do
			eval line$s+=\$\(colorChartV3 \$r\)
			(( r = r + 1 ))
			((v++))
		done

	done

	clear

	for (( s = 0; s < 8; s++ )); do
		eval echo \$line$s
		printf \\n
	done

}

## 0.3.1 New
function watDo {

	actions=()
	selectedAction=

	if eval [[ -n \${$friendUp[0]} ]] 2>/dev/null || eval [[ -n \${$friendRight[0]} ]] 2>/dev/null || eval [[ -n \${$friendDown[0]} ]] 2>/dev/null || eval [[ -n \${$friendLeft[0]} ]] 2>/dev/null; then
		actions+=( "makeFriend" )
	fi

	if [[ "$canRepro" == true ]]; then
		actions+=( "repro" )
	fi

	if eval [[ -z \${$friendUp[0]} ]] 2>/dev/null || eval [[ -z \${$friendRight[0]} ]] 2>/dev/null || eval [[ -z \${$friendDown[0]} ]] 2>/dev/null || eval [[ -z \${$friendLeft[0]} ]] 2>/dev/null; then
		actions+=( "migrateBit" )
	fi

	if (( ${#actions[@]} > 0 )); then
		
		selectedAction=${actions[$(($RANDOM % ${#actions[@]}))]}
	fi

}

## 0.3.1 New
function unsetLines {

	for (( x = 0; x < 9; x++ )); do
		unset line$x
	done

	echo "Line unset complete" >> ~/Desktop/out.txt
}

#---------------------------------------------Test Space-------------------------------------------------
#clear









#--------------------------------------------------------------------------------------------------------

#exit

#-------------------------------------------Full Sim Test------------------------------------------------


clear
createGrid
spawnBit ran 50
tick=70

echo ""
echo "		The Beginning		"
displayGridV3
echo ""
sleep 0.2
unsetLines

while (( $tick > 0 )); do

	turnOrder
	# echo "" >> ~/Desktop/turnout.txt
	# echo "                                  Tick: "$tick >> ~/Desktop/turnout.txt
	# echo "—————————————————————————————————————————————————————————————————————————————" >> ~/Desktop/turnout.txt

	while (( ${#bitsWithAction[@]} > 0 )); do

		movingBit ${bitsWithAction[0]}
		unset bitsWithAction[0]
		bitsWithAction=( ${bitsWithAction[@]} )
		searchFriend
		reproCheck
		watDo

		case $selectedAction in
			"makeFriend" ) makeFriend; mergeFriends
				;;
			"repro" ) repro
				;;
			"migrateBit" ) migrateBit
				;;
		esac

		# if [[ -n "${colorSpawned[@]}" ]]; then

		# 	echo "" >> ~/Desktop/turnout.txt
		# 	echo "Bit: "${currentLoc[0]} >> ~/Desktop/turnout.txt
		# 	echo "Potential Actions: ${actions[@]}" >> ~/Desktop/turnout.txt
		# 	echo "Selected Action: $selectedAction" >> ~/Desktop/turnout.txt
		# 	echo "Result: ${colorSpawned[0]} spawned ${colorSpawned[1]} & ${colorSpawned[2]}" >> ~/Desktop/turnout.txt

		# elif [[ -n "${colorMerged[@]}" ]]; then

		# 	echo "" >> ~/Desktop/turnout.txt
		# 	echo "Bit: "${currentLoc[0]} >> ~/Desktop/turnout.txt
		# 	echo "Potential Actions: ${actions[@]}" >> ~/Desktop/turnout.txt
		# 	echo "Selected Action: $selectedAction" >> ~/Desktop/turnout.txt
		# 	echo "Result: ${colorMerged[1]} merged with ${colorMerged[0]}" >> ~/Desktop/turnout.txt

		# elif [[ -n "${colorMigrated[@]}" ]]; then

		# 	echo "" >> ~/Desktop/turnout.txt
		# 	echo "Bit: "${currentLoc[0]} >> ~/Desktop/turnout.txt
		# 	echo "Potential Actions: ${actions[@]}" >> ~/Desktop/turnout.txt
		# 	echo "Selected Action: $selectedAction" >> ~/Desktop/turnout.txt
		# 	echo "Result: ${colorMigrated[1]} migrated to ${colorMigrated[0]}" >> ~/Desktop/turnout.txt

		# else

		# 	echo "" >> ~/Desktop/turnout.txt
		# 	echo "Bit: "${currentLoc[0]} >> ~/Desktop/turnout.txt
		# 	echo "No action was taken" >> ~/Desktop/turnout.txt

		# fi

		clearTurnVariables

	done

	#echo "" >> ~/Desktop/energyout.txt
	#echo "-Aging-" >> ~/Desktop/energyout.txt
	age
	#echo "agedBits: ${agedBits[@]}" >> ~/Desktop/energyout.txt
	#echo "-     -" >> ~/Desktop/energyout.txt
	#echo "" >> ~/Desktop/energyout.txt

	#clear
	displayGridV3
	echo
	echo "			Tick: "$tick
	sleep 0.2
	unsetLines

	clearTickVariables
	((tick--))

	# echo "" >> ~/Desktop/energyout.txt
	# echo "$tick" >> ~/Desktop/energyout.txt
	# echo "------------------------" >> ~/Desktop/energyout.txt
	# for (( q = 0; q < 65; q++ )); do
		
	# 	eval echo "grid\$q["\${grid$q[2]}"]" >> ~/Desktop/energyout.txt

	# done
	# echo "------------------------" >> ~/Desktop/energyout.txt

done

echo ""
echo "End of Sim"
exit


























































########################################################__To Do__#########################################
#																									
#																									
#																								
#																							
#																																																						#
#																							
#	Possible: Create "panic mode" when energy gets close to zero
#																									
#	DONE ------ Change sizePenalty to favor small multibits
#																									
#	DONE ------ Create a "reproduction" system 														
#																								
#	Do something when bits get too large 														
#																								
#	RecentlyMerged - possibly have a bit panic merge ignoring recentlyMerged - compare value and merge
#					 accordingly.
#																								
#	DONE ------ If all grids around a bit are empty, have it move to a random (or not) grid around it 	
#																										
# 	DONE ------ Check what in the hell is going on with the spawnBit function. 					
#																							
#	Set a color in displayGrids for aged-out Bits. 													
#																							
#	Set a total "in sim" Energy value that can not be exceeded and is split between all current bits.
#																									
#	Have bigger Bit's offspring have randomly larger starting values					
#																							
#																							
#																					
#																									
##########################################################################################################