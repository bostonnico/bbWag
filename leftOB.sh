#!/bin/bash

cstartdate=$(date +"20%y-%m-%d" -d "4 days ago");cenddate=$(date +"20%y-%m-%d" -d "yesterday")
curl --silent "https://www.fangraphs.com/leaders.aspx?pos=all&stats=bat&lg=all&qual=0&type=0&season=2022&month=1000&season1=2022&ind=0&team=0%2Cts&rost=0&age=0&filter=&players=0&startdate=${cstartdate}&enddate=${cenddate}" | html2text > temp98987  	# for hits only last 4
grep '^ 1 ' -A65 ~/bbWag/temp98987 | awk '{print $2,$9}' | grep "[A-Z][A-Z][A-Z]" | head -n30 > temp989877

tput cup 3 0
while read -r line;do

hits=$(grep "${line}" temp989877 | awk '{print$6}')	
walks=$(grep "${line}" Daysback | tac | head -n1 | awk '{print$9}' | awk -F'\.' '{print$1}') 

runs=$(grep "${line}" Daysback | tac | head -n1 | awk '{print$6 }')         
echo $(($hits+$walks-$runs)) 
echo " "
done < ~/bbWag/Top7clean

exit
