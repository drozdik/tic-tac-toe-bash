game="on"
while [[ "$game" == "on" ]]; do
	echo press cell number or 0 to quit
	read input
	read input
	if [[ "$input" -eq 0 ]]; then
		echo quitting
		exit 0
	fi
	echo you chose "$input"
done
