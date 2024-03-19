#! /bin/bash

# Count the number of failed logins by IP address.
# If there are any IPs with over LIMIT failures, dispaly the count, IP, and location.

LIMIT='10'
LOG_FILE="${1}"

if [[ ! -e "${LOG_FILE}" ]]; then
  echo "Can not read ${LOG_FILE}, you either don't have permision, or the file doesn't exist" >&2
  exit 1
fi

# Display the CSV header.
echo 'Count,IP,Location'

cat "${LOG_FILE}" | grep Failed | awk '{print $(NF - 3)}' | sort | uniq -c | sort -nr | while read COUNT IP; do
  if [[ "${COUNT}" -gt "${LIMIT}" ]]; then
    LOCATION=$(geoiplookup ${IP} | awk -F ', ' '{print $2}')
    echo "${COUNT},${IP},${LOCATION}"
  fi
done

exit 0
