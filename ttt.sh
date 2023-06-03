#!/bin/bash
field_size=3 # means 3x3
field=""
for (( i=1; i <= field_size*field_size; i++ ))
do
	if [[ "$field" == "" ]]; then
		field="$i"
	else
		field="$field $i"
	fi
done

player_char="x"
bot_char="o"

row=""
bot_pick=""
player_won=false
for player_pick in 4 5 6
do
	echo -e ""
	cell_i=1
	new_field=""
	player_row_score=0
	for cell in $field
	do

		if [[ "$cell_i" == "$player_pick" ]]; then
			cell="$player_char"
		fi
		if [[ "$cell_i" == "$bot_pick" ]]; then
			cell="$bot_pick"
		fi

		if [[ "$cell" == "$player_char" ]]; then
			((player_row_score++))
			echo player score now "$player_row_score"
		fi

		if [[ "$row" == "" ]]; then
			row="$cell"
		else
			row="$row $cell"
		fi

		if [[ $(( cell_i % field_size )) == 0 ]]; then
			echo "$row"
			row=""
			if [[ "$player_row_score" -eq $field_size ]]; then
				player_won=true
			fi
			player_row_score=0
		fi

		if [[ "$new_field" == "" ]]; then
			new_field="$cell"
		else
			new_field="$new_field $cell"
		fi

		((cell_i++))
	done
	field="$new_field"
	if [[ "$player_won" == "true" ]]; then
		echo player won
		break
	fi
done
