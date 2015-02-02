#!/usr/bin/env perl

use Date::Calc qw( Today_and_Now );
use Data::Dumper;
use YAML qw( LoadFile );
use WWW::Tumblr;
use WWW::Mechanize;
use File::Copy qw/move/;

my $state    = "queue";
my( $home )  = glob "~";
my $cfg_file = "$home/.tumblr.yml";
my $folder   = "$home/Privat/Groups/Bilder/Groups/tumblr";
my $doppel   = "$home/Privat/Groups/Bilder/Doppelt/";
my $error   = "$home/Privat/Groups/Bilder/Error/";
my $LOGLIB = "$home/Privat/image_upload.lib";
my $LOGFILE = "$home/Privat/logfile.txt";
require $LOGLIB;

my $logger = $VAR1;

my ( $year, $month, $day, $hour, $min, $sec ) = Today_and_Now();
my $heute = $year . "-" . $month . "-" . $day . "  " . $hour . " Nr. ";

my $cfg = LoadFile( $cfg_file );

my $t = WWW::Tumblr->new(
  consumer_key => $cfg->{ consumer_key },
  secret_key   => $cfg->{ secret_key },
  token        => $cfg->{ token },
  token_secret => $cfg->{ token_secret },
);

my $blog = $t->blog( "saextus.tumblr.com" );

opendir( FOLDER, $folder );
open( LOG, ">>".$LOGFILE); 
my $zaehler = 1;
my @files=readdir(FOLDER);
closedir(FOLDER);
@files = sort { -M "$files/$b" <=> -M "$files/$a" } (@files);
my @reverse;
for ( my $i = 0; $i < @files; $i++){
	push @reverse, pop @files;
}
foreach my $file (  @reverse ) {
    my $fehler = 0;
    my $fehlerfall;
    my $post;
    my @errorstring;
    if ( $file =~ m/\.(jpg|png|gif|jpeg|flv|mov|mpg|mpeg|avi)/i ) {
#        print LOG "$file \n";
	my $type = 'photo';
        if ( $file =~ m/\.(jpg|png|gif|jpeg)/i ){
		$type = 'photo';
	}else{
		$type = 'video';
	}
        unless( $logger->{$file}){
	    $post = $blog->post(
                        type      => $type,
			data      => [$folder . "/" . $file],
                        state     => $state,
			tags	  => "Internetfundstueck, nude",
			caption   => "$heute - $zaehler",
            );
        }else{
            $fehlerfall =  "Bildname wurde schon mal hochgeladen";
        } 
        if ( $post ) {
#            print LOG "Hochgeladen:\n \t$file\n".$post->{id}."\n";
            $logger->{$file}++;
            $zaehler++;
       	    unlink $folder . "/" . $file;
        }else{
	    if($fehlerfall){
#                print LOG $fehlerfall . "\n\n";
                move $folder . "/" . $file, $doppel;
            }else{
                print LOG  Dumper($blog->error->reasons) . "\n\n";
                if ( $blog->error->reasons->[0] =~ m/Error uploading / ){
                    move $folder . "/" . $file, $error;
                }
                if ( $blog->error->reasons->[1] =~ "queue more than 300" ){
		    exit(1);
                }
            }
	}
    }
}
open(LOGGER, ">".$LOGLIB)||die("Fuck: ".$@);
print LOGGER Dumper($logger);
print LOGGER "\n1\;\n";
close LOGGER;
close LOG;
