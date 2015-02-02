#!/usr/bin/perl

use Date::Calc qw( Today_and_Now );
use Mail::Audit qw( Attach );
use Regexp::Common qw /URI/;
use File::Find;
use File::Spec::Functions qw( splitdir );
use Data::Dumper;

( $year, $month, $day, $hour, $min, $sec ) = Today_and_Now();

my $bilder = "/home/robin/Privat/Groups/Bilder/Groups/";
my $filme = "/home/robin/Privat/Groups/Filme/Groups/";
 

my $mail = Mail::Audit->new;
my $attachments = $mail->attachments;
my $num_attachments = $mail->num_attachments;

my $filesizes = 0;
my $images = 0;
my $movies = 0;

my $group;
if($mail->subject =~ m/\[([^\[\]]*)\]/i){
    $group = $1;
}

if(!$group){
    $mail->subject =~ m/(Daily [A-Za-z]+)/i;
    $group = $1;
}

my @subject;
if(!$group){
    @subject = split /\s+/, $mail->subject;
    if($subject[0] =~ m/DLL/g){
        return 1;
    }elsif($subject[0] =~ m/File/g){
        $group = "File";
    }elsif( $subject[0] =~ m/C_NSFW/g){
        $group = "C_NSFW";
    }elsif($subject[0] =~ m/Biker/g){
        $group = $subject[0];
    }else{
        $group = "UNDEF";
    }
};


if($group =~ m/^[\ ]+$/){
	return;
}

$group =~ s/ /_/g;
$group =~ s/\'/+/g;
$group =~s/\://g;

my $wo = q{};

if($num_attachments > 0){
    foreach (@$attachments) {
        if ( $_->mime_type =~ m/^image/i || $_->mime_type =~ m/^application/i ){
            unless($_->mime_type =~ m/zip/i){
                unless($_->filename =~ m/LLY/){
                    unless(-d $bilder."/".$group){
                        system("mkdir ".$bilder."/".$group);
                    }
                    $filesizes += $_->size;
                    $images++;
                    my $name = $_->save($bilder."/".$group);
					print "Bild $name abgespeichert.\n";
                }
            }
        }
        elsif ( $_->mime_type =~ m/^video/i ) {
            unless(-d $filme."/".$group){
                system("mkdir ".$filme."/".$group);
            }
            $filesizes += $_->size;
            $movies++;
            my $name = $_->save($filme."/".$group);
			print "Film $name abgespeichert.\n";
        }
    }
}
