                                      MLB Regular-Season Stat Guide for Wagers                                                             


 This app is inspired by a Reddit user's statistcal model from years ago, this command-line betting tool
 scrapes MLB data from publicly availalbe source, for the most important advanced baseball metrics
 (according to me) you could use to assist in selecting a team to pick to win a ballgame. In order
 of importance, those would be:
 
              1. Pitching (fip, differentials between starters)
              
                 2. TEAM Hitting (top-8 hitting teams league-wide, last 4 days, per OPS)
                 
                    3. Fielding (double-plays / error ratios, roughly last 6 days, or, 1 pitching rotation)
                    
                       4. then simply, yesterday's scores.
                       

 Alongside the above are a few complementary stats, which give the user a better sense of a team's
 performance on the field. This packages comes with a NO ACTION alert as well for pitching changes,
 which really comes in handy after a lot of time spent selecting your pick for the day.                                                                                                                      

### requirements:

-Debian 10 or higher (will run, I'm sure, w/ other bash-based distrubitions of linux w/ a few tweaks)

    1. The real distro /or
    
    2. WSM->Debian, linux through windows now?!! works like a charm!
            https://docs.microsoft.com/en-us/windows/wsl/install
            
-git (sudo apt install git)

-node 
(sudo apt install node;npm install node-fetch;npm install stream-to-string;npm install JSON;npm install fs)

### install:
 - git clone https://github.com/bostonnico/bbWag.git
  
 - ./bbWag/init.sh
  
### run:

    ./mlb.sh

   (the pack of scripts zips through the primary hitting/pitching stats, then scrapes for defensive stats. A "CHECK" next to pitcher,
   means there are more than one pitchers w/ same last name. An opposing pitcher left blank means they have no recent stats; could be an
   injury or recently brought up, et cetera)

    After analzying all the data (4-6 minutes on my system), a prompt asks you to enter your pick's team-code to keep track of your picks'                       win-losses record. Enter this, along with the last names of the starting pitchers, your pitcher first, all on one line:
                        syntax: ATL Fredde Wainright
                        or: BOS+ Clemens Johnson
                    
    Grab some sunflower seeds, a beverage of your choosing, and enjoy the game!
