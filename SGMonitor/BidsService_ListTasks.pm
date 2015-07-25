use strict;
use warnings;
package SGMonitor::BidsService_ListTasks;
use SGMonitor::Helpers::ServiceBus;
use Data::Dumper;
use Sys::Hostname;

sub new(){
    my ($class,$args)=@_;
    my $self = {};

    $self->{SB}=SGMonitor::Helpers::ServiceBus->new( $args );
    $self->{DEBUG} = $args->{DEBUG} || 0;

    $self->{SERVICE_NAME}="BidsService.ListTasks";
    $self->{BASE_STRING}="ServiceBus.monitor." . uc($self->{SERVICE_NAME});
    $self->{ORDERNUMBER}=$args->{ORDERNUMBER} || 10442868;

    return(bless($self,$class));
}

sub run(){
    my $self=shift;

    my %params=( 'OrderNumber' => int($self->{ORDERNUMBER}) );
    #my %params=( 'Id' => 50000 );

    my ($elapsed,$status,$extra)=$self->{SB}->call_object($self->{SERVICE_NAME},\%params);

    return($self->{BASE_STRING},$elapsed,$status,$extra);

}


1;
