#!/usr/bin/perl

use URI;
use Web::Scraper;
use Data::Dumper;

my $HOMEPAGE = "/home/robin/Privat/up57_repo/MyIntraNet/index.html";

# First, create your scraper block
my $daily = scraper {
    process ".ngg-singlepic", img => '@src';
};

my $res = $daily->scrape( URI->new("http://www.glasbergen.com/") );

my $img_src = $res->{'img'};

$img_src =~ m/.*(toon[0-9\-]+\.gif)/g;

my $img = $1;

open($HP , "<$HOMEPAGE") || die ( "Keine Homepage gefunden" );
my $page;
while(<$HP>){
    if($_ =~ m/toon[0-9\-]+\.gif/g){
        $_ =~ s/toon[0-9\-]+\.gif/$img/eg;
    }
    $page .= $_;
}
close( $HP );

open($HP , ">$HOMEPAGE") || die ( "Keine Homepage gefunden" );
print $HP $page;
close( $HP );

