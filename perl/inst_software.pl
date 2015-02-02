#!/usr/bin/perl
#######################################################################
# Created By: Bryce Verdier
# on 4/14/10
#
# Function: grab all installed packages, find their exact
# versions, and display them
# NOTE: FOR USE ON DEBIAN BASED MACHINES
#######################################################################
my $temp_pack;
my $temp_ver;
my $returned_version;
my %pack_hash;
my @return = `dpkg --get-selections`;

foreach (@return)
{
    $_ =~ m/(\S*)[ \t].*/i;
    $temp_pack = $1;
    $returned_version = `dpkg -s $temp_pack`;
    $returned_version =~ m/Version: (.*)/i;
    $temp_ver = $1;
    $pack_hash{$temp_pack} = $temp_ver;
}
       
while((my $key, my $value) = each(%pack_hash))
{
    print "$key : $value\n";
}
