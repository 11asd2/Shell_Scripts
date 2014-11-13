#!/bin/bash
echo -n "" > /tmp/temp.txt
echo "PID USER RSS COMMAND" | awk '{printf "%10s %-10s %10s %1s\n", $1, $2, $3, $4}' >> /tmp/temp.txt
for p in /proc/[0-9]*/ ; do
	PID=$(basename "$p")
	USER=$(stat -c "%U" "$p")
	if grep -wq '^VmRSS' "$p/status"; then
		RSS=$(grep -w '^VmRSS' "$p/status" | sed -e s/'VmRSS: *[^0-9]'//)
		COMMAND=$(cat $p/cmdline | tr '\0' ' ')
	else
		RSS="0"
		COMMAND=[$(grep -w '^Name:' "$p/status" | sed -e s/'Name: *[^a-z]'//)]
	fi
	echo "$PID $USER $RSS" | awk '{printf "%10s %-10s %10s", $1, $2, $3}' >> /tmp/temp.txt
	echo " $COMMAND" >> /tmp/temp.txt
done
cat /tmp/temp.txt | sort -g
rm /tmp/temp.txt

