#!/bin/bash
###	        
################
printf '%b\n';printf '%b\n'
while read -r line;
do
        if [[ $(echo "$line" | awk '{print $4}') =~ ^[0-9]+$ ]]; then
                newLine=$(echo "$line" | awk '{print $1,$2,$4,$5}');sed -i "s/$line/${newLine}/g" ~/bbWag/CBSscores.html 2>/dev/null
                 ffirstTeam=$(echo "${newLine}" | awk '{print $2}')
                 ssecondTeam=$(echo "${newLine}" | awk '{print $4}')
                 lletterTCode=$(grep "${ffirstTeam}" 30TeamCodes.txt | awk '{print $1}')
                 lletterTCode2=$(grep "${ssecondTeam}" 30TeamCodes.txt | awk '{print $1}')
sed -i "s/"${ffirstTeam}"/"${lletterTCode}"/g" ~/bbWag/MLB/CBSscores.html 2>/dev/null
sed -i "s/"${ssecondTeam}"/"${lletterTCode2}"/g" ~/bbWag/MLB/CBSscores.html 2>/dev/null
else
                 firstTeam=$(echo $line | awk '{print $2}')
                 secondTeam=$(echo $line | awk '{print $4}')
                 letterTCode=$(grep "${firstTeam}" 30TeamCodes.txt | awk '{print $1}')
                 letterTCode2=$(grep "${secondTeam}" 30TeamCodes.txt | awk '{print $1}')
sed -i "s/"${firstTeam}"/"${letterTCode}"/" ~/bbWag/MLB/CBSscores.html 2>/dev/null
sed -i "s/"${secondTeam}"/"${letterTCode2}"/" ~/bbWag/MLB/CBSscores.html 2>/dev/null
        fi
done < ~/bbWag/MLB/copyCBSscores.html;sed -i "s/White_Sox/CWS/g" CBSscores.html
awk NF tonightsMatchups > tonightsMatchups1;mv tonightsMatchups1 tonightsMatchups
tput cup 2 50;echo -e "\t   FIELDING \e[27m DPs / Errs, last \e[7m6\e[27m games ";printf '%b\n'

printf '%b\n';printf '%b\n';printf '%b\n';printf '%b\n';printf '%b\n';
exit
