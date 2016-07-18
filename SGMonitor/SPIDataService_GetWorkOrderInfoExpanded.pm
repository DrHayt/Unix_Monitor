use strict;
use warnings;
package SGMonitor::SPIDataService_GetWorkOrderInfoExpanded;
use SGMonitor::Helpers::ServiceBus;
use Data::Dumper;
use Sys::Hostname;

sub new(){
    my ($class,$args)=@_;
    my $self = {};

    $self->{DEBUG} = $args->{DEBUG} || 0;
    $self->{SB}=SGMonitor::Helpers::ServiceBus->new( $args );
    $self->{host}=hostname();
    $self->{host}=~ s/\./_/g;

    $self->{SERVICE_NAME}="SPIDataService.GetWorkOrderInfoExpanded";
    $self->{BASE_STRING}="ServiceBus.monitor." . uc($self->{SERVICE_NAME});

    $self->{RANGE}=60000000;
    $self->{START}=100000000;
    $self->{ORDERNUMBER}=$args->{ORDERNUMBER} || int(rand($self->{RANGE}))+$self->{START};


    return(bless($self,$class));
}

sub run(){
    my $self=shift;
    my $ordernumber=int($self->{ORDERNUMBER});

    my %params=( 'ordernumber' => int($ordernumber) );

    my ($elapsed,$status,$extra)=$self->{SB}->call_object($self->{SERVICE_NAME},\%params);

    return($self->{BASE_STRING},$elapsed,$status,$extra);
}


1;
