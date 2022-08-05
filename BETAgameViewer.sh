#!/bin/bash
trap 'rm ~/bbWag/pitchingTonight 2> /dev/null' EXIT 		
  												 # Starts w/ BASHRC
pid=$(pgrep ~/bbWag/gameViewer.sh | tail -n1);kill ${pid} 2> /dev/null

if [[ -s ~/bbWag/gameTemp.dat ]];then 
												 # if DAT file hasn't been deleted by this script yet, launch ballgame when it comes on
teamCode=$(grep "[A-Z][A-Z][A-Z]" ~/bbWag/gameTemp.dat | head -n1 | awk '{print$1}' | sed "s/\+//g") 
#												 user entered
htmlAdjustedTC=$(grep "${teamCode}" ~/bbWag/30TeamCodes.txt | awk '{print$4}') 
#												 4th column of code file with HTML-ready team-codes

firstPitch=$(tail -n1 ~/bbWag/gameTemp.dat | awk -F':' '{print$1-1":"$2}' | sed "s/[A-Z]//g" | awk -F':' '$1>=8{print$1+12":"$2};$1<=7{print"1"$1+2":"$2}')
aHoraSegundos=$(date +%s)
firstPitchSegundos=$(date -d"${firstPitch}" +%s)  	
#												 this is the format to do stuff with DATE
tillGame=$((firstPitchSegundos-aHoraSegundos))

myStarter=$(head -n1 ~/bbWag/gameTemp.dat | awk '{print$2}')
oppStarter=$(head -n1 ~/bbWag/gameTemp.dat | awk '{print$3}')   		
#												 manually enter in LAST NAMES of starters, yours, then opposing

curl --silent "https://www.baseball-reference.com/previews/index.shtml" | html2text | grep -A110 "Probable Pit" | grep "^[A-Z][A-Z][A-Z]" | sort | uniq | awk -F'_' '{print$2}' > ~/bbWag/pitchingTonight

      if [[ $(grep "${myStarter}" ~/bbWag/pitchingTonight) && $(grep "${oppStarter}" ~/bbWag/pitchingTonight) ]];then
	rm ~/bbWag/pitchingTonight 2> /dev/null;checkWhileWaiting=$(($tillGame / 2));sleep ${checkWhileWaiting}s 2> /dev/null 
#												 in case y'all keep the window open for long periods, rerun above
  	   curl --silent "https://www.baseball-reference.com/previews/index.shtml" | html2text | grep -A110 "Probable Pit" | grep "^[A-Z][A-Z][A-Z]" | sort | uniq | awk -F'_' '{print$2}' > ~/bbWag/pitchingTonight
      	   if [[ $(grep "${myStarter}" ~/bbWag/pitchingTonight) && $(grep "${oppStarter}" ~/bbWag/pitchingTonight) ]];then
		rm ~/bbWag/pitchingTonight 2> /dev/null;sleep ${tillGame}s 2> /dev/null;mv ~/bbWag/gameTemp.dat ~/bbWag/gameTemp1.dat 2> /dev/null
		echo " FIRST PITCH - MONEY ON THE LINE"
		
		# 		BETA FEATURE BELOW / LAUNCH THE GAME TO WATCH YOURSELF AT FIRST PITCH
		#/mnt/c/Program\ Files/Firefox\ Developer\ Edition/firefox.exe --kiosk http://hd.worldcupfootball.me/mlb/"${htmlAdjustedTC}"-live-stream 2>/dev/null &
	else
	tput cup 18 64;echo "NO ACTION - NO BET PLACED"
	tput cup 19 64;echo "NO ACTION - NO BET PLACED"
	tput cup 20 64;echo "NO ACTION - NO BET PLACED";rm ~/bbWag/pitchingTonight 2> /dev/null 
	   fi
else
	tput cup 18 64;echo "NO ACTION - NO BET PLACED"
	tput cup 19 64;echo "NO ACTION - NO BET PLACED"
	tput cup 20 64;echo "NO ACTION - NO BET PLACED";rm ~/bbWag/pitchingTonight 2> /dev/null 
	   fi
exit
fi
exit
