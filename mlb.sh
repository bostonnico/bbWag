#!/bin/bash
## 		`     ` `            										
## 		``   `` `       				      W - L 			
## 		` ` ` ` `       b    ___ season		RECORD   of  0 - 0
## 		`     ` ``````` 

if [[ ! -f ~/MLB/mlb.cgf ]];then
echo "Configuration file not installed. please run "./init.sh" in the home directory first, to set your config variables "
exit
fi

DIR=$(head -n1 mlb.cfg)
trap "rm FIP* scores* temp* 2>/dev/null;exit" 2;clear;cd ${DIR}/MLB

if [[ $(TZ=America/New_York date +%-H) -gt '20' || $(TZ=America/New_York date +%-H) -lt '8' ]];then
tput cup 20 46;echo " Please note script is intended to function correctly before the first pitch";tput cup 21 36;echo "of the first game of the day.";sleep 2s;clear;tput cup 20 46;echo "Otherwise, statistics will most likely not display properly as most stat sites have not yet been updated. -NL"
fi
today=$(date +"20%y-%m-%d" -d "today");pitching=$(date +"20%y-%m-%d" -d "14 days ago");yesterday1=$(date +"20%y-%m-%d" -d "yesterday");yesterday=$(date +"20%y%m%d" -d "yesterday");counter=1

echo "How many days back would you like to set your hitting statistics function to? ( anywhere from 3 to 5 recommended )"
read back
selectdaysback=$(echo $back})

echo " URL to check your betting lines, and potentially place a wager on a game: ${URL}"
curl --silent https://plaintextsports.com/ | html2text | grep -A30 'Major League Baseball' | sed 1,2d | head -n15 | grep "^ +" | sed "s/SD/SDP/g;s/SF/SFG/g;s/WSH/WSN/g;s/TB/TBR/g;s/KC/KCR/g;s/__/_/g" > tonightTimes;awk -F '\|' '{print $4,$6}' tonightTimes | awk -F '\_' '{print$2,$5}' | awk NF > tonightsMatchups

Team_Hitting () {
printf '%b\n'
cstartdate=$(date +"20%y-%m-%d" -d "$selectdaysback days ago");cenddate=$(date +"20%y-%m-%d" -d "yesterday");spacee="     "
curl --silent "https://www.fangraphs.com/leaders.aspx?pos=all&stats=bat&lg=all&qual=0&type=8&season=$(date +"20%y" -d "today")&month=1000&season1=$(date +"20%y" -d "today")&ind=0&team=0%2Cts&rost=0&age=0&filter=&p%20%20%20%20layers=0&startdate=$cstartdate&enddate=$cenddate&sort=14%2Cd" \
	--compressed -k | html2text -o Daysback;cp Daysback $(pwd)/logicPicker;echo -e "Hw/R\tOPS\tABs,SBs (last \e[7m4\e[27m gms)";printf '%b\n' 
	grep '^ 1 ' -A20 Daysback | awk '{print $2,$4,$8,$14,$15}' | grep -v "^ " | grep -v "^[0-9]" | awk '{print" ",$2,$1,$4+$5,$3}' | sort -n | sed G | sed "16,16s/^/&__^/g" > temp1;head -n16 temp1;tail -n8 temp1 > temp44    
										# ^ highest plate apps. in my group

awk -v topABs="`cat temp1 | head -n16 | awk '{print$4}' | sort | awk NF | tac | head -n1`" 'topABs-$4>=30{print}' <<< $(cat temp44)
										#noteworthy teams outside top8
awk '{print $2}' temp1 | sort -V | uniq temp1 > Top7;grep -o '[A-Z]*[A-Z]*[A-Z]*' Top7 | awk NF > Top7clean;head -n8 Top7clean > ${DIR}/MLB/BoxScores/temp455
${DIR}/MLB/leftOB.sh 			
										# adjusted OPS (left on base)
rm temp*; rm Daysback
}

