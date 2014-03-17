/*
	= SOLAR REPORT SERVER 3 (SRS 3) =

	Version : 3.7V2
	Dev : L7D

	Thank you Garrys. = Derma Copyright.
	Thank you Alex Grist. = FileIO Copyright. = Deleted =
	Copyright (C) 2013 ~ Solar Team ( L7D )
*/


-- / Welcome To Soler Report Server 3 ! / --
-- / This is Master Code! Do not edit this!!! / --

if ( SERVER ) then
	include( "XPSys/SV_L7D_XPCore.lua" )
	AddCSLuaFile( "XPSys/CL_L7D_XPDerma.lua" )
elseif ( CLIENT ) then
	include( "XPSys/CL_L7D_XPDerma.lua" )
end
