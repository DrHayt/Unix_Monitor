use strict;
use warnings;
package SGMonitor::Utility_Ping;
use SGMonitor::Helpers::ServiceBus;
use Data::Dumper;
use Net::Statsd;
use Sys::Hostname;

sub new(){
    my ($class,$args)=@_;
    my $self = {};

    $self->{DELAYMILLISECONDS} = $args->{DELAYMILLISECONDS} || 1;


    $self->{RANDMIN}=$args->{RANDMIN} || 1;
    $self->{RANDRANGE}=$args->{RANDRANGE} || 1;

    $self->{DEBUG} = $args->{DEBUG} || 0;
    $self->{SB}=SGMonitor::Helpers::ServiceBus->new( $args );
    $self->{host}=hostname();
    $self->{host}=~ s/\./_/g;

    $self->{SERVICE_NAME}="Utility.Ping";
    $self->{BASE_STRING}="ServiceBus.monitor." . uc($self->{SERVICE_NAME});

    return(bless($self,$class));
}

sub run(){
    my $self=shift;
    my $delay=int(rand($self->{RANDRANGE}))+$self->{RANDMIN};

    my %params=( 'Delaymilliseconds' => $delay );

    my ($elapsed,$status,$extra)=$self->{SB}->call_object($self->{SERVICE_NAME},\%params);

    return($self->{BASE_STRING},$elapsed,$status,$extra);
}


1;
