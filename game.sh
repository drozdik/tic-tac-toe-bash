#!/bin/bash
#
# game
#
game="on"

# prepare field 'array'
field=""
new_field=""
for (( i=1; i <= 9; i++ ))
do
	if [[ "$field" == "" ]]; then
		field="$i"
	else
		field="$field $i"
	fi
done

player_pick=""
round_i=1
#
# round
#
while [[ "$game" == "on" ]]; do


	#
	# diaplay and evaluate
	#
	options=""
	col1score=0
	col2score=0
	col3score=0
	diag1score=0 # 1row1col, 2row2col, 3row3col
	diag2score=0 # 1row3col, 2row2col, 3row1col
	row_score=0

	cell_i=1
	row_i=1
	col_i=1

	for cell in $field; do
		if [[ "$cell" != "x" ]] && [[ "$cell" != "o" ]]  && [[ "$cell_i" -ne "$player_pick" ]]; then
			options="$options $cell_i"
		fi
		#echo "value $cell cell $cell_i row $row_i column $col_i"
		if [[ "$cell_i" -eq "$player_pick" ]]; then
			cell="$player_sign"
		fi

		if [[ "$cell" == "$player_sign" ]]; then

			# row
			((row_score++))
			if [[ "$row_score" -eq 3 ]]; then
				game_over_reason="Player won with row"
				game="over"
			fi

			# column
			col_score="col${col_i}score"
			((${col_score}++))
			if [[ ${col_score} -eq 3 ]]; then
				game_over_reason="Player won with column "$col_i""
				game="over"
			fi

			# diagonal 1
			if [[ "$row_i $col_i" == "1 1" ]] ||
				[[ "$row_i $col_i" == "2 2" ]] || 
				[[ "$row_i $col_i" == "3 3" ]]; then
							((diag1score++))
			fi
			if [[ ${diag1score} -eq 3 ]]; then
				game_over_reason="Player won with diagonal 1"
				game="over"
			fi

			# diagonal 2
			if [[ "$row_i $col_i" == "1 3" ]] ||
				[[ "$row_i $col_i" == "2 2" ]] || 
				[[ "$row_i $col_i" == "3 1" ]]; then
							((diag2score++))
			fi
			if [[ ${diag2score} -eq 3 ]]; then
				game_over_reason="Player won with diagonal 2"
				game="over"
			fi
		fi


		# printable row
		if [[ "$row" == "" ]]; then
			row="$cell"
		else
			row="$row $cell"
		fi


		((col_i++))
		if [[ $((cell_i%3)) -eq 0 ]]; then
			((row_i++))
			col_i=1
			row_score=0
			echo "$row"
			row=""
		fi

		if [[ "$new_field" == "" ]]; then
			new_field="$cell"
		else
			new_field="$new_field $cell"
		fi

		((cell_i++))
	done
	field="$new_field"
	new_field=""

	# finish game with draw if run out of options
	if [[ -z "$options" ]]; then
		game="over"
		game_over_reason="DRAW"
	fi

	# ask for a turn or print game over screen
	if [[ "$game" == "over" ]]; then
		echo GAME OVER
		echo "$game_over_reason"
		exit 0
	fi

	#
	# player action
	#
	if [[ $((round_i%2)) -eq 1 ]]; then
		active_player="player 1"
		player_sign="x"
	else
		active_player="player 2"
		player_sign="o"
	fi

	if [[ "$active_player" == "player 2" ]]; then
		echo
		echo bot playing
		echo

		bot_pick=""
		prefered=""

		if [[ "$col1score" -eq 2 ]]; then
			prefered="${prefered}147"
		fi

		if [[ "$col2score" -eq 2 ]]; then 
			prefered="${prefered}258"
		fi

		if [[ "$col3score" -eq 2 ]]; then 
			prefered="${prefered}369"
		fi

		if [[ "$diag1score" -eq 2 ]]; then 
			prefered="${prefered}159"
		fi

		if [[ "$diag2score" -eq 2 ]]; then 
			prefered="${prefered}357"
		fi

		prefered="[$prefered]"

		echo prefered are "$prefered"
		echo options "$options"
		echo col1score "$col1score"
		echo col2score "$col2score"
		echo col3score "$col3score"
		echo diag1score "$diag1score"
		echo diag2score "$diag2score"
		echo row_score "$row_score"
		echo
		for i in $options; do
			if [[ "$i" =~ ${prefered} ]]; then
				bot_pick="$i"
				break
			fi
		done
		if [[ "$bot_pick" == "" ]]; then
			echo 000 bot chooses random
			for i in $options; do
				bot_pick="$i"
				break
			done
		fi

		player_pick="$bot_pick"
		echo bot chose "$i"
		((round_i++))
		continue
	fi

	echo -e ""
	#echo options are "$options"
	echo "$active_player ($player_sign)," press cell number or 0 to quit
	read input
	if [[ "$input" =~ [0-9] ]]; then
		if [[ "$input" -eq 0 ]]; then
			echo quitting
			exit 0
		fi
		player_pick="$input"
	else
		echo chose number from 0 to 9
		continue
	fi

	# check if input corresponds to x or o, then go to next iteration without increasing round, means without changing player
	option="invalid"
	for i in $options; do
		if [[ "$i" -eq "$input" ]]; then
			option="valid"
		fi
	done
	if [[ "$option" == "invalid" ]]; then
		echo "$input" is not a valid option
		player_pick=""
		continue
	fi

	echo you chose "$input"

	((round_i++))
done
