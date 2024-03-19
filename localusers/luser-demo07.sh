#! /bin/bash

# Demonstrate the use of shift and while loops.
# shift removes first argument, just like js array function.
# can support number to shift by number

# Loop through all the positional parameters.
while [[ "${#}" -gt 0 ]]; do
  echo "Number of parameters: ${#}"
  echo "Parameter 1: ${1}"
  echo "Parameter 2: ${2}"
  echo "Parameter 3: ${3}"
  echo
  shift
done
