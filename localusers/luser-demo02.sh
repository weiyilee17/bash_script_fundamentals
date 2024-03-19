#!/bin/bash

# Display the UID and username of the user executing this script.
# Display if the user is the root user or not.

# Display the UID
echo "Your UID is ${UID}"

# Display the username
# instead of $(), can also wrap by ``, an older syntax
USER_NAME=$(id -un)
echo "Your username is ${USER_NAME}"
ME=$(whoami)
echo "Your username is ${ME}"

# Display if the user is the root user or not.
# ; seperates commands, and is replacable with new line
# [[]] is bash specific. [] also works, but is an older way
if [[ "${UID}" -eq 0 ]]; then
  echo 'You are root.'
else
  echo 'You are not root.'
fi
