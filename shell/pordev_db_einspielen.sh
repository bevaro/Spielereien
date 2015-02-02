#!/bin/bash

MYSQLDUMP_BIN=/usr/bin/mysqldump

#sluvver

MYSQLDUMP_OPT='-u voyager -pbumbarash -h127.0.0.1 -P3307'

TEMPDIR=/tmp

#DATABASES='BestellDB PDB2'
READ_DB=$1
WRITE_DB=$2

REMOTE_SSH_USER_HOST=pordev
 
$MYSQLDUMP_BIN $MYSQLDUMP_OPT $READ_DB > $TEMPDIR/$READ_DB.sql
scp $TEMPDIR/$READ_DB.sql $REMOTE_SSH_USER_HOST:/tmp/
rm $TEMPDIR/$READ_DB.sql
ssh $REMOTE_SSH_USER_HOST "mysql -u root $WRITE_DB < /tmp/$READ_DB.sql"
ssh $REMOTE_SSH_USER_HOST "rm /tmp/$READ_DB.sql"
