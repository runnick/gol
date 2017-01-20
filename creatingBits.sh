#!/bin/sh

tick=10
cycle=1
totalEnergy=1000
evoChance=10
firstBorn=1
secondBorn=0
range=2


echo "Tick is:" $tick
echo "Cycle is:" $cycle
echo "Total Energy is:" $totalEnergy
echo "Evo Chance is:" $evoChance
echo "First Born is:" $firstBorn
echo "Second Born is:" $secondBorn
echo "Range is:" $range

echo "Beginning simulation..."

sleep 2

while (($tick >= 1)); do
	echo "Loop started"
	#Energy renewal. For now this will be automatic.
	(( totalEnergy = ( totalEnergy + ( (($RANDOM % range) + 1) * (totalEnergy / 5) ) ) ))

	if (($firstBorn >= 1)); then
		if (($totalEnergy >= $firstBorn)); then
			(( totalEnergy = (totalEnergy - firstBorn) ))
			(( firstBorn = ( firstBorn + ( (($RANDOM % range) + 1) * firstBorn) ) ))

			#This will be for "death". Implement later.
			#$firstBorn=($firstBorn - (randomNumber(0.01 - 0.1) * $firstBorn)

		elif (($totalEnergy < $firstBorn)); then
			(( totalEnergy = (totalEnergy - firstBorn) ))
			(( firstBorn = (firstBorn - totalEnergy) ))
			(( totalEnergy = 10 ))
		else
			echo "ERROR: A problem occurred during the repro branch."
			exit
		fi
	else
		echo "Simulation complete."
		printf "Cycle: $cycle \n" >> ~/Desktop/aiprog.txt
		printf "The first have become extinct. \n" >> ~/Desktop/aiprog.txt
		printf "\n" >> ~/Desktop/aiprog.txt
		exit
	fi

	if (( (($RANDOM % evoChance) + 1) == 1)) && (($totalEnergy >= $firstBorn)); then
		if (($firstBorn >= 100)); then
			(( secondBorn = ( secondBorn + (($RANDOM % range) + 1) ) ))
			(( firstBorn = ( firstBorn - (($RANDOM % range) + 1) ) )) #Fix random number here to match above
			printf "\n" >> ~/Desktop/aiprog.txt
			printf "Cycle: $cycle \n" >> ~/Desktop/aiprog.txt
			printf "The second have arrived! \n" >> ~/Desktop/aiprog.txt
			printf "\n" >> ~/Desktop/aiprog.txt
		else 
			(( firstBorn = ( firstBorn - (($RANDOM % range) + 1) ) ))
			printf "\n" >> ~/Desktop/aiprog.txt
			printf "Pool not diverse enough for evolution." >> ~/Desktop/aiprog.txt
			printf "\n" >> ~/Desktop/aiprog.txt
		fi
	else
		printf ""
	fi

	printf "Cycle: $cycle \n" >> ~/Desktop/aiprog.txt
	printf "Total energy: $totalEnergy \n" >> ~/Desktop/aiprog.txt
	printf "Total First: $firstBorn \n" >> ~/Desktop/aiprog.txt
	printf "Total Second: $secondBorn \n" >> ~/Desktop/aiprog.txt
	printf "\n" >> ~/Desktop/aiprog.txt

	(( tick = (tick - 1) ))
	(( cycle = (cycle + 1) ))
done

printf "SIMULATION COMPLETE" >> ~/Desktop/aiprog.txt
echo "Simulation complete."
exit
