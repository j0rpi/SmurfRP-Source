
include( "rprint/sh_rprint.lua" )
include( "rprint/sh_config.lua" )


if SERVER then
	AddCSLuaFile()

	AddCSLuaFile( "rprint/sh_rprint.lua" )
	AddCSLuaFile( "rprint/sh_config.lua" )

	include( "rprint/server/sv_rprint.lua" )

	resource.AddFile( "materials/dan/rprint/fanpart1.png" )
	resource.AddFile( "materials/dan/rprint/fanpart2.png" )	
end
