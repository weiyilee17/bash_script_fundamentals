#! /bin/bash

# This script executes all arguments as a single command on every server listed in the /vagrant/servers file by default.

SERVER_FILE='/vagrant/servers'

usage() {
  echo "Usage: ${0} [-vsn] [-f FILE] COMMAND" >&2
  echo "Executes COMMAND as a single command on all the servers in ${SERVER_FILE}"
  echo '  -f FILE   Specity the file that lists all servers.'
  echo '  -n        Displaying the COMMAND rather than executing them.'
  echo '  -s        Runs the COMMAND with sudo privilages on the remote servers.'
  echo '  -v        Increase verbosity. Displays the server name before executing COMMAND.'

  exit 1
}

if [[ "${UID}" -eq 0 ]]; then
  echo "Do not execute this script as root. Use the -s option instead." >&2
  usage
fi

while getopts vsnf: OPTION; do
  case ${OPTION} in
  v)
    VERBOSE='true'
    ;;
  s)
    SUDO='sudo'
    ;;
  n)
    DRY_RUN='true'
    ;;
  f)
    SERVER_FILE="${OPTARG}"
    ;;
    # getopts provides a single char at a time, hence ? is enough for catch all
  ?)
    usage
    ;;
  esac

done

shift "$((OPTIND - 1))"

# At least 1 command should be executed
if [[ "${#}" -eq 0 ]]; then
  usage
fi

if [[ ! -e "${SERVER_FILE}" ]]; then
  echo "Can not open server list file ${SERVER_FILE}" >&2
  exit 1
fi

SSH_OPTIONS='-o ConnectTimeout=2'

# The command to be executed can also be ${@}

for SERVER in $(cat ${SERVER_FILE}); do
  if [[ "${VERBOSE}" = 'true' ]]; then
    echo "Server: ${SERVER}"
  fi

  COMMAND="ssh ${SSH_OPTIONS} ${SERVER} ${SUDO} ${*}"

  if [[ "${DRY_RUN}" = 'true' ]]; then
    echo "DRY RUN: ${COMMAND}"
  else
    ${COMMAND}

    SSH_EXIT_STATUS="${?}"

    if [[ "${SSH_EXIT_STATUS}" -ne 0 ]]; then
      echo "Command ${COMMAND} failed." >&2
    fi
  fi
done

exit ${SSH_EXIT_STATUS}
