###Making a bondGrid function that accepts arguments




function xxxxxxx {
	xxxxxx="grid"$1
	if (($gridNumber[1] + $gridNumber[5] >= 1)); then
		
		generateRandom "${$gridNumber[1]} + ${$gridNumber[5]}"
		bondAttempts=$randNum

		for (( bondAttempts; bondAttempts > 0; bondAttempts-- )); do
			
			if (($gridNumber[1] >= 1 && $gridNumber[5] >= 1)); then
			
				generateRandom 2
				
				if (($randNum == 0)); then		#Posit is bonding
					
					generateRandom 3
					
					if (($randNum == 0 && $gridNumber[1] > 1)); then	#Posit hit another Posit
						
						generateRandom 3
						
						if (($randNum == 1)) && [[ "$gridNumber" == *0* ]]; then
							(($gridNumber[1] = $gridNumber[1] - 1))
							((grid01[1] = grid01[1] + 1))
						elif (($randNum == 2)); then
							(($gridNumber[1] = $gridNumber[1] - 1))
							((grid02[1] = grid02[1] + 1))
						else
							(($gridNumber[1] = $gridNumber[1]))
						fi

					elif (($randNum == 1 && $gridNumber[3] >= 1)); then
						
						(($gridNumber[1] = $gridNumber[1] - 1))
						((leftoverP++))
						#Will need to add the code here

					elif (($randNum == 2 && $gridNumber[5] >= 1)); then

						(($gridNumber[1] = $gridNumber[1] - 1))
						(($gridNumber[5] = $gridNumber[5] - 1))
						(($gridNumber[3] = $gridNumber[3] + 1))
						
					else
						
						(($gridNumber[1] = $gridNumber[1]))

					fi

				elif (($randNum == 1)); then	#Negatrit is bonding
					
					generateRandom 3
					
					if (($randNum == 0 && $gridNumber[1] >= 1)); then

						(($gridNumber[1] = $gridNumber[1] - 1))
						(($gridNumber[5] = $gridNumber[5] - 1))
						(($gridNumber[3] = $gridNumber[3] + 1))
						
					elif (($randNum == 1 && $gridNumber[3] >= 1)); then
						
						(($gridNumber[5] = $gridNumber[5] - 1))
						((leftoverE++))

					elif (($randNum == 2 && $gridNumber[5] > 1)); then
						
						generateRandom 3
						
						if (($randNum == 1)); then
							(($gridNumber[5] = $gridNumber[5] - 1))
							((grid01[5] = grid01[5] + 1))
						elif (($randNum == 2)); then
							(($gridNumber[5] = $gridNumber[5] - 1))
							((grid02[5] = grid02[5] + 1))
						else
							(($gridNumber[5] = $gridNumber[5]))
						fi

					else
						
						(($gridNumber[5] = $gridNumber[5]))

					fi

				else

					(($gridNumber[@] = $gridNumber[@]))

				fi

			elif (($gridNumber[1] >= 1 && $gridNumber[5] <= 0)); then

				generateRandom 2
					
					if (($randNum == 0 && $gridNumber[1] > 1)); then	#Posit hit another Posit
						
						generateRandom 3
						
						if (($randNum == 1)); then
							(($gridNumber[1] = $gridNumber[1] - 1))
							((grid01[1] = grid01[1] + 1))
						elif (($randNum == 2)); then
							(($gridNumber[1] = $gridNumber[1] - 1))
							((grid02[1] = grid02[1] + 1))
						else
							(($gridNumber[1] = $gridNumber[1]))
						fi

					elif (($randNum == 1 && $gridNumber[3] >= 1)); then
						
						(($gridNumber[1] = $gridNumber[1] - 1))
						((leftoverP++))
						#Will need to add the code here
						
					else
						
						(($gridNumber[1] = $gridNumber[1]))

					fi

			elif (($gridNumber[5] >= 1 && $gridNumber[1] <= 0)); then
				
				generateRandom 2
					
					if (($randNum == 0 && $gridNumber[3] >= 1)); then

						(($gridNumber[5] = $gridNumber[5] - 1))
						((leftoverE++))

					elif (($randNum == 1 && $gridNumber[5] > 1)); then #Negatrit hit another Negatrit
						
						generateRandom 3
						
						if (($randNum == 1)); then
							(($gridNumber[5] = $gridNumber[5] - 1))
							((grid01[5] = grid01[5] + 1))
						elif (($randNum == 2)); then
							(($gridNumber[5] = $gridNumber[5] - 1))
							((grid02[5] = grid02[5] + 1))
						else
							(($gridNumber[5] = $gridNumber[5]))
						fi

					else
						
						(($gridNumber[5] = $gridNumber[5]))

					fi

			else

				bondAttempts=0

			fi

		done

	else

		(($gridNumber[@] = $gridNumber[@]))
		
	fi
}