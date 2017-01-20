#!/bin/sh

#------------------------------------VARIABLES-----------------------------------
randNum=0
tick=0

energyP=1
energyN=0
energyE=-1

totalNumP=0
totalNumN=0 #Will set this to be based on the "in universe" value
totalNumE=0

leftoverP=100
leftoverN=0
leftoverE=100 #Will need to change this later on if this is going to be dynamic

(( totalEnergy = $totalNumP + $totalNumN + $totalNumE ))

#------------------------------------ARRAYS--------------------------------------
grid01S=()
grid02S=()
grid11S=()

grid01=("+:" 0 "=:" 0 "-:" 0)		###Need to make this easier to look at.
grid02=("+:" 0 "=:" 0 "-:" 0)		#echo ${grid01[@]}
grid11=("+:" 0 "=:" 0 "-:" 0)

charge01=("+:" 0 "=:" 0 "-:" 0)
charge02=("+:" 0 "=:" 0 "-:" 0)
charge11=("+:" 0 "=:" 0 "-:" 0)

Posit=()
Neutrit=()
Negatrit=()

#-----------------------------------FUNCTIONS------------------------------------
#argument = starting, live, charge
function visualGrid {
	gridToDisplay=$1

	if [[ "$gridToDisplay" == "starting" ]]; then
		echo "grid01:[${grid01S[@]}]"\ "grid02:[${grid02S[@]}]"
		echo "grid11:[${grid11S[@]}]"\ 

	elif [[ "$gridToDisplay" == "live" ]]; then
		echo "grid01:[${grid01[@]}]"\ "grid02:[${grid02[@]}]"
		echo "grid11:[${grid11[@]}]"\ 

	elif [[ "gridToDisplay" == "charge" ]]; then
		echo "charge01:[${charge01[@]}]"\ "charge02:[${charge02[@]}]"
		echo "charge11:[${charge11[@]}]"\ 

	else
		echo "visualGrid function failed."
		echo "gridToDisplay is" $gridToDisplay
		echo "It must be set to 'starting', 'live' or 'charge'."
		exit

	fi
}

#argument = grid whose charge you want
#function getCharge {
#	grid=$1
									###### In progress ###

#	(( $chargeNumber[1] = $gridNumber[1] ))
#	(( $chargeNumber[3] = $gridNumber[3] * 10 ))
#	(( $chargeNumber[5] = $gridNumber[5] - ($gridNumber[5] * 2) ))
#}

function currentORStatus {
	echo "There are currently ${leftoverP} Posits outside reality."
	echo "There are currently ${leftoverN} Neutrits outside reality."
	echo "There are currently ${leftoverE} Negatrits outside reality."
}

#argument = max value or varible you are currently manipulating
function generateRandom {
	(( maxValue = $1 ))
	if (($maxValue != 0)); then
		(( randNum = $RANDOM % $maxValue ))
	else
		(( randNum = $RANDOM % 1 ))
	fi
}

#argument = grid number
function generateGridSquare {
	gridNumber="grid"$1
	generateRandom $leftoverP
	(( $gridNumber[1] = $gridNumber[1] + $randNum ))
	(( leftoverP = $leftoverP - $randNum ))

	#generateRandom $leftoverN
	#(( $gridNumber[3] = $gridNumber[3] + $randNum ))
	#(( leftoverN = $leftoverN - $randNum ))

	generateRandom $leftoverE
	(( $gridNumber[5] = $gridNumber[5] + $randNum ))
	(( leftoverE = $leftoverE - $randNum ))
}

