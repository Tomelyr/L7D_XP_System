
--[[########################################################
						L7D's XP System
				Copyright ( C ) 2014 ~ 'L7D'
		You have any question? steam friend invite me!
						ID : smhjyh2009
//////////////////////////////////////////////////////////--]]

include( "SH_Config.lua" )
include( "CL_L7D_Font.lua" )

XPSys = XPSys or {}
XPSys.Client32 = XPSys.Client32 or {}
XPSys.XPCL = XPSys.XPCL or {}
XPSys.XPLvlCL = XPSys.XPLvlCL or {}
XPSys.XPHookCL = XPSys.XPHookCL or {}
XPSys.LevelCL = XPSys.LevelCL or {}
XPSys.LogHistoryCL = XPSys.LogHistoryCL or {}

concommand.Add( XPSys.Config.MenuShowConsoleCommand, function()
	XPSys.LevelMainPanel()
end)

usermessage.Hook("XPSys_RankNoticeCall", function( data )
	XPSys.RankNoticePanel()
end)

net.Receive("XPSys_MenuOpen", function( len, cl )
	XPSys.LevelMainPanel()
end)

net.Receive("XPSys_XP_Notice", function( len, cl )
	local data = net.ReadTable() or {}
	XPSys.Client32.XPNotice( data )
end)

net.Receive("XPSys_XPTableSendCL", function( len, cl )
	XPSys.XPCL = net.ReadTable()
	XPSys.XPLvlCL = net.ReadTable()
	XPSys.XPHookCL = net.ReadTable()
	XPSys.LevelCL = net.ReadTable()
	XPSys.LogHistoryCL = net.ReadTable()
end)

include( "CL_L7D_Web.lua" )
include( "CL_L7D_XPAdmin.lua" )

function XPSys.RankNoticePanel()
	local LP = LocalPlayer()
	local scrW, scrH = ScrW(), ScrH()
	local RankNotice_Panel_w, RankNotice_Panel_h = scrW * 0.45, scrH * 0.5
	local RankNotice_Panel_x, RankNotice_Panel_y = scrW + RankNotice_Panel_w, (scrH * 0.5) - (RankNotice_Panel_h / 2);
	local DeleteTimeLeft = 10
	
	table.sort( XPSys.XPCL, function( a, b )
		return a.XP > b.XP
	end)
	
	if ( !RankNotice_Panel ) then
	
	surface.PlaySound("buttons/button5.wav")
	
	RankNotice_Panel = vgui.Create("DFrame")
	RankNotice_Panel:SetPos( RankNotice_Panel_x ,  RankNotice_Panel_y )
	RankNotice_Panel:MoveTo( scrW * 0.75 - RankNotice_Panel_w / 2, RankNotice_Panel_y, 1, 0 )
	RankNotice_Panel:SetSize( RankNotice_Panel_w, RankNotice_Panel_h )
	RankNotice_Panel:SetTitle( "" )
	RankNotice_Panel:SetDraggable( false )
	RankNotice_Panel:ShowCloseButton( false )
	RankNotice_Panel.Paint = function()
		local x = RankNotice_Panel_x
		local y = RankNotice_Panel_y
		local w = RankNotice_Panel_w
		local h = RankNotice_Panel_h
			
		surface.SetDrawColor( 255, 255, 255, 230 )
		surface.DrawRect( 0, 0, w, h )

		draw.SimpleText( "Rank Notice", "XP_Notice_Title2", w * 0.5, h * 0.1 / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( DeleteTimeLeft, "XP_Notice_Percent", w * 0.95, h * 0.1 / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
	end
	
	local RankList = vgui.Create( "DPanelList", RankNotice_Panel )
	RankList:SetPos( RankNotice_Panel_w / 2 - RankNotice_Panel_w * 0.98 / 2, RankNotice_Panel_h * 0.1 )
	RankList:SetSize( RankNotice_Panel_w , RankNotice_Panel_h * 0.8 )
	RankList:SetSpacing( 3 )
	RankList:EnableHorizontal( false )
	RankList:EnableVerticalScrollbar( true )
	RankList.Paint = function()
	end
	
	function RankListClear()
		RankList:Clear()
	end
	
	function RankListAdd()
		for k, v in pairs( XPSys.XPCL ) do
				
			local list = vgui.Create( "DPanel", RankNotice_Panel )    
			list:SetSize( RankList:GetWide(), 60 ) 
			list.Paint = function()
				local w, h = list:GetWide(), list:GetTall()
				if ( k >= 4 ) then
					return
				end
				
				if ( k == 1 ) then
					surface.SetDrawColor( 255, 185, 15, 200 )
					surface.DrawRect( 0, 0, w, h )
				elseif ( k == 2 ) then
					surface.SetDrawColor( 205, 200, 177, 200 )
					surface.DrawRect( 0, 0, w, h )				
				elseif ( k == 3 ) then
					surface.SetDrawColor( 139, 90, 0, 200 )
					surface.DrawRect( 0, 0, w, h )				
				end
				
				if ( k == 1 ) then
					draw.SimpleText( "1st", "XP_Notice_Title", w * 0.02, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					draw.SimpleText( "Gold Rank", "XP_Notice_Text", w * 0.95, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				elseif ( k == 2 ) then
					draw.SimpleText( "2st", "XP_Notice_Title", w * 0.02, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					draw.SimpleText( "Silver Rank", "XP_Notice_Text", w * 0.95, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				elseif ( k == 3 ) then
					draw.SimpleText( "3st", "XP_Notice_Title", w * 0.02, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					draw.SimpleText( "Bronze Rank", "XP_Notice_Text", w * 0.95, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				end		
				
				if ( k <= 3 ) then
					if ( v.Name ) then
						draw.SimpleText( v.Name, "XP_Notice_Text", w * 0.2, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					elseif ( v.SteamID ) then
						draw.SimpleText( v.SteamID, "XP_Notice_Text", w * 0.2, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( "Rank system error!", "XP_Notice_Text", w * 0.2, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					end
				end
			end
			
			if ( k <= 3 ) then
				RankList:AddItem( list )
			end
		end
	end
	
	RankListClear()
	RankListAdd()
	
	else
		if ( IsValid( RankNotice_Panel ) ) then
			RankNotice_Panel:Remove()
			RankNotice_Panel = nil		
		end
	end
	timer.Create("XPSys_RankNoticeDeleteTimeLeft", 1, 0, function()
		DeleteTimeLeft = DeleteTimeLeft - 1
	end)
	 
	timer.Create("XPSys_RankNoticeDelete", 1, 0, function()
		if ( DeleteTimeLeft <= 0 ) then
			if ( IsValid( RankNotice_Panel ) ) then
				surface.PlaySound("buttons/button1.wav")
				RankNotice_Panel:MoveTo( scrW + RankNotice_Panel_w, RankNotice_Panel_y, 0.7, 0 )
				timer.Simple( 0.7, function()
					RankNotice_Panel:Remove()
					RankNotice_Panel = nil			
				end)
			else
				if ( timer.Exists("XPSys_RankNoticeDelete") ) then
					timer.Destroy( "XPSys_RankNoticeDelete" )
				end
			end
		end
	end)
end

function XPSys.Client32.XPNotice( tab )
	local scrW, scrH = ScrW(), ScrH()
	local Start = CurTime()
	local W, H = scrW * 0.4, scrH * 0.2
	local X, Y = scrW / 2 - W / 2, scrH
	
	hook.Remove("HUDPaint", "XPSys_XPNoticeHook")
	
	surface.PlaySound("buttons/button1.wav")
	hook.Add("HUDPaint", "XPSys_XPNoticeHook", function( )
		local Out = CurTime() - Start
		if ( Out > 7 ) then
			Y = math.Approach( Y, scrH + H, 5 )
		else
			Y = math.Approach( Y, scrH * 0.85 - H / 2, 5 )
		end	
		
		surface.SetDrawColor( 0, 0, 0, 235 ) 
		surface.DrawRect( X, Y, W, H )
		
		draw.SimpleText( "Congratulation!", "XP_Notice_Title", X + W / 2, Y, Color( 255, 255, 255, 255 ), 1)
		draw.SimpleText( "Level UP!", "XP_Notice_Text", X + W / 2, Y + H * 0.4, Color( 255, 255, 255, 255 ), 1)
		
		draw.SimpleText( "You are now " .. tab.NextLevel .. " Level!", "XP_Notice_Text", X + W / 2, Y + H * 0.7, Color( 255, 255, 255, 255 ), 1)
		if ( Out > 7 + 3 ) then
			hook.Remove( "HUDPaint", "XPSys_XPNoticeHook" )
			return
		end		
	end)
end

function XPSys.Client32.FindPlayer( name )
	local matches = {}
	for k, v in pairs( XPSys.GlobalRankCLSave ) do
		if ( v.Name:lower():match( name:lower() ) ) then
			table.insert( matches, v )
		end
	end
	if ( #matches == 0 ) then
		return false
	end
	return matches
end

function XPSys.LvlDetailPanel()
	local LP = LocalPlayer()
	local scrW, scrH = ScrW(), ScrH()
	local LvlDetail_Panel_w, LvlDetail_Panel_h = scrW * 0.7, scrH * 0.9
	local LvlDetail_Panel_x, LvlDetail_Panel_y = (scrW * 0.5) - (LvlDetail_Panel_w / 2), (scrH * 0.5) - (LvlDetail_Panel_h / 2);
	
	if ( !LvlDetail_Panel ) then
	LvlDetail_Panel = vgui.Create("DFrame")
	LvlDetail_Panel:SetPos( LvlDetail_Panel_x ,  LvlDetail_Panel_y )
	LvlDetail_Panel:SetAlpha( 0 )
	LvlDetail_Panel:AlphaTo( 255, 0.3, 0 )
	LvlDetail_Panel:SetSize( LvlDetail_Panel_w, LvlDetail_Panel_h )
	LvlDetail_Panel:SetTitle( "" )
	LvlDetail_Panel:SetDraggable( false )
	LvlDetail_Panel:ShowCloseButton( false )
	LvlDetail_Panel:MakePopup()
	LvlDetail_Panel.Paint = function()
		local x = LvlDetail_Panel_x
		local y = LvlDetail_Panel_y
		local w = LvlDetail_Panel_w
		local h = LvlDetail_Panel_h
			
		surface.SetDrawColor( 255, 255, 255, 230 )
		surface.DrawRect( 0, 0, w, h )

		draw.SimpleText( "Level List", "XP_Notice_Title2", w * 0.5, h * 0.1 / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	
	local LvlList = vgui.Create( "DPanelList", LvlDetail_Panel )
	LvlList:SetPos( LvlDetail_Panel_w / 2 - LvlDetail_Panel_w * 0.98 / 2, LvlDetail_Panel_h * 0.1 )
	LvlList:SetSize( LvlDetail_Panel_w * 0.98 , LvlDetail_Panel_h * 0.8 )
	LvlList:SetSpacing( 3 )
	LvlList:EnableHorizontal( false )
	LvlList:EnableVerticalScrollbar( true )
	LvlList.Paint = function()
	end
	
	function LvlListClear()
		LvlList:Clear()
	end
	
	function LvlListAdd()
		for k, v in pairs( XPSys.XPLvlCL ) do
				
			local list = vgui.Create( "DPanel", LvlDetail_Panel )    
			list:SetSize( LvlList:GetWide(), 60 ) 
			list.Paint = function()
				local w, h = list:GetWide(), list:GetTall()
				if ( LP:GetNWInt( "Level" ) == v.Index ) then
					surface.SetDrawColor( 10, 200, 10, 100 )
					surface.DrawRect( 0, 0, w, h )
				elseif ( LP:GetNWInt( "Level" ) > v.Index ) then
					surface.SetDrawColor( 10, 200, 10, 100 )
					surface.DrawRect( 0, 0, w, h )	
				elseif ( LP:GetNWInt( "Level" ) < v.Index ) then
					surface.SetDrawColor( 200, 10, 10, 100 )
					surface.DrawRect( 0, 0, w, h )								
				end
				
				draw.SimpleText( v.Index .. " Level", "XP_Notice_Text3", w * 0.02, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				if ( XPSys.Config.UseRewardSystem ) then
					draw.SimpleText( "Reward : " .. v.Reward .. "", "XP_Notice_Text3", w * 0.98, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				end
				draw.SimpleText( v.XP .. " XP Over", "XP_Notice_Text3", w * 0.3, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			end
			
			LvlList:AddItem( list )
		end
	end
	
	LvlListClear()
	LvlListAdd()
	
	local Bx, By = (LvlDetail_Panel_w * 0.5) - (LvlDetail_Panel_w * 0.98 / 2), (LvlDetail_Panel_h * 0.95) - (50 / 2); -- 0.3

	local CloseButton = vgui.Create( "DButton", LvlDetail_Panel )    
	CloseButton:SetText( "Close" )  
	CloseButton:SetFont("XP_Notice_Text3")
	CloseButton:SetPos( Bx, By )  
	CloseButton:SetColor(Color( 0, 0, 0, 255 ))
	CloseButton:SetSize( LvlDetail_Panel_w * 0.98, 50 ) 
	CloseButton.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		LvlDetail_Panel:Remove()
		LvlDetail_Panel = nil
	end
	CloseButton.Paint = function()
		local w = CloseButton:GetWide()
		local h = CloseButton:GetTall()
		
		surface.SetDrawColor( 100, 100, 100, 30 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	else
		LvlDetail_Panel:Remove()
		LvlDetail_Panel = nil
	end
end

function XPSys.RankPanel()
	local LP = LocalPlayer()
	local scrW, scrH = ScrW(), ScrH()
	local RankDetail_Panel_w, RankDetail_Panel_h = scrW * 0.8, scrH
	local RankDetail_Panel_x, RankDetail_Panel_y = (scrW * 0.5) - (RankDetail_Panel_w / 2), (scrH * 0.5) - (RankDetail_Panel_h / 2);
	local Real_TimeTimeLeft = 10
	
	table.sort( XPSys.XPCL, function( a, b )
		return a.XP > b.XP
	end)
	
	if ( !RankDetail_Panel ) then
	RankDetail_Panel = vgui.Create("DFrame")
	RankDetail_Panel:SetPos( RankDetail_Panel_x ,  RankDetail_Panel_y )
	RankDetail_Panel:SetAlpha( 0 )
	RankDetail_Panel:AlphaTo( 255, 0.3, 0 )
	RankDetail_Panel:SetSize( RankDetail_Panel_w, RankDetail_Panel_h )
	RankDetail_Panel:SetTitle( "" )
--	RankDetail_Panel:Center()
	RankDetail_Panel:SetDraggable( false )
	RankDetail_Panel:ShowCloseButton( false )
	RankDetail_Panel:MakePopup()
	RankDetail_Panel.Paint = function()
		local x = RankDetail_Panel_x
		local y = RankDetail_Panel_y
		local w = RankDetail_Panel_w
		local h = RankDetail_Panel_h
			
		surface.SetDrawColor( 255, 255, 255, 230 )
		surface.DrawRect( 0, 0, w, h )

		draw.SimpleText( "Rank", "XP_Notice_Title2", w * 0.5, h * 0.1 / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( Real_TimeTimeLeft .. " (sec) update.", "XP_Notice_Text3", w * 0.95, h * 0.1 / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		
	end
	
	local RankList = vgui.Create( "DPanelList", RankDetail_Panel )
	RankList:SetPos( RankDetail_Panel_w / 2 - RankDetail_Panel_w * 0.98 / 2, RankDetail_Panel_h * 0.1 )
	RankList:SetSize( RankDetail_Panel_w * 0.98 , RankDetail_Panel_h * 0.8 )
	RankList:SetSpacing( 3 )
	RankList:EnableHorizontal( false )
	RankList:EnableVerticalScrollbar( true )
--	RankList:SetNoSizing( false )
	RankList.Paint = function()
	end
	
	function RankListClear()
		RankList:Clear()
	end
	
	function RankListAdd()
		local delta = 0
		for k, v in pairs( XPSys.XPCL ) do
				
			local list = vgui.Create( "DPanel", RankDetail_Panel )    
			list:SetSize( RankList:GetWide(), 40 ) 
			list:SetAlpha( 0 )
			list:AlphaTo( 255, 0.1, delta )
			delta = delta + 0.03
			list.Paint = function()
				local w, h = list:GetWide(), list:GetTall()
				
				if ( k == 1 ) then
					surface.SetDrawColor( 255, 185, 15, 200 )
					surface.DrawRect( 0, 0, w, h )
				elseif ( k == 2 ) then
					surface.SetDrawColor( 205, 200, 177, 200 )
					surface.DrawRect( 0, 0, w, h )				
				elseif ( k == 3 ) then
					surface.SetDrawColor( 139, 90, 0, 200 )
					surface.DrawRect( 0, 0, w, h )	
				else
					surface.SetDrawColor( 10, 10, 10, 30 )
					surface.DrawRect( 0, 0, w, h )					
				end
				if ( k == 1 ) then
					draw.SimpleText( "1st", "XP_Notice_Title", w * 0.02, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					draw.SimpleText( "Gold Rank", "XP_Notice_Text3", w * 0.98, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
					if ( v.Level ) then
						draw.SimpleText( v.Level .. " Level", "XP_Notice_Percent", w * 0.1, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					end
				elseif ( k == 2 ) then
					draw.SimpleText( "2st", "XP_Notice_Title", w * 0.02, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					draw.SimpleText( "Silver Rank", "XP_Notice_Text3", w * 0.98, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
					if ( v.Level ) then
						draw.SimpleText( v.Level .. " Level", "XP_Notice_Percent", w * 0.1, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					end
				elseif ( k == 3 ) then
					draw.SimpleText( "3st", "XP_Notice_Title", w * 0.02, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					draw.SimpleText( "Bronze Rank", "XP_Notice_Text3", w * 0.98, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
					if ( v.Level ) then
						draw.SimpleText( v.Level .. " Level", "XP_Notice_Percent", w * 0.1, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					end
				else
					if ( v.Level ) then
						draw.SimpleText( v.Level .. " Level", "XP_Notice_Percent", w * 0.1, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					end
					draw.SimpleText( k .. "st", "XP_Notice_Text3", w * 0.02, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				end		

				if ( v.Name ) then
					draw.SimpleText( v.Name, "XP_Notice_Text3", w * 0.2, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				elseif ( v.SteamID ) then
					draw.SimpleText( v.SteamID, "XP_Notice_Text3", w * 0.2, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				else
					draw.SimpleText( "System Error", "XP_Notice_Text3", w * 0.2, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				end
				
				if ( v.XP ) then
					draw.SimpleText( math.Round( v.XP ) .. " XP", "XP_Notice_Text3", w * 0.8, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				else
					draw.SimpleText( "System Error", "XP_Notice_Text3", w * 0.9, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				end
			end
			
			RankList:AddItem( list )
		end
	end
	
	RankListClear()
	RankListAdd()
	
	local Bx, By = (RankDetail_Panel_w * 0.5) - (RankDetail_Panel_w * 0.98 / 2), (RankDetail_Panel_h * 0.95) - (50 / 2); -- 0.3

	local CloseButton = vgui.Create( "DButton", RankDetail_Panel )    
	CloseButton:SetText( "Close" )  
	CloseButton:SetFont("XP_Notice_Text3")
	CloseButton:SetPos( Bx, By )  
	CloseButton:SetColor(Color( 0, 0, 0, 255 ))
	CloseButton:SetSize( RankDetail_Panel_w * 0.98, 50 ) 
	CloseButton.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		RankDetail_Panel:Remove()
		RankDetail_Panel = nil
	end
	CloseButton.Paint = function()
		local w = CloseButton:GetWide()
		local h = CloseButton:GetTall()
		
		surface.SetDrawColor( 100, 100, 100, 30 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	timer.Create("XPSys_RankReal_TimeRefresh", 1, 0, function()
		if ( IsValid( RankDetail_Panel ) ) then
			if ( Real_TimeTimeLeft <= 1 ) then
				Real_TimeTimeLeft = 10
				RankListClear()
				RankListAdd()
			else
				Real_TimeTimeLeft = Real_TimeTimeLeft - 1
			end
		else
			if ( timer.Exists("XPSys_RankReal_TimeRefresh") ) then
				timer.Destroy("XPSys_RankReal_TimeRefresh")
			end
		end
		
		
	end)
	
	else
		RankDetail_Panel:Remove()
		RankDetail_Panel = nil
	end

end

function XPSys.RankReward()
	local LP = LocalPlayer()
	local scrW, scrH = ScrW(), ScrH()
	local RankRewardList_w, RankRewardList_h = scrW * 0.7, scrH * 0.9
	local RankRewardList_x, RankRewardList_y = (scrW * 0.5) - (RankRewardList_w / 2), (scrH * 0.5) - (RankRewardList_h / 2);
	
	if ( !RankRewardList ) then
	RankRewardList = vgui.Create("DFrame")
	RankRewardList:SetPos( RankRewardList_x ,  RankRewardList_y )
	RankRewardList:SetAlpha( 0 )
	RankRewardList:AlphaTo( 255, 0.3, 0 )
	RankRewardList:SetSize( RankRewardList_w, RankRewardList_h )
	RankRewardList:SetTitle( "" )
	RankRewardList:SetDraggable( false )
	RankRewardList:ShowCloseButton( false )
	RankRewardList:MakePopup()
	RankRewardList.Paint = function()
		local x = RankRewardList_x
		local y = RankRewardList_y
		local w = RankRewardList_w
		local h = RankRewardList_h
			
		surface.SetDrawColor( 255, 255, 255, 230 )
		surface.DrawRect( 0, 0, w, h )

		draw.SimpleText( "Rank Reward List", "XP_Notice_Title2", w * 0.5, h * 0.1 / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		if ( XPSys.Config.UseRewardSystem ) then
			draw.SimpleText( "Reward Time : 100 (sec)", "XP_Notice_SubTitle", w * 0.98, h * 0.1 / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		end
	end
	
	local RewardListRank = vgui.Create( "DPanelList", RankRewardList )
	RewardListRank:SetPos( RankRewardList_w / 2 - RankRewardList_w * 0.98 / 2, RankRewardList_h * 0.1 )
	RewardListRank:SetSize( RankRewardList_w * 0.98 , RankRewardList_h * 0.8 )
	RewardListRank:SetSpacing( 3 )
	RewardListRank:EnableHorizontal( false )
	RewardListRank:EnableVerticalScrollbar( true )
	RewardListRank.Paint = function()
		local w, h = RewardListRank:GetWide(), RewardListRank:GetTall()
		if ( !XPSys.Config.UseRewardSystem ) then
			draw.SimpleText( "Not enabled reward system.", "XP_Notice_Text3", w * 0.5, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	
	function RewardListRankClear()
		RewardListRank:Clear()
	end
	
	function RewardListRankAdd()
		if ( !XPSys.Config.UseRewardSystem ) then
			return
		end
		for k, v in pairs( XPSys.Config.RankReward ) do
				
			local list = vgui.Create( "DPanel", RankRewardList )    
			list:SetSize( RewardListRank:GetWide(), 70 ) 
			list.Paint = function()
				local w, h = list:GetWide(), list:GetTall()
				if ( k == 1 ) then
					surface.SetDrawColor( 255, 185, 15, 200 )
					surface.DrawRect( 0, 0, w, h )
					draw.SimpleText( "Gold Rank", "XP_Notice_Text3", w * 0.5, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				elseif ( k == 2 ) then
					surface.SetDrawColor( 205, 200, 177, 200 )
					surface.DrawRect( 0, 0, w, h )	
					draw.SimpleText( "Silver Rank", "XP_Notice_Text3", w * 0.5, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				elseif ( k == 3 ) then
					surface.SetDrawColor( 139, 90, 0, 200 )
					surface.DrawRect( 0, 0, w, h )	
					draw.SimpleText( "Bronze Rank", "XP_Notice_Text3", w * 0.5, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
				
				draw.SimpleText( k .. "st", "XP_Notice_Title", w * 0.02, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( v .. " Reward", "XP_Notice_Text3", w * 0.98, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			end
			
			RewardListRank:AddItem( list )
		end
	end
	
	RewardListRankClear()
	RewardListRankAdd()
	
	local Bx, By = (RankRewardList_w * 0.5) - (RankRewardList_w * 0.98 / 2), (RankRewardList_h * 0.95) - (50 / 2); -- 0.3

	local CloseButton = vgui.Create( "DButton", RankRewardList )    
	CloseButton:SetText( "Close" )  
	CloseButton:SetFont("XP_Notice_Text3")
	CloseButton:SetPos( Bx, By )  
	CloseButton:SetColor(Color( 0, 0, 0, 255 ))
	CloseButton:SetSize( RankRewardList_w * 0.98, 50 ) 
	CloseButton.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		RankRewardList:Remove()
		RankRewardList = nil
	end
	CloseButton.Paint = function()
		local w = CloseButton:GetWide()
		local h = CloseButton:GetTall()
		
		surface.SetDrawColor( 100, 100, 100, 30 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	else
		RankRewardList:Remove()
		RankRewardList = nil
	end

end

function XPSys.AnotherPLYDetailPanel()
	local LP = LocalPlayer()
	local scrW, scrH = ScrW(), ScrH()
	local AnotherPLYPercent_Panel_w, AnotherPLYPercent_Panel_h = scrW * 0.8, scrH * 0.9
	local AnotherPLYPercent_Panel_x, AnotherPLYPercent_Panel_y = (scrW * 0.5) - (AnotherPLYPercent_Panel_w / 2), (scrH * 0.5) - (AnotherPLYPercent_Panel_h / 2);
	
	table.sort( XPSys.XPCL, function( a, b )
		return a.XP > b.XP
	end)
	
	if ( !AnotherPLYPercent_Panel ) then
	AnotherPLYPercent_Panel = vgui.Create("DFrame")
	AnotherPLYPercent_Panel:SetPos( AnotherPLYPercent_Panel_x ,  AnotherPLYPercent_Panel_y )
	AnotherPLYPercent_Panel:SetAlpha( 0 )
	AnotherPLYPercent_Panel:AlphaTo( 255, 0.3, 0 )
	AnotherPLYPercent_Panel:SetSize( AnotherPLYPercent_Panel_w, AnotherPLYPercent_Panel_h )
	AnotherPLYPercent_Panel:SetTitle( "" )
	AnotherPLYPercent_Panel:SetDraggable( false )
	AnotherPLYPercent_Panel:ShowCloseButton( false )
	AnotherPLYPercent_Panel:MakePopup()
	AnotherPLYPercent_Panel.Paint = function()
		local x = AnotherPLYPercent_Panel_x
		local y = AnotherPLYPercent_Panel_y
		local w = AnotherPLYPercent_Panel_w
		local h = AnotherPLYPercent_Panel_h
			
		surface.SetDrawColor( 255, 255, 255, 230 )
		surface.DrawRect( 0, 0, w, h )

		draw.SimpleText( "Other Users", "XP_Notice_Title2", w * 0.5, h * 0.1 / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	
	local DetailList = vgui.Create( "DPanelList", AnotherPLYPercent_Panel )
	DetailList:SetPos( AnotherPLYPercent_Panel_w / 2 - AnotherPLYPercent_Panel_w * 0.98 / 2, AnotherPLYPercent_Panel_h * 0.1 )
	DetailList:SetSize( AnotherPLYPercent_Panel_w * 0.98 , AnotherPLYPercent_Panel_h * 0.8 )
	DetailList:SetSpacing( 3 )
	DetailList:EnableHorizontal( false )
	DetailList:EnableVerticalScrollbar( true )
	DetailList.Paint = function()
	end
	
	local function DetailListClear()
		DetailList:Clear()
	end
	
	local function DetailListAdd()
		for k, v in pairs( XPSys.XPCL ) do
				
			local list = vgui.Create( "DPanel", AnotherPLYPercent_Panel )    
			list:SetSize( DetailList:GetWide(), 70 ) 
			list.Paint = function()
				local w, h = list:GetWide(), list:GetTall()
				surface.SetDrawColor( 10, 10, 10, 50 )
				surface.DrawRect( 0, 0, w, h )
				
				draw.SimpleText( v.Level .. " Level", "XP_Notice_Text3", w * 0.02, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				
				draw.SimpleText( v.Name, "XP_Notice_Text3", w * 0.2, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

				draw.SimpleText( math.Round( v.XP ) .. " XP", "XP_Notice_Percent", w * 0.98, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			end
			
			DetailList:AddItem( list )
		end
	end

	DetailListClear()
	DetailListAdd()
	
	local Bx, By = (AnotherPLYPercent_Panel_w * 0.5) - (AnotherPLYPercent_Panel_w * 0.98 / 2), (AnotherPLYPercent_Panel_h * 0.95) - (50 / 2); -- 0.3

	local CloseButton = vgui.Create( "DButton", AnotherPLYPercent_Panel )    
	CloseButton:SetText( "Close" )  
	CloseButton:SetFont("XP_Notice_Text3")
	CloseButton:SetPos( Bx, By )  
	CloseButton:SetColor(Color( 0, 0, 0, 255 ))
	CloseButton:SetSize( AnotherPLYPercent_Panel_w * 0.98, 50 ) 
	CloseButton.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		AnotherPLYPercent_Panel:Remove()
		AnotherPLYPercent_Panel = nil
	end
	CloseButton.Paint = function()
		local w = CloseButton:GetWide()
		local h = CloseButton:GetTall()
		
		surface.SetDrawColor( 100, 100, 100, 30 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	else
		AnotherPLYPercent_Panel:Remove()
		AnotherPLYPercent_Panel = nil
	end

end

function XPSys.DetailPanel()
	local LP = LocalPlayer()
	local scrW, scrH = ScrW(), ScrH()
	local Detail_Panel_w, Detail_Panel_h = scrW * 0.7, scrH * 0.9
	local Detail_Panel_x, Detail_Panel_y = (scrW * 0.5) - (Detail_Panel_w / 2), (scrH * 0.5) - (Detail_Panel_h / 2);
	
	if ( !Detail_Panel ) then
	Detail_Panel = vgui.Create("DFrame")
	Detail_Panel:SetPos( Detail_Panel_x ,  Detail_Panel_y )
	Detail_Panel:SetAlpha( 0 )
	Detail_Panel:AlphaTo( 255, 0.3, 0 )
	Detail_Panel:SetSize( Detail_Panel_w, Detail_Panel_h )
	Detail_Panel:SetTitle( "" )
	Detail_Panel:SetDraggable( false )
	Detail_Panel:ShowCloseButton( false )
	Detail_Panel:MakePopup()
	Detail_Panel.Paint = function()
		local x = Detail_Panel_x
		local y = Detail_Panel_y
		local w = Detail_Panel_w
		local h = Detail_Panel_h
			
		surface.SetDrawColor( 255, 255, 255, 230 )
		surface.DrawRect( 0, 0, w, h )

		draw.SimpleText( "List of Conditions", "XP_Notice_Title2", w * 0.5, h * 0.1 / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	
	local DetailList = vgui.Create( "DPanelList", Detail_Panel )
	DetailList:SetPos( Detail_Panel_w / 2 - Detail_Panel_w * 0.98 / 2, Detail_Panel_h * 0.1 )
	DetailList:SetSize( Detail_Panel_w * 0.98 , Detail_Panel_h * 0.8 )
	DetailList:SetSpacing( 3 )
	DetailList:EnableHorizontal( false )
	DetailList:EnableVerticalScrollbar( true )
	DetailList.Paint = function()
	end
	
	function DetailListClear()
		DetailList:Clear()
	end
	
	function DetailListAdd()
		for k, v in pairs( XPSys.XPHookCL ) do
				
			local list = vgui.Create( "DPanel", Detail_Panel )    
			list:SetSize( DetailList:GetWide(), 70 ) 
			list.Paint = function()
				local w, h = list:GetWide(), list:GetTall()
				surface.SetDrawColor( 10, 10, 10, 50 )
				surface.DrawRect( 0, 0, w, h )
				
				draw.SimpleText( v.Title, "XP_Notice_Text3", w * 0.02, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				
				draw.SimpleText( v.Detail, "XP_Notice_Text3", w * 0.4, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				
				draw.SimpleText( v.Cost .. " XP", "XP_Notice_Percent", w * 0.98, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			end
			
			DetailList:AddItem( list )
		end
	end
	
	DetailListClear()
	DetailListAdd()
	
	local Bx, By = (Detail_Panel_w * 0.5) - (Detail_Panel_w * 0.98 / 2), (Detail_Panel_h * 0.95) - (50 / 2); -- 0.3

	local CloseButton = vgui.Create( "DButton", Detail_Panel )    
	CloseButton:SetText( "Close" )  
	CloseButton:SetFont("XP_Notice_Text3")
	CloseButton:SetPos( Bx, By )  
	CloseButton:SetColor(Color( 0, 0, 0, 255 ))
	CloseButton:SetSize( Detail_Panel_w * 0.98, 50 ) 
	CloseButton.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		Detail_Panel:Remove()
		Detail_Panel = nil
	end
	CloseButton.Paint = function()
		local w = CloseButton:GetWide()
		local h = CloseButton:GetTall()
		
		surface.SetDrawColor( 100, 100, 100, 30 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	else
		Detail_Panel:Remove()
		Detail_Panel = nil
	end

end

	
function XPSys.NextXPCheck()
	local lastXP = 0
	for i = #XPSys.LevelCL, #XPSys.LevelCL do
		lastXP = XPSys.LevelCL[i].XP
	end
	if ( #XPSys.XPLvlCL != 0 ) then
		for k, v in pairs( XPSys.XPLvlCL ) do
			if ( LocalPlayer():GetNWInt( "XP" ) < lastXP ) then
				if ( LocalPlayer():GetNWInt( "XP" ) < v.XP ) then
					return v.XP
				end
			else
				return "MAX"
			end
		end	
	else
		return 0
	end
end

function XPSys.LevelMainPanel()
	local LP = LocalPlayer()
	local scrW, scrH = ScrW(), ScrH()
	local LevelMain_w, LevelMain_h = scrW * 0.7, scrH * 0.7
	local LevelMain_x, LevelMain_y = (scrW * 0.5) - (LevelMain_w / 2), (scrH * 0.5) - (LevelMain_h / 2);
	local PlyXPTab = {}
	local NextXP = XPSys.NextXPCheck()
	local PercentXP = 0
	local PercentXPPer = 0
	
	if ( NextXP != "MAX" ) then
		Percent = LocalPlayer():GetNWInt( "XP" ) / NextXP
		Percent = math.min( Percent, 1 )	
	else
		Percent = 100
	end

	if ( !LevelMain ) then
	LevelMain = vgui.Create("DFrame")
	LevelMain:SetPos( LevelMain_x , ScrH() + LevelMain_h )
	LevelMain:MoveTo( ScrW() / 2 - LevelMain_w / 2, LevelMain_y, 0.3, 0 )
	LevelMain:SetSize( LevelMain_w, LevelMain_h )
	LevelMain:SetTitle( "" )
	LevelMain:SetDraggable( false )
	LevelMain:ShowCloseButton( false )
	LevelMain:MakePopup()
	LevelMain.Paint = function()
		local x = LevelMain_x
		local y = LevelMain_y
		local w = LevelMain_w
		local h = LevelMain_h

		for k, v in pairs( XPSys.XPCL ) do
			if ( v.SteamID == LP:SteamID() ) then
				PlyXPTab = v
			end
		end

		PercentXP = math.Approach( PercentXP, Percent, 0.008 )
		PercentXPPer = math.Approach( PercentXPPer, Percent, 0.008 )
		
		surface.SetDrawColor( 255, 255, 255, 230 )
		surface.DrawRect( 0, 0, w, h )

		if ( NextXP != "MAX" ) then
			if ( PlyXPTab.Level ) then
				draw.SimpleText( "Level", "XP_Notice_MaxTitle", w * 0.5, h * 0.1 / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				draw.SimpleText( PlyXPTab.Level, "XP_Notice_Title", w * 0.5, h * 0.13, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( "Level", "XP_Notice_MaxTitle", w * 0.5, h * 0.1 / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				draw.SimpleText( "0 > 1", "XP_Notice_Title", w * 0.5, h * 0.13, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		else
			if ( PlyXPTab.Level ) then
				draw.SimpleText( "Level : " .. PlyXPTab.Level, "XP_Notice_Title", w * 0.5, h * 0.13, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end
		
		if ( PlyXPTab.XP ) then
			draw.SimpleText( math.Round( LocalPlayer():GetNWInt( "XP" ) ) .. " XP", "XP_Notice_Title", w * 0.5, h * 0.2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( "0 XP", "XP_Notice_Title", w * 0.5, h * 0.2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		
		if ( NextXP != "MAX" ) then
			draw.RoundedBox( 0, 0, h * 0.4 - 50 / 2, w, 50, Color( 30, 30, 30, 200 ) )
			draw.RoundedBox( 0, 0, h * 0.4 - 50 / 2, w * PercentXP, 50, Color( 0, 0, 0, 255 ) )
			draw.SimpleText( math.Round( NextXP - LP:GetNWInt("XP") ) .. " XP left", "XP_Notice_Percent", w * 0.95, h * 0.4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			draw.SimpleText( math.Round( PercentXPPer * 100 ) .. "%", "XP_Notice_Percent", w * 0.5, h * 0.4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( "MAX LEVEL :)", "XP_Notice_Title", w * 0.5, h * 0.4, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		
		draw.SimpleText( "L7D's XP System", "XP_Notice_Percent", w * 0.95, h * 0.9, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		draw.SimpleText( "Version " .. XPSys.Config.SysVersion, "XP_Notice_Text3", w * 0.95, h * 0.95, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
	end
	
	if ( XPSys.Config.PermissionGroup( LP ) ) then
		local Bx, By = LevelMain_w - LevelMain_w * 0.25, (LevelMain_h * 0.05) - (35 / 2); -- 0.3
	
		local DetailButton = vgui.Create( "DButton", LevelMain )    
		DetailButton:SetText( "Administrator" )  
		DetailButton:SetFont("XP_Notice_Text3")
		DetailButton:SetPos( Bx, By )  
		DetailButton:SetColor(Color( 0, 0, 0, 255 ))
		DetailButton:SetSize( LevelMain_w * 0.2, 35 ) 
		DetailButton.DoClick = function(  )
			surface.PlaySound( "ui/buttonclick.wav" )
			XPSys.XPAdminMain()
		end
		DetailButton.Paint = function()
			local w = DetailButton:GetWide()
			local h = DetailButton:GetTall()
		
			surface.SetDrawColor( 100, 100, 100, 30 )
			surface.DrawRect( 0, 0, w, h )
		end
	end
	
	local Bx, By = LevelMain_w * 0.05, (LevelMain_h * 0.6) - (35 / 2)

	local DetailButton = vgui.Create( "DButton", LevelMain )    
	DetailButton:SetText( "List of conditions" )  
	DetailButton:SetFont("XP_Notice_Text3")
	DetailButton:SetPos( Bx, By )  
	DetailButton:SetColor(Color( 0, 0, 0, 255 ))
	DetailButton:SetSize( LevelMain_w * 0.25, 35 ) 
	DetailButton.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		XPSys.DetailPanel()
	end
	DetailButton.Paint = function()
		local w = DetailButton:GetWide()
		local h = DetailButton:GetTall()
		
		surface.SetDrawColor( 100, 100, 100, 30 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	local Bx, By = LevelMain_w * 0.05, (LevelMain_h * 0.7) - (35 / 2)

	local DetailButton = vgui.Create( "DButton", LevelMain )    
	DetailButton:SetText( "Rank Reward List" )  
	DetailButton:SetFont("XP_Notice_Text3")
	DetailButton:SetPos( Bx, By )  
	DetailButton:SetColor(Color( 0, 0, 0, 255 ))
	DetailButton:SetSize( LevelMain_w * 0.25, 35 ) 
	DetailButton.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		XPSys.RankReward()
	end
	DetailButton.Paint = function()
		local w = DetailButton:GetWide()
		local h = DetailButton:GetTall()
		
		surface.SetDrawColor( 100, 100, 100, 30 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	local Bx, By = LevelMain_w * 0.05, (LevelMain_h * 0.8) - (35 / 2)

	local DetailButton = vgui.Create( "DButton", LevelMain )    
	DetailButton:SetText( "Other Users" )  
	DetailButton:SetFont("XP_Notice_Text3")
	DetailButton:SetPos( Bx, By )  
	DetailButton:SetColor(Color( 0, 0, 0, 255 ))
	DetailButton:SetSize( LevelMain_w * 0.25, 35 ) 
	DetailButton.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		XPSys.AnotherPLYDetailPanel()
	end
	DetailButton.Paint = function()
		local w = DetailButton:GetWide()
		local h = DetailButton:GetTall()
		
		surface.SetDrawColor( 100, 100, 100, 30 )
		surface.DrawRect( 0, 0, w, h )
	end

	local Bx, By = LevelMain_w * 0.05, (LevelMain_h * 0.9) - (35 / 2)

	local Detail2Button = vgui.Create( "DButton", LevelMain )    
	Detail2Button:SetText( "Level List" )  
	Detail2Button:SetFont("XP_Notice_Text3")
	Detail2Button:SetPos( Bx, By )  
	Detail2Button:SetColor(Color( 0, 0, 0, 255 ))
	Detail2Button:SetSize( LevelMain_w * 0.25, 35 ) 
	Detail2Button.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		XPSys.LvlDetailPanel()
	end
	Detail2Button.Paint = function()
		local w = Detail2Button:GetWide()
		local h = Detail2Button:GetTall()
		
		surface.SetDrawColor( 100, 100, 100, 30 )
		surface.DrawRect( 0, 0, w, h )
	end	
	
	local Bx, By = 0 + LevelMain_w * 0.05, (LevelMain_h * 0.05) - (35 / 2); -- 0.3

	local DetailButton = vgui.Create( "DButton", LevelMain )    
	DetailButton:SetText( "Rank" )  
	DetailButton:SetFont("XP_Notice_Text3")
	DetailButton:SetPos( Bx, By )  
	DetailButton:SetColor(Color( 0, 0, 0, 255 ))
	DetailButton:SetSize( LevelMain_w * 0.2, 35 ) 
	DetailButton.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		XPSys.RankPanel()
	end
	DetailButton.Paint = function()
		local w = DetailButton:GetWide()
		local h = DetailButton:GetTall()
		
		surface.SetDrawColor( 100, 100, 100, 30 )
		surface.DrawRect( 0, 0, w, h )
	end

	local Bx, By = (LevelMain_w * 0.5) - (LevelMain_w * 0.1 / 2), LevelMain_h - 40

	local CloseButton = vgui.Create( "DButton", LevelMain )    
	CloseButton:SetText( "▼" )  
	CloseButton:SetFont("XP_Notice_Text3")
	CloseButton:SetPos( Bx, By )  
	CloseButton:SetColor(Color( 0, 0, 0, 255 ))
	CloseButton:SetSize( LevelMain_w * 0.1, 35 ) 
	CloseButton.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		LevelMain:MoveTo( ScrW() / 2 - LevelMain_w / 2, ScrH() * 1.5, 0.3, 0 )
		timer.Simple(0.3 , function()
			LevelMain:Remove()
			LevelMain = nil
		end)
		if ( IsValid( Detail_Panel ) ) then
			Detail_Panel:Remove()
			Detail_Panel = nil
		end
		if ( IsValid( RankDetail_Panel ) ) then
			RankDetail_Panel:Remove()
			RankDetail_Panel = nil
		end
		if ( IsValid( LvlDetail_Panel ) ) then
			LvlDetail_Panel:Remove()
			LvlDetail_Panel = nil
		end
		if ( IsValid( RankRewardList ) ) then
			RankRewardList:Remove()
			RankRewardList = nil
		end		
		if ( IsValid( AnotherPLYPercent_Panel ) ) then
			AnotherPLYPercent_Panel:Remove()
			AnotherPLYPercent_Panel = nil
		end		
		if ( IsValid( GlobalRank_Panel ) ) then
			GlobalRank_Panel:Remove()
			GlobalRank_Panel = nil
		end				
	end
	CloseButton.Paint = function()
		local w = CloseButton:GetWide()
		local h = CloseButton:GetTall()
		
		surface.SetDrawColor( 255, 100, 100, 50 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	else
		LevelMain:Remove()
		LevelMain = nil
	end

end