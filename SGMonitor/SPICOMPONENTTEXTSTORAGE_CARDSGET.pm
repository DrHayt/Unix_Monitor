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

    # All these are successfull
    push (@{$self->{SLUGS}->{DEFAULT}},3400162);
    push (@{$self->{SLUGS}->{DEFAULT}},3400171);
    push (@{$self->{SLUGS}->{DEFAULT}},3400173);
    push (@{$self->{SLUGS}->{DEFAULT}},3400179);
    push (@{$self->{SLUGS}->{DEFAULT}},3400180);
    push (@{$self->{SLUGS}->{DEFAULT}},3400181);
    push (@{$self->{SLUGS}->{DEFAULT}},3400182);
    push (@{$self->{SLUGS}->{DEFAULT}},3400186);
    push (@{$self->{SLUGS}->{DEFAULT}},3400187);
    push (@{$self->{SLUGS}->{DEFAULT}},3400188);
    push (@{$self->{SLUGS}->{DEFAULT}},3400193);
    push (@{$self->{SLUGS}->{DEFAULT}},3400200);
    push (@{$self->{SLUGS}->{DEFAULT}},3400201);
    push (@{$self->{SLUGS}->{DEFAULT}},3400202);
    push (@{$self->{SLUGS}->{DEFAULT}},3400205);
    push (@{$self->{SLUGS}->{DEFAULT}},3400206);
    push (@{$self->{SLUGS}->{DEFAULT}},3400207);
    push (@{$self->{SLUGS}->{DEFAULT}},3400210);
    push (@{$self->{SLUGS}->{DEFAULT}},3400211);
    push (@{$self->{SLUGS}->{DEFAULT}},3400219);
    push (@{$self->{SLUGS}->{DEFAULT}},3400221);
    push (@{$self->{SLUGS}->{DEFAULT}},3400223);
    # For development.
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

    my @slugsarray=@{$self->{SLUGS}->{$self->{ENVIRONMENT}}};
    my $propertyid=$self->{PROPERTYID} || $slugsarray[int(rand(scalar(@slugsarray)))];
    #my $propertyid=$self->{PROPERTYID} || int(rand($self->{RANGE}))+$self->{START};

    if ($self->{DEBUG}) {
      printf("SPICOMPONENTTEXTSTORAGE_CARDSGET: I chose %s\n",$propertyid)
    }


    my %params=( 'PROPERTYID' => int($propertyid)
                );

    my ($elapsed,$status,$extra)=$self->{SB}->call_object($self->{SERVICE_NAME},\%params);

    return($self->{BASE_STRING},$elapsed,$status,$extra);
}

1;
