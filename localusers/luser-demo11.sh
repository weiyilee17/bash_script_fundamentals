#! /bin/bash

# This script generates a random password, showcasing getopts
# This user can set the password length with -l and add a special char with -s.
# Verbose mode can be enabled with -v

usage() {
  echo "Usage: ${0} [-vs] [-l LENGTH]" >&2
  echo 'Generate a random password.'
  echo '  -l LENGTH  Specity the password length.'
  echo '  -s         Append a special character to the password.'
  echo '  -v         Increase verbosity.'

  exit 1
}

log_to_STDOUT() {
  local MESSAGE="${@}"

  if [[ "${VERBOSE}" = 'true' ]]; then
    echo "${MESSAGE}"
  fi
}

# Set a default password length
LENGTH=48

# l is followed by a mandatory value, so has a : after it
while getopts vl:s OPTION; do
  case ${OPTION} in
  v)
    VERBOSE='true'
    log_to_STDOUT 'Verbose mode on.'
    ;;
  l)
    LENGTH="${OPTARG}"
    ;;
  s)
    USE_SPECIAL_CHARACTER='true'
    ;;
    # getopts provides a single char at a time, hence ? is enough for catch all
  ?)
    usage
    ;;
  esac

done

# Could be tested by running command ./luser-demo11.sh -sl 8 extra-stuff
# echo "Number of args: ${#}"
# echo "All args: ${@}"
# echo "First args: ${1}"
# echo "Second args: ${2}"
# echo "Third args: ${3}"

# Inspect OPTIND
# echo "OPTIND: ${OPTIND}"

# Remove the option while leaving the remaining arguments.
# OPTIND is a variable that stores the index of the next argument to be processed by getopts.  As getopts processes each argument to see if it's an option, it increments OPTIND by one.  When getopts finds an argument that isn't an option it's done, so at the end the value of $OPTIND is set to the location of the first non-option argument.

# Putting a mathematical operation inside of "$(( ))" tells bash to use the result of that operation at that point in a command.

# And the shift command tells bash to discard earlier arguments and update the arguments list to include only unshifted arguments.  If you shift a list of 5 arguments by 3, you'll be left with only the last two arguments as the argument list.

# All of that together means that "$((OPTIND - 1))" results in the number of arguments that getopts found to be options, and "shift $((OPTIND - 1))" removes the arguments that getopts said were options.

# The result is that the list of arguments (accessible with $@ or $*) will only be the arguments you want to process with the rest of the script.  The shift command got rid of the arguments that were options.
shift "$((OPTIND - 1))"

# echo
# echo "After the shift"

# echo "Number of args: ${#}"
# echo "All args: ${@}"
# echo "First args: ${1}"
# echo "Second args: ${2}"
# echo "Third args: ${3}"

# The remaining args could be processed through for or while loop
# Could be useful if the options are in the middle, and the last arg is the destination file or what not

# In this case, we can simply use it to check if user entered extra arguments, since the only valid options are v, s and l
if [[ "${#}" -gt 0 ]]; then
  usage
fi

log_to_STDOUT 'Generating a password.'
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c${LENGTH})

# Append a special character if requested to do so.
if [[ "${USE_SPECIAL_CHARACTER}" = 'true' ]]; then
  log_to_STDOUT 'Selecting a random special character.'
  SPECIAL_CHAR=$(echo '!@#$%^&*()_+-=' | fold -w 1 | shuf | head -c1)
  PASSWORD="${PASSWORD}${SPECIAL_CHAR}"
fi

log_to_STDOUT 'Done.'
log_to_STDOUT 'Here is the password:'
echo "${PASSWORD}"

# For arithmic calculation, we use $(( 6 / 4 )) to get the value
# If we want to do floating point calculation we can use bc -l
# l is to use the predefined math routines
# Depending on the distribution, you may need to add it using command
# sudo yum install -y bc or apt, apt-get

# bc accepts input from STDOUT, so we can pipe it in from echo
# echo '6 / 4' | bc -l

# Another way is using awk
# awk 'BEGIN {print 6/4}'

# When using variables, it goes directly without $
# DICE_A='3'
# DICE_B='6'
# TOTAL=$(( DICE_A + DICE_B ))
# TOTAL would be 9

# NUM='1'
# (( NUM++ ))
# NUM would be 2

# (( NUM += 5 ))

# let NUM='2 + 3'
# NUM would be 5
# let NUM++
# NUM would be 6
# more info can be found in help let

# expr processes expression and sends the result to STDOUT
# NUM=$(expr 2 + 3)
# NUM would be 5

exit 0
