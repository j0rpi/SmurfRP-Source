
-- RANKS --
local grad = Material("gui/gradient.png")
local grad_down = Material("gui/gradient_down.png")
local grad_up = Material("gui/gradient_up.png")
local mut = Material("icon32/muted.png")
local unmut = Material("icon32/unmuted.png")
local backbeh = Material("boowman/bg5.png","noclamp")
local serversettings = Material("icon64/tool.png")
local playersettings = Material("icon64/playermodel.png")
-- RANKS -- 

-- RULES -- 
// If in the rule tab you see only the rule number like 13) that mean the rule is to 
// long and try to keep it at 97 character.
local rules = {
}

surface.CreateFont( "Commands", {
	font = "Tahoma",
	size = 17,
	weight = 300,
} )

surface.CreateFont( "Options", {
	font = "Tahoma",
	size = 16,
	weight = 0,
	antialias = true
} )

surface.CreateFont( "SBTitle", {
	font = "Tahoma",
	size = 25,
	weight = 300,
	antialias = true
} )

surface.CreateFont( "News", {
	font = "Tahoma",
	size = 20,
	weight = 300,
	antialias = true,
	outline = true
} )

surface.CreateFont( "Text", {
	font = "Tahoma",
	size = 15,
	weight = 300,
} )

surface.CreateFont( "Info", {
	font = "Tahoma",
	size = 17,
	weight = 300,
} )

surface.CreateFont( "Infosmall", {
	font = "Tahoma",
	size = 17,
	weight = 300,
} )

surface.CreateFont( "Show", {
	font = "Tahoma",
	size = 13,
	weight = 300,
} )

local Menu = {}

local function formatNumber(n)
	n = tonumber(n)
	if (!n) then
		return 0
	end
	if n >= 1e14 then return tostring(n) end
    n = tostring(n)
    sep = sep or ","
    local dp = string.find(n, "%.") or #n+1
	for i=dp-4, 1, -3 do
		n = n:sub(1, i) .. sep .. n:sub(i+1)
    end
    return n
end

local function GetTextHeight(font, str)
	surface.SetFont(font)
	local w, h = surface.GetTextSize(str)
	return h
end


function plcommandbtn(parent,x,y,text,command,...)

local over = Color(51,51,51,255)		
local btn = vgui.Create("DButton",parent)
	btn:SetPos(x,y)
	btn:SetSize(130,35)
	btn:SetFont("Commands")
	btn:SetTextColor(Color(255,255,255))
	btn:SetText(text)
	btn.Paint = function()
			draw.RoundedBox(0,0,0,btn:GetWide(),btn:GetTall(),over)
			surface.SetDrawColor(0,0,0,255)
			surface.DrawOutlinedRect(0,0,btn:GetWide(),btn:GetTall())
	end
	local cmdArgs = {...}
	btn.DoClick = function()
		surface.PlaySound("buttons/button9.wav")
		RunConsoleCommand(command,unpack(cmdArgs))
	end
	btn.OnCursorEntered = function()
		over = Color(80,80,80,255)
	end
	btn.OnCursorExited = function()
		over = Color(51,51,51,255)
	end	
	return btn
end

function sboxcommandslid(parent,x,y,text,sboxcom)

	local svbg = vgui.Create("DPanel",parent)
		svbg:SetPos(x,y)
		svbg:SetSize(parent:GetWide()/2.3,25)
		
	local com = vgui.Create( "DNumSlider",svbg)
		com:DockMargin(20,0,2,0)
		com:SetText(text)	
		com:Dock(FILL)
		com:SetConVar(sboxcom)
		com:SetMin(0)
		com:SetMax(256)
		com:SetDecimals(0)
		com:GetValue()
		com.Label:SizeToContents( )
		com.Label:SetTextColor(Color(0,0,0,255))	
end

function svcomcheck(parent,y,text,com)

	local check = vgui.Create("DCheckBoxLabel", parent)
		check:SetPos(5,y)
		check:SetText(text)
		check:SetConVar(com)
		check:GetValue()
		check:SizeToContents()	
			
end

