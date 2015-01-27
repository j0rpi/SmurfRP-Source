/*TEAM_DJ = AddExtraTeam("DJ", {
	color = Color(162, 0, 255, 255),
	model = "models/player/p2_chell.mdl",
	description = [[DJ is able to buy a radio and play music.]],
	weapons = {},
	command = "dj",
	max = 2,
	salary = 90,
	admin = 0,
	vote = false,
	hasLicense = false,
	candemote = false,
	mayorCanSetSalary = true
})

TEAM_CINEMAOWNER = AddExtraTeam("Cinema Owner", {
	color = Color(0, 171, 169, 255),
	model = "models/player/magnusson.mdl",
	description = [[Cinema Owner is able to play media using a projector.]],
	weapons = {},
	command = "cinemaowner",
	max = 1,
	salary = 90,
	admin = 0,
	vote = false,
	hasLicense = false,
	candemote = false,
	mayorCanSetSalary = true
})

AddEntity("Radio", {
	ent = "wyozi_screen_radio",
	model = "models/props_lab/citizenradio.mdl",
	price = 800,
	max = 1,
	cmd = "/buyradio",
	allowed = {TEAM_DJ}
})

AddEntity("Disco Ball", {
	ent = "wyozi_discoball",
	model = "models/XQM/Rails/gumball_1.mdl",
	price = 400,
	max = 1,
	cmd = "/buydiscoball",
	allowed = {TEAM_DJ}
})*/