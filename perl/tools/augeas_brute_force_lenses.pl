#!/usr/bin/env perl

use strict;
use warnings;

use Carp          qw/ confess        /;
use Data::Dumper;
use English       qw/ -no_match_vars /;
use File::Copy;
use IPC::Run      qw/ run            /;
use Path::Class   qw/ dir file       /;

use feature       qw/ say            /;


# rsync -av ~/.config/kcminputrc /tmp/kcminputrc
# rsync -av      /tmp/kcminputrc /tmp/kcminputrc_temp_copy
# augtool --noautoload
# 
# set /augeas/load/$lens/lens "Rsyncd.lns"
# set /augeas/load/$lens/incl "/tmp/kcminputrc_temp_copy"
# print /augeas/load
# load
# ls /augeas/files/tmp/kcminputrc_temp_copy
# ls /files/tmp/kcminputrc_temp_copy
# set /files/tmp/kcminputrc_temp_copy/autodisable/KeyboardActivityTimeoutMs 850
# save
# quit
# 
# diff /tmp/kcminputrc /tmp/kcminputrc_temp_copy


# These are not concrete lenses: Build Erlang IniFile Quote Rx Sep Util
# grep -hP '^module\s+' /usr/share/augeas/lenses/dist/*.aug | awk '{print $2}' | sort | uniq | grep -Pv '^(Build|Erlang|IniFile|Quote|Rx|Sep|Util)$' | tr '\n' ' '
# my @lenses = ( qw/ Access ActiveMQ_Conf ActiveMQ_XML               Aliases Anacron Approx AptCacherNGSecurity AptConf AptPreferences Aptsources Apt_Update_Manager Authorized_Keys Automaster Automounter Avahi BackupPCHosts BBhosts BootConf Cachefilesd Carbon      Cgconfig Cgrules Channels Chrony        CobblerModules CobblerSettings Collectd CPanel Cron           Crypttab     Cups Cyrus_Imapd Darkice Debctrl Desktop Device_map Dhclient Dhcpd Dnsmasq          Dovecot Dpkg Dput Ethers Exports FAI_DiskConfig Fonts Fstab Fuse Gdm        Group Grub         Gshadow GtkBookmarks Host_Conf Hostname Hosts Hosts_Access Htpasswd Httpd Inetd Inittab Inputrc Interfaces IPRoute2 Iptables        Jaas JettyRealm JMXAccess JMXPassword Json Kdump Keepalived Known_Hosts Koji Krb5 Ldif LdSo Lightdm Limits Login_defs Logrotate Logwatch Lokkit LVM                                            MCollective Mdadm_conf Memcached Mke2fs Modprobe Modules Modules_conf MongoDBServer Monit Multipath MySQL NagiosCfg NagiosObjects Netmasks NetworkManager Networks Nginx Nrpe       Nsswitch Ntp Ntpd Odbc          OpenShift_Config OpenShift_Http OpenShift_Quickstarts OpenVPN    Pagekite Pam PamConf Passwd Pbuilder           Pg_Hba PHP Phpvars Postfix_Access Postfix_Main Postfix_Master                                        Postfix_Transport Postfix_Virtual Postgresql Properties Protocols Puppet Puppet_Auth            PuppetFileserver             PythonPaste Qpid Rabbitmq                 Redis Reprepro_Uploaders Resolv      Rmt Rsyncd Rsyslog        Samba Schroot Securetty Services Shadow Shells Shellvars Shellvars_list Simplelines Simplevars Sip_Conf Slapd SmbUsers Solaris_System Soma Spacevars Splunk Squid Ssh Sshd Sssd      Stunnel Subversion Sudoers Sysconfig Sysconfig_Route Sysctl Syslog Systemd         Thttpd                        Tuned Up2date UpdateDB Vfstab VMware_Config Vsftpd Webmin Wine Xendconfsxp Xinetd Xml Xorg Xymon Xymon_Alerting      Yum / );
my @lenses = ( qw/ Access ActiveMQ_Conf ActiveMQ_XML AFS_cellalias Aliases Anacron Approx AptCacherNGSecurity AptConf AptPreferences Aptsources Apt_Update_Manager Authorized_Keys Automaster Automounter Avahi BackupPCHosts BBhosts BootConf Cachefilesd Carbon Ceph Cgconfig Cgrules Channels Chrony Clamav CobblerModules CobblerSettings Collectd CPanel Cron Cron_User Crypttab CSV Cups Cyrus_Imapd Darkice Debctrl Desktop Device_map Dhclient Dhcpd Dnsmasq Dns_Zone Dovecot Dpkg Dput Ethers Exports FAI_DiskConfig Fonts Fstab Fuse Gdm Getcap Group Grub GrubEnv Gshadow GtkBookmarks Host_Conf Hostname Hosts Hosts_Access Htpasswd Httpd Inetd Inittab Inputrc Interfaces IPRoute2 Iptables Iscsid Jaas JettyRealm JMXAccess JMXPassword Json Kdump Keepalived Known_Hosts Koji Krb5 Ldif LdSo Lightdm Limits Login_defs Logrotate Logwatch Lokkit LVM Mailscanner Mailscanner_Rules MasterPasswd MCollective Mdadm_conf Memcached Mke2fs Modprobe Modules Modules_conf MongoDBServer Monit Multipath MySQL NagiosCfg NagiosObjects Netmasks NetworkManager Networks Nginx Nrpe Nslcd Nsswitch Ntp Ntpd Odbc Opendkim OpenShift_Config OpenShift_Http OpenShift_Quickstarts OpenVPN Oz Pagekite Pam PamConf Passwd Pbuilder Pgbouncer Pg_Hba PHP Phpvars Postfix_Access Postfix_Main Postfix_Master Postfix_Passwordmap Postfix_sasl_smtpd Postfix_Transport Postfix_Virtual Postgresql Properties Protocols Puppet Puppet_Auth Puppetfile PuppetFileserver Pylonspaste PythonPaste Qpid Rabbitmq Radicale Rancid Redis Reprepro_Uploaders Resolv Rhsm Rmt Rsyncd Rsyslog Rtadvd Samba Schroot Securetty Services Shadow Shells Shellvars Shellvars_list Simplelines Simplevars Sip_Conf Slapd SmbUsers Solaris_System Soma Spacevars Splunk Squid Ssh Sshd Sssd Star Stunnel Subversion Sudoers Sysconfig Sysconfig_Route Sysctl Syslog Systemd Termcap Thttpd Tmpfiles Trapperkeeper Tuned Up2date UpdateDB Vfstab VMware_Config Vsftpd Webmin Wine Xendconfsxp Xinetd Xml Xorg Xymon Xymon_Alerting YAML Yum / );

