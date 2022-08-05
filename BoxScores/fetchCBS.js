
const JSON = require('JSON');const FS = require('fs');const streamToString = require('stream-to-string');const buffer = Buffer.alloc(1024);
const fetch = (...args) => import('node-fetch').then(({default: fetch}) => fetch(...args));
var URL = "https://www.cbssports.com/mlb/gametracker/boxscore/"
var game = process.argv[2].toString('utf8');
var FINAL = URL.concat(game);
(async() => {

const CBSpayLoad = await fetch("" + FINAL + "", {
    "headers": {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:99.0) Gecko/20100101 Firefox/99.0",
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
        "Accept-Language": "en-US,en;q=0.5",
        "Upgrade-Insecure-Requests": "1",
	"Referer": "https://www.cbssports.com/mlb/scoreboard/",
        "Sec-Fetch-Dest": "document",
        "Sec-Fetch-Mode": "navigate",
        "Sec-Fetch-Site": "none",
        "Sec-Fetch-User": "?1",
        "Sec-GPC": "1"
    },
    "method": "GET",
    "mode": "cors"
}).then(response => response.body)
.then(res => res.on('readable', () => {
        let chunk;
        while (null !== (chunk = res.read())) {
            var buffer = chunk.toString();
            console.log(buffer);
        }
    }))
.catch(err => console.log(err));
})()





