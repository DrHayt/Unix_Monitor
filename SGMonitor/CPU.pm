use strict;
use warnings;
package SGMonitor::CPU;
use Net::Statsd;
use Sys::Hostname;
use SGMonitor::Helpers::cpu_stats;

sub new(){
    my $class=shift;
    my $self = {};

    #  Get an initial copy of the data.
    $self->{CPU_STATS}=SGMonitor::Helpers::cpu_stats->new();
    sleep(1);

    $self->{host}=hostname;
    $self->{host}=~ s/\./_/g;


    return(bless($self,$class));
}

sub run(){
    my $self=shift;
    $self->{CPU_STATS}->refresh_stats();
    foreach my $stat ($self->{CPU_STATS}->get_stat_types()){
        #printf("Sending %s on host %s \n",$stat,$self->{host});
        $self->send_cpustat(
                    $stat,
                    $self->{CPU_STATS}->get_stat($stat),
                    $self->{CPU_STATS}->get_stat('total'),
                    $self->{host}
                    );
    }
}

sub send_cpustat($$$$){
        my $self=shift;
	my $name=shift;
	my $used=shift;
	my $total=shift;
	my $host=shift;

        #printf("Name is %s, used is %s, total is %s, host is %s\n",$name,$used,$total,$host);

	my $send_name='system.' . $host .'.cpu.' . $name;
	my $value=(($used/$total)*100);
	printf("Sending %s, with Value %s\n",$send_name,$value);
	#Net::Statsd::gauge($send_name, (($used/$total)*100));
	
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
