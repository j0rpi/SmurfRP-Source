ULib.ucl.registerAccess(	"xgui_urs", "superadmin", "Access to modify URS restrictions.", "XGUI" )local URS = {}function URS.Init()	xgui.addDataType( "URSLimits", function() return limits end, "xgui_urs", 0, -10 )	xgui.addDataType( "URSRestrictions", function() return restrictions end, "xgui_urs", 0, -10 )	xgui.addDataType( "URSLoadouts", function() return loadouts end, "xgui_urs", 0, -10 )endxgui.addSVModule( "URS", URS.Init )