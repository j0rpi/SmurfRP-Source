AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props/cs_office/Vending_machine.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	self.sparking = false

end

ENT.Once = false
function ENT:Use(activator,caller)
umsg.Start("ammodframe", caller)
umsg.End()
end



function ENT:Think()

end

function ENT:OnRemove()
	timer.Destroy(self:EntIndex())
	local ply = self:Getowning_ent()
	if not IsValid(ply) then return end
end


 function BuyAmmo(ply,command,args)

 if args[1] == "" then
  DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", "argument", ""))
  return ""
 end

 if ply:isArrested() then
  DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("unable", "/buyammo", ""))
  return ""
 end

 if GAMEMODE.Config.noguns then
  DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("disabled", "ammo", ""))
  return ""
 end

 local found
 for k,v in pairs(GAMEMODE.AmmoTypes) do
  if v.ammoType == args[1] then
   found = v
   break
  end
 end

 if not found or (found.customCheck and not found.customCheck(ply)) then
  DarkRP.notify(ply, 1, 4, found and found.CustomCheckFailMsg or DarkRP.getPhrase("unavailable", "ammo"))
  return ""
 end

 if not ply:canAfford(found.price) then
  DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("cant_afford", "ammo"))
  return ""
 end

 --DarkRP.notify(ply, 0, 4, DarkRP.getPhrase("you_bought_x", found.name, GAMEMODE.Config.currency..tostring(found.price)))
 ply:addMoney(-found.price)

 local trace = {}
 trace.start = ply:EyePos()
 trace.endpos = trace.start + ply:GetAimVector() * 85
 trace.filter = ply

 local tr = util.TraceLine(trace)

 local ammo = ents.Create("spawned_weapon")
 ammo:SetModel(found.model)
 ammo.ShareGravgun = true
 ammo:SetPos(tr.HitPos)
 ammo.nodupe = true
 function ammo:PlayerUse(user, ...)
  user:GiveAmmo(found.amountGiven, found.ammoType)
  self:Remove()
  return true
 end
 ammo:Spawn()

 return ""
end

concommand.Add("buyammo", BuyAmmo)