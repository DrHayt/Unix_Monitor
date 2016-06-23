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
    push (@{$self->{SLUGS}->{DEFAULT}},3400210);
    push (@{$self->{SLUGS}->{DEFAULT}},3400211);
    push (@{$self->{SLUGS}->{DEFAULT}},3400219);
    push (@{$self->{SLUGS}->{DEFAULT}},3400221);
    push (@{$self->{SLUGS}->{DEFAULT}},3400223);
    # For development.
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451660);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451661);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451662);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451663);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451664);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451665);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451666);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451667);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451668);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451669);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451670);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451671);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451672);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451673);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451674);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451675);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451676);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451677);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451678);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451679);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451680);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451681);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451682);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451683);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451684);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451685);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451686);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451687);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451688);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451689);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451690);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451691);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451692);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451693);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451694);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451695);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451696);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451697);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451698);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451699);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451701);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451702);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451703);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451704);
push (@{$self->{SLUGS}->{DEVELOPMENT}},9451705);
    $self->{PROPERTYID}=$args->{PROPERTYID} || undef;

    return(bless($self,$class));
}

sub run(){
    my $self=shift;

    #my @slugsarray=@{$self->{SLUGS}->{$self->{ENVIRONMENT}}};
    my $index=int(rand(scalar(@{$self->{SLUGS}->{$self->{ENVIRONMENT}}})));
    my $propertyid=$self->{PROPERTYID} || @{$self->{SLUGS}->{$self->{ENVIRONMENT}}}[$index];
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
