
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )


util.AddNetworkString( "rprint_selectmode" )

net.Receive( "rprint_selectmode", function( len, ply )
	if !IsValid( ply ) then return end

	local ent = net.ReadEntity()
	local select = net.ReadUInt( 8 )

	if !IsValid( ent ) or ent.Base != "rprint_base" then return end
	
	ent:SetPlayerSelection( ply, select )
end )


AccessorFunc( ENT, "health", "HP", FORCE_NUMBER )

function ENT:Initialize()
	self:SetModel( "models/props_c17/consolebox01a.mdl" )
	
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	
	self:SetColor( self.Params.Color )
	self:SetUseType( SIMPLE_USE )
	
	local owner = self:Getowning_ent()

	if IsValid( owner ) then
		self.OwnerSteamID = owner:SteamID()
	end

	self:SetHP( self.Params.PrinterHealth )
	self:SetTemp( self.Params.TempStart )
	self:SetMoney( 0 )
	self:SetPower( 100 )
	self:SetHasCooler( false )

	local phys = self:GetPhysicsObject()

	if IsValid( phys ) then 
		phys:Wake()
	end
end

function ENT:Think()
	self:NextThink( CurTime() + 1 )

	if self:GetHasCooler() and self.Params.CoolerBreakEnabled then
		self.nextCoolerBreak = self.nextCoolerBreak or CurTime() + math.random( 
			(self.Params.CoolerBreakInterval or {})[1] or 0,
			(self.Params.CoolerBreakInterval or {})[2] or 0
		)

		if CurTime() >= self.nextCoolerBreak then
			self:SetHasCooler( false )

			self:EmitSound( "buttons/combine_button2.wav", self.Params.SoundEffectVolume, 100 )

			self.nextCoolerBreak = nil
		end
	end

	local temp = self:GetTemp()

	if self:GetPower() > 0 then
		local printrate = self.Params.PrintRate
		local hascooler = self:GetHasCooler()

		self:SetMoney(
			self:GetMoney() + printrate
		)

		self:SetPower(
			self:GetPower()
				- (self.Params.PowerConsumptionRate * printrate)
				- (hascooler and self.Params.PowerConsumptionRateCooler or 0)
		)

		temp = temp
			+ (self.Params.HeatRate * printrate)
			- (hascooler and self.Params.CoolerCoolRate or 0)
	end

	self:SetTemp( math.max(
		temp - self.Params.CoolRate,
		self.Params.TempMin
	) )

	if self:GetTemp() >= self.Params.TempMax then
		local owner = self:Getowning_ent()

		if IsValid( owner ) and self.Params.AlertOwnerOnOverheated then
			owner:ChatPrint( "Your printer has overheated." )
		end

		if self.Params.ExplodeOnOverheat then
			self:Explode()
		else
			self:SetPower( 0 )
			self:SetTemp( self.Params.TempMax - 1 )
		end
	end

	return true
end

function ENT:OnTakeDamage( dmg )
	if !self.Params.CanBeDestroyed then return end

	self:SetHP( self:GetHP() - dmg:GetDamage() )

	if self:GetHP() <= 0 then
		local attacker = dmg:GetAttacker()

		if IsValid( attacker ) and attacker:IsPlayer() then
			if table.HasValue( self.Params.DestroyPayoutTeams, attacker:Team() ) then
				rPrint.AddMoney( attacker, self.Params.DestroyPayout )
			end
		end

		local owner = self:Getowning_ent()

		if IsValid( owner ) and self.Params.AlertOwnerOnDestroyed then
			owner:ChatPrint( "Your printer has been destroyed." )
		end

		self:Explode()
	end
end

function ENT:Explode()
	local pos, effect = self:GetPos(), EffectData()
		effect:SetStart( pos )
		effect:SetOrigin( pos )
		effect:SetScale( 1 )

	util.Effect( "Explosion", effect )

	self:Remove()
end

function ENT:RechargeSelected( ply )
	if self:GetPower() > self.Params.RechargeMax then return end

	local rccost = self.Params.RechargeCost

	if !rPrint.CanAfford( ply, rccost ) then
		self:EmitSound( "buttons/button2.wav", self.Params.SoundEffectVolume, 100 )
		return
	end
	
	rPrint.AddMoney( ply, -rccost )

	self:SetPower( 100 )

	self:EmitSound( "buttons/button1.wav", self.Params.SoundEffectVolume, 100 )
end

function ENT:WithdrawSelected( ply )
	if self:GetMoney() <= 0 then return end

	rPrint.AddMoney( ply, self:GetMoney() )

	self:SetMoney( 0 )

	self:EmitSound( "ambient/tones/equip3.wav", self.Params.SoundEffectVolume, 50 )
end

function ENT:CoolerSelected( ply )
	if self:GetHasCooler() then return end

	local coolercost = self.Params.CoolerCost

	if !rPrint.CanAfford( ply, coolercost ) then 
		self:EmitSound( "buttons/button2.wav", self.Params.SoundEffectVolume, 100 )
		return
	end
	
	rPrint.AddMoney( ply, -coolercost )

	self:SetHasCooler( true )

	self.nextCoolerBreak = nil

	self:EmitSound( "buttons/lever1.wav", self.Params.SoundEffectVolume, 100 )
end

function ENT:Use( ply )
	if !self.selections or !self.selections[ply] then return end
	if self.lastuse and CurTime() - self.lastuse < 0.75 then return	end
	if ply:GetShootPos():Distance( self:GetPos() ) > self.Params.UseDistance then return end

	self.lastuse = CurTime()

	local select = self.selections[ply]

	if select == rPrint.SelectionModes.RECHARGE then
		self:RechargeSelected( ply )
	elseif select == rPrint.SelectionModes.WITHDRAW then
		self:WithdrawSelected( ply )
	elseif select == rPrint.SelectionModes.PURCHASE_COOLER then
		self:CoolerSelected( ply )
	elseif select == rPrint.SelectionModes.TRANSFER_OWNERSHIP and self:Getowning_ent() != ply then
		self:Setowning_ent( ply )
		self.OwnerSteamID = ply:SteamID()
		
		self:EmitSound( "buttons/combine_button1.wav", self.Params.SoundEffectVolume, 100 )
	end

	rPrint.TriggerEvent( "PRINTER_Use", self, ply, select )
end

function ENT:SetPlayerSelection( ply, select )
	self.selections = self.selections or {}

	self.selections[ply] = select
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end
