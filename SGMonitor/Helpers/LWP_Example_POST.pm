#!/usr/bin/perl -w
use strict;
use warnings;

use lib $ENV{'HOME'}.'/perl5/';
use lib $ENV{'HOME'}.'/skel/perl5/';

$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;

use LWP::UserAgent;
use LWP::UserAgent::DNS::Hosts;
use Time::HiRes;
use Net::Statsd;
use File::Basename;

use Data::Dumper;

my $interval=4;


my $configdir=$ARGV[0];
my $urlfile=$configdir.'/url.txt';
my $hostsfile=$configdir.'/hosts.txt';
my $postfile=$configdir.'/post.txt';
my $freqfile=$configdir.'/frequency.txt';

my $log_pfx=basename($configdir);


#  Does our config dir exist?
if ( ! -d $configdir ){
    &usage();
}

#  Does our url file exist
if ( ! -f $urlfile ){
    &usage();
}

#  Does our hosts file exist
if ( ! -f $hostsfile ){
    &usage();
}

#  Does our hosts file exist
if ( ! -f $postfile ){
    &usage();
}


#  Does our hosts file exist
if ( -f $freqfile ){
    open(FREQ,$freqfile);
    my $freq=<FREQ>;
    chomp($freq);
    $interval=$freq;
}



open(URLFILE,$urlfile) || die("Unable to open provided file $urlfile");
	my $url=<URLFILE>;
	chomp($url);
close(URLFILE);

open(IPFILE,$hostsfile) || die("Unable to open IP file $hostsfile");
	my @lines=<IPFILE>;
	chomp(@lines);
close(IPFILE);

open(POSTFILE,$postfile) || die ("Unable to open post file $postfile");
    my @otherlines=<POSTFILE>;
    chomp(@otherlines);
close(POSTFILE);


my $postbody;
foreach my $line (@otherlines){
    my ($key,$value)=split(/=/,$line);
    $postbody->{$key}=$value;
}

#print(Dumper($postbody));

#exit(1);


#print(Dumper(@lines));


my @hosts;



while (1) {

	my $total_elapsed=0;

	for(my $i=0;$i<=$#lines;$i++){
		my ($address,$name)=split(/ /,$lines[$i]);
		#printf("Trying to get %s from %s\n",$url,$address);
		my ($code,$elapsed,$body)=&post_override($url,$name,$address,$postbody);
		$total_elapsed += $elapsed;
		#printf("Received code %s, in %f seconds from %s\n",$code,$elapsed,$address);
                if($code == 200){
                    &send_stats($log_pfx,$code,$elapsed,$address);
                }

	}

	if ($total_elapsed < $interval ){
		sleep($interval-$total_elapsed);
	}
}


sub post_override($$$){
	my $url=shift;
	my $name=shift;
	my $address=shift;
	my $body=shift;

	LWP::UserAgent::DNS::Hosts->register_host( $name => $address );
	LWP::UserAgent::DNS::Hosts->enable_override;

	my $UA = LWP::UserAgent->new();

	my $t0=Time::HiRes::gettimeofday();
        my $response = $UA->post( $url, $body );
        #print(Dumper($response));
        my $t1=Time::HiRes::gettimeofday();

	return($response->code,($t1-$t0),$response->content);

}


sub send_stats($$$$){
        my $file=shift;
        my $code=shift;
        my $elapsed=shift;
        my $host=shift;

	$host =~ s/\./_/g;
	$file =~ s/\./_/g;



	my $send_base="system.webmonitor_post.".$file.".".$host;
	my $success_name=$send_base.'.success';
	my $fail_name=$send_base.'.fail';
	my $total_name=$send_base.'.total';

	my $elapsed_name=$send_base.'.ElapsedMiliseconds';

	#print("Success is $success_name\n");
	#print("Fail is $fail_name\n");
	#print("total is $total_name\n");
	#print("elapsed is $elapsed_name\n");


	Net::Statsd::increment($total_name);

	if($code eq "200"){
		Net::Statsd::increment($success_name);
	} else {
		my $fail_name=$send_base.'.failed';
		Net::Statsd::increment($fail_name);
	}

        #print("The elapsed I am gonna send is $elapsed\n");
	Net::Statsd::timing($elapsed_name,($elapsed*1000));

}




sub usage(){
	die("This program requires two arguments, the first is a file containing the URL you wish to hit.  The second is a file containing the IP addresses of the servers which will serve that content");
        print(STDERR "This program expects a single argument which is a directory\n");
        print(STDERR "The directory name is what will be used to send data to graphite.\n");
        print(STDERR "The directory should contain 2 files:\n");
        print(STDERR "\turl.txt\n");
        print(STDERR "\thosts.txt\n");
        print(STDERR "\tpost.txt\n");
        print(STDERR "\nThe content of url.txt should be the URL to hit\n");
        print(STDERR "The content of hosts.txt should be host files entries for that host, identical to a normal hosts file.");
        print(STDERR "The content of post.txt should be the exact post body to post.");
        print(STDERR "There should be NO commented entries.");
        die "Try Again";
}

