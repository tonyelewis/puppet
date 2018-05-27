#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Butler' ) || print "Bail out!\n";
}

diag( "Testing Butler $Butler::VERSION, Perl $], $^X" );
