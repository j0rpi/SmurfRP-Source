CATEGORY_NAME = "Workshop"
// Workshop
function ulx.work(ply)
	ply:SendLua([[gui.OpenURL("http://steamcommunity.com/sharedfiles/filedetails/?id=254829353")]])
end
local work = ulx.command( CATEGORY_NAME, "ulx work", ulx.work, "!workshop" )
work:defaultAccess( ULib.ACCESS_ALL )
work:help( "" )