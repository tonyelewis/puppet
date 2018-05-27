#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use English qw(-no_match_vars);
use FileHandle;
use Params::Util qw(:ALL);
use Readonly;
use IPC::Run3;

Readonly my $listOfFilesFilename => 'TestIncludesInputList.txt';
Readonly my $cleanSourceDir => $ENV{'HOME'}.'/eclipseworkspace/cudatest';
Readonly my $testCompileStem => 'TestIncludeCompile';
Readonly my $testCompileSourceFile => $testCompileStem.'.cpp';
Readonly my $testCompileObjectFile => $testCompileStem.'.o';
Readonly my $makeCommandParts => [
	'make',
	'-C',
	'release'
];
Readonly my $buildHeaderCommandParts => [
	'g++',
	'-D_DEBUG=1',
	'-I.',
	'-I/usr/local/cuda/include',
	'-I/home/tony/NVIDIA_CUDA_SDK/common/inc',
	'-I/usr/include/boost',
	'-W',
	'-Wall',
	'-Werror',
	'-Wextra',
	'-Wcast-qual',
	'-pedantic',
	'-Wno-long-long',
	'-Wno-deprecated',
	'-Wno-ignored-qualifiers',
	'-g',
	'-D_GLIBCXX_DEBUG',
	'-O3',
	'-D_NO_OF_REGISTERS_PER_THREAD=32'
];

sub getIncludeLinesAndAllLinesFromFile($);
sub checkBuildAfterModifyingFile($);

#####
# Things to work on:
#  * What if the include removal is fine but get errors about namespaces?  Check that at least one error is about something else.
#  * What if removal of an include from a header is fine but causes problems in some other dependent file?  Build file that just includes.
#  * What if an include is required only for something it in turn requires?  Try replacing an include with all the subsiduary includes.
#####

#####
# Get a list of files to process
#####
my $listOfFilesFH = new FileHandle($listOfFilesFilename, 'r');
if (!$listOfFilesFH) {
	die;
}
my @listOfFiles = (<$listOfFilesFH>);
close $listOfFilesFH;
while(chomp(@listOfFiles)) {};

