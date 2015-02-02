#!/usr/bin/perl
use Mail::POP3Client;
use Data::Dumper;

print "In Account einloggen.\n";

my $pop3c = new Mail::POP3Client(
    USER        => "[MAILADRESS]",
    PASSWORD    => "[PASSWORD]",
    HOST        => "pop.mail.yahoo.de",
    USESSL   => true,);

#my $pop3c = new Mail::POP3Client(
#     USER        => "sanextu\@yahoo.de",
#     PASSWORD    => "Sinner66",
#     HOST        => "pop.mail.yahoo.de",
#     USESSL   => true,);

    
print "Anzahl herrunter zu ladener Mails: " . $pop3c->Count() ."\n";

for( $i = 1; $i <= $pop3c->Count(); $i++ ) {
	print "\nMail Nr $i holen.\n";
    open $MF, "|/home/robin/Privat/up57_repo/mailfilter.pl";
    $pop3c->RetrieveToFile( $MF, $i );
    print "Lösche Mail nr. $i\n";
    $pop3c->Delete( $i );
}

$pop3c->Close();
