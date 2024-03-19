#! /bin/bash

# This script generates a random password for each user specified on the command line.

# Display what the user typed on the command line.
echo "You executed this command: ${0}"
# a parameter is a variable that is being used inside the shell script
# an argument is the data passed into the shell script

# the 0 argument, for this file, is ./luser-demo06.sh, or /vagrant/luser-demo06.sh, if
# executed through absolute path
# if this file is moved to places like /usr/local/bin, 0 would be /usr/local/bin/luser-demo06.sh

# basename gets the file name without paths
# dirname gets the path without file name

# Display the path and file name of the script.
echo "You used $(dirname ${0}) as the path to the $(basename ${0}) script."

# Tell users how many arguments they passed in.
# (Inside the script they are parameters, outside they are arguments.)
NUMBER_OF_PARAMS="${#}"
echo "You supplied ${NUMBER_OF_PARAMS} argument(s) on the command line."

# Make sure users at least supply 1 argument in the command line
if [[ "${NUMBER_OF_PARAMS}" -lt 1 ]]; then
  echo "Usage: ${0} USER_NAME [USER_NAME]..."
  exit 1
fi

# Generate and display a password for each parameter.
# ${*} joins each parameter to a string, which is not what we want with a for loop
for USER_NAME in "${@}"; do
  PASSWORD=$(date +%s%N | sha256sum | head -c48)
  echo "user: ${USER_NAME}, password: ${PASSWORD}"
done
