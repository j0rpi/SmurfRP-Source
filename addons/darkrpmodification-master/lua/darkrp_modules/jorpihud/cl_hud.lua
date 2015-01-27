/*---------------------------------------------------------------------------

SmurfRP by j0rpi
File: hud.lua
Purpose: Handles everything on the screen
---------------------------------------------------------------------------*/





/*---------------------------------------------------------------------------
HUD ConVars
---------------------------------------------------------------------------*/
local ConVars = {}
local HUDWidth
local HUDHeight

local Color = Color
local cvars = cvars
local draw = draw
local GetConVar = GetConVar
local Lerp = Lerp
local localplayer
local pairs = pairs
local SortedPairs = SortedPairs
local string = string
local surface = surface
local table = table
local tostring = tostring

local version = "drp2.5.1 - #rev2 [2014-06-24]"








CreateClientConVar("weaponhud", 0, true, false)

local function ReloadConVars()
	ConVars = {
		background = {0,0,0,100},
		Healthbackground = {0,0,0,200},
		Healthforeground = {140,0,0,180},
		HealthText = {255,255,255,200},
		Job1 = {0,0,150,200},
		Job2 = {0,0,0,255},
		salary1 = {0,150,0,200},
		salary2 = {0,0,0,255}
	}

	for name, Colour in pairs(ConVars) do
		ConVars[name] = {}
		for num, rgb in SortedPairs(Colour) do
			local CVar = GetConVar(name..num) or CreateClientConVar(name..num, rgb, true, false)
			table.insert(ConVars[name], CVar:GetInt())

			if not cvars.GetConVarCallbacks(name..num, false) then
				cvars.AddChangeCallback(name..num, function() timer.Simple(0,ReloadConVars) end)
			end
		end
		ConVars[name] = Color(unpack(ConVars[name]))
	end


	HUDWidth = (GetConVar("HudW") or  CreateClientConVar("HudW", 240, true, false)):GetInt()
	HUDHeight = (GetConVar("HudH") or CreateClientConVar("HudH", 115, true, false)):GetInt()

	if not cvars.GetConVarCallbacks("HudW", false) and not cvars.GetConVarCallbacks("HudH", false) then
		cvars.AddChangeCallback("HudW", function() timer.Simple(0,ReloadConVars) end)
		cvars.AddChangeCallback("HudH", function() timer.Simple(0,ReloadConVars) end)
	end
end
ReloadConVars()


local function formatNumber(n)
	if not n then return "" end
	if n >= 1e14 then return tostring(n) end
    n = tostring(n)
    local sep = sep or ","
    local dp = string.find(n, "%.") or #n+1
	for i=dp-4, 1, -3 do
		n = n:sub(1, i) .. sep .. n:sub(i+1)
    end
    return n
end


local Scrw, Scrh, RelativeX, RelativeY
/*---------------------------------------------------------------------------
HUD Seperate Elements
---------------------------------------------------------------------------*/
local tblFonts = { }
tblFonts["DebugFixed"] = {
	font = "Courier New",
	size = 10,
	weight = 500,
	antialias = true,
}

tblFonts["DebugFixedSmall"] = {
	font = "Courier New",
	size = 7,
	weight = 500,
	antialias = true,
}

tblFonts["DefaultFixedOutline"] = {
	font = "Lucida Console",
	size = 10,
	weight = 0,
	outline = true,
}

tblFonts["MenuItem"] = {
	font = "Tahoma",
	size = 12,
	weight = 500,
}

tblFonts["Default"] = {
	font = "Tahoma",
	size = 13,
	weight = 500,
}

tblFonts["TabLarge"] = {
	font = "Tahoma",
	size = 13,
	weight = 700,
	shadow = true,
}

tblFonts["DefaultBold"] = {
	font = "Tahoma",
	size = 13,
	weight = 1000,
}

tblFonts["DefaultUnderline"] = {
	font = "Tahoma",
	size = 13,
	weight = 500,
	underline = true,
}

tblFonts["DefaultSmall"] = {
	font = "Tahoma",
	size = 1,
	weight = 0,
}

tblFonts["DefaultSmallDropShadow"] = {
	font = "Tahoma",
	size = 11,
	weight = 0,
	shadow = true,
}

tblFonts["DefaultVerySmall"] = {
	font = "Tahoma",
	size = 12,
	weight = 600,
	outline = true,
}

tblFonts["DefaultLarge"] = {
	font = "Tahoma",
	size = 16,
	weight = 0,
}

tblFonts["UiBold"] = {
	font = "Tahoma",
	size = 12,
	weight = 1000,
}

tblFonts["MenuLarge"] = {
	font = "Verdana",
	size = 15,
	weight = 600,
	antialias = true,
}

tblFonts["ConsoleText"] = {
	font = "Lucida Console",
	size = 10,
	weight = 500,
}

tblFonts["Marlett"] = {
	font = "Marlett",
	size = 13,
	weight = 0,
	symbol = true,
}

tblFonts["Trebuchet24"] = {
	font = "Trebuchet MS",
	size = 24,
	weight = 900,
}

tblFonts["Trebuchet22"] = {
	font = "Trebuchet MS",
	size = 22,
	weight = 900,
}

tblFonts["Trebuchet20"] = {
	font = "Trebuchet MS",
	size = 20,
	weight = 900,
}

tblFonts["Trebuchet19"] = {
	font = "Trebuchet MS",
	size = 19,
	weight = 900,
}

