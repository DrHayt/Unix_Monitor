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
    #  For this call, the propertyid and the ordernumber are irrelevant.
    push (@{$self->{SLUGS}->{DEFAULT}},"1,1,111806526");
    push (@{$self->{SLUGS}->{DEFAULT}},"1,1,111806532");
    push (@{$self->{SLUGS}->{DEFAULT}},"1,1,111806535");
    push (@{$self->{SLUGS}->{DEFAULT}},"1,1,111806531");
    push (@{$self->{SLUGS}->{DEFAULT}},"1,1,111806536");
    push (@{$self->{SLUGS}->{DEFAULT}},"1,1,111806539");
    push (@{$self->{SLUGS}->{DEFAULT}},"1,1,111806543");
    push (@{$self->{SLUGS}->{DEFAULT}},"1,1,111806544");
    push (@{$self->{SLUGS}->{DEFAULT}},"1,1,111806550");
    push (@{$self->{SLUGS}->{DEFAULT}},"1,1,111806549");
    push (@{$self->{SLUGS}->{DEFAULT}},"1,1,111807549");
    push (@{$self->{SLUGS}->{DEFAULT}},"1,1,111808549");
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
