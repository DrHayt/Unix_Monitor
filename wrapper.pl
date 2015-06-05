#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
use Time::HiRes qw(gettimeofday usleep);
use Sys::Syslog;         # oh noes! standards?! logging?! [*head explodes*]
use Net::Statsd;

use lib $ENV{'HOME'}."/perl5";

my $interval=3;

my $time_to_live=30;
my $time_range=60;

my $runonce=0;


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
$params->{INTERVAL}=$interval;
$params->{TIMING}=0;
$params->{SYSLOG}=1;
$params->{STATSD}=1;

foreach my $arg (@ARGV){
    my ($key,$value)=split(/=/,$arg);
    $params->{$key}=$value;
}

if (exists($params->{STATSD})){
    $interval=$params->{STATSD};
}

if (exists($params->{SYSLOG})){
    $interval=$params->{SYSLOG};
}

if (exists($params->{INTERVAL})){
    $interval=$params->{INTERVAL};
}

if (exists($params->{TIME_TO_LIVE})){
    $time_to_live=$params->{TIME_TO_LIVE};
}

if (exists($params->{TIME_RANGE})){
    $time_range=$params->{TIME_RANGE};
}

if (exists($params->{RUNONCE})){
    $runonce=$params->{RUNONCE};
}


my $lifetime=$time_to_live+int(rand($time_range));

#print(Dumper(%params));

my $startup_time=gettimeofday();

my $The_Monitor=$real_monitor->new( $params );

openlog("Monitor $monitor", 'ndelay', 'user');

while(1){
    my $t0=gettimeofday();
    my @tmparray=$The_Monitor->run();
    my $t1=gettimeofday();


    my $elapsed=$t1-$t0;

    my $remaining=$interval - $elapsed;

    my $fmt_string="SERVICE=%s STATUS=%s ELAPSED=%.2f";

    if (defined($tmparray[0]) && $params->{STATSD}){
	Net::Statsd::timing($tmparray[0].".".$tmparray[2],$tmparray[1]*1000);
    }

    if (defined($tmparray[0]) && $params->{SYSLOG}){
	syslog('info', $fmt_string, $monitor, $tmparray[2], $tmparray[1]*1000);
    }

    if (defined($tmparray[0]) && $params->{TIMING}){
        printf($fmt_string."\n", $monitor, $tmparray[2], $tmparray[1]*1000);
    } elsif ( $params->{TIMING} ) {
        print("Total Call took $elapsed\n");
    }

        #printf($fmt_string."\n", $monitor, $tmparray[2], $tmparray[1]*1000);

    last if(int($t1-$startup_time) > ($lifetime*60));

    last if($runonce);

    if ($remaining >0){
        usleep($remaining*1000000);
    }
}

closelog();

sub usage(){
    print(STDERR "This program requires 1 argument which is the name of a monitor to run.\n");
    die("\t$0 <Monitor To Run>");
}
