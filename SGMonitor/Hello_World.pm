use strict;
use warnings;
package SGMonitor::Hello_World;

sub new(){
    my $class=shift;
    my $self = {};
    $self->{DEBUG} = $args->{DEBUG} || 0;

    return(bless($self,$class));
}

sub run(){
    my $self=shift;
    printf("Hello World\n");
    return(undef,undef,undef,undef);
}


1;
