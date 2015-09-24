#!/usr/bin/perl -w

# for file in **/*.md; do ../_utils/get-redirects.pl < $file; done > /tmp/redirects

use strict;

my $not_frontmatter = -1; # $not_frontmatter = 0 iff inside frontmatter
my $permalink;
my $redirect = 0;

while (<STDIN>) {
    if (m/^---$/) {
        $not_frontmatter++;
        next;

        if ($not_frontmatter > 0) {
            exit 0;
        }
    }

    if ($not_frontmatter) {
        next;
    }

    s/"//g;

    if (m/^permalink:\s+(.*)$/) {
        $permalink = $1;
        next;
    }

    if (m/^redirect_from:/) {
        $redirect = 1;
        next;
    }

    if ($redirect) {
        if (m/^- (.*)$/) {
            print "$1 $permalink\n";
        } else {
            $redirect = 0;
            next;
        }
    }
}
