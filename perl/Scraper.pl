#!/usr/bin/perl
use URI;
use Web::Scraper;
use Data::Dumper;

# First, create your scraper block
my $tweets = scraper {
    process "li", "links[]" => scraper {
        process "a", link => '@href';
    };
};

my $res = $tweets->scrape( URI->new("http://www.googelhupf.de/") );

print STDERR Dumper($res);