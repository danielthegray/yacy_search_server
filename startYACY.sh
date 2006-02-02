#!/bin/sh
if [ $UID -eq 0 ]
then
	echo
	echo "For security reasons, you should not run this as root!"
	echo
else
	cd `dirname $0`
	
	#get javastart args
	java_args=""
	if [ -f DATA/SETTINGS/httpProxy.conf ]
	then
		for i in $(grep javastart DATA/SETTINGS/httpProxy.conf);
		do  i="${i#javastart_*=}";java_args=-$i" "$java_args;
		done
	fi
	
	# generating the proper classpath
	CLASSPATH=""
	for N in lib/*.jar; do CLASSPATH="$CLASSPATH$N:"; done	
	for N in libx/*.jar; do CLASSPATH="$CLASSPATH$N:"; done
	
	if [ x$1 == x-d ] #debug
	then
		java $java_args -classpath classes:$CLASSPATH yacy
		exit 0
	elif [ x$1 == x-l ] #logging
	then
		nohup java $java_args -classpath classes:htroot:$CLASSPATH yacy >> yacy.log &
	else
		nohup java $java_args -classpath classes:htroot:$CLASSPATH yacy > /dev/null &
#		nohup java -Xms160m -Xmx160m -classpath classes:htroot:$CLASSPATH yacy > /dev/null &
	fi
	echo "YaCy started as daemon process. View it's activity in DATA/LOG/yacy00.log"
	echo "To stop YaCy, please execute stopYACY.sh and wait some seconds"
	echo "To administrate YaCy, start your web browser and open http://localhost:8080"
fi
