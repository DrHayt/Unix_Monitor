use strict;
use warnings;
package SGMonitor::DamagesService_GetDamageImagesForLoan;
use SGMonitor::Helpers::ServiceBus;
use Data::Dumper;
use Net::Statsd;
use Sys::Hostname;

sub new(){
    my ($class,$args)=@_;
    my $self = {};

    $self->{SB}=SGMonitor::Helpers::ServiceBus->new( $args );
    $self->{host}=hostname();
    $self->{host}=~ s/\./_/g;

    $self->{DEBUG} = $args->{DEBUG} || 0;

    $self->{SERVICE_NAME}="DamagesService.GetDamageImagesForLoan";
    $self->{BASE_STRING}="ServiceBus.monitor." . uc($self->{SERVICE_NAME});

    return(bless($self,$class));
}

sub run(){
    my $self=shift;
    #my $start=100100100;
    #my $range=30000000;
    #my $ordernumber=int(rand($range))+$start;

    #AddValidationRule("DamagesService.GetDamageImagesForLoan", "ClientCode", typeof(string));
    #AddValidationRule("DamagesService.GetDamageImagesForLoan", "LoanNumber", typeof(string));
    #AddValidationRule("DamagesService.GetDamageImagesForLoan", "SpiPropertyId", typeof(long));
    #AddValidationRule("DamagesService.GetDamageImagesForLoan", "IncludeWas", typeof(bool), false, true);
    #AddValidationRule("DamagesService.GetDamageImagesForLoan", "IsHash", typeof(bool), false, true);
    #AddValidationRule("DamagesService.GetDamageImagesForLoan", "IncludeCorrectedDamages", typeof(bool), false);

    #  Example from Mangesh;
    #CITI,0001712972,3400162,False,True
    #DMI,1432654869,14648908,True,True    (returned result)



    #my %params=( ClientCode => 'CITI',
    #             LoanNumber => '0001712972',
    #             SpiPropertyId => 3400162,
    #             IncludeWas => JSON::false,
    #             IncludeCorrectedDamages => JSON::true
    #            );
    my %params=( ClientCode => 'DMI',
                 LoanNumber => '1432654869',
                 SpiPropertyId => 14648908,
                 IncludeWas => JSON::true,
                 IncludeCorrectedDamages => JSON::true
                );

    my ($elapsed,$status,$extra)=$self->{SB}->call_object($self->{SERVICE_NAME},\%params);

    Net::Statsd::timing($self->{BASE_STRING}.".".$status,$elapsed*1000);

}


1;
