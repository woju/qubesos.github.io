#!/usr/bin/perl -w

use strict;

my $arg = $ARGV[0];
$arg =~ s/([[:upper:]])/-$1/g;
$arg =~ s/(\/|^)-/$1/g;
print lc $arg . "\n";
