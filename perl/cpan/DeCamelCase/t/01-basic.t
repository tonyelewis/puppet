#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 7;

use English qw/ -no_match_vars /;
use FindBin;
use Path::Class                qw/ dir file       /;

BEGIN {
    use_ok( 'DeCamelCase' ) || print "Bail out!\n";
}

my $example_root_dir      = dir($FindBin::Bin)->subdir('data')->absolute();
my $files_to_exclude_file = $example_root_dir->file('files_to_exclude.txt');


# my $ids_to_exclude_file   = $example_root_dir->file('ids_to_exclude.txt');
# my $example_dir           = $example_root_dir;

my $ids_to_exclude_file   = file('cudatest_exclude_ids.txt');
my $example_dir           = dir('', 'home', 'lewis', 'svn', 'cudatest', 'trunk', 'source')->absolute();

is_deeply(
	DeCamelCase->get_components_of_file_or_dir( dir('t', 'data', 'Exception')->file('InvalidArgumentException.cpp') ),
	[ 't', 'data', 'Exception', 'InvalidArgumentException.cpp' ],
);

is_deeply(
	DeCamelCase->get_components_of_file_or_dir( dir('', 't', 'data', 'Exception')->file('InvalidArgumentException.cpp') ),
	[ 't', 'data', 'Exception', 'InvalidArgumentException.cpp' ],
);

my $source_files          = DeCamelCase->get_source_files_of_dir($example_dir);
$source_files             = DeCamelCase->remove_files_to_exclude_from_file($source_files, $files_to_exclude_file );

my $ccids_from_filenames  = DeCamelCase->get_camel_case_ids_from_filenames($source_files);
my %ccids_from_filenames  = map { ( $ARG, 1 ) } @$ccids_from_filenames;
is( $ccids_from_filenames{'ExceptionIsEquivalent'}, 1 );

my $ccids_from_contents   = DeCamelCase->get_camel_case_ids_from_contents_of_files($example_dir, $source_files);
$ccids_from_contents      = DeCamelCase->remove_ids_to_exclude_from_file($ccids_from_contents, $ids_to_exclude_file);
my %ccids_from_contents   = map { ( $ARG, 1 ) } @$ccids_from_contents;
is( $ccids_from_contents{'argExceptionToCompare'}, 1 );

# Two words that are only in ThirdPartyCode/gnuplot-iostream.h and that should hence
# have been excluded (through $files_to_exclude_file)
is( $ccids_from_contents{'Stahlke'},               undef );
is( $ccids_from_contents{'Software'},              undef );

# Two words that are in $ids_to_exclude_file and that should hence have been excluded
is( $ccids_from_contents{'Severity'},              undef );
is( $ccids_from_contents{'Caught'},                undef );

DeCamelCase->process_source_dir_into_another(
	$example_dir,
	dir('', 'home', 'lewis', 'svn', 'cudatest', 'trunk', 'source_new')->absolute(),
	$ccids_from_filenames,
	$ccids_from_contents
);

# use Data::Dumper;
# warn Dumper( [ $ccids_from_filenames, $ccids_from_contents ] );

# my $bar_delimited_string = join("|", @$ccids_from_contents);
# file("command.tcsh")->spew("#!/bin/tcsh\ngrep -hR '\"' $example_dir | grep -vP '^\\\/*#include' | grep -P '\\b($bar_delimited_string)\\b'\n");

