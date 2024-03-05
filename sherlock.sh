#!/bin/bash

#  The script includes a loop for a menu allowing the user to choose between different search options and handles the creation of a directory for results.

# Check if git is installed
if ! command -v git &> /dev/null
then
    echo "git could not be found. Please install git to continue."
    exit 1
fi

# Directory to store Sherlock
tools_dir="$HOME/OSINTTools"

# Sherlock repository and local path
sherlock_repo="https://github.com/sherlock-project/sherlock.git"
sherlock_dir="$tools_dir/sherlock"

# Check if Sherlock is installed, if not, clone it from GitHub
if [ ! -d "$sherlock_dir" ]; then
    echo "Sherlock not found, downloading..."
    mkdir -p "$tools_dir"
    git clone "$sherlock_repo" "$sherlock_dir"
    echo "Sherlock downloaded."
fi

# Store the command in a variable
python3=$(which python3)
sherlock="$sherlock_dir/sherlock.py"

# Directory to store the results
results="$HOME/OSINTTools_results"

# Check if the results directory exists, if not, create it
if [ ! -d "$results" ]; then
    mkdir -p "$results"
fi

# Loop displaying the menu and waiting for the user's selection
while true; do
    clear
    echo "Select an option:"
    echo "1. Basic Search"
    echo "2. Multi-User Search"
    echo "3. Verbose Mode Search"
    echo "4. Search on All Platforms"
    echo "0. Exit"

    # Read the user's option
    read -p "Enter your choice: " option

    # Execute the selected option
    case $option in
        1)
            echo "Executing Basic Search..."
            read -p "Enter the username: " username
            date_time=$(date +"%Y%m%d%H%M%S")
            output_file="$results/sherlock_basic_search_$date_time.txt"
            $python3 $sherlock $username 2>&1 | tee "$output_file"
            ;;
        2)
            echo "Executing Multi-User Search..."
            read -p "Enter a list of usernames separated by spaces: " usernames
            $python3 $sherlock --folderoutput $results $usernames
            ;;
        3)
            echo "Executing Verbose Mode Search..."
            read -p "Enter the username: " username
            date_time=$(date +"%Y%m%d%H%M%S")
            output_file="$results/sherlock_verbose_$date_time.txt"
            $python3 $sherlock --verbose $username 2>&1 | tee "$output_file"
            ;;
        4)
            echo "Executing Search on All Platforms..."
            read -p "Enter the username: " username
            date_time=$(date +"%Y%m%d%H%M%S")
            output_file="$results/sherlock_all_platforms_$date_time.txt"
            $python3 $sherlock --print-all $username 2>&1 | tee "$output_file"
            ;;
        0)
            echo "Exiting the menu."
            exit 0
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
    read -p "Press Enter to continue..."
done
