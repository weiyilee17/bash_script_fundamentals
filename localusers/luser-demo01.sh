#!/bin/bash

# This script displays various information to the screen.

# Display 'Hello'
echo 'Hello'

# Assign a value to a variable. By convention all variables are all cap
# no spaces around =
WORD='script'

# Display that value. '' are used to show text, "" are used to show variables
echo 'variable'
echo "$WORD"
echo 'exact string'
echo '$WORD'

# Another valid syntax
echo "This is a shell ${WORD}"

# This is the only way to concat strings,
echo "${WORD}ing is fun!"

ENDING='ed'

echo "This is ${WORD}${ENDING}."

ENDING='ing'

echo "${WORD}${ENDING} is fun."

ENDING='s'

echo "Your are going to write many ${WORD}${ENDING} in this class!"
