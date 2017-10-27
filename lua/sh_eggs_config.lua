
--[[-----------------------------------------------------------------------//
* 
* GModEggs
* 
* sh_eggs_config.lua
* Configuration options for the addon.
* 
//-----------------------------------------------------------------------]]--

GEggs.Config = GEggs.Config or {}

-- /// CONFIG /// --

GEggs.Config = {
	-- UsePointShop: Should we award PointShop points? PointShop MUST be installed!
	UsePointShop                     = false,

	-- PointsForEgg: If UsePointShpo is true, how many points should we award?
	PointsForEgg                     = 250,

	-- TTT_ActiveRoundDisable: Should we disable the ability for players to discover
	-- easter eggs during an active TTT round? This only applies if the player is alive.
	TTT_ActiveRoundDisable           = true
}

if SERVER then

	-- Add your easter eggs here.
	GEggs.Config.EggList = {
		"!easteregg",
		"!easteregg2"
	}

end

-- /// END CONFIG /// --
