use strict;
use warnings;
package SGMonitor::SPIGlass_GetRestatedINSPIBids;
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

    $self->{SERVICE_NAME}="SPIGlass.GetRestated";
    $self->{BASE_STRING}="ServiceBus.monitor." . uc($self->{SERVICE_NAME});

    return(bless($self,$class));
}

sub run(){
    my $self=shift;
    my $start=14000000;
    my $range=1000000;
    my $propertyid=int(rand($range))+$start;

    my %params=( 'PropertyId' => $propertyid ,
                'IncludeBids' => JSON::false,
                'Source'      => 'INSPI'
                );
                #,'IgnoreSPI' => JSON::false );

    my ($elapsed,$status,$extra)=$self->{SB}->call_object($self->{SERVICE_NAME},\%params);

    return($self->{BASE_STRING},$elapsed,$status,$extra);
}


1;
