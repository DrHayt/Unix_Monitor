use strict;
use warnings;
package SGMonitor::CPU;
use Net::Statsd;
use Data::Dumper;
use Sys::Hostname;
use SGMonitor::Helpers::cpu_stats;

sub new(){
    my $class=shift;
    my $self = {};

    #  Get an initial copy of the data.
    $self->{CPU_STATS}=SGMonitor::Helpers::cpu_stats->new();

    $self->{host}=hostname;
    $self->{host}=~ s/\./_/g;


    return(bless($self,$class));
}

sub run(){
    my $self=shift;
    $self->{CPU_STATS}->refresh_stats();
    foreach my $stat (qw(user system nice idle iowait irq softirq)){
        print("Sending $stat\n");
    }
    #&send_cpustat($self->{CPU_STATS}->get_stat(
}

sub send_cpustat($$$$){
        my $self=shift;
	my $name=shift;
	my $used=shift;
	my $total=shift;
	my $host=shift;
	my $send_name='system.' . $host .'.cpu.' . $name;
	Net::Statsd::gauge($send_name, (($used/$total)*100));
	
}


sub calc_pct($$){
	my $user=shift;
	my $total=shift;
	my $pct=($user/$total)*100;
	return($pct);
}

sub get_cpu_data(){
        my $self=shift;
	open(LOADAVG,"/proc/stat");
	my $line=<LOADAVG>;
	chomp($line);
	my @tmparray=split(/ /,$line);
	close(LOADAVG);
	return(@tmparray);
}

1;
