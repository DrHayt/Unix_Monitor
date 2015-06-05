use strict;
use warnings;
package SGMonitor::BackgroundCheckService_GetResourceByEmail;
use SGMonitor::Helpers::ServiceBus;
use Data::Dumper;
use Net::Statsd;
use Sys::Hostname;

sub new(){
    my ($class,$args)=@_;
    my $self = {};

    $self->{SB}=SGMonitor::Helpers::ServiceBus->new( $args );
    $self->{DEBUG} = $args->{DEBUG} || 0;
    $self->{EMAIL} = $args->{EMAIL} || 'val.chulskiy@safeguardproperties.com';

    $self->{SERVICE_NAME}="BackgroundCheckService.GetResourceByEmail";
    $self->{BASE_STRING}="ServiceBus.monitor." . uc($self->{SERVICE_NAME});

    return(bless($self,$class));
}

sub run(){
    my $self=shift;

    my %params=( 'Email' => $self->{EMAIL} );

    my ($elapsed,$status,$extra)=$self->{SB}->call_object($self->{SERVICE_NAME},\%params);

    Net::Statsd::timing($self->{BASE_STRING}.".".$status,$elapsed*1000);

    return($self->{BASE_STRING},$elapsed,$status,$extra);

}


1;
