#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
use Time::HiRes qw(gettimeofday usleep);

use lib $ENV{'HOME'}."/perl5";


my $interval=10;


my $CLASS_BASE ="SGMonitor";


#  Check to see if we got a monitor to run as an argument.
if ($#ARGV lt 0){
    #  WTF jeeves, need to stow that shit with the no argument business.
    &usage();
}

#  Select the monitor which should be the first argument off the list.
my $monitor=shift(@ARGV);

my $real_monitor=$CLASS_BASE . "::" . $monitor;

eval {
    (my $thing_to_require = $real_monitor) =~ s|::|/|g;
    $thing_to_require.='.pm';
    require $thing_to_require;
    1;
} or do {
    # Module load failed. You could recover, try loading
    # an alternate module, die with $error...
    # whatever's appropriate
    my $error = $@;
    print(STDERR "Received error message:" . $@ . "\n");
    die("Unable to load module $real_monitor derived from $monitor");

};


my $params;
$params->{TIMING}=0;
foreach my $arg (@ARGV){
    my ($key,$value)=split(/=/,$arg);
    $params->{$key}=$value;
}

if (exists($params->{INTERVAL})){
    $interval=$params->{INTERVAL};
}


#print(Dumper(%params));


my $The_Monitor=$real_monitor->new( $params );

while(1){
    my $t0=gettimeofday();
    $The_Monitor->run();
    my $t1=gettimeofday();

    my $elapsed=$t1-$t0;

    my $remaining=$interval - $elapsed;


    if($params->{TIMING}){
        print("Call took $elapsed\n");
    }

    if ($remaining >0){
        usleep($remaining*1000000);
    }
}

sub usage(){
    print(STDERR "This program requires 1 argument which is the name of a monitor to run.\n");
    die("\t$0 <Monitor To Run>");
}
