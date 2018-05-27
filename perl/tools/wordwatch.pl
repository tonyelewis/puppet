#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use English qw( -no_match_vars ) ;
use Readonly;
use Term::Report;
use IPC::Run3;

sub countWords($);

my ($filename) = @ARGV;

if (!defined($filename)) {
	die "Usage: $PROGRAM_NAME mainlatexfile\n";
}

Readonly my $startTime => time();
Readonly my $startWordCount => countWords($filename);

my $report = new Term::Report();
# $report->savePoint('screentop');
while (1) {
	sleep (1);
	Readonly my $timeElapsed => time() - $startTime;
	Readonly my $wordsAdded => countWords($filename) - $startWordCount;
	Readonly my $targetWords => int(5.0 * $timeElapsed / 18.0);
	$report->clear();
	$report->finePrint(1, 0, "Start words: $startWordCount");
	$report->finePrint(2, 0, "");
	$report->finePrint(3, 0, "Time elapsed: ".substr(gmtime($timeElapsed), 11, 8));
	$report->finePrint(4, 0, "Target words: $targetWords");
	$report->finePrint(5, 0, "Words added: $wordsAdded");
	$report->finePrint(6, 0, "Success: ".($targetWords > 0 ? 100.0*$wordsAdded/$targetWords : 'N/A'));
	$report->finePrint(7, 0, "");
}

sub countWords($) {
	my ($fileToCount) = @ARG;
	if (!-e $fileToCount) {
		die "No such file \"$fileToCount\"\n";
	}
	my $detexStdout;
	# 'detex X' is equivalent to 'detex -e array,eqnarray,equation,figure,mathmatica,picture,table,verbatim X'
	run3(['detex', $fileToCount], undef, \$detexStdout);
	my $wordCount = 0;
	while ($detexStdout =~ /\S+/g) {
		$wordCount++;
	}
	return $wordCount;
}