use strict;
use warnings;
package SGMonitor::ContentService_List;
use SGMonitor::Helpers::ServiceBus;
use Data::Dumper;

sub new(){
    my ($class,$args)=@_;
    my $self = {};

    $self->{SB}=SGMonitor::Helpers::ServiceBus->new( $args );

    return(bless($self,$class));
}

sub run(){
    my $self=shift;
    my $start=100100100;
    my $range=30000000;
    my $ordernumber=int(rand($range))+$start;

    my %params=( 'orderId' => $ordernumber );

    my ($elapsed,$status,$extra)=$self->{SB}->call_object("ContentService.List",\%params);
    if( $status eq "SUCCESS"){
        print("Yay, successful call took $elapsed seconds\n");
    } else {
        print("boo, failed call of type $status took $elapsed seconds with body $extra\n");
    }
}


1;
