#!/bin/bash

##-----------------------------------------------------___Variables___----------------------------------------------------##

## The "Classes": Our two bits
I=("I" 2 30) #Currently three values for our bits: ( "Bit Name" | Numeric Value of the Bit | The Bit's Energy )
O=("O" 2 30) 

#----------------------------------------------------------------------------------------------------------------------------------------------------
#																																					|
#	Bit Name - Initially "I" or "O". As a bit merges, this will change based on the bit it has merged with (e.g. "IO", "OO", "IOIOI"). 				|
#				This does have an impact on the selection and merge process.																		|
#																																					|
#	Numeric Value - Initially 2. This currently only goes up. Increases additively based on the bit merged. 										|
#					 This has an impact on the merge process.																						|
#																																					|
#	Energy - Initially 30. This value increases and decreses. Increases additively based on the bit merged. Decreses multiply based on the size 	|
#			  (Bit Name) of the bit.																												|
#				*Note* Selected 30 as Bash doesn't really support floating point integers as far as I've seen and I needed room to play with 		|
#						the value more than +-1.																									|
#																																					|
#----------------------------------------------------------------------------------------------------------------------------------------------------

## The time variables.
tick=0
attempt=11

## The display grid for the first iterations.
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

## Variables for Bit selection and location.
currentLoc=()
friendUp=()
friendDown=()
friendRight=()
friendLeft=()
f0=()
f1=()
f2=()
f3=()

## Variables for Bit Merge or Migration.
gridsToIgnore=()
gridsToHold=()
merged=()
recentlyMerged=()
migrated=()
bitFound=false
completed=true
running=true

##Etc...
dump=0

##-------------------------------------------___Functions___------------------------------------------##

