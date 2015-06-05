use strict;
use warnings;
package SGMonitor::RatingService_RateRequest;
use SGMonitor::Helpers::ServiceBus;
use Data::Dumper;
use Net::Statsd;
use Sys::Hostname;

sub new(){
    my ($class,$args)=@_;
    my $self = {};

    $self->{SB}=SGMonitor::Helpers::ServiceBus->new( $args );
    $self->{DEBUG} = $args->{DEBUG} || 0;

    $self->{SERVICE_NAME}="RatingService.RateRequest";
    $self->{BASE_STRING}="ServiceBus.monitor." . uc($self->{SERVICE_NAME});

    return(bless($self,$class));
}

sub run(){
    my $self=shift;

    my $params = "{ 'raterequest' : { 'Tasks' : [ { 'Measures' : [ { 'Value' : 0, 'UnitOfMeasure' : 'IN', 'Type' : 'HEIGHT' }, { 'Value' : 100, 'UnitOfMeasure' : 'IN', 'Type' : 'LENGTH' }, { 'Value' : 50, 'UnitOfMeasure' : 'IN', 'Type' : 'WIDTH' } ], 'SequenceNumber' : 0, 'TaskId' : '2510' } ], 'LoanType' : 'CV', 'WorkCode' : 'GCL', 'Occupied' : 'V', 'State' : 'OH', 'AccessGained' : '', 'ServiceLine' : 'PP', 'PricingDate' : '2015-05-08', 'ZipCode' : '44092', 'ClientId' : 'RRR', 'VendorId' : 'INRESR' } }"; 

    my ($elapsed,$status,$extra)=$self->{SB}->call($self->{SERVICE_NAME},$params);

    Net::Statsd::timing($self->{BASE_STRING}.".".$status,$elapsed*1000);

    return($self->{BASE_STRING},$elapsed,$status,$extra);
}


1;
