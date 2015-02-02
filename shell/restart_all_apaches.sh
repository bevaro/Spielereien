#!/bin/sh

PS='ps -fu httpd | grep httpd.conf'
SSH='ssh -l strato'
START_APACHE='sudo /etc/init.d/apache_dyn start'
STOP_APACHE='sudo /etc/init.d/apache_dyn stop'
WAIT=15

no_more_processes() {
    $SSH $1 $PS >> /dev/null
    until [ $? != 0 ]
    do
        echo "apaches laufen noch."
        sleep 2
        $SSH $1 $PS >> /dev/null
    done
}

stop_apache() {
    $SSH $1 $STOP_APACHE 
}

start_apache() {
    $SSH $1 $START_APACHE
}


for machine in kirk moe gil homer
do
    echo "$machine"
    stop_apache $machine
    no_more_processes $machine
    start_apache $machine
    echo "Going to sleep for $WAIT seconds"
    sleep $WAIT
    echo
done
