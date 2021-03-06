#!/usr/bin/perl -w
use strict;
use warnings;
use lib $ENV{'HOME'}."/perl5";
use Data::Dumper;
use Time::HiRes qw(gettimeofday usleep);
use Sys::Syslog;         # oh noes! standards?! logging?! [*head explodes*]
use Net::Statsd;


#
# Some default config values
#
################################################################################

my $params;
# Behaviors
$params->{INTERVAL}=3;
$params->{TIME_TO_LIVE}=30;
$params->{TIME_RANGE}=60;
$params->{TIMING}=0;
$params->{RUNONCE}=0;
$params->{SYSLOG_SUCCESS}=0;
$params->{FAILED}=0;
$params->{SYSLOG}=0;
$params->{STATSD}=1;
$params->{EXTRA}=0;

$|=1;


# Initialization
my $CLASS_BASE ="SGMonitor";

################################################################################
#
#
#

#  Check to see if we got a monitor to run as an argument.
if ($#ARGV lt 0){
    #  WTF jeeves, need to stow that shit with the no argument business.
    &usage();
}

#  Select the monitor which should be the first argument off the list.
my $monitor=shift(@ARGV);

my $real_monitor=$CLASS_BASE . "::" . $monitor;

#
#  Are we able to instantiate that module
#
################################################################################
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
################################################################################
#
#
#


#
# Swallow all KEY=VALUE arguments into the parameter array.
#
################################################################################
foreach my $arg (@ARGV){
    my ($key,$value)=split(/=/,$arg);
    $params->{$key}=$value;
}
################################################################################
#
#
#

my $lifetime=$params->{TIME_TO_LIVE}+int(rand($params->{TIME_RANGE}));

#print(Dumper(%params));

my $startup_time=gettimeofday();

my $The_Monitor=$real_monitor->new( $params );

openlog("Monitor $monitor", 'ndelay', 'user');

my $COUNT=0;


while(1){
    my $t0=gettimeofday();
    my ($monitor_name,$monitor_time,$monitor_result,$monitor_extra)=$The_Monitor->run();
    my $t1=gettimeofday();


    if ($params->{INTERVAL} == '0'){
	print("Count is $COUNT        \r");
	$COUNT++;
	}


    my $elapsed=$t1-$t0;

    my $remaining=$params->{INTERVAL} - $elapsed;

    my $fmt_string="SERVICE=%s STATUS=%s ELAPSED=%.2f";

    if(defined($monitor_name)){
	# this means that we got a complete message back from the monitor;
	
	# Shoule we statsd?
	if($params->{STATSD}){
	    Net::Statsd::timing($monitor_name.".".$monitor_result,$monitor_time*1000);
	}


	# Should we syslog?
	if($params->{SYSLOG}){
		if(($monitor_result eq 'SUCCESS') && $params->{SYSLOG_SUCCESS}){
		    syslog('info', $fmt_string, $monitor_name, $monitor_result, $monitor_time*1000);
                } else {
		    syslog('info', $fmt_string, $monitor_name, $monitor_result, $monitor_time*1000);
                }
        }

	if ($params->{EXTRA}){
            printf($fmt_string." %s\n", $monitor, $monitor_result, $monitor_time*1000,Dumper($monitor_extra));
        }
	if ($params->{FAILED}){
		if($monitor_result ne 'SUCCESS'){
		    printf($fmt_string." %s\n", $monitor, $monitor_result, $monitor_time*1000,Dumper($monitor_extra));
		}
        }
    }
    if ( $params->{TIMING} ) {
        printf($fmt_string."\n",$monitor,$monitor_result,$monitor_time*1000);
    }

    last if(int($t1-$startup_time) > ($lifetime*60));

    last if($params->{RUNONCE});

    if ($remaining >0){
        usleep($remaining*1000000);
    }
}

closelog();

sub usage(){
    print(STDERR "This program requires 1 argument which is the name of a monitor to run.\n");
    die("\t$0 <Monitor To Run>");
}
