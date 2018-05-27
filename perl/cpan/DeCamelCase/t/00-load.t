#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'DeCamelCase' ) || print "Bail out!\n";
}

diag( "Testing DeCamelCase $DeCamelCase::VERSION, Perl $], $^X" );
