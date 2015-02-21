use strict;
use warnings;
use Data::Dumper;
package SGMonitor::Helpers::cpu_stats;

sub new(){
    my $class=shift;
    my $self = {};

    $self->{STAT_FILE}="/proc/stat";

    open(STATS, $self->{STAT_FILE});
        $self->{STAT_LINE}=<STATS>;
        chomp($self->{STAT_LINE});
    close(STATS);

    my @tmparray=split(/ /,$self->{STAT_LINE});

    @{$self->{stat_types}}=qw(user nice system idle iowait irq softirq total);

    $self->{oldstats}{user}   =$tmparray[2];
    $self->{oldstats}{nice}   =$tmparray[3];
    $self->{oldstats}{system} =$tmparray[4];
    $self->{oldstats}{idle}   =$tmparray[5];
    $self->{oldstats}{iowait} =$tmparray[6];
    $self->{oldstats}{irq}    =$tmparray[7];
    $self->{oldstats}{softirq}=$tmparray[8];
    $self->{oldstats}{total}  =0;

    $self->{stats}{user}   =$tmparray[2];
    $self->{stats}{nice}   =$tmparray[3];
    $self->{stats}{system} =$tmparray[4];
    $self->{stats}{idle}   =$tmparray[5];
    $self->{stats}{iowait} =$tmparray[6];
    $self->{stats}{irq}    =$tmparray[7];
    $self->{stats}{softirq}=$tmparray[8];
    $self->{stats}{total}  =0;

    $self->{user}=0;
    $self->{nice}=0;
    $self->{system}=0;
    $self->{idle}=0;
    $self->{iowait}=0;
    $self->{irq}=0;
    $self->{softirq}=0;
    $self->{total}=0;

    #  Must make sure we are protected.
    sleep(1);

    return(bless($self,$class));
}


sub get_stat($){
    my $self=shift;
    my $stat_to_get=shift;
    return($self->{$stat_to_get}) if defined($self->{$stat_to_get});
    return(undef);

}

sub get_stat_types(){
    my $self=shift;
    return(@{$self->{stat_types}});
}

sub refresh_stats(){
    my $self=shift;

    open(STATS, $self->{STAT_FILE});
    $self->{STAT_LINE}=<STATS>;
    chomp($self->{STAT_LINE});
    close(STATS);
    my @tmparray=split(/ /,$self->{STAT_LINE});

    foreach my $stat (@{$self->{stat_types}}){
        $self->{oldstats}{$stat}   = $self->{stats}{$stat};
    }

    $self->{stats}{user}   =$tmparray[2];
    $self->{stats}{nice}   =$tmparray[3];
    $self->{stats}{system} =$tmparray[4];
    $self->{stats}{idle}   =$tmparray[5];
    $self->{stats}{iowait} =$tmparray[6];
    $self->{stats}{irq}    =$tmparray[7];
    $self->{stats}{softirq}=$tmparray[8];

    #  Need special handling for total.
    $self->{stats}{total}=0;
    for(my $i=2;$i<9;$i++){
        $self->{stats}{total}+=$tmparray[$i];
    }

    #  Set the new internal value to be that of the delta between new and old.
    foreach my $stat (@{$self->{stat_types}}){
        $self->{$stat}   = $self->{stats}{$stat}-$self->{oldstats}{$stat};
    }

}


1;