Top30Probables () { 										
										#NOTE: 7/22, changed min. innings 10 > 11
curl --silent "https://www.fangraphs.com/leaders.aspx?pos=all&stats=sta&lg=all&qual=11&type=8&season=$(date +"20%y" -d "today")&month=2&season1=$(date +"20%y" -d "today")&ind=0&team=0&rost=0&age=0&filter=&players=0&startdate=$(date +"20%y" -d "today")-01-01&enddate=$(date +"20%y" -d "today")-12-31&sort=19,a" -k | html2text -o temp
curl --silent "https://www.fangraphs.com/leaders.aspx?pos=all&stats=sta&lg=all&qual=0&type=8&season=$(date +"20%y" -d "today")&month=2&season1=$(date +"20%y" -d "today")&ind=0&team=0&rost=0&age=0&filter=&players=0&startdate=$(date +"20%y" -d "today")-01-01&enddate=$(date +"20%y" -d "today")-12-31&sort=19,a&page=1_170" -k | html2text -o tempWhole;cp tempWhole $(pwd)/logicPicker 
										#whole league




grep '^ 1 ' -A50 temp | tr '\n' ' ' | sed "s/[0-9] [A-Z]/&\n/g" | perl -pe "s/^\w.*_//g;s/\\./-/g" 2> /dev/null | cut -c1-10,19-33,105-  | sed 1d | sed "s/-//g;s/ [0-9] //g" | tr '\n' '@' | perl -pe "s/([0-9][0-9][0-9]\s)/ \1/g" 2> /dev/null | tr '@' '\n' | awk '$3<193{print;next}' | grep -oP "[A-Z][a-z].*?\s" > FIP30



curl --silent "https://www.baseball-reference.com/previews/index.shtml" | html2text -o temp21;grep -A110 "Probable Pit" temp21 | grep "^[A-Z][A-Z][A-Z]" | sort | uniq > preProbables;sed -i "s/_/ /g" preProbables;cp preProbables tempprobs 
										# outputs last-names, top pitchers, pitched at least 10 innings last 14 days

while read -r line;do 								
										# This script excludes double-headers;too many variables to bet on IMO
	doubleHeader=$(echo $line | awk '{print$1}')
	if [[ $(grep -c "${doubleHeader}" preProbables) -eq '2' ]];then
		sed -i "/"${doubleHeader}"/d" preProbables
	fi
done < tempprobs

cat preProbables | awk '{print$3}' > tempForFIP;fgrep -wf tempForFIP FIP30 > tempForFIPP;tr ' ' '\n' < tempWhole > tempWhole1

while read -r line;do 											
	colCount=$(grep -B1 "${line}" temp | head -n1 | tr ' ' '\n' | awk NF | wc -l)
	Team1=$(grep "${line}" preProbables | awk '{print$1}');Team2=$(grep "${Team1}" tonightsMatchups | sed "s/"${Team1}"//g;s/ //g" 2> /dev/null | awk NF)
	NameOpp1=$(grep "${Team2}" preProbables | awk '{print$3}');oppStarterFIP=$(grep -B1 "${NameOpp1}" tempWhole | awk '{print$18}' | tail -n2 | awk NF)

	   if [[ ${colCount} == '20' ]];then
		   myStarterFIP=$(grep -B1 "${line}" temp | head -n2 | awk '{print$18}' | awk NF)
		else
	 	    myStarterFIP=$(grep -B1 "${line}" temp | head -n2 | awk '{print$19}' | awk NF)
	   fi
	echo "${myStarterFIP}" >> temp30

         	if [[ $(grep -c "${NameOpp1}" tempWhole1) -gt '1' ]];then 				
										# look up manually in tempWhole1; repeat names     
echo "(opp."${oppStarterFIP}" ${NameOpp}CHECK)" >> temp30
else
echo "(opp."${oppStarterFIP}" ${NameOpp})" >> temp30
fi

	if [[ $(grep -c "${line}" FIP30) -gt '1' ]];then 				
										# look up manually in tempWhole1; repeat names
echo "${line}CHECK" >> temp30
else 
echo "${line}" >> temp30
	fi
echo "${Team1}" >> temp30

done < tempForFIPP

grep -o "[A-Z][A-Z][A-Z]" temp30 > tempTeamListYscores
tput cup 26 78;echo -e "Field-Independent Pitching (last \e[7m3\e[27m starts, more or less)";cat temp30 | tr '\n' ' '
}

Inclement_Weather () {
	echo " "
for (( i=0;i<=6;i++))
do                                                                                                          
echo -en "**** Watch out for weather issues below concering our games" 
sleep 0.4s;                                                                                                 
echo -en "\033[1A";echo -en "                                                            \n"
sleep 0.2s;                                                                                                 
done                                                                                                        
teamCode1=$(cat temp4 | head -n1);teamCode2=$(cat temp4 | head -n2);teamCode3=$(cat temp4 | head -n3)       
paste temp1 | column -s $'\t\t\t' -t | head -n -2 > temp5												
grep -E --color "|${teamCode1} |${teamCode2} |${teamCode3} $" temp5					    
}                                                                                                           

Sunny_Skies () {                                                                                            
tput cup 46 28;banner "Sunny";banner "Skies"                                         
}                                                                                                           

Team_Hitting  										
										# MAIN function calls
Top30Probables
${DIR}/MLB/BoxScores/ratios.sh

curl --silent https://www.cbssports.com/mlb/scoreboard/${yesterday}/ | html2text | grep -A1 'team_' | grep -v '\*' | tr '\n' '@' | sed 's/--@--/--@/g' | tr '@' '\n' | awk NF > htmlFix.html  
										#html fix/add-on/ads removal
