#!/usr/bin/env perl

use Test::More tests => 5;

use warnings;
use strict;

use English qw/ -no_match_vars /;
use Path::Class qw/ dir /;

BEGIN { use_ok( 'Butler::SourceFileList' ); }

my @test_file_list = ( qw# Common/AlgorithmCreators.h Common/ContainerJoin.h Common/NotRealFile.cpp Common/NotRealFileTest.cpp Common/Counter/Counter.h Common/Counter/CounterTest.cpp Common/Counter/CounterWheel.cpp Common/Counter/CounterWheel.h Common/OnlyTestFile/MyTest.cpp Common/OnlyNormFile/My.cpp # );

my $sfl_from_list = new_ok( 'Butler::SourceFileList', [ \@test_file_list ] );

my $expected_cmake_output = <<'EOF' ;
set(
	SOURCES_COMMON_COUNTER
		Common/Counter/CounterWheel.cpp
)

set(
	SOURCES_COMMON_ONLYNORMFILE
		Common/OnlyNormFile/My.cpp
)

set(
	SOURCES_COMMON
		${SOURCES_COMMON_COUNTER}
		Common/NotRealFile.cpp
		${SOURCES_COMMON_ONLYNORMFILE}
)

set(
	TESTSOURCES_COMMON_COUNTER
		Common/Counter/CounterTest.cpp
)

set(
	TESTSOURCES_COMMON_ONLYTESTFILE
		Common/OnlyTestFile/MyTest.cpp
)

set(
	TESTSOURCES_COMMON
		${TESTSOURCES_COMMON_COUNTER}
		Common/NotRealFileTest.cpp
		${TESTSOURCES_COMMON_ONLYTESTFILE}
)
EOF

is($sfl_from_list->output_as_cmake_spec()."\n", $expected_cmake_output, 'Check CMake output');

my $sfl_from_dir = new_ok( 'Butler::SourceFileList', [
	dir('test_data')->subdir('example_dir_structure'),
	sub {
		my ($filename) = @ARG;
		return ($filename =~ /\.(cpp|h)$/ && $filename !~ /^(bioplib|CMakeFiles|release|debug|profile|lx62_debug)/);
	}
] );
is($sfl_from_dir->output_as_cmake_spec()."\n", $expected_cmake_output, 'Check CMake output');