#####
# Loop over the list of files
#####
foreach my $filename (@listOfFiles) {
# 	warn $filename;
	my $includeLinesAndAllLines = getIncludeLinesAndAllLinesFromFile($filename);
	my ($includeLines, $allLines) = @$includeLinesAndAllLines;
	
	my $modfiledFile = 0;
	
	#####
	# Loop over the include lines, processing each of them separately
	#####
	foreach my $includeLine (@$includeLines) {
		my $rewritePerlFH;
		
		#####
		# Overwrite the file with out the relevant include line absent
		#####
		$rewritePerlFH = new FileHandle($filename, 'w');
		$modfiledFile = 1;
		foreach my $line (@$allLines) {
			if ($line ne $includeLine) {
				print $rewritePerlFH "$line\n";
			}
		}
		close $rewritePerlFH;
		
		if (checkBuildAfterModifyingFile($filename)) {
			warn "$filename :(COMPLETELY_REMOVE): $includeLine\n";
			next;
		}
		
		if ($includeLine =~ /\"(.*\/(.*?)\.h)\"/) {
			my $includeFilename = $1;
			my $className = $2;
			my $includeLinesAndAllLinesFromIncludedFile = getIncludeLinesAndAllLinesFromFile($includeFilename);
			my ($includeIncludeLines, $includeAllLines) = @$includeLinesAndAllLinesFromIncludedFile;
# 			warn "\$className : $className    \$includeFilename : $includeFilename\n";
		
			#####
			# If that didn't work and if this is a header then try replacing the include with a forward declaration of a class
			#####
			if ($filename =~ /\.h$/) {
				$rewritePerlFH = new FileHandle($filename, 'w');
				$modfiledFile = 1;
				foreach my $line (@$allLines) {
					if ($line ne $includeLine) {
						print $rewritePerlFH "$line\n";
					}
					else {
						print $rewritePerlFH "class $className;\n";
					}
				}
				close $rewritePerlFH;
				if (checkBuildAfterModifyingFile($filename)) {
					warn "$filename :(REPLACE_WITH_FORWARD_DECLARATION): $includeLine\n";
					next;
				}
			}
			
			#####
			# If that didn't work and then try including the included file's includes
			#####
			$rewritePerlFH = new FileHandle($filename, 'w');
			$modfiledFile = 1;
			foreach my $line (@$allLines) {
				if ($line ne $includeLine) {
					print $rewritePerlFH "$line\n";
				}
				else {
					print $rewritePerlFH join("\n", @$includeIncludeLines)."\n";
				}
			}
			close $rewritePerlFH;
			if (checkBuildAfterModifyingFile($filename)) {
				warn "$filename :(REPLACE_WITH_INCLUDES_FROM_HEADER): $includeLine\n";
				next;
			}
			
			#####
			# If that didn't work and if this is a header then try replacing the include with both (a forward decl. and the includes)
			#####
			if ($filename =~ /\.h$/) {
				$rewritePerlFH = new FileHandle($filename, 'w');
				$modfiledFile = 1;
				foreach my $line (@$allLines) {
					if ($line ne $includeLine) {
						print $rewritePerlFH "$line\n";
					}
					else {
						print $rewritePerlFH join("\n", @$includeIncludeLines)."\nclass $className;\n";
					}
				}
				close $rewritePerlFH;
				if (checkBuildAfterModifyingFile($filename)) {
					warn "$filename :(REPLACE_WITH_FORWARD_DECLARATION_AND_INCLUDES_FROM_HEADER): $includeLine\n";
					next;
				}
			}
		}
	}
	
	#####
	# Rewrite the original file and make sure the project compiles correctly again
	#####
	if ($modfiledFile) {
		my $rewritePerlFH = new FileHandle($filename, 'w');
		foreach my $line (@$allLines) {
			print $rewritePerlFH "$line\n";
		}
		my ($makeCommandStdout, $makeCommandStderr);
		run3($makeCommandParts, undef, \$makeCommandStdout, \$makeCommandStderr, {'return_if_system_error' => 'true'});
		if ($CHILD_ERROR != 0) {
			die "\n***PROBLEM***\n".Dumper($OS_ERROR)."\n***PROBLEM***\n";
		}
	}
}

sub getIncludeLinesAndAllLinesFromFile($) {
	my ($fileToParseFilename) = @ARG;
	
	#####
	# Read the file and get two lists:
	#  * One containing all lines
	#  * and another containing the include lines
	#####
	my $fileToParseFH = new FileHandle($fileToParseFilename, 'r');
	if (!$fileToParseFH) {
		die "Unable to open \"$fileToParseFilename\" for reading : $OS_ERROR\n";
	}
	my @allLines;
	my @includeLines;
	while (my $line = <$fileToParseFH>) {
		while(chomp($line)) {};
		push @allLines, $line;
		if ($line =~ /^#include/) {
			push @includeLines, $line;
		}
	}
	close $fileToParseFH;
	return [\@includeLines, \@allLines];
}


sub checkBuildAfterModifyingFile($) {
	my ($checkFilename) = @ARG;
	
	#####
	# Default to the normal make command
	#####
	my $commandParts = $makeCommandParts;
	
	#####
	# ...but if this is a header, construct a suitable .cpp file to include it
	# and use a command to build that
	#####
	if ($checkFilename =~ /\.h$/) {
		my $writeNewSourceFH = new FileHandle($testCompileSourceFile, 'w');
		print $writeNewSourceFH <<"EOF";
#include "$checkFilename"

#include <iostream>

using namespace std;

int main() {
	cerr << endl;
	return 0;
}
EOF
		close $writeNewSourceFH;
		
		$commandParts = [@$buildHeaderCommandParts, $testCompileSourceFile, '-o', $testCompileObjectFile];
	}
	
	my ($commandStdout, $commandStderr);
	run3($commandParts, undef, \$commandStdout, \$commandStderr, {'return_if_system_error' => 'true'});
	return ($CHILD_ERROR == 0);
}