tblFonts["Trebuchet18"] = {
	font = "Trebuchet MS",
	size = 18,
	weight = 900,
}

tblFonts["HUDNumber"] = {
	font = "Trebuchet MS",
	size = 40,
	weight = 900,
}

tblFonts["HUDNumber1"] = {
	font = "Trebuchet MS",
	size = 41,
	weight = 900,
}

tblFonts["HUDNumber2"] = {
	font = "Trebuchet MS",
	size = 42,
	weight = 900,
}

tblFonts["HUDNumber3"] = {
	font = "Trebuchet MS",
	size = 43,
	weight = 900,
}

tblFonts["HUDNumber4"] = {
	font = "Trebuchet MS",
	size = 44,
	weight = 900,
}

tblFonts["HUDNumber5"] = {
	font = "Trebuchet MS",
	size = 45,
	weight = 900,
}

tblFonts["HudHintTextLarge"] = {
	font = "Verdana",
	size = 14,
	weight = 1000,
	antialias = true,
	additive = true,
}

tblFonts["HudHintTextSmall"] = {
	font = "Verdana",
	size = 11,
	weight = 0,
	antialias = true,
	additive = true,
}

tblFonts["CenterPrintText"] = {
	font = "Trebuchet MS",
	size = 18,
	weight = 900,
	antialias = true,
	additive = true,
}

tblFonts["DefaultFixed"] = {
	font = "Lucida Console",
	size = 10,
	weight = 0,
}

tblFonts["DefaultFixedDropShadow"] = {
	font = "Lucida Console",
	size = 10,
	weight = 0,
	shadow = true,
}

tblFonts["CloseCaption_Normal"] = {
	font = "Tahoma",
	size = 16,
	weight = 500,
}

tblFonts["CloseCaption_Italic"] = {
	font = "Tahoma",
	size = 16,
	weight = 500,
	italic = true,
}

tblFonts["CloseCaption_Bold"] = {
	font = "Tahoma",
	size = 16,
	weight = 900,
}

tblFonts["CloseCaption_BoldItalic"] = {
	font = "Tahoma",
	size = 16,
	weight = 900,
	italic = true,
}

tblFonts["TargetID"] = {
	font = "Trebuchet MS",
	size = 22,
	weight = 900,
	antialias = true,
}

tblFonts["TargetIDSmall"] = {
	font = "Trebuchet MS",
	size = 18,
	weight = 900,
	antialias = true,
}

tblFonts["BudgetLabel"] = {
	font = "Courier New",
	size = 14,
	weight = 400,
	outline = true,
}

tblFonts["j0rpi"] = {
	font = "Tahoma",
	size = 23,
	weight = 200,
	antialias = false,
	shadow = false,
	outline = true,
}

tblFonts["j0rpi2"] = {
	font = "Tahoma",
	size = 14,
	weight = 200,
	antialias = false,
	shadow = false,
	outline = true,
}

tblFonts["j0rpi3"] = {
	font = "Tahoma",
	size = 14,
	weight = 900,
	antialias = true,
	shadow = false,
	outline = false,
}

tblFonts["j0rpi4"] = {
	font = "Tahoma",
	size = 18,
	weight = 600,
	antialias = false,
	shadow = false,
	outline = true,
}

tblFonts["j0rpi5"] = {
	font = "Tahoma",
	size = 12,
	weight = 600,
	antialias = true,
	shadow = false,
	outline = true,
}



tblFonts["j0rpi6"] = {
	font = "Tahoma",
	size = 16,
	weight = 600,
	antialias = false,
	shadow = false,
	outline = true,
}

tblFonts["j0rpi7"] = {
	font = "Tahoma",
	size = 16,
	weight = 600,
	antialias = false,
	shadow = false,
	outline = false,
}

tblFonts["j0rpi8"] = {
	font = "Verdana",
	size = 12,
	weight = 100,
	antialias = false,
	shadow = false,
	outline = true,
}

tblFonts["j0rpiAA"] = {
	font = "Segoe UI Light",
	size = 19,
	weight = 100,
	antialias = true,
	shadow = false,
	outline = false,
}

tblFonts["j0rpiAA2"] = {
	font = "Segoe UI Light",
	size = 18,
	weight = 100,
	antialias = true,
	shadow = false,
	outline = false,
}

tblFonts["j0rpiAA3"] = {
	font = "Segoe UI Light",
	size = 24,
	weight = 200,
	antialias = true,
	shadow = true,
	outline = false,
}


for k,v in SortedPairs( tblFonts ) do
	surface.CreateFont( k, tblFonts[k] );

	--print( "Added font '"..k.."'" );
end
local function DrawInfo()


    
	
	-- FAdmin is still fucking up. Run this command on player connect
    --RunConsoleCommand("FAdmin_IsScoreboard", "0")
	
	local wep = localplayer:GetActiveWeapon()

	if IsValid(wep) and GAMEMODE.Config.weaponhud then
        local name = wep:GetPrintName();
		draw.DrawText("Weapon: "..name, "UiBold", RelativeX + 5, RelativeY - HUDHeight - 18, Color(255, 255, 255, 255), 0)
	end
end

local Page = Material("icon16/application_view_list.png")
local function GunLicense()
	if localplayer:getDarkRPVar("HasGunlicense") then
		surface.SetMaterial(Page)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(505, ScrH() - 60, 25, 25)
	end
end

