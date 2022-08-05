#!/bin/bash
###    
#######

cd ~/bbWag/BoxScores
sed "s/TBR/TB/g;s/WSN/WAS/g;s/SDP/SD/g;s/KCR/KC/g;s/SFG/SF/g" temp455 > tempCBSstyle  

cnter=1
while read -r line;
										       	#grabs opps of Top 8 from past games for DP/err ratio
do

curl --silent https://www.cbssports.com/mlb/teams/$line/$(grep "${line}" 30TeamCodes.txt | awk '{print$4}')/schedule/ | html2text -o temp300
if [[ $(grep -A2 -B23 "$(date -d "1 days ago" | awk '{print$2,$3}')" temp300) ]];then  		
											# if team played yesterday ... LAST 6 SCHEDULES
grep -A2 -B23 "$(date -d "1 days ago" | awk '{print$2,$3}')" temp300 | sed 's/@/#/g' | cut -c 8-22 | grep -v "team" | awk NF | sed 's/^[[:space:]]*//g' | awk '{print$1}' | tr '\n' '@' | sed 's/vs@/vs@@/g;s/#@/#@@/g;s/@vs@@/\nvs/g;s/@#@@/\n#/g;s/@@//g;s/OPP//g;s/@/_/g' | awk -F, 'BEGIN{OFS=FS} {gsub(/_#/,"\n",$1); print}' | sed 's/#/@/g;s/_$//g' | head -n6 | tac > temp${line};cnt=1
 					   else
grep -A2 -B23 "$(date -d "2 days ago" | awk '{print$2,$3}')" temp300 | sed 's/@/#/g' | cut -c 8-22 | grep -v "team" | awk NF | sed 's/^[[:space:]]*//g' | awk '{print$1}' | tr '\n' '@' | sed 's/vs@/vs@@/g;s/#@/#@@/g;s/@vs@@/\nvs/g;s/@#@@/\n#/g;s/@@//g;s/OPP//g;s/@/_/g' | awk -F, 'BEGIN{OFS=FS} {gsub(/_#/,"\n",$1); print}' | sed 's/#/@/g;s/_$//g' | head -n6 | tac > temp${line};cnt=2
fi

sed -i "s/San_Diego/SD/g;s/Kansas_City/KC/g;s/Tampa_Bay/TB/g;s/L\.A\._Angel/LAA/g;s/NY\._Yankees/NYY/;s/NY\.Mets/NYM/g;s/San_Francisco/SF/g;s/Chi\._Cubs/CHC/g;s/Chi\._White_Sox/CWS/g" temp${line}
sed -i -e "/^S/d" temp${line}
rg=7;num=$RANDOM;let "num %= $rg";sleep "${num}"s 	
#												## random times to evade CBS servers

	while read -r linea;
	do
	DaysAgo=$(date +"%Y%m%d" -d "${cnt} days ago")
	qwer=$(echo $linea | sed "s/vs//g");qwert=$(echo $linea | sed "s/@//g")
	
		if [[ $(echo $linea | grep "vs") ]];then 								
#												## HHOOMMEE
	
			url="MLB_${DaysAgo}_$(grep "${qwer}" ~/bbWag/30TeamCodes.txt | awk '{print$7}')@$(grep "${line}" ~/bbWag/30TeamCodes.txt | awk '{print$7}')"
			node ~/bbWag/BoxScores/fetchCBS.js ${url} > ~/bbWag/BoxScores/temp9393 2> /dev/null;html2text ~/bbWag/BoxScores/temp9393 > ~/bbWag/BoxScores/temp999 2> /dev/null 
			grep -m1 -B14 "BATTING" temp999 | sed 's/^...//g' | grep "^[A-Z][a-z]" | awk '{print$1}' | grep -v "HITTERS\|\BATTING\|\-" | sort | uniq > tempPlist 
#												adding pitchers too for DPs
			echo "$(grep -m1 -A7 "PITCHERS" temp999 | awk '{print$1}' | sed "s/^...//g;s/CHERS//g" | awk NF | sort | uniq)" >> tempPlist
	tempDPs=0;temperrors=0
			if [[ $(grep "FIELDING" temp999) ]];then     
#												some games have no DPs or Errors
	
				if [[ $(grep -c "FIELDING" temp999) -ne '4' ]];then
	
				tr '\n' '@' < temp999 | perl -pe "s/(\*\*\*\*\*\*).*(---)//g" 2> /dev/null | tr '@' '\n' > temp403 
#												 deletes narrative
				 grep -A5 "FIELDING" temp403 | grep -m1 -o " [A-Z][a-z].*-\|\ [A-Z][a-z].* " | sed 's/ //g;s/-.*//g' > tempplayer
					if [[ $(grep -Fwf tempplayer tempPlist) ]];then
	
					if [[ $(grep "E -" temp403) ]];then
	
					temperrors=$(grep -A5 "FIELDING" temp999 | grep "E -" | awk '!seen[$0]++' | tr ',' '\n' | wc -l) 
					fi
					if [[ $(grep -A4 "FIELDING" temp403 | grep "\;") ]];then
	
					tempDPs=$(grep -A5 "FIELDING" temp403 | grep "DP -" | awk '!seen[$0]++' | tr ';' '\n' | wc -l)
				else
					tempDPs=1
					fi
					fi
					rm ~/bbWag/BoxScores/temp9393 ~/bbWag/BoxScores/temp999 2> /dev/null
				else 						    
