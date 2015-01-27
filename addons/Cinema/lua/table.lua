///////////////////////////////////////////////
///// Created by Temparh
///// 21th October 2013
///// table.lua

CinemaSettings = {} // IGNORE THIS DONT TOUCH
SeatColors = {} // IGNORE THIS DONT TOUCH


//////////////////////////////
/// GAME SETTINGS

CinemaSettings.ShouldDisableOnNoOwner = false // can you buy tickets when no one is there? NOTE NOT USED IT WAS FOR THE NPC

CinemaSettings.Price = 80 // Price of a ticket

CinemaSettings.Popcorn = 5 // Price of popcorn

CinemaSettings.SellPopcorn = true // Does the cinema sell popcorn?

CinemaSettings.OneTicketOnly = true // Can you buy more than one ticket? true/false

CinemaSettings.ClosedText = "The Cinema is closed, come back later" // Text when the cinema is closed

CinemaSettings.NoOwnerText = "The Cinema is closed!\n Manager needed!"

CinemaSettings.ManagerSellTickets = true // Should a Cinema manger be able to sell tickets? true/false

CinemaSettings.WorkerSellTickets = true // should a cinema worker be able to sell tickets? true/false

CinemaSettings.NPCSellTickets = true // should a npc spawn in the cinema and sell tickets? true/false

CinemaSettings.NPCModel = "models/humans/group01/male_07.mdl" // The model of the NPC if above is true

CinemaSettings.NPCPosition = Vector(-1685, 1162, -131) // The position of the npc. use getpos in console to get your position that you can copy to this. remember to make commas.

//////////////////////////////
/// Color and outlook settings

SeatColors.OpenSeat = Color(50,255,50,255) // color of open seats

SeatColors.OpenSeatHover = Color(50,200,50,255) // color of open seats you have mouse over

SeatColors.ClosedSeat = Color(255,50,50,255) // color of seat that is already bought

SeatColors.ClosedSeatHover = Color(255,0,0,255) // color of seats someone else own which your mouse is hovering over

SeatColors.PickedSeat = Color(55,100,50,255)  // color of seats you have pressed

SeatColors.OwnedSeat = Color(50,50,255,255) // Color of seats you own

SeatColors.Background = Color(50, 50, 50, 255) // Color of the background when buying tickets and looking at them

SeatColors.Screen = Color(255, 50, 50, 255)  // Color of the screen

SeatColors.ScreenLabel = Color(50,50,50,255) // Color of the text saying "screen"

SeatColors.ButtonLabel = Color(255,255,255,255) // Color on buttons when buying ticket

SeatColors.ScreenClosedLabel = Color(255,50,50,255) // Color when showing cinema closed

SeatColors.CinemaNoOwner = Color(50,255,50,255) 
 



 /// DONT TOUCH
OccupiedSeats = {}
for i=1,48 do
	OccupiedSeats[i] = {Occupied = false, Owner = nil, Position = nil}
end   

function SetTableShared(tableh)
	OccupiedSeats = tableh
end  