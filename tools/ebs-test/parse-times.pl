#!/usr/bin/perl
	
use strict;
use List::Util qw(sum);
use Time::Local;
use Data::Dumper;
use Getopt::Long;




############################################################################################
# INIT

	my $debug = 0;
	my $usage = q{
		usage: $0 <IO-count> <log1> [<log2> <log3> ...]
		required:
              IO-count = total # of io completed per execution of random_io program, in k (thousands)
		    log1 = first log file 
		optional:
              log2, log3, etc. = additional log files
	};
	#die $usage if ($#ARGV eq -1 or !$result);
	die $usage if ($#ARGV < 1);
	


############################################################################################
# MAIN
	
#my $iocnt=$ARGV[0]*1000;
my $iocnt=$ARGV[0];

Debug ("IOcnt=$iocnt");


shift;
foreach my $logf (@ARGV) {

	print "LOGFILE = $logf:\n";

	my $iops=0;
	my $time=0;
	my $min=0;
	my $sec=0;
	my @stats;
	my $line=0;
	my $low=987654;
	my $high=0;
	my $stat=0;
	my $fh;
	my $stdev=0;
	my $sdsum=0;
	my $dev=0;
	my $delta=0;
	my $mean=0;
	my $elems=0;
	my $exceptions=0;


	if ($logf =~ /\.gz$/) {
		open($fh, "gunzip -c $logf|") or die $!;
	}
	else {
		open($fh, '<', $logf) or die $!;
	}

	while(my $line = <$fh>) {
	
		chomp $line;
		if ($line =~ /real/) {
			(undef,$time)= split /\s/, $line;
			($min,$sec) = split /[ms]/, $time;
			$sec = (60 * $min) + $sec;
			Debug ("Pushing stat: [$sec] seconds, time=$time");
			#Debug ("Pushing stat: [$sec] seconds, time=$time");
			push (@stats, $sec);	

		}


	}


	#$std_dev = Math::NumberCruncher::StandardDeviation(@stats);
	#$mean = Math::NumberCruncher::Mean(@stats);


	$elems = scalar(@stats);
	$mean= sum(@stats)/$elems;
	
	foreach $stat (@stats) { 
		$delta = abs ($stat - $mean);
		$sdsum += ($delta * $delta);
		if ($stat > $high) {
			$high = $stat;
		}
		if ($stat < $low) {
			$low = $stat;
		}
	}
	$stdev = sqrt ($sdsum / $elems);
	
	foreach $stat (@stats) { 
		$delta = abs ($stat - $mean);
		#if ($delta > $stdev*2) {
		if ($delta > .3*$mean) {
			Debug ("Exception: |$stat - $mean| > $stdev * 2");
			$exceptions+=1;
		}
	}

	$iops = $iocnt/$mean;
	printf ("   IOps=%5.0f. TIMES:  Mean=%.1f. Cnt=$elems. StdDev=%.1f. Lo=$low, Hi=$high, Exceptions=$exceptions\n\n", $iops, $mean, $stdev);
	#print "MEAN=$mean.   COUNT=$elems.   StdDeviation=$stdev.\n";

	@stats = ();
	close($fh);

}




sub Debug {
	if ($debug > 0) {
		print "DEBUG: [@_]\n";
	}

}
		
