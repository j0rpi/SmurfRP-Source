/*---------------------------------------------------------------------------
DarkRP custom entities
---------------------------------------------------------------------------

This file contains your custom entities.
This file should also contain entities from DarkRP that you edited.

Note: If you want to edit a default DarkRP entity, first disable it in darkrp_config/disabled_defaults.lua
	Once you've done that, copy and paste the entity to this file and edit it.

The default entities can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/addentities.lua#L111

Add entities under the following line:
---------------------------------------------------------------------------*/

AddEntity("Bronze Money Printer", {
	ent = "rprint_bronzeprinter",
	model = "models/props_c17/consolebox01a.mdl",
	price = 1000,
	max = 2,
	cmd = "/buybronzep"
})

AddEntity("Silver Money Printer", {
	ent = "rprint_silverprinter",
	model = "models/props_c17/consolebox01a.mdl",
	price = 4500,
	max = 2,
	cmd = "/buysilverp"
})

AddEntity("Gold Money Printer", {
	ent = "rprint_goldprinter",
	model = "models/props_c17/consolebox01a.mdl",
	price = 9000,
	max = 2,
	cmd = "buygoldp"
})

AddEntity("Platinum Money Printer", {
	ent = "rprint_platinum",
	model = "models/props_c17/consolebox01a.mdl",
	price = 15000,
	max = 2,
	cmd = "buyplatinump"
})

AddEntity("Leet Money Printer", {
	ent = "rprint_leet",
	model = "models/props_c17/consolebox01a.mdl",
	price = 25000,
	max = 2,
	cmd = "/buyleetp"
})


DarkRP.createEntity("Aspirin", {
	ent = "durgz_aspirin",
	model = "models/jaanus/aspbtl.mdl",
	price = 750,
	max = 5,
	cmd = "apsirin",
	allowed = TEAM_DRUGDEALER
})

DarkRP.createEntity("Cannabis", {
	ent = "durgz_weed",
	model = "models/katharsmodels/contraband/zak_wiet/zak_wiet.mdl",
	price = 1300,
	max = 5,
	cmd = "cannabis",
	allowed = TEAM_DRUGDEALER
})

DarkRP.createEntity("Cigarettes", {
	ent = "durgz_cigarette",
	model = "models/boxopencigshib.mdl",
	price = 800,
	max = 5,
	cmd = "cigarettes",
	allowed = TEAM_DRUGDEALER
})

DarkRP.createEntity("Heroin", {
	ent = "durgz_heroine",
	model = "models/katharsmodels/syringe_out/syringe_out.mdl",
	price = 2900,
	max = 5,
	cmd = "heroin",
	allowed = TEAM_DRUGDEALER
})

DarkRP.createEntity("LSD", {
	ent = "durgz_lsd",
	model = "models/smile/smile.mdl",
	price = 2500,
	max = 5,
	cmd = "lsd",
	allowed = TEAM_DRUGDEALER
})

DarkRP.createEntity("Ammo Dispenser", {
	ent = "ammodispenser",
	model = "models/props/cs_office/Vending_machine.mdl",
	price = 0,
	max = 10,
	cmd = "buyammodispenser",
	allowed = TEAM_ADMIN
})

DarkRP.createEntity("Cigarettes", {
	ent = "durgz_cigarette",
	model = "models/boxopencigshib.mdl",
	price = 800,
	max = 5,
	cmd = "ciggz",
	allowed = TEAM_BARTENDER
})

DarkRP.createEntity("Water", {
	ent = "durgz_water",
	model = "models/drug_mod/the_bottle_of_water.mdl",
	price = 300,
	max = 5,
	cmd = "waterz",
	allowed = TEAM_BARTENDER
})

DarkRP.createEntity("Alcohol", {
	ent = "durgz_alcohol",
	model = "models/drug_mod/alcohol_can.mdl",
	price = 500,
	max = 5,
	cmd = "alcoholzz",
	allowed = TEAM_BARTENDER
})

--DarkRP.createEntity("Donator Printer", "donator_printer", "models/props_c17/consolebox01a.mdl", 300000, 2, "/donator3moneyprinter", nil, function(ply) return ply:GetUserGroup() == "donator" or ply:GetUserGroup() == "s-donator" or ply:GetUserGroup() == "moderator" or ply:GetUserGroup() == "trialmod" or ply:GetUserGroup() == "admin" or ply:GetUserGroup() == "superadmin" or ply:GetUserGroup() == "developer" or ply:GetUserGroup() == "owner" or ply:GetUserGroup() == "co.owner" or ply:GetUserGroup() == "headadmin" end