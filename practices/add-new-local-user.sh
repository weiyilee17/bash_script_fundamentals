#! /bin/bash

# Enforces that it be executed with superuser (root) privileges.  If the script is not executed with superuser privileges it will not attempt to create a user and returns an exit status of 1.
if [[ "${UID}" -ne 0 ]]; then
  echo 'Please run with sudo or as root.'
  exit 1
fi

if [[ "${#}" -lt 1 ]]; then
  echo "Usage: ${0} USER_NAME [COMMENT]..."
  echo "Create an account on the local system with the name of USER_NAME and a comments field of COMMENT."
  exit 1
fi

USER_NAME="${1}"
shift
# The rest of the parameters are for the account comments.
COMMENT="${@}"

# Creates a new user on the local system with the input provided by the user.
adduser -c "${COMMENT}" -m ${USER_NAME}

# Informs the user if the account was not able to be created for some reason.  If the account is not created, the script is to return an exit status of 1.
ADD_USER_EXIT_CODE="${?}"
if [[ ADD_USER_EXIT_CODE -ne 0 ]]; then
  echo "adduser failed with exit code ${ADD_USER_EXIT_CODE}"
  exit 1
fi

PASSWORD=$(date +%s%N | sha256sum | head -c48)

# pipe the output of echo PASSWORD as the input of passwd
echo ${PASSWORD} | passwd --stdin ${USER_NAME}
PASSWD_EXIT_CODE="${?}"
if [[ PASSWD_EXIT_CODE -ne 0 ]]; then
  echo "The password failed to be set with exit code ${PASSWD_EXIT_CODE}"
  exit 1
fi

# Force password change on first login
passwd -e ${USER_NAME}

echo
# Displays the username, password, and host where the account was created.  This way the help desk staff can copy the output of the script in order to easily deliver the information to the new account holder.
echo "Created username ${USER_NAME} for ${COMMENT}. The password is ${PASSWORD}."

# HOSTNAME is a bash variable
echo "Created in host: ${HOSTNAME}"

exit 0
