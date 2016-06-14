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

    $self->{ENVIRONMENT}=$args->{ENVIRONMENT} || "DEFAULT";

    push (@{$self->{SLUGS}->{DEFAULT}},3400162);
    push (@{$self->{SLUGS}->{DEFAULT}},3400163);
    push (@{$self->{SLUGS}->{DEFAULT}},3400164);
    push (@{$self->{SLUGS}->{DEFAULT}},3400165);
    push (@{$self->{SLUGS}->{DEVELOPMENT}},9436982);
    push (@{$self->{SLUGS}->{DEVELOPMENT}},9436984);
    push (@{$self->{SLUGS}->{DEVELOPMENT}},9436986);
    push (@{$self->{SLUGS}->{DEVELOPMENT}},9436814);
    push (@{$self->{SLUGS}->{DEVELOPMENT}},9436987);

    $self->{PROPERTYID}=$args->{PROPERTYID} || undef;

    return(bless($self,$class));
}

sub run(){
    my $self=shift;

    my @slugsarray=@{$self->{SLUGS}->{$SELF->{ENVIRONMENT}}};
    my $propertyid=$self->{PROPERTYID} || $slugsarray[int(rand($#slugsarray))];
    #my $propertyid=$self->{PROPERTYID} || int(rand($self->{RANGE}))+$self->{START};
    

    my %params=( 'PROPERTYID' => int($propertyid)
                );

    my ($elapsed,$status,$extra)=$self->{SB}->call_object($self->{SERVICE_NAME},\%params);

    return($self->{BASE_STRING},$elapsed,$status,$extra);
}


1;
