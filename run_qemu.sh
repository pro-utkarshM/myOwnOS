#!/bin/bash

# # Check if the user provided the file location
# if [ -z "$1" ]; then
#     echo "Usage: $0 <path-to-os.bin>"
#     exit 1
# fi

# Get the file location from the argument
OS_BIN="./bin/os.bin"

# Check if the specified file exists
if [ ! -f "$OS_BIN" ]; then
    echo "Error: File '$OS_BIN' does not exist."
    exit 1
fi

# Run QEMU with the provided OS binary file
qemu-system-x86_64 -hda "$OS_BIN"
