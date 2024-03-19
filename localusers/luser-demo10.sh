#! /bin/bash

# This script demonstates the use case of functions
log3() {
  echo 'You called the log function'

}
function log2 {
  echo 'You called the log2 function'

}

log_with_logger() {
  # This function sends a message to syslog and to standard output if VERBOSE is true
  local MESSAGE="${@}"

  if [[ "${VERBOSE}" = 'true' ]]; then
    echo "${MESSAGE}"
  fi

  # logger logs to /var/log/messages, and to see the content, you need root permission
  # logger 'Hello from the command line!'
  # sudo tail /var/log/messages
  logger -t luser-demo10.sh "${MESSAGE}"
}

# executing function like commands
log3

backup_file() {
  # This function creates a backup of a file. Returns non-zero status on error.

  local FILE="${1}"

  # Make sure the file exists.
  if [[ -f "${FILE}" ]]; then
    # Files in /var/tmp servive reboots, while files in tmp are not guaranteed to
    # In centos, files in /var/tmp are default to be cleared in 30 days, while file in tmp are in 10
    # F for full date (year, month date in numbers). To differentiate between different back up files
    # in the same day, we add the nano second option
    local BACKUP_FILE="/var/tmp/$(basename ${FILE}).$(date +%F-%N)"

    log_with_logger "Backing up ${FILE} to ${BACKUP_FILE}"

    # The exit status of the function will be the exit status of the cp command.
    # p is for preserve, preserving the files modes, timestamps and ownerships
    # when you recover the file, you then have the original timestamp
    cp -p ${FILE} ${BACKUP_FILE}
  else
    # The file does not exist, so return a non-zero exit status.
    echo "${FILE} does not exist."
    # In functions, we should return, not exit. exit exits the entire script
    return 1
  fi
}

log_with_logger 'Hello'
VERBOSE='true'
log_with_logger 'This is fun!'

# like constant
readonly VERBOSITY='true'

backup_file '/etc/passwd'

# Make a decision based on the exit status of the function.
if [[ "${?}" -eq '0' ]]; then
  log_with_logger 'File backup succeeded!'
else
  log_with_logger 'File backup failed!'
fi
