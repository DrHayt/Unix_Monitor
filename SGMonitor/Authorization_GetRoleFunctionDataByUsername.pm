use strict;
use warnings;
package SGMonitor::Authorization_GetRoleFunctionDataByUsername;
use SGMonitor::Helpers::ServiceBus;
use Data::Dumper;
use Sys::Hostname;

sub new(){
    my ($class,$args)=@_;
    my $self = {};

    $self->{SB}=SGMonitor::Helpers::ServiceBus->new( $args );
    $self->{DEBUG} = $args->{DEBUG} || 0;

    $self->{SERVICE_NAME}="Authorization.GetRoleFunctionDataByUsername";
    $self->{BASE_STRING}="ServiceBus.monitor." . uc($self->{SERVICE_NAME});
    $self->{USERNAME}=$args{'USERNAME'} || "rick.moran";
    $self->{APPLICATIONID}=$args{'APPLICATIONID'} || "642";

    return(bless($self,$class));
}

sub run(){
    my $self=shift;

    my %params=( 'username' => $self->{USERNAME} );
    my %params=( 'applicationID' => $self->{APPLICATIONID} );

    my ($elapsed,$status,$extra)=$self->{SB}->call_object($self->{SERVICE_NAME},\%params);

    return($self->{BASE_STRING},$elapsed,$status,$extra);

}


1;
