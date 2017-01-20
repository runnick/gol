#!/bin/bash
# In use: abc i
clear
. nbfunction.sh
cycle=9


createGrid 64
spawnBit 25
echo "Starting..."
echo "-------------"
displayGrid
echo "-------------"
sleep 2

echo ""
# echo "Bit array"
# echo "${bitLocations[@]}"
# echo ""
until (( "$cycle" == 0 )); do
	loop=0
	getBits
	while (( "${#bitLocations[@]}" > "$loop" )); do
		clear
		#echo "${#bitLocations[@]}"
		#echo "Moving Bit at grid"${bitLocations[$loop]:4}
		localAreaBits ${bitLocations[$loop]:4}
		selectMove
		moveBit ${bitLocations[$loop]} $moving
		echo "-------------"
		displayGrid
		echo "-------------"
		((loop++))
		sleep 0.1
		echo ""

	done
	((cycle--))
done


exit





