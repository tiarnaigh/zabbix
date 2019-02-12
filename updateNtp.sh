#
# Assumes input file "allHosts.txt" which is a list of host IPs, one per line
# This script replied on the Zabbix remote agent execution, but could easily be extended to use salt alternatively
# 
# [root@hostX ~]# cat allHosts.txt
# 10.10.1.200
# 10.10.1.208
# 10.10.1.209
#
#
#
#!/bin/bash
cat allHosts.txt | while read i;
 do
  echo "###### $i ####";
  /sys_apps_01/zabbix/bin/zabbix_get -s $i -k system.run["/etc/init.d/ntpd stop","wait"];
  # Curl down ntp.conf from local nginx/Apache server and store locally on each node
  /sys_apps_01/zabbix/bin/zabbix_get -s $i -k system.run["curl -k https://10.10.2.30/infr-packages/infra/ntp.conf -o /etc/ntp.conf","wait"];
  /sys_apps_01/zabbix/bin/zabbix_get -s $i -k system.run["chkconfig ntpdate on","wait"];
  /sys_apps_01/zabbix/bin/zabbix_get -s $i -k system.run["chkconfig ntpd on","wait"];
  /sys_apps_01/zabbix/bin/zabbix_get -s $i -k system.run["/etc/init.d/ntpdate start","wait"];
  /sys_apps_01/zabbix/bin/zabbix_get -s $i -k system.run["/etc/init.d/ntpd start","wait"];
 done