function bondGrid01 {
	if ((grid01[1] + grid01[5] >= 1)); then
		
		generateRandom "${grid01[1]} + ${grid01[5]}"
		bondAttempts=$randNum

		for (( bondAttempts; bondAttempts > 0; bondAttempts-- )); do
			
			if ((grid01[1] >= 1 && grid01[5] >= 1)); then
			
				generateRandom 2
				
				if (($randNum == 0)); then		#Posit is bonding
					
					generateRandom 3
					
					if (($randNum == 0 && grid01[1] > 1)); then	#Posit hit another Posit
						
						generateRandom 3
						
						if (($randNum == 1)); then
							((grid01[1] = grid01[1] - 1))
							((grid02[1] = grid02[1] + 1))
						elif (($randNum == 2)); then
							((grid01[1] = grid01[1] - 1))
							((grid11[1] = grid11[1] + 1))
						else
							((grid01[1] = grid01[1]))
						fi

					elif (($randNum == 1 && grid01[3] >= 1)); then
						
						((grid01[1] = grid01[1] - 1))
						((leftoverP++))
						#Will need to add the code here

					elif (($randNum == 2 && grid01[5] >= 1)); then

						((grid01[1] = grid01[1] - 1))
						((grid01[5] = grid01[5] - 1))
						((grid01[3] = grid01[3] + 1))
						
					else
						
						((grid01[1] = grid01[1]))

					fi

				elif (($randNum == 1)); then	#Negatrit is bonding
					
					generateRandom 3
					
					if (($randNum == 0 && grid01[1] >= 1)); then

						((grid01[1] = grid01[1] - 1))
						((grid01[5] = grid01[5] - 1))
						((grid01[3] = grid01[3] + 1))
						
					elif (($randNum == 1 && grid01[3] >= 1)); then
						
						((grid01[5] = grid01[5] - 1))
						((leftoverE++))

					elif (($randNum == 2 && grid01[5] > 1)); then
						
						generateRandom 3
						
						if (($randNum == 1)); then
							((grid01[5] = grid01[5] - 1))
							((grid02[5] = grid02[5] + 1))
						elif (($randNum == 2)); then
							((grid01[5] = grid01[5] - 1))
							((grid11[5] = grid11[5] + 1))
						else
							((grid01[5] = grid01[5]))
						fi

					else
						
						((grid01[5] = grid01[5]))

					fi

				else

					((grid01[1] = grid01[1]))

				fi

			elif ((grid01[1] >= 1 && grid01[5] <= 0)); then

				generateRandom 2
					
					if (($randNum == 0 && grid01[1] > 1)); then	#Posit hit another Posit
						
						generateRandom 3
						
						if (($randNum == 1)); then
							((grid01[1] = grid01[1] - 1))
							((grid02[1] = grid02[1] + 1))
						elif (($randNum == 2)); then
							((grid01[1] = grid01[1] - 1))
							((grid11[1] = grid11[1] + 1))
						else
							((grid01[1] = grid01[1]))
						fi

					elif (($randNum == 1 && grid01[3] >= 1)); then
						
						((grid01[1] = grid01[1] - 1))
						((leftoverP++))
						#Will need to add the code here
						
					else
						
						((grid01[1] = grid01[1]))

					fi

			elif ((grid01[5] >= 1 && grid01[1] <= 0)); then
				
				generateRandom 2
					
					if (($randNum == 0 && grid01[3] >= 1)); then

						((grid01[5] = grid01[5] - 1))
						((leftoverE++))

					elif (($randNum == 1 && grid01[5] > 1)); then #Negatrit hit another Negatrit
						
						generateRandom 3
						
						if (($randNum == 1)); then
							((grid01[5] = grid01[5] - 1))
							((grid02[5] = grid02[5] + 1))
						elif (($randNum == 2)); then
							((grid01[5] = grid01[5] - 1))
							((grid11[5] = grid11[5] + 1))
						else
							((grid01[5] = grid01[5]))
						fi

					else
						
						((grid01[5] = grid01[5]))

					fi

			else

				bondAttempts=0

			fi

		done

	else

		((grid01[1] = grid01[1]))
		
	fi
}

