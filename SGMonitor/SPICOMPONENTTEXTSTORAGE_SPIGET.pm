use strict;
use warnings;
package SGMonitor::SPICOMPONENTTEXTSTORAGE_SPIGET;
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

    $self->{SERVICE_NAME}="SPICOMPONENTTEXTSTORAGE.SPIGET";
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
    push (@{$self->{SLUGS}->{DEVELOPMENT}},"9432370,600003210,111806526");
    push (@{$self->{SLUGS}->{DEVELOPMENT}},"9432372,600003128,111806532");
    push (@{$self->{SLUGS}->{DEVELOPMENT}},"9432373,600003130,111806535");
    push (@{$self->{SLUGS}->{DEVELOPMENT}},"9432372,600003128,111806531");
    push (@{$self->{SLUGS}->{DEVELOPMENT}},"9432373,600003130,111806536");
    push (@{$self->{SLUGS}->{DEVELOPMENT}},"9432374,600003131,111806539");
    push (@{$self->{SLUGS}->{DEVELOPMENT}},"9432341,600003215,111806543");
    push (@{$self->{SLUGS}->{DEVELOPMENT}},"9432341,600003216,111806544");
    push (@{$self->{SLUGS}->{DEVELOPMENT}},"9432342,600003218,111806550");
    push (@{$self->{SLUGS}->{DEVELOPMENT}},"9432342,600003218,111806549");


    $self->{PROPERTYID}=$args->{PROPERTYID} || undef;
    $self->{ORDERNUMBER}=$args->{ORDERNUMBER} || undef;
    $self->{TEXTID}=$args->{TEXTID} || undef;

    return(bless($self,$class));
}

sub run(){
    my $self=shift;

    my $propertyid;
    my $ordernumber;
    my $textid;

    my @slugsarray=@{$self->{SLUGS}->{$self->{ENVIRONMENT}}};

    if (defined($self->{PROPERTYID}) && defined ($self->{ORDERNUMBER}) && defined($self->{TEXTID})) {
      $propertyid=$self->{PROPERTYID};
      $ordernumber=$self->{ORDERNUMBER};
      $textid=$self->{TEXTID};
    } else {
      my $slug=$self->{PROPERTYID} || $slugsarray[int(rand(scalar(@slugsarray)))];
      ($propertyid,$ordernumber,$textid)=split(/,/,$slug);
    }

    if ($self->{DEBUG}) {
      printf("SPICOMPONENTTEXTSTORAGE_SPIGET: I chose %d,%d,%d\n",$propertyid,$ordernumber,$textid)
    }


    my %params=( 'PROPERTYID' => int($propertyid),
                  'ORDERNUMBER' => int($ordernumber),
                  'componenttextid' => int($textid),
                );

    my ($elapsed,$status,$extra)=$self->{SB}->call_object($self->{SERVICE_NAME},\%params);

    return($self->{BASE_STRING},$elapsed,$status,$extra);
}

1;
