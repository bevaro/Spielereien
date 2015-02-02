#!/usr/bin/perl

my @dir = ('0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f','g','h');

for(my $i = 0; $i < @dir; $i++){
	for(my $j = 0; $j < @dir; $j++){
		system("mkdir $dir[$i]$dir[$j]");
	}
}
