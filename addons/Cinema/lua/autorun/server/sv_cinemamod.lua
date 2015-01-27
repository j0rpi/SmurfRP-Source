///////////////////////////////////////////////
///// Created by Temparh
///// 20th October 2013
///// server.lua
AddCSLuaFile("table.lua")
include("table.lua")

util.AddNetworkString("CinemaMenu")
util.AddNetworkString("TempMSG")
util.AddNetworkString("ChangeCinema")
util.AddNetworkString("BuyTicket")
util.AddNetworkString("CreateSeat") 
util.AddNetworkString("SendSeatTableServer")
util.AddNetworkString("SendSeatTableClient")
util.AddNetworkString("CinemaUpdate")
util.AddNetworkString("BuyPopcorn")

/*
concommand.Add("spawnEnt", function(ply, cmd, args) 
	local plyTrace = ply:GetEyeTrace()
	local loc = plyTrace.HitPos
	
	newEnt = ents.Create(args[1]);
	newEnt:SetPos(loc);

	if (newEnt:GetModel() == nil) then
		newEnt:SetModel("models/props_c17/FurnitureChair001a.mdl");
	end
	
	newEnt:Spawn();

end) */

function SpawnCinemaNPC()
	if CinemaSettings.NPCSellTickets then
		local npc = ents.Create("npc_cinema")
		npc:SetModel(CinemaSettings.NPCModel)
		npc:SetPos(CinemaSettings.NPCPosition)
		npc:SetAngles(Angle(0,0,0))
		npc:Spawn()
	end
end
hook.Add("InitPostEntity", "SpawnsNPCMaybe", SpawnCinemaNPC)

net.Receive("ChangeCinema", function(len, ply)
	local npc = net.ReadEntity()
	npc:SetNWBool("Occupied", false)
end)

net.Receive("BuyPopcorn", function(len, ply)
	ply:addMoney(-CinemaSettings.Popcorn)
	ply:Give("weapon_popcorn")
	net.Start("TempMSG")
		net.WriteString("You bought a bucket of popcorn")
		net.WriteInt(0,2)
	net.Send(ply)

	for k,v in pairs(player.GetAll()) do
		if v:Team() == TEAM_CINEMAMANAGER then
			v:addMoney(CinemaSettings.Popcorn)
			net.Start("TempMSG")
				net.WriteString("You sold a bucket of popcorn")
				net.WriteInt(0,2)
			net.Send(v)
		end
	end

end)
 
net.Receive("BuyTicket", function(len, ply)
	
	local price = CinemaSettings.Price
	local seat = net.ReadFloat() 
	local row = net.ReadFloat()
	local actualSeat = net.ReadFloat()
	if net.ReadString() == "popcorn" then 
		price = CinemaSettings.Price + CinemaSettings.Popcorn
		ply:Give("weapon_popcorn")
	end

	ply:addMoney(-price)
	OccupiedSeats[actualSeat].Occupied = true
	OccupiedSeats[actualSeat].Owner = ply:SteamID()
	ply:SetNWBool("OwnCinemaSeat", true)
	for k,v in pairs(ents.GetAll()) do
		if v:GetModel() == "models/nova/airboat_seat.mdl" then
			if v:GetNWInt("SeatNumber") == actualSeat then
				v:SetNWString("Owner", ply:SteamID())
			end
		end
	end
	for k,v in pairs(player.GetAll()) do
		if v:Team() == TEAM_CINEMAMANAGER then
			v:addMoney(price)
			net.Start("TempMSG")
				net.WriteString("You sold a ticket")
				net.WriteInt(0,2)
			net.Send(v)
		end
	end
	SetTableShared(OccupiedSeats) 
	//print(actualSeat) 
	//print(OccupiedSeats[actualSeat].Owner)
	net.Start("TempMSG")
		net.WriteString("You just bought a ticket to the movies. Your seat is in row "..row..", nr. "..seat)
		net.WriteInt(0,2)
	net.Send(ply)
	for k,v in pairs(player.GetAll()) do
		net.Start("SendSeatTableClient")
			net.WriteFloat(actualSeat)
			net.WriteString(ply:SteamID())
		net.Send(v)
	end
end)

