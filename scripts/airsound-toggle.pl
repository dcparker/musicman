#!/usr/bin/perl

if(`SwitchAudioSource -c -t output` =~ /Built-in/) {
  `airsound.pl`;
} else {
  system("airsound-off.pl");
}
