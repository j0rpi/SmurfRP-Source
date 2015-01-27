/*---------------------------------------------------------------------------
DarkRP custom jobs
---------------------------------------------------------------------------

This file contains your custom jobs.
This file should also contain jobs from DarkRP that you edited.

Note: If you want to edit a default DarkRP job, first disable it in darkrp_config/disabled_defaults.lua
	Once you've done that, copy and paste the job to this file and edit it.

The default jobs can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/jobrelated.lua

For examples and explanation please visit this wiki page:
http://wiki.darkrp.com/index.php/DarkRP:CustomJobFields


Add jobs under the following line:
---------------------------------------------------------------------------*/

TEAM_CITIZEN = AddExtraTeam("Citizen", {
        color = Color(20, 150, 20, 255),
        model = {
                "models/player/Group01/Female_01.mdl",
                "models/player/Group01/Female_02.mdl",
                "models/player/Group01/Female_03.mdl",
                "models/player/Group01/Female_04.mdl",
                "models/player/Group01/Female_06.mdl",
                "models/player/group01/male_01.mdl",
                "models/player/Group01/Male_02.mdl",
                "models/player/Group01/male_03.mdl",
                "models/player/Group01/Male_04.mdl",
                "models/player/Group01/Male_05.mdl",
                "models/player/Group01/Male_06.mdl",
                "models/player/Group01/Male_07.mdl",
                "models/player/Group01/Male_08.mdl",
                "models/player/Group01/Male_09.mdl"
        },
        description = [[The Citizen is the most basic level of society you can hold
                besides being a hobo.
                You have no specific role in city life.]],
        weapons = {""},
        command = "citizen",
        max = 0,
        salary = 150,
        admin = 0,
        vote = false,
        hasLicense = false,
        candemote = false,
        mayorCanSetSalary = true
})
 
TEAM_POLICE = AddExtraTeam("Police Officer", {
        color = Color(25, 25, 170, 255),
        model = {"models/player/elispolice/police.mdl"},
        description = [[The protector of every citizen that lives in the city .
                You have the power to arrest criminals and protect innocents.
                Hit them with your arrest baton to put them in jail
                Bash them with a stunstick and they might learn better than to disobey
                the law.
                The Battering Ram can break down the door of a criminal with a warrant
                for his/her arrest.
                The Battering Ram can also unfreeze frozen props(if enabled).
                Type /wanted <name> to alert the public to this criminal
                OR go to tab and warrant someone by clicking the warrant button]],
        weapons = {"arrest_stick", "unarrest_stick", "weapon_mad_glock", "stunstick", "door_ram", "weaponchecker"},
        command = "cp",
        max = 7,
        salary = 300,
        admin = 0,
        vote = true,
        hasLicense = true,
        help = {
                "Please don't abuse your job",
                "When you arrest someone they are auto transported to jail.",
                "They are auto let out of jail after some time",
                "Type /warrant [Nick|SteamID|Status ID] to set a search warrant for a player.",
                "Type /wanted [Nick|SteamID|Status ID] to alert everyone to a wanted suspect",
                "Type /unwanted [Nick|SteamID|Status ID] to clear the suspect",
                "Type /jailpos to set the jail position"
        }
})
 
