use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'DeCamelCase',
    AUTHOR              => q{Tony Lewis <a@b.com>},
    VERSION_FROM        => 'lib/DeCamelCase.pm',
    ABSTRACT_FROM       => 'lib/DeCamelCase.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'DeCamelCase-*' },
);
