use strict;
use warnings;
package SGMonitor::Helpers::CLW;
use Data::Dumper;
use LWP::UserAgent;
use Time::HiRes qw(gettimeofday);
use JSON;

sub new(){
    my ($class,$args)=@_;
    my $self = {};

    $self->{DEBUG} = $args->{DEBUG} || 0;
    $self->{URL}=$args->{url} || 'https://clw.safeguardproperties.com/cgi-bin/websvc.cgi';
    # https://clw.safeguardproperties.com/cgi-bin/websvc.cgi?app=WD180&PropertyNumber=7233738
    $self->{TIMEOUT}=$args->{timeout} || 10;

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


        my $id=int(rand(time()));


        my @params;
        my $encoded_params;


        if($self->{DEBUG}){
            print($self->{ENCODER}->encode($params_obj)."\n");
        }

        foreach my $key (keys %{$params_obj}){
            my $string=$key."=".$params_obj->{$key};
            push(@params,$string);
        }

        $encoded_params=join('&',@params);
        $encoded_params='app='.$method.'&'.$encoded_params;

        if ($self->{DEBUG}){
            $self->trace_log($id,
                            'call_object',
                            scalar(caller),
                            "ARGS:  method:\"$method\", params_obj: ".$encoded_params
                            );
        }

        my ($elapsed,$status,$extra)=$self->call($method,$encoded_params,$id);

        return($elapsed,$status,$extra);

}

sub call($$$){
        my $self=shift;
	my $service=shift;
	my $encoded_params=shift;
        my $id=shift;

        my $t0;
        my $t1;

	$t0=gettimeofday();

        if ($self->{DEBUG}){
            $self->trace_log($id,
                            'call',
                            scalar(caller),
                            "ARGS:  method:\"$service\", encoded_params: ".$encoded_params);
        }


        my $response;

        eval {
                $response = $self->{UA}->get( $self->{URL}."?".$encoded_params);
                $t1=gettimeofday();
        } or do {
                $t1=gettimeofday();
                return(($t1-$t0),"FAILED_POST",$@);
        };

        my $elapsed=($t1-$t0);

        if ( ($response->code eq 302 ) || ($response->code eq 301 ) ) {
            $self->trace_log($id,
                            'call',
                            scalar(caller),
                            "Redirect: ".$response->code);
            return($elapsed,"REDIRECT","Unexpected Redirect response: ".$response->code);
        }

        if ( ! ($response->code eq 200 ))  {
            $self->trace_log($id,
                            'call',
                            scalar(caller),
                            "Bad Response: ".$response->code );
            return($elapsed,"INVALID_RESPONSE",
                    "HTTP Code: " . 
                    $response->code() . 
                    " Decoded Content: " . 
                    $response->decoded_content());
        }

	my $response_content  = $response->decoded_content();


        $response_content =~ s/^(?:\357\273\277|\377\376\0\0|\0\0\376\377|\376\377|\377\376)//g;

        my $native_object;

        # <error>Yes</error>
        if ($response_content =~ /<error>Yes<\/error>/) {
            $self->trace_log($id,
                            'call',
                            scalar(caller),
                            "Call Error: ".$response_content);
            return($elapsed,"CALL_ERROR",$@."\n\n".$response_content);
        } 
            $self->trace_log($id,
                            'call',
                            scalar(caller),
                            "Success: ".$response_content);
        return($elapsed,"SUCCESS",$response_content);
}

sub trace_log($$$$){
            my $self=shift;
            my $id=shift;
            my $method = shift;
            my $caller = shift;
            my $logmsg = shift;
            #print("$id: Method is \"$method\", caller is \"$caller\", logmsg is \"$logmsg\"\n");
            print($id . " -- " . caller() ."::".$method." called by \n");
            print($id . " -- \t" .$caller."\n");
            print($id . " -- \t\t".$logmsg."\n");
}


1;