TEAM_FBI = AddExtraTeam("FBI Agent", {
        color = Color(25, 25, 170, 255),
        model = {"models/fbi_pack/fbi_09.mdl"},
        description = [[You protect the city from it's most harmful murderers.]],
        weapons = {"arrest_stick", "unarrest_stick", "weapon_mad_deagle", "stunstick", "door_ram", "weaponchecker"},
        command = "fbi",
        max = 5,
        salary = 400,
        admin = 0,
        vote = true,
        hasLicense = true,
})
 
TEAM_CHIEF = AddExtraTeam("Police Chief", {
        color = Color(0, 63, 255, 255),
        model = {"models/player/Combine_Soldier_PrisonGuard.mdl"},
        description = [[You are the Chief of the Police, you make sure the Police Officers and FBI Agents do their jobs.]],
        weapons = {"arrest_stick", "unarrest_stick", "weapon_mad_glock", "weapon_mad_mp5", "stunstick", "door_ram", "weaponchecker"},
        command = "policechief",
        max = 1,
        salary = 450,
        admin = 0,
        vote = true,
        hasLicense = true,
        customCheck = function(ply) return ply:GetUserGroup() == "donator" or ply:GetUserGroup() == "s-donator" or ply:GetUserGroup() == "moderator" or ply:GetUserGroup() == "trialmod" or ply:IsSuperAdmin() or ply:IsAdmin() end,
        CustomCheckFailMsg = "This job is for donators only, sorry."
})

TEAM_SWAT = AddExtraTeam("S.W.A.T", {
        color = Color(19, 77, 179, 255),
        model = {"models/player/Combine_Super_Soldier.mdl"},
        description = [[The S.W.A.T. officer, aids the police force in raids.
You DO NOT have authority over the Police Chief]],
        weapons = {"arrest_stick", "unarrest_stick", "weapon_mad_deagle", "weapon_mad_mp5", "stunstick", "door_ram", "weaponchecker", "kermite_knife_nautalis", "weapon_real_spas"},
        command = "swat",
        max = 5,
        salary = 430,
        admin = 0,
        vote = false,
        hasLicense = true,
        customCheck = function(ply) return ply:GetUserGroup() == "donator" or ply:GetUserGroup() == "s-donator" or ply:GetUserGroup() == "moderator" or ply:GetUserGroup() == "trialmod" or ply:IsSuperAdmin() or ply:IsAdmin() end,
        CustomCheckFailMsg = "This job is for donators only, sorry."
})
 
TEAM_GANG = AddExtraTeam("Gangster", {
        color = Color(75, 75, 75, 255),
        model = {
                "models/player/Group03/Female_01.mdl",
                "models/player/Group03/Female_02.mdl",
                "models/player/Group03/Female_03.mdl",
                "models/player/Group03/Female_04.mdl",
                "models/player/Group03/Female_06.mdl",
                "models/player/group03/male_01.mdl",
                "models/player/Group03/Male_02.mdl",
                "models/player/Group03/male_03.mdl",
                "models/player/Group03/Male_04.mdl",
                "models/player/Group03/Male_05.mdl",
                "models/player/Group03/Male_06.mdl",
                "models/player/Group03/Male_07.mdl",
                "models/player/Group03/Male_08.mdl",
                "models/player/Group03/Male_09.mdl"},
        description = [[The lowest person of crime.]],
        weapons = {""},
        command = "gangster",
        max = 8,
        salary = 225,
        admin = 0,
        vote = false,
        hasLicense = false,
        mayorCanSetSalary = false
})
 
TEAM_AGUN = AddExtraTeam("Arms Dealer", {
        color = Color(255, 160, 0, 255),
        model = "models/player/monk.mdl",
        description = [[You sell pistols. You may not use this job to
                 self-supply.]],
        weapons = {""},
        command = "gundealer",
        max = 4,
        salary = 280,
        admin = 0,
        vote = false,
        hasLicense = false,
        mayorCanSetSalary = true
})
 
TEAM_GUN = AddExtraTeam("Heavy Arms Dealer", {
        color = Color(255, 140, 0, 255),
        model = "models/player/monk.mdl",
        description = [[You sell Rifles, Snipers etc. You may not use this job to
                 self-supply.]],
        weapons = {""},
        command = "hgundealer",
        max = 4,
        salary = 280,
        admin = 0,
        vote = false,
        hasLicense = false,
        mayorCanSetSalary = true
})
 
TEAM_EXPLOSIVES = AddExtraTeam("Explosives Dealer", {
        color = Color(130, 140, 0, 255),
        model = "models/player/eli.mdl",
        description = [[You sell explsosives. You may not use this job to self-supply.]],
        weapons = {""},
        command = "explosivedealer",
        max = 4,
        salary = 280,
        admin = 0,
        vote = false,
        hasLicense = false,
        mayorCanSetSalary = true,
        customCheck = function(ply) return ply:GetUserGroup() == "donator" or ply:GetUserGroup() == "s-donator" or ply:GetUserGroup() == "moderator" or ply:GetUserGroup() == "trialmod" or ply:IsSuperAdmin() or ply:IsAdmin() end,
        CustomCheckFailMsg = "This job is for donators only, sorry."
})
 
TEAM_MEDIC = AddExtraTeam("Medic", {
        color = Color(47, 79, 79, 255),
        model = "models/player/kleiner.mdl",
        description = [[With your medical knowledge,
                you heal players to proper
                health.
                Without a medic, people cannot be healed.
                Left click with the Medical Kit to heal other players.
                Right click with the Medical Kit to heal yourself.]],
        weapons = {"med_kit"},
        command = "medic",
        max = 4,
        salary = 175,
        admin = 0,
        vote = false,
        hasLicense = false,
        medic = true,
        mayorCanSetSalary = true
})
 
TEAM_MAYOR = AddExtraTeam("Mayor", {
        color = Color(150, 20, 20, 255),
        model = "models/player/breen.mdl",
        description = [[The Mayor of the city creates laws to serve the greater good
        of the people.
        If you are the mayor you may create and accept warrants.
        Type /wanted <name>  to warrant a player
        Type /jailpos to set the Jail Position
        Type /lockdown initiate a lockdown of the city.
        Everyone must be inside during a lockdown.
        The cops patrol the area
        /unlockdown to end a lockdown]],
        weapons = {""},
        command = "mayor",
        max = 1,
        salary = 450,
        admin = 0,
        vote = true,
        hasLicense = false,
        mayor = true,
        help = {
                "Type /warrant [Nick|SteamID|Status ID] to set a search warrant for a player.",
                "Type /wanted [Nick|SteamID|Status ID] to alert everyone to a wanted suspect.",
                "Type /unwanted [Nick|SteamID|Status ID] to clear the suspect.",
                "Type /lockdown to initiate a lockdown",
                "Type /unlockdown to end a lockdown",
                "Type /placelaws to place a screen containing the laws.",
                "Type /addlaw and /removelaw to edit the laws."
        }
})
 
TEAM_HOBO = AddExtraTeam("Hobo", {
        color = Color(80, 45, 0, 255),
        model = "models/player/corpse1.mdl",
        description = [[The lowest member of society. All people see you laugh.
                You have no home.
                Beg for your food and money
                Sing for everyone who passes to get money
                Make your own wooden home somewhere in a corner or
                outside someone else's door]],
        weapons = {""},
        command = "hobo",
        max = 9,
        salary = 0,
        admin = 0,
        vote = false,
        hasLicense = false,
        candemote = false,
        hobo = true,
        mayorCanSetSalary = false
})
 
//ADD CUSTOM TEAMS UNDER THIS LINE:
 
 
TEAM_HITMAN = AddExtraTeam("Assassin", {
    color = Color(255, 0, 0, 255),
    model = "models/agent_47.mdl",
        description = [[Your job is to complete hits ordered by other players.
              After eliminating the player you have been ordered to kill, you
                  MUST notify everyone in OOC that you completed the hit.]],
                  weapons = {"weapon_mad_awp", "kermite_knife_hibben"},
                  command = "hitman",
                  max = 1,
                  salary = 275,
                  admin = 0,
                  vote = true,
                  hasLicense = true,
                  help = {
                "To accept hits placed by players, type !hitmenu.",
                "Remember: You are not allowed to kill anyone unless",
                "it's a hit you've accepted.",
        }
})
 
TEAM_ADMIN = AddExtraTeam("Admin on Duty", {
    color = Color(114, 149, 0, 255),
    model = "models/player/Police.mdl",
        description = [[Staff Only]],
                  weapons = {"weapon_keypadchecker", "unarrest_stick", "arrest_stick", "stunstick", "weaponchecker"},
                  command = "adminonduty",
                  max = 10,
                  salary = 0,
                  admin = 1,
                  vote = false,
                  customCheck = function(ply) return ply:GetUserGroup() == "moderator" or ply:GetUserGroup() == "trialmod" or ply:IsSuperAdmin() or ply:IsAdmin() end,
                  hasLicense = true  
})
 
 
TEAM_BLACKMARKET = AddExtraTeam("Black Market Dealer", {
    color = Color(0, 0, 0, 255),
        model = "models/player/arctic.mdl",
        description = [[You sell tools which comes in handy for thiefs.]],
                  weapons = {""},
                  command = "blackmarket",
              max = 4,
                  salary = 280,
                  admin = 0,
                  vote = false,
                  hasLicense = false
})
 
TEAM_GUARD = AddExtraTeam("Bodyguard", {
        color = Color(0, 0, 0, 255),
        model = {"models/player/smith.mdl"},
        description = [[You're job is to protect your paying client.]],
        weapons = {"weapon_mad_usp", "stunstick", "weaponchecker"},
        command = "bodyguard",
        max = 6,
        salary = 300,
        admin = 0,
        vote = false,
        hasLicense = true
})
 
TEAM_DRUGDEALER = AddExtraTeam("Drug Dealer", {
    color = Color(255, 140, 0, 255),
        model = "models/player/odessa.mdl",
        description = [[You are a drugdealer. You supply the junkies with drugs.]],
                  weapons = {""},
                  command = "drugdealer",
              max = 4,
                  salary = 200,
                  admin = 0,
                  vote = false,
                  hasLicense = false,
        customCheck = function(ply) return ply:GetUserGroup() == "donator" or ply:GetUserGroup() == "s-donator" or ply:GetUserGroup() == "moderator" or ply:GetUserGroup() == "trialmod" or ply:IsSuperAdmin() or ply:IsAdmin() end,
        CustomCheckFailMsg = "This job is for donators only, sorry."
})
 
TEAM_THIEF = AddExtraTeam("Thief", {
    color = Color(0, 170, 255, 255),
        model = "models/player/phoenix.mdl",
        description = [[You are a standard pathetic thief.]],
                  weapons = {"lockpick"},
                  command = "thief",
              max = 5,
                  salary = 125,
                  admin = 0,
                  vote = false,
                  hasLicense = false
})
 
TEAM_PROTHIEF = AddExtraTeam("Professional Thief", {
    color = Color(70, 140, 100, 255),
        model = "models/player/leet.mdl",
        description = [[You are a professional thief. You are more advanced than the standard thief.]],
                  weapons = {"lockpick", "keypad_cracker"},
                  command = "prothief",
              max = 5,
                  salary = 150,
                  admin = 0,
                  vote = false,
                  hasLicense = false,
                  customCheck = function(ply) return ply:GetUserGroup() == "donator" or ply:GetUserGroup() == "s-donator" or ply:GetUserGroup() == "moderator" or ply:GetUserGroup() == "trialmod" or ply:IsSuperAdmin() or ply:IsAdmin() end,
                  CustomCheckFailMsg = "This job is for donators only, sorry."
})
 
TEAM_FREERUNNER = AddExtraTeam("Free Runner", {
    color = Color(100, 140, 50, 255),
        model = "models/player/vin_diesel/slow.mdl",
        description = [[You are a free runner. You can climb high buildings etc.]],
                  weapons = {"climb_swep2"},
                  command = "freerunner",
              max = 4,
                  salary = 100,
                  admin = 0,
                  vote = false,
                  hasLicense = false,
                  customCheck = function(ply) return ply:GetUserGroup() == "donator" or ply:GetUserGroup() == "s-donator" or ply:GetUserGroup() == "moderator" or ply:GetUserGroup() == "trialmod" or ply:GetUserGroup() == "vip+" or ply:IsSuperAdmin() or ply:IsAdmin() end,
                  CustomCheckFailMsg = "This job is for donators only, sorry."
})
 
TEAM_HOTEL = AddExtraTeam("Hotel Manager", {
    color = Color(0, 0, 150, 255),
        model = "models/player/gman_high.mdl",
        description = [[You manage hotels. You can own a building and rent rooms out.]],
                  weapons = {""},
                  command = "hotelmanager",
              max = 1,
                  salary = 100,
                  admin = 0,
                  vote = false,
                  hasLicense = false
})
 
TEAM_BANKER = AddExtraTeam("Banker", {
        color = Color(56, 26, 89, 255),
        model = {"models/player/Group02/male_02.mdl"},
        description = [[You are a banker, store other players money printers legally.]],
        weapons = {""},
        command = "banker",
        max = 1,
        salary = 200,
        admin = 0,
        vote = true,
        hasLicense = true
})
 
TEAM_CINEMAMANAGER = AddExtraTeam("Cinema Manager", {
                color = Color(45, 161, 155, 255),
                model = "models/player/magnusson.mdl",
                description = [[Cinema Manager is able to play media using a projector.]],
                weapons = {""},
                command = "cinemamanager",
                max = 1,
                salary = 100,
                admin = 0,
                vote = true,
                hasLicense = false,
                candemote = true,
                mayorCanSetSalary = false
})
 
TEAM_STALKER = AddExtraTeam("Shadow Stalker", {
                color = Color(80, 45, 0, 255),
                model = "models/player/soldier_stripped.mdl",
                description = [[You're a stalker, you go around and follow people around.. Hopefully they won't notice you.. You are obsessed with people afterall.]],
                weapons = {"kermite_knife_balisong"},
                command = "stalker",
                max = 4,
                salary = 200,
                admin = 0,
                vote = false,
                hasLicense = false,
                candemote = true,
                mayorCanSetSalary = false,
                customCheck = function(ply) return ply:GetUserGroup() == "donator" or ply:GetUserGroup() == "s-donator" or ply:GetUserGroup() == "moderator" or ply:GetUserGroup() == "trialmod" or ply:IsSuperAdmin() or ply:IsAdmin() end,
                CustomCheckFailMsg = "This job is for donators only, sorry."
})
 
TEAM_BARTENDER = AddExtraTeam("Bartender", {
        color = Color(127, 0, 95, 255),
        model = "models/player/Group02/male_02.mdl",
        description = [[You create a relaxing place, you get drinks to your costumers and relax them... Make them forget the outdoor trouble.]],
                  weapons = {""},
                  command = "bartender",
                  max = 2,
                  salary = 220,
                  admin = 0,
                  vote = false,
                  hasLicense = false
 
})







/*---------------------------------------------------------------------------
Define which team joining players spawn into and what team you change to if demoted
---------------------------------------------------------------------------*/
GAMEMODE.DefaultTeam = TEAM_CITIZEN


/*---------------------------------------------------------------------------
Define which teams belong to civil protection
Civil protection can set warrants, make people wanted and do some other police related things
---------------------------------------------------------------------------*/
GAMEMODE.CivilProtection = {
	[TEAM_POLICE] = true,
	[TEAM_CHIEF] = true,
	[TEAM_MAYOR] = true,
}

/*---------------------------------------------------------------------------
Jobs that are hitmen (enables the hitman menu)
---------------------------------------------------------------------------*/
DarkRP.addHitmanTeam(TEAM_HITMAN)
