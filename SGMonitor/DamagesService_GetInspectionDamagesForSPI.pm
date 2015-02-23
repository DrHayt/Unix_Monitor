use strict;
use warnings;
package SGMonitor::DamagesService_GetInspectionDamagesForSPI;
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
                #);
                #,'IgnoreSPI' => JSON::false );

    my ($elapsed,$status,$extra)=$self->{SB}->call_object($self->{SERVICE_NAME},\%params);

    Net::Statsd::timing($self->{BASE_STRING}.".".$status,$elapsed*1000);

    #if ($self->{DEBUG}){
        #print("$status: Order #$ordernumber took $elapsed seconds Extra: ". Dumper($extra) . "\n");
    #}
    #if( $status eq "SUCCESS"){
        #print("$status: Order #$ordernumber took $elapsed seconds\n");
    #} else {
        #print("$status: Order #$ordernumber took $elapsed seconds with body $extra\n");
    #}
}


1;