if ( scalar( @ARGV ) == 0 ) {
	print "Usage: $PROGRAM_NAME files for which to find lenses\n";
	print "Usage: $PROGRAM_NAME files for which to find lenses\n";
	exit;
}

my @filenames = map { file( $ARG ); } @ARGV;

foreach my $filename ( @filenames ) {
	if ( ! -e $filename ) {
		confess "No such non-empty file \"$filename\"";
	}
}

warn localtime(time())
     . " : Attempt to use " . scalar( @lenses    )
     . " lenses for "            . scalar( @filenames )
     . " files\n";
if ( scalar( @filenames ) > 1 ) {
	warn localtime(time()). " : Since more than one file has been specified, parsing details won't be printed\n";
}

foreach my $filename ( @filenames ) {
	
	my @lenses_that_parse = ();
	foreach my $lens ( @lenses ) {
		my $conf_file_copy = file( '/tmp/augeas_brute_force_lenses.copy_of_conf_file' )->absolute();
		my $command_file   = file( '/tmp/augeas_brute_force_lenses.commands_file'     )->absolute();
		copy( $filename, $conf_file_copy );
		file( $command_file )->spew( <<"EOF"
set /augeas/load/$lens/lens "$lens.lns"
set /augeas/load/$lens/incl "$conf_file_copy"
print /augeas/load
load
ls /augeas/files$conf_file_copy
ls /files/tmp/augeas_brute_force_lenses.copy_of_conf_file
EOF
		);
		my @command_parts = ( qw/ augtool --noautoload --file /, "$command_file" );
		my ( $in, $out, $err );
		run( \@command_parts, \$in, \$out, \$err );
		if ( $out !~ /parse_failed/ && $err !~ /error: garbage at end of path expression/ ) {
			if ( $err =~ /Lens not found/ ) {
				warn "Lens $lens was not found\n";
				next;
			}

			if ( scalar( @filenames ) == 1 ) {
				say "################################# $lens #################################";
				say $out;
			}

			push @lenses_that_parse, $lens;
		}
	}
	say "There are "
	    . sprintf( '%3d', scalar( @lenses_that_parse ) )
	    . " lenses that parse \"$filename\" : "
	    . join( ' ', @lenses_that_parse );
}
