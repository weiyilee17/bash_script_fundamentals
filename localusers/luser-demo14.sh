#! /bin/bash

# Displays the top 3 most visited URLs for a given web server log file.

# Below are information related to sort, uniq, wc, and du

# Can use sort to sort content alphabetically, -r option to reverse order
# sort -r /etc/passwd

# Get UID
# cut -d ':' -f 3 /etc/passwd

# If we want to sort the UIDs, we have to use the -n option
# cut -d ':' -f 3 /etc/passwd | sort -n

# In reverse order
# cut -d ':' -f 3 /etc/passwd | sort -nr

# du is for disk usage
# We can use sudo du /var to check disk usages of /var library, sudo because some require
# root privilage to read
# We can then sort the result to sort the usages from least to most, or -r to reverse
# sudo du /var | sort -nr

# The unit is KB, can use -h to human readable format
# sudo du -h /var

# But how to sort it? The -h option in sort can sort human readable format
# sudo du -h /var | sort -h

# Combining with netstat mentioned previously we can sort the ports with
# netstat -nutl | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}' | sort -n

# But to get unique values, we can add -u option
# netstat -nutl | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}' | sort -nu

# Another command is uniq. It returns the uniq values, but the input has to be sorted
# because it compares the value with the prev value
# netstat -nutl | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}' | sort -n | uniq

# How is this useful? uniq has a -c option that shows the freq of the line,
# somewhat simular to Counter, but the freq comes first

# If we want to know how many messages in syslog a program is generating, we can use
# sudo cat /var/log/messages | awk '{print $5}' | sort | uniq -c | sort -n

# We can use similar technique to check which IP is hitting the server the most

# wc is for word count
# wc /etc/passwd
#   24   37 1131 /etc/passwd
# The fist column is the number of lines in the file (-l to only show this)
# The second is the number of words (-w to only show this)
# The third is the number of chars (-c to only show this)

# How many accounts are using bash shell?
# grep bash /etc/passwd

# Although there are only 2 in this case, if there are a lot, we can pipe it to
# wc to see the line count
# grep bash /etc/passwd | wc -l

# grep has a -c option to perform count, so the following line is the same:
# grep -c bash /etc/passwd

# But for commands that don't have this functionality, we can use wc to get the count

# sort has a -k option to sort by key
# We can sort /etc/passwd by UID with:
# cat /etc/passwd | sort -t ':' -k 3 -n
# t is the seperator, 3 is the third field

# For the access_log file, we can get the url with
# cut -d '"' -f 2 access_log | cut -d ' ' -f 2
# or
# awk '{print $7}' access_log

# The 3 most visited URLs
# awk '{print $7}' access_log | sort | uniq -c | sort -n | tail -n 3

LOG_FILE="${1}"

if [[ ! -e "{LOG_FILE}" ]]; then
  echo "Can not open ${LOG_FILE}" >&2
  exit 1
fi

awk '{print $7}' ${LOG_FILE} | sort | uniq -c | sort -n | tail -n 3
