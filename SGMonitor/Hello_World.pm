use strict;
use warnings;
package SGMonitor::Hello_World;

sub new(){
    my $class=shift;
    my $self = {};

    return(bless($self,$class));
}

sub run(){
    my $self=shift;
    printf("Hello World\n");
}


1;
