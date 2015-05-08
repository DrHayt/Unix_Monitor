use strict;
use warnings;
package SGMonitor::Helpers::Linux_Memory;
use Data::Dumper;

sub new(){
    my ($class,$args)=@_;
    my $self = {};

    $self->{STAT_FILE}="/proc/meminfo";

    $self->{DEBUG} = $args->{DEBUG} || 0;

    open(STATS, $self->{STAT_FILE});
        while(my $line=<STATS>){
            chomp($line);
            $line =~ s/\(/_/g;
            $line =~ s/\)/_/g;
            $line =~ s/://g;
            my @tmparray=split(/\s+/,$line);
            $self->{stats}{$tmparray[0]}=$tmparray[1];
            #print(Dumper(@tmparray));
        }
    close(STATS);

    return(bless($self,$class));
}


sub get_stat_names(){
    my $self=shift;
    return(keys(%{$self->{stats}}));
}


sub get_stat($){
    my $self=shift;
    my $stat_to_get=shift;
    return($self->{$stat_to_get}) if defined($self->{$stat_to_get});
    return(undef);

}

sub refresh_stats(){
    my $self=shift;

    open(STATS, $self->{STAT_FILE});
        while(my $line=<STATS>){
            chomp($line);
            $line =~ s/\(/_/g;
            $line =~ s/\)/_/g;
            $line =~ s/://g;
            my @tmparray=split(/\s+/,$line);
            $self->{$tmparray[0]}=$tmparray[1];
            #print(Dumper(@tmparray));
        }
    close(STATS);

}
1;
