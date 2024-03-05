#!/bin/bash

# Check if git is installed
if ! command -v git &> /dev/null
then
    echo "git could not be found. Please install git to continue."
    exit 1
fi

# Directory to store OSINT Tools
tools_dir="$HOME/OSINTTools"

# Photon repository and local path
photon_repo="https://github.com/s0md3v/Photon.git"
photon_dir="$tools_dir/Photon"

# Check if Photon is installed, if not, clone it from GitHub
if [ ! -d "$photon_dir" ]; then
    echo "Photon not found, downloading..."
    mkdir -p "$tools_dir"
    git clone "$photon_repo" "$photon_dir"
    echo "Photon downloaded."
fi

# Store the command in a variable using dynamic path
python3=$(which python3)
photon="$photon_dir/photon.py"

# Directory to store the results
results="$tools_dir/results"

# Check if the results directory exists, if not, create it
if [ ! -d "$results" ]; then
    mkdir -p "$results"
fi

while true; do
    clear
    echo "=============================================================================="
    echo "Photon Scanner:"
    echo "=============================================================================="
    echo "1. Scan website"
    echo "2. Clone website"
    echo "3. Return to main menu"

    read -p "Select an option (1-3): " option

    if [ "$option" == "1" ]; then
        read -p "Enter the website URL to scan: " url
        website=$(basename "$url")
        destination_directory="$results/$website"

        echo "Creating directory $destination_directory and scanning $url ..."
        mkdir -p "$destination_directory"
        "$python3" "$photon" -u "$url" -o "$destination_directory"
        read -p "Press Enter to continue..."
    elif [ "$option" == "2" ]; then
        read -p "Enter the website URL to clone: " url
        website=$(basename "$url")
        destination_directory="$results/$website"

        echo "Creating directory $destination_directory and cloning $url ..."
        mkdir -p "$destination_directory"
        "$python3" "$photon" -u "$url" --clone -o "$destination_directory"
        read -p "Press Enter to continue..."
    elif [ "$option" == "3" ]; then
        break
    else
        echo "Invalid option. Please select a valid option."
        read -p "Press Enter to continue..."
    fi
done
