#!/usr/bin/env perl

package Butler::SourceFileList::SourceFile;

use warnings;
use strict;

# Core
use English                    qw/ -no_match_vars /;

# Non-core
use Moose;
use MooseX::Params::Validate;
use MooseX::Types::Path::Class qw/ Dir File       /;

has 'file' => (
	is  => 'ro',
	isa => File,
);

sub output_cmake_details {
	my $self = shift;
	my ( $context_dir ) = pos_validated_list(
		\@ARG,
		{ isa => Dir },
	);

	my $filename = $context_dir->file( $self->file() )->stringify();
	my $file_is_a_test_file   = ($filename =~ /Test\.cpp$/ || $filename =~ /_test\.cpp$/ || $filename =~ /_fixture.[ch](pp)?$/ );
	my $file_is_a_source_file = ($filename =~ /\.cpp$/) && !$file_is_a_test_file;

	if ( ! $file_is_a_test_file ) {
		if ( $filename =~ /test/ ) {
			warn $filename;
		}
	}

	return [
		undef,
		($file_is_a_source_file ? $filename : undef),
		undef,
		($file_is_a_test_file   ? $filename : undef),
	];
}

1;
