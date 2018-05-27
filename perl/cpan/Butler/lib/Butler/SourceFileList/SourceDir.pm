#!/usr/bin/env perl

package Butler::SourceFileList::SourceDir;

use warnings;
use strict;

# Core
use Carp                       qw/ confess        /;
use English                    qw/ -no_match_vars /;

# Non-core
use Moose;
use MooseX::Params::Validate;
use MooseX::Types::Path::Class qw/ Dir            /;
use Params::Util               qw/ _ARRAY         /;
use Path::Class                qw/ dir file       /;

# Butler
use Butler::SourceFileList::SourceFile;

=head2 _process_list_of_files

A private static member function to convert a raw list of filename strings
into a SourceDir object

=cut

sub _process_list_of_files {
	my $self = shift;
	my ( $file_list ) = pos_validated_list(
		\@ARG,
		{ isa => 'ArrayRef[Str]' },
	);

	# Take a sorted copy of the list
	my @sorted_file_list = sort(@$file_list);

	# Loop over the entries, grouping together entries into directories
	my @entries;
	foreach my $filename (@sorted_file_list) {
		my $file = file($filename);

		# If it is within a directory...
		my $next_dir = $file->dir();
		if ($next_dir ne dir('.')) {
			# Find the first-level sub-directory
			while ($next_dir->parent() ne dir('.')) {
# 				warn "\$next_dir is $next_dir";
				$next_dir = $next_dir->parent();
			}

			# If this directory hasn't already been added to the data structure, then do so
			if (scalar(@entries) == 0 || !_ARRAY($entries[-1]) || $entries[-1]->[0] ne $next_dir) {
				push @entries, [$next_dir, []];
			}
			# Then add the file to its directory entry
			push @{$entries[-1]->[1]}, $file->relative($next_dir)->stringify();
		}
		# Else, it is a file in this directory...
		else {
			push @entries, $file;
		}
	}

	# Convert any parts representing directories into SourceDir objects
	# and the others into SourceFile objects
	foreach my $entry (@entries) {
		if (_ARRAY($entry)) {
			$entry = Butler::SourceFileList::SourceDir->new(@$entry);
		}
		else {
			$entry = Butler::SourceFileList::SourceFile->new(file => $entry);
		}
	}

	return \@entries;
}

around BUILDARGS => sub {
	my $orig  = shift;
	my $class = shift;

	if ( scalar(@ARG) == 2 && is_Dir($ARG[0]) && _ARRAY($ARG[1]) ) {
# 		warn "constructing with ".$ARG[0];
		my $new_source_dir_entries = Butler::SourceFileList::SourceDir->_process_list_of_files($ARG[1]);
# 		warn "and : ".$new_source_dir_entries;
		return $class->$orig(
			this_dir    => $ARG[0],
			sub_entries => $new_source_dir_entries,
		);
	}
	else {
		return $class->$orig(@ARG);
	}
};

has 'this_dir' => (
	is  => 'ro',
	isa => Dir,
);

has 'sub_entries' => (
	is  => 'ro',
	isa => 'ArrayRef[Butler::SourceFileList::SourceDir|Butler::SourceFileList::SourceFile]',
);

=head2 output_as_cmake_spec

TODO: Should implement this with a visitor class to permit other formats

=cut

sub output_cmake_details {
	my $self = shift;
	my ( $context_dir ) = pos_validated_list(
		\@ARG,
		{ isa => Dir },
	);

	my $this_full_dir = $context_dir->subdir($self->this_dir());
	my $uc_dir_string = join( '_', map { $ARG ne '.' ? ( uc( $ARG ) ) : ( ) } ( $this_full_dir->dir_list() ) );
	my $norm_local_name = 'NORMSOURCES_'.$uc_dir_string;
	my $test_local_name = 'TESTSOURCES_'.$uc_dir_string;
	my $cmake_norm_spec_string = undef;
	my $cmake_test_spec_string = undef;

	my @local_norm_entries;
	my @local_test_entries;
	my $sub_entries = $self->sub_entries();
	foreach my $sub_entry (@$sub_entries) {
		my $cmake_spec_result = $sub_entry->output_cmake_details($this_full_dir);
		my ($cmake_norm_result_string, $cmake_norm_result_name,
		    $cmake_test_result_string, $cmake_test_result_name) = @$cmake_spec_result;
# 		if (!defined($cmake_norm_result_name)) {
# 			warn "\$cmake_norm_result_name not defined for ".$sub_entry->file();
# 		}
# 		if (!defined($cmake_test_result_string)) {
# 			warn "\$cmake_test_result_string not defined for ".$sub_entry->file();
# 		}
		if (defined($cmake_norm_result_string)) {
			$cmake_norm_spec_string .= $cmake_norm_result_string;
		}
		if (defined($cmake_test_result_string)) {
			$cmake_test_spec_string .= $cmake_test_result_string;
		}
		if (defined($cmake_norm_result_name)) {
			push @local_norm_entries, $cmake_norm_result_name;
		}
		if (defined($cmake_test_result_name)) {
			push @local_test_entries, $cmake_test_result_name;
		}
	}

	if ($this_full_dir ne dir()) {
		if (scalar(@local_norm_entries)) {
			$cmake_norm_spec_string .= "\n\n";
			$cmake_norm_spec_string .= "set(\n\t$norm_local_name\n\t\t".join("\n\t\t", @local_norm_entries)."\n)";
		}
		if (scalar(@local_test_entries)) {
			$cmake_test_spec_string .= "\n\n";
			$cmake_test_spec_string .= "set(\n\t$test_local_name\n\t\t".join("\n\t\t", @local_test_entries)."\n)";
		}
	}

	return [
		$cmake_norm_spec_string,
		(defined($cmake_norm_spec_string) ? '${'.$norm_local_name.'}' : undef),
		$cmake_test_spec_string,
		(defined($cmake_test_spec_string) ? '${'.$test_local_name.'}' : undef),
	];
}

1;
