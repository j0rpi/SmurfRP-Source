// edits made by Tyler ;P

/* 
	Changelog:
		
		added a cooldown time to prefend lag from ents["FindByClass"]() loop
		I cleaned up the code a bit, it was very messy and hard to work with 
		removed completely unrelated code
		fixed grammar issue!

*/		
	
local CommandRan = false

function ulx.nolag(calling_ply)
	if CommandRan == false then
		for k,v in pairs( ents["FindByClass"]( "prop_physics" ) ) do
			v:GetPhysicsObject():EnableMotion( false )
		end
		ulx.fancyLogAdmin( calling_ply, "#A froze all props." )
		CommandRan = true // command has been ran, this will be reset in 30 seconds.
		timer.Simple( 30, function()
			if CommandRan == true then
				CommandRan = false
			end
		end )	
	else
		calling_ply:ChatPrint( "[NoLag]: You must wait for this command to cooldown!" )
	end
		
end

local nolag = ulx.command("MoreULX", "ulx nolag", ulx.nolag, "!nolag")
nolag:defaultAccess( ULib.ACCESS_ADMIN )
nolag:help( "Freezes all props on the map." )