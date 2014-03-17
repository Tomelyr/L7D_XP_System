--[[########################################################
						L7D's XP System
				Copyright ( C ) 2014 ~ 'L7D'
		You have any question? steam friend invite me!
						ID : smhjyh2009
//////////////////////////////////////////////////////////--]]

local PANEL = {}

--[[---------------------------------------------------------
	
-----------------------------------------------------------]]
function PANEL:Init()

	self.TextArea = self:Add( "DTextEntry" );
	self.TextArea:Dock( RIGHT )
	self.TextArea:DockMargin( 10, 1, 1, 1 )
	self.TextArea:SetDrawBackground( false )
	self.TextArea:SetEditable( false )
	self.TextArea:SetWide( 45 )
	self.TextArea:SetNumeric( true )
	self.TextArea:SetFont("Guestbook_DNumSlider_Label")
	self.TextArea.OnChange = function( textarea, val ) self:SetValue( self.TextArea:GetText() ) end

	self.Slider = self:Add( "DSlider", self )
		self.Slider:SetLockY( 0.5 )
		self.Slider.TranslateValues = function( slider, x, y ) return self:TranslateSliderValues( x, y ) end
		self.Slider:SetTrapInside( true )
		self.Slider:Dock( FILL )
		self.Slider:SetHeight( 16 )
		self.Slider.Paint = function( pnl )
			surface.SetDrawColor( 10, 10, 10, 50 )
			surface.DrawRect( 0, 5, pnl:GetWide(), pnl:GetTall() / 2 )	
		end
	--	Derma_Hook( self.Slider, "Paint", "Paint", "NumSlider" )
	
	self.Label = vgui.Create ( "DLabel", self )
		self.Label:Dock( LEFT )
		self.Label:SetSize( 130 )
		self.Label:SetMouseInputEnabled( false )

	self.Scratch = self.Label:Add( "DNumberScratch" )
		self.Scratch:SetImageVisible( false )
		self.Scratch:Dock( FILL )
		self.Scratch.OnValueChanged = function() self:ValueChanged( self.Scratch:GetFloatValue() ) end
	
	self:SetTall( 32 )

	self:SetMin( 0 )
	self:SetMax( 1 )
	self:SetDecimals( 2 )
	self:SetText( "" )
	self:SetValue( 0.5 )

	--
	-- You really shouldn't be messing with the internals of these controls from outside..
	--                                .. but if you are this might stop your code from fucking us both.
	--
	self.Wang = self.Scratch

end

--[[---------------------------------------------------------
	SetMinMax
-----------------------------------------------------------]]
function PANEL:SetMinMax( min, max )
	self.Scratch:SetMin( tonumber( min ) )
	self.Scratch:SetMax( tonumber( max ) )
	self:UpdateNotches()
end

function PANEL:SetDark( b )
	self.Label:SetDark( b )
end

--[[---------------------------------------------------------
	GetMin
-----------------------------------------------------------]]
function PANEL:GetMin()
	return self.Scratch:GetMin()
end

--[[---------------------------------------------------------
	GetMin
-----------------------------------------------------------]]
function PANEL:GetMax()
	return self.Scratch:GetMax()
end

--[[---------------------------------------------------------
	GetRange
-----------------------------------------------------------]]
function PANEL:GetRange()
	return self:GetMax() - self:GetMin()
end

--[[---------------------------------------------------------
	SetMin
-----------------------------------------------------------]]
function PANEL:SetMin( min )

	if ( !min ) then min = 0  end

	self.Scratch:SetMin( tonumber( min ) )
	self:UpdateNotches()
end

--[[---------------------------------------------------------
	SetMax
-----------------------------------------------------------]]
function PANEL:SetMax( max )

	if ( !max ) then max = 0  end

	self.Scratch:SetMax( tonumber( max ) )
	self:UpdateNotches()
end

--[[---------------------------------------------------------
   Name: SetValue
-----------------------------------------------------------]]
function PANEL:SetValue( val )

	val = math.Clamp( tonumber( val ) or 0, self:GetMin(), self:GetMax() )

	if ( val == nil ) then return end
	if ( self:GetValue() == val ) then return end

	self.Scratch:SetValue( val )

	if ( self.TextArea != vgui.GetKeyboardFocus() ) then
		self.TextArea:SetValue( self.Scratch:GetTextValue() )
	end

	self:ValueChanged( self:GetValue() )

end

--[[---------------------------------------------------------
   Name: GetValue
-----------------------------------------------------------]]
function PANEL:GetValue()
	return self.Scratch:GetFloatValue()
end

--[[---------------------------------------------------------
   Name: SetDecimals
-----------------------------------------------------------]]
function PANEL:SetDecimals( d )
	self.Scratch:SetDecimals( d )
	self:UpdateNotches()
end

--[[---------------------------------------------------------
   Name: GetDecimals
-----------------------------------------------------------]]
function PANEL:GetDecimals()
	return self.Scratch:GetDecimals()
end

--
-- Are we currently changing the value?
--
function PANEL:IsEditing()

	return self.Scratch:IsEditing() || self.TextArea:IsEditing() || self.Slider:IsEditing()

end

--[[---------------------------------------------------------
   Name: SetConVar
-----------------------------------------------------------]]
function PANEL:SetConVar( cvar )
	self.Scratch:SetConVar( cvar )
	self.TextArea:SetConVar( cvar )
end

--[[---------------------------------------------------------
   Name: SetText
-----------------------------------------------------------]]
function PANEL:SetText( text )
	self.Label:SetText( text )
end

--[[---------------------------------------------------------
   Name: ValueChanged
-----------------------------------------------------------]]
function PANEL:ValueChanged( val )

	val = math.Clamp( tonumber( val ) or 0, self:GetMin(), self:GetMax() )

	self.Slider:SetSlideX( self.Scratch:GetFraction( val ) )
	
	if ( self.TextArea != vgui.GetKeyboardFocus() ) then
		self.TextArea:SetValue( self.Scratch:GetTextValue() )
	end

	self:OnValueChanged( val )

end

--[[---------------------------------------------------------
   Name: OnValueChanged
-----------------------------------------------------------]]
function PANEL:OnValueChanged( val )

	
	-- For override

end

--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:TranslateSliderValues( x, y )

	self:SetValue( self.Scratch:GetMin() + (x * self.Scratch:GetRange()) );
	
	return self.Scratch:GetFraction(), y

end

--[[---------------------------------------------------------
   Name: GetTextArea
-----------------------------------------------------------]]
function PANEL:GetTextArea()

	return self.TextArea

end

function PANEL:UpdateNotches()

	local range = self:GetRange()
	self.Slider:SetNotches( nil )
	
	if ( range < self:GetWide()/4 ) then
		return self.Slider:SetNotches( range )
	else
		self.Slider:SetNotches( self:GetWide()/4 )
	end

end

--[[---------------------------------------------------------
   Name: GenerateExample
-----------------------------------------------------------]]
function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
		ctrl:SetWide( 200 )
		ctrl:SetMin( 1 )
		ctrl:SetMax( 10 )
		ctrl:SetText( "Example Slider!" )
		ctrl:SetDecimals( 0 )
	
	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "XPSys_DNumSlider", "Menu Option Line", table.Copy(PANEL), "Panel" )

function XPSys.XPAdminMain()
	local LP = LocalPlayer()
	local scrW, scrH = ScrW(), ScrH()
	local XPAdmin_Panel_w, XPAdmin_Panel_h = scrW, scrH
	local XPAdmin_Panel_x, XPAdmin_Panel_y = (scrW * 0.5) - (XPAdmin_Panel_w / 2), (scrH * 0.5) - (XPAdmin_Panel_h / 2);
	
	if ( !XPAdmin_Panel ) then
	XPAdmin_Panel = vgui.Create("DFrame")
	XPAdmin_Panel:SetPos( XPAdmin_Panel_x ,  XPAdmin_Panel_y )
	XPAdmin_Panel:SetAlpha( 0 )
	XPAdmin_Panel:AlphaTo( 255, 0.3, 0 )
	XPAdmin_Panel:SetSize( XPAdmin_Panel_w, XPAdmin_Panel_h )
	XPAdmin_Panel:SetTitle( "" )
	XPAdmin_Panel:SetDraggable( false )
	XPAdmin_Panel:ShowCloseButton( false )
	XPAdmin_Panel:MakePopup()
	XPAdmin_Panel.Paint = function()
		local x = XPAdmin_Panel_x
		local y = XPAdmin_Panel_y
		local w = XPAdmin_Panel_w
		local h = XPAdmin_Panel_h

		surface.SetDrawColor( 255, 255, 255, 230 )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( "L7D's XP System", "XP_Notice_Title3", w * 0.5, h * 0.1 / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( "Administrator", "XP_Notice_Title2", w * 0.5, h * 0.1, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		/* Background */

		draw.RoundedBox( 0, w / 2 - w * 0.95 / 2, h * 0.13, w * 0.95, 2, Color( 0, 0, 0, 255 ) )
	end


	local Bx, By = (XPAdmin_Panel_w * 0.2) - (XPAdmin_Panel_w * 0.15 / 2), (XPAdmin_Panel_h * 0.5) - (35 / 2); -- 0.3

	local PlayerManagerButton = vgui.Create( "DButton", XPAdmin_Panel )    
	PlayerManagerButton:SetText( "Player Manager" )  
	PlayerManagerButton:SetFont("XP_Notice_Text3")
	PlayerManagerButton:SetPos( Bx, By )  
	PlayerManagerButton:SetColor(Color( 0, 0, 0, 255 ))
	PlayerManagerButton:SetSize( XPAdmin_Panel_w * 0.15, 35 ) 
	PlayerManagerButton.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		XPSys.XPAdmin01()
	end
	PlayerManagerButton.Paint = function()
		local w = PlayerManagerButton:GetWide()
		local h = PlayerManagerButton:GetTall()
		
		surface.SetDrawColor( 100, 100, 100, 50 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	
	local Bx, By = (XPAdmin_Panel_w * 0.5) - (XPAdmin_Panel_w * 0.15 / 2), (XPAdmin_Panel_h * 0.5) - (35 / 2); -- 0.3

	local LogButton = vgui.Create( "DButton", XPAdmin_Panel )    
	LogButton:SetText( "Log Manager" )  
	LogButton:SetFont("XP_Notice_Text3")
	LogButton:SetPos( Bx, By )  
	LogButton:SetColor(Color( 0, 0, 0, 255 ))
	LogButton:SetSize( XPAdmin_Panel_w * 0.15, 35 ) 
	LogButton.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		XPSys.XPAdmin02()
	end
	LogButton.Paint = function()
		local w = LogButton:GetWide()
		local h = LogButton:GetTall()
		
		surface.SetDrawColor( 100, 100, 100, 50 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	local Bx, By = (XPAdmin_Panel_w * 0.1) - (XPAdmin_Panel_w * 0.15 / 2), (XPAdmin_Panel_h * 0.95) - (35 / 2); -- 0.3

	local CloseButton = vgui.Create( "DButton", XPAdmin_Panel )    
	CloseButton:SetText( "Close" )  
	CloseButton:SetFont("XP_Notice_Text3")
	CloseButton:SetPos( Bx, By )  
	CloseButton:SetColor(Color( 0, 0, 0, 255 ))
	CloseButton:SetSize( XPAdmin_Panel_w * 0.15, 35 ) 
	CloseButton.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		XPAdmin_Panel:Remove()
		XPAdmin_Panel = nil
	end
	CloseButton.Paint = function()
		local w = CloseButton:GetWide()
		local h = CloseButton:GetTall()
		
		surface.SetDrawColor( 100, 100, 100, 50 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	local Bx, By = (XPAdmin_Panel_w * 0.8) - (XPAdmin_Panel_w * 0.15 / 2), (XPAdmin_Panel_h * 0.5) - (35 / 2); -- 0.3

	local InitButton = vgui.Create( "DButton", XPAdmin_Panel )    
	InitButton:SetText( "System Init" )  
	InitButton:SetFont("XP_Notice_Text3")
	InitButton:SetPos( Bx, By )  
	InitButton:SetColor(Color( 0, 0, 0, 255 ))
	InitButton:SetSize( XPAdmin_Panel_w * 0.15, 35 ) 
	InitButton.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		Derma_Query("Are you sure system init?", "WARNING",
			"Yes", function() 
				net.Start("XPSys_XP_Init")
				net.SendToServer()
				Derma_Message("The system has been restored to its initial state.", "Notice", "OK")
			end,
			"No", function()
			
			end
		)	
	end
	InitButton.Paint = function()
		local w = InitButton:GetWide()
		local h = InitButton:GetTall()
		
		surface.SetDrawColor( 255, 100, 100, 50 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	else
		XPAdmin_Panel:Remove()
		XPAdmin_Panel = nil
	end

end


function XPSys.XPAdmin01()
	local LP = LocalPlayer()
	local scrW, scrH = ScrW(), ScrH()
	local XPAdmin_Panel01_w, XPAdmin_Panel01_h = scrW, scrH
	local XPAdmin_Panel01_x, XPAdmin_Panel01_y = (scrW * 0.5) - (XPAdmin_Panel01_w / 2), (scrH * 0.5) - (XPAdmin_Panel01_h / 2);
	
	table.sort( XPSys.XPCL, function( a, b )
		return a.XP > b.XP
	end)
	
	if ( !XPAdmin_Panel01 ) then
	XPAdmin_Panel01 = vgui.Create("DFrame")
	XPAdmin_Panel01:SetPos( XPAdmin_Panel01_x ,  XPAdmin_Panel01_y )
	XPAdmin_Panel01:SetAlpha( 0 )
	XPAdmin_Panel01:AlphaTo( 255, 0.3, 0 )
	XPAdmin_Panel01:SetSize( XPAdmin_Panel01_w, XPAdmin_Panel01_h )
	XPAdmin_Panel01:SetTitle( "" )
	XPAdmin_Panel01:SetDraggable( false )
	XPAdmin_Panel01:ShowCloseButton( false )
	XPAdmin_Panel01:MakePopup()
	XPAdmin_Panel01.Paint = function()
		local x = XPAdmin_Panel01_x
		local y = XPAdmin_Panel01_y
		local w = XPAdmin_Panel01_w
		local h = XPAdmin_Panel01_h
			
		surface.SetDrawColor( 255, 255, 255, 230 )
		surface.DrawRect( 0, 0, w, h )

		draw.SimpleText( "Player Manager", "XP_Notice_Title2", w * 0.02, h * 0.1 / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end
	
	local DetailList = vgui.Create( "DPanelList", XPAdmin_Panel01 )
	DetailList:SetPos( XPAdmin_Panel01_w / 2 - XPAdmin_Panel01_w * 0.98 / 2, XPAdmin_Panel01_h * 0.1 )
	DetailList:SetSize( XPAdmin_Panel01_w * 0.98 , XPAdmin_Panel01_h * 0.8 )
	DetailList:SetSpacing( 3 )
	DetailList:EnableHorizontal( false )
	DetailList:EnableVerticalScrollbar( true )
	DetailList.Paint = function()
		local w, h = DetailList:GetWide(), DetailList:GetTall()
		surface.SetDrawColor( 10, 10, 10, 100 )
		surface.SetMaterial( Material("gui/center_gradient") )
		surface.DrawTexturedRect( 0, 0, w, 5 )
		
		surface.SetDrawColor( 10, 10, 10, 100 )
		surface.SetMaterial( Material("gui/center_gradient") )
		surface.DrawTexturedRect( 0, h - 5, w, 5 )
		
		if ( #XPSys.XPCL == 0 ) then
			draw.SimpleText( "No Information.", "XP_Notice_Text3", w * 0.5, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	
	local function DetailListClear()
		DetailList:Clear()
	end
	
	local function DetailListAdd()
		local delta = 0
		for k, v in pairs( XPSys.XPCL ) do
				
			local list = vgui.Create( "DButton", XPAdmin_Panel01 ) 
			list:SetText("")
			list:SetAlpha( 0 )
			list:AlphaTo( 255, 0.1, delta )
			delta = delta + 0.03
			list:SetToolTip( v.SteamID .. "\n" .. v.Level .. " Level\n" .. math.Round( v.XP ) .. " XP" )
			list:SetSize( DetailList:GetWide(), 70 ) 
			list.Paint = function()
				local w, h = list:GetWide(), list:GetTall()
				surface.SetDrawColor( 10, 10, 10, 10 )
				surface.DrawRect( 0, 0, w, h )
				
				draw.SimpleText( k, "XP_Notice_Text3", w * 0.02, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				
				draw.SimpleText( v.Level .. " Level", "XP_Notice_Text3", w * 0.08, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				
				draw.SimpleText( v.Name, "XP_Notice_Text3", w * 0.15, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				
				draw.SimpleText( v.SteamID, "XP_Notice_Text3", w * 0.5, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	
				draw.SimpleText( math.Round( v.XP ) .. " XP", "XP_Notice_Percent", w * 0.9, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			end
			
			local w, h = list:GetWide(), list:GetTall()

			local CloseButton = vgui.Create( "DButton", list )    
			CloseButton:SetText( "Manage" )  
			CloseButton:SetFont("XP_Notice_Text3")
			CloseButton:SetPos( w * 0.95 - 70 / 2, h * 0.5 - 50 / 2 )  
			CloseButton:SetColor(Color( 0, 0, 0, 255 ))
			CloseButton:SetSize( 70, 50 ) 
			CloseButton.DoClick = function(  )
				surface.PlaySound( "ui/buttonclick.wav" )
				local MenuButtonOptions = DermaMenu()

				MenuButtonOptions:AddOption("XP Set", function() 
					surface.PlaySound( "ui/buttonclick.wav" )
					Derma_StringRequest(
						v.Name .. " 's XP Set",
						v.Name .. " 님의 XP를 몇으로 설정하시겠습니까?",
						math.Round(v.XP),
						function(str)
							net.Start("XPSys_XP_Set")
							net.WriteString( v.SteamID )
							net.WriteString( str )
							net.SendToServer()
							timer.Simple( 0.3, function()
								DetailListClear()
								DetailListAdd()
							end)
						end
					)
				end )
				if ( v.XP >= 1 ) then
					MenuButtonOptions:AddOption("XP Take", function() 
						surface.PlaySound( "ui/buttonclick.wav" )
						Derma_StringRequest(
							v.Name .. " 's XP Take",
							"",
							math.Round(v.XP),
							function(str)
								net.Start("XPSys_XP_Take")
								net.WriteString( v.SteamID )
								net.WriteString( str )
								net.SendToServer()
								timer.Simple( 0.3, function()
									DetailListClear()
									DetailListAdd()
								end)
							end
						)
					end )
				end
				MenuButtonOptions:AddOption("XP Add", function() 
					surface.PlaySound( "ui/buttonclick.wav" )
					Derma_StringRequest(
						v.Name .. " 's XP Add",
						"",
						math.Round(v.XP),
						function(str)
							net.Start("XPSys_XP_Add")
							net.WriteString( v.SteamID )
							net.WriteString( str )
							net.SendToServer()
							timer.Simple( 0.3, function()
								DetailListClear()
								DetailListAdd()
							end)
						end
					)
				end )
				MenuButtonOptions:AddOption("Level Set", function() 
					surface.PlaySound( "ui/buttonclick.wav" )
					Derma_StringRequest(
						v.Name .. " 's Level Set",
						"",
						math.Round(v.Level),
						function(str)
							str = tonumber( str )
							if ( type( str ) == "number" ) then
								if ( str >= 0 ) then
									net.Start("XPSys_Level_Set")
									net.WriteString( v.SteamID )
									net.WriteString( str )
									net.SendToServer()
									timer.Simple( 0.3, function()
										DetailListClear()
										DetailListAdd()
									end)
								else
									Derma_Query("Level is must over 0!", "Error",
									"OK", function() 
								
									end
									)
								end
							end
						end
						)
				end )
				MenuButtonOptions:Open()
				MenuButtonOptions.Paint = function()
					surface.SetDrawColor( 255, 255, 255, 245 )
					surface.DrawRect( 0, 0, MenuButtonOptions:GetWide(), MenuButtonOptions:GetTall() )
			
					surface.SetDrawColor( 0, 0, 0, 255 )
					surface.DrawOutlinedRect( 0, 0, MenuButtonOptions:GetWide(), MenuButtonOptions:GetTall() )
				end
			end
			CloseButton.Paint = function()
				local w = CloseButton:GetWide()
				local h = CloseButton:GetTall()
		
				surface.SetDrawColor( 100, 100, 100, 50 )
				surface.DrawRect( 0, 0, w, h )
			end
			
			DetailList:AddItem( list )
		end
	end

	DetailListClear()
	DetailListAdd()
	
	local Bx, By = (XPAdmin_Panel01_w * 0.1) - (XPAdmin_Panel01_w * 0.15 / 2), (XPAdmin_Panel01_h * 0.95) - (35 / 2); -- 0.3

	local CloseButton = vgui.Create( "DButton", XPAdmin_Panel01 )    
	CloseButton:SetText( "Close" )  
	CloseButton:SetFont("XP_Notice_Text3")
	CloseButton:SetPos( Bx, By )  
	CloseButton:SetColor(Color( 0, 0, 0, 255 ))
	CloseButton:SetSize( XPAdmin_Panel01_w * 0.15, 35 ) 
	CloseButton.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		XPAdmin_Panel01:Remove()
		XPAdmin_Panel01 = nil
	end
	CloseButton.Paint = function()
		local w = CloseButton:GetWide()
		local h = CloseButton:GetTall()
		
		surface.SetDrawColor( 100, 100, 100, 50 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	local Bx, By = (XPAdmin_Panel01_w * 0.3) - (XPAdmin_Panel01_w * 0.15 / 2), (XPAdmin_Panel01_h * 0.95) - (35 / 2); -- 0.3

	local RefreshButton = vgui.Create( "DButton", XPAdmin_Panel01 )    
	RefreshButton:SetText( "Refresh" )  
	RefreshButton:SetFont("XP_Notice_Text3")
	RefreshButton:SetPos( Bx, By )  
	RefreshButton:SetColor(Color( 0, 0, 0, 255 ))
	RefreshButton:SetSize( XPAdmin_Panel01_w * 0.15, 35 ) 
	RefreshButton.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		DetailListClear()
		DetailListAdd()
	end
	RefreshButton.Paint = function()
		local w = RefreshButton:GetWide()
		local h = RefreshButton:GetTall()
		
		surface.SetDrawColor( 100, 100, 100, 50 )
		surface.DrawRect( 0, 0, w, h )
	end

	else
		XPAdmin_Panel01:Remove()
		XPAdmin_Panel01 = nil
	end
end

function XPSys.XPAdmin02()
	local LP = LocalPlayer()
	local scrW, scrH = ScrW(), ScrH()
	local XPAdmin_Panel02_w, XPAdmin_Panel02_h = scrW, scrH
	local XPAdmin_Panel02_x, XPAdmin_Panel02_y = (scrW * 0.5) - (XPAdmin_Panel02_w / 2), (scrH * 0.5) - (XPAdmin_Panel02_h / 2);
	local SelectFile = nil
	
	if ( !XPAdmin_Panel02 ) then
	XPAdmin_Panel02 = vgui.Create("DFrame")
	XPAdmin_Panel02:SetPos( XPAdmin_Panel02_x ,  XPAdmin_Panel02_y )
	XPAdmin_Panel02:SetAlpha( 0 )
	XPAdmin_Panel02:AlphaTo( 255, 0.3, 0 )
	XPAdmin_Panel02:SetSize( XPAdmin_Panel02_w, XPAdmin_Panel02_h )
	XPAdmin_Panel02:SetTitle( "" )
	XPAdmin_Panel02:SetDraggable( false )
	XPAdmin_Panel02:ShowCloseButton( true )
	XPAdmin_Panel02:MakePopup()
	XPAdmin_Panel02.Paint = function()
		local x = XPAdmin_Panel02_x
		local y = XPAdmin_Panel02_y
		local w = XPAdmin_Panel02_w
		local h = XPAdmin_Panel02_h
			
		surface.SetDrawColor( 255, 255, 255, 230 )
		surface.DrawRect( 0, 0, w, h )

		draw.SimpleText( "System Log", "XP_Notice_Title2", w * 0.02, h * 0.1 / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		draw.SimpleText( "▲ Latest", "XP_Notice_Text5", w * 0.99, h * 0.93, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		
		draw.SimpleText( "▼ Old", "XP_Notice_Text5", w * 0.99, h * 0.95, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
	end
	
	local LogList = vgui.Create( "DPanelList", XPAdmin_Panel02 )
	LogList:SetPos( 10, XPAdmin_Panel02_h * 0.1 )
	LogList:SetSize( XPAdmin_Panel02_w * 0.1 , XPAdmin_Panel02_h * 0.8 )
	LogList:SetSpacing( 3 )
	LogList:EnableHorizontal( false )
	LogList:EnableVerticalScrollbar( true )
	LogList.Paint = function()
		local w, h = LogList:GetWide(), LogList:GetTall()
		
		surface.SetDrawColor( 100, 100, 100, 30 )
		surface.DrawRect( 0, 0, w, h )
		
		for k, v in pairs( XPSys.LogHistoryCL ) do
			if ( !k ) then
				draw.SimpleText( "No File Found.", "XP_Notice_Text6", w * 0.5, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end	
		end
	end
	
	local LogDetail = vgui.Create( "DPanelList", XPAdmin_Panel02 )
	LogDetail:SetPos( 10 + XPAdmin_Panel02_w * 0.1 + 10, XPAdmin_Panel02_h * 0.1 )
	LogDetail:SetSize( XPAdmin_Panel02_w * 0.88 , XPAdmin_Panel02_h * 0.8 )
	LogDetail:SetSpacing( 0 )
	LogDetail:EnableHorizontal( false )
	LogDetail:EnableVerticalScrollbar( true )
	LogDetail.Paint = function()
		local w, h = LogDetail:GetWide(), LogDetail:GetTall()
		
		if ( !SelectFile ) then
			draw.SimpleText( "Select Log File.", "XP_Notice_Text3", w * 0.5, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		
		surface.SetDrawColor( 10, 10, 10, 10 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	local function DetailListClear()
		LogList:Clear()
	end
	
	local function DetailListAdd()
		local delta = 0
		for k, v in pairs( XPSys.LogHistoryCL ) do
			local list = vgui.Create( "DButton", XPAdmin_Panel02 ) 
			list:SetText("")
			list:SetAlpha( 0 )
			list:AlphaTo( 255, 0.1, delta )
			delta = delta + 0.05
			list:SetSize( LogList:GetWide(), 35 ) 
			list:SetToolTip( "" .. k .. "\nDelete : Mouse Right" )
			list.DoRightClick = function()
				Derma_Query("Are you sure delete this file?", "WARNING",
				"OK", function() 
					net.Start("XPSys_LogFile_Delete")
					net.WriteString( k )
					net.SendToServer()
					timer.Simple( 1, function()
						if ( IsValid( XPAdmin_Panel02 ) ) then
							DetailListClear()
							DetailListAdd()
							Detail2ListClear( nil )
						end
					end)
				end,
				"No", function()
			
				end
				)		

			end
			list.DoClick = function()
				SelectFile = k
				Detail2ListClear( SelectFile )
				Detail2ListAdd( SelectFile )
				surface.PlaySound( "ui/buttonclick.wav" )
			end
			list.Paint = function()
				local w, h = list:GetWide(), list:GetTall()
				surface.SetDrawColor( 10, 10, 10, 10 )
				surface.DrawRect( 0, 0, w, h )
				
				draw.SimpleText( k, "XP_Notice_Text3", w * 0.5, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end


			LogList:AddItem( list )
		end
	end
	
	function Detail2ListClear( logFile )
		if ( logFile ) then
			table.sort( XPSys.LogHistoryCL[logFile], function( a, b )
				return tonumber( a.Count ) > tonumber( b.Count )
			end)
		end
		LogDetail:Clear()
	end
	
	
	function Detail2ListAdd( logFile )
		if ( !logFile ) then
			return
		end
		local delta = 0
		for k, v in pairs( XPSys.LogHistoryCL[logFile] ) do
				
			local x = 0.99
			local list = vgui.Create( "DButton", XPAdmin_Panel02 ) 
			list:SetText("")
			list:SetSize( LogDetail:GetWide(), 35 ) 
			list:SetAlpha( 0 )
			list:AlphaTo( 255, 0.1, delta )
			delta = delta + 0.05
			list:SetToolTip( "Delete : Mouse Left" )
			list.Paint = function()
				local w, h = list:GetWide(), list:GetTall()
				surface.SetDrawColor( 10, 10, 10, 10 )
				surface.DrawRect( 0, 0, w, h )
				
			--	draw.RoundedBox( 0, w * 0.07, 0, 3, h, Color( 0, 0, 0, 100 ) )
				
			--	draw.SimpleText( v.Count, "XP_Notice_Text3", w * 0.03, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				
				draw.SimpleText( v.Text, "XP_Notice_Text4", 5, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				
				draw.SimpleText( v.Time, "XP_Notice_Text4", w * x, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )

			end
			
			local w, h = list:GetWide(), list:GetTall()

			local Delete = vgui.Create( "DButton", list )    
			Delete:SetText( "X" )  
			Delete:SetVisible( false )
			Delete:SetFont("XP_Notice_Text4")
			Delete:SetPos( w * 0.95 - 70 / 2, h * 0.5 - 20 / 2 )  
			Delete:SetColor(Color( 0, 0, 0, 255 ))
			Delete:SetSize( 70, 20 ) 
			Delete.DoClick = function(  )
				surface.PlaySound( "ui/buttonclick.wav" )
				net.Start("XPSys_Log_Delete")
				net.WriteString( logFile )
				net.WriteString( tostring( v.Count ) )				
				net.SendToServer()
				timer.Simple( 1, function()
					if ( IsValid( XPAdmin_Panel02 ) ) then
						Detail2ListClear( SelectFile )
						Detail2ListAdd( SelectFile )
					end
				end)
			end
			Delete.Paint = function()
				local w = Delete:GetWide()
				local h = Delete:GetTall()
		
				surface.SetDrawColor( 255, 100, 100, 100 )
				surface.DrawRect( 0, 0, w, h )
			end			
			
			list.DoClick = function()
				if ( !Delete:IsVisible() ) then
					Delete:SetVisible( true )
					Delete:AlphaTo( 255, 0.1, 0 )
					x = 0.9
				else
					Delete:AlphaTo( 0, 0.1, 0 )
					timer.Simple( 0.1, function()
						Delete:SetVisible( false )
						x = 0.99
					end)

				end
			end
			LogDetail:AddItem( list )
		end
	end
	
	local Bx, By = (XPAdmin_Panel02_w * 0.1) - (XPAdmin_Panel02_w * 0.15 / 2), (XPAdmin_Panel02_h * 0.95) - (35 / 2); -- 0.3

	local CloseButton = vgui.Create( "DButton", XPAdmin_Panel02 )    
	CloseButton:SetText( "Close" )  
	CloseButton:SetFont("XP_Notice_Text3")
	CloseButton:SetPos( Bx, By )  
	CloseButton:SetColor(Color( 0, 0, 0, 255 ))
	CloseButton:SetSize( XPAdmin_Panel02_w * 0.15, 35 ) 
	CloseButton.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		XPAdmin_Panel02:Remove()
		XPAdmin_Panel02 = nil
	end
	CloseButton.Paint = function()
		local w = CloseButton:GetWide()
		local h = CloseButton:GetTall()
		
		surface.SetDrawColor( 100, 100, 100, 50 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	DetailListClear()
	DetailListAdd()
	
--	table.sort( XPSys.LogHistoryCL, function( a, b )
--		return a.Time > b.Time
--	end)
	
	local Bx, By = (XPAdmin_Panel02_w * 0.3) - (XPAdmin_Panel02_w * 0.15 / 2), (XPAdmin_Panel02_h * 0.95) - (35 / 2); -- 0.3

	local RefreshButton = vgui.Create( "DButton", XPAdmin_Panel02 )    
	RefreshButton:SetText( "Refresh" )  
	RefreshButton:SetFont("XP_Notice_Text3")
	RefreshButton:SetPos( Bx, By )  
	RefreshButton:SetColor(Color( 0, 0, 0, 255 ))
	RefreshButton:SetSize( XPAdmin_Panel02_w * 0.15, 35 ) 
	RefreshButton.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		DetailListClear()
		DetailListAdd()
	end
	RefreshButton.Paint = function()
		local w = RefreshButton:GetWide()
		local h = RefreshButton:GetTall()
		
		surface.SetDrawColor( 100, 100, 100, 50 )
		surface.DrawRect( 0, 0, w, h )
	end

	else
		XPAdmin_Panel02:Remove()
		XPAdmin_Panel02 = nil
	end
end