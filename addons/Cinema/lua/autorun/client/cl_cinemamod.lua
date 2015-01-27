///////////////////////////////////////////////
///// Created by Temparh
///// 21th October 2013
///// cl_start.lua
include("table.lua")
print("cl works")

surface.CreateFont( "WelcomeText", {
 font = "default",
 size = 15,
 weight = 800,
 blursize = 0,
 scanlines = 0,
 antialias = true,
 underline = false,
 italic = false,
 strikeout = false,
 symbol = false,
 rotary = false,
 shadow = false,
 additive = false, 
 outline = false
} )

surface.CreateFont( "BigSeatText", {
 font = "Arial",
 size = 100,
 weight = 550,
 blursize = 0,
 scanlines = 0,
 antialias = true,
 underline = false,
 italic = false,
 strikeout = false,
 symbol = false,
 rotary = false,
 shadow = false,
 additive = false,
 outline = false
} )

surface.CreateFont( "ButtonFont", {
 font = "Arial",
 size = 22,
 weight = 800,
 blursize = 0,
 scanlines = 0,
 antialias = true,
 underline = false,
 italic = false,
 strikeout = false,
 symbol = false,
 rotary = false,
 shadow = false,
 additive = false,
 outline = false
} )

surface.CreateFont( "SeatFont", {
 font = "arial",
 size = 22,
 weight = 500,
 blursize = 0,
 scanlines = 0,
 antialias = true,
 underline = false,
 italic = false,
 strikeout = false,
 symbol = false,
 rotary = false,
 shadow = false,
 additive = false,
 outline = false
} )

surface.CreateFont( "BigDefault", {
 font = "default",
 size = 28,
 weight = 500,
 blursize = 0,
 scanlines = 0,
 antialias = true,
 underline = false,
 italic = false,
 strikeout = false,
 symbol = false,
 rotary = false,
 shadow = false,
 additive = false,
 outline = false
} )

surface.CreateFont( "MonitorFont", {
 font = "default",
 size = 70,
 weight = 500,
 blursize = 0,
 scanlines = 0,
 antialias = true,
 underline = false,
 italic = false,
 strikeout = false,
 symbol = false,
 rotary = false,
 shadow = false,
 additive = false,
 outline = false
} )

surface.CreateFont( "ClosedMonitorBig", {
 font = "arial", 
 size = 150,
 weight = 800,
 blursize = 0,
 scanlines = 0,
 antialias = true,
 underline = false,
 italic = false,
 strikeout = false,
 symbol = false,
 rotary = false,
 shadow = false,
 additive = false,
 outline = false
} )

surface.CreateFont( "ClosedMonitorSmall", {
 font = "arial",
 size = 80,
 weight = 800,
 blursize = 0,
 scanlines = 0,
 antialias = true,
 underline = false,
 italic = false,
 strikeout = false,
 symbol = false,
 rotary = false,
 shadow = false,
 additive = false,
 outline = false
} )

surface.CreateFont( "ClosedMonitorSmaller", {
 font = "arial",
 size = 60,
 weight = 800,
 blursize = 0,
 scanlines = 0,
 antialias = true,
 underline = false,
 italic = false,
 strikeout = false,
 symbol = false,
 rotary = false,
 shadow = false,
 additive = false,
 outline = false
} )


surface.CreateFont( "CinemaHelpBox", {
 font = "arial",
 size = 15,
 weight = 800,
 blursize = 0,
 scanlines = 0,
 antialias = true,
 underline = false,
 italic = false,
 strikeout = false,
 symbol = false,
 rotary = false,
 shadow = false,
 additive = false,
 outline = false
} )


surface.CreateFont( "CountDownFont", {
 font = "arial",
 size = 40,
 weight = 800,
 blursize = 0,
 scanlines = 0,
 antialias = true,
 underline = false,
 italic = false,
 strikeout = false,
 symbol = false,
 rotary = false,
 shadow = false,
 additive = false,
 outline = false
} )

