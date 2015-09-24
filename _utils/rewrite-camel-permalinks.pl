#!/usr/bin/perl -w

use strict;

my $not_frontmatter = -1; # $not_frontmatter = 0 iff inside frontmatter
my $permalink;
my $need_redirect = 1;

while (<STDIN>) {
    if (m/^---$/) {
        $not_frontmatter++;

        if ($not_frontmatter == 1 and $need_redirect) {
            print "redirect_from: $permalink\n";
        }
    }

    if (!$not_frontmatter) {
        if (m/^permalink:/) {

            # store permalink to add it to redirects and add
            my @line = split /:\s*/;
            $permalink = $line[1];
            $permalink =~ s/\s+$//;
            $_ = "/en" . $permalink;
            s/([[:upper:]])/-$1/g;
            s/\/-/\//g;
            print "permalink: " . lc($_) . "\n";
            $_ = '';
        }
        
        if (m/^redirect_from:/) {
            $need_redirect = 0;
            my @line = split /\s+/;

            if (@line > 1) {
                print shift(@line) . "\n";
                print "- $permalink\n";
                foreach my $link (@line) {
                    $link =~ s/\s+$//;
                    print "- $link\n";
                }

            } else {
                print;
                print "- $permalink\n";
            }

            $_ = '';
            undef $permalink;
        }
    }

    print;
}
