use strict;
use warnings;
package SGMonitor::ContentService_Put;
use SGMonitor::Helpers::ServiceBus;
use Data::Dumper;
use Sys::Hostname;
use FileHandle;
use IPC::Open2;
use MIME::Base64;

sub new(){
    my ($class,$args)=@_;
    my $self = {};

    $self->{SB}=SGMonitor::Helpers::ServiceBus->new( $args );
    $self->{DEBUG} = $args->{DEBUG} || 0;

    $self->{ORDERNUMBER} = $args->{ORDERNUMBER} || undef;
    $self->{FILE_TO_READ} = $args->{FILE_TO_READ} || undef;

    $self->{SERVICE_NAME}="ContentService.Put";
    $self->{BASE_STRING}="ServiceBus.monitor." . uc($self->{SERVICE_NAME});

    return(bless($self,$class));
}

sub run(){
    my $self=shift;
    #my $start=1#;
    #my $range=30000000;
    #my $ordernumber=int(rand($self->{RANGE}))+$self->{START};


    if (!defined($self->{ORDERNUMBER})){	
        return($self->{BASE_STRING},0,"INVALID_PARAMETERS","Order number is a required argument and was not passed");
    }
    if (!defined($self->{FILE_TO_READ})){	
        return($self->{BASE_STRING},0,"INVALID_PARAMETERS","The file to read is a required parameter");
    }

	if (! -f $self->{FILE_TO_READ} ){
        return($self->{BASE_STRING},0,"INVALID_PARAMETERS","the file you provided" . $self->{FILE_TO_READ} ." does not exist");
	}
	# exit(1);

	open(INPUTFILE, $self->{FILE_TO_READ}) || die ("Unable to open that file");
	my $buffer; # the target buffer
	my $filebytes; # the permanent buffer

	while (my $bytes_read=read(INPUTFILE,$buffer,1024)){
		$filebytes.=$buffer;
	}

	my $encoded_bytes=MIME::Base64::encode($filebytes);

    my %params=( 
	"Ordernumber" => $self->{ORDERNUMBER},
	"contractorid" => 0,
	"releasedate" => "2015-09-03T12:34:36.4830792-04:00",
	"filename" => "MANUAL.PDF",
	"imagewidth" => 0,
	"imageheight" => 0,
	"imagetype" => 2,
	"deptcode" => "02",
	"descprefix" => "Document",
	"desctext" => "Wint Season 2015",
	"category" => "Other",
	"filecontents" => $encoded_bytes,
	"sourceSystem" => "File Importer"
	);

    my ($elapsed,$status,$extra)=$self->{SB}->call_object($self->{SERVICE_NAME},\%params);

    return($self->{BASE_STRING},$elapsed,$status,$extra);

}


1;
