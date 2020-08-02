This template...

 * doesn't require adding specific Zabbix Agent configurations
 * requires the Nextcloud plugin Monitoring/Serverinfo available in the app store and developd at https://github.com/nextcloud/serverinfo/

Instructions:
 * create a monitoring user (eg, `mon`)
   * `make it a member of the admins group` (sadly required, see https://github.com/nextcloud/serverinfo/issues/100 )
   * `create an app token`, then edit it and `forbid file access` (strongly advised instead of user password)
   * set `file quota 0` (optional but may help with security)
   * `define a TOTP token` (optional but improves on security) and then `throw it away as well as any backup codes` (optional but will definitely help with security)
 * In Zabbix, create a host for your site and add the template, then proceed to define the  `inherited macros`
   * `NCPASSWORD` with the app token previiusly created
   * `NCROOT` with your Nextcloud root (eg https://your.clou.de/ )
   * `NCUSER` with the user (if different than mon)
