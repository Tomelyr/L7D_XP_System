--[[########################################################
						L7D's XP System
				Copyright ( C ) 2014 ~ 'L7D'
		You have any question? steam friend invite me!
						ID : smhjyh2009
//////////////////////////////////////////////////////////--]]

function XPSys.WebHTML_Open( url )
	local LP = LocalPlayer()
	local scrW, scrH = ScrW(), ScrH()
	local WebHTML_Panel_w, WebHTML_Panel_h = scrW * 0.9, scrH * 0.8
	local WebHTML_Panel_x, WebHTML_Panel_y = (scrW * 0.5) - (WebHTML_Panel_w / 2), (scrH * 0.5) - (WebHTML_Panel_h / 2);
	local urlStr = ""

	if ( !WebHTML_Panel ) then
	WebHTML_Panel = vgui.Create("DFrame")
	WebHTML_Panel:SetSize( WebHTML_Panel_w, WebHTML_Panel_h )
	WebHTML_Panel:SetPos( WebHTML_Panel_x , ScrH() + WebHTML_Panel_h )
	WebHTML_Panel:MoveTo( ScrW() / 2 - WebHTML_Panel_w / 2, WebHTML_Panel_y, 0.3, 0 )
	WebHTML_Panel:SetAlpha( 0 )
	WebHTML_Panel:AlphaTo( 255, 0.3, 0 )
	WebHTML_Panel:SetTitle( "" )
	WebHTML_Panel:SetDraggable( false )
	WebHTML_Panel:ShowCloseButton( false )
	WebHTML_Panel:MakePopup()
	WebHTML_Panel.Paint = function()
		local x = WebHTML_Panel_x
		local y = WebHTML_Panel_y
		local w = WebHTML_Panel_w
		local h = WebHTML_Panel_h
			
		surface.SetDrawColor( 255, 255, 255, 245 )
		surface.DrawRect( 0, 0, w, h )
		
		draw.RoundedBox( 0, 0, h * 0.06, w, 3, Color( 0, 0, 0, 255 ) )
		draw.RoundedBox( 0, 0, 0, w, 3, Color( 0, 0, 0, 255 ) )

		draw.SimpleText( "Simple XP System Web Browser", "XP_Notice_Text3", 20, h * 0.03, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	--	draw.SimpleText( urlStr, "XP_Notice_Text3", w * 0.5, h * 0.03, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end
	
	local Html = vgui.Create( "HTML", WebHTML_Panel )
	Html:SetSize( WebHTML_Panel_w , WebHTML_Panel_h * 0.94 )
	Html:SetPos( 0, WebHTML_Panel_h * 0.06 )
	Html.PaintOver = function()

	end
	
	Html:OpenURL( url )
	urlStr = url
	
	local SearchBox = vgui.Create("DTextEntry", WebHTML_Panel)
	SearchBox:SetMultiline(false)
	SearchBox:SetSize( WebHTML_Panel_w * 0.63, 30 )
	SearchBox:SetPos( WebHTML_Panel_w * 0.3, WebHTML_Panel_h * 0.03 - 30 / 2 )
	SearchBox:SetText( url )
	SearchBox:SetFont("XP_Notice_Text3")
	SearchBox:SetAllowNonAsciiCharacters( true )
	SearchBox:SetEnterAllowed( true )
	SearchBox:SetDrawBorder(false)
	SearchBox:SetDrawBackground(false)
--	SearchBox:RequestFocus()
	SearchBox:SetTextColor( Color( 0, 0, 0, 255 ) )
	SearchBox.OnEnter = function( pnl )
		surface.PlaySound( "ui/buttonclick.wav" )
		Html:OpenURL( SearchBox:GetValue() )
	end
	SearchBox.Paint = function()
		local w = SearchBox:GetWide()
		local h = SearchBox:GetTall()

		draw.RoundedBox( 0, 0, 0, w, 3, Color( 0, 0, 0, 255 ) )
		draw.RoundedBox( 0, 0, h - 3, w, 3, Color( 0, 0, 0, 255 ) )
		
		SearchBox:DrawTextEntryText(Color(0, 0, 0), Color(0, 0, 0), Color(0, 0, 0))
	end
	
	local Bx, By = WebHTML_Panel_w - 55, 7; -- 0.3

	local CloseButton = vgui.Create( "DButton", WebHTML_Panel )    
	CloseButton:SetText( "X" )  
	CloseButton:SetFont("XP_Notice_Text3")
	CloseButton:SetPos( Bx, By )  
	CloseButton:SetColor(Color( 0, 0, 0, 255 ))
	CloseButton:SetSize( 50, 30 ) 
	CloseButton.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		WebHTML_Panel:MoveTo( ScrW() / 2 - WebHTML_Panel_w / 2, ScrH() * 1.5, 0.3, 0 )
		timer.Simple( 0.3, function()
			WebHTML_Panel:Remove()
			WebHTML_Panel = nil
		end)
	end
	CloseButton.Paint = function()
		local w = CloseButton:GetWide()
		local h = CloseButton:GetTall()
		
		surface.SetDrawColor( 255, 100, 100, 200 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	else
		WebHTML_Panel:Remove()
		WebHTML_Panel = nil
	end
end