## 0.2.1 In Progress - reproValue is now randomized per Bit | Argument = spawnCheck chance
function spawnBit () {
  for (( l = 0; l < 16; l++ )); do
    spawnChance=$(( ($RANDOM % 99) + 1 ))
    spawnCheck=$(( ($RANDOM % $1) + 1 ))
    reproValue=$(( ($RANDOM % 50) + 1 ))
    ranBit=
    if (( $spawnCheck <= $spawnChance )) ; then
      if eval [ -z \"\${grid$l[0]}\" ] ; then
        ranBit=$(($RANDOM % 2))
        if (( $ranBit == 0 )) ; then
          eval grid$l+=${O[0]}
          eval grid$l[1]=${O[1]}
          eval grid$l[2]=${O[2]}
          eval grid$l[3]=$reproValue
        else
          eval grid$l+=${I[0]}
          eval grid$l[1]=${I[1]}
          eval grid$l[2]=${I[2]}
          eval grid$l[3]=$reproValue
        fi
      fi
    fi   
  done

}

## 0.2 Updated - Increased grid size
function displayGrid {
	echo "-----------------------------------------"
	colorChartBasic 0
	colorChartBasic 1
	colorChartBasic 2
	colorChartBasic 3
	printf \\n
	colorChartBasic 4
	colorChartBasic 5
	colorChartBasic 6
	colorChartBasic 7
	printf \\n
	colorChartBasic 8
	colorChartBasic 9
	colorChartBasic 10
	colorChartBasic 11
	printf \\n
	colorChartBasic 12
	colorChartBasic 13
	colorChartBasic 14
	colorChartBasic 15
	printf \\n
	echo "-----------------------------------------"

}

## 0.2 Updated - Increased grid size
function displayEnhancedGrid {
	echo "-----------------------------------------"
	colorChart 0
	colorChart 1
	colorChart 2
	colorChart 3
	printf \\n
	colorChart 4
	colorChart 5
	colorChart 6
	colorChart 7
	printf \\n
	colorChart 8
	colorChart 9
	colorChart 10
	colorChart 11
	printf \\n
	colorChart 12
	colorChart 13
	colorChart 14
	colorChart 15
	printf \\n
	echo "-----------------------------------------"

}

## 0.2 Updated - Added support for increased grid size
function searchFriend () {
	if (($1 - 4 >= 0)) ; then
		((friendLoc = $1 - 4))
		friendUp+=(grid$friendLoc)				#		   "grid#" "Name" Value  Energy
		eval friendUp+=(\${grid$friendLoc[@]})	# friendUp=(grid6  O      0      1)
	fi
	if ((($1 + 1) % 4 == 0)) ; then 
		friendRight=()
	else
		((friendLoc=$1 + 1))
		friendRight+=(grid$friendLoc)
		eval friendRight+=(\${grid$friendLoc[@]})
	fi
	if (($1 + 4 <= 15)) ; then
		((friendLoc=$1 + 4))
		friendDown+=(grid$friendLoc)
		eval friendDown+=(\${grid$friendLoc[@]})
	fi
	if (($1 % 4 == 0)) ; then
		friendLeft=()
	else
		((friendLoc=$1 - 1))
		friendLeft+=(grid$friendLoc)
		eval friendLeft+=(\${grid$friendLoc[@]})
	fi

}	

## 0.2 Updated - Needs serious cleanup!!
function makeFriend {
	
	numOfFriends=0

	#
	#echo "Make Friends"
	#echo "------------------------------------------"
	#
	
	if [ "$friendUp" = "" ]; then

		((dump++))

		#
		#echo "Nothing found at friendUp"
		#

	else
		eval f$numOfFriends=\(\${friendUp[@]}\)
		((numOfFriends++))
	fi
	
	if [ "$friendRight" = "" ]; then

		((dump++))

		#
		#echo "Nothing found at friendRight"
		#

	else
		eval f$numOfFriends=\(\${friendRight[@]}\)
		((numOfFriends++))
	fi

	if [ "$friendDown" = "" ]; then

		((dump++))

		#
		#echo "Nothing found at friendDown"
		#

	else
		eval f$numOfFriends=\(\${friendDown[@]}\)
		((numOfFriends++))
	fi

	if [ "$friendLeft" = "" ]; then

		((dump++))
		
		#
		#echo "Nothing found at friendLeft"
		#

	else
		eval f$numOfFriends=\(\${friendLeft[@]}\)
		((numOfFriends++))
	fi

	#
	#echo "NumberOfFriends: "$numOfFriends
	#

	notFound=true

	##Need to clean this branch up and make it more effecient.

	while [ "$notFound" = "true" ]; do

		if (( $attempt > 0 )) && (( $numOfFriends > 0 )); then

			#
			#echo "Ignoring grids: "${gridsToIgnore[@]}
			#echo "Grids on hold: "${gridsToHold[@]}
			#echo "Attempts remaining: "$attempt
			#

			((ran = $RANDOM % $numOfFriends))

			eval ranFriend=(\${f$ran[@]})

			#
			#echo "Random friend is: {"${ranFriend[0]}"["${ranFriend[1]} ${ranFriend[2]} ${ranFriend[3]}"]}"
			#

			if [ "${ranFriend[0]}" != "${gridsToIgnore[0]}" ] && [ "${ranFriend[0]}" != "${gridsToIgnore[1]}" ] && [ "${ranFriend[0]}" != "${gridsToIgnore[2]}" ] && [ "${ranFriend[0]}" != "${gridsToIgnore[3]}" ]; then

				if [ "${ranFriend[0]}" = "${recentlyMerged[0]}" ] || [ "${ranFriend[0]}" = "${recentlyMerged[1]}" ] || [ "${ranFriend[0]}" = "${recentlyMerged[2]}" ] || [ "${ranFriend[0]}" = "${recentlyMerged[3]}" ] || [ "${ranFriend[0]}" = "${recentlyMerged[4]}" ] || [ "${ranFriend[0]}" = "${recentlyMerged[5]}" ] || [ "${ranFriend[0]}" = "${recentlyMerged[6]}" ]; then

					gridsToIgnore+=(${ranFriend[0]})

				else

					if [ "${ranFriend[0]}" != "${gridsToHold[0]}" ] && [ "${ranFriend[0]}" != "${gridsToHold[1]}" ] && [ "${ranFriend[0]}" != "${gridsToHold[2]}" ] && [ "${ranFriend[0]}" != "${gridsToHold[3]}" ] && (( $attempt > 1 )); then
					
						if [ "$ranFriend" != "" ]; then

							if (( ${#ranFriend[1]} > 0 )); then
						  		
						  		ranFriendSL=$(( ${#ranFriend[1]} - 1 ))
						  		currentLocSL=$(( ${#currentLoc[1]} - 1 ))

						  		if eval [ "\${currentLoc[1]:$currentLocSL}" == "\${ranFriend[1]:$ranFriendSL}" ]; then

						  				((attempt--))
						  				gridsToHold+=(${ranFriend[0]})

						  				#
						  				#echo "Fail: Bit character match"
						  				#sleep 1
						  				#echo ""
						  				#

						  		else

						  			if (( ${currentLoc[2]} == ${ranFriend[2]} )); then

						  				notFound=false

							  			#
							  			#echo "Success: Made friends with a different bit"
							  			#sleep 2
							  			#echo ""
							  			#echo ""
							  			#

							  		elif (( ${currentLoc[2]} != ${ranFriend[2]} )) && (( ${currentLoc[3]} > 11 )); then

							  			((attempt--))
							  			gridsToHold+=${ranFriend[0]}

							  			#
							  			#echo "Fail: Bit size mismatch"
							  			#echo ""
							  			#

							  		else 

							  			notFound=false

							  			#
							  			#echo "Success: Fallback bit selected"
							  			#sleep 2
							  			#echo ""
							  			#echo ""
							  			#

							  		fi

						  		fi

						  	else
						  		((attempt--))
						  		gridsToIgnore+=(${ranFriend[0]})

						  		#
						  		#echo "Fail: ranFriend at ${ranFriend[@]} has no bit"
						  		#sleep 1
						  		#echo ""
						  		#

							fi

						else
							((attempt--))
							gridsToIgnore+=(${ranFriend[0]})

							#
							#echo "Fail: ranFriend is a non-existent gridspace"
							#sleep 1
							#echo ""
							#

						fi

					else

						if [ "$ranFriend" != "" ] && (( ${#ranFriend[1]} > 0 )) && (( $attempt == 1 )); then			

							notFound=false

				  				#
				  				#echo "Success: Friend from gridsToHold was selected"
				  				#sleep 2
				  				#echo ""
				  				#echo ""
				  				#
				  		
				  		else

				  			((attempt--))

				  			#
				  			#echo "Fail: ranFriend is in gridsToHold"
				  			#echo ""
				  			#

				  		fi

					fi

				fi

			else

				if (( ${#gridsToIgnore[@]} >= $numOfFriends )); then

					completed=false
					notFound=false

					migrateBit	#Need to check and make sure ranFriend isn't a non-exsistent grid

					#
					#echo "MakeFriend Fail: GridsToIgnore is equal to NumberOfFriends"
					#sleep 2
					#echo ""
					#echo ""
					#

				fi

			fi

		else

			completed=false
			notFound=false

			migrateBit	#Need to check and make sure ranFriend isn't a non-exsistent grid

			#
			#echo "MakeFriend Fail: No attempts or friends left"
			#sleep 2
			#echo ""
			#echo ""
			#

		fi

	done

}

## In Progress - 0.2 functional - Need to create error check.
function migrateBit {

	#Used if no bit was found to merge with
	if (( ( ${currentLoc[3]} - 5 ) > 0 )); then

		migrated[0]=${currentLoc[0]}
		migrated[1]=${ranFriend[0]}

		ranFriend[1]=${currentLoc[1]}
		ranFriend[2]=${currentLoc[2]} #Value
		ranFriend[3]=$(( ${currentLoc[3]} - 5 )) #Energy
		ranFriend[4]=${currentLoc[4]}	#Repro
		eval ${ranFriend[0]}=${ranFriend[1]}
		eval ${ranFriend[0]}[1]=${ranFriend[2]}
		eval ${ranFriend[0]}[2]=${ranFriend[3]}
		eval ${ranFriend[0]}[3]=${ranFriend[4]}
		eval ${currentLoc[0]}="()"

	fi

}

## 0.2.1.1 Updated
function mergeFriends {	 

	# Check to make sure there is enough energy to merge
	if (( ( (${currentLoc[3]} + ${ranFriend[3]}) - 10 ) > 0 )); then

		if (( ${currentLoc[2]} >= ${ranFriend[2]} )); then

			merged[0]=${currentLoc[0]}
			merged[1]=${ranFriend[0]}

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

			fi

		elif (( ${currentLoc[2]} < ${ranFriend[2]} )); then

			merged[0]=${currentLoc[0]}
			merged[1]=${ranFriend[0]}

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

			fi

		else

			echo "An error occurred with assigning the varible to the array."
		
		fi

	fi

}

## 0.2 Updated
function clearVariables {
	spawnChance=
	spawnCheck=
	ranBit=
	loc=
	l=
	friendUp=()
	friendDown=()
	friendRight=()
	friendLeft=()
	currentLoc=()
	numOfFriends=0
	f0=()
	f1=()
	f2=()
	f3=()
	gridsToIgnore=()
	gridsToHold=()
	bitFound=false
	notFound=true
	attempt=11
	ran=
	ranFriend=
	ranFriendSL=
	currentLocSL=
	completed=true
	merged=()
	migrated=()

}

## 0.2.1 Updated
function age {

	for (( t = 0; t < 16; t++ )); do

		if eval [ -n \"\${grid$t[0]}\" ]; then
			
			eval energyReductionV2 \${grid$t[@]}
			
			eval grid$t[2]="$?"

			if (( grid$t[2] <= 0 )); then

				eval grid$t="()"

			else

				eval reproChange grid$t \${grid$t[@]}

				eval grid$t[3]="$?"

			fi
		
		fi

	done

}

## 0.2.1 New
function energyReductionV2 () {

	if (( $2 == 3 )) || (( $2 == 4 )); then

		if (( ($3 - 10) <= 0 )); then

			return "0"

		else

			return $(( $3 - 10 ))

		fi

	else

		if (( ( ($2 * (3 + $2) ) / 2) <= 0 )); then

			return "0"

		else

			return $(( ($2 * (3 + $2) ) / 2 ))

		fi

	fi

}

## 0.2.1.1 New
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

## 0.2 Updated - Use with displayEnhancedGrid.
function colorChart () {

 	if [ "grid$1" = "${merged[0]}" ] || [ "grid$1" = "${merged[1]}" ]; then

		printf $(tput bold)$(tput setaf 6)"$1:""["; eval printf "%s' '" \${grid$1[@]}; printf \\b; printf "]"; tput sgr 0
		printf " "

	elif [ "grid$1" = "${migrated[0]}" ] || [ "grid$1" = "${migrated[1]}" ]; then

		printf $(tput bold)$(tput setaf 3)"$1:""["; eval printf "%s' '" \${grid$1[@]}; printf \\b; printf "]"; tput sgr 0
		printf " "

	else

		if eval [ -n \"\${grid$1[0]}\" ]; then 

			printf $(tput setaf 2)"$1:""["; eval printf "%s' '" \${grid$1[@]}; printf \\b; printf "]"; tput sgr 0
			printf " "
		
		else

			eval printf "%s " $(tput setaf 1)"$1:""["\${grid$1[@]}; printf "]"; tput sgr 0
			printf " "

		fi
	
	fi

}

## 0.2 Updated - Use with displayGrid.
function colorChartBasic () {

 	if [ "grid$1" = "${merged[0]}" ] || [ "grid$1" = "${merged[1]}" ]; then

		printf $(tput bold)$(tput setaf 6)"$1:""["; eval printf "%s' '" \${grid$1[0]}; printf \\b; printf "]"; tput sgr 0
		printf " "

	elif [ "grid$1" = "${migrated[0]}" ] || [ "grid$1" = "${migrated[1]}" ]; then

		printf $(tput bold)$(tput setaf 3)"$1:""["; eval printf "%s' '" \${grid$1[0]}; printf \\b; printf "]"; tput sgr 0
		printf " "

	else

		if eval [ -n \"\${grid$1[0]}\" ]; then 

			printf $(tput setaf 2)"$1:""["; eval printf "%s' '" \${grid$1[0]}; printf \\b; printf "]"; tput sgr 0
			printf " "
		
		else

			eval printf "%s " $(tput setaf 1)"$1:""["\${grid$1[0]}; printf "]"; tput sgr 0
			printf " "

		fi
	
	fi

}

## 0.2 Updated
function movingBit () {

			currentLoc=() 
			currentLoc+=(grid$1)					#		   	"grid#" "Name" Value  Energy
			eval currentLoc+=(\${grid$1[@]})		# currentLoc=(grid1  I      1      3)
			if eval [ -n \"\${currentLoc[1]}\" ]; then
				bitFound=true
			else
				bitFound=false
			fi

}

## 0.2.1 Updated - Argument = number of cycles to run.
function terminalMain () {

	tick=$1

	for (( cycle=1; cycle <= tick; cycle++ )); do
	 	
		spawnBit 99

		if [ "$2" = "eg" ]; then
			displayEnhancedGrid
		else
			displayGrid
		fi
			
		for (( i = 0; i < 16; i++ )); do

			movingBit $i

			if [ "$bitFound" = true ]; then
				
				searchFriend $i
				
				makeFriend

				if [ "$completed" = true ]; then

					mergeFriends
					
				fi
				
			fi

			if [ "$2" = "eg" ]; then
				displayEnhancedGrid
			else
				displayGrid
			fi

			clearVariables

		done

		age

		recentlyMerged=()

		echo "Cycle $cycle complete."

	done

	echo ""
	echo ""
	echo ""
	echo ""
	echo ""
	echo "Simulation complete."
	echo ""
	echo ""
	echo "		Final Grid 		"
	if [ "$2" = "eg" ]; then
		displayEnhancedGrid
	else
		displayGrid
	fi
	echo ""
	echo ""
	echo "---------------------"
	echo "$(tput setaf 6)Cyan: Merged Bits$(tput sgr 0)"
	echo "$(tput setaf 3)Yellow: Migrated Bits$(tput sgr 0)"
	echo "$(tput setaf 2)Green: Grid with Bit$(tput sgr 0)"
	echo "$(tput setaf 1)Red: Empty Grid$(tput sgr 0)"
	echo "---------------------"
	echo ""
	exit

}

## Currently does not work.
function textMain () {

	tick=$1

	for (( cycle=1; cycle <= tick; cycle++ )); do
	 	
		spawnBit

		displayGrid >> binary.txt
			
		for (( i = 0; i < 12; i++ )); do

			movingBit $i

			if [ "$bitFound" = true ]; then
				
				searchFriend $i
				
				makeFriend

				if [ "$completed" = true ]; then

					mergeFriends
					
				fi
				
			fi

			displayGrid >> binary.txt

			clearVariables

		done

		age

		recentlyMerged=()

		echo "Cycle $cycle complete." >> binary.txt

	done

	echo "Simulation complete." >> binary.txt
	sleep 2
	exit

}


## 0.2 Updated - Argument = number of cycles to run.
function debugMain () {

	tick=$1

	for (( cycle=1; cycle <= tick; cycle++ )); do
	 	
	 	echo ""
		echo "Current cycle is: "$cycle
		echo ""
		echo "Spawning bits..."
		echo ""
		
		spawnBit 99

		displayEnhancedGrid
		echo ""
		echo "Beginning simulation..."
		#sleep 1
		echo ""
			
		for (( i = 0; i < 16; i++ )); do

			echo "Starting loop for grid"$i
			echo ""
			echo "recentlyMerged grids are: "${recentlyMerged[@]}
			echo ""
			echo "------------"
			echo "MovingBit..."
			echo "------------"
			#sleep 1
			echo ""
			echo ""
			
			movingBit $i

			if [ "$bitFound" = true ]; then
				
				echo "BitFound is: "$bitFound
				#sleep 1
				echo "CurrentLoc: {"${currentLoc[0]}"["${currentLoc[1]} ${currentLoc[2]} ${currentLoc[3]}"]}"
				#sleep 1
				echo "Proceeding with the loop."
				#sleep 1
				echo ""
				echo "------------------"
				echo "SearchingFriend..."
				echo "------------------"
				#sleep 1
				echo ""
				echo ""
				
				searchFriend $i

				echo "Possible Friends"
				echo "------------------"
				echo "FU: "${friendUp[@]}
				echo "FR: "${friendRight[@]}
				echo "FD: "${friendDown[@]}
				echo "FL: "${friendLeft[@]}
				echo "------------------"
				echo ""
				echo "MakingFriend..."
				#sleep 1
				echo ""
				echo ""
				
				makeFriend

				echo "MakeFriend Successful: "$completed
				#sleep 1
				
				if [ "$completed" = true ]; then

					echo "RanFriend: "${ranFriend[@]}
					echo "CurrentLocSL: "$currentLocSL
					echo "RanFriendSL: "$ranFriendSL
					echo "Merging friends..."
					#sleep 1
					echo ""
					echo ""
					
					mergeFriends

					echo "Merged grids"
					echo "-----------------"
					echo "Merged0: "${merged[0]}
					echo "Merged1: "${merged[1]}
					echo "-----------------"
					#sleep 1
					echo ""
					echo ""
					
				else

					echo "MakeFriend was not successful"
					echo "Friend found: "$notFound
					echo "No merge is occurring..."
					#sleep 1
					echo ""
					echo ""
				
				fi

			else

				echo "BitFound is: "$bitFound
				echo "Moving to the next loop"
				#sleep 1
				echo ""
				echo ""
				
			fi

			displayEnhancedGrid
			echo ""

			echo "ClearingVariables..."
			#sleep 1
			echo ""
			echo ""
			
			clearVariables

			echo "Loop $i complete"
			echo ""

		done

		echo "Cycle $cycle complete."
		echo "Aging bits..."
		#sleep 1
		echo ""
		echo ""
		
		age

		recentlyMerged=()

		
		echo "recentlyMerged is now cleared: "${recentlyMerged[@]}
	 	#sleep 2
		echo ""
		echo ""
		

	done

	echo "Simulation complete."
	echo "--------------------"
	echo "$(tput setaf 6)Cyan: Merged Bits$(tput sgr 0)"
	echo "$(tput setaf 3)Yellow: Migrated Bits$(tput sgr 0)"
	echo "$(tput setaf 2)Green: Grid with Bit$(tput sgr 0)"
	echo "$(tput setaf 1)Red: Empty Grid$(tput sgr 0)"
	#sleep 2
	echo ""
	exit

}

## 0.2 Updated 
function clearGrid {

	for (( c = 0; c < 16; c++ )); do

		if eval [ -n \"\${grid$c[0]}\" ]; then
			
			eval grid$c="()"
		
		fi

	done

}




##-----------------------------------------___Menu___-----------------------------------------##

echo "$(tput clear)$(tput bold)$(tput smul)BINARY v. 0.1$(tput sgr0)"

options="Terminal Text Debug Quit"

echo "Select the mode to run in."

select opt in $options; do
##-----------------------------------------_Terminal_-----------------------------------------##	
	if [ "$opt" = "Terminal" ]; then

		echo "You selected Terminal"
		echo ""
		echo "How many cycles?"
		read tick
		echo ""

		terminalMain $tick

##-----------------------------------------___Text___-----------------------------------------##			
	elif [ "$opt" = "Text" ]; then

		echo "You selected Text"
		> ~/Desktop/binary.txt
		echo ""
		echo "This shit dun work yet."
		#echo "The text file will be on your desktop"
		echo ""
		echo "How many cycles?"
		read tick
		echo ""

		terminalMain $tick

##--------------------------------------___Debug-Mode___--------------------------------------##		
	elif [ "$opt" = "Debug" ]; then
		
		echo "You selected Debug"
		echo ""
		echo "Now in Debug Mode"
		echo ""
		echo "How many cycles?"
		read tick
		echo ""
		echo "User entered: "$tick
		sleep 2

		debugMain $tick

##---------------------------------------___Menu End___---------------------------------------##			
	elif [ "$opt" = "Quit" ]; then

		echo "Exiting..."
		sleep 2
		exit

	else

		clear
		echo "Bad option"

	fi

done


exit