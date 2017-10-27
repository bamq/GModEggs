
--[[-----------------------------------------------------------------------//
* 
* GModEggs
* 
* cl_eggs.lua
* Client-side functions, mostly chat notifications and messages.
* 
//-----------------------------------------------------------------------]]--

include( "sh_eggs_config.lua" )

-- Function to create the menu that displays the eggs.
local function GEggsMenu( eggs )
	-- Create the frame.
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

	-- Create the main panel.
	local GEggsPanel = vgui.Create( "DPanel", GEggsFrame )
	GEggsPanel:Dock( FILL )

	-- Create the list
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
