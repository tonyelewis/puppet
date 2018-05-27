package DeCamelCase;

use 5.006;
use strict;
use warnings;

use Carp                       qw/ confess              /;
use English                    qw/ -no_match_vars       /;
use List::Util                 qw/ maxstr minstr        /;
use List::MoreUtils            qw/ uniq                 /;
use MooseX::Params::Validate;
use MooseX::Types::Moose       qw/ ArrayRef HashRef Str /;
use MooseX::Types::Path::Class qw/ Dir File             /;
use Path::Class                qw/ dir file             /;

=head1 NAME

DeCamelCase - The great new DeCamelCase!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

my @global_temp_source_files_for_constr;

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use DeCamelCase;

    my $foo = DeCamelCase->new();
    ...

=head1 SUBROUTINES/METHODS

=head2 _file_find_wanted_fn

Private subroutine that is used by get_source_files_of_dir() to recursively
scan through directories, generating a list of source code file objects

=cut

sub _file_find_wanted_fn {
# 	use Data::Dumper;
# 	warn Dumper(\@ARG);
# 	my $self = shift;
	my ( $child, $cont ) = pos_validated_list(
		\@ARG,
		{ isa => File|Dir,  coerce => 1 },
		{ isa => 'CodeRef',             },
	);
	
	# If this is a file (ie not a directory) then either:
	#  * add it to the back of @global_temp_source_files_for_constr if it has a .cpp or .h extension or
	#  * warn otherwise
	if ( ! $child->is_dir() ) {
		if ($child =~ /\.cpp$/ || $child =~ /\.h$/ || $child =~ /\.cu$/ || $child =~ /\.cuh$/ || $child =~ /\.ptx$/) {
			push @global_temp_source_files_for_constr, $child;
		}
		else {
			warn "Do not recognise file \"$child\"";
		}
	}
	$cont->();
}

=head2 function1

=cut

sub get_source_files_of_dir {
	my $self = shift;
	my ( $source_code_dir ) = pos_validated_list(
		\@ARG,
		{ isa => Dir },
	);
	
	# Clear @global_temp_source_files_for_constr and then
	# repopulate it by traversing $source_code_dir
	@global_temp_source_files_for_constr = ();
	$source_code_dir->traverse(\&_file_find_wanted_fn);
	@global_temp_source_files_for_constr = sort {"$a" cmp "$b"} @global_temp_source_files_for_constr;
	@global_temp_source_files_for_constr = map { $ARG->relative($source_code_dir) } @global_temp_source_files_for_constr;
	return \@global_temp_source_files_for_constr;
}

sub remove_files_to_exclude_from_file {
	my $self = shift;
	my ( $source_code_files, $exclude_file ) = pos_validated_list(
		\@ARG,
		{ isa => ArrayRef[File] },
		{ isa => File           },
	);
	
	my @files_to_exclude = $exclude_file->slurp();
	while (chomp(@files_to_exclude)) {}
	
	return __PACKAGE__->remove_files_to_exclude($source_code_files, \@files_to_exclude);
}

sub remove_files_to_exclude {
	my $self = shift;
	my ( $source_code_files, $files_to_exclude ) = pos_validated_list(
		\@ARG,
		{ isa => ArrayRef[File] },
		{ isa => ArrayRef[Str] },
	);
	
	my %files_to_exclude = map {($ARG, 1)} @$files_to_exclude;
	
# 	use Data::Dumper;
# 	warn Dumper(\%files_to_exclude);
	
# 	my @new_source_code_files;
# 	foreach my $source_code_file (@$source_code_files) {
# 		warn $source_code_file->relative();
# 		if ( ! $files_to_exclude{$source_code_file->relative()} ) {
# 			push @new_source_code_files, $source_code_file;
# 		}
# 	}
# 	return \@new_source_code_files;
	
	my @new_source_code_files = map { !defined($files_to_exclude{$ARG}) ? ($ARG) : () } @$source_code_files;
	return \@new_source_code_files;
}

sub remove_ids_to_exclude_from_file {
	my $self = shift;
	my ( $ids, $exclude_file ) = pos_validated_list(
		\@ARG,
		{ isa => ArrayRef[Str] },
		{ isa => File },
	);
	
	my @ids_to_exclude = $exclude_file->slurp();
	while (chomp(@ids_to_exclude)) {}
	return __PACKAGE__->remove_ids_to_exclude( $ids, \@ids_to_exclude);
}

