#!/usr/bin/perl
use Mail::IMAPClient;
use Data::Dumper;

print "In Account einloggen.\n";

my $imap = new Mail::IMAPClient(
    User        => "[MAILADRESS]",
    Password    => "[PASSWORD]",
    Server        => "pop.googlemail.com",
    Ssl   => 1,);
   

$imap->select('INBOX');
my @mails = ($imap->unseen(), $imap->seen());

print "Anzahl herrunter zu ladener Mails: ". $imap->message_count('INBOX') . "\n";

foreach my $id (@mails) {
    print "\nMail Nr $id holen.\n";
    open $MF, "|/home/robin/Privat/up57_repo/mailfilter.pl";
    $imap->message_to_file($MF,$id);
}

$imap->delete_message(\@mails);
$imap->logout;


print "In den Zwischenaccount einloggen\n";

my $pop3c2 = new Mail::IMAPClient(
    User        => "[MAILADDRESS]",
    Password    => "[PASSWORD]",
    Server        => "pop.googlemail.com",
    Ssl   => 1,);

$pop3c2->select('INBOX');
print "Anzahl zu loeschender Mails: " . $pop3c2->message_count('INBOX') ."\n";

my @mails2 = ($pop3c2->unseen(), $pop3c2->seen());

$pop3c2->delete_message(\@mails2);
print "MAILS gelöscht\n";

$pop3c2->logout;
