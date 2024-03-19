#! /bin/bash

# This script shows the open network ports on a system.
# Use -4 as an argument to limit IPv4 ports.
# The following comments are information related to cut and awk.

# cut -c 4-7 file  reads the file and get 4th ~ 7th char (no spaces between 4-7)
# without providing the ending char, it goes to the end, like python's array[start:]
# so cut -c 4- file gets every line starting from char 4
# same for without providing the start char, so cut -c -4 file gets the first 4 chars of every line

# can use , to seperate, but the output is concatenated
# cut -c 1,3,5 file gets the first, third, fifth char. It always follows the original order
# so the result of cut -c 5,3,1 file is the same as cut -c 1,3,5 file
# when the specified position, ex. char 999, doesn't exist, a blank line would be the default

# -b 1 and -c 1 are the same for ascii chars, but for multi byte chars, ex. chinese, the results would be different
# -f allows you to cut lines by field, by default splits by a tab
# echo -e 'one\ttwo\tthree' | cut -f 1  # one
# echo -e 'one\ttwo\tthree' | cut -f 2  # two
# echo -e 'one\ttwo\tthree' | cut -f 3  # three

# Should always single quote the delimeter to escape special chars like \
# echo -e 'one,two,three' | cut -d ',' -f 3  # three

# Get the username and uid from /etc/passwd
# cut -d ':' -f 1,3 /etc/passwd

# Can change the output delimeter to something else
# cut -d ':' -f 1,3 --output-delimiter /etc/passwd

# For csv files, we often need to remove the headers
# grep can get the headers using regex
# grep '^first,last$' people.csv
# -v inverts the matching, so

# grep -v '^first,last$' people.csv
# gets every line of people.csv except the heading
# so we can get every first name with
# grep -v '^first,last$' people.csv | cut -d ',' -f 1

# This gets the first column, then only get the data
# cut -d ',' -f 1| grep -v '^first$' people.csv

# When data are seperated by a string, ex: "DATA:", cut won't work, because
# the delimeter only accepts char, so when that is the case, we can use awk,
# like this, to get the first column

# awk -F 'DATA:' '{print $2}' people.dat
# -F is for the field seperator, the entire progrem is in the next single quotes,
# which is {print $2}.
# If people.dat is
# DATA:oneDATA:twoDATA:three
# DATA:fourDATA:fiveDATA:six
# '{print $2}' would be
# one
# four
# '{print $3}' would be
# two
# five
# '{print $4}' would be
# three
# six

# awk -F ':' '{print $1, $3}' /etc/passwd prints the username and uid, seperated by space. The , means the default output field seperator
# which is space

# awk -F ':' '{print $1 $3}' /etc/passwd prints the username and uid concatenated together
# awk -F ':' -v OFS=',' '{print $1, $3}' /etc/passwd prints the username and uid, seperated by ,
# awk -F ':' -v OFS=',' '{print $1      ,    $3}' /etc/passwd is exactly same as previous line
# awk -F ':' '{print $1 "," $3}' /etc/passwd is exactly same as previous line

# Unlike awk not being able to control the fields printed out, they always appear in the order of when thet occur
# you can easily do so by switching the order in awk
# awk -F ':' '{print $3, $1}' /etc/passwd

# Can be more specific:
# awk -F ':' '{print "UID: "$3 ";LOGIN: " $1"}' /etc/passwd

# $NF means the number of fields in a file
# print the last field of every line in a file
# awk -F ':' '{print $NF}' /etc/passwd
# If data is properly formatted, then $NF is not that useful
# but if data doesn't follow specific rule, with the combination of seperator and $NF, we can easily get data

# Prints the n - 1 column
# awk -F ':' '{print $(NF - 1)}' /etc/passwd

# For a file like
# L1C1        L1C2
#    L2C1   L2C2
#  L3C1       L3C2
# L4C1\tL4C2

# cut can only set 1 delimeter, so can't process this file properly
# but awk '{print $1, $2}' file works perfectly because it considers non white space chars to be a field by default

# Displays open network ports. -n is for number instead of port names, u for udp and t for tcp, l for listening port
# netstat -nutl

# To remove the headers(first 2 lines), we can pipe the result to grep
# netstat -nutl | grep -v '^Active' | grep -v '^Proto'
# or, we can use extending regex -E
# netstat -nutl | grep -Ev '^Active|^Proto'

# In this case, all the data has : , so we can also get the data with
# netstat -nutl | grep ':'

# Since awk deals with white space well, it can get the local address by
# netstat -nutl | grep ':' | awk '{print $4}'

# To further get the port, it could be accessed through $NF
# netstat -nutl | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}'

# To only get IPv4 addresses we can use
# netstat -4nutl

# So to get port of currently using IPv4 addresses by
# netstat -4nutl | grep ':' | awk '{print $4}' | cut -d ':' -f 2

# Or
# netstat -4nutl | grep ':' | awk '{print $4}' | awk -F ':' '{print $2}'
# netstat -4nutl | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}'

# The p option shows the PID and the program name, but it can only be run using sudo

netstat -nutl ${1} | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}'
