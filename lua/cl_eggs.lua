
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

include( "sh_eggs_config.lua" )

local function GEggsMenu( eggs )
	local GEggsFrame = vgui.Create( "DFrame" )
	GEggsFrame:SetSize( 250, 175 )
	GEggsFrame:SetTitle( "Your discovered easter eggs" )
	GEggsFrame:Center()
	GEggsFrame:SetSizable( true )
	GEggsFrame:ShowCloseButton( true )
	GEggsFrame:MakePopup()
	function GEggsFrame:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 150, 255, 150 ) )
	end

	local GEggsPanel = vgui.Create( "DPanel", GEggsFrame )
	GEggsPanel:Dock( FILL )

	local GEggsListView = vgui.Create( "DListView", GEggsPanel )
	GEggsListView:AddColumn( "Easter Eggs" )
	for _, egg in ipairs( eggs ) do
		GEggsListView:AddLine( egg )
	end
	GEggsListView:Dock( FILL )
end

local m = {
	color = Color( 50, 200, 255 ),
	text = "[Easter Eggs]: "
}

net.Receive( "GEggs_Message", function()
	local message = net.ReadString()

	local ch = { m.color, m.text }
	table.insert( ch, Color( 255, 255, 255 ) )
	table.insert( ch, message )
	chat.AddText( unpack( ch ) )
end )

net.Receive( "GEggs_DiscoverNotification", function()
	local egg = net.ReadString()

	local ch = { m.color, m.text }
	table.insert( ch, Color( 255, 255, 0 ) )
	table.insert( ch, "Congratulations! You have found easter egg " )
	table.insert( ch, Color( 255, 255, 255 ) )
	table.insert( ch, "\"" .. egg .. "\"" )
	table.insert( ch, Color( 255, 255, 0 ) )
	table.insert( ch, "!" )
	if GEggs.Config.UsePointShop then
		table.insert( ch, " You've earned " )
		table.insert( ch, Color( 255, 255, 255 ) )
		table.insert( ch, tostring( GEggs.Config.PointsForEgg ) .. " " )
		table.insert( ch, Color( 255, 255, 0 ) )
		table.insert( ch, PS.Config.PointsName .. "!\n" )
	end
	surface.PlaySound( "UI/buttonclick.wav" )
	chat.AddText( unpack( ch ) )
end )

net.Receive( "GEggs_RequestList", function()
	local pEggs = net.ReadTable()

	GEggsMenu( pEggs )
end )

-- Created by bamq.
