#!/usr/bin/env perl

use strict;
use warnings;

use Carp                       qw/ confess        /;
use Data::Dumper;
use English                    qw/ -no_match_vars /;
use MooseX::Params::Validate;
use MooseX::Types::Path::Class qw/ Dir File       /;
use Path::Class                qw/ dir file       /;
use Readonly;

Readonly my $SOURCE_DIR => dir('', 'home', 'lewis', 'svn', 'cudatest', 'trunk', 'source');

decommentise($SOURCE_DIR);

sub decommentise {
	my ( $source_dir ) = pos_validated_list(
		\@ARG,
		{ isa => Dir, coerce => 1 },
	);
	
# 	warn "** $source_dir\n";
	
	while (my $file = $source_dir->next) {
		if ($file->basename() eq '.' || $file->basename() eq '..' || $file eq $source_dir) {
			next;
		}
		if ($file->is_dir()) {
# 			warn "In $source_dir, about to call for $file\n";
			decommentise($file);
		}
		else {
			warn "Processing $file\n";
			my @lines = $file->slurp();
			while (chomp(@lines)) {}
			my @new_lines;
			foreach my $line (@lines) {
				if ($line !~ '^\s*\/\/\/\/\/\/?\s*$') {
					push @new_lines, $line;
				}
			}
			$file->spew(join("\n", @new_lines)."\n");
# 			confess "";
		}
	}
# 	warn "** \n";
}
