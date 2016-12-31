#!/bin/sh

MAILLOG="/var/log/maillog"
DATADIR="/tmp/zabbix-postfix"
OFFSET="offset.dat"
RESULT="results.dat"
TMPLOG="$DATADIR/maillog.tmp"
ZABBIX_CONF="/etc/zabbix/zabbix_agentd.conf"

DELTAT="$1"

PATH=/sbin:/usr/sbin:/bin:/usr/bin

[ -e $DATADIR ] || mkdir -p $DATADIR

TEST=$(find $DATADIR -name $RESULT -mmin "$DELTAT" | head -1)

if [ -z "$TEST" ] ; then
	logtail -f $MAILLOG -o $DATADIR/$OFFSET > $TMPLOG
	pflogsumm -i --detail=0 --zero_fill $TMPLOG > $DATADIR/$RESULT
	mailq | awk -S 'BEGIN { COUNT=0 } !/empty/ && /^[0-9A-Z]/ { COUNT++ } END { printf "\n%d messages in mailq\n",COUNT }' >> $DATADIR/$RESULT
	echo "$( grep -c 'blocked using' $TMPLOG ) blacklist-block" >> $DATADIR/$RESULT
	# comment out the following if you don't use postgrey
	echo "$( grep -c action=greylist $TMPLOG ) greylist-block" >> $DATADIR/$RESULT
	echo "$( grep -c action=pass $TMPLOG ) greylist-pass" >> $DATADIR/$RESULT
fi


function zsend {
	PREFIX="$1"
	TOKEN="$2"
	VALUE=$(awk -S "BEGIN { FOUND=0 } /$TOKEN/ { print \$1; FOUND=1; exit 0 } END { if (FOUND==0) print -1 }" $DATADIR/$RESULT )
	ZBX_TOKEN="$(echo $TOKEN | tr ' ' '_')"
        zabbix_sender -c $ZABBIX_CONF -k "$PREFIX.$ZBX_TOKEN" -o "$VALUE" &> /dev/null
}

function zsend2 {
	PREFIX="$1"
	TOKEN="$2"
	VALUE=$(awk -S "BEGIN { FOUND=0 } /$TOKEN/ { print \$1; FOUND=1; exit 0 } END { if (FOUND==0) print -1 }" $DATADIR/$RESULT )
	ZBX_TOKEN="$(echo $TOKEN | tr ' ' '_')"

	if (echo $VALUE | grep -iq 'k') ; then
		ZBX_VALUE=$(( $(echo $VALUE | sed -e 's/[^0-9]*//') * 1024))
	elif (echo $VALUE | grep -iq 'm') ; then
		ZBX_VALUE=$(( $(echo $VALUE | sed -e 's/[^0-9]*//') * 1024 * 1024))
	else
		ZBX_VALUE=$VALUE
	fi

        zabbix_sender -c $ZABBIX_CONF -k "$PREFIX.$ZBX_TOKEN" -o "$ZBX_VALUE" &> /dev/null
}

zsend postfix received
zsend postfix delivered
zsend postfix forwarded
zsend postfix deferred
zsend postfix bounced
zsend postfix rejected
zsend postfix held
zsend postfix discarded
zsend postfix "reject warnings"
zsend2 postfix "bytes received"
zsend2 postfix "bytes delivered"
zsend postfix senders
zsend postfix recipients
zsend postfix mailq
zsend postfix blacklist-block
# comment out the following if you don't use postgrey
zsend postgrey greylist-block
zsend postgrey greylist-pass