function CinemaTicketBuy(clerk)
	LocalPlayer():ConCommand("RefreshCinema")


	ClerkNPC = clerk

	/*if LocalPlayer():Team() == TEAM_CINEMAMANAGER or LocalPlayer():Team() == TEAM_CINEMAWORKER then
		net.Start("ChangeCinema")
			net.WriteEntity(ClerkNPC)
		net.SendToServer()
		return ""
	end
*/
	local ownseat = false
	if LocalPlayer():GetNWBool("OwnCinemaSeat") && CinemaSettings.OneTicketOnly then
		ownseat = true
	end
	if ownseat then
		if CinemaSettings.SellPopcorn then
				local welcomeFrame = vgui.Create("DFrame")
			welcomeFrame:SetSize(400,150)
			welcomeFrame:SetTitle("Cinema Clerk")
			welcomeFrame:MakePopup()
			welcomeFrame:SetDraggable(false)
			welcomeFrame:IsVisible(true)
			welcomeFrame:SetSizable(false)
			welcomeFrame:SetPos(ScrW()/2-200, ScrH()-150-75)
			welcomeFrame:ShowCloseButton(false)

			local welcomeLabel = vgui.Create("DLabel", welcomeFrame)
			welcomeLabel:SetText("You already have a seat. Do you want to buy some popcorn?")
			welcomeLabel:SetFont("WelcomeText")
			welcomeLabel:SetTextColor(SeatColors.ButtonLabel) 
			welcomeLabel:SizeToContents()
			welcomeLabel:SetPos(200-welcomeLabel:GetWide()/2,32.5)

			local n = vgui.Create("DButton", welcomeFrame)
			n:SetPos(20, 100)
			n:SetSize(360, 30)
			n:SetText("No thank you. I am just waiting for the movie to start.")
			n.DoClick = function()
				welcomeFrame:Close()
				net.Start("ChangeCinema")
					net.WriteEntity(ClerkNPC)
				net.SendToServer()
			end

			local y = vgui.Create("DButton", welcomeFrame)
			y:SetPos(20, 60)
			y:SetSize(360, 30)
			y:SetText("Yes please. I would like a bucket. (Costs: $"..CinemaSettings.Popcorn..")")
			y.DoClick = function()
				welcomeFrame:Close()
				net.Start("BuyPopcorn")
				net.SendToServer()
				net.Start("ChangeCinema")
					net.WriteEntity(ClerkNPC)
				net.SendToServer()
			end
		else
			net.Start("ChangeCinema")
				net.WriteEntity(ClerkNPC)
			net.SendToServer()
			return ""
		end
	else

	local welcomeFrame = vgui.Create("DFrame")
	welcomeFrame:SetSize(400,150)
	welcomeFrame:SetTitle("Cinema Clerk")
	welcomeFrame:MakePopup()
	welcomeFrame:SetDraggable(false)
	welcomeFrame:IsVisible(true)
	welcomeFrame:SetSizable(false)
	welcomeFrame:SetPos(ScrW()/2-200, ScrH()-150-75)
	welcomeFrame:ShowCloseButton(false)

	local welcomeLabel = vgui.Create("DLabel", welcomeFrame)
	welcomeLabel:SetText("Welcome to the cinema. Would you like to buy a ticket?")
	welcomeLabel:SetFont("WelcomeText")
	welcomeLabel:SetTextColor(SeatColors.ButtonLabel)
	welcomeLabel:SizeToContents()
	welcomeLabel:SetPos(200-welcomeLabel:GetWide()/2,32.5)

	local n = vgui.Create("DButton", welcomeFrame)
	n:SetPos(20, 100)
	n:SetSize(360, 30)
	n:SetText("No thank you. I don't really like this movie.")
	n.DoClick = function()
		welcomeFrame:Close()
		net.Start("ChangeCinema")
			net.WriteEntity(ClerkNPC)
		net.SendToServer()
	end

	local y = vgui.Create("DButton", welcomeFrame)
	y:SetPos(20, 60)
	y:SetSize(360, 30)
	y:SetText("Yes please. Let me see what seats are open.")
	y.DoClick = function()
		welcomeFrame:Close()
		local frame = vgui.Create("DFrame")
		frame:SetSize(900,700)
		frame:SetTitle("")
		frame:Center()
		frame:MakePopup()
		frame:SetDraggable(false)
		frame:IsVisible(true)
		frame:SetSizable(false)
		frame:ShowCloseButton(false)
		frame.Paint = function()
			surface.SetDrawColor(Color(0,0,0,0))
			surface.DrawRect(0,0, frame:GetWide(), frame:GetTall()-30)
		end

		local leave = vgui.Create("DButton",frame)
		leave:SetPos(100,40)
		leave:SetSize(200,50)
		leave:SetFont("SeatFont")
		leave:SetText("Leave the Cinema")
		leave:SetTextColor(SeatColors.ButtonLabel)
		leave.DoClick = function()
			net.Start("ChangeCinema")
				net.WriteEntity(ClerkNPC)
			net.SendToServer()
			frame:Close()
		end
		leave.Paint = function()
			surface.SetDrawColor(Color(0,0,0,255))
			surface.DrawRect(0, 0, leave:GetWide()+2, leave:GetTall()+2 )
			surface.SetDrawColor(SeatColors.Background)
			surface.DrawRect( 1, 1, leave:GetWide()-2, leave:GetTall()-2)
		end

		local textPanel = vgui.Create("DPanel", frame)
		textPanel:SetPos(310,40)
		textPanel:SetSize(490, 50)
		textPanel.Paint = function()
			surface.SetDrawColor(Color(0,0,0,255))
			surface.DrawRect(0, 0, textPanel:GetWide()+2, textPanel:GetTall()+2 )
			surface.SetDrawColor(SeatColors.Background)
			surface.DrawRect( 1, 1, textPanel:GetWide()-2, textPanel:GetTall()-2)
		end

		local seatInfo = vgui.Create("DLabel", textPanel)
		seatInfo:SetPos(10, 13)
		seatInfo:SetFont("WelcomeText")
		seatInfo:SetTextColor(SeatColors.ButtonLabel)
		seatInfo:SetText("Pick the seat you want to sit in.")
		seatInfo:SetFont("SeatFont")
		seatInfo:SizeToContents()
		seatInfo.Think = function()
			if chosenSeat != nil then
				seatInfo:SetText("Row "..Seats[chosenSeat].Row..", nr. "..Seats[chosenSeat].Num)
				seatInfo:SizeToContents()
			end
		end


		local buy = vgui.Create("DButton",frame)
		buy:SetPos(600, 605)
		buy:SetSize(200,50)
		buy:SetText("Buy this seat")
		buy:SetFont("SeatFont")
		buy:SetText("Buy a ticket for "..CinemaSettings.Price.."$")
		buy:SetTextColor(SeatColors.ButtonLabel)
		buy.DoClick = function()
			net.Start("ChangeCinema") 
				net.WriteEntity(ClerkNPC)
			net.SendToServer()

			net.Start("BuyTicket")
				net.WriteFloat(Seats[chosenSeat].Num)
				net.WriteFloat(Seats[chosenSeat].Row)
				net.WriteFloat(Seats[chosenSeat].NumTotal)
			net.SendToServer()

			for k,v in pairs(player.GetAll()) do
				v:ConCommand("RefreshCinema")
			end  

			OccupiedSeats[chosenSeat].Occupied = true
			OccupiedSeats[chosenSeat].Owner = LocalPlayer():SteamID()
			//SendSeatTable(OccupiedSeats)
			frame:Close()
		end 
		buy.Think = function()
			if chosenSeat != nil then
				 buy:SetSize(200,50)
			else
				buy:SetSize(0,0)
			end
		end
		buy.Paint = function()
			surface.SetDrawColor(Color(0,0,0,255))
			surface.DrawRect(0, 0, buy:GetWide()+1, buy:GetTall()+1 )
			surface.SetDrawColor(SeatColors.Background)
			surface.DrawRect( 1, 1, buy:GetWide()-2, buy:GetTall()-2)
		end
 
		if CinemaSettings.SellPopcorn then
			local buypopcorn = vgui.Create("DButton",frame)
			buypopcorn:SetPos(100, 605)
			buypopcorn:SetSize(300,50) 
			buypopcorn:SetText("Buy this seat") 
			buypopcorn:SetFont("SeatFont")
			buypopcorn:SetText("Buy a ticket and popcorn for "..CinemaSettings.Price+CinemaSettings.Popcorn.."$")
			buypopcorn:SetTextColor(SeatColors.ButtonLabel)
			buypopcorn.DoClick = function()
				net.Start("ChangeCinema") 
					net.WriteEntity(ClerkNPC)
				net.SendToServer()

				net.Start("BuyTicket") 
					net.WriteFloat(Seats[chosenSeat].Num)
					net.WriteFloat(Seats[chosenSeat].Row)
					net.WriteFloat(Seats[chosenSeat].NumTotal)
					net.WriteString("popcorn")
				net.SendToServer()
				for k,v in pairs(player.GetAll()) do
					v:ConCommand("RefreshCinema")
				end  
				OccupiedSeats[chosenSeat].Occupied = true
				OccupiedSeats[chosenSeat].Owner = LocalPlayer():SteamID()
				//SendSeatTable(OccupiedSeats)
				frame:Close()
			end 

			buypopcorn.Think = function()
				if chosenSeat != nil then
					 buypopcorn:SetSize(300,50)
				else
					buypopcorn:SetSize(0,0)
				end
			end
			buypopcorn.Paint = function()
				surface.SetDrawColor(Color(0,0,0,255))
				surface.DrawRect(0, 0, buypopcorn:GetWide()+2, buypopcorn:GetTall()+2 )
				surface.SetDrawColor(SeatColors.Background)
				surface.DrawRect( 1, 1, buypopcorn:GetWide()-2, buypopcorn:GetTall()-2)
			end
		end

		seatPanel = vgui.Create("DPanel", frame)
		seatPanel:SetSize(700, 500)
		seatPanel:SetPos(100,100)
		seatPanel.Paint = function()
			surface.SetDrawColor(Color(0,0,0,255))
			surface.DrawRect(0, 0, seatPanel:GetWide()+2, seatPanel:GetTall()+2 )
			surface.SetDrawColor(SeatColors.Background)
			surface.DrawRect( 1, 1, seatPanel:GetWide()-2, seatPanel:GetTall()-2)

		end

		local MovieScreen = vgui.Create("DPanel", seatPanel)
		MovieScreen:SetSize(600,50)
		MovieScreen:SetPos(50, 50)
		MovieScreen.Paint = function()
			surface.SetDrawColor(Color(0,0,0,255))
			surface.DrawRect(0, 0, MovieScreen:GetWide()+2, MovieScreen:GetTall()+2 )
			surface.SetDrawColor(SeatColors.Screen)
			surface.DrawRect( 1, 1, MovieScreen:GetWide()-2, MovieScreen:GetTall()-2)
		end
		local MovieText = vgui.Create("DLabel", MovieScreen)
		MovieText:SetFont("BigDefault")
		MovieText:SetTextColor(Color(0,0,0,255))
		MovieText:SetText("Movie Screen")
		MovieText:SizeToContents()
		MovieText:SetPos(300-(MovieText:GetWide()/2), 10)


		Seats = {}
		x = 640
		side = 1
		row = 1
		seatw = 50
		seath = 40
		gap = 30
		seatnum = 1 
		chosenSeat = nil

		for i=1,48 do
			if side==1 && seatnum==5 then
				side = 2
				x = x - 80
			end
			if side == 2 && seatnum==13 then
				row = row + 1
				seatnum = 1
				side = 1
				x = 640
			end
			y = seatPanel:GetTall() - seath - 20 - (row-1)*(seath+gap)
			local seat = vgui.Create("DPanel", seatPanel)
			seat:SetSize(seatw, seath)
			seat:SetPos(x,y)
			if OccupiedSeats[i].Occupied then
				if OccupiedSeats[i].Owner == LocalPlayer():SteamID() then
					seat.drawColor = SeatColors.OwnedSeat
				else
					seat.drawColor = SeatColors.ClosedSeat
				end
			else
				seat.drawColor = SeatColors.OpenSeat
			end
			seat.SeatNum = i
			seat.Paint = function()
				surface.SetDrawColor(Color(0,0,0,255))
				surface.DrawRect(0, 0, seat:GetWide()+2, seat:GetTall()+2 )
				surface.SetDrawColor(seat.drawColor)
				surface.DrawRect( 1, 1, seat:GetWide()-2, seat:GetTall()-2 )
			end
			seat.OnCursorEntered = function()
				if chosenSeat != i then
					if OccupiedSeats[i].Occupied then
						if OccupiedSeats[i].Owner == LocalPlayer():SteamID() then
							seat.drawColor = SeatColors.OwnedSeat
						else
							seat.drawColor = SeatColors.ClosedSeatHover
						end
					else
						seat.drawColor = SeatColors.OpenSeatHover 
					end
				end
			end 
			seat.OnCursorExited = function()
				if chosenSeat != i then
					if OccupiedSeats[i].Occupied then
						if OccupiedSeats[i].Owner == LocalPlayer():SteamID() then
							seat.drawColor = SeatColors.OwnedSeat
						else
							seat.drawColor = SeatColors.ClosedSeat
						end
					else
						seat.drawColor = SeatColors.OpenSeat
					end
				end
				if OccupiedSeats[i].Owner == LocalPlayer():SteamID() then
					seat.DrawColor = SeatColors.OwnedSeat
				end
			end
			seat.OnMousePressed = function()
				if OccupiedSeats[i].Occupied == false then
					chosenSeat = i
					seat.drawColor = SeatColors.PickedSeat
				end

			end
			seat.Think = function() 
				if seat.drawColor == SeatColors.PickedSeat && chosenSeat != i then
					seat.drawColor = SeatColors.OpenSeat
				end
			end
			seat.Row = row
			seat.Num = seatnum
			seat.NumTotal = i
			//seat.Position = OccupiedSeats[]
			x = x - seatw+1
			seatnum = seatnum + 1
			table.insert(Seats, seat)
		end

	end
