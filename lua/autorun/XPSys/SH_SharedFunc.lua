--[[########################################################
						L7D's XP System
				Copyright ( C ) 2014 ~ 'L7D'
		You have any question? steam friend invite me!
						ID : smhjyh2009
//////////////////////////////////////////////////////////--]]

local Players = FindMetaTable( "Player" )

function Players:GetXP( )
	return self:GetNWInt( "XP" )
end

function Players:GetLevel( )
	return self:GetNWInt( "Level" )
end