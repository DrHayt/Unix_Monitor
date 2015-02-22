use strict;
use warnings;
package SGMonitor::SPIDataService_GetPropertyInfo;
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

    $self->{BASE_STRING}="ServiceBus.monitor.SPIDATASERVICE.GETPROPERTYINFO";

    return(bless($self,$class));
}

sub run(){
    my $self=shift;
    my $start=10000000;
    my $range=4500000;
    my $propertyid=int(rand($range))+$start;

    my %params=( 'propertyid' => $propertyid );

    my ($elapsed,$status,$extra)=$self->{SB}->call_object("SPIDataService.GetPropertyInfo",\%params);

    Net::Statsd::timing($self->{BASE_STRING}.".".$status,$elapsed*1000);

    #if( $status eq "SUCCESS"){
        #print("$status: Order #$ordernumber took $elapsed seconds\n");
    #} else {
        #print("$status: Order #$ordernumber took $elapsed seconds with body $extra\n");
    #}
}

1;
