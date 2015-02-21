use strict;
use warnings;
package SGMonitor::Helpers::unix_load;
use Data::Dumper;

sub new(){
    my $class=shift;
    my $self = {};

    #  How many pids does it take to get to the center?
    open(MAXPIDFILE,"/proc/sys/kernel/pid_max");
        my $MAXPID=<MAXPIDFILE>;
        chomp($MAXPID);
    close(MAXPIDFILE);

    $self->{MAX_PID}=$MAXPID;
    
    $self->{STAT_FILE}="/proc/loadavg";

    open(STATS, $self->{STAT_FILE});
        $self->{STAT_LINE}=<STATS>;
        chomp($self->{STAT_LINE});
    close(STATS);

    my @tmparray=split(/ /,$self->{STAT_LINE});

    $self->{one_min}     = $tmparray[0];
    $self->{five_min}    = $tmparray[1];
    $self->{fifteen_min} = $tmparray[2];
    ($self->{active_procs},$self->{total_procs})=split(/\//,$tmparray[3]);
    $self->{pid_current} = $tmparray[4];
    $self->{pid_last}    = $self->{pid_current};

    $self->{pid_churn}   = 0;

    return(bless($self,$class));
}


sub get_stat($){
    my $self=shift;
    my $stat_to_get=shift;
    return($self->{$stat_to_get}) if defined($self->{$stat_to_get});
    return(undef);

}

sub refresh_stats(){
    my $self=shift;

    $self->{STAT_FILE}="/proc/loadavg";

    open(STATS, $self->{STAT_FILE});
        $self->{STAT_LINE}=<STATS>;
        chomp($self->{STAT_LINE});
    close(STATS);

    my @tmparray=split(/ /,$self->{STAT_LINE});

    $self->{one_min}        = $tmparray[0];
    $self->{five_min}        = $tmparray[1];
    $self->{fifteen_min}       = $tmparray[2];
    ($self->{active_procs},$self->{total_procs})=split(/\//,$tmparray[3]);
    $self->{pid_last}    = $self->{pid_current};
    $self->{pid_current} = $tmparray[4];

    if ($self->{pid_current} >= $self->{pid_last}){
        $self->{pid_churn}=$self->{pid_current} - $self->{pid_last};
    } else {
        $self->{pid_churn}=($self->{MAX_PID} - $self->{pid_last}) + $self->{pid_current};
    }

}
1;