SeatEntities = {}
function SpawnCinemaSeats()
	startPos = Vector(-1579, 1770, -202)
	SpawnPos = startPos
	side = 1
	seatnum = 1
	row = 1
	gap = 98
	width = 28
	for i=1,48 do
		if seatnum == 5 && side == 1 then
			side = 2
			SpawnPos = SpawnPos + Vector(-gap,0,0)
		end
		if seatnum == 9 && side == 2 then
			side = 3
			SpawnPos = SpawnPos + Vector(-5,0,0)
		end 
		if seatnum == 13 && side == 3 then
			side = 1
			seatnum = 1
			SpawnPos = SpawnPos - Vector(-(12*width+gap)-5, -58, (23+row) )
		end

		local Seat = ents.Create("prop_vehicle_prisoner_pod")
		Seat:SetPos(SpawnPos)
		Seat:SetModel( "models/nova/airboat_seat.mdl" )
		Seat:SetAngles(Angle(0, 0, 0))
		Seat:SetRenderMode(RENDERMODE_TRANSALPHA) 
		Seat:SetColor(Color(0,0,0,0))
		Seat:Spawn()
		Seat:SetMoveType(MOVETYPE_PUSH)
		Seat:SetNWInt("SeatNumber", i)
		Seat.SeatNumber = seatnum
		Seat:SetNWString("Owner", "None")
		//Seat:SetNWIn
		//Seat.Row = row 
		//Seat.Owner = OccupiedSeats[i].Owner
		//Seat:SetNWString("Owner", OccupiedSeats[i].Owner)
		Seat.DoorData = {}
		Seat.DoorData.NonOwnable = true
		SpawnPos = SpawnPos - Vector(width,0,0)

		//SetSeatPosition(seatnum, Vector(Seat:GetPos()))
		seatnum = seatnum +1


	end
end


/*
concommand.Add("cleanshit", function() 
	for k,v in pairs(ents.GetAll()) do
		if v:GetModel() == "models/nova/airboat_seat.mdl" then
			v:Remove()
		end
	end
end)*/

hook.Add("CanPlayerEnterVehicle", "CheckCinemaSeats", function(ply, seat, role)
	if seat:GetModel() == "models/nova/airboat_seat.mdl" && seat:GetNWString("Owner") != nil then
		if ply:Team() == TEAM_CINEMAMANAGER || ply:Team() ==  TEAM_CINEMAWORKER then
			return true
		end
		if seat:GetNWString("Owner") == ply:SteamID() then
			ply:SetNWInt("InSeat", seat:GetNWInt("SeatNumber")) 
			return true
		else
			net.Start("TempMSG")
				net.WriteString("This is not your seat.")
				net.WriteInt(1,2)
			net.Send(ply)
			return false
		end
	end
end)

hook.Add("CanExitVehicle", "RemoveFromCinemaSeat", function(vehicle, ply)
	ply:SetNWInt("InSeat", 0)
	return true
end) 

function SpawnDoors()
	for i=1,2 do 
		local door = ents.Create("prop_physics")
		door:SetModel("models/props_phx/construct/metal_plate2x2.mdl")
		door:SetAngles(Angle(0,0,90))
		door:SetNWBool("CinemaDoor", true)
		door:SetCustomCollisionCheck( )
		//door:SetMoveCollide(MOVECOLLIDE_FLY_SLIDE)
		door:Spawn() 
		door:SetRenderMode(RENDERMODE_TRANSALPHA) 
		door:SetColor(Color(0,0,0,0))
		if i==1 then door:SetPos(Vector(-1629, 1417, -132))
		else door:SetPos(Vector(-1629, 1417, -150)) end
		door:SetMoveType(MOVETYPE_NOCLIP)
	end


	local mngBlock = ents.Create("prop_physics")
	mngBlock:SetModel("models/props_phx/construct/metal_plate1x2.mdl")
	mngBlock:SetAngles(Angle(0,90,90))
	mngBlock:SetNWBool("IsManagerBlock", true)
	mngBlock:SetCustomCollisionCheck()
	mngBlock:SetPos(Vector(-1866, 1270, -131))
	mngBlock:SetRenderMode(RENDERMODE_TRANSALPHA)
	mngBlock:SetColor(Color(0,0,0,0))
	mngBlock:Spawn()
	mngBlock:SetMoveType(MOVETYPE_NOCLIP)
	
