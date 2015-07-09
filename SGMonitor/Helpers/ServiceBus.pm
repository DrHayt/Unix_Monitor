use strict;
use warnings;
package SGMonitor::Helpers::ServiceBus;
use Data::Dumper;
use LWP::UserAgent;
use Time::HiRes qw(gettimeofday);
use JSON;

sub new(){
    my ($class,$args)=@_;
    my $self = {};

    $self->{DEBUG} = $args->{DEBUG} || 0;
    $self->{URL}=$args->{url} || 'http://servicebus/Execute.svc/Execute';
    $self->{TIMEOUT}=$args->{SB_TIMEOUT} || 50;

    $self->{UA}= LWP::UserAgent->new();
    $self->{UA}->timeout($self->{TIMEOUT});

    $self->{ENCODER}=JSON->new->allow_nonref;
    $self->{ENCODER}->allow_blessed;

    return(bless($self,$class));
}


sub call_object($\%){
        my $self=shift;
        my $method=shift;
        my $params_obj=shift;

        my $id=rand(time());


        my $encoded_params=$self->{ENCODER}->encode($params_obj);

        $self->trace_log($id,
                        'call_object',
                        scalar(caller),
                        "ARGS:  method:\"$method\", params_obj: ".$self->{ENCODER}->encode($params_obj)
                        );

        my ($elapsed,$status,$extra)=$self->call($method,$encoded_params,$id);

        return($elapsed,$status,$extra);

}

sub call($$){
        my $self=shift;
	my $method=shift;
	my $encoded_params=shift;
	my $id=shift || rand(time());

        my $content=qq({
          "jsonrpc" : "2.0",
	  "method" : "$method",
	  "id" : "$id",
	  "params" : $encoded_params
	});


        my $t0;
        my $t1;

	$t0=gettimeofday();

        $self->trace_log($id,
                        'call_object',
                        scalar(caller),
                        "ARGS:  method:\"$method\", encode_params: ".$encoded_params);


        my $response;

        eval {
                $response = $self->{UA}->post( $self->{URL}, Content => $content );
                $t1=gettimeofday();
        } or do {
                $t1=gettimeofday();
                return(($t1-$t0),"FAILED_POST",$@);
        };

        my $elapsed=($t1-$t0);

        if ( ($response->code eq 302 ) || ($response->code eq 301 ) ) {
            $self->trace_log($id,
                            'call_object',
                            scalar(caller),
                            "Redirect: ".$response->code);
            return($elapsed,"REDIRECT","Unexpected Redirect response: ".$response->code);
        }

        if ( ! ($response->code eq 200 ))  {
            $self->trace_log($id,
                            'call_object',
                            scalar(caller),
                            "Bad Response: ".$response->code." ".$response->content);
            return($elapsed,"INVALID_RESPONSE",
                    "HTTP Code: " . 
                    $response->code() . 
                    " Decoded Content: " . 
                    $response->decoded_content());
        }

	my $response_content  = $response->decoded_content();


        $response_content =~ s/^(?:\357\273\277|\377\376\0\0|\0\0\376\377|\376\377|\377\376)//g;

        my $native_object;

        eval { 
            $native_object=$self->{ENCODER}->decode($response_content);
            } or do {
            $self->trace_log($id,
                            'call',
                            scalar(caller),
                            "Decode Failed: ".$response->content);
            return($elapsed,"FAILED_DECODE",$@."\n\n".$response_content);
        };

        if(exists($native_object->{error})){
            $self->trace_log($id,
                            'call',
                            scalar(caller),
                            "Call Failed: ". $self->{ENCODER}->encode($native_object->{error})
                            );
            return($elapsed,"CALL_ERROR",$native_object->{error});
        }
        $self->trace_log($id,
                        'call',
                        scalar(caller),
                        "Success: ". $self->{ENCODER}->encode($native_object->{result})
                        );
        return($elapsed,"SUCCESS",$native_object->{result});
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
