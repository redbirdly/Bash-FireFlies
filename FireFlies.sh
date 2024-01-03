#!/bin/bash

# Function to initialize a firefly
initialize_firefly() {
    local x=$1
    local y=$2
    local duration=$3

    for ((i=0; i<duration; i++))
    do
        random_number=$((RANDOM % 3 - 1))
        random_number2=$((RANDOM % 3 - 1))

        # Erase the previous character
        echo -ne "\033[${prev_y};${prev_x}H \033[${prev_y};${prev_x}H"

        # Update x and y with random numbers
        x=$((x + random_number))
        y=$((y + random_number2))

        # Limit x and y to stay within the specified range
        x=$((x < 1 ? 1 : (x > 128 ? 128 : x)))
        y=$((y < 1 ? 1 : (y > 48 ? 48 : y)))

        # Randomly select a color between black, yellow, and lime
        color_code=$((RANDOM % 3))
        case $color_code in
            0) color="\033[30m";;  # Black
            1) color="\033[33m";;  # Yellow
            2) color="\033[32m";;  # Lime
        esac

        # Set color and move cursor to the limited (x, y) position and print '*'
        echo -ne "\033[${y};${x}H${color}*"

        # Update previous position
        prev_x=$x
        prev_y=$y
    done
}

# Array of firefly positions
firefly_positions=(
    "20 10"
    "80 20"
    "40 30"
    "100 5"
)

# Run each firefly in the background
for position in "${firefly_positions[@]}"
do
    # Split position into x and y coordinates
    IFS=' ' read -r x y <<< "$position"

    # Initialize previous position
    prev_x=$x
    prev_y=$y

    # Run the initialize_firefly function in the background
    initialize_firefly "$x" "$y" 200 &
done

# Wait for all background processes to complete
wait