end
//concommand.Add("spawnDoors", SpawnDoors )

/*
concommand.Add("deletedoor", function() 
	for k,v in pairs(ents.GetAll()) do
		if v:GetModel() == "models/props_phx/construct/metal_plate2x2.mdl" then
			v:Remove()
		end
	end  
end)*/

function uncolidewithmng(ply)
	timer.Simple(2, function() ply:SetNWBool("CollidedWithMng",false) end)
end
hook.Add("ShouldCollide", "Go through manager door", function(ent1, ent2)
	if ent1:GetNWBool("CinemaDoor") then prop = ent1 collideplayer = ent2 
	elseif ent2:GetNWBool("CinemaDoor") then prop = ent2 collideplayer = ent1  
	else prop = ent1 collideplayer = ent2 end

	if prop:GetNWBool("IsManagerBlock") then
		if collideplayer:Team() == TEAM_CINEMAMANAGER then
			return false
		else
			if collideplayer:GetNWBool("CollidedWithMng") != true then
				collideplayer:SetNWBool("CollidedWithMng", true)
				net.Start("TempMSG")
					net.WriteString("Cinema Manager Only!")
					net.WriteInt(1,2)
				net.Send(collideplayer)
				uncolidewithmng(collideplayer)
			end	
			return true
		end
	end
end)

hook.Add("ShouldCollide", "Go through cinema door", function(ent1, ent2)
	if ent1:GetNWBool("CinemaDoor") then prop = ent1 collideplayer = ent2 
	elseif ent2:GetNWBool("CinemaDoor") then prop = ent2 collideplayer = ent1  
	else prop = ent1 collideplayer = ent2 end

		if prop:GetNWBool("CinemaDoor") && collideplayer:IsPlayer() && prop:GetModel() == "models/props_phx/construct/metal_plate2x2.mdl" && collideplayer:GetPos():Distance(prop:GetPos()) < 100 && (collideplayer:Team() == TEAM_CINEMAMANAGER || collideplayer:Team() ==  TEAM_CINEMAWORKER) then
			return false
		end 

	if prop:GetNWBool("CinemaDoor") && collideplayer:IsPlayer() && prop:GetModel() == "models/props_phx/construct/metal_plate2x2.mdl" && collideplayer:GetPos():Distance(prop:GetPos()) < 65 then

 
		if collideplayer:GetNWBool("OwnCinemaSeat") then
			
			if collideplayer:GetNWBool("CollidedWithCinema") == false && collideplayer:GetNWInt("PassedThroughCinemaDoor") == 1 then 
				collideplayer:SetPos(Vector(-1632.131958, 1390.774780, -196))
				collideplayer:SetNWBool("OwnCinemaSeat", false)
				collideplayer:SetNWBool("CollidedWithCinema", true)
				collideplayer:SetNWInt("PassedThroughCinemaDoor", 0)
				for k,v in pairs(ents.GetAll()) do
					if v:GetModel() == "models/nova/airboat_seat.mdl" && v:GetNWString("Owner") == collideplayer:SteamID() then
						v:SetNWString("Owner", "None") 
					end
				end
				for k,v in pairs(OccupiedSeats) do
					if v.Owner == collideplayer:SteamID() then
						v.Owner = nil
						v.Occupied = false
					end
				end
				if collideplayer:HasWeapon("weapon_popcorn") then
					collideplayer:StripWeapon("weapon_popcorn")
				end
				net.Start("TempMSG")
					net.WriteString("You left the cinema.") 
					net.WriteInt(0,2)
				net.Send(collideplayer) 
				for k,v in pairs(player.GetAll()) do
					RefreshCinemaData(v)
				end
				SetColiddedWithCinema(collideplayer, false, true)
				return false
			end

			if collideplayer:GetNWBool("OwnCinemaSeat") then
				collideplayer:SetPos(Vector(-1629.847778, 1435.301514, -195))
			end
			if collideplayer:GetNWBool("CollidedWithCinema") == false && collideplayer:GetNWBool("OwnCinemaSeat") then 
				//collideplayer:SetVelocity(Vector(0,700,0))
				//collideplayer:SetPos(Vector(-1629.847778, 1451.301514, -131.968750))
				//slowspeed(collideplayer)
				collideplayer:SetNWBool("CollidedWithCinema", true)
				net.Start("TempMSG")
					net.WriteString("You entered the cinema. Go find your seat.")
					net.WriteInt(0,2)
				net.Send(collideplayer) 
				SetColiddedWithCinema(collideplayer, false)
				collideplayer:SetNWInt("PassedThroughCinemaDoor", 1)
			end 
				return false
		else 
			collideplayer:SetPos(Vector(-1632.131958, 1390.774780, -196))
			slowspeed(collideplayer)
			if collideplayer:GetNWBool("CollidedWithCinema") == false then
				
			//	net.Start("TempMSG") 
			//		net.WriteString("You have to buy a ticket before entering the cinema!")
			//		net.WriteInt(1,2)
			//	net.Send(collideplayer) 
				collideplayer:SetNWBool("CollidedWithCinema", true)
				SetColiddedWithCinema(collideplayer, false)
				return true
			end 
		end  
	end

	if !collideplayer:IsPlayer() then return false end

end)