sub remove_ids_to_exclude {
	my $self = shift;
	my ( $ids, $ids_to_exclude) = pos_validated_list(
		\@ARG,
		{ isa => ArrayRef[Str] },
		{ isa => ArrayRef[Str] },
	);
	
	my %ids_to_exclude = map { ( $ARG, 1 ) } @$ids_to_exclude;
	my @new_ids = map { !defined($ids_to_exclude{$ARG}) ? ($ARG) : () } @$ids;
	return \@new_ids;
}

=head2 get_components_of_file_or_dir

TODO: Update Path::Class to 0.32 so that it has
      the components() method and then remove this.

=cut

sub get_components_of_file_or_dir {
	my $self = shift;
	my ( $file_or_dir ) = pos_validated_list(
		\@ARG,
		{ isa => File|Dir },
	);
	
	my @components;
	while ( $file_or_dir ne dir() && $file_or_dir ne dir('') 	) {
		unshift @components, $file_or_dir->basename();
		$file_or_dir = $file_or_dir->parent();
	}
	return \@components;
}

sub get_camel_case_ids_from_filenames {
	my $self = shift;
	my ( $source_code_files ) = pos_validated_list(
		\@ARG,
		{ isa => ArrayRef[File] },
	);
	
	my %camel_case_ids;
	foreach my $source_code_file (@$source_code_files) {
		my $components = __PACKAGE__->get_components_of_file_or_dir($source_code_file);
		foreach my $filename (@$components) {
			$filename =~ s/\.h$//g;
			$filename =~ s/\.cpp$//g;
			if ($filename =~ /[A-Z]/ && $filename =~ /[a-z]/) {
				$camel_case_ids{$filename} = 1;
			}
		}
	}
	return [sort(keys(%camel_case_ids))];
}

sub get_camel_case_ids_from_contents_of_files {
	my $self = shift;
	my ( $root_dir, $source_code_files ) = pos_validated_list(
		\@ARG,
		{ isa => Dir },
		{ isa => ArrayRef[File] },
	);
	
	my %camel_case_ids;
	foreach my $source_code_file (@$source_code_files) {
		my @lines = $root_dir->file($source_code_file)->slurp();
		while (chomp(@lines)) {}
		my $new_ccids = __PACKAGE__->_get_camel_case_ids_from_lines(\@lines);
		%camel_case_ids = map {($ARG, 1)} (@$new_ccids, sort(keys(%camel_case_ids)));
	}
	
	return [sort(keys(%camel_case_ids))];
}

=head2 _get_camel_case_ids_from_lines

=cut

sub _get_camel_case_ids_from_lines {
	my $self = shift;
	my ( $source_code_lines ) = pos_validated_list(
		\@ARG,
		{ isa => ArrayRef[Str] },
	);
	
	my %camel_case_ids;
	foreach my $source_code_line_orig (@$source_code_lines) {
		my $source_code_line = $source_code_line_orig;
		# Strip off any //-style comments
		$source_code_line =~ s/\/\/.*$//g;
		
		while ($source_code_line =~ /([\w_]+)/) {
			my $id = $1;
			if ($id =~ /[A-Z]/ && $id =~ /[a-z]/) {
				$camel_case_ids{$id} = 1;
			}
			$source_code_line =~ s/\b$id\b//g;
		}
	}
	
	if ($camel_case_ids{'oOfTPerTGroup'}) {
		confess join("\n", @$source_code_lines);
	}
	
	return [sort(keys(%camel_case_ids))];
}

sub process_source_dir_into_another {
	my $self = shift;
	my ( $source_dir, $dest_dir, $ids_from_files, $ids_from_source ) = pos_validated_list(
		\@ARG,
		{ isa => Dir           },
		{ isa => Dir           },
		{ isa => ArrayRef[Str] },
		{ isa => ArrayRef[Str] },
	);
	
	my @all_ids = uniq( sort( @$ids_from_files, @$ids_from_source ) );
	my $sc_of_cc = __PACKAGE__->snake_case_id_of_camel_case_id_list(\@all_ids);
	$sc_of_cc    = __PACKAGE__->fix_initial_letter_duplicates_in_sc_of_cc($sc_of_cc);
	$sc_of_cc->{'Price'} = 'price';
	
# 	use Data::Dumper;
# 	confess Dumper( [ $source_dir, $dest_di, $sc_of_cc ] );
	__PACKAGE__->_process_source_dir_into_another(
			$source_dir,
			$source_dir,
			$dest_dir,
			$dest_dir,
			$sc_of_cc
		);
}

