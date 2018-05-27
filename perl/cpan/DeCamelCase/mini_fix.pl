#!/usr/bin/env perl

use strict;
use warnings;

use Carp          qw/ confess        /;
use Data::Dumper;
use English       qw/ -no_match_vars /;
use Path::Class   qw/ dir file       /;
use Readonly;

Readonly my $SOURCE_DIR => dir('', 'home', 'lewis', 'svn', 'cpan', 'trunk', 'DeCamelCase');
Readonly my $SOURCE_FILE => $SOURCE_DIR->file('pudding_notes.txt');
my @file_lines = $SOURCE_FILE->slurp();
while (chomp(@file_lines)) {}

my %dest_of_source;
foreach my $file_line (@file_lines) {
	if ($file_line !~ /\S/) {
		next;
	}
	my ($source, $break, $dest) = split(/\s+/, $file_line);
	if ($break ne '->') {
		warn 'Skipping line "'.$file_line.'" ';
		next;
	}
# 	warn $break;
	$dest_of_source{$source} = $dest;
}
# die;

foreach my $source (sort(keys(%dest_of_source))) {
	my $dest = $dest_of_source{$source};
	print "grep -RP '\\b$source\\b' -l | xargs sed -i 's/\\b$source\\b/$dest/g'\n";
}

# confess Dumper(\%dest_of_source)."";