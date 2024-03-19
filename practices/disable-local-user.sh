#! /bin/bash

# This script deletes an user, with a number of options.

readonly ARCHIVE_DIR='/archives'

log_to_STDERR() {
  local MESSAGE="${@}"

  echo "${MESSAGE}" >&2
  exit 1
}

log_if_prev_command_failed() {
  local MESSAGE="${@}"

  if [[ "${?}" -ne 0 ]]; then
    log_to_STDERR ${MESSAGE}
  fi
}
# This may not be the best way of doing this
log_if_prev_command_succeded() {
  local MESSAGE="${@}"

  if [[ "${?}" -eq 0 ]]; then
    echo ${MESSAGE}
  fi
}

usage() {
  echo "Usage: ${0} [-dra] USER_NAME [USERN]..." >&2
  echo 'Delete a local Linux account..'
  echo '  -d Deletes accounts instead of disabling them.'
  echo
  echo '  -r Removes the home directory associated with the account(s).'
  echo
  # NOTE: /archives is not a directory that exists by default on a Linux system.
  # The script will need to create this directory if it does not exist.
  echo '  -a Creates an archive of the home directory associated'
  echo '       with the account(s) and stores the archive in the'
  echo '       /archives directory.'

  exit 1
}

if [[ "${UID}" -ne 0 ]]; then
  log_to_STDERR 'Please run with sudo or with as root.'
fi

# Parse the options
while getopts dra OPTION; do
  case ${OPTION} in
  d)
    DELETE_ACCOUNT='true'
    ;;
  r)
    REMOVE_HOME='true'
    ;;
  a)
    CREATE_ARCHIVE='true'
    ;;
  ?)
    usage
    ;;
  esac
done

shift $((OPTIND - 1))

# At least 1 user name should be provided
if [[ "${#}" -eq 0 ]]; then
  usage
fi

for USER_NAME in "${@}"; do

  USER_ID=$(id ${USER_NAME} -u)
  if [[ "${USER_ID}" -le 1000 ]]; then
    log_to_STDERR 'Only system accounts should be modified by system administrators. \n Only allow the help desk team to change user accounts.'
    continue
  fi

  chage -E 0 ${USER_NAME}
  log_if_prev_command_failed "Failed to disable user ${USER_NAME}"
  log_if_prev_command_succeded "Disabled user ${USER_NAME}"

  if [[ "${CREATE_ARCHIVE}" = 'true' ]]; then
    if [[ ! -d "${ARCHIVE_DIR}" ]]; then
      # For ARCHIVE_DIR = /archives, -p doesn't matter, but when it is /archives/a/b/c, -p would created the path if it doesn't exist
      mkdir -p ${ARCHIVE_DIR}
      log_if_prev_command_failed "Failed to create the archive directory ${ARCHIVE_DIR}"
      exit 1
    fi

    HOME_DIR="/home/${USER_NAME}"
    ARCHIVE_FILE="${ARCHIVE_DIR}/${USER_NAME}.tar"

    tar -cvf "${ARCHIVE_FILE}" "${HOME_DIR}"
    log_if_prev_command_failed "Failed to archive home directory for user ${USER_NAME}"
    log_if_prev_command_succeded "Archived home directory for user ${USER_NAME}"
  fi

  if [[ "${DELETE_ACCOUNT}" = 'true' ]]; then
    userdel ${USER_NAME}
    log_if_prev_command_failed "Failed to delete user ${USER_NAME}"
    log_if_prev_command_succeded "Deleted user ${USER_NAME}"
  fi

  if [[ "${REMOVE_HOME}" = 'true' ]]; then
    rm -rf "${HOME_DIR}"
    log_if_prev_command_failed "Failed to remove home directory for user ${USER_NAME}"
    log_if_prev_command_succeded "Removed home directory for user ${USER_NAME}"
  fi

done

exit 0
