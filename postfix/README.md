This template...

 * requires placing pfstats.sh somewhere in your MTA
 * running it in a cron job giving the delta it's run on as an argument to find -mmin
 * sends information from the MTA to your Zabbix server
 * reports on
   * postfix not running as DISASTER
   * postgrey not running as AVERAGE

If you don't use postgrey, adjust pfstats.sh in order to not collect nor try to send postgrey activity information.
