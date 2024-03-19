#! /bin/bash

: ' To use multi line comment, all the content are wrappted between the single quotes
So some of the commands below, while they should be in single quotes, are written in
double quotes

sed is mostly used for find and replace
Lets say there is some text in manager.text
echo "Dwight is the assistant regional manager." > manager.txt

We can use 
sed "s/assistant/assistant to the/" manager.txt
to replace assistant to assistant to the. The string between / are regex

sed "s/search-pattern/replacement-string/flags"
flag can be i or I to ignore chase

However, it does not change the content of manager.txt. It just shows the changed content.

By default, the search pattern goes through every line, and replaces the first match
Can use flag g to remove every match in every line

If the 2nd occurance needs to be changed, the flag can be 2

sed "s/my wife/sed/g" love.txt > my-new-love.txt 
would save the replaced content to my-new-love.txt

The -i option in set allows in place editing


sed -i.bak "s/my wife/sed/" love.txt
creates backup love.txt.bak, and changes love.txt in place
no spaces between -i and .bak

If you only want to save the lines where changes were made, you can use the w flag with the file name
sed "s/love/like/gw" like.txt love.txt
reads from love.txt and writes to like.txt the lines that were changed.

To change /home/jason to /export/users/jasonc, we can use \ to escape /
sed "s/\/home\/jason/\/export\/users\/jasonc/"

The delimeter doesn"t have to be /, so we can rewrite the previous command as
sed "#/home/jason#/export/users/jasonc#"

The flag d removes the line
sed "/This/d" love.text
removes the second line "This is line 2."

Lets say there is a config file:

#User to run service as.
User apache

#Group to run service as.
Group apache

We can remove comments with
# lines that start as comments. There are cases where the comment is after the line, those should not be deleted
sed "/^#/d" config
to filter out comments.

This removes empty lines
sed "/^$/d" config

This combines the 2:
sed "/^#/d ; /^$/d" config

This changes apache to httpd
sed "/^#/d ; /^$/d ; s/apache/httpd/" config
sed -e "/^#/d" -e "/^$/d" -e "s/apache/httpd/" config

These search patterns can be stored in file, and used in the -f option

script.sed:
/^#/d
/^$/d
s/apache/httpd/

sed -f script.sed config

We can have sed only run on specific line
# space between 2 and s are not necessary
sed "2 s/apache/httpd/" config

or lines that match regex pattern, lines who contain Group
sed "/Group/ s/apache/httpd/" config

, can be used for range, so if we want to change run to execute from 1 ~ 3, we can write
sed "1,3 s/run/execute/" config

sed "/#User/,/^$/ s/run/execute/" config


'
