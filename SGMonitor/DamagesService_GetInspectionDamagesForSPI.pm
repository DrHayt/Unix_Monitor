use strict;
use warnings;
package SGMonitor::DamagesService_GetInspectionDamagesForSPI;
use SGMonitor::Helpers::ServiceBus;
use Data::Dumper;
use Sys::Hostname;

sub new(){
    my ($class,$args)=@_;
    my $self = {};

    $self->{SB}=SGMonitor::Helpers::ServiceBus->new( $args );

    $self->{DEBUG} = $args->{DEBUG} || 0;

    $self->{SERVICE_NAME}="DamagesService.GetInspectionDamagesForSPI";
    $self->{BASE_STRING}="ServiceBus.monitor." . uc($self->{SERVICE_NAME});

    return(bless($self,$class));
}

sub run(){
    my $self=shift;
    my $start=100100100;
    my $range=30000000;
    my $ordernumber=int(rand($range))+$start;

    my %params=( 'ORDERNUMBER' => $ordernumber 
                ,'SB_DEBUG' => 0 );

    my ($elapsed,$status,$extra)=$self->{SB}->call_object($self->{SERVICE_NAME},\%params);

    return($self->{BASE_STRING},$elapsed,$status,$extra);
}


1;
