#! /bin/bash

# The following is information related to network settings, ssh and exit status

# When pinging an url, we check the /etc/hosts first,
# If there is no entries there, we then go to a dns server
# To avoid the overhead of setting up a dns server for the 3 vms, we can edit the /etc/hosts with the command
# echo '10.9.8.11 server01' | sudo tee -a /etc/hosts

# Why use tee when we can use sudo echo test >> /etc/hosts ?
# The reason is sudo runs echo with root permission, but >> is still executed as normal user

# ssh-keygen to generate key for ssh to access other 2 vms
# with out passphrase, we don't have to enter password when connecting to the other 2 servers

# Put the public key on the remote system
# ssh-copy-id server01

# Can access server01 by ssh server01

# Can run hostname command on server01 with ssh server01 hostname
# It connects to server01, executes the command, and exits

# ssh server01 'ps -ef | head -3'
# without the quotes, the head is executed on admin01, not server01
# ssh server01 ps -ef | head -3

# ssh returns the exit status of romote command previously executed. If there is an error, it returns 255
# ssh server01 'false | true' -> exit status is 0
# ssh server01 'true | false' -> exit status is 1

# Any none 0 exit statuses to be returned if you are using a pipe on the remote system
# ssh server01 'set -o pipefail; false | true' -> exit status is 1

# The return value of a pipeline is the status of the last command to exit with a non-zero status,
# or zero if no command exited with a non-zero status

SERVER_FILE='/vagrant/servers'

if [[ ! -e "${SERVER_FILE}" ]]; then
  echo "Can not open ${SERVER_FILE}." >&2
  exit 1
fi

for SERVER in $(cat ${SERVER_FILE}); do
  echo "Pinging ${SERVER}"
  ping -c 1 ${SERVER} &>/dev/null

  if [[ "${?}" -ne 0 ]]; then
    # In real world, not being able to ping a server doesn't mean it is down. ping might be blocked by a firewall or something
    echo "${SERVER} down."
  else
    echo "${SERVER} up."
  fi
done

# ssh server01 sudo id runs id on server01 as root, but is connected as current user, vagrant
# sudo ssh server01 id executes ssh as root, so connects to server01 as root, using root, it executes id

# Some linux distributions don't allow root sshs, so would have to ssh in, then sudo command
