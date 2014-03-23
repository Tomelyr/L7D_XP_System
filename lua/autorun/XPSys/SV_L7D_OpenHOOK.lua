
local KeyHook = {}
KeyHook[1] = "ShowHelp"
KeyHook[2] = "ShowTeam"
KeyHook[3] = "ShowSpare1"
KeyHook[4] = "ShowSpare2"

util.AddNetworkString("XPSys_MenuOpen")

function XPSys.core.OpenKeyHook( keyhook )
	if ( keyhook == "F1" ) then
		XPSys.core.Print( Color( 0, 255, 0 ), "Menu open key set : " .. keyhook )
		hook.Add(KeyHook[1], "XPSys.OpenKey.1", function( pl )
			net.Start("XPSys_MenuOpen")
			net.Send( pl )
		end)
	elseif ( keyhook == "F2" ) then
		XPSys.core.Print( Color( 0, 255, 0 ), "Menu open key set : " .. keyhook )
		hook.Add(KeyHook[2], "XPSys.OpenKey.2", function( pl )
			net.Start("XPSys_MenuOpen")
			net.Send( pl )
		end)
	elseif ( keyhook == "F3" ) then
		XPSys.core.Print( Color( 0, 255, 0 ), "Menu open key set : " .. keyhook )
		hook.Add(KeyHook[3], "XPSys.OpenKey.3", function( pl )
			net.Start("XPSys_MenuOpen")
			net.Send( pl )
		end)
	elseif ( keyhook == "F4" ) then
		XPSys.core.Print( Color( 0, 255, 0 ), "Menu open key set : " .. keyhook )
		hook.Add(KeyHook[4], "XPSys.OpenKey.4", function( pl )
			net.Start("XPSys_MenuOpen")
			net.Send( pl )
		end)
	else
		keyhook = "Non!"
		XPSys.core.Print( Color( 0, 255, 0 ), "Menu open key set : " .. keyhook )
	end
end

function XPSys.core.OpenKeyHook_Chat( pl, text )
	if ( !IsValid( pl ) ) then return end
	if ( !text ) then return end
	if ( !XPSys.Config.ChatOpenCommand ) then return end
	local text_lower = string.lower( text )
	local command_lower = string.lower( XPSys.Config.ChatOpenCommand )
	
	if ( command_lower == text_lower ) then
		net.Start("XPSys_MenuOpen")
		net.Send( pl )		
		return XPSys.Config.ChatOpenCommand_Output
	end
end

hook.Add("PlayerSay", "XPSys.OpenKeyHook_Chat", XPSys.core.OpenKeyHook_Chat)

hook.Add("Initialize", "XPSys.OpenKeyHook", function()
	XPSys.core.OpenKeyHook( XPSys.Config.OpenKey )
end)