hook.Add('ScoreboardShow','DarkRPSCoreboard', function()

gui.EnableScreenClicker(true)
		
	if IsValid(LocalPlayer()) then
	
local bgcolor = Color(19,26,26,255)
	bg = vgui.Create("DFrame")
		bg:SetPos(ScrW()/2-500,ScrH()/2-350)
		bg:SetSize(1000,600)
		bg:SetTitle("")
		bg:ShowCloseButton(false)
		bg:SetDraggable(false)
		bg:MakePopup()	
		bg.Paint = function()
			draw.RoundedBox(8,0,0,bg:GetWide(),bg:GetTall(),Color(25,25,25,255))
		end
	
	config = vgui.Create("DFrame")
		config:SetPos(ScrW()/2-500,ScrH()/2 - 400)
		config:SetSize(1000,50)
		config:SetTitle("")
		config:ShowCloseButton(false)
		config:SetDraggable(false)
		config:SetVisible(false)
		config:MakePopup()
		config.Paint = function()
			draw.RoundedBox(0,0,0,config:GetWide(),config:GetTall(),Color(0,0,0,200))			
			
			surface.SetMaterial(backbeh)
			surface.SetDrawColor(255,255,255,200)
			surface.DrawTexturedRectUV( 0, 0, config:GetWide(), config:GetTall(), 0, 0, config:GetWide()/32, config:GetTall()/32 )

			draw.RoundedBox(0,0,0,config:GetWide(),config:GetTall(),Color(0,0,0,200))			
			
			surface.SetDrawColor(0,0,0)
			surface.DrawOutlinedRect(0,0,config:GetWide(),config:GetTall())
		
		end
local colop = Color(255,255,255)
	local options = vgui.Create("DButton",bg)
		options:SetPos(2,2)
		options:SetSize(bg:GetWide()-4,25)
		options:SetFont("Options")
		options:SetTextColor(Color(255,255,255))
		options:SetText('')
		options.Paint = function()
			draw.RoundedBox(0,0,0,options:GetWide(),options:GetTall(),Color(25,25,25,255))
            draw.RoundedBox(0,0,0,options:GetWide(),options:GetTall() / 2,Color(40,40,40,255))
			--draw.RoundedBox(0,0,0,options:GetWide(),options:GetTall(),Color(0,0,0,1))
		if config:IsVisible() then
			draw.DrawText("Shrink Options","Options",options:GetWide()/2,0,Color(0,0,0,255),TEXT_ALIGN_CENTER)
		else
			draw.DrawText(GetHostName(),"j0rpiAA3",options:GetWide()/2, 2,colop,TEXT_ALIGN_CENTER)
		end
		end 
		
		
//***********\\
--Players Tab--
//***********\\	

local plydarkblue = Color(37,104,137,255)	
	local btnplayers = vgui.Create("DButton",config)
		btnplayers:SetPos(ScrW()/2 - 700,5)
		btnplayers:SetSize(config:GetWide()/4-10,config:GetTall()-10)
		btnplayers:SetFont("Commands")
		btnplayers:SetTextColor(Color(255,255,255))
		btnplayers:SetText("Players")
		btnplayers.Paint = function()
			if plylist:IsVisible() then
				draw.RoundedBox(0,0,0,btnplayers:GetWide(),btnplayers:GetTall(),Color(37,104,137,255))
			else	
				draw.RoundedBox(0,0,0,btnplayers:GetWide(),btnplayers:GetTall(),plydarkblue)
			end
		end
		btnplayers.DoClick = function()
			--surface.PlaySound("buttons/button9.wav")
			print(LocalPlayer():GetName().." clicked on the players button.")
			if IsValid(plylist) or IsValid(shows) then
				plylist:SetVisible(true)
				shows:SetVisible(true)
			end
			if IsValid(webbg) then
				webbg:SetVisible(false)
			end
			if IsValid(helpbg) then
				helpbg:SetVisible(false)
			end	
			if IsValid(rulbg)then
				rulbg:SetVisible(false)
			end
			if IsValid(playersbg) then
				playersbg:SetVisible(false)
			end	
			if IsValid(serverbg) then
				serverbg:SetVisible(false)
			end	
			if IsValid(buttonsbg) then
				buttonsbg:SetVisible(false)
			end
			bgcolor = Color(19,26,26,200)
		end
		btnplayers.OnCursorEntered = function()
			--surface.PlaySound("garrysmod/ui_return.wav")
			plydarkblue = Color(37,104,137,255)	
		end		
		btnplayers.OnCursorExited = function()
			plydarkblue = Color(0,0,0,255)
		end
		
	shows = vgui.Create("DPanel",bg)
		shows:SetPos(2,29)
		shows:SetSize(bg:GetWide()-4,15)
		shows.Paint = function()
			--draw.RoundedBox(0,0,0,shows:GetWide(),shows:GetTall(),Color(25,25,25,255))
			--draw.RoundedBox(0,0,0,shows:GetWide(),shows:GetTall()/2,Color(40,40,40,255))
			--draw.DrawText("NAME","Show",50,1,Color(255,255,255),TEXT_ALIGN_LEFT)
			--draw.DrawText("JOB","Show",shows:GetWide()/2+50,1,Color(255,255,255),TEXT_ALIGN_CENTER)
			draw.RoundedBox(0,0,0,shows:GetWide(),shows:GetTall(),Color(25,25,25,255))
			draw.RoundedBox(0,0,0,shows:GetWide(),shows:GetTall()/2,Color(25,25,25,255))
			draw.DrawText("NAME","j0rpiAA2",50,1,Color(255,255,255),TEXT_ALIGN_LEFT)
			draw.DrawText("JOB","j0rpiAA2",shows:GetWide()/2+50,1,Color(255,255,255),TEXT_ALIGN_CENTER)
			if plylist.VBar:IsVisible() then	
				draw.DrawText("K/D","j0rpiAA2",shows:GetWide()-115,1,Color(255,255,255),TEXT_ALIGN_CENTER)
				draw.DrawText("PING","j0rpiAA2",shows:GetWide()-50,1,Color(255,255,255),TEXT_ALIGN_RIGHT)
                draw.DrawText("USER GROUP","j0rpiAA2",shows:GetWide()-250,1,Color(255,255,255),TEXT_ALIGN_RIGHT)					
			else	
				draw.DrawText("K/D","j0rpiAA2",shows:GetWide()-100,1,Color(255,255,255),TEXT_ALIGN_CENTER)
				draw.DrawText("PING","j0rpiAA2",shows:GetWide()-32,1,Color(255,255,255),TEXT_ALIGN_RIGHT)
                draw.DrawText("USER GROUP","j0rpiAA2",shows:GetWide()-240,1,Color(255,255,255),TEXT_ALIGN_RIGHT)					
			end
		end	
		
	plylist = vgui.Create("DScrollPanel",bg)
		plylist:SetPos(2,47)
		plylist:SetSize(bg:GetWide()-4,bg:GetTall()-50)
		plylist:SetPadding(5)
		plylist.Paint = function()
			draw.RoundedBox(0,0,0,plylist:GetWide(),plylist:GetTall(),Color(60,60,60,200))
		end
	
local plys = player.GetAll()
table.sort(plys, function(a, b) return a:Team() > b:Team() end)
	
for k,pl in pairs(plys) do
local mo = formatNumber(pl.DarkRPVars.money) or 0	
local over = Color(0,0,0,0)	
local slujba = pl:getDarkRPVar("job") or "Unemployed"

	local row = vgui.Create("DButton",plylist)
		row:SetPos(0,k*40-40)
		row:SetSize(plylist:GetWide(),40)
		row:SetText('')
		row.Paint = function()
			draw.RoundedBox(0,0,0,row:GetWide(),row:GetTall(),team.GetColor(pl:Team()))	
		local rank = "User"
		if pl:IsUserGroup("owner") then rank = "Owner"end
		if pl:IsUserGroup("superadmin") then rank = "SAdmin"end
		if pl:IsUserGroup("admin") then rank = "Admin"end
		if pl:IsUserGroup("moderator") then rank = "Moderator"end
		if pl:IsUserGroup("user") then rank = "User"end
		if pl:IsUserGroup("donator") then rank = "Donator"end
		if pl:IsUserGroup("respected") then rank = "R.Donator"end
		if pl:IsUserGroup("contributor") then rank = "Contributor"end
 
			draw.DrawText(pl:Nick(),"j0rpiAA3",50,8,Color(255,255,255),TEXT_ALIGN_LEFT)

			--draw.DrawText(rank,"Info",50,20,Color(255,255,255),TEXT_ALIGN_LEFT)
			draw.DrawText(slujba,"j0rpiAA3",row:GetWide()/2+50,8,Color(255,255,255),TEXT_ALIGN_CENTER)
			if LocalPlayer():GetNWString("usergroup") == "superadmin" or LocalPlayer():GetNWString("usergroup") == "admin" or LocalPlayer():GetNWString("usergroup") == "owner"	then
				draw.DrawText("$"..mo,"j0rpiAA2",row:GetWide()/2+50,23,Color(255,255,255),TEXT_ALIGN_CENTER)
			end			
			if plylist.VBar:IsVisible() then
				draw.DrawText(pl:Frags().."/"..pl:Deaths(),"j0rpiAA3",row:GetWide()-115,8,Color(255,255,255),TEXT_ALIGN_CENTER)
				draw.DrawText(pl:Ping(),"j0rpiAA3",row:GetWide()-55,8,Color(255,255,255),TEXT_ALIGN_RIGHT)
				if LocalPlayer():GetNWString("usergroup") == "superadmin" or LocalPlayer():GetNWString("usergroup") == "admin" or LocalPlayer():GetNWString("usergroup") == "owner" then		
			    draw.DrawText(rank, "j0rpiAA3", row:GetWide() - 285, 8, Color(255,255,255), TEXT_ALIGN_CENTER)
				else
				end
			else
				draw.DrawText(pl:Frags().."/"..pl:Deaths(),"j0rpiAA3",row:GetWide()-100,8,Color(255,255,255),TEXT_ALIGN_CENTER)
				draw.DrawText(pl:Ping(),"j0rpiAA3",row:GetWide()-40,8,Color(255,255,255),TEXT_ALIGN_RIGHT)
				if LocalPlayer():GetNWString("usergroup") == "superadmin" or LocalPlayer():GetNWString("usergroup") == "admin" or LocalPlayer():GetNWString("usergroup") == "owner" then		
			    draw.DrawText(rank, "j0rpiAA3", row:GetWide() - 285, 8, Color(255,255,255), TEXT_ALIGN_CENTER)
				else
				end
			end	
		end
		row.DoClick = function()
		--surface.PlaySound("buttons/button9.wav")
			local options = DermaMenu()
			options.Paint = function ()
			surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawRect( 0, 0, options:GetWide(), options:GetTall() )
	surface.SetDrawColor( 0, 100, 255, 255 )
	surface.DrawOutlinedRect( 0, 0, options:GetWide(), options:GetTall() )
	
	end
			options:AddOption(pl:Nick() .. " [" .. pl:SteamID() .. "]", function() end):SetImage("icon16/user.png")
			options:AddSpacer()
			options:AddOption("Copy SteamID", function() SetClipboardText(pl:SteamID()) surface.PlaySound("buttons/button9.wav") end):SetImage("icon16/tag_blue.png")
			options:AddOption("Copy Name", function() SetClipboardText(pl:Nick()) surface.PlaySound("buttons/button9.wav") end):SetImage("icon16/user_edit.png")
			options:AddSpacer()
			options:AddOption("Open Profile", function() pl:ShowProfile() surface.PlaySound("buttons/button9.wav") end):SetImage("icon16/world.png")
			options:AddSpacer()
			options:Open()
		if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() or LocalPlayer():GetUserGroup() == "moderator" then
			if IsValid(pl) then
					options:AddOption("Kick", function() RunConsoleCommand("ulx","kick",pl:Nick(),"You were kicked by "..LocalPlayer():Nick()) surface.PlaySound("buttons/button9.wav") end):SetImage("icon16/door_out.png")
					options:AddOption("Advanced Ban", function() RunConsoleCommand("xgui","fban",pl:Nick(),"You were banned by "..LocalPlayer():Nick()) surface.PlaySound("buttons/button9.wav") bg:Close() end):SetImage("icon16/delete.png")
					options:AddSpacer()
					options:AddOption("Go To Player", function() RunConsoleCommand("ulx","goto",pl:Nick()) surface.PlaySound("buttons/button9.wav") bg:Close() end):SetImage("icon16/arrow_right.png")
					options:AddOption("Bring Player", function() RunConsoleCommand("ulx","bring",pl:Nick()) surface.PlaySound("buttons/button9.wav") bg:Close() end):SetImage("icon16/arrow_left.png")
					options:AddOption("Freeze Player", function() RunConsoleCommand("ulx","freeze",pl:Nick()) surface.PlaySound("buttons/button9.wav") bg:Close() end):SetImage("icon16/time_delete.png")
					options:AddOption("Un-Freeze Player", function() RunConsoleCommand("ulx","unfreeze",pl:Nick()) surface.PlaySound("buttons/button9.wav") bg:Close() end):SetImage("icon16/time.png")
					options:AddSpacer()
					options:AddOption("Spectate", function() RunConsoleCommand("ulx","spectate",pl:Nick()) surface.PlaySound("buttons/button9.wav") end):SetImage("icon16/zoom.png")
					options:AddSpacer()
					options:AddOption("Cloak Myself", function() RunConsoleCommand("ulx","cloak") surface.PlaySound("buttons/button9.wav") end):SetImage("icon16/user_gray.png")
					options:AddOption("Un-Cloak Myself", function() RunConsoleCommand("ulx","uncloak") surface.PlaySound("buttons/button9.wav") end):SetImage("icon16/user_suit.png")
					options:AddOption("Spectate (ULX Style)", function() RunConsoleCommand("ulx","spectate",pl:Nick()) surface.PlaySound("buttons/button9.wav") end):SetImage("icon16/zoom.png")
					options:AddOption("Spectate (FAdmin Style)", function() RunConsoleCommand("fadmin","spectate",pl:Nick()) surface.PlaySound("buttons/button9.wav") end):SetImage("icon16/zoom.png")
					local setTeam, subimg = options:AddSubMenu("Set Team")
					    subimg:SetImage("icon16/group.png")    
					    setTeam:AddOption("Gangster", function() RunConsoleCommand("FAdmin", "setteam", pl:Nick(), "Gangster") end)
						setTeam:AddOption("Civil Protection", function() RunConsoleCommand("FAdmin", "setteam", pl:Nick(), "Civil Protection") end)
						setTeam:AddOption("Mob Boss", function() RunConsoleCommand("FAdmin", "setteam", pl:Nick(), "Mob Boss") end)
						setTeam:AddOption("Gun Dealer", function() RunConsoleCommand("FAdmin", "setteam", pl:Nick(), "Gun Dealer") end)
						setTeam:AddOption("Medic", function() RunConsoleCommand("FAdmin", "setteam", pl:Nick(), "Medic") end)
						setTeam:AddOption("Mayor", function() RunConsoleCommand("FAdmin", "setteam", pl:Nick(), "Mayor") end)
						setTeam:AddOption("Hobo", function() RunConsoleCommand("FAdmin", "setteam", pl:Nick(), "Hobo") end)
				        
					local setusrgroup, subimg2 = options:AddSubMenu("Set Usergroup")
					    subimg2:SetImage("icon16/user_go.png")
				        setusrgroup:AddOption("Standard User", function() RunConsoleCommand("ulx", "removeuser", pl:Nick()) end)
						setusrgroup:AddOption("Donator", function() RunConsoleCommand("ulx", "adduser", pl:Nick(), "donator") end)
						setusrgroup:AddOption("Respected Donator", function() RunConsoleCommand("ulx", "adduser", pl:Nick(), "respected") end)
						setusrgroup:AddOption("Super Admin", function() RunConsoleCommand("ulx", "adduser", pl:Nick(), "superadmin") end)
			            
					options:AddSpacer()
				options:Open()
				end
			end
		end
		
		
		row.OnCursorEntered = function()
			--surface.PlaySound("garrysmod/ui_return.wav")
			--over = Color(37,104,134,255)
			draw.RoundedBox(0,0,0,row:GetWide(),row:GetTall(),Color(100, 100, 100, 255))
		end	
	
		row.OnCursorExited = function()
			over = Color(0,0,0,0)
		end	
		
	local plicon = vgui.Create("AvatarImage",row)
		plicon:SetPos(7,4)
		plicon:SetSize(32,32)
		plicon:SetPlayer( pl, 32 )
		plicon:SetToolTip('')
	
	local mute = vgui.Create("DImageButton",row)
		mute:SetPos(row:GetWide()-50,4)
		mute:SetSize(50,32)
		mute:SetToolTip("Mute "..pl:GetName()..".")	
		mute:SetColor(255,255,255,255)
		mute.DoClick = function()
			--surface.PlaySound( "buttons/button17.wav" )	
			pl:SetMuted(pl:IsMuted())
		end
		mute.Paint = function()
			draw.RoundedBox(0,0,0,mute:GetWide(),mute:GetTall(),Color(0,0,0,0))
		local x,y = 0,0
		if plylist.VBar:IsVisible() then
			x = 0
		else
			x = 18
		end
			if ( pl:IsMuted() ) then
				surface.SetMaterial(mut)
				surface.SetDrawColor(225,255,255,255)
				surface.DrawTexturedRect(x,y,32,32)
			else
				surface.SetMaterial(unmut)
				surface.SetDrawColor(225,255,255,255)
				surface.DrawTexturedRect(x,y,32,32)
			end
		end
		
function row:Think() 
	if not IsValid(pl) then 
		self:Remove()
		plicon:Remove()
		mute:Remove() 		
	end	
end
	
end				
end 
end) 

--hook.Add( 'ScoreboardHide', 'HideMe', function()
hook.Add( 'ScoreboardHide', 'DarkRP_Override_H', function()
		gui.EnableScreenClicker(false)
		if bg and IsValid(bg) then
			bg:Remove()
		end
		if IsValid(plylist) then
			plylist:Remove()
		end
		if IsValid(shows) then
			shows:Remove()
		end
		if IsValid(webbg) then	
			webbg:Remove()
		end
		if IsValid(rulbg) then
			rulbg:Remove()
		end
		if IsValid(config) then
			config:Close()	
		end		
end)

timer.Simple(0.1, function()
	
	function GAMEMODE.ScoreboardShow()
	end

	function GAMEMODE.ScoreboardHide()
	end
end)