end
end 

net.Receive("CinemaMenu", function(len)
	local npc = net.ReadEntity()
	CinemaTicketBuy(npc)
end)


net.Receive("TempMSG", function(len)
	local msg = net.ReadString()
	local notify = net.ReadInt(2)
	SendNotificationClient(msg, notify)
end)

function SendNotificationClient(msg, notify)
	notification.AddLegacy(msg, notify, 4)
	if notify == 1 then
		surface.PlaySound("buttons/button10.wav")
	else
		surface.PlaySound("buttons/button15.wav") 
	end
end

/*
concommand.Add("unownAll", function()
	for k,v in pairs(ents.GetAll()) do 
		if v:GetModel() == "models/nova/airboat_seat.mdl" then
			v.DoorData = v.DoorData or {}
			v.DoorData.NonOwnable = true
		end 
	end
end) */


  
bounce = 0
bouncedown = true
maxbounce = 75
bouncespeed = 0.1
hook.Add("Think", "CheckSeatOwner", function()

end)
ShouldDraw = {}
hook.Add("PostDrawTranslucentRenderables", "DrawSeat", function() 
	ShouldDraw = {}
 
	for k,v in pairs(ents.GetAll()) do
		if v:GetModel() == "models/nova/airboat_seat.mdl" && v:GetNWInt("SeatNumber") != nil then
			if v:GetNWString("Owner") == LocalPlayer():SteamID() then
				if  !table.HasValue(ShouldDraw,v) && v:GetNWInt("SeatNumber") != LocalPlayer():GetNWInt("InSeat") then
				cam.Start3D2D(v:GetPos() + Vector(0, 0,25), Angle(0,180,90), 0.07);
					draw.SimpleText("Your seat", "BigSeatText", 0, 0, Color(0, 255, 0, 255), TEXT_ALIGN_CENTER )

					surface.SetDrawColor(Color(0,200,0,255))
					

					 centerx = 0 --this is the middle x cordinate
					 centery = -500+bounce --this is the middle y cordinate
					 trianglevertex = {{ },{ },{ }} --create the two dimensional table
					 
					 --First Vertex
					trianglevertex[1]["x"] = centerx - 100
					trianglevertex[1]["y"] = centery 
					trianglevertex[1]["u"] = 1 //Top Left
					trianglevertex[1]["v"] = 0
					 
					 --Second Vertex
					trianglevertex[2]["x"] = centerx + 100
					trianglevertex[2]["y"] = centery
					trianglevertex[2]["u"] = 1 //Top Right
					trianglevertex[2]["v"] = 0
					 
					 --Third Vertex
					trianglevertex[3]["x"] = centerx
					trianglevertex[3]["y"] = centery + 175
					trianglevertex[3]["u"] = 0 //Bottom Left
					trianglevertex[3]["v"] = 1

					surface.DrawPoly( trianglevertex )
					draw.RoundedBox(0,-50, -650+bounce, 100, 200, Color(0,200,0,255))

					if bouncedown then
						bounce = bounce + bouncespeed
					else
						bounce = bounce - bouncespeed
					end

					if bounce > maxbounce then
						bouncedown = false
					end
					if bounce < 0 then
						bouncedown = true
					end
					//surface.DrawRect(-10, -30,  )
				cam.End3D2D() 
				table.insert(ShouldDraw, v)
		       end
			end
		end 
	end
	CinemaWindow()
	doorwide = 1100
	doortall = 1160
	if !LocalPlayer():GetNWBool("OwnCinemaSeat") && LocalPlayer():Team() != TEAM_CINEMAMANAGER && (LocalPlayer():Team() != TEAM_CINEMAWORKER) then
		cam.Start3D2D(Vector(-1685, 1414, -80), Angle(0,0, 90), 0.1)
			draw.RoundedBox(0, 0,0,doorwide,doortall, Color(50,50,50,255))
			draw.DrawText("You need a ticket to enter", "ClosedMonitorSmall", doorwide/2, doortall/2-100, Color(255,50,50,255), TEXT_ALIGN_CENTER)
			draw.DrawText("Buy one from the cinema staff", "ClosedMonitorSmaller", doorwide/2, doortall/2-10, Color(255,255,255,255), TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end

end) 

got = {} 
net.Receive("SendSeatTableClient", function(len) 
	table.insert(got, LocalPlayer():Nick())
	local seat = net.ReadFloat()
	local owner = net.ReadString() 
	OccupiedSeats[seat].Owner = owner 
	OccupiedSeats[seat].Occupied = true
end) 

net.Receive("CinemaUpdate", function(len)
	local recTable = net.ReadTable()
	OccupiedSeats = {}
	OccupiedSeats = recTable
end)

function CinemaWindow()
	hasOwner = false
	isOpen = false
	owner = nil
	for k,v in pairs(player.GetAll()) do
		if v:Team() == TEAM_CINEMAMANAGER then
			hasOwner = true
			owner = v
			isOpen = v:GetNWBool("CinemaStatus")
			if v:GetNWString("CinemaFilm") != nil then
				movie = v:GetNWString("CinemaFilm")
			end
		end
	end


	wide = 1340
	tall = 850
	cam.Start3D2D(Vector(-1696, 999, -72), Angle(0, 90, 90), 0.1 )
		draw.RoundedBox( 0, 0, 0, wide, tall, Color( 50, 50, 50, 255 ) ) // FRAME


		if hasOwner && isOpen then
			txt = "Movie: "..movie
			if string.len(movie) == 0 || movie == "none" then
				txt = "Waiting for next film"
			end
			draw.RoundedBox( 0, wide/2-(wide-100)/2, 50, (wide-100), 125, SeatColors.Screen )

			draw.DrawText(txt, "MonitorFont", wide/2, 75, SeatColors.ScreenLabel , TEXT_ALIGN_CENTER)
			if owner:GetNWInt("CinemaCountDownProg") > 0 then
				draw.DrawText("Movie Start In: ".. owner:GetNWInt("CDHour").. "h, ".. owner:GetNWInt("CDMin").."m, ".. owner:GetNWInt("CDSec").. "s", "CountDownFont", wide/2, 200, Color(255,255,255,255), TEXT_ALIGN_CENTER)
			end
			local seatx = 90
			local seaty = 75
			local gap = 180

			local x = wide-140
			local y = tall-100

			local row = 1
			local side = 1
			local seat = 1

			for i=1,48 do

				if seat == 5 && side==1 then
					x = x - gap
					side = 2
				end
				if seat == 13 && side == 2 then
					row = row + 1
					seat = 1
					side = 1
					x = wide-140
					y = y-seaty*2
				end 

				local Paincolor = SeatColors.OpenSeat
				 if OccupiedSeats[i].Occupied == true then
					Paincolor =  SeatColors.ClosedSeat
				end
				if OccupiedSeats[i].Occupied == true && OccupiedSeats[i].Owner == LocalPlayer():SteamID() then
					Paincolor =  Color(50,50,255,255)
				end 


				//draw.RoundedBox(0, x, y, seatx+2, seaty, Color(0,0,0,255) )
				draw.RoundedBox(0, x+2, y+2, seatx-2, seaty-4, Paincolor )

				x = x - seatx
				seat = seat+1 
			end
		else
			local font = "ClosedMonitorBig"
			local txt = CinemaSettings.ClosedText
			local color = SeatColors.ScreenClosedLabel
			if string.len(CinemaSettings.ClosedText) > 16 then 
				font = "ClosedMonitorSmall"
			end
			local owner = false
			for k,v in pairs(player.GetAll()) do
				if v:Team() == TEAM_CINEMAMANAGER then
					owner = true
					break
				end
			end
			if !owner then
				txt = "The Cinema is closed"
				color = SeatColors.CinemaNoOwner
			end
			if owner then
				draw.DrawText("The Cinema is closed", font, wide/2, tall/2-50, SeatColors.ScreenClosedLabel, TEXT_ALIGN_CENTER)
				draw.DrawText("Please come back later", "ClosedMonitorSmaller" , wide/2, tall/2+50, Color(255,255,255,255), TEXT_ALIGN_CENTER)
			end
			
			if !owner then
				draw.DrawText("The Cinema is closed", font, wide/2, tall/2-50, SeatColors.ScreenClosedLabel, TEXT_ALIGN_CENTER)
				draw.DrawText("Manager needed", "ClosedMonitorSmaller" , wide/2, tall/2+50, Color(255,255,255,255), TEXT_ALIGN_CENTER)
			end 
 
		end


	cam.End3D2D()
end

hook.Add("KeyPress", "PressCinema", function(ply, key)
	if key == IN_USE then 
		local traceRes = ply:GetEyeTrace()
		if traceRes.Entity:IsPlayer() && (traceRes.Entity:Team() == TEAM_CINEMAMANAGER || traceRes.Entity:Team() == TEAM_CINEMAWORKER) then 
			owner = false
			owneriscaller = false
			status = false
			for k,v in pairs(player.GetAll()) do
				if v:Team() == TEAM_CINEMAMANAGER then
					owner = true
					status = v:GetNWBool("CinemaStatus")
					if v == ply then
						owneriscaller = true
					end
				end
			end
			if owneriscaller then return end
			if !owner then
				if msgd != true then
					msgd = true
					SendNotificationClient("You cannot buy a ticket. There is no Cinema Manager", 1)
					timer.Simple(2, function() msgd = false end)
				end
				return ""
			end
			if !status then
				if msgd != true then
					msgd = true
					SendNotificationClient("You cannot buy a ticket. The Cinema is closed", 1)
					timer.Simple(2, function() msgd = false end)
				end
				return ""
			end

			if ply:Team() == TEAM_CINEMAWORKER || ply:Team() == TEAM_CINEMAMANAGER then
				return
			end
			if traceRes.Entity:Team() == TEAM_CINEMAMANAGER && !CinemaSettings.ManagerSellTickets then 
				return
			end
			if traceRes.Entity:Team() == TEAM_CINEMAWORKER && !CinemaSettings.WorkerSellTickets then
				return
			end

			if owner then
				if !status then
					if msgd != true then 
						msgd = true
						SendNotificationClient("The Cinema staff is not selling tickets at the moment.",1)
						timer.Simple(2, function() msgd = false end)
					end
				else
					traceRes.Entity:SetNWBool("Occupied", false)
					if traceRes.Entity:GetNWBool("Occupied") then
						if msgd != true then 
							msgd = true
							SendNotificationClient("Someone is already talking to the Cinema staff.",1)
							timer.Simple(2, function() msgd = false end)
						end
					end
					if traceRes.Entity:GetNWBool("Occupied") == false then
						if msgd != true then 
							msgd = true
							timer.Simple(2, function() msgd = false end)
							traceRes.Entity:SetNWBool("Occupied", true)
							CinemaTicketBuy(traceRes.Entity)
						end
					end
				end
			else
				if msgd != true then
					msgd = true
					SendNotificationClient("You cannot buy a ticket because there is no Cinema Manager",1)
					timer.Simple(2, function() msgd = false end)
				end
			end

		end
	end
end)

hook.Add("HUDPaint", "cinemamanagerhelp", function()
	local shouldClose = true
	local owner = false
	if LocalPlayer():GetNWBool("CinemaHelpClose") != nil then
		shouldClose = LocalPlayer():GetNWBool("ShouldCinemaHelp") 
	end
	if LocalPlayer():Team() == TEAM_CINEMAMANAGER then
		owner = true
	end

	if !shouldClose && owner then
		draw.RoundedBox(6, ScrW()-325, 25, 300, 115, Color(50,50,50,200))
		draw.DrawText("Open Cinema:", "CinemaHelpBox", ScrW()-310, 35, Color(255,255,255,255), TEXT_ALIGN_LEFT)
		draw.DrawText("/cinema_open", "CinemaHelpBox", ScrW()-228, 35, Color(0,170,255,255), TEXT_ALIGN_LEFT)

		draw.DrawText("Close Cinema:", "CinemaHelpBox", ScrW()-310, 55, Color(255,255,255,255), TEXT_ALIGN_LEFT)
		draw.DrawText("/cinema_close", "CinemaHelpBox", ScrW()-225, 55, Color(0,170,255,255), TEXT_ALIGN_LEFT)

		draw.DrawText("Change Title:", "CinemaHelpBox", ScrW()-310, 75, Color(255,255,255,255), TEXT_ALIGN_LEFT)
		draw.DrawText("/cinema_title <title>", "CinemaHelpBox", ScrW()-233, 75, Color(0,170,255,255), TEXT_ALIGN_LEFT)

		draw.DrawText("Movie Timer:", "CinemaHelpBox", ScrW()-310, 95, Color(255,255,255,255), TEXT_ALIGN_LEFT)
		draw.DrawText("/cinema_time <minutes to movie>", "CinemaHelpBox", ScrW()-234, 95, Color(0,170,255,255), TEXT_ALIGN_LEFT)

		draw.DrawText("Close/Open Help:", "CinemaHelpBox", ScrW()-310, 115, Color(255,255,255,255), TEXT_ALIGN_LEFT)
		draw.DrawText("/cinema_help", "CinemaHelpBox", ScrW()-210, 115, Color(0,170,255,255), TEXT_ALIGN_LEFT)
	end
end)