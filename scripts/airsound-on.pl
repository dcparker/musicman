#!/usr/bin/perl
system("esd -d \"Soundflower (2ch)\" -tcp -bind 0.0.0.0 -port 16001 -nobeeps 2>/dev/null &");
sleep(1);
system("esdrec -s 0.0.0.0:16001 2>/dev/null | nc 192.168.1.90 4712 &");
system("./SwitchAudioSource -t output -s \"Soundflower (2ch)\"");
