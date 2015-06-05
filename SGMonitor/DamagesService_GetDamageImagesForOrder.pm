use strict;
use warnings;
package SGMonitor::DamagesService_GetDamageImagesForOrder;
use SGMonitor::Helpers::ServiceBus;
use Data::Dumper;
use Sys::Hostname;

sub new(){
    my ($class,$args)=@_;
    my $self = {};

    $self->{SB}=SGMonitor::Helpers::ServiceBus->new( $args );

    $self->{DEBUG} = $args->{DEBUG} || 0;

    $self->{START} = $args->{RANGE_START} || 100100100;
    $self->{RANGE} = $args->{RANGE_SIZE} || 30000000;

    $self->{SERVICE_NAME}="DamagesService.GetDamageImagesForOrder";
    $self->{BASE_STRING}="ServiceBus.monitor." . uc($self->{SERVICE_NAME});

    return(bless($self,$class));
}

sub run(){
    my $self=shift;

    my $ordernumber=int(rand($self->{RANGE}))+$self->{START};

    my %params=( 'ORDERNUMBER' => $ordernumber 
                );

    my ($elapsed,$status,$extra)=$self->{SB}->call_object($self->{SERVICE_NAME},\%params);

    return($self->{BASE_STRING},$elapsed,$status,$extra);

}


1;
