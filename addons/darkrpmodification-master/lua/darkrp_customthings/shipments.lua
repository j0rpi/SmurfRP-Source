/*---------------------------------------------------------------------------
DarkRP custom shipments and guns
---------------------------------------------------------------------------

This file contains your custom shipments and guns.
This file should also contain shipments and guns from DarkRP that you edited.

Note: If you want to edit a default DarkRP shipment, first disable it in darkrp_config/disabled_defaults.lua
	Once you've done that, copy and paste the shipment to this file and edit it.

The default shipments and guns can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/addentities.lua

For examples and explanation please visit this wiki page:
http://wiki.darkrp.com/index.php/DarkRP:CustomShipmentFields


Add shipments and guns under the following line:
---------------------------------------------------------------------------*/
DarkRP.createShipment("Desert eagle", {
	model = "models/weapons/w_pist_deagle.mdl",
	entity = "weapon_real_cs_desert_eagle",
	price = 4800,
	amount = 10,
	seperate = false,
	pricesep = nil,
	noship = false,
	allowed = {TEAM_AGUN}
})

DarkRP.createShipment("Fiveseven", {
	model = "models/weapons/w_pist_fiveseven.mdl",
	entity = "weapon_real_cs_five-seven",
	price = 3600,
	amount = 10,
	seperate = false,
	pricesep = nil,
	noship = false,
	allowed = {TEAM_AGUN}
})

DarkRP.createShipment("Glock", {
	model = "models/weapons/w_pist_glock18.mdl",
	entity = "weapon_real_cs_glock18",
	price = 2400,
	amount = 10,
	seperate = false,
	pricesep = nil,
	noship = false,
	allowed = {TEAM_AGUN}
})

DarkRP.createShipment("P228", {
	model = "models/weapons/w_pist_p228.mdl",
	entity = "weapon_real_cs_p228",
	price = 3000,
	amount = 10,
	seperate = false,
	pricesep = nil,
	noship = false,
	allowed = {TEAM_AGUN}
})

DarkRP.createShipment("USP", {
	model = "models/weapons/w_pist_usp.mdl",
	entity = "weapon_real_cs_usp",
	price = 3000,
	amount = 10,
	seperate = false,
	pricesep = nil,
	noship = false,
	allowed = {TEAM_AGUN}
})

DarkRP.createShipment("Dual Elite", {
	model = "models/weapons/w_pist_elite.mdl",
	entity = "weapon_real_cs_elites",
	price = 4950,
	amount = 10,
	seperate = false,
	pricesep = nil,
	noship = false,
	allowed = {TEAM_AGUN}
})

