
--[[-----------------------------------------------------------------------//
* 
* Created by bamq. (https://steamcommunity.com/id/bamq)
* Garry's Mod - GModEggs Easter Eggs System.
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

AddCSLuaFile( "cl_eggs.lua" )
AddCSLuaFile( "sh_eggs_config.lua" )

include( "sh_eggs_config.lua" )

util.AddNetworkString( "GEggs_DiscoverNotification" )
util.AddNetworkString( "GEggs_Message" )
util.AddNetworkString( "GEggs_RequestList" )

local PLAYER = FindMetaTable( "Player" )

if not file.IsDir( "gmodeggs", "DATA" ) then
	file.CreateDir( "gmodeggs" )
end
if not file.IsDir( "gmodeggs/playerdata", "DATA" ) then
	file.CreateDir( "gmodeggs/playerdata" )
end

function GEggs.PlayerFile_Initialize( ply )
	if not file.Exists( "gmodeggs/playerdata/" .. ply:SteamID64() .. ".txt.", "DATA" ) then
		file.Write( "gmodeggs/playerdata/" .. ply:SteamID64() .. ".txt", util.TableToJSON( {} ) )
	end
end

function GEggs.PlayerFile_WriteTable( ply, tbl )
	file.Write( "gmodeggs/playerdata/" .. ply:SteamID64() .. ".txt", util.TableToJSON( tbl ) )
end

function GEggs.PlayerFile_GetTable( ply )
	GEggs.PlayerFile_Initialize( ply )
	return util.JSONToTable( file.Read( "gmodeggs/playerdata/" .. ply:SteamID64() .. ".txt", "DATA" ) )
end

function PLAYER:GEggs_SendDiscoverNotification( egg )
	timer.Simple( 0.5, function()
		net.Start( "GEggs_DiscoverNotification" )
		net.WriteString( egg )
		net.Send( self )
	end )
end

function PLAYER:GEggs_SendEggsList()
	local pEggs = GEggs.PlayerFile_GetTable( self )
	timer.Simple( 0.5, function()
		net.Start( "GEggs_RequestList" )
		net.WriteTable( pEggs )
		net.Send( self )
	end )
end

function PLAYER:GEggs_SendGenericMessage( message )
	timer.Simple( 0.5, function()
		net.Start( "GEggs_Message" )
		net.WriteString( message )
		net.Send( self )
	end )
end

function PLAYER:GEggs_HasDiscoveredEgg( egg )
	return table.HasValue( GEggs.PlayerFile_GetTable( self ), egg )
end

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

function PLAYER:GEggs_UndiscoverEgg( egg )
	if not self:GEggs_HasDiscoveredEgg( egg ) then return end

	local pEggs = GEggs.PlayerFile_GetTable( self )
	table.RemoveByValue( pEggs, egg )
	GEggs.PlayerFile_WriteTable( self, pEggs )
end

hook.Add( "TTTBeginRound", "GEggs_RoundReminder_TTTBeginRound", function()
	if not GEggs.Config.TTT_ActiveRoundDisable then return end
	for _, ply in pairs( player.GetAll() ) do
		ply:GEggs_SendGenericMessage( "Reminder: easter egg discovery is disabled during rounds unless you are dead or spectating!" )
	end
end )

hook.Add( "PlayerSay", "GEggs_CheckChatForEgg_PlayerSay", function( ply, text, isteam )
	if not IsValid( ply ) then return end
	if GetConVar( "gamemode" ):GetString() == "terrortown" and GEggs.Config.TTT_ActiveRoundDisable and GetRoundState() == ROUND_ACTIVE and ply:Alive() and not ply:IsSpec() then return end

	text = string.lower( text )
	if table.HasValue( GEggs.Config.EggList, text ) then
		ply:GEggs_DiscoverEgg( text )
		MsgN( ply:Nick() .. " has found easter egg " .. text .. "!" )
	end
end )

hook.Add( "PlayerSay", "GEggs_RequestDiscoveredEggs_PlayerSay", function( ply, text, isteam )
	if not IsValid( ply ) then return end

	if string.lower( text ) == "!myeggs" then
		ply:GEggs_SendEggsList()
	end
end )

-- Created by bamq.
