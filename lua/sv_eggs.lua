
--[[-----------------------------------------------------------------------//
* 
* GModEggs
* 
* sv_eggs.lua
* Server-side functions.
* 
//-----------------------------------------------------------------------]]--

-- Send the client files to the client.
AddCSLuaFile( "cl_eggs.lua" )
AddCSLuaFile( "sh_eggs_config.lua" )

include( "sh_eggs_config.lua" )

util.AddNetworkString( "GEggs_DiscoverNotification" )
util.AddNetworkString( "GEggs_Message" )
util.AddNetworkString( "GEggs_RequestList" )

-- Get the Player metatable so we can add our own functions.
local PLAYER = FindMetaTable( "Player" )

-- Make sure our directories exist.
if not file.IsDir( "gmodeggs", "DATA" ) then
	file.CreateDir( "gmodeggs" )
end

if not file.IsDir( "gmodeggs/playerdata", "DATA" ) then
	file.CreateDir( "gmodeggs/playerdata" )
end

-- Init a player's text file.
function GEggs.PlayerFile_Initialize( ply )
	if not file.Exists( "gmodeggs/playerdata/" .. ply:SteamID64() .. ".txt", "DATA" ) then
		file.Write( "gmodeggs/playerdata/" .. ply:SteamID64() .. ".txt", util.TableToJSON( {} ) )
	end
end

-- Write the player's data to their file using JSON.
function GEggs.PlayerFile_WriteTable( ply, tbl )
	file.Write( "gmodeggs/playerdata/" .. ply:SteamID64() .. ".txt", util.TableToJSON( tbl ) )
end

-- Get the player's easter egg table from their file.
function GEggs.PlayerFile_GetTable( ply )
	GEggs.PlayerFile_Initialize( ply )
	return util.JSONToTable( file.Read( "gmodeggs/playerdata/" .. ply:SteamID64() .. ".txt", "DATA" ) )
end

-- Let the client know they discovered an easter egg.
function PLAYER:GEggs_SendDiscoverNotification( egg )
	-- Wait just a little bit.
	timer.Simple( 0.5, function()
		net.Start( "GEggs_DiscoverNotification" )
		net.WriteString( egg )
		net.Send( self )
	end )
end

-- Send the player's easter egg list to the client.
function PLAYER:GEggs_SendEggsList()
	timer.Simple( 0.5, function()
		net.Start( "GEggs_RequestList" )
		net.WriteTable( GEggs.PlayerFile_GetTable( self ) )
		net.Send( self )
	end )
end

-- A generic message sender.
function PLAYER:GEggs_SendGenericMessage( message )
	timer.Simple( 0.5, function()
		net.Start( "GEggs_Message" )
		net.WriteString( message )
		net.Send( self )
	end )
end

-- Check if a player has already discovered an easter egg.
function PLAYER:GEggs_HasDiscoveredEgg( egg )
	return table.HasValue( GEggs.PlayerFile_GetTable( self ), egg )
end

-- Add an easter egg to the player's discovered list.
function PLAYER:GEggs_DiscoverEgg( egg )
	if self:GEggs_HasDiscoveredEgg( egg ) then
		self:GEggs_SendGenericMessage( "You have already found this easter egg!" )

		return
	end

	local pEggs = GEggs.PlayerFile_GetTable( self )

	table.insert( pEggs, egg )
	GEggs.PlayerFile_WriteTable( self, pEggs )

	self:GEggs_SendDiscoverNotification( egg )

	if GEggs.Config.UsePointShop then
		self:PS_GivePoints( GEggs.Config.PointsForEgg )
	end
end

-- Remove an easter egg from a player's list of discovered easter eggs.
-- Isn't used anywhere yet but I guess it could be useful.
function PLAYER:GEggs_UndiscoverEgg( egg )
	if not self:GEggs_HasDiscoveredEgg( egg ) then return end

	local pEggs = GEggs.PlayerFile_GetTable( self )

	table.RemoveByValue( pEggs, egg )
	GEggs.PlayerFile_WriteTable( self, pEggs )
end

-- Just a hook reminding players that they cannot discover easter eggs
-- during an active TTT round, if that option is enabled.
hook.Add( "TTTBeginRound", "GEggs_RoundReminder_TTTBeginRound", function()
	if not GEggs.Config.TTT_ActiveRoundDisable then return end

	for _, ply in pairs( player.GetAll() ) do
		ply:GEggs_SendGenericMessage( "Reminder: easter egg discovery is disabled during rounds unless you are dead or spectating!" )
	end
end )

-- Hook for checking chat messages for easter eggs.
hook.Add( "PlayerSay", "GEggs_CheckChatForEgg_PlayerSay", function( ply, text, isteam )
	if not IsValid( ply ) then return end
	-- If TTT_ActiveRoundDisable is true then we only want to allow dead or
	-- spectating players to find easter eggs if the round is currently active.
	if GetConVar( "gamemode" ):GetString() == "terrortown" and GEggs.Config.TTT_ActiveRoundDisable and GetRoundState() == ROUND_ACTIVE and ply:Alive() and not ply:IsSpec() then return end

	text = string.lower( text )

	if table.HasValue( GEggs.Config.EggList, text ) then
		ply:GEggs_DiscoverEgg( text )
		-- Log the event to console.
		MsgN( ply:Nick() .. " has found easter egg " .. text .. "!" )
	end
end )

-- Hook to check if the player has requested their easter egg data.
hook.Add( "PlayerSay", "GEggs_RequestDiscoveredEggs_PlayerSay", function( ply, text, isteam )
	if not IsValid( ply ) then return end

	if string.lower( text ) == "!myeggs" then
		ply:GEggs_SendEggsList()
	end
end )
