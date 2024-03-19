#! /bin/bash

# This script generates a list of random passwords

# A random number as a password.
PASSWORD="${RANDOM}"
echo "${PASSWORD}"

# Three random numbers together.
PASSWORD="${RANDOM}${RANDOM}${RANDOM}"
echo "${PASSWORD}"

# Use the current date/time as the basis for the password.
PASSWORD=$(date +%s)
echo "${PASSWORD}"

# Add nanoseconds information to randomize even more
PASSWORD=$(date +%s%N)
echo "${PASSWORD}"

# Combine with sha256 to get even more randomized data, and get the first 32 char
PASSWORD=$(date +%s%N | sha256sum | head -c32)
echo "${PASSWORD}"

# An even better password.
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c48)
echo "${PASSWORD}"

# Get 1 special char and append it to password
# shuf command randomizes lines of files
# fold command turns string to 1 char per line with the -w 1 option
# we can define special chars string, and pipe them together, and get the first char

SPECIAL_CHAR=$(echo '!@#$%^&*()_+-=' | fold -w 1 | shuf | head -c1)
echo "${PASSWORD}${SPECIAL_CHAR}"
