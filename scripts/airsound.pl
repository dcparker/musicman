#!/usr/bin/perl

use POSIX;
POSIX::setsid or die "setsid: $!";
my $pid = fork;
if($pid < 0) {
  die "fork: $!";
} elsif($pid) {
  exit 0;
}
chdir "/";
umask 0;
foreach(0 .. (POSIX::sysconf (&POSIX::_SC_OPEN_MAX) || 1024)) { POSIX::close $_ }
open(STDIN, "</dev/null");
open(STDOUT, ">/dev/null");
open(STDERR, ">&STDOUT");

$SIG{'ABRT'} = $SIG{'INT'} = $SIG{'TERM'} = sub {
  `SwitchAudioSource -t output -s \"Built-in Output\"`;
  `killall esd 2>/dev/null`;
  `killall esdrec 2>/dev/null`;
  exit;
};

`esd -d \"Soundflower (2ch)\" -nobeeps -tcp -bind 0.0.0.0 -port 16001 2>/dev/null &`;
`SwitchAudioSource -t output -s \"Soundflower (2ch)\"`;
`esdrec -s 0.0.0.0:16001 2>/dev/null | nc 192.168.1.90 4712 &`;
