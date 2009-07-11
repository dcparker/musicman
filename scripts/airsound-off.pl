#!/usr/bin/perl
`SwitchAudioSource -t output -s \"Built-in Output\"`;
system("kill `ps -A | grep airsound.pl -m 1 | awk '{print \$1}'`");
sleep 1;
system("kill `ps -A | grep airsound.pl -m 1 | awk '{print \$1}'`");
