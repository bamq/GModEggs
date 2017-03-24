
--[[-----------------------------------------------------------------------//
* 
* Created by bamq. (https://steamcommunity.com/id/bamq)
* Garry's Mod - GModEggs Easter Eggs Sytem.
* 24 March 2017
* 
* Originally made for The Drunken T's TTT server.
* https://steamcommunity.com/groups/thedrunkent
*
* Features:
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

GEggs = {}
GEggs.VERSION = "1.0"

if SERVER then
	include( "sv_eggs.lua" )
else
	include( "cl_eggs.lua" )
end

MsgN( "GModEggs v" .. GEggs.VERSION .. " Initialized. Created by bamq." )

-- Created by bamq.