local WantedIcon = Material( "icon16/exclamation.png" )
local function DrawWantedIcon()
	if LocalPlayer():getDarkRPVar("wanted") then
		surface["SetMaterial"]( WantedIcon )
		surface["SetDrawColor"]( 255, 255, 255, 255 )
		surface["DrawTexturedRect"]( 505, ScrH() - 92, 23, 23 )
	end
end
		

--local function Agenda()
--	local DrawAgenda, AgendaManager = DarkRPAgendas[localplayer:Team()], localplayer:Team()
--	if not DrawAgenda then
--		for k,v in pairs(DarkRPAgendas) do
--			if table.HasValue(v.Listeners or {}, localplayer:Team()) then
--				DrawAgenda, AgendaManager = DarkRPAgendas[k], k
--				break
--			end
--		end
--	end
--	if DrawAgenda then
--		draw.RoundedBox(0, ScrW() / 2 - 250, 10, 460, 74, Color(0, 0, 0, 100))
--		draw.RoundedBox(0, ScrW() / 2 - 248, 12, 456, 70, Color(0, 0, 0, 100))
--		draw.RoundedBox(0, ScrW() / 2 - 248, 12, 456, 20, Color(0, 0, 0, 100))
--
--		draw.DrawText("AGENDA", "DarkRPHUD1", ScrW() / 2 - 50, 12, Color(255,255,255,255),0)
--
--		local AgendaText = {}
--		for k,v in pairs(team.GetPlayers(AgendaManager)) do
--			if not v.DarkRPVars then continue end
--			table.insert(AgendaText, v:getDarkRPVar("agenda"))
--		end
--
--		local text = table.concat(AgendaText, "\n")
--		text = text:gsub("//", "\n"):gsub("\\n", "\n")
--		text = GAMEMODE:TextWrap(text, "DarkRPHUD1", 440)
--		draw.DrawText(text, "DarkRPHUD1", ScrW() / 2 - 240, 35, Color(255,255,255,255),0)
--	end
--end

local VoiceChatTexture = surface.GetTextureID("voice/icntlk_pl")
local function DrawVoiceChat()
	if localplayer.DRPIsTalking then
		local chbxX, chboxY = chat.GetChatBoxPos()

		local Rotating = math.sin(CurTime()*3)
		local backwards = 0
		if Rotating < 0 then
			Rotating = 1-(1+Rotating)
			backwards = 180
		end
		surface.SetTexture(VoiceChatTexture)
		surface.SetDrawColor(ConVars.Healthforeground)
		surface.DrawTexturedRectRotated(ScrW() - 100, chboxY, Rotating*96, 96, backwards)
	end
end

local function LockDown()
	local chbxX, chboxY = chat.GetChatBoxPos()
	if util.tobool(GetConVarNumber("DarkRP_LockDown")) then
		local cin = (math.sin(CurTime()) + 1) / 2
		local chatBoxSize = math.floor(ScrH() / 4)
		draw.DrawText(DarkRP.getPhrase("lockdown_started"), "ScoreboardSubtitle", chbxX, chboxY + chatBoxSize, Color(cin * 255, 0, 255 - (cin * 255), 255), TEXT_ALIGN_LEFT)
	end
end

local Arrested = function() end

usermessage.Hook("GotArrested", function(msg)
	local StartArrested = CurTime()
	local ArrestedUntil = msg:ReadFloat()

	Arrested = function()
		if CurTime() - StartArrested <= ArrestedUntil and localplayer:getDarkRPVar("Arrested") then
		draw.DrawText(DarkRP.getPhrase("youre_arrested", math.ceil(ArrestedUntil - (CurTime() - StartArrested))), "DarkRPHUD1", ScrW()/2, ScrH() - ScrH()/12, Color(255,255,255,255), 1)
		elseif not localplayer:getDarkRPVar("Arrested") then
			Arrested = function() end
		end
	end
end)

local AdminTell = function() end

usermessage.Hook("AdminTell", function(msg)
	local Message = msg:ReadString()

	AdminTell = function()
		draw.RoundedBox(4, 10, 10, ScrW() - 20, 100, Color(0, 0, 0, 200))
		draw.DrawText(DarkRP.getPhrase("listen_up"), "GModToolName", ScrW() / 2 + 10, 10, Color(255, 255, 255, 255), 1)
		draw.DrawText(Message, "ChatFont", ScrW() / 2 + 10, 80, Color(200, 30, 30, 255), 1)
	end

	timer.Simple(10, function()
		AdminTell = function() end
	end)
end)

/*---------------------------------------------------------------------------
Drawing the HUD elements such as Health etc.
---------------------------------------------------------------------------*/
local name = Material("icon16/user_suit.png")
local job = Material("icon16/wrench.png")
local salarr = Material("icon16/money_add.png")
local banii = Material("icon16/money_dollar.png")
local played = Material("icon16/time.png")
local gradient = Material("materials/darkrp/j0rpihpgradient6.png")
local hpgradient = Material("materials/darkrp/j0rpihpgradient2.png")
local pigeonrp = Material("materials/darkrp/pigeon2.png")
local star = Material("icon16/star.png")
local heart = Material("icon16/heart.png")
local heart_add = Material("icon16/heart_add.png")
local shield = Material("icon16/shield.png")
local contributor = Material("icon16/add.png")
local heart = Material("icon16/heart.png")
local donator = Material("icon16/asterisk_orange.png")
local smiley = Material("icon16/emoticon_smile.png")
local developer = Material("icon16/wrench.png")
local owner = Material("icon16/rosette.png")
local princess = Material("icon16/user_female.png")
local vip = Material("icon16/accept.png")
local mod = Material("icon16/emoticon_grin.png")
local OwnerIcon = Material("icon16/shield.png")
local SuperAdminIcon = Material("icon16/shield.png")
local AdminIcon = Material("icon16/award_star_gold_1.png")
local ModIcon = Material("icon16/emoticon_grin.png")
local DevIcon = Material("icon16/wrench.png")
local TrialModIcon = Material("icon16/emoticon_smile.png")
local DonatorIcon = Material("icon16/heart.png")
local RespectedIcon = Material("icon16/heart_add.png")
local UserIcon = Material("icon16/user.png")
local ErrorIcon = Material("icon16/error.png")

