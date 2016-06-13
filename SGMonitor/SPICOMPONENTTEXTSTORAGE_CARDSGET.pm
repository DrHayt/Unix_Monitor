use strict;
use warnings;
package SGMonitor::SPICOMPONENTTEXTSTORAGE_CARDSGET;
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

    $self->{SERVICE_NAME}="SPICOMPONENTTEXTSTORAGE.CARDSGET";
    $self->{BASE_STRING}="ServiceBus.monitor." . uc($self->{SERVICE_NAME});

    my $START=$args->{START} || 1000;
    my $RANGE=$args->{RANGE} || 900;

    $self->{PROPERTYID}=$args->{PROPERTYID} || int(rand($self->{RANGE}))+$self->{START};

    return(bless($self,$class));
}

sub run(){
    my $self=shift;

    my %params=( 'PROPERTYID' => $self->{PROPERTYID}
                );

    my ($elapsed,$status,$extra)=$self->{SB}->call_object($self->{SERVICE_NAME},\%params);

    return($self->{BASE_STRING},$elapsed,$status,$extra);
}


1;
