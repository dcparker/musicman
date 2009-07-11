#!/usr/bin/perl

$volume = `curl http://el-yora:6874/volume_get?name=Fenestra`;
if($volume =~ /{'volume': (\d+)}/){
  $volume = $1;
}

print "From volume $volume to ";
$volume += 8;
print "$volume.";

print `curl \"http://el-yora:6874/volume_set?name=Fenestra\&volume=$volume\"`;

# Weirdness, I have to run ssh to get the right environment to do the growling.
open($ssh, '| ssh -ldaniel localhost') or die $!;
print $ssh "/usr/local/bin/growlnotify -m 'Volume set to $volume%' -H localhost -P avjodfjl -n World";
print $ssh 'exit';
close $ssh;
