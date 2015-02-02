#!/usr/bin/perl
use strict;
use CGI qw/:standard/;
use File::Find;
print header,
start_html,
h1("Perl Environment: $ENV{SERVER_NAME}"),
p("Perl Version: $]"),
p("CGI.pm Version: $CGI::VERSION"),
p("Library Path (\@INC):"),
ul(li([@INC])),
p('Modules:');
foreach my $dir (@INC) {
my @mods;
find(sub { push @mods, $File::Find::name if /\.pm$/ }, $dir);
my @mods2 = grep { !/_vti_cnf/ } @mods;
print ul(li("$dir"), ul(li([sort @mods2])));
}

