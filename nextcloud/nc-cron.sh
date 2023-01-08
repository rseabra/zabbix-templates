#!/bin/sh

# Use this script as a cron rather than just running the cron so it creates an evidence it was run

# set SECONDS to slightly below your period, since I'm running it every 5 minutes (300 s) I used 290 s
SECONDS="290"

export NEXTCLOUD_CONFIG_DIR="/etc/nextcloud"
LOCK=/var/tmp/nc.cron.lock

if [ ! -f $LOCK ] || [ $(( $( date +%s ) - $( date -r $LOCK +%s ) )) -gt $SECONDS ] ; then
	echo cron > $LOCK

	php /var/www/html/nextcloud/cron.php
fi
