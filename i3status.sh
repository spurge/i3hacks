#!/bin/bash

i3status -c ~/.i3/i3status.conf | ( read LINE && echo $LINE && while :
do
	read LINE
	GREEN="859900"
	RED="cb4b16"
	MAGENTA="d33682"
	BLUE="268bd2"
	ORANGE="cb4b16"
	ADD=""

	# CMUS

	CMUS=$( cmus-remote -Q 2>/dev/null )
	STATUS=$( echo "$CMUS" | grep -o 'status [^\$]\+' | cut -d " " -f 2- )
	ARTIST=$( echo "$CMUS" | grep -o 'tag artist [^\$]\+' | cut -d " " -f 3- )
	TITLE=$( echo "$CMUS" | grep -o 'tag title [^\$]\+' | cut -d " " -f 3- )

	if [ "$STATUS" = "playing" ]; then
		COLOR="$BLUE"
	elif [ "$STATUS" = "paused" ]; then
		COLOR="$ORANGE"
	else
		COLOR="$RED"
	fi

	if [ -z "$ARTIST" ] & [ -z "$TITLE" ]; then
		ADD="$ADD"
	elif [ -z "$ARTIST" ]; then
		ADD="$ADD{\"name\":\"cmus\",\"color\":\"#${COLOR}\",\"full_text\":\"${TITLE:0:22}\"},"
	else
		ADD="$ADD{\"name\":\"cmus\",\"color\":\"#${COLOR}\",\"full_text\":\"${ARTIST:0:22} - ${TITLE:0:22}\"},"
	fi

	# WEATHER

	WEATHER=$( weather -m essb 2>/dev/null )
	LOCATION=$( echo "$WEATHER" | grep -o 'Current conditions at [^ ]\+' | cut -d " " -f 4- )
	TEMP=$( echo "$WEATHER" | grep -o 'Temperature: [^ ]\+' | cut -d " " -f 2- )
	SKY=$( echo "$WEATHER" | grep -o 'Sky conditions: [^\$]\+' | cut -d " " -f 3- )

	if [ -z "$WEATHER" ]; then
		ADD="$ADD"
	else
		ADD="$ADD{\"name\":\"weather\",\"color\":\"#${MAGENTA}\",\"full_text\":\"${LOCATION:0:22}: ${TEMP}°C ${SKY}\"},"
	fi

	# REPLACE COLORS

	LINE="${LINE//FF0000/$RED}"
	LINE="${LINE//00FF00/$GREEN}"

	echo "${LINE/[{/[$ADD{}" || exit 1
done )
