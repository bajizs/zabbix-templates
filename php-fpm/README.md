Zabbix Template for php-fpm monitoring without NgINX
====================================================

Show php-fpm pool statistics in Zabbix, multiple pools and his connections discovered over LLD. Tested on OpenSUSE. Zabbix configuration is for zabbix agent active checks.

REQUIREMENTS
------------

- installed cgi-fcgi (FastCGI package in OpenSUSE)
- installedd and configured zabbix agent
- lsof acces by user zabbix

INSTALL
-------

### Add User Parameters

Copy php-fpm-LLD.sh, php-fpm-status.sh and php-fpm-params.conf to zabbix_agentd include
directory (for example /etc/zabbix/zabbix-agentd.conf.d/), make sure php-fpm-params.conf included to configuration.

php-fpm-LLD.sh and php-fpm-status.sh must be executable:
```
chmod a+x php-fpm-LLD.sh and php-fpm-status.sh
```

If scripts php-fpm-LLD.sh and php-fpm-status.sh is not installed to folder /etc/zabbix/zabbix-agentd.conf.d/ You need to modify php-fpm-params.conf

Restart Zabbix agent.

### Add zabbix to sudoers for running lsof command

You need to enable to zabix run 'lsof' command. This will be done adding zabbix user to sudoers, for security reason only for command lsof. This will be done for example with next command:

```
echo zabbix ALL = NOPASSWD: `which lsof` >> /etc/sudoers.d/zabbix
```

Command will be modified for You system (not every system has /etc/sudoers.d/ folder)

### Configure php-fpm

Open the php-fpm pool's configuration file, uncomment the 'pm.status=' and 'pm.ping=' directive:

pm.status_path = /status
pm.status_path = /ping

Since php-fpm's statistics is collected by different pools, so you need to set up config for every pool.

If You use file socket, need to add access for zabbix user. Example configuration:

listen.group = zabbix
listen.mode = 0660


### Import Template

Import php-fpm-template.xml, and link it to a host.


CREDITS
-------

Some of the codes are form https://github.com/jizhang/zabbix-templates/.

