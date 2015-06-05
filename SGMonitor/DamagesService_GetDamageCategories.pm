use strict;
use warnings;
package SGMonitor::DamagesService_GetDamageCategories;
use SGMonitor::Helpers::ServiceBus;
use Data::Dumper;
use Net::Statsd;
use Sys::Hostname;

sub new(){
    my ($class,$args)=@_;
    my $self = {};

    $self->{SB}=SGMonitor::Helpers::ServiceBus->new( $args );

    $self->{DEBUG} = $args->{DEBUG} || 0;

    $self->{SERVICE_NAME}="DamagesService.GetDamageCategories";
    $self->{BASE_STRING}="ServiceBus.monitor." . uc($self->{SERVICE_NAME});

    return(bless($self,$class));
}

sub run(){
    my $self=shift;
    
    my @options=(1,2,3,20);

    my $range=scalar(@options);
    my $number=int(rand($range));

    #print("Number is $number, option is: ".$options[$number]."\n");

    # AddValidationRule("DamagesService.GetReportedDamage", "ReportedDamageId", typeof(long));

    my %params=( ModuleId => $options[$number]
                );

    my ($elapsed,$status,$extra)=$self->{SB}->call_object($self->{SERVICE_NAME},\%params);

    return($self->{BASE_STRING},$elapsed,$status,$extra);
}


1;
