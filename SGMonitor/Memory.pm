use strict;
use warnings;
package SGMonitor::Memory;
use Net::Statsd;
use Sys::Hostname;
use SGMonitor::Helpers::Linux_Memory;

sub new(){
    my ($class,$args)=@_;
    my $self = {};


    $self->{DEBUG}=$args->{DEBUG} || 0;

    #  Get an initial copy of the data.
    $self->{STATS}=SGMonitor::Helpers::Linux_Memory->new();
    $self->{host}=hostname;
    $self->{host}=~ s/\./_/g;

    $self->{SEND_BASE}='system.' . $self->{host} .'.memory.';

    return(bless($self,$class));
}

sub run(){
    my $self=shift;
    $self->{STATS}->refresh_stats();
    foreach my $stat ($self->{STATS}->get_stat_names()){
        my $string=$self->{SEND_BASE}.$stat;
        my $value=$self->{STATS}->get_stat($stat);
        if ($self->{DEBUG}){
            print("Going to send $value for $string\n");
        }
	Net::Statsd::gauge($string, $value);
    }
	
    return(undef,undef,undef,undef);
}

1;
