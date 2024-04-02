#!/bin/bash

#psql connection
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# get username
echo "Enter your username:"
read USERNAME

# insert new username or check existant user
CHECK_USERNAME(){
	CHECK_USERNAME=$($PSQL "SELECT * FROM users WHERE username = '$USERNAME'")
	GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username = '$USERNAME'")
	BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username ='$USERNAME' ")
	if [[ $CHECK_USERNAME ]];	then
		echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
		NUMBER_GUESS_GAME
	elif [[ -z $CHECK_USERNAME ]];	then
		echo "Welcome, $USERNAME! It looks like this is your first time here."
		INSERT_USERNAME=$($PSQL "INSERT INTO users (username, games_played, best_game) VALUES('$USERNAME', 0,0)")
		NUMBER_GUESS_GAME
	fi
}

# number guess game code
NUMBER_GUESS_GAME(){
	# generating a secret number between 1 and 1000
	SECRET_NUMBER=$((1 + RANDOM % 1000))
	echo "Guess the secret number between 1 and 1000:"
	# guesses counter
	NUMBER_OF_GUESSES=0
	# Loop until guess the number
	while true; do
		(( NUMBER_OF_GUESSES++ ))
		read -p "Your try:" USER_NUMBER
		#check if the input is a valid number
		if ! [[ $USER_NUMBER =~ [0-9]+$ ]]; then
			echo That is not an integer, guess again:
			continue
		fi
		# Check if the attempt is right
		if (( $USER_NUMBER == $SECRET_NUMBER )); then
			echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
			SET_BEST_GAME
			break
		elif (( $USER_NUMBER < $SECRET_NUMBER ));then
			echo "It's higher than that, guess again:"
		else
			echo "It's lower than that, guess again:"
		fi	
	done
}

#Increments games_played and set best game
SET_BEST_GAME(){
	INCREMENT_GAMES_PLAYED=$($PSQL "UPDATE users SET games_played = games_played + 1 WHERE username = '$USERNAME'")
	BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username = '$USERNAME'")
			if [[ $BEST_GAME = 0 ]]
			then
				NEW_BG=$($PSQL "UPDATE users SET best_game = $NUMBER_OF_GUESSES WHERE username = '$USERNAME'")
			elif
				[[ $NUMBER_OF_GUESSES < $BEST_GAME ]]
				then
					NEW_BG=$($PSQL "UPDATE users SET best_game = $NUMBER_OF_GUESSES WHERE username = '$USERNAME'")
			fi	
}

CHECK_USERNAME