function bondGrid02 {
	if ((grid02[1] + grid02[5] >= 1)); then
		
		generateRandom "${grid02[1]} + ${grid02[5]}"
		bondAttempts=$randNum

		for (( bondAttempts; bondAttempts > 0; bondAttempts-- )); do
			
			if ((grid02[1] >= 1 && grid02[5] >= 1)); then
			
				generateRandom 2
				
				if (($randNum == 0)); then		#Posit is bonding
					
					generateRandom 3
					
					if (($randNum == 0 && grid02[1] > 1)); then	#Posit hit another Posit
						
						generateRandom 3
						
						if (($randNum == 1)); then
							((grid02[1] = grid02[1] - 1))
							((grid01[1] = grid01[1] + 1))
						elif (($randNum == 2)); then
							((grid02[1] = grid02[1] - 1))
							((grid11[1] = grid11[1] + 1))
						else
							((grid02[1] = grid02[1]))
						fi

					elif (($randNum == 1 && grid02[3] >= 1)); then
						
						((grid02[1] = grid02[1] - 1))
						((leftoverP++))
						#Will need to add the code here

					elif (($randNum == 2 && grid02[5] >= 1)); then

						((grid02[1] = grid02[1] - 1))
						((grid02[5] = grid02[5] - 1))
						((grid02[3] = grid02[3] + 1))
						
					else
						
						((grid02[1] = grid02[1]))

					fi

				elif (($randNum == 1)); then	#Negatrit is bonding
					
					generateRandom 3
					
					if (($randNum == 0 && grid02[1] >= 1)); then

						((grid02[1] = grid02[1] - 1))
						((grid02[5] = grid02[5] - 1))
						((grid02[3] = grid02[3] + 1))
						
					elif (($randNum == 1 && grid02[3] >= 1)); then
						
						((grid02[5] = grid02[5] - 1))
						((leftoverE++))

					elif (($randNum == 2 && grid02[5] > 1)); then
						
						generateRandom 3
						
						if (($randNum == 1)); then
							((grid02[5] = grid02[5] - 1))
							((grid01[5] = grid01[5] + 1))
						elif (($randNum == 2)); then
							((grid02[5] = grid02[5] - 1))
							((grid11[5] = grid11[5] + 1))
						else
							((grid02[5] = grid02[5]))
						fi

					else
						
						((grid02[5] = grid02[5]))

					fi

				else

					((grid02[1] = grid02[1]))

				fi

			elif ((grid02[1] >= 1 && grid02[5] <= 0)); then

				generateRandom 2
					
					if (($randNum == 0 && grid02[1] > 1)); then	#Posit hit another Posit
						
						generateRandom 3
						
						if (($randNum == 1)); then
							((grid02[1] = grid02[1] - 1))
							((grid01[1] = grid01[1] + 1))
						elif (($randNum == 2)); then
							((grid02[1] = grid02[1] - 1))
							((grid11[1] = grid11[1] + 1))
						else
							((grid02[1] = grid02[1]))
						fi

					elif (($randNum == 1 && grid02[3] >= 1)); then
						
						((grid02[1] = grid02[1] - 1))
						((leftoverP++))
						#Will need to add the code here
						
					else
						
						((grid02[1] = grid02[1]))

					fi

			elif ((grid02[5] >= 1 && grid02[1] <= 0)); then
				
				generateRandom 2
					
					if (($randNum == 0 && grid02[3] >= 1)); then

						((grid02[5] = grid02[5] - 1))
						((leftoverE++))

					elif (($randNum == 1 && grid02[5] > 1)); then #Negatrit hit another Negatrit
						
						generateRandom 3
						
						if (($randNum == 1)); then
							((grid02[5] = grid02[5] - 1))
							((grid01[5] = grid01[5] + 1))
						elif (($randNum == 2)); then
							((grid02[5] = grid02[5] - 1))
							((grid11[5] = grid11[5] + 1))
						else
							((grid02[5] = grid02[5]))
						fi

					else
						
						((grid02[5] = grid02[5]))

					fi

			else

				bondAttempts=0

			fi

		done

	else

		((grid02[1] = grid02[1]))
		
	fi
}

