AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

/*---------------------------------------------------------
	Basics
---------------------------------------------------------*/
function ENT:Initialize()
	
	self.BetAmount = 50
	self.SlotsPlaying = nil
	self.SlotsSpinning = false
	self.LastSpin = CurTime()
	
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:DrawShadow( false )
	self:SetAngles( Angle( 0, 0, 0) )
	
	self:SetupChair()
	self:SetupLight()

	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
		phys:Sleep()
	end
	
end


function ENT:Think()

	// Player In Chair Check
	if !self.SlotsPlaying && self:IsInUse() then		// Game not in play, player in chair
		self:SendPlaying()
	elseif self.SlotsPlaying && !self:IsInUse() then	// Game in play, nobody in chair
		if IsValid(self.chair) then
			self.chair:Remove()
		end
		self.SlotsPlaying = nil
	end

	// Player Idling Check
	if ( self.LastSpin + (60*3) < CurTime() ) && self:IsInUse() then
		local ply = self:GetPlayer()
		ply:ExitVehicle()
		ply:SendLua("chat.AddText(Color(0,255,0,255), '[CASINO] ', Color(255,255,255,255), 'You were ejected due to idling!')")
		ply:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	end
	
	if ( self.Jackpot && self.Jackpot < CurTime() ) then
		self.Jackpot = nil
	end
	
	self:NextThink(CurTime()) // Don't change this, the animation requires it
	
	return true
end


/*---------------------------------------------------------
	Chair Related Functions
---------------------------------------------------------*/

function ENT:SetupChair()

	// Chair Model
	self.chairMdl = ents.Create("prop_physics_multiplayer")
	--self.chairMdl:SetModel("models/props/cs_militia/barstool01.mdl")
	self.chairMdl:SetModel(self.ChairModel)
	--self.chairMdl:SetParent(self)
	self.chairMdl:SetPos( self:GetPos() + Vector(35,0,2) )
	self.chairMdl:SetAngles( Angle(0, math.random(-180,180), 0) )
	self.chairMdl:DrawShadow( false )
	
	self.chairMdl:PhysicsInit(SOLID_VPHYSICS)
	self.chairMdl:SetMoveType(MOVETYPE_NONE)
	self.chairMdl:SetSolid(SOLID_VPHYSICS)
	
	self.chairMdl:Spawn()
	self.chairMdl:Activate()
	
	local phys = self.chairMdl:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
		phys:Sleep()
	end
	
	self.chairMdl:SetKeyValue( "minhealthdmg", "999999" )
	
end

function ENT:SetupVehicle()

	// Chair Vehicle
	self.chair = ents.Create("prop_vehicle_prisoner_pod")
	self.chair:SetModel("models/props_phx/carseat2.mdl")
	self.chair:SetKeyValue("vehiclescript","scripts/vehicles/prisoner_pod.txt")
	--self.chair:SetParent(self)
	self.chair:SetPos( self:GetPos() + Vector(45,0,40) )
	self.chair:SetAngles( Angle(0,90,0) )
	self.chair:SetNotSolid(true)
	self.chair:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self.chair:SetNoDraw(true)
	self.chair:DrawShadow(false)

	self.chair.bSlots = true

	self.chair:Spawn()
	self.chair:Activate()
	
	local phys = self.chair:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
		phys:Sleep()
	end
	
end

function ENT:SetupLight()

	self.light = ents.Create("slotmachine_light")

	self.light.Jackpot = false
	self.light:SetPos( self:GetPos() + Vector( -5, 0, 80 ) )

	self.light:Spawn()
	self.light:Activate()

end

function ENT:IsInUse()

	if IsValid(self.chair) && self.chair:GetDriver():IsPlayer() then
		return true
	else
		return false
	end
	
end

/*---------------------------------------------------------
	Initial Player Interaction
---------------------------------------------------------*/
function ENT:Use( ply )

	if !IsValid(ply) || !ply:IsPlayer() then
		return
	end
	
	if ( ply:GetBilliardTable() ) then
		ply:SendLua("chat.AddText(Color(0,255,0,255), '[CASINO] ', Color(255,255,255,255), 'Quit your billiards game before attempting to play Slots!')")
		return
	end
	
	if !self:IsInUse() then
		self:SetupVehicle()
	
		if !IsValid(self.chair) then return end -- just making sure...
	
		ply.SeatEnt = self.chair
		ply.EntryPoint = ply:GetPos()
		ply.EntryAngles = ply:EyeAngles()
		
		ply:EnterVehicle( self.chair )
		self:SendPlaying( ply )
	else
		return
	end
	
end

hook.Add( "PlayerLeaveVehicle", "ResetCollisionVehicle", function( ply )

	ply:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )

end )

hook.Add( "CanPlayerEnterVehicle", "PreventEntry", function( ply, vehicle )

	if ( ply:GetBilliardTable() ) then
		ply:SendLua("chat.AddText(Color(0,255,0,255), '[CASINO] ', Color(255,255,255,255), 'Quit your billiards game before attempting to play Slots!')")
		return false
	end
	
	return true

end )

