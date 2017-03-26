
--[[-----------------------------------------------------------------------//
* 
* Created by bamq. (https://steamcommunity.com/id/bamq)
* Garry's Mod - GModEggs Easter Eggs System.
* Updated 25 March 2017
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

GEggs.Config = GEggs.Config or {}

-- /// CONFIG /// --

-- GEggs.Config.UsePointShop:
--	Should we award PointShop points for discovering easter eggs?
--	Will cause an error if PointShop is not installed.
GEggs.Config.UsePointShop					= false

-- GEggs.Config.PointsForEgg:
--	If we are using PointShop, how many points should be awarded?
GEggs.Config.PointsForEgg					= 250

-- GEggs.Config.TTT_ActiveRoundDisable:
--	Disables the ability to discover easter eggs during an active
--	round in TTT, unless the player is dead or spectating.
GEggs.Config.TTT_ActiveRoundDisable			= true

if SERVER then

	-- Add your easter eggs here.
	GEggs.Config.EggList = {
		"!easteregg",
		"!easteregg2"
	}

end
-- /// CONFIG /// --

-- Created by bamq.