<htmlFix.html LC_ALL=C sed 's/[^\o0-\o177]//g;s/[0-9]-[0-9]$//g;s/\[team_logo]//g;s/  / /g;s/[0-9] [0-9]$//g;s/1$//g;0~3d' | tr '\n' '@' | sed 's/@/\n/4;P;D' | sed 's/@//g' | sed -r 's/\s+/ /g' | sed 's/^.//g;s/.$//g' > CBSscores.html;cp CBSscores.html copyCBSscores.html;tput cup 0 56
${DIR}/MLB/teamCODEConverter.sh 
										#Codes for below to work, and F.D. loop
tput cup 30 3

echo "$spacee Top-7 teams' 1-run games yesterday"
while read -r line;do
		echo $line | grep -P '.{0,2} [A-Z][A-Z][A-Z]' | awk '{$5="";print}' > tempScores
			if [[ $(awk '{print $1-$3}' tempScores) == '1' || $(awk '{print $1-$3}' tempScores) == '-1' ]];then
					while read -r teamCode;do
					grep -E --color "$teamCode" tempScores
							done < Top7clean
					fi
					done < CBSscores.html
row=$(${DIR}/MLB/srnPos.sh | head -n1 | awk '{print $1-2}');colu=$(${DIR}/MLB/srnPos.sh | tail -n1 | awk '{print $1+60}');tput cup ${row} ${colu};echo "$spacee .. .  .   . and relevant final scores.";printf '%b\n';sleep .82s
													
										#SCREEN POS script for columized output below

cnter=25;head -n8 Top7clean > temptop7cleanedup
while read -r linea;do  											
										# Relevant SCORES from yesterday
	t1=$(echo $linea | awk '{print$2}');t2=$(echo $linea | awk '{print$4}')
	if [[ $(grep "${t1}" temptop7cleanedup) || $(grep "${t1}" tempTeamListYscores) ]];then
tput cup $((${cnter} + 3)) 62;let cnter=cnter+1					
echo $linea | grep -E --color "${t1}" 
else
	if [[ $(grep "${t2}" temptop7cleanedup) || $(grep "${t2}" tempTeamListYscores) ]];then
tput cup $((${cnter} + 3)) 62;let cnter=cnter+1					
echo $linea | grep -E --color "${t2}" 
	fi
fi
		    done < CBSscores.html

row=$(${DIR}/MLB/srnPos.sh | head -n1 | awk '{print $1+4}');colu=$(${DIR}/MLB/srnPos.sh | tail -n1);tput cup ${row} ${colu}
												        
										#Today's weather forecast with relevant Teams highlighted 
curl --silent "https://rotogrinders.com/weather/mlb" | html2text -o temp
awk '/MLB Forecast/,/Tweets/' temp > temp1;grep -o '[A-Z]*[A-Z]*[A-Z]* ' temp1 > temp2;grep -o '[A-Z]*[A-Z]*[A-Z]*' Top7 > temp3 
grep -Fwf temp3 temp2 | awk NF > temp4;grep -Fwf temp3 temp2 > temp8

if [[ $? -eq 0 ]];then                                                                                                           
 awk '/MLB Forecast/,/Tweets/' temp > temp1;Inclement_Weather;printf '%b\n';printf '%b\n';printf '%b\n'
 else
	 Sunny_Skies                                                                                                                
 fi                                                                                                                              
 tput cup ${row} ${colu};echo " ";echo "Input your pick for today. SYNTAX: 3-letter team code / alt-line(op.) / your pitcher / opp. pitcher i.e. : [PHI+ Verlander Kluber]";echo "otherwise enter 'No' for no to skip"
read -s launch
if [[ $launch == "No" ]];then
rm pr* list* fip* FIP* temp* *.html Top7* tonight* scores* 2>/dev/null;rm ${DIR}/MLB/BoxScores/temp* 2> /dev/null;rm ${DIR}/MLB/BoxScores/*ratios 2> /dev/null
exit
fi
firstPitch=$(grep "$(echo $launch | head -n1 | grep -o "^...")" tonightTimes | awk -F'|' '{print$2}' | sed 's/_//g')
echo "${launch}" >> gameTemp.dat;echo "${firstPitch}" >> gameTemp.dat
tput cup ${row} 28;echo "auto-player set to start for the first-pitch @ $spacee ${firstPitch}";echo "Reboot your Terminal to initiate. Enjoy the ballgame!"
rm ${DIR}/MLB/BoxScores/temp* 2> /dev/null;rm ${DIR}/MLB/BoxScores/*ratios 2> /dev/null;rm pr* list* fip* FIP* temp* *.html Top7* tonight* scores* 2>/dev/null
exit
