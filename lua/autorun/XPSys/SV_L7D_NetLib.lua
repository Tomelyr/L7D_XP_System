--[[########################################################
						L7D's XP System
				Copyright ( C ) 2014 ~ 'L7D'
		You have any question? steam friend invite me!
						ID : smhjyh2009
//////////////////////////////////////////////////////////--]]

local NetLib = {
	"XPSys_XPTableSend",
	"XPSys_XPTableSendCL",
	"XPSys_XP_Notice",
	"XPSys_XP_Add",
	"XPSys_XP_Take",
	"XPSys_XP_Set",
	"XPSys_XP_Init",
	"XPSys_Log_Delete",
	"XPSys_LogFile_Delete",
	"XPSys_Level_Set"
}

for i = 1, #NetLib do
	util.AddNetworkString( NetLib[i] )
end

net.Receive("XPSys_Log_Delete", function( len, cl )
	local target = net.ReadString()
	local count = net.ReadString()
	local tab = XPSys.LogHistory[ target ]
	
	for i = 1, #tab do
		if ( tab[i].Count == tonumber( count ) ) then
			table.remove( tab, i )
			XPSys.core.Print( Color( 255, 255, 0 ), "Remove log. [ " .. cl:SteamID() .. " ]" )
			XPSys.core.LogHistorySave()
			RunConsoleCommand("XPSys_SendCL")
			return
		end
	end
end)

net.Receive("XPSys_LogFile_Delete", function( len, cl )
	local target = net.ReadString()
		
	XPSys.LogHistory[ target ] = nil
	XPSys.core.LogHistorySave()
	RunConsoleCommand("XPSys_SendCL")
	XPSys.core.Print( Color( 255, 255, 0 ), "Remove log table. [ " .. cl:SteamID() .. " ]" )
end)

net.Receive("XPSys_Level_Set", function( len, cl )
	if ( XPSys.Config.XPAntiHackSystem_Enabled && !XPSys.Config.PermissionGroup( cl ) ) then  
		if ( ulx ) then
			RunConsoleCommand("ulx", "banid", cl:SteamID(), tostring( XPSys.Config.XPAntiHackSystem_BanTime ), XPSys.Config.XPAntiHackSystem_BanReason )
		else
			cl:Ban( XPSys.Config.XPAntiHackSystem_BanTime, XPSys.Config.XPAntiHackSystem_BanReason )
		end
		XPSys.core.Log( "[* !IMPORTANT! *]Level hack detected, ban player : [ " .. cl:Name() .. " , " .. cl:SteamID() .. " , " .. cl:IPAddress() .. " ]" )
		XPSys.core.Print( Color( 255, 0, 0 ), "[Hack Detected]" .. cl:SteamID() .. " : Level Hack user detected, ban " .. XPSys.Config.XPAntiHackSystem_BanTime .. " minite." )
		return 
	end
	local steamID = net.ReadString()
	local value = net.ReadString()
	XPSys.core.LevelSetOffline( steamID, tonumber(value) )
	XPSys.core.Log( "Admin Level set run. { " .. steamID .. " } : [ " .. cl:Name() .. " , " .. cl:SteamID() .. " , " .. cl:IPAddress() .. " ]" )
end)

net.Receive("XPSys_XP_Init", function( len, cl )
	if ( XPSys.Config.XPAntiHackSystem_Enabled && !XPSys.Config.PermissionGroup( cl ) ) then  
		if ( ulx ) then
			RunConsoleCommand("ulx", "banid", cl:SteamID(), tostring( XPSys.Config.XPAntiHackSystem_BanTime ), XPSys.Config.XPAntiHackSystem_BanReason )
		else
			cl:Ban( XPSys.Config.XPAntiHackSystem_BanTime, XPSys.Config.XPAntiHackSystem_BanReason )
		end
		XPSys.core.Log( "[* !IMPORTANT! *]XP hack detected, ban player : [ " .. cl:Name() .. " , " .. cl:SteamID() .. " , " .. cl:IPAddress() .. " ]" )
		XPSys.core.Print( Color( 255, 0, 0 ), "[Hack Detected]" .. cl:SteamID() .. " : Hack user detected, ban " .. XPSys.Config.XPAntiHackSystem_BanTime .. " minite." )
		return 
	end
	RunConsoleCommand("XPSys_Initialization")
end)

net.Receive("XPSys_XP_Add", function( len, cl )
	if ( XPSys.Config.XPAntiHackSystem_Enabled && !XPSys.Config.PermissionGroup( cl ) ) then  
		if ( ulx ) then
			RunConsoleCommand("ulx", "banid", cl:SteamID(), tostring( XPSys.Config.XPAntiHackSystem_BanTime ), XPSys.Config.XPAntiHackSystem_BanReason )
		else
			cl:Ban( XPSys.Config.XPAntiHackSystem_BanTime, XPSys.Config.XPAntiHackSystem_BanReason )
		end
		XPSys.core.Log( "[* !IMPORTANT! *]XP hack detected, ban player : [ " .. cl:Name() .. " , " .. cl:SteamID() .. " , " .. cl:IPAddress() .. " ]" )
		XPSys.core.Print( Color( 255, 0, 0 ), "[Hack Detected]" .. cl:SteamID() .. " : Hack user detected, ban " .. XPSys.Config.XPAntiHackSystem_BanTime .. " minite." )
		return 
	end
	local steamID = net.ReadString()
	local value = net.ReadString()
	XPSys.core.XPAddOffline( steamID, tonumber(value) )
	XPSys.core.Log( "Admin XP add run. { " .. steamID .. " } : [ " .. cl:Name() .. " , " .. cl:SteamID() .. " , " .. cl:IPAddress() .. " ]" )
end)

net.Receive("XPSys_XP_Take", function( len, cl )
	if ( XPSys.Config.XPAntiHackSystem_Enabled && !XPSys.Config.PermissionGroup( cl ) ) then 
		if ( ulx ) then
			RunConsoleCommand("ulx", "banid", cl:SteamID(), tostring( XPSys.Config.XPAntiHackSystem_BanTime ), XPSys.Config.XPAntiHackSystem_BanReason )
		else
			cl:Ban( XPSys.Config.XPAntiHackSystem_BanTime, XPSys.Config.XPAntiHackSystem_BanReason )
		end
		XPSys.core.Log( "[* !IMPORTANT! *]XP hack detected, ban player : [ " .. cl:Name() .. " , " .. cl:SteamID() .. " , " .. cl:IPAddress() .. " ]" )
		XPSys.core.Print( Color( 255, 0, 0 ), "[Hack Detected]" .. cl:SteamID() .. " : Hack user detected, ban " .. XPSys.Config.XPAntiHackSystem_BanTime .. " minite." )
		return 
	end
	local steamID = net.ReadString()
	local value = net.ReadString()
	XPSys.core.XPTakeOffline( steamID, tonumber(value) )
	XPSys.core.Log( "Admin XP take run. { " .. steamID .. " } : [ " .. cl:Name() .. " , " .. cl:SteamID() .. " , " .. cl:IPAddress() .. " ]" )
end)

net.Receive("XPSys_XP_Set", function( len, cl )
	if ( XPSys.Config.XPAntiHackSystem_Enabled && !XPSys.Config.PermissionGroup( cl ) ) then 
		if ( ulx ) then
			RunConsoleCommand("ulx", "banid", cl:SteamID(), tostring( XPSys.Config.XPAntiHackSystem_BanTime ), XPSys.Config.XPAntiHackSystem_BanReason )
		else
			cl:Ban( XPSys.Config.XPAntiHackSystem_BanTime, XPSys.Config.XPAntiHackSystem_BanReason )
		end
		XPSys.core.Log( "[* !IMPORTANT! *]XP hack detected, ban player : [ " .. cl:Name() .. " , " .. cl:SteamID() .. " , " .. cl:IPAddress() .. " ]" )
		XPSys.core.Print( Color( 255, 0, 0 ), "[Hack Detected]" .. cl:SteamID() .. " : Hack user detected, ban " .. XPSys.Config.XPAntiHackSystem_BanTime .. " minite." )
		return 
	end
	local steamID = net.ReadString()
	local value = net.ReadString()
	XPSys.core.XPSetOffline( steamID, tonumber(value) )
	XPSys.core.Log( "Admin XP set run. : { " .. steamID .. " } [ " .. cl:Name() .. " , " .. cl:SteamID() .. " , " .. cl:IPAddress() .. " ]" )
end)