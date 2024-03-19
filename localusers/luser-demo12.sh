#! /bin/bash

# userdel is the command to delet users, but it can't be found in
# type -a or which
# locate searches for the file, but it's using cache.
# the cache updates once per day, so files added recently won't be recognized

# Can invalidate cache using command sudo updatedb
# locate only scan through files it has permission to read
# so the result of sudo locate and locate would, in a lot of cases, be different
# sudo !! would execute the prev command with sudo privilege

# normal commands are usually found in bin directory
# system admin commands are usually found in sbin directory

# find is a command similar to locate, but does it in realtime, so is slower
# ex. find /usr/sbin/ -name userdel
# find / -name userdel 2>/dev/null when you have no idea where the file is
# 2>/dev/null is because there are a lot of files that normal file has no premission
# to access.
# Alternatively, this commmand can be run with sudo

# When we use ls -l and see user and group are numbers, not names, that means the owner
# has been deleted

# System accounts have UID less than 1000, so should not be removed

# use grep to filter results
# locate userdel | grep bin

# -r removes the home directory
# sudo userdel -r isaac

# 2 step archive and compress

# tar -cvf catvideos.tar catvideos/
# same as tar -f catvideos.tar -c -v catvideos/

# gzip compresses the file
# gzip catvideos.tar

# gunzip catvideos.tar.gz

# 1 step archive and compress
# z: compress, c: create an archive, v: verbose, f: filename and path
# file extension can also be tgz
# tar -zcvf catvideos.tar.gz catvideos/

# view the content of compressed archive
# t: list
# tar -ztvf catvideos.tar.gz

# restore the content
# tar -zxvf /home/vagrant/catvideos

# !$ is the last argument of the prev command
# echo 'hello' > catvideos/darthpaw.mp4
# cat !$

# this overwrites the hello in catvideos/darthpaw.mp4
# tar -zxvf ../catvideos.tgz

# tar doesn't archive files without permission, and doesn't extracts to locations where it doesn't have permission

# If we don't want a user's account to be accessed in a period of time, ex. an employee is in a long vacation,
# we can use the chage command to expire the account so it can't be accessed, and to it again after the employee is back
# ex sudo chage -E 0 woz  # lock the account woz
# sudo chage -E -1 woz  # reopen the account woz

# sudo passwd -l woz  # locks the user
# sudo passwd -u woz  # unlocks the user
# However, it doesn't prevent authenticating user with a ssh key, so this should not be used

# cat /etc/shells list all shells

# changes the shell of user woz also prevent woz from logging in, but there are things that can be
# done via ssh that doesn't require a shell, ex. port forwarding
# sudo usermod -s /sbin/nologin woz

###

# This script deletes a user.

# Run as root.
if [[ "${UID}" -ne 0 ]]; then
  echo 'Please run with sudo or as root.' >&2
  exit 1
fi

# Assume the first argument is the user to delete.
USER="${1}"

# Delete the user
userdel ${USER}

# Make sure the user got deleted
if [[ "${?}" -ne 0 ]]; then
  echo "The account ${USER} was NOT deleted." >&2
  exit 1
fi

echo "The account ${USER} was deleted."

exit 0