function RefreshCinemaData(ply)
	net.Start("CinemaUpdate")
		net.WriteTable(OccupiedSeats)
	net.Send(ply)
end
concommand.Add("RefreshCinema", RefreshCinemaData)

/*
function startup()
	for k,v in pairs(player.GetAll()) do
		v:SetNWBool("OwnCinemaSeat", false)
		v:SetNWBool("CollidedWithCinema", false)
	end
end*/

function SetColiddedWithCinema(ply, bool, bool2)
	timer.Create("SetColiddedNW", 0.7, 1, function() 
		ply:SetNWBool("CollidedWithCinema", bool) 
		if bool2 then
			ply:SetNWBool("OwnCinemaSeat", false) 
		end
	end)
end

function slowspeed(ply)
	timer.Simple(0.5, function() ply:SetVelocity(Vector(0,0,0)) end)
end

/*
hook.Add("Think", "CinemaBlock", function()
	doors = 
	for k,v in pairs(ents.GetAll()) do
		if v:GetNWBool("CinemaDoor") then
			
		end
	end

end)*/ 

hook.Add("Think", "CheckTicketOwner", function()
	for k,v in pairs(OccupiedSeats) do
		for j, h in pairs(player.GetAll()) do
			if v.Owner == h:SteamID() then
				h:SetNWBool("OwnsSeat", true)
				//print(h:Nick())
			end
		end
	end
end)

function OpenCinema(ply, args)
	if ply:Team() == TEAM_CINEMAMANAGER then
		ply:SetNWBool("CinemaStatus", true)
	end
end
function CloseCinema(ply, args)
	if ply:Team() == TEAM_CINEMAMANAGER then
		ply:SetNWBool("CinemaStatus", false)
	end
end
function HelpBox(ply, args)
	if ply:GetNWBool("ShouldCinemaHelp") then
		ply:SetNWBool("ShouldCinemaHelp", false)
	else
		ply:SetNWBool("ShouldCinemaHelp", true)
	end
end
function SetCinemaMovie(ply,args)
	if ply:Team() == TEAM_CINEMAMANAGER then
		local movie = args
		ply:SetNWString("CinemaFilm", movie)
	end
end

