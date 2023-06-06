field0="1 2 3 4 5 6 7 8 9"
field1="x x x 4 5 6 7 8 9"
field2="x 2 3 x 5 6 x 8 9"
field22="1 x 3 4 x 6 7 x 9"
field23="1 2 x 4 5 x 7 8 x"
field3="x 2 3 4 x 6 7 8 x"
field4="1 2 x 4 x 6 x 8 9"
echo bla
# row is pretty simple
# columns i need to keep track of 
col1score=0
col2score=0
col3score=0
diag1score=0 # 1row1col, 2row2col, 3row3col
diag2score=0 # 1row3col, 2row2col, 3row1col
row_score=0

field="$field3"
cell_i=1
row_i=1
col_i=1
for cell in $field; do
	echo "value $cell cell $cell_i row $row_i column $col_i"
	if [[ "$cell" == 'x' ]]; then
		((row_score++))
		echo row score is "$row_score"
		if [[ "$row_score" -eq 3 ]]; then
			echo Player won with row
			exit 0
		fi

		col_score="col${col_i}score"
		((${col_score}++))
		if [[ ${col_score} -eq 3 ]]; then
			echo Player won with column "$col_i"
			exit 0
		fi

		# diagonal 1
		if [[ "$row_i $col_i" == "1 1" ]] ||
			[[ "$row_i $col_i" == "2 2" ]] || 
			[[ "$row_i $col_i" == "3 3" ]]; then
					((diag1score++))
		fi
		
		# diagonal 2
		if [[ "$row_i $col_i" == "1 3" ]] ||
			[[ "$row_i $col_i" == "2 2" ]] || 
			[[ "$row_i $col_i" == "3 1" ]]; then
					((diag2score++))
		fi

	fi

	((col_i++))
	if [[ $((cell_i%3)) -eq 0 ]]; then
		((row_i++))
		row_score=0
		col_i=1
	fi
	((cell_i++))
done

if [[ ${diag1score} -eq 3 ]]; then
	echo Player won with diagonal 1
fi

if [[ ${diag2score} -eq 3 ]]; then
	echo Player won with diagonal 2
fi

echo col1score is "$col1score"