sub _process_source_dir_into_another {
	my $self = shift;
	my ( $source_root_dir, $source_dir, $dest_root_dir, $dest_dir, $sc_of_cc ) = pos_validated_list(
		\@ARG,
		{ isa => Dir          },
		{ isa => Dir          },
		{ isa => Dir          },
		{ isa => Dir          },
		{ isa => HashRef[Str] },
	);
	
# 	my $source_dir_hd = $source_dir->open()
# 		or confess "Unable to open dir \"$source_dir\" for reading : $OS_ERROR";
	my @source_children = sort($source_dir->children());
	foreach my $source_child (@source_children) {
		my $child_parent   = $source_child->parent();
		my $child_basename = $source_child->basename();
		my $dest_basename  = __PACKAGE__->_process_string($child_basename, $sc_of_cc);
		if ($source_child->is_dir()) {
			my $child_dest_dir = $dest_dir->subdir( $dest_basename );
			my $source_file_rel_name = $dest_dir->file($child_basename)->relative($dest_root_dir)."";
			my   $dest_file_rel_name = $child_dest_dir->relative($dest_root_dir)."";
			warn "1 svn rename $source_file_rel_name $dest_file_rel_name\n";
			if (!-d $child_dest_dir) {
				$child_dest_dir->mkpath()
					or confess "Unable to make directory \"$child_dest_dir\" : $OS_ERROR";
			}
			warn localtime(time()).' : Processing '.$source_child->relative($source_root_dir).' into '.$child_dest_dir->relative($dest_root_dir)."\n";
			__PACKAGE__->_process_source_dir_into_another($source_root_dir, $source_child, $dest_root_dir, $child_dest_dir, $sc_of_cc);
		}
		else {
			my @source_lines = $source_child->slurp();
			my @dest_lines = map { __PACKAGE__->_process_string($ARG, $sc_of_cc) } @source_lines;
			my $child_dest_file = $dest_dir->file( $dest_basename );
			$child_dest_file->spew( join('', @dest_lines) );
# 			if ( $source_child->parent()->relative($source_root_dir)."" eq $child_dest_file->parent()->relative($dest_root_dir)."" ) {
				my $source_file_rel_name = $dest_dir->file($child_basename)->relative($dest_root_dir)."";
				my   $dest_file_rel_name = $child_dest_file->relative($dest_root_dir)."";
				if ($source_file_rel_name ne $dest_file_rel_name) {
					warn "2 svn rename $source_file_rel_name $dest_file_rel_name\n";
				}
# 			}
# 			else {
# 				warn $source_child->parent()->relative($source_root_dir)." ".$child_dest_file->parent()->relative($dest_root_dir)."";
# 				warn "3 svn rename ".$source_child->parent()->relative($source_root_dir)." ".$child_dest_file->parent()->relative($dest_root_dir)."\n";
# 			}
		}
# 		warn "$source_child ".;
	}

	return $source_dir;
}

sub _process_string {
	my $self = shift;
	my ( $string, $sc_of_cc ) = pos_validated_list(
		\@ARG,
		{ isa => Str          },
		{ isa => HashRef[Str] },
	);
	
	foreach my $camel_case (sort(keys(%$sc_of_cc))) {
		my $snake_case = $sc_of_cc->{$camel_case};
		$string =~ s/\b$camel_case\b/$snake_case/g;
	}
	
	return $string;
}