/*---------------------------------------------------------
	Console Commands
---------------------------------------------------------*/
concommand.Add( "slotm_spin", function( ply, cmd, args )
	local bet = tonumber(args[1]) or 50
	local ent = ply.SlotMachine
	
	if bet < 50 then 
		ply:SendLua("chat.AddText(Color(0,255,0,255), '[CASINO] ', Color(255,255,255,255), 'Minimum bet of $50!')")
		bet = 50
	end

	if bet > 5000 then
		bet = 5000
	end
	
	if IsValid(ent) && !ent.SlotsSpinning && !ent.Jackpot then
		ent.LastSpin = CurTime()
		ent.BetAmount = bet
		ent:PullLever()
		ent:PickResults()
		ply:addMoney(-bet)
	end
end )

/*---------------------------------------------------------
	Slot Machine Functions
---------------------------------------------------------*/
function ENT:GetPlayer()

	local ply = player.GetByID( self.SlotsPlaying )

	if IsValid(ply) && ply:IsPlayer() && self:IsInUse() then
		return ply
	end


end

function ENT:SendPlaying()
	
	if ( !IsValid( self ) || !IsValid(self.chair) ) then return end

	self.SlotsPlaying = self.chair:GetDriver():EntIndex()
	self.LastSpin = CurTime()
	
	local ply = self:GetPlayer()
	ply.SlotMachine = self
	
	local rf = RecipientFilter()
	rf:AddPlayer( ply )
	
	umsg.Start("slotsPlaying", rf)
		umsg.Short( self:EntIndex() )
	umsg.End()
	
end


function ENT:PullLever()
	
	local seq = self:LookupSequence("pull_handle")
    
	if seq == -1 then return end
    
	self:ResetSequence(seq)
	
end


function ENT:PickResults()

	self.SlotsSpinning = true
	
	local rf = RecipientFilter()
	rf:AddPlayer( self:GetPlayer() )
	rf:AddAllPlayers()
	
	local random = { getRand(), getRand(), getRand() }
	
	if (table.concat(random) == "222") then random = { 2, getRand(), 2} end
	
	umsg.Start("slotsResult", rf)
		umsg.Short( self:EntIndex() )
		umsg.Short( random[1] )
		umsg.Short( random[2] )
		umsg.Short( random[3] )
	umsg.End()
	
	self:EmitSound( Casino.SlotPullSound, 30, 100 )
	
	timer.Simple( Casino.SlotSpinTime[3], function()
		self:CalcWinnings( random )
	end )
	
	// Prevent spin button spam
	timer.Simple( Casino.SlotSpinTime[3] + 1, function()
		self.SlotsSpinning = false
	end )
end

// Ranked highest to lowest
ENT.ExactCombos = {
	//["6"] = { 2, 2, 2 }, //Jackpot?
	["17.5"] = { 1, 1, 1 },
	["15"] = { 3, 3, 3 },
	["12.5"] = { 4, 4, 4 },
	["10"] = { 5, 5, 5 },
	["7.5"] = { 6, 6, 6 },
}

ENT.AnyTwoCombos = {
	["5"] = 2,
}

function ENT:CalcWinnings( random )

	if !self:IsInUse() then
		return
	end
	
	local ply = self:GetPlayer()
	local winnings = 0
	
	// Jackpot
	if table.concat(random) == "222" then
		local winnings = math.Round( self:GetJackpot() + self.BetAmount )
		self:SendWinnings( ply, winnings, true )
		
		self:SetJackpot(50000)
		
		return
	end
	
	// Exact Combos
	for x, combo in pairs( self.ExactCombos ) do
		if table.concat(random) == table.concat(combo) then
			local winnings = math.Round( self.BetAmount * tonumber(x) )
			self:SendWinnings( ply, winnings )
			return
		end
	end

	// Any Two Combos
	for x, combo in pairs( self.AnyTwoCombos ) do
		if random[3] == combo then
			local winnings = math.Round( self.BetAmount * tonumber(x) )
			self:SendWinnings( ply, winnings )
			return
		end
	end
	
	// Player lost
	self:SetJackpot( self:GetJackpot() + self.BetAmount )
	
end

function ENT:SendWinnings( ply, amount, bJackpot )

	if bJackpot then
		for k, v in pairs(player.GetAll()) do
			v:SendLua("chat.AddText(Color(0,255,0,255), '[CASINO] ', Color(255,255,255,255), '"..ply:Nick().." has won the JackPot on the Slot Machines! They win a total of $"..amount.."!')")
		end
		self:EmitSound( Casino.SlotJackpotSound, 100, 100 )
		self.Jackpot = CurTime() + 25
	else
		self:EmitSound( Casino.SlotWinSound, 75, 100 )
		ply:SendLua("chat.AddText(Color(0,255,0,255), '[CASINO] ', Color(255,255,255,255), 'Winner! You won $"..amount.."!')")
	end

	if self.light then
		self.light:CreateLight( bJackpot )
	end
	
	ply:addMoney(amount)
		
end