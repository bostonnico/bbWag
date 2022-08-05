#!/bin/bash
#DDEV> needs +1 alt. line support 
#set -x
		pick=$(head -n1 ~/bbWag/gameTemp1.dat | awk '{print$1}' | sed "s/\+//g")
		win=$(head -n4 ~/bbWag/mlb.sh | tail -n1 | awk '{print$12+1,$13,$14}')
		loss=$(head -n4 ~/bbWag/mlb.sh | tail -n1 | awk '{print$12,$13,$14+1}')
		currentRecord=$(cat ~/bbWag/mlb.sh | head -n4 | tail -n1 | awk '{print$12,$13,$14}')

if [[ $(ls -l ~/bbWag/gameTemp1.dat 2> /dev/null | awk '{print$6$7}') == $(date +%b%d -d "yesterday" | perl -pe "s/([A-Z][a-z][a-z])\K0//" 2> /dev/null) ]];then
	cd ~/bbWag
	curl --silent https://plaintextsports.com/mlb/2022/teams/$(grep "$(echo ${pick} | sed "s/\+//g")" ~/bbWag/30TeamCodes.txt | awk '{print$4}') | html2text | tr '\n' ' '| sed 's/\/ /\//g' | grep -oP "$(TZ=America/New_York date +%-m/%d -d "yesterday" | sed "s/\/0/\//g").{0,30}" | head -n1 > tempfinal
	if [[ $(grep "W_" tempfinal) ]];then
                        sed -i "s/${currentRecord}/${win}/g" ~/bbWag/mlb.sh;rm ~/bbWag/tempfinal ~/bbWag/gameTemp1.dat 2> /dev/null;exit
	fi

	if [[ $(grep "@" tempfinal) && $(grep "\+" gameTemp1.dat) ]];then
		if [[ $(grep -oP ".{0,2}-.{0,2}" tempfinal | grep -oP "\d.+" | head -n1 | awk -F'-' '{print$1-$2}') -eq '-1' ]];then 
               sed -i "s/${currentRecord}/${win}/g" ~/bbWag/mlb.sh;rm ~/bbWag/tempfinal ~/bbWag/gameTemp1.dat 2> /dev/null;exit
		fi
	fi

	if [[ $(grep -oP ".{0,2}-.{0,2}" tempfinal | grep -oP "\d.+" | head -n1 | awk -F'-' '{print$2-$1}') -eq '-1' ]];then
               sed -i "s/${currentRecord}/${win}/g" ~/bbWag/mlb.sh;rm ~/bbWag/tempfinal ~/bbWag/gameTemp1.dat 2> /dev/null;exit
	fi

sed -i "s/${currentRecord}/${loss}/g" ~/bbWag/mlb.sh;rm ~/bbWag/tempfinal ~/bbWag/gameTemp1.dat 2> /dev/null
fi
exit	
