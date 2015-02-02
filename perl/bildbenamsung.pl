#!/usr/bin/perl

use strict;
use warnings;
use Date::Calc qw(Today);

my $ausgangspfad = "/home/robin/Privat/Groups/Bilder/Groups/";
my $themen       = {
    "Bild"       => "tumblr",
};

my $pfad         = q{};
my $beschreibung = "Bild_News|Name";
my $zaehler      = "001";
my ( $y, $m, $d ) = Today();
my $date = sprintf "%4d-%02d-%02d", $y, $m, $d;

$beschreibung =~ m/([^|]+)\|([^|]*)/;
my $tags  = $1;
my $titel = $2;

$tags =~ m/([^_]+)/;
my $thema = $1;

unless ( defined $themen->{$thema} ) {
    print STDERR "Keinen gueltigen Pfad gefunden! $thema \n\n";
}
else {
    $pfad = $ausgangspfad . $themen->{$thema};
}

opendir( FOLDER, $pfad );
while ( my $file = readdir(FOLDER) ) {
	next if $file eq ".";
	next if $file eq "..";
	$file =~ m/([^\.]+)\.([^\.]+)/g;
	if($1 =~ m/$date/){
		print STDERR "\nWarte bis Morgen\n\n";
		exit;
    }
	next if $1 =~ m/\d{4}\-\d{2}\-\d{2}\-\d{3}/;
	my $endung = $2;
	if( $endung =~ m/jpg/i || $endung =~ m/gif/i || $endung =~ m/png/i || $endung =~ m/jpeg/i ){
		my $newname
    	    = $pfad . "/"
        	. $date . "-"
        	. $zaehler
        	. "." . $endung;
    	$file = $pfad . "/" . $file;
      	rename $file, $newname;
		print STDERR "$file => $newname\n";
	}else{
		print STDERR "\n\n$endung - $1\n\n";
	}
    $zaehler++;
}
closedir(FOLDER);
