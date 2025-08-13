#!/usr/bin/perl -w

use strict;

my $log_file = shift @ARGV || '/var/log/zimbra.log';
my $pflogsumm_output = `/opt/zimbra/common/bin/pflogsumm.pl $log_file`;

my %stats = (
    'received' => 0,
    'delivered' => 0,
    'forwarded' => 0,
    'deferred' => 0,
    'bounced' => 0,
    'rejected' => 0,
    'reject_warnings' => 0,
    'held' => 0,
    'discarded' => 0,
    'bytes_received' => 0,
    'bytes_delivered' => 0,
    'senders' => 0,
    'sending_hosts_domains' => 0,
    'recipients' => 0,
    'recipient_hosts_domains' => 0
);

foreach my $line (split /\n/, $pflogsumm_output) {
    if ($line =~ /^\s*(\d+)\s+received/) { $stats{'received'} = $1; }
    if ($line =~ /^\s*(\d+)\s+delivered/) { $stats{'delivered'} = $1; }
    if ($line =~ /^\s*(\d+)\s+forwarded/) { $stats{'forwarded'} = $1; }
    if ($line =~ /^\s*(\d+)\s+deferred/) { $stats{'deferred'} = $1; }
    if ($line =~ /^\s*(\d+)\s+bounced/) { $stats{'bounced'} = $1; }
    if ($line =~ /^\s*(\d+)\s+rejected/) { $stats{'rejected'} = $1; }
    if ($line =~ /^\s*(\d+)\s+reject warnings/) { $stats{'reject_warnings'} = $1; }
    if ($line =~ /^\s*(\d+)\s+held/) { $stats{'held'} = $1; }
    if ($line =~ /^\s*(\d+)\s+discarded/) { $stats{'discarded'} = $1; }
    if ($line =~ /^\s*(\d+)k\s+bytes\s+received/) { $stats{'bytes_received'} = $1 * 1024; }
    if ($line =~ /^\s*(\d+)k\s+bytes\s+delivered/) { $stats{'bytes_delivered'} = $1 * 1024; }
    if ($line =~ /^\s*(\d+)\s+senders/) { $stats{'senders'} = $1; }
    if ($line =~ /^\s*(\d+)\s+sending\s+hosts\/domains/) { $stats{'sending_hosts_domains'} = $1; }
    if ($line =~ /^\s*(\d+)\s+recipients/) { $stats{'recipients'} = $1; }
    if ($line =~ /^\s*(\d+)\s+recipient\s+hosts\/domains/) { $stats{'recipient_hosts_domains'} = $1; }
}

foreach my $key (sort keys %stats) {
    print "zimbra-stats $key=$stats{$key}\n";
}
