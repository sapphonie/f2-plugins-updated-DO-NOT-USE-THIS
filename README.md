Fixes for various tf2 comp plugins, [originally made by F2](https://www.teamfortress.tv/13598/medicstats-sourcemod-plugin/)

## Fixes:

#### general fixes

* included newest curl extension in repository because it's annoyingly hard to find
* cleaned up in general, converted tabs to spaces, removed xtra whitespace (will likely be restyling in the the future for better readability)
* updated updater updatefiles to the ones in this github
* updated to latest sourcemod syntax
* updated stocks/incs to most recent versions
* compiled on latest sourcemod

#### logstf:
~~* Fixed logstf cutting off server hostname for no apparent reason~~ Reverted
* Added 1 character to max hostname length, until such time as zooob allows longer titles on logs.tf
* Removed deprecated descriptors for cvars (FCVAR_PLUGIN)

###### todo: replace morecolors.inc with [color-literals.inc](https://github.com/nosoop/stocksoup/blob/master/color_literals.inc) for less of a memory footprint on servers

##### medicstats:
* fixed log spam when picking up healthpacks
* stv stats now print w/colors
* new unique stvstat print if a medic drops with 100% uber

#### supstats2:
* fixed log spam when picking up healthpacks
* (hopefully) fixed 'unknown medigun' error in logs

###### todo: add logging airshots for classes other than soldier and demo

#### fixstvslot:
* actually made the plugin work lol
* plugin now forcibly changes level after 10 seconds if stv is turned on (from off state)
* added checks to prevent conflicts with other plugins
* forked off [rglqol](https://github.com/stephanieLGBT/rgl-server-resources)

#### waitforstv:
* actually made the plugin work lol
* No longer forcibly changes level
* now prints in chat on game end and when STV is done broadcasting
* warns user before changing level with active stv broadcast
* unloads plugins that force map changes if not unloaded
* forked off [rglqol](https://github.com/stephanieLGBT/rgl-server-resources)

#### restorescore:
* now zeros damage at start of teamplay start (ie a game starts), this prevents soapdm dmg from showing up on scoreboard toggle

##### more coming soon

## Installation:
* clone repository
* drag folders into your `/tf/addons/sourcemod/` directory

## Known bugs:
* i don't know. i have only done light testing, but so far things seem fine
