#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;

use lib $ENV{'HOME'}."/perl5";


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

my $The_Monitor=$real_monitor->new(@ARGV);

while(1){
    $The_Monitor->run();
    sleep(3);
}

sub usage(){
    print(STDERR "This program requires 1 argument which is the name of a monitor to run.\n");
    die("\t$0 <Monitor To Run>");
}