Health = 0
surface.CreateFont("RankFont",{font = "akbar", size = 30, weight = 400, antialias = 0})
local function DrawHUD()
	localplayer = localplayer and IsValid(localplayer) and localplayer or LocalPlayer()
	if not IsValid(localplayer) then return end

	local shouldDraw = hook.Call("HUDShouldDraw", GAMEMODE, "DarkRP_HUD")
	if shouldDraw == false then return end

	Scrw, Scrh = ScrW(), ScrH()
	RelativeX, RelativeY = 0, Scrh

	local Salary = 	"Salary: " .. GAMEMODE.Config.currency .. (localplayer:getDarkRPVar("salary") or 0)
	local Job = localplayer:getDarkRPVar("job") or ""
	local Wallet = "Wallet: " .. GAMEMODE.Config.currency .. (formatNumber(localplayer:getDarkRPVar("money") or 0) or 0)
	

	
	-- Draw Smurf :)
	surface.SetMaterial(pigeonrp)
	surface.SetDrawColor(200,200,200,255)
	surface.DrawTexturedRect(0, 0, 250, 69)
	
	
	
	-- Draw Ammo Box
--	if LocalPlayer():Alive() && LocalPlayer():GetActiveWeapon():IsValid() && LocalPlayer():GetActiveWeapon():Clip1() < 0 && LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()) < 0 then
--      
--	  draw.RoundedBox(0, ScrW() - 200, ScrH() - 50, 180, 45, Color(0,0,0,200))
--	  surface.SetDrawColor(255,255,255,150)
--	  surface.DrawOutlinedRect( ScrW() - 200, ScrH() - 50, 180, 45 )
	
