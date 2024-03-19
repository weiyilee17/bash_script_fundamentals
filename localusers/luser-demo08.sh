#! /bin/bash

# This script demonstrates I/O redirection.

# Redirct STDOUT to a file.
FILE="/tmp/data"
# > overwrites data on the right hand side, and creates file if not exist
# >> appends content to existing file content
head -n 1 /etc/passwd >${FILE}

# Redirect STDIN to a program.
# read takes 1 line of input from the command line
# When using files, it also read 1 line from the file
# In the code below, it stores the content to variable LINE
read LINE <${FILE}
echo "Line contains: ${LINE}"

# Redirect STDOUT to a file, overwriting the file.
head -n 3 /etc/passwd >${FILE}
echo

echo "Contents of ${FILE} after overwriting 3 lines:"
cat ${FILE}

# Redirect STDOUT to a file, appending to the file.
echo "${RANDOM} ${RANDOM}" >>${FILE}
echo "${RANDOM} ${RANDOM}" >>${FILE}
echo
echo "Contents of ${FILE} after appending 2 lines:"
cat ${FILE}

# File descriptions: 0: STDIN, 1: STDOUT, 2: STDERR
# Can explicitly type the file description to redirect.
# ex. head -n 1 /etc/passwd /file2 /file2 1> head.out 2>> head.err
# read LINE 0< /etc/passwd

# send STDOUT, STDERR to the same place
# &1 is not a file, it is a file descriptor
# STDERR is appended to head.both
# old syntax: head -n 1 /etc/passwd /etc/hosts > head.both 2>&1
# new syntax: head -n 1 /etc/passwd /etc/hosts &> head.both

# >> for concatenation: head -n 1 /etc/passwd /etc/hosts &>> head.both

# | takes STDOUT as the input of the next command
# if we want to also include STDERR, we can use 2>&1 as well, ex.
# head -n 1 /etc/passwd /etc/hosts 2>&1 | cat -n
# or
# head -n 1 /etc/passwd /etc/hosts |& cat -n

# Redirect STDIN to a program, using FD 0
read LINE 0<${FILE}
echo
echo "LINE contains: ${LINE}"

# Redirect STDOUT to a file using FD 1 overwritting the file.
head -n 3 /etc/passwd 1>${FILE}
echo
echo "Contents of ${FILE}:"
cat ${FILE}

# Redirect STDERR to a file using FD 2.
# this file doesn't exist
ERR_FILE="/tmp/date.err"
head -n 3 /etc/passwd /fakefile 2>${ERR_FILE}

# Redirect STDOUT and STDERR to a file.
head -n 3 /etc/passwd /fakefile &>${FILE}
echo
echo "Contents of ${FILE}:"
cat ${FILE}

# Redirect STDOUT and STDERR through a pipe.
echo
head -n 3 /etc/passwd /fakefile |& cat -n

# Send output to STDERR
# if the script is executed with err redirection, ex. ./luser-demo08.sh 2>err
# then err would contain 'This is STDERR!'
echo 'This is STDERR!' >&2

# null device is a file that throughs away what's sent to it. It is located in /dev/null

# Discard STDOUT
echo
echo "Discarding STDOUT:"
head -n 3 /etc/passwd /fakefile >/dev/null

# Discard STDERR
echo
echo "Discarding STDERR:"
head -n 3 /etc/passwd /fakefile 2>/dev/null

# Discard STDOUT and STDERR
echo
echo "Discarding STDOUT and STDERR:"
head -n 3 /etc/passwd /fakefile &>/dev/null

# Clean up
rm ${FILE} ${ERR_FILE} &>/dev/null
