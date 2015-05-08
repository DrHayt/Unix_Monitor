use strict;
use warnings;
package SGMonitor::ContentService_List;
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

    $self->{START} = $args->{RANGE_START} || 100100100;
    $self->{RANGE} = $args->{RANGE_SIZE} || 30000000;

    $self->{SERVICE_NAME}="ContentService.List";
    $self->{BASE_STRING}="ServiceBus.monitor." . uc($self->{SERVICE_NAME});

    return(bless($self,$class));
}

sub run(){
    my $self=shift;
    #my $start=1#;
    #my $range=30000000;
    my $ordernumber=int(rand($self->{RANGE}))+$self->{START};

    my %params=( 'orderId' => $ordernumber );

    my ($elapsed,$status,$extra)=$self->{SB}->call_object($self->{SERVICE_NAME},\%params);

    Net::Statsd::timing($self->{BASE_STRING}.".".$status,$elapsed*1000);

}


1;
