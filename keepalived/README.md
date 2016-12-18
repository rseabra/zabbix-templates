This template...

 * requires no scripts placed on the server
 * creates an application, Keepalived
 * collects from the agent:
   * if it is a master
   * if it is an IPv4 router
   * the number of keepalived processes
 * reports on
   * state changes (from master to backup or the reverse) as WARNING
   * backup server that's neither a router or has keepalived routing as HIGH (your redundancy is impacted)
   * master server that's neither a router nor has keepalived routing as DISASTER (your service will be impacted if there's an availability issue in one real server as nothing else will automatically let IPVS know of a different table)

I still haven't found a good way to report on the cluster other than creating triggers on hosts, though. Any ideas?
