#!/usr/bin/env perl

use strict;
use warnings;

use Carp        qw/ confess        /;
use Cwd;
use Data::Dumper;
use English     qw/ -no_match_vars /;
use Path::Class qw/ dir file       /;
use Term::ANSIColor;
# use Test::More tests => 2;
use Test::More;

$OUTPUT_AUTOFLUSH = 1;

my $run_self_tests = 0;

if ( $run_self_tests ) {
	my $eg_orig_dir  = dir ( '/home/some_user' );
	is( tidy_source_filename( file( '', 'usr', 'a.hpp'      ), $eg_orig_dir ), file( '', 'usr', 'a.hpp' ) );
	is( tidy_source_filename( file( '..', 'source', 'a.cpp' ), $eg_orig_dir ), file( 'a.cpp'            ) );
	is( tidy_source_filename( file( 'source', 'a', 'b.cpp'  ), $eg_orig_dir ), file( 'a', 'b.cpp'       ) );
}
else {

	my $orig_dir = dir( getcwd() );

	while (my $line = <STDIN>) {
		while (chomp($line)) {};
		print color 'reset';
		
		if ($line =~ /^\s*from\b/ ||
		    $line =~ /^In file included from\b/ ||
		    $line =~ /At global scope\b/ ||
		    $line =~ /candidates are\b/ ||
		    $line =~ /empty character\b/ ||
		    $line =~ /error:/i ||
		    $line =~ /first defined here\b/ ||
		    $line =~ /in constexpr expansion of\b/ ||
		    $line =~ /In constructor\b/ ||
		    $line =~ /In copy constructor\b/ ||
		    $line =~ /In destructor\b/ ||
		    $line =~ /In function\b/ ||
		    $line =~ /In instantiation of\b/ ||
		    $line =~ /In member function\b/ ||
		    $line =~ /In static member function\b/ ||
		    $line =~ /In substitution of\b/ ||
		    $line =~ /instantiated from\b/ ||
		    $line =~ /more undefined references to\b/ ||
		    $line =~ /multiple definition of\b/ ||
		    $line =~ /note:/ ||
		    $line =~ /required by substitution of\b/ ||
		    $line =~ /required from\b/ ||
		    $line =~ /undefined reference to\b/
		    ) {
			#process_message_line( $line, 'red', 'bold red' );
			process_message_line( $line, 'bold red', 'yellow' );
		}
		elsif ($line =~ /^\s*g\+\+/ || $line =~/^\s*g?cc/ || $line =~ /^if / || $line =~ /^\s*f77/ || $line =~ /^\S*nvcc\s+/ ) {
			print color 'reset';
			print color 'bold';
			print "$line";
			print color 'reset';
		}
		elsif ( $line =~/warning:/ ) {
			process_message_line( $line, 'yellow', 'bold yellow' );
		}
	# 	elsif ( $line =~/^make/ || $line =~ /recipe for target/ || $line =~ /Building CXX object/ ) {
		elsif ( $line =~/^make/ || $line =~ /recipe for target/ || $line =~ /ninja: Entering directory/ ) {
			print color 'bold blue';
			print "$line";
			print color 'reset';
		}
		elsif ($line =~/^(\s*)(\^)(\s*)$/) {
			print color 'reset';
			print $1;
			print color 'bold white';
			print $2;
			print color 'reset';
			print $3;
		}
		else {
			print "$line";
		}
		print color 'reset';
		print "\n";
	}

}

sub process_message_line {
	my $line             = shift;
	my $normal_colour    = shift;
	my $highlight_colour = shift;
	
	$line =~ /^(.*?\:.*?)(\s+.*)?$/
		or confess "Unable to parse line \"$line\"";
	my $first_half  = $1;
	my $second_half = $2 // '';
	my @prefix_parts = ( split( /:/, $first_half ), $second_half );
	my $message = pop @prefix_parts;
	
	@prefix_parts = map { ( $ARG, ':' ) } @prefix_parts;
	if ( scalar( @prefix_parts ) >= 2 && $prefix_parts[-2] =~ /\s+\w/) {
		$message = (pop @prefix_parts).$message;
		$message = (pop @prefix_parts).$message;
	}
	if ( scalar( @prefix_parts ) >= 2 && $prefix_parts[-2] =~ /(\d+)\,/) {
		$prefix_parts[-2] = $1;
		$prefix_parts[-1] = ','
	}
	my $message_parts = split_message_on_quotes( $message );
	
	if ( $prefix_parts[ 0 ] =~ /\sfrom\s(.*)/ || $prefix_parts[ 0 ] =~ /(.*)/ ) {
		$prefix_parts[ 0 ] = tidy_source_filename( file( $1 ), dir( getcwd() ) );
	}
	
	for (my $prefix_part_ctr = 0; $prefix_part_ctr < scalar( @prefix_parts ); ++$prefix_part_ctr ) {
		if ( $prefix_part_ctr == 0 ) {
			print color 'magenta'
		}
		elsif ( $prefix_part_ctr % 2== 0 ) {
			print color 'green'
		}
		else {
			print color 'cyan'
		}
		print $prefix_parts[ $prefix_part_ctr ];
		print color 'reset'
	}

	for (my $message_part_ctr = 0; $message_part_ctr < scalar( @$message_parts ); ++$message_part_ctr ) {
		print color $normal_colour;
		if ( $message_part_ctr % 2 != 0 )  {
			print color $highlight_colour;
		}
		print $message_parts->[ $message_part_ctr ];
		print color 'reset';
	}
}

sub split_message_on_quotes {
	my $message = shift;
	
	$message =~ s/([‘’]*‘)/SPLIT_MESSAGE_HERE$1/g;
	$message =~ s/([‘’]*’)/${1}SPLIT_MESSAGE_HERE/g;
	my @message_parts = split( /SPLIT_MESSAGE_HERE/, $message );
	return \@message_parts;
}

sub tidy_source_filename {
	my $file     = shift;
	my $orig_dir = shift;

	if ( $file->is_relative() ) {
		my @components = $file->components();

		if ( scalar( @components ) > 2 && $components[ 0 ] eq '..' ) {
			$file = file( splice( @components, 2 ) );
			@components = $file->components();
		}

		if ( scalar( @components ) > 1 && $components[ 0 ] eq 'source' ) {
			$file = file( splice( @components, 1 ) );
		}

	}
	# my @components = $file->components();
	# warn Dumper( \@components );

	# if ( ! -e $file ) {
	# 	if ( -e $file->absolute( $orig_dir ) ) {
	# 		$file = $file->absolute( $orig_dir );
	# 	}
	# 	elsif ( -e $file->absolute( $orig_dir->subdir( 'source') ) ) {
	# 		$file = $file->absolute( $orig_dir->subdir( 'source') )->resolve();
	# 		#$file = $file->cleanup();
	# 		warn "Trying $file\n";
	# 	}
	# }
	if ( $file->is_absolute() && $orig_dir->subsumes( $file ) ) {
		$file = $file->relative( $orig_dir );
	}
	# 	warn "subsuming : $file\n\t\$orig_dir is $orig_dir\n\t\$file_local is $file_local\n";
	# 	#$prefix_parts[0] =~ s/$file/$file_local/g;
	# 	$file_local =~ s/\bsource\///g;
	# 	$file = $file_local;
	# }
	return $file;
	# else {
	# 	warn "Does not exist : $file\n\t\$orig_dir is $orig_dir\n\tcwd is ".dir( getcwd() )."\n";
	# }
}