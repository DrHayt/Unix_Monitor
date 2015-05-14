use strict;
use warnings;
package SGMonitor::Helpers::LWP_URL;
use Data::Dumper;
use LWP::UserAgent;
use LWP::UserAgent::DNS::Hosts;
use Time::HiRes qw(gettimeofday);

sub new(){
    my ($class,$args)=@_;
    my $self = {};

    $self->{DEBUG}      = $args->{DEBUG}        || 0;
    $self->{TIMEOUT}    = $args->{URL_TIMEOUT}  || 5;

    $self->{UA}= LWP::UserAgent->new();
    $self->{UA}->timeout($self->{TIMEOUT});

    return(bless($self,$class));
}


sub get_override($$$){
        my $url=shift;
        my $name=shift;
        my $address=shift;

        LWP::UserAgent::DNS::Hosts->register_host( $name => $address );
        LWP::UserAgent::DNS::Hosts->enable_override;

        my ($code,$elapsed,$content) = $self->get( $url );

        LWP::UserAgent::DNS::Hosts->disable_override();
        LWP::UserAgent::DNS::Hosts->clear_hosts();

        return($code,$elapsed,$content);

}

sub post_override($$$$){
        my $url=shift;
        my $body=shift;
        my $name=shift;
        my $address=shift;

        LWP::UserAgent::DNS::Hosts->register_host( $name => $address );
        LWP::UserAgent::DNS::Hosts->enable_override;

        my ($code,$elapsed,$content) = $self->post( $url );

        LWP::UserAgent::DNS::Hosts->disable_override();
        LWP::UserAgent::DNS::Hosts->clear_hosts();

        return($code,$elapsed,$content);

}

sub get($){
        my $url=shift;

        my $t0=Time::HiRes::gettimeofday();
        my $response = $self->{UA}->get( $url );
        my $t1=Time::HiRes::gettimeofday();

        return($response->code,($t1-$t0),$response->content);

}

sub post($$){
        my $url=shift;
        my $body=shift;

        my $t0=Time::HiRes::gettimeofday();
        my $response = $self->{UA}->post( $url, $body );
        my $t1=Time::HiRes::gettimeofday();

        return($response->code,($t1-$t0),$response->content);

}


sub trace_log($$$$){
            my $self=shift;
            my $id=shift;
            my $method = shift;
            my $caller = shift;
            my $logmsg = shift;
            if ($self->{DEBUG} ge 10 ){
                print($id . " -- " . caller() ."::".$method." called by \n");
            }
            if ($self->{DEBUG} ge 5 ){
                print($id . " -- \t" .$caller."\n");
                }
            if ($self->{DEBUG}){
                print($id . " -- \t\t".$logmsg."\n");
            }
}


1;