function UpdateMngCountdown(ply)
	ply:SetNWInt("CinemaCountDownProg", ply:GetNWInt("CinemaCountDownProg")-1)
	if ply:GetNWInt("CinemaCountDownProg") == 0 then
		ply:SetNWBool("Countdowing", false)
	end

	if ply:GetNWInt("CDSec") <= 0 then
		ply:SetNWInt("CDSec", 60)
		if ply:GetNWInt("CDMin") > 0 then
			ply:SetNWInt("CDMin", ply:GetNWInt("CDMin")-1)
		end
	else
		ply:SetNWInt("CDSec", ply:GetNWInt("CDSec") -1 )
	end

	if ply:GetNWInt("CDMin") <= -1 then
		if ply:GetNWInt("CDHour") > 0 then
			ply:SetNWInt("CDMin", 60 )
			ply:SetNWInt("CDHour", math.Clamp(ply:GetNWInt("CDHour") -1, 0, 6000000000000) )
		end
	end

	if ply:GetNWInt("CDMin") >= 60 then
		ply:SetNWInt("CDMin", 0)
		ply:SetNWInt("CDHour", ply:GetNWInt("CDHour")+1)
	end
end

function CinemaCountDown(ply,args)
	if ply:Team() == TEAM_CINEMAMANAGER then
		args = tonumber(args)
		min = args
		while min > 61 do
			min = min - 60
		end
		ply:SetNWInt("CinemaCountDown", args*60)
		ply:SetNWInt("CinemaCountDownProg", args*60)
		ply:SetNWInt("CDSec", 60)
		ply:SetNWInt("CDMin", min-1)
		ply:SetNWInt("CDHour", math.Clamp(math.floor(args/60-1), 0, 10000000000))
		ply:SetNWInt("CDHour", math.Clamp(ply:GetNWInt("CDHour"), 0, 100000000000000000))
		ply:SetNWInt("CDMin", math.Clamp(ply:GetNWInt("CDMin"), 0, 60))
		ply:SetNWInt("CDSec", math.Clamp(ply:GetNWInt("CDSec"), 0, 60))
		ply:SetNWBool("Countdowing", true)
		timer.Create("CDGayDown", 1, args*60, function() UpdateMngCountdown(ply) end)
	end
end

timer.Simple(30, function() 
DarkRP.defineChatCommand("/cinema_time", CinemaCountDown)
DarkRP.defineChatCommand("/cinema_open", OpenCinema)
DarkRP.defineChatCommand("/cinema_close", CloseCinema)
DarkRP.defineChatCommand("/cinema_help", HelpBox)
DarkRP.defineChatCommand("/cinema_title", SetCinemaMovie)
end)



hook.Add("InitPostEntity", "SpawnCinemaSeats", SpawnCinemaSeats)
hook.Add("InitPostEntity", "SpawnDoorsForCinema", SpawnDoors)
hook.Add("PlayerInitialSpawn", "SetCinemaData", RefreshCinemaData) 

hook.Add("OnPlayerChangedTeam", "SetCinemaSettings", function(ply, oldteam, newteam)
	if newteam == TEAM_CINEMAMANAGER then
		ply:SetNWBool("CinemaStatus", true)
		ply:SetNWString("CinemaFilm", "none")
	end
end)

concommand.Add("RespawnNPC", function(ply)
if !ply:IsAdmin() then return end
SpawnCinemaNPC()
end)

concommand.Add("spawnDoors", function(ply)
if !ply:IsAdmin() then return end
SpawnDoors()
end)

concommand.Add("spawnSeats", function(ply)
if !ply:IsAdmin() then return end
SpawnCinemaSeats()
end)

hook.Add("PlayerDisconnected", "player leaves cinema", function(ply)
for k,v in pairs(OccupiedSeats) do
if v.Owner == ply:SteamID() then
v.Owner = nil
v.Occupied = false
for _,otherply in pairs(player.GetAll()) do
RefreshCinemaData(otherply)
end

end
end
end)

concommand.Add("resetCinema", function(ply)
if (!ply:IsAdmin()) then return end

for k,v in pairs(OccupiedSeats) do
v.Owner = nil
v.Occupied = false
end

for _,otherply in pairs(player.GetAll()) do
RefreshCinemaData(otherply)
end
end)