#												 Both teams have FIELDING
				tr '\n' '@' < temp999 | perl -pe "s/(\*\*\*\*\*\*).*(---)//g" 2> /dev/null | perl -pe "s/(FIELDING[^FIELDING]*).*?FIELDING/FIELDING/g" 2> /dev/null | tr '@' '\n' > temp403 					
#												Gets rid of narrative recap AND away team FIELDING sections when both teams have it
					if [[ $(grep "E -" temp403) ]];then
	temperrors=$(grep -A5 "FIELDING" temp403 | grep "E -" | awk '!seen[$0]++' | tr ',' '\n' | wc -l) 
#												when ready single numbers for multi-errors fomr 1 player
					fi
					if [[ $(grep -A4 "FIELDING" temp403 | grep "\;") ]];then
	tempDPs=$(grep -A5 "FIELDING" temp403 | grep "DP -" | awk '!seen[$0]++' | tr ';' '\n' | wc -l)
	else
	tempDPs=1
	fi
				fi
	
					fi
echo ${tempDPs} >> ${line}ratios;sed -i '$s/$/ '"${temperrors}"'/' ${line}ratios;let cnt=cnt+1;rm ~/bbWag/BoxScores/temp9393 ~/bbWag/BoxScores/temp999 2> /dev/null
	 	else 														
#												## AAWWAAYY
		
			url="MLB_${DaysAgo}_$(grep "${line}" ~/bbWag/30TeamCodes.txt | awk '{print$7}')@$(grep "${qwert}" ~/bbWag/30TeamCodes.txt | awk '{print$7}')"
			node ~/bbWag/BoxScores/fetchCBS.js ${url} > temp9393 2> /dev/null;html2text temp9393 > temp999 2> /dev/null
			grep -m1 -A12 "HITTERS" temp999 | awk '{print$1}' | grep -v "HITTERS\|\BATTING\|\-" | sed "s/^...//g" | sort | uniq > tempPlist
			tempDPs=0;temperrors=0
			echo "$(grep -m1 -A7 "PITCHERS" temp999 | awk '{print$1}' | sed "s/^...//g;s/CHERS//g" | awk NF | sort | uniq)" >> tempPlist
			if [[ $(grep "FIELDING" temp999) ]];then     
#												some games have no DPs or Errors
	
				if [[ $(grep -c "FIELDING" temp999) -ne '4' ]];then
	
				tr '\n' '@' < temp999 | perl -pe "s/(\*\*\*\*\*\*).*(---)//g" 2> /dev/null | tr '@' '\n' > temp403 
#												 deletes narrative
				grep -A5 "FIELDING" temp403 | grep -m1 -o " [A-Z][a-z].*-\|\ [A-Z][a-z].* " | sed 's/ //g;s/-.*//g' > tempplayer
					if [[ $(grep -Fwf tempplayer tempPlist) ]];then
	
					if [[ $(grep "E -" temp403) ]];then
	
					temperrors=$(grep -A5 "FIELDING" temp999 | grep "E -" | awk '!seen[$0]++' | tr ',' '\n' | wc -l) 
					fi
					if [[ $(grep -A4 "FIELDING" temp403 | grep "\;") ]];then
	
					tempDPs=$(grep -A5 "FIELDING" temp403 | grep "DP -" | awk '!seen[$0]++' | tr ';' '\n' | wc -l)
				else
					tempDPs=1
					fi
					fi
					rm ~/bbWag/BoxScores/temp9393 ~/bbWag/BoxScores/temp999 2> /dev/null
			else 						    
#												 Both teams have FIELDING
				tr '\n' '@' < temp999 | perl -pe "s/(\*\*\*\*\*\*).*(---)//g" 2> /dev/null | perl -pe "s/(?<=FIELDING).*?\K(FIELDING.{0,90})//g" 2> /dev/null | tr '@' '\n' > temp403 					
#												Gets rid of narrative recap AND away team FIELDING sections when both teams have it
					if [[ $(grep "E -" temp403) ]];then
	temperrors=$(grep -A5 "FIELDING" temp403 | grep "E -" | awk '!seen[$0]++' | tr ',' '\n' | wc -l) 
#												when ready single numbers for multi-errors fomr 1 player
					fi
					if [[ $(grep -A4 "FIELDING" temp403 | grep "\;") ]];then
	tempDPs=$(grep -A5 "FIELDING" temp403 | grep "DP -" | awk '!seen[$0]++' | tr ';' '\n' | wc -l)
	else
	tempDPs=1
					fi
				fi				
					fi
echo ${tempDPs} >> ${line}ratios;sed -i '$s/$/ '"${temperrors}"'/' ${line}ratios;let cnt=cnt+1;rm ~/bbWag/BoxScores/temp9393 ~/bbWag/BoxScores/temp999 2> /dev/null
	fi
	done < temp${line}
tput cup $((${cnter} + 3)) 59;let cnter=cnter+1
awk '{dps+=$1;errs+=$2} END {print FILENAME,dps,errs}' $(ls -t *ratios 2> /dev/null | head -n1)
done < tempCBSstyle
exit
