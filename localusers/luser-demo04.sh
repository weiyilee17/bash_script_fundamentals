#! /bin/bash

# chmod 755 file is the same as chmod +x file

# This script creates an account on the local system.
# You will be prompted for the account name and password.

# Ask for the user name.
read -p 'Enter the username to create: ' USER_NAME

# Ask for the real name.
# Historically, the comment has been used for the user's full name. If the account is not
# for a person, it can be the name of application that is using it.
# Can also add help desk ticket number, so we can go to check the help desk ticket numbers
# to get more information
read -p 'Enter the name of the person who this account is for: ' COMMENT

# Ask for the password.
read -p 'Enter the password to use for the account: ' PASSWORD

# Create the user.
# if username is longer than 8 char, when we run ps -ef, it would only show the first 7 chars and the + char
# so in convention, it is 8 char. Another convention is its all lower case. Special chars aren't allowed,
# but numbers except the first char is.
# -m creates home directory. Although it does so be default, it differs between different distribute systems,
# so we can explicitly do so to make sure that it does.
# COMMENT might contain spaces, so we use "" to wrap it
useradd -c "${COMMENT}" -m ${USER_NAME}

# Set the password for the user.
# --stdin is to allow us to programatically enter the USER_NAME, rather having the user to type in the terminal
# although the user typed in to the terminal already
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

# Force password change on first login.
passwd -e ${USER_NAME}
