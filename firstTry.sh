#!/bin/sh

#Varible defines
tick=10
cycle=1
totalEnergy=1000
evoChance=10
firstBorn=1
secondBorn=0
range=2

echo "Beginning simulation..."

sleep 2

while (($tick >= 1))

	#Energy renewal. For now this will be automatic.
	(( totalEnergy = ( totalEnergy + ( (($RANDOM % range) + 1) * (totalEnergy / 2) ) ) ))

	if (($firstBorn >= 1)); then
		if (($totalEnergy >= $firstBorn)); then
			(( totalEnergy = (totalEnergy - firstBorn) ))
			(( firstBorn = ( firstBorn + ( (($RANDOM % range) + 1) * firstBorn) ) ))

			#This will be for "death". Implement later.
			#$firstBorn=($firstBorn - (randomNumber(0.01 - 0.1) * $firstBorn)

		elif (($totalEnergy < $firstBorn)); then
			(( $totalEnergy=($totalEnergy - $firstBorn) ))
			(( $firstBorn=($firstBorn - $totalEnergy) ))
			(( $totalEnergy=1 ))
		else
			echo "ERROR: A problem occurred during the repro branch."
			exit
		fi
	else
		echo "Simulation complete."
		printf "Cycle: $(cycle) \n" >> aiprog.txt
		printf "The first have become extinct. \n" >> aiprog.txt
		printf "\n" >> aiprog.txt
		exit
	fi

	if (( (($RANDOM % evoChance) + 1) == 1)) && (($totalEnergy >= $firstBorn)); then
		if (($firstBorn >= 100)); then
			(( $secondBorn=( $secondBorn + (($RANDOM % range) + 1) ) ))
			(( $firstBorn=( $firstBorn - (($RANDOM % range) + 1) ) )) #Fix random number here to match above
			printf "\n" >> aiprog.txt
			printf "Cycle: $(cycle) \n" >> aiprog.txt
			printf "The second have arrived! \n" >> aiprog.txt
			printf "\n" >> aiprog.txt
		else 
			(( $firstBorn=( $firstBorn - (($RANDOM % range) + 1) ) ))
			printf "\n" >> aiprog.txt
			printf "Pool not diverse enough for evolution." >> aiprog.txt
			printf "\n" >> aiprog.txt
		fi
	else
		printf ""
	fi

	printf "Cycle: $(cycle) \n" >> aiprog.txt
	printf "Total energy: $(totalEnergy) \n" >> aiprog.txt
	printf "Total First: $(firstBorn) \n" >> aiprog.txt
	printf "Total Second: $(secondBorn) \n" >> aiprog.txt
	printf "\n" >> aiprog.txt

	(( $tick=($tick - 1) ))
	(( $cycle=($cycle + 1) ))

printf "SIMULATION COMPLETE" >> aiprog.txt
echo "Simulation complete."
exit

























