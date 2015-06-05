use strict;
use warnings;
package SGMonitor::DamagesService_GetDamageImagesForDamage;
use SGMonitor::Helpers::ServiceBus;
use Data::Dumper;
use Sys::Hostname;

sub new(){
    my ($class,$args)=@_;
    my $self = {};

    $self->{SB}=SGMonitor::Helpers::ServiceBus->new( $args );

    $self->{DEBUG} = $args->{DEBUG} || 0;

    $self->{SERVICE_NAME}="DamagesService.GetDamageImagesForDamage";
    $self->{BASE_STRING}="ServiceBus.monitor." . uc($self->{SERVICE_NAME});

    return(bless($self,$class));
}

sub run(){
    my $self=shift;
    my $start=1;
    my $range=3000000;
    my $number=int(rand($range))+$start;

    # AddValidationRule("DamagesService.GetReportedDamage", "ReportedDamageId", typeof(long));

    my %params=( ReportedDamageId => $number
                );

    my ($elapsed,$status,$extra)=$self->{SB}->call_object($self->{SERVICE_NAME},\%params);

    return($self->{BASE_STRING},$elapsed,$status,$extra);

}


1;
