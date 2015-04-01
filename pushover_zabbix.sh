#!/bin/bash

#set -x

# Defult Values
PTOKEN="aQ2bKJVKMHf62a1RBUaSV8TRYPdAeG"
PUSER=""
PDEVICE=""
PTITLE="Zabbix alerter processes more than 75% busy"
PMESSAGE=$(cat <<EOT
Status: <b>PROBLEM</b>
%PUSHOVER%HTML%0
%PUSHOVER%PRIORITY%High
%PUSHOVER%URL_TITLE%Original event ID: 1077780
%PUSHOVER%URL%http://www.monitor.skytelecom.kz/tr_events.php?triggerid=13485&eventid=1077123&sid=750a37192495410c
Zabbix busy alerter processes, in % (Zabbix server:zabbix[process,alerter,avg,busy]): 100%
EOT
)
PPRIORITY=""	# -2
PSOUND=""
PRETRY=""	# 2
PEXPIRE=""	# 60
PURL=""
PURL_TITLE=""
PTIMESTAMP=""
PCALLBACK=""
PHTML=""

# Other Variables
ZASPATH=/usr/lib/zabbix/alertscripts
CURL="$(which curl)"
CURL_OPTS=""
PUSHOVER_URL="https://api.pushover.net/1/messages.json"
REGEX="/^%PUSHOVER%[A-Z]+%.*$/p"

# Get CMD Parameters
CUSER=$1 
CTITLE=$2 
CMESSAGE=$3

# Functions

opt_field() {
    field=$1
    shift
    value="${*}"
    if [ ! -z "${value}" ]; then
        echo "-F \"${field}=${value}\""
    fi
}

validate_token() {
	field="${1}"
	value="${2}"
	opt="${3}"
	ret=1
	if [ -z "${value}" ]; then
		echo "${field} is unset or empty: Did you create ${CONFIG_FILE} or specify ${opt} on the command line?" >&2
	elif ! echo "${value}" | egrep -q '[A-Za-z0-9]{30}'; then
		echo "Value of ${field}, \"${value}\", does not match expected format. Should be 30 characters of A-Z, a-z and 0-9." >&2;
	else
		ret=0
	fi
	return ${ret}
}
set -x
severity_to_priority() {
local	priority=-2
local	severity="${1}"

	case $severity in
		Information)	priority=-2 ;;
		Warning)	priority=-1 ;;
		Average)	priority=0  ;;
		High)		priority=1  ;;
		Disaster)	priority=2; PRETRY="2"; PEXPIRE="60" ;;
	esac
	echo $priority
}

send_message() {
    local device="${1:-}"

    curl_cmd="\"${CURL}\" -s -S \
        ${CURL_OPTS} \
        -F \"token=${PTOKEN}\" \
        -F \"user=${PUSER}\" \
        -F \"message=${PMESSAGE}\" \
        $(opt_field device "${PDEVICE}") \
        $(opt_field callback "${PCALLBACK}") \
        $(opt_field timestamp "${PTIMESTAMP}") \
        $(opt_field priority "${PPRIORITY}") \
        $(opt_field retry "${PRETRY}") \
        $(opt_field expire "${PEXPIRE}") \
        $(opt_field title "${PTITLE}") \
        $(opt_field sound "${PSOUND}") \
        $(opt_field url "${PURL}") \
        $(opt_field url_title "${PURL_TITLE}") \
	$(opt_field html "${PHTML}") \
        \"${PUSHOVER_URL}\""

    # execute and return exit code from curl command
    response="$(eval "${curl_cmd}")"
    # TODO: Parse response for value of status to give better error to user
    r="${?}"
    if [ "${r}" -ne 0 ]; then
        echo "${0}: Failed to send message" >&2
    fi

    return "${r}"
}


if [ -z "$PUSER" ]; then PUSER=$CUSER; fi
if [ -z "$PTITLE" ]; then PTITLE=$CTITLE; fi
if [ -z "$PMESSAGE" ]; then PMESSAGE=$CMESSAGE; fi

# Cut pushover rows from Message
POPTS=$(echo "${PMESSAGE}" | grep -i %PUSHOVER%)
PMESSAGE=$(echo "${PMESSAGE}" | grep -iv PUSHOVER%)

OLDIFS=$IFS
IFS=$'\n'
for PL in ${POPTS}
do
	OPT=$(echo $PL | cut -f3 -d'%')
	VAL=$(echo $PL | cut -f4 -d'%')
	case $OPT in
		TOKEN)		PTOKEN=$VAL ;;
		USER)		PUSER=$VAL ;;
		DEVICE)		PDEVICE=$VAL ;;
		TITLE)		PTITLE=$VAL ;;
		PRIORITY)	PPRIORITY=$(severity_to_priority "$VAL") ;;
		SOUND)		PSOUND=$VAL ;;
		RETRY)		PRETRY=$VAL ;;
		EXPIRE)		PEXPIRE=$VAL ;;
		URL)		PURL=$VAL ;;
		URL_TITLE)	PURL_TITLE=$VAL ;;
		TIMESTAMP)	PTIMESTAMP=$VAL ;;
		CALLBACK)	PCALLBACK=$VAL ;;
		HTML)		PHTML=$VAL ;;
	esac
done
IFS=$OLDIFS

send_message


