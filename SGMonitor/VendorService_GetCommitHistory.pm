use strict;
use warnings;
package SGMonitor::VendorService_GetCommitHistory;
use SGMonitor::Helpers::ServiceBus;
use Data::Dumper;
use Net::Statsd;
use Sys::Hostname;

sub new(){
    my ($class,$args)=@_;
    my $self = {};

    $self->{SB}=SGMonitor::Helpers::ServiceBus->new( $args );
    $self->{host}=hostname();
    $self->{host}=~ s/\./_/g;
    $self->{DEBUG} = $args->{DEBUG} || 0;

    $self->{SERVICE_NAME}="VendorService.GetCommitHistory";
    $self->{BASE_STRING}="ServiceBus.monitor." . uc($self->{SERVICE_NAME});

    return(bless($self,$class));
}

sub run(){
    my $self=shift;
    my $start=100100100;
    my $range=30000000;
    my $ordernumber=int(rand($range))+$start;

    my %params=( 'OrderNumber' => $ordernumber );

    my ($elapsed,$status,$extra)=$self->{SB}->call_object($self->{SERVICE_NAME},\%params);

    Net::Statsd::timing($self->{BASE_STRING}.".".$status,$elapsed*1000);

}


1;