--	-- Magazine Size
--	draw.SimpleText("0", "j0rpi", ScrW() - 145, ScrH() - 25, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	-- Ammo Seperator
--	draw.SimpleText("|", "j0rpi", ScrW() - 115, ScrH() - 25, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	-- Total Ammo
--	draw.SimpleText("0", "j0rpi", ScrW() - 80, ScrH() - 25, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
--	elseif LocalPlayer():Alive() && LocalPlayer():GetActiveWeapon():GetClass() == "weapon_fists" then
	
--	else
	
--	draw.RoundedBox(0, ScrW() - 200, ScrH() - 50, 180, 45, Color(0,0,0,200))
--	surface.SetDrawColor(255,255,255,150)
--	surface.DrawOutlinedRect( ScrW() - 200, ScrH() - 50, 180, 45 )
	
	-- Magazine Size
--	draw.SimpleText(LocalPlayer():GetActiveWeapon():Clip1() or "0", "j0rpi", ScrW() - 145, ScrH() - 25, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	-- Ammo Seperator
--	draw.SimpleText("|", "j0rpi", ScrW() - 115, ScrH() - 25, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	-- Total Ammo
--	draw.SimpleText(LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()) or "0", "j0rpi", ScrW() - 80, ScrH() - 25, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
--	end
	
	local lowammo = Color(120,0,0,200)
	if LocalPlayer():Alive() && LocalPlayer():GetActiveWeapon():IsValid() then
	if LocalPlayer():GetActiveWeapon():Clip1() < 0 then
	
	elseif LocalPlayer():GetActiveWeapon():GetClass() == "weapon_physcannon" or LocalPlayer():GetActiveWeapon():GetClass() == "weapon_physgun" then
	
	else
	
	if LocalPlayer():GetActiveWeapon():Clip1() < 6 then
	draw.SimpleText("Press R To Reload!", "j0rpi3", ScrW() - 170, ScrH() - 70, Color(0,0,0,255))
	draw.SimpleText("Press R To Reload!", "j0rpi3", ScrW() - 171, ScrH() - 71, Color(255,0,0,255))
	draw.RoundedBox(0, ScrW() - 200, ScrH() - 50, 180, 45, lowammo)
    surface.SetDrawColor(255,255,255,150)
	surface.DrawOutlinedRect( ScrW() - 200, ScrH() - 50, 180, 45 )
	else
	lowammo = Color(0,0,0,200)
	draw.RoundedBox(0, ScrW() - 200, ScrH() - 50, 180, 45, lowammo)
	surface.SetDrawColor(255,255,255,150)
	surface.DrawOutlinedRect( ScrW() - 200, ScrH() - 50, 180, 45 )
	end
	end
	
	
	-- Magazine Size
	if LocalPlayer():GetActiveWeapon():Clip1() < 0  then
	-- Do nada.
	elseif LocalPlayer():GetActiveWeapon():GetClass() == "weapon_physcannon" or LocalPlayer():GetActiveWeapon():GetClass() == "weapon_physgun" then
	-- Do nada.
	else
	draw.SimpleText(LocalPlayer():GetActiveWeapon():Clip1(), "j0rpi", ScrW() - 145, ScrH() - 28, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	-- Ammo Seperator
	draw.SimpleText("|", "j0rpi", ScrW() - 111, ScrH() - 28, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	-- Total Ammo
	draw.SimpleText(LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()) or "0", "j0rpi", ScrW() - 74, ScrH() - 28, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	
	
    end
	
 


    -- Draw revision
	
    draw.SimpleText(version, "j0rpi8", 0 + 420, ScrH() - 110, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	-- Background
	
	draw.RoundedBox(0, 5, ScrH() / 2 + 440, 500, 95, Color(0,0,0,200))
    surface.SetDrawColor(0,0,0,255)
	surface.DrawOutlinedRect( 5, ScrH() / 2 + 440, 500, 95 )
	-- Job
	
	draw.RoundedBox(0, 0 + 10, ScrH() - 93, 240, 25, team.GetColor(LocalPlayer():Team()))
	draw.RoundedBox(0, 0 + 10, ScrH() - 93, 240, 10, Color(255,255,255,20))
	surface.SetDrawColor(0,0,0,255)
	surface.DrawOutlinedRect( 0 + 10, ScrH() - 93, 240, 25 )
	surface.SetMaterial(job)
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(0 + 15, ScrH() - 88, 16, 16)
	draw.SimpleText(Job, "j0rpiAA2", 0 + 135, ScrH() - 80, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	-- Name
	draw.RoundedBox(0, 0 + 260, ScrH() - 93, 240, 25, Color(0,0,0,200))
	draw.RoundedBox(0, 0 + 260, ScrH() - 93, 240, 10, Color(255,255,255,10))
	surface.SetDrawColor(0,0,0,255)
	surface.DrawOutlinedRect( 0 + 260, ScrH() - 93, 240, 25 )
	surface.SetMaterial(played)
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(0 + 265, ScrH() - 88, 16, 16)

function timeToStr( time )
	local tmp = time
	local s = tmp % 60
	tmp = math.floor( tmp / 60 )
	local m = tmp % 60
	tmp = math.floor( tmp / 60 )
	local h = tmp % 24
	tmp = math.floor( tmp / 24 )
	local d = tmp % 7
	local w = math.floor( tmp / 7 )

	return string.format( "%02i:%02i:%02i", h, m, s )
end

	--local newtime = string.ToMinutesSeconds(CurTime(), "%00i:%00i:%0i")
	draw.SimpleText("Session: " .. timeToStr( CurTime() - LocalPlayer():GetUTimeStart() ),"j0rpiAA2", 0 + 385, ScrH() - 80, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	-- Wallet
	draw.RoundedBox(0, 0 + 260, ScrH() - 62, 240, 25, Color(0,0,0,200))
	draw.RoundedBox(0, 0 + 260, ScrH() - 62, 240, 10, Color(255,255,255,10))
	surface.SetDrawColor(0,0,0,255)
	surface.DrawOutlinedRect( 0 + 260, ScrH() - 62, 240, 25 )
	surface.SetMaterial(banii)
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(0 + 265, ScrH() - 58, 16, 16)
	draw.SimpleText(Wallet, "j0rpiAA2", 0 + 382,ScrH() - 49, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	-- Salary
	draw.RoundedBox(0, 0 + 10, ScrH() - 62, 240, 25, Color(0,0,0,200))
	draw.RoundedBox(0, 0 + 10, ScrH() - 62, 240, 10, Color(255,255,255,10))
	surface.SetDrawColor(0,0,0,255)
	surface.DrawOutlinedRect( 0 + 10, ScrH() - 62, 240, 25 )
	surface.SetMaterial(salarr)
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(0 + 15, ScrH() - 58, 16, 16)
	draw.SimpleText(Salary, "j0rpiAA2", 0 + 135,ScrH() - 49, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)	

	-- Health

	draw.RoundedBox(0, 0 + 10, ScrH() - 32, 490, 21, Color(0,0,0,200))
	
	Health = math.min(100, (Health == localplayer:Health() and Health) or Lerp(0.1, Health, localplayer:Health()))
	local DrawHealth = math.Min(Health / GAMEMODE.Config.startinghealth, 1)

	if Draw_Health == 0 then 

	else
		draw.RoundedBox(0, 0 + 10, ScrH() - 32, 490 * DrawHealth, 21, Color(200,0,0,255))
        draw.RoundedBox(0, 0 + 10, ScrH() - 32, 490, 11, Color(255,255,255,20))
		surface.SetDrawColor(0,0,0,255)
	    surface.DrawOutlinedRect( 0 + 10, ScrH() - 32, 490, 21 )
		surface.SetMaterial(heart)
	surface.SetDrawColor(255,255,255,255)
	surface.DrawTexturedRect(0 + 15, RelativeY - 29, 16, 16)
	end	

	--draw.SimpleText("Health: " .. math.Max(0, math.Round(LocalPlayer():Health())),"j0rpi2", ScrW() / 2 + 1, RelativeY - 24, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText("HP: " .. math.Max(0, math.Round(LocalPlayer():Health())).."%","j0rpiAA2", 0 + 255, RelativeY - 22, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	function hidehud(name)
	for k, v in pairs({"CHudAmmo", "CHudSecondaryAmmo", "CHudBattery", "CHudHealth"})do
		if name == v then return false end
	end
end
    
    hook.Add("HUDShouldDraw", "hide", hidehud)
	DrawInfo()
	GunLicense()
	--Agenda()
	DrawVoiceChat()
	LockDown()

	Arrested()
	AdminTell()
end

/*---------------------------------------------------------------------------
Entity HUDPaint things
---------------------------------------------------------------------------*/
local function DrawPlayerInfo(ply)
	local pos = ply:EyePos()

	pos.z = pos.z + 10 -- The position we want is a bit above the position of the eyes
	pos = pos:ToScreen()
	pos.y = pos.y - 50 -- Move the text up a few pixels to compensate for the height of the text
	--if ply:IsSuperAdmin()  then
   -- draw.RoundedBox(8, pos.x - 100, pos.y, 200, 58, Color(0,0,0,100))
	--end
	

	
	if ply:GetUserGroup() == "user" then
	draw.RoundedBox(0, pos.x - 100, pos.y, 200, 52, Color(0,0,0,100))
	surface.SetDrawColor(0,0,0,255)
	surface.DrawOutlinedRect( pos.x - 100, pos.y, 200, 52 )
	draw.RoundedBox(0, pos.x - 100, pos.y + 51, 200, 15, Color(0,0,0,100))
	surface.SetDrawColor(0,0,0,255)
	surface.DrawOutlinedRect( pos.x - 100, pos.y + 51, 200, 15 )
	  else
	   draw.RoundedBox(0, pos.x - 100, pos.y, 200, 65, Color(0,0,0,100))
	   surface.SetDrawColor(0,0,0,255)
	  surface.DrawOutlinedRect( pos.x - 100, pos.y, 200, 65 )
	  
	  draw.RoundedBox(0, pos.x - 100, pos.y + 64, 200, 15, Color(0,0,0,100))
	   surface.SetDrawColor(0,0,0,255)
	  surface.DrawOutlinedRect( pos.x - 100, pos.y + 64, 200, 15 )
	end
	
	
	
	struc = {}
    struc["pos"] = {pos.x + 1, pos.y + 1}
    struc["color"] = Color(0, 0, 0, 255)
    struc["text"] = ply:Nick()
    struc["font"] = "ChatFont"
    struc["xalign"] = TEXT_ALIGN_CENTER
    struc["yalign"] = TEXT_ALIGN_CENTER
	
	struc2 = {}
    struc2["pos"] = {pos.x, pos.y}
    struc2["color"] = team.GetColor(ply:Team())
    struc2["text"] = ply:Nick()
    struc2["font"] = "ChatFont"
    struc2["xalign"] = TEXT_ALIGN_CENTER
    struc2["yalign"] = TEXT_ALIGN_CENTER
	
    --draw.TextShadow( struc, 2, 150 )
	if GAMEMODE.Config.showname then
	
		--draw.DrawText(ply:Nick(), "ChatFont", pos.x + 1, pos.y + 1, Color(0, 0, 0, 255), 1)
		--draw.TextShadow(struc, 2, 150)
		if ply:GetUserGroup() == "user" then
		--draw.DrawText(ply:Nick(), "j0rpi7", pos.x, pos.y + 2, Color(255,255,255,255), 1)
		draw.DrawText(ply:Nick(), "j0rpiAA", pos.x + 0, pos.y + 1, team.GetColor(ply:Team()), 1)
		--draw.SimpleTextOutlined( ply:Nick(), "j0rpi7", pos.x , pos.y + 1, team.GetColor(LocalPlayer():Team()), 0, 0, 1, Color(255,255,255,255) )
		else 
		draw.DrawText(ply:Nick(), "j0rpiAA", pos.x, pos.y + 2, Color(255,255,0,255), 1)
		end
		
		--draw.TextShadow(Struc2, 2, 150)
		--draw.DrawText("Health: "..ply:Health(), "j0rpi5", pos.x + 1, pos.y + 25, Color(0, 0, 0, 255), 1)
		draw.DrawText("Health: "..ply:Health(), "j0rpiAA", pos.x, pos.y + 31, Color(255,255,255,255), 1)
	end

	if GAMEMODE.Config.showjob then
		local teamname = team.GetName(ply:Team())
		--draw.DrawText(ply:getDarkRPVar("job") or teamname, "j0rpi5", pos.x + 1, pos.y + 19, Color(0, 0, 0, 255), 1)
		draw.DrawText(ply:getDarkRPVar("job") or teamname, "j0rpiAA", pos.x, pos.y + 16, Color(255, 255, 255, 255), 1)
			 if ply:GetUserGroup() == "developer" then
		     --draw.DrawText("Developer", "DermaDefault", pos.x + 1, pos.y + 41, Color(0, 0, 0, 255), 1)
			 draw.DrawText("Developer", "j0rpi5", pos.x, pos.y + 47, Color(127, 95, 255), 1)
			 surface.SetMaterial(developer)
	         surface.SetDrawColor(255,255,255,255)
	         surface.DrawTexturedRect(pos.x - 50, pos.y + 48, 14, 14)
			 end
			 
			 if ply:GetUserGroup() == "superadmin" then
		     --draw.DrawText("Super Admin", "DermaDefault", pos.x + 1, pos.y + 41, Color(0, 0, 0, 255), 1)
			 draw.DrawText("Super Admin", "j0rpiAA", pos.x, pos.y + 47, Color(0, 255, 100, 255), 1)
			 surface.SetMaterial(shield)
	         surface.SetDrawColor(255,255,255,255)
	         surface.DrawTexturedRect(pos.x - 50, pos.y + 48, 14, 14)
			 end
			 
			 if ply:GetUserGroup() == "headadmin" then
		     --draw.DrawText("Head Admin", "DermaDefault", pos.x + 1, pos.y + 41, Color(0, 0, 0, 255), 1)
			 draw.DrawText("Head Admin", "j0rpiAA", pos.x, pos.y + 47, Color(0, 255, 100, 255), 1)
			 surface.SetMaterial(shield)
	         surface.SetDrawColor(255,255,255,255)
	         surface.DrawTexturedRect(pos.x - 50, pos.y + 48, 14, 14)
			 end
			 
			 if ply:GetUserGroup() == "owner" then
				   --draw.DrawText("Owner", "j0rpi5", pos.x + 1, pos.y + 41, Color(255, 255, 255, 255), 1)
			       draw.DrawText("PigeonRP Owner", "j0rpiAA", pos.x, pos.y + 45, Color(0, 222, 255, 255), 1)
			       surface.SetMaterial(OwnerIcon)
	               surface.SetDrawColor(255,255,255,255)
	               surface.DrawTexturedRect(pos.x - 72, pos.y + 48, 12, 12)
				  end
				  
			 if ply:GetUserGroup() == "co.owner" then
				   --draw.DrawText("Owner", "j0rpi5", pos.x + 1, pos.y + 41, Color(255, 255, 255, 255), 1)
			       draw.DrawText("Co. Owner", "j0rpiAA", pos.x, pos.y + 45, Color(0, 100, 255, 255), 1)
			       surface.SetMaterial(owner)
	               surface.SetDrawColor(255,255,255,255)
	               surface.DrawTexturedRect(pos.x - 25, pos.y + 48, 12, 12)
				  end
				  
			 if ply:GetUserGroup() == "princess" then
				   --draw.DrawText("Owner", "j0rpi5", pos.x + 1, pos.y + 41, Color(255, 255, 255, 255), 1)
			       draw.DrawText("Princess <3", "j0rpiAA", pos.x, pos.y + 45, Color(255, 0, 191, 255), 1)
			       surface.SetMaterial(princess)
	               surface.SetDrawColor(255,255,255,255)
	               surface.DrawTexturedRect(pos.x - 50, pos.y + 48, 12, 12)
				  end

 				if ply:GetUserGroup() == "donator" then
				   --draw.DrawText("Smurf Donator", "j0rpi5", pos.x + 1, pos.y + 41, Color(255, 255, 255, 255), 1)
			       draw.DrawText("Smurfie Donator", "j0rpiAA", pos.x, pos.y + 45, Color(177, 44, 144, 255), 1)
			       surface.SetMaterial(heart)
	               surface.SetDrawColor(255,255,255,255)
	               surface.DrawTexturedRect(pos.x - 70, pos.y + 48, 12, 12)
				  end
				 
				  if ply:GetUserGroup() == "sdonator" then
				   --draw.DrawText("Super Donator", "j0rpi5", pos.x + 1, pos.y + 41, Color(255, 255, 255, 255), 1)
			       draw.DrawText("Super Donator", "j0rpiAA", pos.x, pos.y + 45, Color(255, 50, 50, 255), 1)
			       surface.SetMaterial(heart)
	               surface.SetDrawColor(255,255,255,255)
	               surface.DrawTexturedRect(pos.x - 70, pos.y + 48, 12, 12)
				  end
				  
				  if ply:GetUserGroup() == "admin" then
				   --draw.DrawText("Administrator", "j0rpi5", pos.x + 1, pos.y + 41, Color(255, 255, 255, 255), 1)
			       draw.DrawText("Administrator", "j0rpiAA", pos.x, pos.y + 45, Color(255, 0, 0, 255), 1)
			       surface.SetMaterial(star)
	               surface.SetDrawColor(255,255,255,255)
	               surface.DrawTexturedRect(pos.x - 50, pos.y + 48, 12, 12)
				  end
				  
				  if ply:GetUserGroup() == "moderator" then
				   --draw.DrawText("Respected Donator", "j0rpi5", pos.x + 1, pos.y + 41, Color(255, 255, 255, 255), 1)
			       draw.DrawText("Moderator", "j0rpiAA", pos.x, pos.y + 45, Color(63, 79, 127, 255), 1)
			       surface.SetMaterial(mod)
	               surface.SetDrawColor(255,255,255,255)
	               surface.DrawTexturedRect(pos.x - 50, pos.y + 48, 12, 12)
				  end
				  
				   if ply:GetUserGroup() == "trialmod" then
				   --draw.DrawText("Trial Moderator", "j0rpi5", pos.x + 1, pos.y + 41, Color(255, 255, 255, 255), 1)
			       draw.DrawText("Trial Mod", "j0rpiAA", pos.x, pos.y + 45, Color(50, 150, 65, 255), 1)
			       surface.SetMaterial(smiley)
	               surface.SetDrawColor(255,255,255,255)
	               surface.DrawTexturedRect(pos.x - 50, pos.y + 48, 12, 12)
				  end
				  
				  if ply:GetUserGroup() == "vip" then
				   --draw.DrawText("V.I.P", "j0rpi5", pos.x + 1, pos.y + 41, Color(255, 255, 255, 255), 1)
			       draw.DrawText("VIP", "j0rpiAA", pos.x, pos.y + 45, Color(127, 63, 111, 255), 1)
				   surface.SetMaterial(vip)
	               surface.SetDrawColor(255,255,255,255)
	               surface.DrawTexturedRect(pos.x - 50, pos.y + 45, 12, 12)
				  end
				  
				  if ply:GetUserGroup() == "vip+" then
				   --draw.DrawText("V.I.P +", "j0rpi5", pos.x + 1, pos.y + 41, Color(255, 255, 255, 255), 1)
			       draw.DrawText("VIP+", "j0rpiAA", pos.x, pos.y + 47, Color(127, 63, 111, 255), 1)
				   surface.SetMaterial(vip)
	               surface.SetDrawColor(255,255,255,255)
	               surface.DrawTexturedRect(pos.x - 50, pos.y + 45, 12, 12)
				  end
				  
	end

	if ply:getDarkRPVar("HasGunlicense") then
		--draw.RoundedBox(8, pos.x - 100, pos.y - 400, 200, 58, Color(0,0,0,100))
		--draw.DrawText("Gunlicense: Yes", "j0rpi5", pos.x + 1, pos.y + 60, Color(0, 0, 0, 255), 1)
		if ply:GetUserGroup() == "user" then
		draw.DrawText("Gunlicense: Yes", "j0rpiAA", pos.x, pos.y + 48, Color(255, 255, 255, 200), 1)
		else
		draw.DrawText("Gunlicense: Yes", "j0rpiAA", pos.x, pos.y + 61, Color(255, 255, 255, 200), 1)
		end
	end
	if not ply:getDarkRPVar("HasGunlicense") then
		--draw.RoundedBox(8, pos.x - 100, pos.y - 400, 200, 58, Color(0,0,0,100))
		--draw.DrawText("Gunlicense: No", "j0rpi5", pos.x + 1, pos.y + 64, Color(0, 0, 0, 255), 1)
		if ply:GetUserGroup() == "user" then
		draw.DrawText("Gunlicense: No", "j0rpiAA", pos.x, pos.y + 48, Color(255, 255, 255, 200), 1)
		else 
		draw.DrawText("Gunlicense: No", "j0rpiAA", pos.x, pos.y + 61, Color(255, 255, 255, 200), 1)
		end
	end
end

surface.CreateFont("WantedFont",{font = "akbar", size = 21, weight = 400, antialias = 0})

local function DrawWantedInfo(ply)
	if not ply:Alive() then return end

	local pos = ply:EyePos()
	if not pos:isInSight({localplayer, ply}) then return end

	pos.z = pos.z + 38
	pos = pos:ToScreen()

	draw.SimpleTextOutlined( "Wanted by police!", "WantedFont", pos.x + 1, pos.y - 41, Color(255, 165, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) )
	draw.SimpleTextOutlined( "Reason: " .. tostring(ply.DarkRPVars["wantedReason"]), "WantedFont", pos.x + 1, pos.y - 24, Color(255, 165, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) )
end

/*---------------------------------------------------------------------------
The Entity display: draw HUD information about entities
---------------------------------------------------------------------------*/
local function DrawEntityDisplay()
	local shouldDraw = hook.Call("HUDShouldDraw", GAMEMODE, "DarkRP_EntityDisplay")
	if shouldDraw == false then return end

	local shootPos = localplayer:GetShootPos()
	local aimVec = localplayer:GetAimVector()

	for k, ply in pairs(player.GetAll()) do
		if not ply:Alive() then continue end
		local hisPos = ply:GetShootPos()
		if ply:getDarkRPVar("wanted") then DrawWantedInfo(ply) end

		if GAMEMODE.Config.globalshow and ply ~= localplayer then
			DrawPlayerInfo(ply)
		-- Draw when you're (almost) looking at him
		elseif not GAMEMODE.Config.globalshow and hisPos:Distance(shootPos) < 400 then
			local pos = hisPos - shootPos
			local unitPos = pos:GetNormalized()
			if unitPos:Dot(aimVec) > 0.95 then
				local trace = util.QuickTrace(shootPos, pos, localplayer)
				if trace.Hit and trace.Entity ~= ply then return end
				DrawPlayerInfo(ply)
			end
		end
	end

	local tr = localplayer:GetEyeTrace()
    if IsValid(tr.Entity) and tr.Entity:isKeysOwnable( ) and tr.Entity:GetPos():Distance(LocalPlayer():GetPos() ) < 200 then
    tr.Entity:drawOwnableInfo()
end
end

/*---------------------------------------------------------------------------
Zombie display
---------------------------------------------------------------------------*/
local function DrawZombieInfo()
	if not localplayer:getDarkRPVar("zombieToggle") then return end
	local shouldDraw = hook.Call("HUDShouldDraw", GAMEMODE, "DarkRP_ZombieInfo")
	if shouldDraw == false then return end

	for x=1, localplayer:getDarkRPVar("numPoints"), 1 do
		local zPoint = localplayer.DarkRPVars["zPoints".. x]
		if zPoint then
			zPoint = zPoint:ToScreen()
			draw.DrawText("Zombie Spawn (" .. x .. ")", "DarkRPHUD2", zPoint.x, zPoint.y - 20, Color(255, 255, 255, 200), 1)
			draw.DrawText("Zombie Spawn (" .. x .. ")", "DarkRPHUD2", zPoint.x + 1, zPoint.y - 21, Color(255, 0, 0, 255), 1)
		end
	end
end


/*---------------------------------------------------------------------------
Actual HUDPaint hook
---------------------------------------------------------------------------*/
function GAMEMODE:HUDPaint()
	DrawHUD()
	--DrawZombieInfo()
	DrawEntityDisplay()
	self.BaseClass:HUDPaint()
	--DrawWantedIcon()
end



