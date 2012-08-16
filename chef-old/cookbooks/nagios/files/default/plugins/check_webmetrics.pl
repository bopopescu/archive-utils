#!/usr/bin/perl
# Nagios Plug-in for the Webmetrics API
# Created by Jason Paddock | Professional Services Engineer | Webmetrics, A Neustar Service
# 06/07/10

use warnings;
use strict;
use LWP::Simple;
use LWP::UserAgent;
use HTTP::Request;
use HTTP::Response;
use XML::Simple;
use Getopt::Long;
use Digest::SHA1 qw(sha1_base64);
use DateTime;
use DateTime::Format::Strptime;

my $api_key;
my $username;
my $serviceID;

#Set Command Line Options
GetOptions("api_key=s" => \$api_key,
		"username=s" => \$username,
		"serviceID=s" => \$serviceID);

my $timestamp = time;    
my $signature = urlEncode(sha1_base64($username.$api_key.$timestamp));

#Pull API Data
API();

#----------------------------------------------------------------

sub urlEncode { 
	my ($str) = @_;
    $str =~ s/([^=%&a-zA-Z0-9_\-.])/uc sprintf("%%%02x",ord($1))/eg;
    return $str;
}

#----------------------------------------------------------------------

sub API {
	my $url = "https://api.webmetrics.com/v2/?method=realtime.getdata&sig=$signature&username=$username&usebaselines=0&serviceid=$serviceID";
	my $browser = LWP::UserAgent->new();
	my $request = HTTP::Request->new(GET => $url);
	my $response = $browser->request($request)->as_string;
	$response =~ s/^.*?<\?xml/<\?xml/gsm;
	my $xml = new XML::Simple;
	my $xml_results = $xml->XMLin($response);
	if($xml_results->{error})
	{
		print "$xml_results->{error}->{msg}\n";
		exit 3;
	}
	elsif($xml_results->{service}->{sample}->{status} eq "OK")
	{
		print "$xml_results->{service}->{name} Load Time = $xml_results->{service}->{sample}->{transaction}->{loadtime}, Sample Taken At: $xml_results->{service}->{sample}->{time} $xml_results->{timezone} | load_time=$xml_results->{service}->{sample}->{transaction}->{loadtime}\n";
	}
	elsif($xml_results->{service}->{sample}->{status} eq "STRIKE")
	{
		print "Warning Sample Taken At: $xml_results->{service}->{sample}->{time} $xml_results->{timezone}\n";
		exit 1;
	}
	elsif($xml_results->{service}->{sample}->{status} eq "ERROR")
	{
		print "Error Sample Taken At: $xml_results->{service}->{sample}->{time} $xml_results->{timezone}\n";
		exit 2;
	}
	else
	{
		print "Unknown Sample Status\n";
		exit 3;
	}
}
