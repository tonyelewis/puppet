#!/usr/bin/env perl

package Butler::SourceFileList;

use warnings;
use strict;

# Core
use Carp                       qw/ confess        /;
use English                    qw/ -no_match_vars /;
use File::Find;

# Non-core
use Moose;
use MooseX::Params::Validate;
use MooseX::Types::Moose       qw/ CodeRef        /;
use MooseX::Types::Path::Class qw/ Dir File       /;
use Params::Util               qw/ _ARRAY _STRING /;
use Path::Class                qw/ dir file       /;

# Butler
use Butler::SourceFileList::SourceDir;
use Butler::SourceFileList::SourceFile;

sub _get_list_of_files_from_dir_and_regexp {
	my $self = shift;
	my ( $search_dir, $is_acceptable_file_sub ) = pos_validated_list(
		\@ARG,
		{ isa => Dir },
		{ isa => 'CodeRef' },
	);

	# TODO: Update Path::Class::Dir to 0.26 and use this traverse code...
	my @list_of_files = $search_dir->traverse(
		sub {
			my ($child, $cont) = @ARG;
			my $local_name = dir($child)->relative($search_dir)->stringify();
# 			warn $local_name;
			return (
				(
					(
						! $child->is_dir
						&&
						$is_acceptable_file_sub->( $local_name )
					)
					? ($local_name)
					: ()
				),
				$cont->()
			);
		}
	);

	return \@list_of_files;
}

around BUILDARGS => sub {
	my $orig  = shift;
	my $class = shift;

	# If called with a directory and regular expression, then generate a list of files
	# and recursively pass that list to the ctor
	if ( scalar(@ARG) == 2 && is_Dir($ARG[0]) && is_CodeRef($ARG[1]) ) {
		return Butler::SourceFileList->new(
			Butler::SourceFileList->_get_list_of_files_from_dir_and_regexp(@ARG)
		);
	}
	# If called with a list of files, then recursively call the ctor with
	# source_files constructed from that list
	elsif ( scalar(@ARG) == 1 && _ARRAY($ARG[0]) ) {
		return $class->$orig(
			source_files => Butler::SourceFileList::SourceDir->new(dir('.'), $ARG[0])
		);
	}
	# Otherwise use the standard Moose constructor
	else {
		return $class->$orig(@ARG);
	}
};

has 'source_files' => (
	is  => 'ro',
	isa => 'Butler::SourceFileList::SourceDir',
);

sub output_as_cmake_spec {
	my $self = shift;
	my ( $file_list ) = pos_validated_list( \@ARG );

	my $cmake_spec_result = $self->source_files()->output_cmake_details( dir() );
	my ( $cmake_norm_result_string, $cmake_norm_result_name,
	     $cmake_test_result_string, $cmake_test_result_name ) = @$cmake_spec_result;
	my $result_string = $cmake_norm_result_string . $cmake_test_result_string;
	$result_string =~ s/^\s+//g;
	return $result_string;
}

1;
