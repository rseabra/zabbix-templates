This template...

 * doesn't require adding specific Zabbix Agent configurations
 * requires the Nextcloud plugin Monitoring/Serverinfo available in the app store and developd at https://github.com/nextcloud/serverinfo/

Instructions:
 * create a token:
   * Generate a token with `apg -m 20 -M SNCL` or anything that provides a good random string
   * Register it into Nextcloud with `sudo -u apache ./occ config:app:set serverinfo token --value MySecretTokenGeneratedAbove`
   * Test it with `curl -H 'NC-Token: MySecretTokenGeneratedAbove' 'https://cloud.1407.org/ocs/v2.php/apps/serverinfo/api/v1/info?format=json'`
 * In Zabbix, create a host for your site and add the template, then proceed to define the  `inherited macros`
   * `NCTOKEN` with the app token previiusly created
   * `NCROOT` with your Nextcloud root (eg https://your.clou.de/ )
   * `LOCKPATH` with the appropriate path to the cron lock file
   * `LOCKTIMECRITICAL` with the appropriate time (in seconds) after which the cron is not running for a critically long time
   * `LOCKTIMEWARN` with the appropriate time (in seconds) after which the cron is not running for a worryingly long time
