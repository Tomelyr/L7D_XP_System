--[[########################################################
						L7D's XP System
				Copyright ( C ) 2014 ~ 'L7D'
		You have any question? steam friend invite me!
						ID : smhjyh2009
//////////////////////////////////////////////////////////--]]

local logcountread = file.Read("XPSys/Log/Count.txt", "DATA") or 0
XPSys = XPSys or {}
XPSys.core = XPSys.core or {}
XPSys.XP = XPSys.XP or {}
XPSys.XPHook = {}
XPSys.XPHookList = XPSys.XPHookList or {}
XPSys.XPLevel = {}
XPSys.BlackList = {}
XPSys.LogHistory = XPSys.LogHistory or {}
XPSys.LogCount = XPSys.LogCount or logcountread
logcountread = nil

function XPSys.core.Print( color, msg )
	if ( color && msg ) then
		MsgC( color, "[XPSys]" .. msg .. "\n" )
	else
		error( "[XPSys]Missing color or msg" )
	end
end

function XPSys.core.Loadfile( fileDir )
	if ( fileDir ) then
		include( fileDir )
	else
		error( "[XPSys]Missing file dir." )
	end
end

function XPSys.core.ClientLoadfile( fileDir )
	if ( fileDir ) then
		AddCSLuaFile( fileDir )
	else
		error( "[XPSys]Missing file dir." )
	end
end

function XPSys.core.FileWrite( fileDir, fileValue )
	file.Write( fileDir, fileValue )
end

function XPSys.core.FileAppend( fileDir, fileValue )
	file.Append( fileDir, fileValue )
end

function XPSys.core.FileRead( fileDir )
	return file.Read( fileDir, "DATA" )
end

function XPSys.core.FileDelete( fileDir )
	file.Delete( fileDir )
end

function XPSys.core.DirCreate( Dir )
	file.CreateDir( Dir )
end

function XPSys.core.Log( str )
	if ( XPSys.Config.LogSystem_Enabled ) then
		local date = os.date("*t")
		local logCount = file.Read("XPSys/Log/Count.txt", "DATA") or 0
		local fileName = date.year .. "-" .. date.month .. "-" .. date.day
		local str2 = "|" .. os.date() .. "|" .. str .. "\n"
		local fileExist = file.Read("XPSys/Log/" .. fileName .. "-Log.txt", "DATA") or nil
		
		XPSys.core.DirCreate( "XPSys/Log" )
		
		if ( fileExist ) then
			file.Append( "XPSys/Log/" .. fileName .. "-Log.txt", str2 )
		else
			file.Append( "XPSys/Log/" .. fileName .. "-Log.txt", "|" .. os.date() .. "|Log system started.\n"  )
			file.Append( "XPSys/Log/" .. fileName .. "-Log.txt", str2 )
		end
		if ( !XPSys.LogHistory[ fileName ] ) then
			XPSys.LogHistory[ fileName ] = {}
			XPSys.LogCount = 0
			XPSys.core.FileWrite( "XPSys/Log/Count.txt", tostring( 0 ) )
		end
		
		ServerLog( str2 )
		
		local formats = {
			Count = XPSys.LogCount,
			Time = os.date(),
			Text = str
		}
	
		XPSys.LogHistory[ fileName ][ #XPSys.LogHistory[ fileName ] + 1 ] = formats
		
		XPSys.LogCount = XPSys.LogCount + 1
		XPSys.core.FileWrite( "XPSys/Log/Count.txt", tostring( XPSys.LogCount ) )
		
		XPSys.core.LogHistorySave()
		return
	else
		ServerLog( str2 ) -- Cool? :)
	end
end

CreateConVar( "XPSys_RankNoticeSystem", "0", { FCVAR_REPLICATED, FCVAR_PROTECTED } )

local Players = FindMetaTable( "Player" )

function Players:AddXP( xp )
	XPSys.core.XPAdd( self, xp )
end

--[[########################################################
				XPSys.core.XPRegister( pl )
				
		What is this? : First xp data base register.
//////////////////////////////////////////////////////////--]]
function XPSys.core.XPRegister( pl )
	if ( #XPSys.XP != 0 ) then
		for i = 1, #XPSys.XP do
			if ( XPSys.XP[i].SteamID != pl:SteamID() ) then
				if ( i == #XPSys.XP ) then
					table.insert( XPSys.XP, { Name = pl:Name(), SteamID = pl:SteamID(), XP = 0, Level = 0 } )
					XPSys.core.XPSave()
					pl:SetNWInt( "XP", 0 )
					pl:SetNWInt( "Level", 0 )
					RunConsoleCommand("XPSys_SendCL")
					XPSys.core.Print( Color( 0, 255, 0 ), "XP Data base Register : " .. pl:SteamID() )
					XPSys.core.Log( "XP Data base register. : [ " .. pl:Name() .. " , " .. pl:SteamID() .. " , " .. pl:IPAddress() .. " ]" )
					return
				end
			else
				pl:SetNWInt( "XP", XPSys.XP[i].XP )
				pl:SetNWInt( "Level", XPSys.XP[i].Level )	
				return
			end
		end
	else
		pl:SetNWInt( "XP", 0 )
		pl:SetNWInt( "Level", 0 )
		table.insert( XPSys.XP, { Name = pl:Name(), SteamID = pl:SteamID(), XP = 0, Level = 0 } )
		XPSys.core.Print( Color( 0, 255, 0 ), "XP Data base Register : " .. pl:SteamID() )
		XPSys.core.Log( "XP Data base register. : [ " .. pl:Name() .. " , " .. pl:SteamID() .. " , " .. pl:IPAddress() .. " ]" )
		RunConsoleCommand("XPSys_SendCL")
		return
	end
end

--[[########################################################
				XPSys.core.XPSave()
				
		What is this? : XP data base save.
//////////////////////////////////////////////////////////--]]
function XPSys.core.XPSave()
	if ( #XPSys.XP != 0 ) then
		local encode = util.TableToJSON( XPSys.XP )
		XPSys.core.FileWrite( "XPSys/XP.txt", encode )
		XPSys.core.Print( Color( 0, 255, 0 ), #XPSys.XP .. " 's XP datebase saved." )
		local fileCheck = XPSys.core.FileRead( "XPSys/XP.txt" ) or "[]"
		if ( fileCheck != "[]" ) then
			XPSys.core.Print( Color( 0, 255, 0 ), "DB Save Check : No problem found :)" )
		else
			XPSys.core.Print( Color( 255, 255, 0 ), "DB Save Check : Problem found :(" )
			return
		end
		RunConsoleCommand("XPSys_SendCL")
	else
		XPSys.core.FileWrite( "XPSys/XP.txt", "[]" )	
		XPSys.core.Print( Color( 0, 255, 0 ), "0's XP datebase saved." )
	end
end

function XPSys.core.LogHistorySave()
	if ( XPSys.LogHistory != {} ) then
		local encode = util.TableToJSON( XPSys.LogHistory )
		XPSys.core.FileWrite( "XPSys/LogHistory.txt", encode )
		XPSys.core.Print( Color( 0, 255, 0 ), "Log history datebase saved." )
		RunConsoleCommand("XPSys_SendCL")
	end
end

--[[########################################################
				XPSys.core.XPLoad()
				
		What is this? : XP data base load.
//////////////////////////////////////////////////////////--]]
function XPSys.core.XPLoad()
	local fileRead = XPSys.core.FileRead( "XPSys/XP.txt" ) or "[]"
	if ( fileRead != "[]" ) then
		local decode = util.JSONToTable( fileRead )
		XPSys.XP = decode
		XPSys.core.Print( Color( 0, 255, 0 ), #XPSys.XP .. " 's XP database loaded." )
		if ( #XPSys.XP != 0 ) then
			XPSys.core.Print( Color( 0, 255, 0 ), "DB Load Check : No problem found :)" )
		else
			XPSys.core.Print( Color( 255, 255, 0 ), "DB Load Check : Problem found :(" )
			return
		end
		RunConsoleCommand("XPSys_SendCL")
	end
end

function XPSys.core.LogHistoryLoad()
	local fileRead = XPSys.core.FileRead( "XPSys/LogHistory.txt" ) or "[]"
	if ( fileRead != "[]" ) then
		local decode = util.JSONToTable( fileRead )
		XPSys.LogHistory = decode
		XPSys.core.Print( Color( 0, 255, 0 ), "Log history database loaded." )
		RunConsoleCommand("XPSys_SendCL")
	end
end

--[[########################################################
		XPSys.core.XPHookAdd( hookadd, title, detail, cost )
				
			What is this? : XP Hook add function
	EX : XPSys.core.XPHookAdd( "PlayerAuth", "Auth", "Yeah", 15, nil )
//////////////////////////////////////////////////////////--]]
function XPSys.core.XPHookAdd( hookadd, title, detail, cost, func )
	local randomUniqueID = math.random( 1, 1000000 )
	if ( !func ) then
		table.insert( XPSys.XPHook, { Title = title, Detail = detail, Cost = cost } )
		hook.Add( hookadd, "XPSys_Hook_" .. hookadd .. randomUniqueID, function( pl )
			XPSys.core.XPAdd( pl, tonumber(cost) )
		end)
		XPSys.XPHookList[ #XPSys.XPHookList + 1 ] = { hookName = hookadd, hookUniqueID = "XPSys_Hook_" .. hookadd .. randomUniqueID }
	else
		table.insert( XPSys.XPHook, { Title = title, Detail = detail, Cost = cost } )
		hook.Add( hookadd, "XPSys_Hook_" .. hookadd .. randomUniqueID, function( ... )
			func( ... )
		end)
		XPSys.XPHookList[ #XPSys.XPHookList + 1 ] = { hookName = hookadd, hookUniqueID = "XPSys_Hook_" .. hookadd .. randomUniqueID }
	end
end

function XPSys.core.XPHookRemove( hookName, hookUniqueID )
	hook.Remove( hookName, hookUniqueID )
end

--[[########################################################
		XPSys.core.XPHookInfoAdd( index, title, detail, cost )
				
			What is this? : XP Hook info add function
//////////////////////////////////////////////////////////--]]
function XPSys.core.XPHookInfoAdd( index, title, detail, cost )
	table.insert( XPSys.XPHook, { Index = index, Title = title, Detail = detail, Cost = cost } )
end

--[[########################################################
		XPSys.core.BlacklistAdd( steamid )
				
		What is this? : XP system blacklist add function
	EX : XPSys.core.BlacklistAdd( "STEAM:0:0:12345678" )
//////////////////////////////////////////////////////////--]]
function XPSys.core.BlacklistAdd( steamid )
	table.insert( XPSys.BlackList, { SteamID = steamid } )
end

--[[########################################################
		XPSys.core.LevelAdd( lvlindex, lvlXP, lvlreward )
				
		What is this? : Level add function :>
		EX : XPSys.core.LevelAdd( 1, 100, 500 )
//////////////////////////////////////////////////////////--]]
function XPSys.core.LevelAdd( lvlindex, lvlXP, lvlreward )
	table.insert( XPSys.XPLevel, { Index = lvlindex, XP = lvlXP, Reward = tostring(lvlreward) } )
end

--[[########################################################
					Level Core System
//////////////////////////////////////////////////////////--]]
function XPSys.core.XPLevelCheck()
	for m, q in pairs( player.GetAll() ) do
		for l, g in pairs( XPSys.BlackList ) do
			if ( q:SteamID() == g.SteamID ) then
				return
			end
		end
	end
	for k, v in pairs( XPSys.XPLevel ) do
		for i = 1, #XPSys.XP do
			if ( XPSys.XP[i].XP >= v.XP ) then
				k = tonumber( k )
				if ( XPSys.XP[i].Level >= v.Index ) then
					if ( XPSys.XP[i].Level == v.Index ) then
						local curretlvl = XPSys.XP[i].Level
						XPSys.core.Print( Color( 0, 255, 0 ), "Level up! : " .. XPSys.XP[i].SteamID )
						XPSys.core.Log( "Level up. { " .. curretlvl .. " > " .. curretlvl + 1 .. " }: [ " .. XPSys.XP[i].Name .. " , " .. XPSys.XP[i].SteamID .. " ]" )
						XPSys.core.XPLevelUP( XPSys.XP[i].SteamID, v.Index )
						XPSys.core.XPSave()
						RunConsoleCommand("XPSys_SendCL")
						for a, d in pairs( player.GetAll() ) do
							if ( d:SteamID() == XPSys.XP[i].SteamID ) then
								net.Start("XPSys_XP_Notice")
								net.WriteTable( { Name = d:Name(), Text = "", CurretLevel = curretlvl, NextLevel = curretlvl + 1, Cost = v.Reward } )
								net.Send( d )
								PrintMessage( HUD_PRINTTALK, d:Name() .. " 's " .. curretlvl + 1 .. " to Level UP![ Reward : " .. v.Reward .. " ]" )
								if ( PS ) then
									if ( XPSys.Config.UseRewardSystem ) then
										d:PS_XPGivePoints( v.Reward )
									end
								end
							end
						end
						return
					end
				end
			end
		end
	end
end

function XPSys.core.XPLevelUP( plSteamID, level )
	for l, g in pairs( XPSys.BlackList ) do
		if ( plSteamID == g.SteamID ) then
			return
		end
	end
	for i = 1, #XPSys.XP do
		if ( XPSys.XP[i].SteamID == plSteamID ) then
			XPSys.XP[i].Level = level + 1
			for k, v in pairs( player.GetAll() ) do
				if ( v:SteamID() == XPSys.XP[i].SteamID ) then
					v:SetNWInt( "Level", level )
				end
			end
		end
	end
end

XPSys.core.Loadfile( "SH_Config.lua" )
XPSys.core.ClientLoadfile( "SH_Config.lua" )

--[[########################################################
						HOOK! :)
//////////////////////////////////////////////////////////--]]
hook.Add( "PlayerAuthed", "XPSys_DataBaseRegister", function( pl )
	XPSys.core.XPRegister( pl )
	RunConsoleCommand("XPSys_SendCL")
end)

hook.Add("Initialize", "XPSys_InitLoadXP", function()
	local fileCheck = file.Read("XPSys/UniqueID.txt", "DATA") or nil
	XPSys.core.DirCreate( "XPSys" )
	if ( !fileCheck ) then
		local uniqueID = "XP-" .. math.random( 1, 10000000 ) .. "-" .. math.random( 1, 1000 )
		XPSys.core.FileWrite( "XPSys/UniqueID.txt", tostring( uniqueID ) )XPSys.core.FileWrite( "XPSys/UniqueID.txt", tostring( uniqueID ) )
	end
	XPSys.core.XPLoad()
	XPSys.core.LogHistoryLoad()
	XPSys.core.Print( Color( 0, 255, 0 ), "XP System booted!" )
	XPSys.core.Log( "XP System booted!" )
end)

hook.Add("Think", "XPSys_LevelCheck", function()
	XPSys.core.XPLevelCheck()
end)

--[[########################################################
					Console Command :)
//////////////////////////////////////////////////////////--]]
concommand.Add("XPSys_Initialization", function( ply, cmd, args )
	if ( IsValid( ply ) and !XPSys.Config.PermissionGroup( pl ) ) then 
		pl:ChatPrint("You do not have permission!") 
		XPSys.core.Log( "[* !WARNING! *] Permission request denied. : [ " .. pl:Name() .. " , " .. pl:SteamID() .. " , " .. pl:IPAddress() .. " ]" )
		return 
	end
	XPSys.core.FileDelete( "XPSys/XP.txt" )
	XPSys.core.FileDelete( "XPSys/LogHistory.txt" )
	
	XPSys.XP = {}
	XPSys.LogHistory = {}
	XPSys.LogCount = 0
	
	for k, v in pairs( player.GetAll() ) do
		v:SetNWInt( "XP", 0 )
		v:SetNWInt( "Level", 0 )
	end
	RunConsoleCommand("XPSys_SendCL")
	XPSys.core.Print( Color( 0, 255, 0 ), "XP system initialization succeeded." )
	if ( IsValid( ply ) ) then
		XPSys.core.Log( "[* !IMPORTANT! *] XP system initialization succeeded. [ " .. ply:Name() .. " , " .. ply:SteamID() .. " , " .. ply:IPAddress() .. " ]" )
	else
		XPSys.core.Log( "[* !IMPORTANT! *] XP system initialization succeeded." )
	end
end)

concommand.Add("XPSys_SendCL", function( )
	net.Start("XPSys_XPTableSendCL")
	net.WriteTable( XPSys.XP )
	net.WriteTable( XPSys.XPLevel )
	net.WriteTable( XPSys.XPHook )
	net.WriteTable( XPSys.XPLevel )
	net.WriteTable( XPSys.LogHistory )
	net.Broadcast()
end)

concommand.Add("XPSys_Save", function( )
	XPSys.core.XPSave()
	XPSys.core.LogHistorySave()
end)

concommand.Add("XPSys_Sync", function( )
	XPSys.core.XPLoad()
	XPSys.core.LogHistoryLoad()
	for k, v in pairs( player.GetAll() ) do
		for i = 1, #XPSys.XP do
			if ( v:SteamID() == XPSys.XP[i].SteamID ) then
				v:SetNWInt( "XP", XPSys.XP[i].XP )
				v:SetNWInt( "Level", XPSys.XP[i].Level )
			end
		end
	end
end)

concommand.Add("XPSys_RankNoticeCall", function( pl, cmd, args )
	if ( IsValid( pl ) && !XPSys.Config.PermissionGroup( pl ) ) then 
		pl:ChatPrint("You do not have permission!") 
		return 
	end
	umsg.Start("XPSys_RankNoticeCall")
	umsg.End()
end)

concommand.Add("XPSys_RewardCall", function( pl, cmd, args )
	if ( IsValid( pl ) && !XPSys.Config.PermissionGroup( pl ) ) then 
		pl:ChatPrint("You do not have permission!") 
		XPSys.core.Log( "[* !WARNING! *] Permission request denied. : [ " .. pl:Name() .. " , " .. pl:SteamID() .. " , " .. pl:IPAddress() .. " ]" )
		return 
	end
	if ( !PS ) then 
		XPSys.core.Log( "[* !WARNING! *] Can't reward call, pointshop not found. : [ " .. pl:Name() .. " , " .. pl:SteamID() .. " , " .. pl:IPAddress() .. " ]" )
		return 
	end
	if ( !XPSys.Config.UseRewardSystem ) then
		return
	end
	table.sort( XPSys.XP, function( a, b )
		return a.XP > b.XP
	end)
	for i, a in pairs( player.GetAll() ) do
		for k, v in pairs( XPSys.XP ) do
			if ( k == 1 ) then
				if ( v.SteamID == a:SteamID() ) then
					a:PS_RankGivePoints( k, XPSys.Config.RankReward[1] )
					XPSys.core.Print( Color( 0, 255, 0 ), "Give point! : [" .. k .. "st] : [" .. v.SteamID .. "]" )
				end
			elseif ( k == 2 ) then
				if ( v.SteamID == a:SteamID() ) then
					a:PS_RankGivePoints( k, XPSys.Config.RankReward[2] )
					XPSys.core.Print( Color( 0, 255, 0 ), "Give point! : [" .. k .. "st] : [" .. v.SteamID .. "]" )
				end			
			elseif ( k == 3 ) then
				if ( v.SteamID == a:SteamID() ) then
					a:PS_RankGivePoints( k, XPSys.Config.RankReward[3] )
					XPSys.core.Print( Color( 0, 255, 0 ), "Give point! : [" .. k .. "st] : [" .. v.SteamID .. "]" )
				end
			end
		end
	end
end)

concommand.Add("XPSys_XPSysAdd", function( pl, cmd, args )
	if ( IsValid( pl ) && !XPSys.Config.PermissionGroup( pl ) ) then 
		pl:ChatPrint("You do not have permission!") 
		XPSys.core.Log( "[* !WARNING! *] Permission request denied. : [ " .. pl:Name() .. " , " .. pl:SteamID() .. " , " .. pl:IPAddress() .. " ]" )
		return 
	end
	if ( args[1] ) then
		local a = XPSys.core.FindPlayer( args[1] )
		if ( a[1] ) then
			if ( args[2] ) then
				XPSys.core.XPAdd( a[1], args[2] )
			else
				pl:ChatPrint("[XPSys] args[2] is missing.") 
			end
		else
			pl:ChatPrint("[XPSys] Can't find player.") 
		end
	end
end)

concommand.Add("XPSys_XPSysTake", function( pl, cmd, args )
	if ( IsValid( pl ) && !XPSys.Config.PermissionGroup( pl ) ) then 
		pl:ChatPrint("You do not have permission!") 
		XPSys.core.Log( "[* !WARNING! *] Permission request denied. : [ " .. pl:Name() .. " , " .. pl:SteamID() .. " , " .. pl:IPAddress() .. " ]" )
		return 
	end
	if ( args[1] ) then
		local a = XPSys.core.FindPlayer( args[1] )
		if ( a[1] ) then
			if ( args[2] ) then
				XPSys.core.XPTake( a[1], args[2] )
			else
				pl:ChatPrint("[XPSys] args[2] is missing.") 
			end
		else
			pl:ChatPrint("[XPSys] Can't find player.") 
		end
	end
end)

concommand.Add("XPSys_LevelSysSetLevel", function( pl, cmd, args )
	if ( IsValid( pl ) && !XPSys.Config.PermissionGroup( pl ) ) then 
		pl:ChatPrint("You do not have permission!") 
		XPSys.core.Log( "[* !WARNING! *] Permission request denied. : [ " .. pl:Name() .. " , " .. pl:SteamID() .. " , " .. pl:IPAddress() .. " ]" )
		return
	end
	if ( args[1] ) then
		local a = XPSys.core.FindPlayer( args[1] )
		if ( a[1] ) then
			if ( args[2] ) then
				for i = 1, #XPSys.XP do
					if ( XPSys.XP[i].SteamID == pl:SteamID() ) then
						a[1]:SetNWInt( "Level", tonumber(args[2]) )
						XPSys.XP[i].Level = tonumber(args[2])
						XPSys.core.Print( Color( 0, 255, 0 ), "Level set finished, : " .. XPSys.XP[i].Level )
						return
					end
				end
			else
				pl:ChatPrint("[XPSys] args[2] is missing.") 
			end
		else
			pl:ChatPrint("[XPSys] Can't find player.") 
		end
	end
end)

concommand.Add("XPSys_Load", function( pl, cmd, args )
	XPSys.core.XPLoad()
	XPSys.core.LogHistoryLoad()
end)

timer.Create("XPSys_XPSystemSave", XPSys.Config.DataSaveInterval, 0, function()
	XPSys.core.XPSave()
	XPSys.core.LogHistorySave()
	RunConsoleCommand("XPSys_SendCL")
end)

timer.Create("XPSys_XPSystemAutoNotice", XPSys.Config.RankNoticeTimer, 0, function()
	if ( GetConVarString("XPSys_RankNoticeSystem") == "1" ) then
		RunConsoleCommand("XPSys_SendCL")
		umsg.Start("XPSys_RankNoticeCall")
		umsg.End()
	end
end)

timer.Create("XPSys_RankReward", XPSys.Config.RankRewardTimer, 0, function()
	table.sort( XPSys.XP, function( a, b )
		return a.XP > b.XP
	end)
	if ( !PS ) then return end
	if ( !XPSys.Config.UseRewardSystem ) then
		return
	end
	for i, a in pairs( player.GetAll() ) do
		for k, v in pairs( XPSys.XP ) do
			if ( k == 1 ) then
				if ( v.SteamID == a:SteamID() ) then
					a:PS_RankGivePoints( k, XPSys.Config.RankReward[1] )
					XPSys.core.Print( Color( 0, 255, 0 ), "Give gold! : [" .. k .. "st] : [" .. v.SteamID .. "]" )
				end
			elseif ( k == 2 ) then
				if ( v.SteamID == a:SteamID() ) then
					a:PS_RankGivePoints( k, XPSys.Config.RankReward[2] )
					XPSys.core.Print( Color( 0, 255, 0 ), "Give gold! : [" .. k .. "st] : [" .. v.SteamID .. "]" )
				end			
			elseif ( k == 3 ) then
				if ( v.SteamID == a:SteamID() ) then
					a:PS_RankGivePoints( k, XPSys.Config.RankReward[3] )
					XPSys.core.Print( Color( 0, 255, 0 ), "Give gold! : [" .. k .. "st] : [" .. v.SteamID .. "]" )
				end	
			end
		end
	end
end)

function XPSys.core.FindPlayer( name )
	local matches = {}
	for k, v in pairs( player.GetAll() ) do
		if ( v:Name():lower():match( name:lower() ) ) then
			table.insert( matches, v )
		end
	end
	if ( #matches == 0 ) then
		return false
	end
	return matches
end

function XPSys.core.XPAdd( pl, addxp )
	for l, g in pairs( XPSys.BlackList ) do
		if ( pl:SteamID() == g.SteamID ) then
			return
		end
	end
	if ( #XPSys.XP != 0 ) then
		for i = 1, #XPSys.XP do
			if ( XPSys.XP[i].SteamID == pl:SteamID() ) then
				local xp = XPSys.XP[i].XP
				XPSys.XP[i].XP = xp + addxp
				XPSys.XP[i].Name = pl:Name()
				pl:SetNWInt( "XP", XPSys.XP[i].XP )
				pl:SetNWInt( "Level", XPSys.XP[i].Level )
				XPSys.core.Print( Color( 0, 255, 0 ), "XP Add finished : [" .. XPSys.XP[i].SteamID .. " , " .. XPSys.XP[i].XP .. "]" )
				return
			end
		end
	else
		XPSys.core.XPRegister( pl )
		XPSys.core.Print( Color( 0, 255, 0 ), "XP Add failed , register xp : " .. pl:SteamID() )
		return
	end
end

function XPSys.core.XPTake( pl, takexp )
	if ( #XPSys.XP != 0 ) then
		for i = 1, #XPSys.XP do
			if ( XPSys.XP[i].SteamID == pl:SteamID() ) then
				local xp = XPSys.XP[i].XP
				if ( xp >= 1 ) then
					XPSys.XP[i].XP = xp - takexp
					XPSys.XP[i].Name = pl:Name()
					pl:SetNWInt( "XP", XPSys.XP[i].XP )
					XPSys.core.Print( Color( 0, 255, 0 ), "XP take finished : [" .. XPSys.XP[i].SteamID .. " , " .. XPSys.XP[i].XP .. "]" )
					XPSys.core.XPSave()
					RunConsoleCommand("XPSys_SendCL")
					return
				else
					XPSys.core.Print( Color( 0, 255, 0 ), "XP take failed : [" .. XPSys.XP[i].SteamID .. " , " .. XPSys.XP[i].XP .. "]" )
				end
			end
		end
	else
		XPSys.core.XPRegister( pl )
		XPSys.core.Print( Color( 0, 255, 0 ), "XP Take failed , register xp : " .. pl:SteamID() )
		return
	end
end

function XPSys.core.XPSet( pl, xp )
	if ( #XPSys.XP != 0 ) then
		for i = 1, #XPSys.XP do
			if ( XPSys.XP[i].SteamID == pl:SteamID() ) then
				if ( xp >= 1 ) then
					XPSys.XP[i].XP = xp
					XPSys.XP[i].Name = pl:Name()
					pl:SetNWInt( "XP", XPSys.XP[i].XP )
					XPSys.core.Print( Color( 0, 255, 0 ), "XP set finished : [" .. XPSys.XP[i].SteamID .. " , " .. XPSys.XP[i].XP .. "]" )
					XPSys.core.XPSave()
					RunConsoleCommand("XPSys_SendCL")
					return
				else
					XPSys.core.Print( Color( 0, 255, 0 ), "XP set failed : [" .. XPSys.XP[i].SteamID .. " , " .. XPSys.XP[i].XP .. "]" )
				end
			end
		end
	else
		XPSys.core.XPRegister( pl )
		XPSys.core.Print( Color( 0, 255, 0 ), "XP Set failed , register xp : " .. pl:SteamID() )
		return
	end
end

function XPSys.core.LevelSetOffline( plSteamID, level )
	if ( #XPSys.XP != 0 ) then
		for i = 1, #XPSys.XP do
			if ( XPSys.XP[i].SteamID == plSteamID ) then
				XPSys.XP[i].Level = level
				
				for k, v in pairs( player.GetAll() ) do
					if ( v:SteamID() == plSteamID ) then
						XPSys.core.Print( Color( 0, 255, 0 ), "Target online!, set level : " .. XPSys.XP[i].Level )
						v:SetNWInt( "XP", XPSys.XP[i].XP )
						v:SetNWInt( "Level", XPSys.XP[i].Level )
						XPSys.XP[i].Name = v:Name()
					end
				end
				RunConsoleCommand("XPSys_SendCL")
				XPSys.core.XPSave()
				XPSys.core.Print( Color( 0, 255, 0 ), "Level set finished, : " .. XPSys.XP[i].Level )
				return
			end
		end
	else
		XPSys.core.XPRegister( pl )
		XPSys.core.Print( Color( 0, 255, 0 ), "Level set failed , register xp : " .. plSteamID )
		return
	end
end

function XPSys.core.XPAddOffline( plSteamID, addxp )
	if ( #XPSys.XP != 0 ) then
		for i = 1, #XPSys.XP do
			if ( XPSys.XP[i].SteamID == plSteamID ) then
				local xp = XPSys.XP[i].XP
				XPSys.XP[i].XP = xp + addxp
				
				for k, v in pairs( player.GetAll() ) do
					if ( v:SteamID() == plSteamID ) then
						XPSys.core.Print( Color( 0, 255, 0 ), "Target online!, add xp : " .. XPSys.XP[i].XP )
						v:SetNWInt( "XP", XPSys.XP[i].XP )
						v:SetNWInt( "Level", XPSys.XP[i].Level )
						XPSys.XP[i].Name = v:Name()
					end
				end
				RunConsoleCommand("XPSys_SendCL")
				XPSys.core.XPSave()
				XPSys.core.Print( Color( 0, 255, 0 ), "XP Add finished, : " .. XPSys.XP[i].XP )
				return
			end
		end
	else
		XPSys.core.XPRegister( pl )
		XPSys.core.Print( Color( 0, 255, 0 ), "XP Add failed , register xp : " .. plSteamID )
		return
	end
end

function XPSys.core.XPTakeOffline( plSteamID, takexp )
	if ( #XPSys.XP != 0 ) then
		for i = 1, #XPSys.XP do
			if ( XPSys.XP[i].SteamID == plSteamID ) then
				local xp = XPSys.XP[i].XP
				if ( xp >= 1 ) then
					XPSys.XP[i].XP = xp - takexp
					for k, v in pairs( player.GetAll() ) do
						if ( v:SteamID() == plSteamID ) then
							XPSys.core.Print( Color( 0, 255, 0 ), "Target online take xp : " .. XPSys.XP[i].XP )
							v:SetNWInt( "XP", XPSys.XP[i].XP )
							v:SetNWInt( "Level", XPSys.XP[i].Level )
							XPSys.XP[i].Name = v:Name()
						end
					end
					XPSys.core.Print( Color( 0, 255, 0 ), "XP Take finished, : " .. XPSys.XP[i].XP )
					XPSys.core.XPSave()
					RunConsoleCommand("XPSys_SendCL")
					return
				else
					XPSys.core.Print( Color( 255, 255, 0 ), "XP Take failed, : " .. XPSys.XP[i].XP )
				end
			end
		end
	else
		XPSys.core.XPRegister( pl )
		XPSys.core.Print( Color( 0, 255, 0 ), "XP Take failed , register xp : " .. plSteamID )
		return
	end
end

function XPSys.core.XPSetOffline( plSteamID, xp )
	if ( #XPSys.XP != 0 ) then
		for i = 1, #XPSys.XP do
			if ( XPSys.XP[i].SteamID == plSteamID ) then
				if ( xp >= 1 ) then
					XPSys.XP[i].XP = xp
					for k, v in pairs( player.GetAll() ) do
						if ( v:SteamID() == plSteamID ) then
							XPSys.core.Print( Color( 0, 255, 0 ), "Target online set xp : " .. XPSys.XP[i].XP )
							v:SetNWInt( "XP", XPSys.XP[i].XP )
							v:SetNWInt( "Level", XPSys.XP[i].Level )
							XPSys.XP[i].Name = v:Name()
						end
					end
					XPSys.core.Print( Color( 0, 255, 0 ), "XP Set finished, : " .. XPSys.XP[i].XP )
					XPSys.core.XPSave()
					RunConsoleCommand("XPSys_SendCL")
					return
				else
					XPSys.core.Print( Color( 255, 255, 0 ), "XP Set failed, : " .. XPSys.XP[i].XP )
				end
			end
		end
	else
		XPSys.core.XPRegister( pl )
		XPSys.core.Print( Color( 0, 255, 0 ), "XP Take failed , register xp : " .. plSteamID )
		return
	end
end


XPSys.core.Loadfile( "SV_L7D_OpenHOOK.lua" )
XPSys.core.Loadfile( "SV_L7D_NetLib.lua" )
XPSys.core.Loadfile( "SH_SharedFunc.lua" )

XPSys.core.ClientLoadfile( "SH_SharedFunc.lua" )

--[[########################################################
					Pointship function!
//////////////////////////////////////////////////////////--]]

function XPSys.core.RegisterPointshopFunc()
	if ( !PS ) then return end
	XPSys.core.Print( Color( 0, 255, 0 ), "Pointshop found!" )
	
	local Player = FindMetaTable("Player")
	
	function Player:PS_XPGivePoints( points )
		self.PS_Points = self.PS_Points + points
		self:PS_SendPoints()
		self:SendLua("GAMEMODE:AddNotify(\"Server send to you " .. points .. " points.\", NOTIFY_GENERAL, 7)")
	end

	function Player:PS_RankGivePoints( rank, points )
		self.PS_Points = self.PS_Points + points
		self:PS_SendPoints()
		self:SendLua("GAMEMODE:AddNotify(\"Server ranking has been paid compensation of " .. points .. " points.\", NOTIFY_GENERAL, 7)")
	end

	net.Receive('PS_BuyItem', function(length, ply)
		ply:PS_BuyItem(net.ReadString())
		for k, v in pairs( XPSys.XPHook ) do
			if ( v.Index ) then
				if ( v.Index == 1 ) then
					ply:AddXP( v.Cost )
					return
				end
			end
		end
	end)

	net.Receive('PS_SellItem', function(length, ply)
		ply:PS_SellItem(net.ReadString())
		for k, v in pairs( XPSys.XPHook ) do
			if ( v.Index ) then
				if ( v.Index == 2 ) then
					ply:AddXP( v.Cost )
					return
				end
			end
		end
	end)
end

hook.Add("Initialize", "XPSys_RegisterPointshop", function()
	XPSys.core.RegisterPointshopFunc()
end)

XPSys.core.ClientLoadfile( "CL_L7D_XPAdmin.lua" )
XPSys.core.ClientLoadfile( "CL_L7D_Web.lua" )
XPSys.core.ClientLoadfile( "CL_L7D_Font.lua" )
MsgC( Color( 0, 255, 0 ), "//-- L7D's XP System Loaded --//\n" )