#!/usr/bin/perl

$volume = `curl http://192.168.1.90:6874/volume_get?sink_input_index=3`;
if($volume =~ /{'volume': (\d+)}/){
  $volume = $1;
}

print "From volume $volume to ";
$volume -= 8;
print "$volume.";

print `curl \"http://192.168.1.90:6874/volume_set?sink_input_index=3\&volume=$volume\"`;

# Weirdness, I have to run ssh to get the right environment to do the growling.
open($ssh, '| ssh -ldaniel localhost') or die $!;
print $ssh "/usr/local/bin/growlnotify -m 'Volume set to $volume%' -H localhost -P avjodfjl -n World";
print $ssh 'exit';
close $ssh;
