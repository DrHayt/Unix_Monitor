use strict;
use warnings;
package SGMonitor::CLW_120;
use SGMonitor::Helpers::CLW;
use Data::Dumper;
use Net::Statsd;
use Sys::Hostname;

sub new(){
    my ($class,$args)=@_;
    my $self = {};

    $self->{SB}=SGMonitor::Helpers::CLW->new( $args );
    $self->{host}=hostname();
    $self->{host}=~ s/\./_/g;

    $self->{DEBUG} = $args->{DEBUG} || 0;

    $self->{SERVICE_NAME}="WD120";
    $self->{BASE_STRING}="SPI.monitor." . uc($self->{SERVICE_NAME});

    return(bless($self,$class));
}

sub run(){
    my $self=shift;
    my $start=100100100;
    my $range=5000000;
    my $ordernumber=int(rand($range))+$start;

    my %params=( 'WorkOrderNumber' => $ordernumber 
                );
                #,'IgnoreSPI' => JSON::false );

    my ($elapsed,$status,$extra)=$self->{SB}->call_object($self->{SERVICE_NAME},\%params);

    Net::Statsd::timing($self->{BASE_STRING}.".".$status,$elapsed*1000);

    return($self->{BASE_STRING},$elapsed,$status,$extra);
}


1;
