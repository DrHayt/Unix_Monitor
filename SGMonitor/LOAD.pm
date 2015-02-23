use strict;
use warnings;
package SGMonitor::LOAD;
use Net::Statsd;
use Sys::Hostname;
use SGMonitor::Helpers::unix_load;

sub new(){
    my ($class,$args)=@_;
    my $self = {};

    #  Get an initial copy of the data.
    $self->{DEBUG} = $args->{DEBUG} || 0;
    $self->{STATS}=SGMonitor::Helpers::unix_load->new();
    $self->{host}=hostname;
    $self->{host}=~ s/\./_/g;

    return(bless($self,$class));
}

sub run(){
    my $self=shift;
    $self->{STATS}->refresh_stats();
    Net::Statsd::gauge('system.' . $self->{host} . '.loadavg.1min', $self->{STATS}->get_stat('one_min'));
    Net::Statsd::gauge('system.' . $self->{host} . '.loadavg.5min', $self->{STATS}->get_stat('five_min'));
    Net::Statsd::gauge('system.' . $self->{host} . '.loadavg.15min', $self->{STATS}->get_stat('fifteen_min'));
    Net::Statsd::gauge('system.' . $self->{host} . '.process.churn', $self->{STATS}->get_stat('pid_churn'));
    Net::Statsd::gauge('system.' . $self->{host} . '.process.active', $self->{STATS}->get_stat('active_procs'));
    Net::Statsd::gauge('system.' . $self->{host} . '.process.total', $self->{STATS}->get_stat('total_procs'));
}

1;
