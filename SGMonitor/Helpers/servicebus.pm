use strict;
use warnings;
package SGMonitor::Helpers::servicebus;
use Data::Dumper;
use LWP::UserAgent;
use Time::HiRes qw(gettimeofday);
use JSON;

sub new(){
    my ($class,$args)=@_;
    my $self = {};

    $self->{URL}=$args->{url} || 'http://servicebus/Execute.svc/Execute';
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

        my $encoded_params=$self->{ENCODER}->encode($params_obj);

        #print(Dumper($params_obj));
        #print(Dumper($encoded_params));
        #exit(1);

        my ($elapsed,$status,$extra)=$self->call($method,$encoded_params);

        return($elapsed,$status,$extra);

}

sub call($$){
        my $self=shift;
	my $method=shift;
	my $encoded_params=shift;

	my $id=rand(time());


#my $content=qq({
        #"jsonrpc" : "2.0",
        #"method" : "ContentService.List",
        #"id" : "$id",
        #"params" : {
                    #"orderId" : "$ORDERNUMBER"
                    #},
#});


        my $content=qq({
          "jsonrpc" : "2.0",
	  "method" : "$method",
	  "id" : "$id",
	  "params" : $encoded_params,
	});


        my $t0;
        my $t1;

	$t0=gettimeofday();

        #print($content."\n");


        my $response;

        eval {
                $response = $self->{UA}->post( $self->{URL}, Content => $content );
                $t1=gettimeofday();
        } or do {
                $t1=gettimeofday();
                return(($t1-$t0),"FAILED_POST",$@);
        };

        my $elapsed=($t1-$t0);

        if ( ! $response->is_success) {
            return($elapsed,"INVALID_RESPONSE",$response->decoded_content());
        }

	my $response_content  = $response->decoded_content();


        $response_content =~ s/^(?:\357\273\277|\377\376\0\0|\0\0\376\377|\376\377|\377\376)//g;

        my $native_object;

        eval { 
            $native_object=$self->{ENCODER}->decode($response_content);
            } or do {
            return($elapsed,"FAILED_DECODE",$@."\n\n".$response_content);
        };

        if(exists($native_object->{error})){
            return($elapsed,"CALL_ERROR",$native_object->{error});
        }
        return($elapsed,"SUCCESS",$native_object->{result});
}

1;