function bondGrid11 {
	if ((grid11[1] + grid11[5] >= 1)); then
		
		generateRandom "${grid11[1]} + ${grid11[5]}"
		bondAttempts=$randNum

		for (( bondAttempts; bondAttempts > 0; bondAttempts-- )); do
			
			if ((grid11[1] >= 1 && grid11[5] >= 1)); then
			
				generateRandom 2
				
				if (($randNum == 0)); then		#Posit is bonding
					
					generateRandom 3
					
					if (($randNum == 0 && grid11[1] > 1)); then	#Posit hit another Posit
						
						generateRandom 3
						
						if (($randNum == 1)); then
							((grid11[1] = grid11[1] - 1))
							((grid01[1] = grid01[1] + 1))
						elif (($randNum == 2)); then
							((grid11[1] = grid11[1] - 1))
							((grid02[1] = grid02[1] + 1))
						else
							((grid11[1] = grid11[1]))
						fi

					elif (($randNum == 1 && grid11[3] >= 1)); then
						
						((grid11[1] = grid11[1] - 1))
						((leftoverP++))
						#Will need to add the code here

					elif (($randNum == 2 && grid11[5] >= 1)); then

						((grid11[1] = grid11[1] - 1))
						((grid11[5] = grid11[5] - 1))
						((grid11[3] = grid11[3] + 1))
						
					else
						
						((grid11[1] = grid11[1]))

					fi

				elif (($randNum == 1)); then	#Negatrit is bonding
					
					generateRandom 3
					
					if (($randNum == 0 && grid11[1] >= 1)); then

						((grid11[1] = grid11[1] - 1))
						((grid11[5] = grid11[5] - 1))
						((grid11[3] = grid11[3] + 1))
						
					elif (($randNum == 1 && grid11[3] >= 1)); then
						
						((grid11[5] = grid11[5] - 1))
						((leftoverE++))

					elif (($randNum == 2 && grid11[5] > 1)); then
						
						generateRandom 3
						
						if (($randNum == 1)); then
							((grid11[5] = grid11[5] - 1))
							((grid01[5] = grid01[5] + 1))
						elif (($randNum == 2)); then
							((grid11[5] = grid11[5] - 1))
							((grid02[5] = grid02[5] + 1))
						else
							((grid11[5] = grid11[5]))
						fi

					else
						
						((grid11[5] = grid11[5]))

					fi

				else

					((grid11[1] = grid11[1]))

				fi

			elif ((grid11[1] >= 1 && grid11[5] <= 0)); then

				generateRandom 2
					
					if (($randNum == 0 && grid11[1] > 1)); then	#Posit hit another Posit
						
						generateRandom 3
						
						if (($randNum == 1)); then
							((grid11[1] = grid11[1] - 1))
							((grid01[1] = grid01[1] + 1))
						elif (($randNum == 2)); then
							((grid11[1] = grid11[1] - 1))
							((grid02[1] = grid02[1] + 1))
						else
							((grid11[1] = grid11[1]))
						fi

					elif (($randNum == 1 && grid11[3] >= 1)); then
						
						((grid11[1] = grid11[1] - 1))
						((leftoverP++))
						#Will need to add the code here
						
					else
						
						((grid11[1] = grid11[1]))

					fi

			elif ((grid11[5] >= 1 && grid11[1] <= 0)); then
				
				generateRandom 2
					
					if (($randNum == 0 && grid11[3] >= 1)); then

						((grid11[5] = grid11[5] - 1))
						((leftoverE++))

					elif (($randNum == 1 && grid11[5] > 1)); then #Negatrit hit another Negatrit
						
						generateRandom 3
						
						if (($randNum == 1)); then
							((grid11[5] = grid11[5] - 1))
							((grid01[5] = grid01[5] + 1))
						elif (($randNum == 2)); then
							((grid11[5] = grid11[5] - 1))
							((grid02[5] = grid02[5] + 1))
						else
							((grid11[5] = grid11[5]))
						fi

					else
						
						((grid11[5] = grid11[5]))

					fi

			else

				bondAttempts=0

			fi

		done

	else

		((grid11[1] = grid11[1]))
		
	fi
}

function emergeParticles {
	while (($leftoverP + $leftoverN + $leftoverE > 2)); do

		generateRandom 3

		if (($randNum == 0)); then

			generateGridSquare 01

		elif (($randNum == 1)); then

			generateGridSquare 02

		else

			generateGridSquare 11

		fi
	done
}
#------------------------------------PROGRAM-------------------------------------
emergeParticles

grid01S=${grid01[@]}
grid02S=${grid02[@]}
grid11S=${grid11[@]}


echo "How many ticks?"
read tick

while ((tick >= 1)); do

	generateRandom 3

	if (($randNum == 0)); then

		bondGrid01

	elif (($randNum == 1)); then
		
		bondGrid02

	else

		bondGrid11

	fi

	emergeParticles

	((tick--))
done

echo ""
echo "The end result is:"
echo ""
sleep 1
echo "Starting Universe"
sleep 2
visualGrid starting
sleep 2
echo ""
echo "Ending Universe"
sleep 2
visualGrid live
sleep 2
echo ""
currentORStatus





















exit