use strict;
use warnings;
package SGMonitor::BidsService_ListApprovalRequests;
use SGMonitor::Helpers::ServiceBus;
use Data::Dumper;
use Sys::Hostname;

sub new(){
    my ($class,$args)=@_;
    my $self = {};

    $self->{SB}=SGMonitor::Helpers::ServiceBus->new( $args );

    $self->{DEBUG} = $args->{DEBUG} || 0;

    $self->{SERVICE_NAME}="BidsService.ListApprovalRequests";
    $self->{BASE_STRING}="ServiceBus.monitor." . uc($self->{SERVICE_NAME});

    return(bless($self,$class));
}

sub run(){
    my $self=shift;

    my %params=( SubmissionId => '251834',
                 #LoanNumber => '1982127159',
                 #SpiPropertyId => 14508357
                 #IncludeWas => JSON::false,
                 #IncludeCorrectedDamages => JSON::false
                );

    my ($elapsed,$status,$extra)=$self->{SB}->call_object($self->{SERVICE_NAME},\%params);

    return($self->{BASE_STRING},$elapsed,$status,$extra);
}


1;
