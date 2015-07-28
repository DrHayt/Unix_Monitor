use strict;
use warnings;
package SGMonitor::SPIGlass_ProcessOrder;
use SGMonitor::Helpers::ServiceBus;
use Data::Dumper;
use Sys::Hostname;

sub new(){
    my ($class,$args)=@_;
    my $self = {};

    $self->{SB}=SGMonitor::Helpers::ServiceBus->new( $args );
    $self->{host}=hostname();
    $self->{host}=~ s/\./_/g;

    $self->{DEBUG} = $args->{DEBUG} || 0;

    $self->{SERVICE_NAME}="SPIGlass.ProcessOrder";
    $self->{BASE_STRING}="ServiceBus.monitor." . uc($self->{SERVICE_NAME});

    $self->{ORDERNUMBER} = $args->{ORDERNUMBER} || 0;

    return(bless($self,$class));
}

sub run(){
    my $self=shift;

    my %params=( 'OrderNumber' => $self->{ORDERNUMBER}
                ,'Source' => "VendorWeb" );

    my ($elapsed,$status,$extra)=$self->{SB}->call_object($self->{SERVICE_NAME},\%params);

    return($self->{BASE_STRING},$elapsed,$status,$extra);
}


1;