DarkRP.createShipment("AK47", {
	model = "models/weapons/w_rif_ak47.mdl",
	entity = "weapon_real_cs_ak47",
	price = 14700,
	amount = 10,
	seperate = false,
	pricesep = nil,
	noship = false,
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("Famas", {
	model = "models/weapons/w_rif_famas.mdl",
	entity = "weapon_real_cs_famas",
	price = 12900,
	amount = 10,
	seperate = false,
	pricesep = nil,
	noship = false,
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("MP5", {
	model = "models/weapons/w_smg_mp5.mdl",
	entity = "weapon_real_cs_mp5",
	price = 13200,
	amount = 10,
	seperate = false,
	pricesep = nil,
	noship = false,
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("M4", {
	model = "models/weapons/w_rif_m4a1.mdl",
	entity = "weapon_real_cs_m4",
	price = 14700,
	amount = 10,
	seperate = false,
	pricesep = nil,
	noship = false,
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("AUG", {
	model = "models/weapons/w_rif_aug.mdl",
	entity = "weapon_real_cs_aug",
	price = 17100,
	amount = 10,
	seperate = false,
	pricesep = nil,
	noship = false,
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("P90", {
	model = "models/weapons/w_smg_p90.mdl",
	entity = "weapon_real_cs_p90",
	price = 14700,
	amount = 10,
	seperate = false,
	pricesep = nil,
	noship = false,
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("Mac 10", {
	model = "models/weapons/w_smg_mac10.mdl",
	entity = "weapon_real_cs_mac10",
	price = 12900,
	amount = 10,
	seperate = false,
	pricesep = nil,
	noship = false,
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("Pump shotgun", {
	model = "models/weapons/w_shot_m3super90.mdl",
	entity = "weapon_real_cs_pumpshotgun",
	price = 10500,
	amount = 10,
	seperate = false,
	pricesep = nil,
	noship = false,
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("G3SG1 Sniper Rifle", {
	model = "models/weapons/w_snip_g3sg1.mdl",
	entity = "weapon_real_cs_g3sg1",
	price = 22500,
	amount = 10,
	seperate = false,
	pricesep = nil,
	noship = false,
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("AWP Sniper Rifle", {
	model = "models/weapons/w_snip_awp.mdl",
	entity = "weapon_real_cs_awp",
	price = 27000,
	amount = 10,
	seperate = false,
	pricesep = nil,
	noship = false,
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("M249 Para", {
	model = "models/weapons/w_mach_m249para.mdl",
	entity = "weapon_real_cs_m249",
	price = 27000,
	amount = 10,
	seperate = false,
	pricesep = nil,
	noship = false,
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("STEYR TMP", {
	model = "models/weapons/w_smg_tmp.mdl",
	entity = "weapon_real_cs_tmp",
	price = 12900,
	amount = 10,
	seperate = false,
	pricesep = nil,
	noship = false,
	allowed = {TEAM_GUN}
})


DarkRP.createShipment("SLAM Mine", {
	model = "models/weapons/w_slam.mdl",
	entity = "weapon_slam",
	price = 24000,
	amount = 10,
	seperate = false,
	pricesep = nil,
	noship = false,
	allowed = {TEAM_EXPLOSIVES}
})

DarkRP.createShipment("High Explosive Grenade", {
	model = "models/weapons/w_eq_fraggrenade_thrown.mdl",
	entity = "weapon_real_cs_grenade",
	price = 31050,
	amount = 5,
	seperate = false,
	pricesep = nil,
	noship = false,
	allowed = {TEAM_EXPLOSIVES}
})

DarkRP.createShipment("Flashbang Grenade", {
	model = "models/weapons/w_eq_flashbang_thrown.mdl",
	entity = "weapon_real_cs_flash",
	price = 24000,
	amount = 5,
	seperate = false,
	pricesep = nil,
	noship = false,
	allowed = {TEAM_EXPLOSIVES}
})

DarkRP.createEntity("Drug lab", {
	ent = "drug_lab",
	model = "models/props_lab/crematorcase.mdl",
	price = 400,
	max = 3,
	cmd = "/buydruglab",
	allowed = {TEAM_GANG, TEAM_MOB}
})


DarkRP.createEntity("Gun lab", {
	ent = "gunlab",
	model = "models/props_c17/TrapPropeller_Engine.mdl",
	price = 500,
	max = 1,
	cmd = "/buygunlab",
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("Keypad Cracker Shipment", {
	entity = "keypad_cracker",
	model = "models/weapons/w_c4_planted.mdl",
	price = 1000,
	amount = 10,
	seperate = false,
	pricesep = nil,
	noship = false,
	allowed = {TEAM_BLACKMARKET}
})

DarkRP.createShipment("Lockpick Shipment", {
	entity = "lockpick",
	model = "models/weapons/w_crowbar.mdl",
	price = 700,
	amount = 10,
	seperate = false,
	pricesep = nil,
	noship = false,
	allowed = {TEAM_BLACKMARKET}
})

DarkRP.createShipment("Knife", {
	entity = "kermite_knife_tanto",
	model = "models/weapons/w_knife_f.mdl",
	price = 5000,
	amount = 3,
	seperate = false,
	pricesep = nil,
	noship = false,
	allowed = {TEAM_BLACKMARKET}
})

DarkRP.createShipment("Aspirin Shipment", {
        entity = "durgz_aspirin",
	    model = "models/jaanus/aspbtl.mdl",
	    price = 7500,
        amount = 10,
        seperate = false,
        pricesep = nil,
        noship = false,
        allowed = {TEAM_DRUGDEALER}
})

DarkRP.createShipment("Cannabis Shipment", {
        entity = "durgz_weed",
	    model = "models/katharsmodels/contraband/zak_wiet/zak_wiet.mdl",
	    price = 13000,
        amount = 10,
        seperate = false,
        pricesep = nil,
        noship = false,
        allowed = {TEAM_DRUGDEALER}
})

DarkRP.createShipment("Cigarette Shipment", {
        entity = "durgz_cigarette",
	model = "models/boxopencigshib.mdl",
	price = 8000,
        amount = 10,
        seperate = false,
        pricesep = nil,
        noship = false,
        allowed = {TEAM_DRUGDEALER}
})


DarkRP.createShipment("Heroin Shipment", {
        entity = "durgz_heroine",
	model = "models/katharsmodels/syringe_out/syringe_out.mdl",
	price = 32000,
        amount = 10,
        seperate = false,
        pricesep = nil,
        noship = false,
        allowed = {TEAM_DRUGDEALER}
})

DarkRP.createShipment("LSD Shipment", {
        entity = "durgz_lsd",
	model = "models/smile/smile.mdl",
	price = 28000,
        amount = 10,
        seperate = false,
        pricesep = nil,
        noship = false,
        allowed = {TEAM_DRUGDEALER}
})