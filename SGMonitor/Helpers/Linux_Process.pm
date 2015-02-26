use strict;
use warnings;
package SGMonitor::Helpers::Linux_Process;
#use Fcntl qw(:flock);    # file locking
use POSIX ":sys_wait_h"; # forking niceties
use Data::Dumper;

sub new(){
    my ($class,$args)=@_;
    my $self = {};

    $self->{cmdline} = $args->{cmdline};

    $self->{CHILD_PID} = fork();

    if ($self->{CHILD_PID} == 0) {
        exec($self->{cmdline}) || die("Unable to exec");
    }

    $self->{STAT_FILE}='/proc/'.$self->{CHILD_PID}.'/stat';
    open(STAT,$self->{STAT_FILE});
        $self->{STAT_LINE}=<STAT>;
        chomp($self->{STAT_LINE});
    close(STAT);

    my @tmparray=split(/ /,$self->{STAT_LINE});


    return(bless($self,$class));
    }

1;
