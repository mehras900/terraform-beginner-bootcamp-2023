#!/usr/bin/env bash

# Define the target file
TARGET_FILE="$HOME/.bash_profile"

# Check if the alias already exists
grep -q "alias tf='terraform'" $TARGET_FILE

# If the alias doesn't exist (grep's exit status is non-zero), append it
if [ $? -ne 0 ]; then
    echo "alias tf='terraform'" >> $TARGET_FILE
    echo "Alias added to $TARGET_FILE."
else
    echo "Alias already exists in $TARGET_FILE."
fi

source ~/.bash_profile