#!/usr/bin/env perl

use strict;
use warnings;

# Core
use Carp                       qw/ confess        /;
use English                    qw/ -no_match_vars /;
use FindBin;

# Non-core
use MooseX::Params::Validate;
use MooseX::Types::Path::Class qw/ Dir File       /;
use Path::Class                qw/ dir            /;

use lib "$FindBin::Bin/../lib";

# Butler
use Butler::SourceFileList;

if ( scalar( @ARGV ) != 1 ) {
	die "Usage: gen_cmake_list.pl cmake_root_dir\n";
}
my $dir_name = dir( $ARGV[ 0 ] );

process_cmake_lists( $dir_name );

sub process_cmake_lists {
	my ( $source_dir ) = pos_validated_list(
		\@ARG,
		{ isa => Dir, coerce => 1 },
	);

	my $source_file_list = Butler::SourceFileList->new(
		$source_dir,
		sub {
			my ( $filename ) = @ARG;

			return (
				$filename =~ /\.(cpp|h)$/
				# &&
				# $filename !~ /^(bioplib|cathutils|CMakeFiles|release|debug|profile|lx62_debug)/
			);
		}
	);
	my $new_spec_string = $source_file_list->output_as_cmake_spec();

	$source_dir->file('auto_generated_file_list.cmake')->spew(<<"EOF" );
##### DON'T EDIT THIS FILE - IT'S AUTO-GENERATED #####
$new_spec_string
##### DON'T EDIT THIS FILE - IT'S AUTO-GENERATED #####
EOF

}
