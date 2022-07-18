                                      MLB Regular-Season Stat Guide for Wagers                                                             


 Inspired by a Reddit user's statistcal model from years ago, this command-line betting tool
 scrapes MLB data from publicly availalbe source, for the most important advanced baseball metrics
 (according to me) you could use to assist in selecting a team to pick to win a ballgame. In order
 of importance, those would be:
              1. Pitching (fip, differentials between starters)
                 2. TEAM Hitting (top-8 hitting teams league-wide, last 4 days, per OPS)
                    3. Fielding (double-plays / error ratios, roughly last 6 days, or, 1 pitching rotation)
                       4. then simply, yesterday's scores.

 Alongside the above are a few complementary stats, which give the user a better sense of a team's
 performance on the field. This packages comes with a NO ACTION alert as well for pitching changes,
 which can come in handy                                                                                                                      


### requirements:

*GUI browser (Firefox recommended; VPN recommended)
*sportsbook account (if putting money down / enter account in the configuration file)
*Linux distro running BASH w/ git installed

### install:
  git clone bostonnico/
  Fill out "mlb.config"  in root folder

### run:

    ./mlb.sh

   (the script will zip through the primary hitting/pitching stats, then slows down for the defensive stats. A "CHECK" next to pitcher,
   means there are more than one pitchers listed under that name. An opposing pitcher left blank means they have no recent stats; could be an
   injury or recently brought up, et cetera)

    This packages comes with a game launcher, if you watch games online. Enter your favorite sight in the configuration file as well.

    After analzying all the data (4-6 minutes on my system), a prompt asks you to enter your pick's team-code to keep track of your picks'                       win-losses record. Enter this, along with the last names of the starting pitchers, your pitcher first, all on one line:
                        syntax: ATL Fredde Wainright
                    
    The script's built-in timer will launch your game at first-pitch.. Grab some sunflower seeds, a beverage, and enjoy your game!
