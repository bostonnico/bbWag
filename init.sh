#!/bin/bash

if [[ -s /etc/os-release || -s /etc/sysconfig/***** ]];then
echo "This package requires a version of BASH to operate. Please consider switching shells, or learning bash first."
exit
fi

if [[ $(type node) ]];then
echo " node installed"
else
	echo "plz install node with root privileges before proceeding "
	exit

fi
if [[ $(type curl) ]];then
	echo "curl installed"
else

	echo "install curl with root privileges before proceeding "
	exit

fi
if [[ $(type tput) ]];then
	echo "tput installed"
else

	echo "install tput with root privileges before proceeding "
	exit
fi
if [[ $(type banner) ]];then
	echo "banner installed"
else
	echo "install banner with root privileges before proceeding "
	exit
fi
echo " Howdy... you're good to go. Configuration file for bbWag, for use in the $(date +"20%y" -d "today") mlb regular season is ready to run...";echo " ";echo " "

tmpRt=$(pwd);echo "Using $tmpRt as the root directory for bbWag"
DIR=$(echo $tmpRt/MLB);chmod 755 ${DIR};echo ${tmpRt} >> mlb.cgf

echo " ";echo "Adding gameViewer.sh call to your .bashrc file, to track pitching changes, and keep your betting record for you. "

echo " " >> .bashrc
echo "if [[ $(pgrep gameViewer.sh) ]];then@@@@@@kPID=$(pgrep gameViewer.sh)@@@kill ${kPID}@@@/home/user/MLB/gameViewer.sh 2> /dev/null &@@@else@@@/home/user/MLB/BETAgameViewer.sh 2> /dev/null &@@@fi@@@/home/user/MLB/gameRecorderKper.sh 2> /dev/null@@@" >> ~/.bashrc;sed -i "s/@@@/\n/g" ~/.bashrc;echo " "

echo "Configuration complete."
chmod 755 ${DIR}/mlb.cgf
exit