sub snake_case_id_of_camel_case_id_list {
	my $self = shift;
	my ( $camel_case_ids ) = pos_validated_list(
		\@ARG,
		{ isa => ArrayRef[Str] },
	);
	
	my %snake_case_id_of_camel_case_id;
	my %special_snake_case_id_of_camel_case_id;
	foreach my $camel_case_id (@$camel_case_ids) {
		my $snake_case_id = $camel_case_id;
		$snake_case_id =~ s/([A-Z]+)/'_'.lc($1)/ge;
		$snake_case_id =~ s/__/_/g;
		$snake_case_id =~ s/^_//g;
		$snake_case_id_of_camel_case_id{$camel_case_id} = $snake_case_id;
		if ($camel_case_id =~ /[A-Z][A-Z]/) {
			$special_snake_case_id_of_camel_case_id{$camel_case_id} = $snake_case_id;
		}
	}
# 	use Data::Dumper;
# 	confess Dumper(\%special_snake_case_id_of_camel_case_id);
	
	return \%snake_case_id_of_camel_case_id;
}

sub fix_initial_letter_duplicates_in_sc_of_cc {
	my $self = shift;
	my ( $snake_case_id_of_camel_case_id ) = pos_validated_list(
		\@ARG,
		{ isa => HashRef[Str] },
	);
	
	# Produce a reverse hash (snake_case_id => camel_case_ids)
	my %camel_case_ids_of_snake_case_id;
	foreach my $camel_case_id (sort(keys(%$snake_case_id_of_camel_case_id))) {
		my $snake_case_id = $snake_case_id_of_camel_case_id->{$camel_case_id};
		push @{$camel_case_ids_of_snake_case_id{$snake_case_id}}, $camel_case_id;
	}
	
	# Check for duplicates
	my %snake_case_id_of_camel_case_id_copy = %$snake_case_id_of_camel_case_id;
	foreach my $snake_case_id (sort(keys(%camel_case_ids_of_snake_case_id))) {
# 	warn $snake_case_id;
		my $camel_case_ids = $camel_case_ids_of_snake_case_id{$snake_case_id};
		if ( scalar(@$camel_case_ids) > 1 ) {
			if ( scalar(@$camel_case_ids) != 2 ) {
				warn "WARNING: More than two camel case IDs for snake case '$snake_case_id' : '".join("', '", @$camel_case_ids)."'\n";
				next;
			}
			my $id1 = minstr(@$camel_case_ids);
			my $id2 = maxstr(@$camel_case_ids);
			
			if (lc(substr($id1, 0, 1)).substr($id1, 1) ne $id2) {
				warn "$id1 and $id2 clash in snake case but cannot be handled as an initial letter duplicate\n";
				next;
			}
			$snake_case_id_of_camel_case_id_copy{$id2} = 'the_'.$snake_case_id;
			warn $snake_case_id.' -> the_'.$snake_case_id."\n"
		}
	}
	
	return \%snake_case_id_of_camel_case_id_copy;
}

# sub snake_case_id_of_camel_case_id_list {
# 	my $self = shift;
# 	my ( $camel_case_ids ) = pos_validated_list(
# 		\@ARG,
# 		{ isa => ArrayRef[Str] },
# 	);
# 	
# 	my %camel_case_of_snake_case;
# 	my %snake_case_id_of_camel_case_id;
# 	my %special_snake_case_id_of_camel_case_id;
# 	foreach my $camel_case_id (@$camel_case_ids) {
# 		my $is_special = ($camel_case_id =~ /[A-Z]{2}/);
# 		my $snake_case_id = $camel_case_id;
# 		$snake_case_id =~ s/([A-Z]+)/'_'.lc($1)/ge;
# 		$snake_case_id =~ s/__/_/g;
# 		$snake_case_id =~ s/^_//g;
# 		push @{$camel_case_of_snake_case{$snake_case_id}}, $camel_case_id;
# 		$snake_case_id_of_camel_case_id{$camel_case_id} = $snake_case_id;
# 		if ($is_special) {
# 			$special_snake_case_id_of_camel_case_id{$camel_case_id} = $snake_case_id;
# 		}
# 	}
# 	
# 	foreach my $snake_case (sort(keys(%camel_case_of_snake_case))) {
# 		my $camel_case = $camel_case_of_snake_case{$snake_case};
# 		if (scalar(@$camel_case) > 1) {
# 			warn "$snake_case -> ".join(", ", @$camel_case)."\n"
# 		}
# 	}
# 	use Carp qw/ confess /;
# 	use Data::Dumper;
# 	confess Dumper(\%special_snake_case_id_of_camel_case_id)." ";
# }

1; # End of DeCamelCase













