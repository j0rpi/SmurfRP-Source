///////////////////////////////////////////////
///// Created by Temparh
///// 21th October 2013
///// init.lua

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")


include("shared.lua")

function ENT:Initialize()

	//self:SetModel("models/humans/group01/male_01.mdl")
	self:SetHullType( HULL_HUMAN ) 
	self:SetHullSizeNormal()
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid(SOLID_BBOX)
	self:CapabilitiesAdd( CAP_ANIMATEDFACE ) 
	self:SetUseType( SIMPLE_USE )
	self:DropToFloor()

	self:SetMaxYawSpeed(90)
	self:SetNWBool("Occupied", false)

end 

function ENT:AcceptInput(input, activator, caller)
	local owner = false
	local open = false
	local owneriscaller = false
	for k,v in pairs(player.GetAll()) do
		if v:Team() == TEAM_CINEMAMANAGER then
			owner = true
			open = v:GetNWBool("CinemaStatus")
			if v == caller then
				owneriscaller = true 
			end
		end
	end
	if owneriscaller then return end
	if !owner then 
		net.Start("TempMSG")
			net.WriteString("You cannot buy a ticket. There is no Cinema Manager")
			net.WriteInt(1,2)
		net.Send(caller)
		return 
	end
	if !open then
		net.Start("TempMSG")
			net.WriteString("You cannot buy a ticket. The Cinema is closed")
			net.WriteInt(1,2)
		net.Send(caller)
		return 
	end
	if input == "Use" and caller:IsPlayer() then
		local owner = false
		for k,v in pairs(player.GetAll()) do
			if v:Team() == TEAM_CINEMAMANAGER then
				owner = true
			end
		end
		if owner then
			if self:GetNWBool("Occupied") == false then
		 		net.Start("CinemaMenu")
		 			net.WriteEntity(self)
				net.Send(caller)
				self:SetNWBool("Occupied", true)
			else
				net.Start("TempMSG")
					net.WriteString("Get back in the line. Someone is already talking to the clerk")
					net.WriteInt(1,2)
				net.Send(caller)
			end
		else
			net.Start("TempMSG")
				net.WriteString("You cannot buy a ticket. There is no Cinema Manager")
				net.WriteInt(1,2)
			net.Send(caller)
		end
	end
end  