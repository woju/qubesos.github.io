#!/usr/bin/perl -w

use strict;

my $not_frontmatter = -1; # $not_frontmatter = 0 iff inside frontmatter
my %redirects = ();

open(my $fh, '<', '/tmp/redirects')
    or die "first create redirect maps in /tmp/redirects";

while (<$fh>) {
    my ($key, $value) = split;
    $redirects{$key} = $value;
    $redirects{$value} = $value;
}

close $fh;

while (<STDIN>) {
    if (m/^---$/) {
        $not_frontmatter++;
        print;
        next;
    }

    if ($not_frontmatter <= 0) {
        print;
        next;
    }

    s/\[(.*?)\]\((\/.*?)\)/exists $redirects{$2} ? "[$1]($redirects{$2})" : "[$1]($2)"/ge;
    print;
}
