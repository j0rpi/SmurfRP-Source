include("shared.lua")
AddCSLuaFile("init.lua")
function ENT:Initialize()
end

local formIcon = Material("icon16/plugin.png")




function ENT:Draw()
	self:DrawModel()
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	drink = self:Getprice()
	self:Setprice(10)
	owner = self:Getowning_ent()
	owner = (IsValid(owner) and owner:Nick()) or "Unknown"
	
	surface.SetFont("HUDNumber5")
	local TextWidth = surface.GetTextSize("Ammo Dispenser")
	local TextWidth2 = surface.GetTextSize("Price: $50")

	Ang:RotateAroundAxis(Ang:Forward(), 90)
	local TextAng = Ang

	TextAng:RotateAroundAxis(TextAng:Right(), CurTime() * -180)

	cam.Start3D2D(Pos + Ang:Right() * -30, TextAng, 0.2)
		draw.WordBox(2, -TextWidth*0.5, -360, "Ammo Dispenser", "HUDNumber5", Color(0, 0, 0, 150), Color(255,255,255,255))
	cam.End3D2D()
	
	
	
	
	
	
end














function ammodframe()
        local frame1 = vgui.Create("DFrame")
        frame1:SetPos(ScrW() / 2 - 200, ScrH() / 2 - 100)
        frame1:SetSize(350,250)
        frame1:SetTitle("")
        frame1:MakePopup()
                frame1:SetDraggable(true)
                frame1.btnClose:SetVisible(true)
        frame1.btnMaxim:SetVisible(false)
        frame1.btnMinim:SetVisible(false)
                frame1.Paint = function()
        surface.SetDrawColor( 40, 40, 40, 200 )
        surface.DrawRect( 0, 0, frame1:GetWide(), frame1:GetTall() )
        surface.SetDrawColor( 0, 0, 0, 255 )
        surface.DrawOutlinedRect( 0, 0, frame1:GetWide(), frame1:GetTall() )
       
        -- TITLE BAR
      surface.SetDrawColor(15, 15, 15, 255)
      surface.DrawRect(0, 0, frame1:GetWide(), 20)
      surface.SetDrawColor(35, 35, 35, 255)
      surface.DrawRect(0, -12, frame1:GetWide(), 20)
          draw.SimpleText("        Ammo Dispenser - By Walter/j0rpi", "DermaDefault", 90, 9, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
      -- FORM ICON
      surface.SetMaterial(formIcon)
      surface.SetDrawColor(255, 255, 255, 255)
      surface.DrawTexturedRect(4, 3, 12, 12)
end
 
       
 
-- LIST
 
     local list = vgui.Create("DScrollPanel", frame1)
         list:SetPos(0,20)
         list:SetSize(frame1:GetWide(), frame1:GetTall() - 20)
         --list:EnableVerticalScrollbar( true )
         
    -- list:SetSpacing( 5 )
         
         
--  AMMO   
      
 local function AddAmmoIcon(Model, name,price, command, number)

	
	  
         local ammobg = vgui.Create("DPanel", list)
         ammobg:SetPos(0, 74 * number)
         ammobg:SetSize(list:GetWide() + 2, 75)
     ammobg.Paint = function()
        surface.SetDrawColor( 25, 25, 25, 225 )
        surface.DrawRect( 0, 0, ammobg:GetWide(), ammobg:GetTall() )
        surface.SetDrawColor( 0, 0, 0, 255 )
        surface.DrawOutlinedRect( 0, 0, ammobg:GetWide(), ammobg:GetTall() )
end
               
                local ammo = vgui.Create( "SpawnIcon" , ammobg )
        ammo:SetPos( 15, 3 )
        ammo:SetModel( Model )
                ammo:SetToolTip(name .. " ammo. Price: " .. price)
                ammo.DoClick = function()
                        LocalPlayer():ConCommand("buyammo " .. command)
                        frame1:SetVisible( false )
                end
               
               
                local ammolbl = vgui.Create("DLabel", ammobg)
                ammolbl:SetPos(100, 20)
                ammolbl:SetSize(ammobg:GetWide(), 25)
                ammolbl:SetFont("j0rpi")
                ammolbl:SetText(name)
                --ammolbl:SetColor(Color(0,0,0,255))
               
			   local ammolpbl = vgui.Create("DLabel", ammobg)
                ammolpbl:SetPos(ammobg:GetWide() - 60, 25)
                ammolpbl:SetSize(50, 25)
                ammolpbl:SetFont("j0rpi")
                ammolpbl:SetText("$" .. price)
                --ammolpbl:SetColor(Color(0,0,0,255))
               
                local ammodesc = vgui.Create("DLabel", ammobg)
                ammodesc:SetPos(100, 20)
                ammodesc:SetSize(ammobg:GetWide(), 65)
                ammodesc:SetFont("j0rpi2")
                ammodesc:SetText("Ammo suitable for " ..name.. "s")
                ammodesc:SetColor(Color(255,255,255,255))
 
end



local ammnum = 0
for k,v in pairs(GAMEMODE.AmmoTypes) do
	if not v.customCheck or v.customCheck(LocalPlayer()) then
		AddAmmoIcon(v.model, v.name, v.price, v.ammoType, ammnum)
			ammnum = ammnum + 1
	end
end


-- END  AMMO
 
end



 
usermessage.Hook("ammodframe", ammodframe)