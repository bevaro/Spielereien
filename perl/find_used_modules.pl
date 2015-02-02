#!/usr/bin/perl

use File::Find;
use File::Spec::Functions qw(splitdir);
use Module::Info;
use CPANPLUS::Backend;
use Data::Dumper;
use lib "/home/robin/RZG/Entwicklung/Ordering/Ordering-WFC/lib";
my $modules;
my $pfad = $ARGV[0];
my $cpanplus = CPANPLUS::Backend->new();

if ($pfad) {
    my @path = split( /\//, $pfad );
    my $zaehler = 0;
    my %dir_cut;
    foreach (@path) {
        $dir_cut{$_} = 1;
    }
    my $hash = {};
    find( \&make_hash, $pfad );

    sub make_hash() {
        return if $_ eq '.' or $_ eq '..';
        my $cursor = $hash;
        for ( splitdir $File::Find::dir) {
            next if $dir_cut{$_};
            $cursor = $cursor->{$_} ||= {};   # for splitdir $File::Find::dir;
        }
        ### only Perlfiles count
        if (       $_ =~ m/\.pm$/
                || $_ =~ m/\.pl$/
                || $_ =~ m/\.lib$/
            )
        {
            open $FILE, $_;
            while(<$FILE>){
                if($_ =~ /^\s*use ([A-Za-z0-9_\:]*)/){
                    if($1 !~ /Ordering/ && $1 !~ /Customer/
                       && $1 !~ /DB2/ && $1 !~ /Strato/
                       && $1 !~ /Apache/ && $1 !~ /Bestell/
                       && $1 !~ /strict/ && $1 !~ /warnings/ 
                       && $1 !~ /vars/ && $1 !~ /EPages/
                       && $1 !~ /Fcntl/ && $1 !~ /TCom/
                       && $1 !~ /Whois/ && $1 !~ /constant/
                       && $1 !~ /Data::Dumper/ && $1 !~ /NDBM_File/
                       && $1 !~ /lib/ && $1 !~ /shop_/
                       && $1 !~ /Carp/ && $1 !~ /utf8/
                       && $1 !~ /DomainChecker/ && $1 !~ /Application/){
                        $modules->{$1}++;
                    }
                }
            }
            close($FILE);
 			-d $_
            	? $cursor->{$name} = {}
				: push @{ $cursor->{$name} }, $_;
		}
    }    ### End Function
    foreach(keys %{$modules}){
        print "INSTALLIEREN VON $_ :\n";
        $cpanplus->install(modules => [ $_ ]);
    }
}
