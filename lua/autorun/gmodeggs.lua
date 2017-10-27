
--[[-----------------------------------------------------------------------//
* 
* GModEggs
* Chat-based easter eggs system for Garry's Mod
*
* Created by bamq - https://steamcommunity.com/id/bamq
* 27 October 2017
* GitHub: https://github.com/bamq/GModEggs
*
* Addon features:
* - Typing specific phrases in chat will trigger the matching easter egg to
* be discovered. If enabled, PointShop points will be awarded.
* - Player data is stored on the server in each player's own text file. This
* file is created in garrysmod\data\gmodeggs\playerdata when the player
* discovers an easter egg. The name of the text file will be the player's
* Steam Community ID (SteamID64)
* Using the "!myeggs" command, a player may request their list of discovered
* easter eggs. The data is sent from the server to the player and is
* displayed in a Derma menu.
* - There are various configuration options available. These are located in
* the "sh_eggs_config.lua" file.
*
//-----------------------------------------------------------------------]]--

--[[-----------------------------------------------------------------------//
*
* GModEggs
* 
* gmodeggs.lua
* The autorun script for the addon.
* Sets up stuff before the rest of the addon is run.
* 
//-----------------------------------------------------------------------]]--

GEggs = {}
GEggs.VERSION = "1.1.1"

if SERVER then
	include( "sv_eggs.lua" )
else
	include( "cl_eggs.lua" )
end

MsgN( "GModEggs v" .. GEggs.VERSION .. " initialized. Created by bamq." )
