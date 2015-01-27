
timer.Simple( 1, function() // No idea why, it just needs it for it to work!
	-- Configuration, you can touch this.
	local config = {
		-- What team to revert the mayor to when they die.
			mayorRevert = TEAM_CITIZEN,
		-- The team of mayor, if you changed it in the DarkRP jobs.
			mayorTeam = TEAM_MAYOR,
		-- Demote the Mayor when they die, true for yes, and false for no.
			mayorDeathDemote = true,
		-- The message displayed when the Mayor has been killed.
			mayorDeathMessage = "The Mayor has been killed!",
		-- Take money from government's bank for paydays, true for yes, and false for no.
			payFromBank = true,
		-- What percentage does the economy start on, from 0 to 100.
			startingEconomy = 50,
		-- How much money the government begins with.
			startingMoney = 10000,
		-- How many minutes the Mayor is given a chance to have an opportunity.
			opportunityTime = 5,
		-- What is the chance the Mayor is given an opportunity when the time above comes; 100 for always.
			opportunityChance = 100,
		-- Either draw the economy HUD on the top or bottom of the screen.
			hudPosition = "top",
		-- You can make the economy HUD as wide and tall as you want.
			hudTall = 20,
			hudWide = 250,
		-- How much of a tax all jobs start with, from 0 to 100.
			startingTax = 10,
		-- How long should perks last for when bought, in minutes.
			perkTime = 60,
		-- Put all of the jobs that can be taxed here.
			JobTaxes = {
				TEAM_CITIZEN,
				TEAM_MEDIC,
				TEAM_GUN,
				TEAM_POLICE,
				TEAM_CHIEF,
			},
		-- Prices for buying government perks, don't add or remove, just configure.
			GovernmentPerks = {
				{ name = "Government Training", info = "Improve leg strength to run faster and jump higher.", price = 2500 },
				{ name = "Made of Stone", info = "Improve durability to take less damage.", price = 2500 },
				{ name = "Primary Weaponry", info = "Add an arsonal of primary weapons.", price = 5000 },
				{ name = "Protective Gear", info = "Allow body armor to protect bodies.", price = 2500 },
			},
		-- Minimum economy levels for the government perks.
			EconomyLevels = {
				legStrength = 25,
				damageResistance = 25,
				armor = 50,
				primaries = 75,
			},
		-- Translate weapon classes into names, for custom weapons you should replace this.
			WeaponTranslations = {
				{ class = "weapon_ak472", name = "AK-47" },
				{ class = "weapon_deagle2", name = "Deagle" },
				{ class = "weapon_glock2", name = "Glock" },
				{ class = "weapon_m42", name = "M4" },
				{ class = "weapon_mp5", name = "MP5" },
				{ class = "weapon_pumpshotgun2", name = "Pump Shotgun" },
				{ class = "weapon_p2282", name = "P228" },
				{ class = "weapon_mac102", name = "Mac 10" },
				{ class = "weapon_fiveseven2", name = "Five Seven" },
				
			},
		-- Put all government jobs and their loadout information here.
			JobWeapons = {
					-- One selection point buys 5% armor, the armor variable is the max armor they can have.
					-- One selection point for leg strength will result in 5 more speed and 2 more jump power.
					-- If perk #3 is bought, you can choose primary weapons, the max is how many they can select.
					-- Max secondary is how many secondary weapons they can choose.
					-- Selection points is how many points they have to use in the loadout screen.
					-- List their primary and secondary weapons, too.
					
					{ job = TEAM_POLICE, legStrength = 50, damageResistance = 25, armor = 50, selectionPoints = 10, maxPrimary = 1, maxSecondary = 1, primaries = { "weapon_pumpshotgun2" }, secondaries = { "weapon_glock2", "weapon_p2282", "weapon_fiveseven2" } },
					{ job = TEAM_CHIEF, legStrength = 50, damageResistance = 50, armor = 100, selectionPoints = 15, maxPrimary = 1, maxSecondary = 1, primaries = { "weapon_pumpshotgun2", "weapon_m42" }, secondaries = { "weapon_glock2", "weapon_deagle2", "weapon_p2282", "weapon_fiveseven2" } },
			},
		-- Put all opportunities the Mayor gets here, don't edit unless you have an idea of what to do.
			Opportunities = {
				{
					title = "New Lot",
					info = "There's a new lot open that is ready to be built on, but you have to make a descision of what to build on it. If you build something that entertains the community, then you are most likely to make money. The community is mostly occupied by middle class men.",
					question = "What do you build?",
					economy = 10,
					failchance = 15,
					successmoney = 4000,
					faileconomy = 5,
					failmoney = 1000,
					options = {
						{ option = "Strip Mall", correct = true },
						{ option = "Wallmart", correct = false },
						{ option = "Strip Club", correct = true },
						{ option = "Gas Station", correct = false },
				}},
				{
					title = "New Lot",
					info = "There's a new lot open, the community is requesting a community building. This means you won't make profit, unless you can tax people in result of the building.",
					question = "What do you build?",
					economy = 15,
					failchance = 5,
					successmoney = 4000,
					faileconomy = 5,
					failmoney = 1000,
					options = {
						{ option = "Park", correct = false },
						{ option = "Middle School", correct = true },
				}},
				{
					title = "A Less Than Legal Offer",
					info = "A gang has asked you to do some shady business with them, it involves drugs and money printers. If you accept, you could make money, but if you get caught you'll ruin your political career. This could lead to loss of money.",
					question = "What do you do?",
					economy = 20,
					failchance = 0,
					successmoney = 0,
					faileconomy = 20,
					failmoney = 3000,
					options = {
						{ option = "Accept Offer", correct = false },
						{ option = "Deny Offer", correct = true },
						{ option = "Have Them Arrested", correct = true },
				}},
				{
					title = "Stressful Ladies",
					info = "You hear a lot of talk that the women are getting stressed out, and they have nothing to do that'll calm their nerves. This is a great opportunity to make some money, all you have to do is build the right building.",
					question = "What do you build?",
					economy = 5,
					failchance = 15,
					successmoney = 4000,
					faileconomy = 5,
					failmoney = 1000,
					options = {
						{ option = "Comic Store", correct = false },
						{ option = "Bar", correct = false },
						{ option = "Spa", correct = true },
						{ option = "Strip Club", correct = false },
				}},
				{
					title = "Terrorists",
					info = "There have been some terrorits in the community, the things they're doing is costing the government money. If you don't do anything, the terrorits could cause you a fortune, in addition, the economy would fail along with it.",
					question = "What action do you take?",
					economy = 10,
					failchance = 1,
					successmoney = 0,
					faileconomy = 20,
					failmoney = 10000,
					options = {
						{ option = "Do Nothing", correct = false },
						{ option = "Nuke Their Hideout", correct = false },
						{ option = "Send In SWAT", correct = true },
				}},
				{
					title = "Education",
					info = "The community is turning into morons because there aren't enough schools. If the community continues to receive uneducated people, there won't be anyone to work. The economy flow will suffer.",
					question = "What action do you take?",
					economy = 10,
					failchance = 0,
					successmoney = 5000,
					faileconomy = 15,
					failmoney = 5000,
					options = {
						{ option = "Ignore It", correct = false },
						{ option = "Influence Independent Studying", correct = false },
						{ option = "Build Schools", correct = true },
				}},
				{
					title = "Too Much Unemployed",
					info = "People are losing jobs, and too fast. At this rate the economy will crash, you need to take action or else you'll loose money and the economy will drop.",
					question = "What action do you take?",
					economy = 5,
					failchance = 0,
					successmoney = 5000,
					faileconomy = 20,
					failmoney = 10000,
					options = {
						{ option = "Lower Taxes", correct = true },
						{ option = "Don't Take Action", correct = false },
						{ option = "Build Hospitals", correct = false },
				}},
				{
					title = "My Car!",
					info = "Crime rates are high, if you don't do something soon, the government will end up spending all of its money on city damage repair.",
					question = "What action do you take?",
					economy = 5,
					failchance = 0,
					successmoney = 0,
					faileconomy = 20,
					failmoney = 3000,
					options = {
						{ option = "Send In SWAT", correct = true },
						{ option = "Don't Take Action", correct = false },
						{ option = "Hunt Them Down Yourself", correct = false },
				}},
			},
	}

	-- Now, don't touch anything else!

	local Taxes = {}
	for k, v in pairs( config.JobTaxes ) do
		table.insert( Taxes, { job = v, tax = config.startingTax } )
	end

	local Perks = {}
	local CurrentOpportunity
	local GovernmentBank = config.startingMoney
	local Economy = config.startingEconomy

	if SERVER then
		util.AddNetworkString( "SyncEconomy" )
		util.AddNetworkString( "EconomyMenu" )
		util.AddNetworkString( "LoadoutMenu" )
		util.AddNetworkString( "UpdateTaxes" )
		util.AddNetworkString( "BuyPerk" )
		util.AddNetworkString( "ChooseLoadout" )
		util.AddNetworkString( "GiveOpportunity" )
		util.AddNetworkString( "TakeOpportunity" )
		
		net.Receive( "TakeOpportunity", function( len, ply )
			if ply:Team() != config.mayorTeam then return end
			
			local option = net.ReadString()
			if !CurrentOpportunity then return end
			
			for k, v in pairs( config.Opportunities ) do
				if v.title == CurrentOpportunity then
					for k, answer in pairs( v.options ) do
						if answer.option == option then
							CurrentOpportunity = nil
							
							if answer.correct then
								if v.failchance >= math.random( 1, 100 ) then
									DarkRP.notifyAll( 0, 5, "The Mayor made a good decision, but luck wasn't with him, the economy has fallen! (-"..v.faileconomy.."%)" )
									Economy = math.Clamp( Economy - v.faileconomy, 0, 100 )
									GovernmentBank = math.Clamp( GovernmentBank - v.failmoney, 0, GovernmentBank )
								else
									DarkRP.notifyAll( 0, 5, "The mayor made a good decision! (+"..v.economy.."%)" )
									Economy = math.Clamp( Economy + v.economy, 0, 100 )
									GovernmentBank = GovernmentBank + v.successmoney
								end
							else
								DarkRP.notifyAll( 0, 5, "The Mayor made a bad decision, the economy has fallen! (-"..v.faileconomy.."%)" )
								Economy = math.Clamp( Economy - v.faileconomy, 0, 100 )
								GovernmentBank = math.Clamp( GovernmentBank - v.failmoney, 0, GovernmentBank )
							end
						end
					end
				end
			end
			
			net.Start( "SyncEconomy" )
				net.WriteFloat( Economy )
				net.WriteFloat( GovernmentBank )
				net.WriteTable( Taxes )
				net.WriteTable( Perks )
			net.Broadcast()
		end)
		
		net.Receive( "UpdateTaxes", function( len, ply )
			if ply:Team() != config.mayorTeam then return end
			
			local taxes = net.ReadTable()
			
			if ply.NextSet and ply.NextSet >= CurTime() then DarkRP.notify( ply, 1, 5, "Wait "..math.Round(ply.NextSet-CurTime()).." more seconds before changing taxes again!" ) return end
			ply.NextSet = CurTime() + 30
			
			for k, v in pairs( Taxes ) do
				if v.tax != math.Clamp( math.Round(taxes[k]), 0, 100 ) then
					v.tax = math.Clamp( math.Round(taxes[k]), 0, 100 )
					DarkRP.notifyAll( 0, 5, "The Mayor has set the taxes for "..team.GetName(v.job).." to "..v.tax.."%!" )
				end
			end
			
			net.Start( "SyncEconomy" )
				net.WriteFloat( Economy )
				net.WriteFloat( GovernmentBank )
				net.WriteTable( Taxes )
				net.WriteTable( Perks )
			net.Broadcast()
		end)
		
		net.Receive( "BuyPerk", function( len, ply )
			if ply:Team() != config.mayorTeam then return end
			
			local buying = net.ReadString()
			local perk
			for k, v in pairs( config.GovernmentPerks ) do
				if v.name == buying then
					perk = v
				end
			end
			
			if !perk then return end
			
			if GovernmentBank < perk.price then return end
			
			for k, v in pairs( Perks ) do
				if v.name == perk.name then
					return
				end
			end
			
			table.insert( Perks, { name = perk.name } )
			GovernmentBank = math.floor( GovernmentBank - perk.price )
			DarkRP.notifyAll( 0, 5, "The Mayor has bought the perk "..perk.name.."!" )
			
			timer.Simple( 60*config.perkTime, function()
				DarkRP.notifyAll( 0, 5, "The perk "..perk.name.." has expired!" )
				
				for k, v in pairs( Perks ) do
					if v.name == perk.name then
						table.remove( Perks, k )
					end
				end
				
				net.Start( "SyncEconomy" )
					net.WriteFloat( Economy )
					net.WriteFloat( GovernmentBank )
					net.WriteTable( Taxes )
					net.WriteTable( Perks )
				net.Broadcast()
			end)
			
			net.Start( "SyncEconomy" )
				net.WriteFloat( Economy )
				net.WriteFloat( GovernmentBank )
				net.WriteTable( Taxes )
				net.WriteTable( Perks )
			net.Broadcast()
		end)
		
		net.Receive( "ChooseLoadout", function( len, ply )
			if ply.HasChoseTeam then return end
			ply.HasChoseTeam = true
			ply:Freeze(false)
			
			local primary = net.ReadTable()
			local secondary = net.ReadTable()
			
			local legstrength = net.ReadFloat()
			local damageresistance = net.ReadFloat()
			local armor = net.ReadFloat()
			
			local perks = {}
			
			for k, v in pairs( config.GovernmentPerks ) do
				perks[k] = false
				for key, perk in pairs( Perks ) do
					if perk.name == v.name then
						perks[k] = true
					end
				end
			end
			
			local maxlegstrength
			local maxdamageresistance
			local maxarmor
			
			for k, v in pairs( config.JobWeapons ) do
				if v.job == ply:Team() then
					if #primary > v.maxPrimary then return end
					if #secondary > v.maxSecondary then return end
					
					maxlegstrength = v.legStrength
					maxdamageresistance = v.damageResistance
					maxarmor = v.armor
					
					if perks[3] then
						for k, wep in pairs( primary ) do
							if table.HasValue( v.primaries, wep ) then
								ply:Give( wep )
							end
						end
					end
					
					for k, wep in pairs( secondary ) do
						if table.HasValue( v.secondaries, wep ) then
							ply:Give( wep )
						end
					end
				end
			end
			
			if perks[4] then
				ply:SetArmor( math.Clamp( 5*armor, 0, 5*maxarmor ) )
			end
			
			if perks[2] then
				ply.DamageResistance = math.Clamp( 5*damageresistance, 0, 5*damageresistance )
			end
			
			if perks[1] then
				ply:SetJumpPower( math.Clamp( ply:GetJumpPower() + 2*legstrength, 0, ply:GetJumpPower() + 2*legstrength ) )
				ply:SetRunSpeed( math.Clamp( ply:GetRunSpeed() + 5*legstrength, 0, ply:GetRunSpeed() + 5*legstrength ) )
			end
		end)
		
		hook.Add( "ScalePlayerDamage", "DarkRP_Economy", function( ply, hitgroup, dmginfo )
			local resistance = 1.5
			if ply.DamageResistance then
				resistance = resistance - ply.DamageResistance*0.01
			end
			
			if hitgroup == HITGROUP_HEAD then
				dmginfo:ScaleDamage( resistance + 0.5 )
			else
				dmginfo:ScaleDamage( resistance )
			end
		end)
		
		hook.Add( "PlayerDeath", "DarkRP_Economy", function( ply )
			ply:Freeze(false)
			
			if ply:Team() == config.mayorTeam and config.mayorDeathDemote then
				ply:changeTeam( config.mayorRevert, true )
				DarkRP.notifyAll( 0, 4, config.mayorDeathMessage )
			end
		end)
		
		hook.Add( "ShowTeam", "DarkRP_Economy", function( ply )
			if ply:Team() == config.mayorTeam then
				local trace = ply:GetEyeTrace().Entity
				
				if !IsValid(trace) then
					net.Start( "EconomyMenu" )
					net.Send( ply )
				else
					if !trace:IsDoor() and trace:GetPos():Distance(ply:GetPos()) > 200 then
						net.Start( "EconomyMenu" )
						net.Send( ply )
					end
				end
			end
		end)
		
		hook.Add( "PlayerInitialSpawn", "DarkRP_Economy", function( ply )
			timer.Simple( 1, function()
				net.Start( "SyncEconomy" )
					net.WriteFloat( Economy )
					net.WriteFloat( GovernmentBank )
					net.WriteTable( Taxes )
					net.WriteTable( Perks )
				net.Send( ply )
			end)
		end)
		
		hook.Add( "PlayerSpawn", "DarkRP_Economy", function( ply )
			local isGov = false
			for k, v in pairs( config.JobWeapons ) do
				if v.job == ply:Team() then
					isGov = true
				end
			end
			
			if isGov then
				ply.HasChoseTeam = false
				ply:Freeze(true)
				
				net.Start( "LoadoutMenu" )
				net.Send( ply )
			end
		end)
		
		timer.Create( "DarkRP_Economy", 60*config.opportunityTime, 0, function()
			local mayor = nil
			
			for k, ply in pairs( player.GetAll() ) do
				if ply:Team() == config.mayorTeam then
					mayor = ply
				end
			end
			
			if mayor and IsValid(mayor) then
				if config.opportunityChance >= math.random(1,100) then
					local Opportunity = table.Random( config.Opportunities )
					CurrentOpportunity = Opportunity.title
					
					net.Start( "GiveOpportunity" )
						net.WriteTable( Opportunity )
					net.Send( mayor )
					
					timer.Simple( 60*config.opportunityTime/2, function()
						if CurrentOpportunity then
							CurrentOpportunity = nil
							DarkRP.notifyAll( 0, 4, "The Mayor isn't doing anything, the economy has fallen! (-5%)" )
							Economy = math.Clamp( Economy - 5, 0, 100 )
							GovernmentBank = math.Clamp( GovernmentBank - math.random(50,250), 0, GovernmentBank )
							
							net.Start( "SyncEconomy" )
								net.WriteFloat( Economy )
								net.WriteFloat( GovernmentBank )
								net.WriteTable( Taxes )
								net.WriteTable( Perks )
							net.Broadcast()
						end
					end)
				end
			else
				if Economy > 0 then
					Economy = math.Clamp( Economy - 5, 0, 100 )
					GovernmentBank = math.Clamp( GovernmentBank - math.random(50,100), 0, GovernmentBank )
					
					net.Start( "SyncEconomy" )
						net.WriteFloat( Economy )
						net.WriteFloat( GovernmentBank )
						net.WriteTable( Taxes )
						net.WriteTable( Perks )
					net.Broadcast()
					
					DarkRP.notifyAll( 1, 5, "There is no mayor, the economy has fallen! (-5%)" )
				end
			end
		end)
		
		local meta = FindMetaTable( "Player" )
		function meta:payDay()
			if not IsValid(self) then return end
			if not self:isArrested() then
				DarkRP.retrieveSalary(self, function(amount)
					if Taxes[self:Team()] then
						amount = math.floor( (amount or GAMEMODE.Config.normalsalary) - (amount or GAMEMODE.Config.normalsalary)*(Taxes[self:Team()].tax)/100 )
					else
						amount = math.floor( amount or GAMEMODE.Config.normalsalary )
					end
					
					hook.Call("playerGetSalary", GAMEMODE, self, amount)
					if amount == 0 or not amount then
						DarkRP.notify(self, 4, 4, "You received no salary because you are unemployed!")
					else
						if config.payFromBank and GovernmentBank < amount then DarkRP.notify( self, "The Government can't afford to pay you!" ) return end
						
						self:addMoney(amount)
						
						if Taxes[self:Team()] then
							DarkRP.notify(self, 4, 4, "Payday! You received $"..amount.."! ("..Taxes[self:Team()].tax.."% Tax)")
						else
							DarkRP.notify(self, 4, 4, "Payday! You received $"..amount.."!")
						end
						
						if config.payFromBank then
							GovernmentBank = math.Clamp( GovernmentBank - amount, 0, GovernmentBank )
						end
					end
				end)
			else
				DarkRP.notify(self, 4, 4, "Payday missed! You're arrested!")
			end
		end
		
		-- Remaking the function so loadout menu opens when they change job. :(
		function meta:changeTeam(t, force)
			local prevTeam = self:Team()
			
			if self:isArrested() and not force then
				DarkRP.notify(self, 1, 4, DarkRP.getPhrase("unable", team.GetName(t), ""))
				return false
			end

			self:setDarkRPVar("agenda", nil)

			if t ~= GAMEMODE.DefaultTeam and not self:changeAllowed(t) and not force then
				DarkRP.notify(self, 1, 4, DarkRP.getPhrase("unable", team.GetName(t), "banned/demoted"))
				return false
			end

			if self.LastJob and 10 - (CurTime() - self.LastJob) >= 0 and not force then
				DarkRP.notify(self, 1, 4, DarkRP.getPhrase("have_to_wait",  math.ceil(10 - (CurTime() - self.LastJob)), "/job"))
				return false
			end

			if self.IsBeingDemoted then
				self:teamBan()
				self.IsBeingDemoted = false
				self:changeTeam(GAMEMODE.DefaultTeam, true)
				DarkRP.destroyVotesWithEnt(self)
				DarkRP.notify(self, 1, 4, DarkRP.getPhrase("tried_to_avoid_demotion"))

				return false
			end


			if prevTeam == t then
				DarkRP.notify(self, 1, 4, DarkRP.getPhrase("unable", team.GetName(t), ""))
				return false
			end

			local TEAM = RPExtraTeams[t]
			if not TEAM then return false end

			if TEAM.customCheck and not TEAM.customCheck(self) then
				DarkRP.notify(self, 1, 4, TEAM.CustomCheckFailMsg or DarkRP.getPhrase("unable", team.GetName(t), ""))
				return false
			end

			if not self.DarkRPVars["Priv"..TEAM.command] and not force then
				if type(TEAM.NeedToChangeFrom) == "number" and prevTeam ~= TEAM.NeedToChangeFrom then
					DarkRP.notify(self, 1,4, DarkRP.getPhrase("need_to_be_before", team.GetName(TEAM.NeedToChangeFrom), TEAM.name))
					return false
				elseif type(TEAM.NeedToChangeFrom) == "table" and not table.HasValue(TEAM.NeedToChangeFrom, prevTeam) then
					local teamnames = ""
					for a,b in pairs(TEAM.NeedToChangeFrom) do teamnames = teamnames.." or "..team.GetName(b) end
					DarkRP.notify(self, 1,4, string.format(string.sub(teamnames, 5), team.GetName(TEAM.NeedToChangeFrom), TEAM.name))
					return false
				end
				local max = TEAM.max
				if max ~= 0 and -- No limit
				(max >= 1 and team.NumPlayers(t) >= max or -- absolute maximum
				max < 1 and (team.NumPlayers(t) + 1) / #player.GetAll() > max) then -- fractional limit (in percentages)
					DarkRP.notify(self, 1, 4,  DarkRP.getPhrase("team_limit_reached", TEAM.name))
					return false
				end
			end

			if TEAM.PlayerChangeTeam then
				local val = TEAM.PlayerChangeTeam(self, prevTeam, t)
				if val ~= nil then
					return val
				end
			end

			local hookValue = hook.Call("playerCanChangeTeam", nil, self, t, force)
			if hookValue == false then return false end

			local isMayor = RPExtraTeams[prevTeam] and RPExtraTeams[prevTeam].mayor
			if isMayor and tobool(GetConVarNumber("DarkRP_LockDown")) then
				DarkRP.unLockdown(self)
			end
			self:updateJob(TEAM.name)
			self:setSelfDarkRPVar("salary", TEAM.salary)
			DarkRP.notifyAll(0, 4, DarkRP.getPhrase("job_has_become", self:Nick(), TEAM.name))


			if self:getDarkRPVar("HasGunlicense") then
				self:setDarkRPVar("HasGunlicense", false)
			end
			if TEAM.hasLicense and GAMEMODE.Config.license then
				self:setDarkRPVar("HasGunlicense", true)
			end

			self.LastJob = CurTime()

			if GAMEMODE.Config.removeclassitems then
				for k, v in pairs(ents.FindByClass("microwave")) do
					if v.allowed and type(v.allowed) == "table" and table.HasValue(v.allowed, t) then continue end
					if v.SID == self.SID then v:Remove() end
				end
				for k, v in pairs(ents.FindByClass("gunlab")) do
					if v.allowed and type(v.allowed) == "table" and table.HasValue(v.allowed, t) then continue end
					if v.SID == self.SID then v:Remove() end
				end

				for k, v in pairs(ents.FindByClass("drug_lab")) do
					if v.allowed and type(v.allowed) == "table" and table.HasValue(v.allowed, t) then continue end
					if v.SID == self.SID then v:Remove() end
				end

				for k,v in pairs(ents.FindByClass("spawned_shipment")) do
					if v.allowed and type(v.allowed) == "table" and table.HasValue(v.allowed, t) then continue end
					if v.SID == self.SID then v:Remove() end
				end
			end

			if isMayor then
				for _, ent in pairs(self.lawboards or {}) do
					if IsValid(ent) then
						ent:Remove()
					end
				end
			end

			self:SetTeam(t)
			hook.Call("OnPlayerChangedTeam", GAMEMODE, self, prevTeam, t)
			DarkRP.log(self:Nick().." ("..self:SteamID()..") changed to "..team.GetName(t), nil, Color(100, 0, 255))
			if self:InVehicle() then self:ExitVehicle() end
			if GAMEMODE.Config.norespawn and self:Alive() then
				self:StripWeapons()
				local vPoint = self:GetShootPos() + Vector(0,0,50)
				local effectdata = EffectData()
				effectdata:SetEntity(self)
				effectdata:SetStart( vPoint ) -- Not sure if we need a start and origin (endpoint) for this effect, but whatever
				effectdata:SetOrigin( vPoint )
				effectdata:SetScale(1)
				util.Effect("entity_remove", effectdata)
				hook.Call("UpdatePlayerSpeed", GAMEMODE, self)
				GAMEMODE:PlayerSetModel(self)
				GAMEMODE:PlayerLoadout(self)
			else
				self:KillSilent()
			end

			umsg.Start("OnChangedTeam", self)
				umsg.Short(prevTeam)
				umsg.Short(t)
			umsg.End()
			
			timer.Simple( 1, function()
				local isGov = false
				for k, v in pairs( config.JobWeapons ) do
					if v.job == self:Team() then
						isGov = true
					end
				end
				
				if isGov then
					if self:Alive() then
						self.HasChoseTeam = false
						self:Freeze(true)
						
						net.Start( "LoadoutMenu" )
						net.Send( self )
					end
				end
			end)
			
			return true
		end
	end

	if CLIENT then
		local function formatNumber(n)
			if not n then return "" end
			if n >= 1e14 then return tostring(n) end
			
			n = tostring(n)
			local sep = sep or ","
			
			local dp = string.find(n, "%.") or #n+1
			
			for i=dp-4, 1, -3 do
				n = n:sub(1, i) .. sep .. n:sub(i+1)
			end
			
			return n
		end
		
		surface.CreateFont( "Trebuchet12", {
			font = "Trebuchet18",
			size = 12
		})
		
		hook.Add( "HUDPaint", "DarkRP_Economy", function()
			local w, h = config.hudWide, config.hudTall
			
			if string.lower(config.hudPosition) == "top" then
				draw.RoundedBoxEx( 2, ScrW()/2-(w/2), 0, w, h, Color(0,0,0,240), false, false, true, true )
				draw.RoundedBoxEx( 2, ScrW()/2-((w-2)/2), 0, w-2, h-1, Color(76,76,76,200), false, false, true, true )
				
				surface.SetMaterial( Material("gui/center_gradient.png") )
				surface.SetDrawColor( Color(0,255,0,255) )
				surface.DrawTexturedRect( ScrW()/2, 0, (w)/2, h-2 )
				surface.SetDrawColor( Color(255,255,0,255) )
				surface.DrawTexturedRect( ScrW()/2-(w/2)/2, 0, (w)/2, h-2 )
				surface.SetDrawColor( Color(255,0,0,255) )
				surface.DrawTexturedRect( ScrW()/2-(w/2), 0, (w)/2, h-2 )
				
				local x = ScrW()/2-(w-5)/2 + ( ((w-5)*Economy)/100 )
				
				surface.SetDrawColor( Color(0,0,0,240) )
				surface.DrawLine( x, -1, x, h-2 )
				
				draw.DrawText( "Economy: "..Economy.."%", "DermaDefaultBold", ScrW()/2+1, h+3, Color(0,0,0,255), TEXT_ALIGN_CENTER )
				draw.DrawText( "Economy: "..Economy.."%", "DermaDefaultBold", ScrW()/2, h+2, Color(255,255,255,255), TEXT_ALIGN_CENTER )
				
				local mx, my = gui.MousePos()
				if mx > ScrW()/2-w and mx < ScrW()/2+w and my < h then
					draw.RoundedBox( 2, ScrW()/2-(w/2), h+20, w, #Taxes*15+50, Color(0,0,0,240) )
					draw.RoundedBox( 2, ScrW()/2-((w-2)/2), h+21, w-2, #Taxes*15+48, Color(76,76,76,200) )
					draw.RoundedBox( 0, ScrW()/2-((w-2)/2), h+52.5, w-2, 20, Color(40,40,40,100) )
					
					draw.DrawText( "Government Bank: $"..formatNumber(GovernmentBank), "DermaDefaultBold", ScrW()/2+1, h+31, Color(0,0,0,255), TEXT_ALIGN_CENTER )
					draw.DrawText( "Government Bank: $"..formatNumber(GovernmentBank), "DermaDefaultBold", ScrW()/2, h+30, Color(255,255,255,255), TEXT_ALIGN_CENTER )
					
					draw.DrawText( "Team", "DermaDefaultBold", ScrW()/2-(w/2)+11, h+56, Color(0,0,0,255) )
					draw.DrawText( "Team", "DermaDefaultBold", ScrW()/2-(w/2)+10, h+55, Color(255,255,255,255) )
					draw.DrawText( "Tax", "DermaDefaultBold", ScrW()/2+(w/2)-9, h+56, Color(0,0,0,255), TEXT_ALIGN_RIGHT )
					draw.DrawText( "Tax", "DermaDefaultBold", ScrW()/2+(w/2)-10, h+55, Color(255,255,255,255), TEXT_ALIGN_RIGHT )
					
					for k, v in pairs( Taxes ) do
						draw.DrawText( team.GetName(v.job), "DermaDefaultBold", ScrW()/2-(w/2)+11, h+60+(k*13), Color(0,0,0,255) )
						draw.DrawText( team.GetName(v.job), "DermaDefaultBold", ScrW()/2-(w/2)+10, h+61+(k*13), Color(255,255,255,255) )
						draw.DrawText( v.tax.."%", "DermaDefaultBold", ScrW()/2+(w/2)-9, h+60+(k*13), Color(0,0,0,255), TEXT_ALIGN_RIGHT )
						draw.DrawText( v.tax.."%", "DermaDefaultBold", ScrW()/2+(w/2)-10, h+61+(k*13), Color(255,255,255,255), TEXT_ALIGN_RIGHT )
					end
				end
			elseif string.lower(config.hudPosition) == "bottom" then
				draw.RoundedBoxEx( 2, ScrW()/2-(w/2), ScrH()-h, w, h, Color(0,0,0,240), true, true, false, false )
				draw.RoundedBoxEx( 2, ScrW()/2-((w-2)/2), ScrH()-h, w-2, h-1, Color(76,76,76,200), true, true, false, false )
				
				surface.SetMaterial( Material("gui/center_gradient.png") )
				surface.SetDrawColor( Color(0,255,0,255) )
				surface.DrawTexturedRect( ScrW()/2, ScrH()-h+1, (w)/2, h-2 )
				surface.SetDrawColor( Color(255,255,0,255) )
				surface.DrawTexturedRect( ScrW()/2-(w/2)/2, ScrH()-h+1, (w)/2, h-2 )
				surface.SetDrawColor( Color(255,0,0,255) )
				surface.DrawTexturedRect( ScrW()/2-(w/2), ScrH()-h+1, (w)/2, h-2 )
				
				local x = ScrW()/2-(w-5)/2 + ( ((w-5)*Economy)/100 )
				
				surface.SetDrawColor( Color(0,0,0,240) )
				surface.DrawLine( x, ScrH()-1, x, ScrH()-h+1 )
				
				draw.DrawText( "Economy: "..Economy.."%", "DermaDefaultBold", ScrW()/2+1, ScrH()-h-16.5, Color(0,0,0,255), TEXT_ALIGN_CENTER )
				draw.DrawText( "Economy: "..Economy.."%", "DermaDefaultBold", ScrW()/2, ScrH()-h-17.5, Color(255,255,255,255), TEXT_ALIGN_CENTER )
				
				local mx, my = gui.MousePos()
				if mx > ScrW()/2-w and mx < ScrW()/2+w and my > ScrH()-h then
					draw.RoundedBox( 2, ScrW()/2-(w/2), ScrH()-h-20-(#Taxes*15+50), w, #Taxes*15+50, Color(0,0,0,240) )
					draw.RoundedBox( 2, ScrW()/2-((w-2)/2), ScrH()-h-19-(#Taxes*15+50), w-2, #Taxes*15+48, Color(76,76,76,200) )
					draw.RoundedBox( 0, ScrW()/2-((w-2)/2), ScrH()-h-(#Taxes*15+50)+10, w-2, 20, Color(40,40,40,100) )
					
					draw.DrawText( "Government Bank: $"..formatNumber(GovernmentBank), "DermaDefaultBold", ScrW()/2+1, ScrH()-h-10-(#Taxes*15+50), Color(0,0,0,255), TEXT_ALIGN_CENTER )
					draw.DrawText( "Government Bank: $"..formatNumber(GovernmentBank), "DermaDefaultBold", ScrW()/2, ScrH()-h-11-(#Taxes*15+50), Color(255,255,255,255), TEXT_ALIGN_CENTER )
					
					draw.DrawText( "Team", "DermaDefaultBold", ScrW()/2-(w/2)+11, ScrH()-h-(#Taxes*15+50)+13.5, Color(0,0,0,255) )
					draw.DrawText( "Team", "DermaDefaultBold", ScrW()/2-(w/2)+10, ScrH()-h-(#Taxes*15+50)+12.5, Color(255,255,255,255) )
					draw.DrawText( "Tax", "DermaDefaultBold", ScrW()/2+(w/2)-9, ScrH()-h-(#Taxes*15+50)+13.5, Color(0,0,0,255), TEXT_ALIGN_RIGHT )
					draw.DrawText( "Tax", "DermaDefaultBold", ScrW()/2+(w/2)-10, ScrH()-h-(#Taxes*15+50)+12.5, Color(255,255,255,255), TEXT_ALIGN_RIGHT )
					
					for k, v in pairs( Taxes ) do
						draw.DrawText( team.GetName(v.job), "DermaDefaultBold", ScrW()/2-(w/2)+11, ScrH()-h-(#Taxes*15+50)+21+(k*13), Color(0,0,0,255) )
						draw.DrawText( team.GetName(v.job), "DermaDefaultBold", ScrW()/2-(w/2)+10, ScrH()-h-(#Taxes*15+50)+20+(k*13), Color(255,255,255,255) )
						draw.DrawText( v.tax.."%", "DermaDefaultBold", ScrW()/2+(w/2)-9, ScrH()-h-(#Taxes*15+50)+21+(k*13), Color(0,0,0,255), TEXT_ALIGN_RIGHT )
						draw.DrawText( v.tax.."%", "DermaDefaultBold", ScrW()/2+(w/2)-10, ScrH()-h-(#Taxes*15+50)+20+(k*13), Color(255,255,255,255), TEXT_ALIGN_RIGHT )
					end
				end
			end
		end)
		
		net.Receive( "LoadoutMenu", function()
			local Frame = vgui.Create( "DFrame" )
			Frame:SetSize(400,250)
			Frame:Center()
			Frame:SetTitle("Loadout Selection")
			Frame:SetDraggable(false)
			Frame:ShowCloseButton(false)
			Frame:MakePopup()
			
			Frame.Paint = function()
				draw.RoundedBox( 4, 0, 0, Frame:GetWide(), Frame:GetTall(), Color(0,0,0,150) )
				draw.RoundedBox( 4, 0, 0, Frame:GetWide()-1, Frame:GetTall()-1, Color(76,76,76,255) )
				draw.RoundedBoxEx( 4, 0, 0, Frame:GetWide()-1, 25, Color(70,70,70,255), true, true, false, false )
				
				surface.SetDrawColor(Color(50,50,50,255))
				surface.DrawLine( 0, 25, Frame:GetWide()-1, 25 )
			end
			
			local perks = {}
			
			for k, v in pairs( config.GovernmentPerks ) do
				perks[k] = false
				for key, perk in pairs( Perks ) do
					if perk.name == v.name then
						perks[k] = true
					end
				end
			end
			
			local points = 0
			for k, v in pairs( config.JobWeapons ) do
				if LocalPlayer():Team() == v.job then
					points = v.selectionPoints
				end
			end
			
			local StatsSelection = vgui.Create( "DPanelList", Frame )
			StatsSelection:SetSize( 235, 190 )
			StatsSelection:SetPos( 5, Frame:GetTall()-StatsSelection:GetTall()-30 )
			StatsSelection.Paint = function()
				draw.RoundedBox( 4, 0, 0, StatsSelection:GetWide(), StatsSelection:GetTall(), Color(50,50,50,200) )
				draw.RoundedBoxEx( 4, 0, 0, StatsSelection:GetWide(), 17.5, Color(50,50,50,200), true, true, false, false )
				draw.RoundedBoxEx( 4, 0, StatsSelection:GetTall()-57.5, StatsSelection:GetWide(), 57.5, Color(50,50,50,200), false, false, true, true )
				draw.RoundedBox( 0, 0, 45, StatsSelection:GetWide(), 17.5, Color(50,50,50,200) )
				draw.RoundedBox( 0, 0, 90, StatsSelection:GetWide(), 17.5, Color(50,50,50,200) )
				draw.DrawText( "Leg Strength", "Trebuchet18", StatsSelection:GetWide()/2, 0, Color(255,255,255,150), TEXT_ALIGN_CENTER )
				draw.DrawText( "Damage Resistance", "Trebuchet18", StatsSelection:GetWide()/2, 45, Color(255,255,255,150), TEXT_ALIGN_CENTER )
				draw.DrawText( "Body Armor", "Trebuchet18", StatsSelection:GetWide()/2, 90, Color(255,255,255,150), TEXT_ALIGN_CENTER )
				draw.DrawText( "Selection Points: "..points, "Trebuchet18", StatsSelection:GetWide()/2, StatsSelection:GetTall()-37.5, Color(255,255,255,150), TEXT_ALIGN_CENTER )
				
				if !perks[1] or Economy < config.EconomyLevels.legStrength then
					local text
					if Economy < config.EconomyLevels.legStrength then
						text = "Economy Too Low"
					else
						text = "Missing Perk"
					end
					
					draw.DrawText( text, "Trebuchet18", StatsSelection:GetWide()/2, 20, Color(255,100,100,150), TEXT_ALIGN_CENTER )
				end
				
				if !perks[2] or Economy < config.EconomyLevels.damageResistance then
					local text
					if Economy < config.EconomyLevels.damageResistance then
						text = "Economy Too Low"
					else
						text = "Missing Perk"
					end
					
					draw.DrawText( text, "Trebuchet18", StatsSelection:GetWide()/2, 65, Color(255,100,100,150), TEXT_ALIGN_CENTER )
				end
				
				if !perks[4] or Economy < config.EconomyLevels.armor then
					local text
					if Economy < config.EconomyLevels.armor then
						text = "Economy Too Low"
					else
						text = "Missing Perk"
					end
					
					draw.DrawText( text, "Trebuchet18", StatsSelection:GetWide()/2, 110, Color(255,100,100,150), TEXT_ALIGN_CENTER )
				end
			end
			
			local legstrength = 0
			
			if perks[1] and Economy >= config.EconomyLevels.legStrength then
				local max
				for k, v in pairs( config.JobWeapons ) do
					if LocalPlayer():Team() == v.job then
						max = v.legStrength/5
					end
				end
				
				local LegStrength = vgui.Create( "DPanel", StatsSelection )
				LegStrength:SetSize(StatsSelection:GetWide(),25)
				LegStrength:SetPos(0,17.5)
				LegStrength.Paint = function()
					local x, y = 150, 20
					draw.RoundedBox( 4, LegStrength:GetWide()/2-75, 5, 150, 20, Color(50,50,50,200) ) 
					draw.RoundedBox( 4, LegStrength:GetWide()/2-73, 7, math.Clamp(146*legstrength/max,8,146), 16, Color(30,30,30,100) ) 
					draw.DrawText( legstrength.."/"..max, "Trebuchet18", LegStrength:GetWide()/2, 6, Color(255,255,255,150), TEXT_ALIGN_CENTER )
				end
				
				LegStrength.Think = function()
					if Economy < config.EconomyLevels.legStrength and LegStrength:IsVisible() then
						LegStrength:SetVisible(false)
					else
						LegStrength:SetVisible(true)
					end
				end
				
				local SubtractLegStrength = vgui.Create( "DImageButton", LegStrength )
				SubtractLegStrength:SetSize(16,16)
				SubtractLegStrength:SetPos(19,LegStrength:GetTall()/2-(SubtractLegStrength:GetTall()/2)+2.5)
				SubtractLegStrength:SetColor(Color(255,255,255,100))
				SubtractLegStrength:SetImage( "icon16/delete.png" )
				SubtractLegStrength.DoClick = function()
					if legstrength > 0 then
						points = points + 1
					end
					
					legstrength = math.Clamp( legstrength - 1, 0, max )
				end
				
				local AddLegStrength = vgui.Create( "DImageButton", LegStrength )
				AddLegStrength:SetSize(16,16)
				AddLegStrength:SetPos(LegStrength:GetWide()-35,LegStrength:GetTall()/2-(AddLegStrength:GetTall()/2)+2.5)
				AddLegStrength:SetColor(Color(255,255,255,100))
				AddLegStrength:SetImage( "icon16/add.png" )
				AddLegStrength.DoClick = function()
					if points > 0 and legstrength < max then
						points = math.Clamp( points - 1, 0, points )
						legstrength = math.Clamp( legstrength + 1, 0, max )
					end
				end
			end
			
			local damageresistance = 0
			
			if perks[2] and Economy >= config.EconomyLevels.damageResistance then
				local max
				for k, v in pairs( config.JobWeapons ) do
					if LocalPlayer():Team() == v.job then
						max = v.damageResistance/5
					end
				end
				
				local DamageResistance = vgui.Create( "DPanel", StatsSelection )
				DamageResistance:SetSize(StatsSelection:GetWide(),25)
				DamageResistance:SetPos(0,62.5)
				DamageResistance.Paint = function()
					local x, y = 150, 20
					draw.RoundedBox( 4, DamageResistance:GetWide()/2-75, 5, 150, 20, Color(50,50,50,200) ) 
					draw.RoundedBox( 4, DamageResistance:GetWide()/2-73, 7, math.Clamp(146*damageresistance/max,8,146), 16, Color(30,30,30,100) ) 
					draw.DrawText( damageresistance.."/"..max, "Trebuchet18", DamageResistance:GetWide()/2, 6, Color(255,255,255,150), TEXT_ALIGN_CENTER )
				end
				
				DamageResistance.Think = function()
					if Economy < config.EconomyLevels.damageResistance and DamageResistance:IsVisible() then
						DamageResistance:SetVisible(false)
					else
						DamageResistance:SetVisible(true)
					end
				end
				
				local SubtractDamageResistance = vgui.Create( "DImageButton", DamageResistance )
				SubtractDamageResistance:SetSize(16,16)
				SubtractDamageResistance:SetPos(19,DamageResistance:GetTall()/2-(SubtractDamageResistance:GetTall()/2)+2.5)
				SubtractDamageResistance:SetColor(Color(255,255,255,100))
				SubtractDamageResistance:SetImage( "icon16/delete.png" )
				SubtractDamageResistance.DoClick = function()
					if damageresistance > 0 then
						points = points + 1
					end
					
					damageresistance = math.Clamp( damageresistance - 1, 0, max )
				end
				
				local AddLegDamageResistance = vgui.Create( "DImageButton", DamageResistance )
				AddLegDamageResistance:SetSize(16,16)
				AddLegDamageResistance:SetPos(DamageResistance:GetWide()-35,DamageResistance:GetTall()/2-(AddLegDamageResistance:GetTall()/2)+2.5)
				AddLegDamageResistance:SetColor(Color(255,255,255,100))
				AddLegDamageResistance:SetImage( "icon16/add.png" )
				AddLegDamageResistance.DoClick = function()
					if points > 0 and damageresistance < max then
						points = math.Clamp( points - 1, 0, points )
						damageresistance = math.Clamp( damageresistance + 1, 0, max )
					end
				end
			end
			
			local armor = 0
			
			if perks[4] and Economy >= config.EconomyLevels.armor then
				local max
				for k, v in pairs( config.JobWeapons ) do
					if LocalPlayer():Team() == v.job then
						max = v.armor/5
					end
				end
				
				local Armor = vgui.Create( "DPanel", StatsSelection )
				Armor:SetSize(StatsSelection:GetWide(),25)
				Armor:SetPos(0,105)
				Armor.Paint = function()
					local x, y = 150, 20
					draw.RoundedBox( 4, Armor:GetWide()/2-75, 5, 150, 20, Color(50,50,50,200) ) 
					draw.RoundedBox( 4, Armor:GetWide()/2-73, 7, math.Clamp(146*armor/max,8,146), 16, Color(30,30,30,100) ) 
					draw.DrawText( armor.."/"..max, "Trebuchet18", Armor:GetWide()/2, 6, Color(255,255,255,150), TEXT_ALIGN_CENTER )
				end
				
				Armor.Think = function()
					if Economy < config.EconomyLevels.armor and Armor:IsVisible() then
						Armor:SetVisible(false)
					else
						Armor:SetVisible(true)
					end
				end
				
				local SubtractArmor = vgui.Create( "DImageButton", Armor )
				SubtractArmor:SetSize(16,16)
				SubtractArmor:SetPos(19,Armor:GetTall()/2-(SubtractArmor:GetTall()/2)+2.5)
				SubtractArmor:SetColor(Color(255,255,255,100))
				SubtractArmor:SetImage( "icon16/delete.png" )
				SubtractArmor.DoClick = function()
					if armor > 0 then
						points = points + 1
					end
					
					armor = math.Clamp( armor - 1, 0, max )
				end
				
				local AddArmor = vgui.Create( "DImageButton", Armor )
				AddArmor:SetSize(16,16)
				AddArmor:SetPos(Armor:GetWide()-35,Armor:GetTall()/2-(AddArmor:GetTall()/2)+2.5)
				AddArmor:SetColor(Color(255,255,255,100))
				AddArmor:SetImage( "icon16/add.png" )
				AddArmor.DoClick = function()
					if points > 0 and armor < max then
						points = math.Clamp( points - 1, 0, points )
						armor = math.Clamp( armor + 1, 0, max )
					end
				end
			end
			
			local WeaponSelection = vgui.Create( "DPanelList", Frame )
			WeaponSelection:SetSize( 150, 190 )
			WeaponSelection:SetPos( Frame:GetWide()-WeaponSelection:GetWide()-5, Frame:GetTall()-WeaponSelection:GetTall()-30 )
			WeaponSelection.Paint = function()
				draw.RoundedBox( 4, 0, 0, WeaponSelection:GetWide(), WeaponSelection:GetTall(), Color(50,50,50,200) )
			end
			
			local PrimaryWeaponsHeader = vgui.Create( "DPanel" )
			PrimaryWeaponsHeader:SetSize(150,17.5)
			PrimaryWeaponsHeader.Paint = function()
				draw.RoundedBoxEx( 4, 0, 0, PrimaryWeaponsHeader:GetWide(), PrimaryWeaponsHeader:GetTall(), Color(50,50,50,200), true, true, false, false )
				draw.DrawText( "Primary Weapon(s)", "Trebuchet18", PrimaryWeaponsHeader:GetWide()/2, 0, Color(255,255,255,150), TEXT_ALIGN_CENTER )
			end
			
			WeaponSelection:AddItem( PrimaryWeaponsHeader )
			
			local selectedPrimaries = {}
			local selectedSecondaries = {}
			
			if perks[3] then
				for k, v in pairs( config.JobWeapons ) do
					if LocalPlayer():Team() == v.job then
						for k, wep in pairs( v.primaries ) do
							local name = wep
							
							for k, v in pairs( config.WeaponTranslations ) do
								if v.class == wep then
									name = v.name
								end
							end
							
							local max = v.maxPrimary
							
							local Weapon = vgui.Create( "DButton" )
							Weapon:SetSize(150,15)
							Weapon:SetText( name )
							Weapon:SetTextColor( Color(255,255,255,150) )
							Weapon.Selected = false
							Weapon.Paint = function() end
							
							Weapon.DoClick = function()
								if Weapon.Selected then
									Weapon.Selected = false
									table.remove( selectedPrimaries, table.KeyFromValue(selectedPrimaries,wep) )
								else
									if #selectedPrimaries < max then
										Weapon.Selected = true
										table.insert( selectedPrimaries, wep )
									end
								end
							end
							
							Weapon.Think = function()
								if Weapon.Hovered and !Weapon:IsDown() and !Weapon.Selected and #selectedPrimaries < max then
									Weapon:SetTextColor( Color(255,150,0,150) )
								elseif ( #selectedPrimaries < max and Weapon:IsDown() ) or Weapon.Selected then
									Weapon:SetTextColor( Color(255,150,0,50) )
								elseif #selectedPrimaries >= max then
									Weapon:SetTextColor( Color(255,255,255,50) )
								else
									Weapon:SetTextColor( Color(255,255,255,150) )
								end
							end
							
							WeaponSelection:AddItem( Weapon )
						end
					end
				end
			else
				local NoPrimaryWeaponsPerk = vgui.Create( "DPanel" )
				NoPrimaryWeaponsPerk:SetSize(150,25)
				NoPrimaryWeaponsPerk.Paint = function()
					draw.DrawText( "Missing Perk", "Trebuchet18", NoPrimaryWeaponsPerk:GetWide()/2, 2.5, Color(255,100,100,150), TEXT_ALIGN_CENTER )
				end
				
				WeaponSelection:AddItem( NoPrimaryWeaponsPerk )
			end
			
			local SecondaryWeaponsHeader = vgui.Create( "DPanel" )
			SecondaryWeaponsHeader:SetSize(150,17.5)
			SecondaryWeaponsHeader.Paint = function()
				draw.RoundedBox( 0, 0, 0, SecondaryWeaponsHeader:GetWide(), SecondaryWeaponsHeader:GetTall(), Color(50,50,50,200) )
				draw.DrawText( "Secondary Weapon(s)", "Trebuchet18", SecondaryWeaponsHeader:GetWide()/2, 0, Color(255,255,255,150), TEXT_ALIGN_CENTER )
			end
			
			WeaponSelection:AddItem( SecondaryWeaponsHeader )
			
			for k, v in pairs( config.JobWeapons ) do
				if LocalPlayer():Team() == v.job then
					for k, wep in pairs( v.secondaries ) do
						local name = wep
						
						for k, v in pairs( config.WeaponTranslations ) do
							if v.class == wep then
								name = v.name
							end
						end
						
						local max = v.maxSecondary
						
						local Weapon = vgui.Create( "DButton" )
						Weapon:SetSize(150,15)
						Weapon:SetText( name )
						Weapon:SetTextColor( Color(255,255,255,150) )
						Weapon.Selected = false
						Weapon.Paint = function() end
						
						Weapon.DoClick = function()
							if Weapon.Selected then
								Weapon.Selected = false
								table.remove( selectedSecondaries, table.KeyFromValue(selectedSecondaries,wep) )
							else
								if #selectedSecondaries < max then
									Weapon.Selected = true
									table.insert( selectedSecondaries, wep )
								end
							end
						end
						
						Weapon.Think = function()
							if Weapon.Hovered and !Weapon:IsDown() and !Weapon.Selected and #selectedSecondaries < max then
								Weapon:SetTextColor( Color(255,150,0,150) )
							elseif ( #selectedSecondaries < max and Weapon:IsDown() ) or Weapon.Selected then
								Weapon:SetTextColor( Color(255,150,0,50) )
							elseif #selectedSecondaries >= max then
								Weapon:SetTextColor( Color(255,255,255,50) )
							else
								Weapon:SetTextColor( Color(255,255,255,150) )
							end
						end
						
						WeaponSelection:AddItem( Weapon )
					end
				end
			end
			
			local FinishLoadout = vgui.Create( "DButton", Frame )
			FinishLoadout:SetSize(Frame:GetWide()-10,20)
			FinishLoadout:SetPos(Frame:GetWide()-FinishLoadout:GetWide()-5,Frame:GetTall()-FinishLoadout:GetTall()-5)
			FinishLoadout:SetText( "Finish Loadout" )
			FinishLoadout:SetTextColor( Color(255,255,255,150) )
			
			FinishLoadout.DoClick = function()
				Frame:Hide()
				
				net.Start( "ChooseLoadout" )
					net.WriteTable( selectedPrimaries )
					net.WriteTable( selectedSecondaries )
					net.WriteFloat( legstrength )
					net.WriteFloat( damageresistance )
					net.WriteFloat( armor )
				net.SendToServer()
			end
			
			FinishLoadout.Paint = function()
				draw.RoundedBox( 4, 0, 0, FinishLoadout:GetWide(), FinishLoadout:GetTall(), Color(50,50,50,200) )
			end
			
			FinishLoadout.Think = function()
				if FinishLoadout.Hovered and !FinishLoadout:IsDown() then
					FinishLoadout:SetTextColor( Color(255,150,0,150) )
				elseif FinishLoadout:IsDown() then
					FinishLoadout:SetTextColor( Color(255,150,0,50) )
				else
					FinishLoadout:SetTextColor( Color(255,255,255,150) )
				end
			end
		end)
		
		net.Receive( "EconomyMenu", function()
			local Frame = vgui.Create( "DFrame" )
			Frame:SetSize(400,250)
			Frame:Center()
			Frame:SetTitle("Economy Management")
			Frame:SetDraggable(false)
			Frame:MakePopup()
			
			timer.Simple( 0.5, function()
				Frame.Think = function()
					if input.IsKeyDown( KEY_F2 ) then
						Frame:Hide()
					end
					
					if LocalPlayer():Team() != config.mayorTeam then
						Frame:Hide()
					end
				end
			end)
			
			Frame.Paint = function()
				draw.RoundedBox( 4, 0, 0, Frame:GetWide(), Frame:GetTall(), Color(0,0,0,150) )
				draw.RoundedBox( 4, 0, 0, Frame:GetWide()-1, Frame:GetTall()-1, Color(76,76,76,255) )
				draw.RoundedBoxEx( 4, 0, 0, Frame:GetWide()-1, 25, Color(70,70,70,255), true, true, false, false )
				
				surface.SetDrawColor(Color(50,50,50,255))
				surface.DrawLine( 0, 25, Frame:GetWide()-1, 25 )
			end
			
			local Panel = vgui.Create( "DScrollPanel", Frame )
			Panel:SetSize(Frame:GetWide()-20,Frame:GetTall()-35)
			Panel:SetPos(10,Frame:GetTall()-Panel:GetTall()-5)
			Panel.Paint = function() end
			
			local Text_JobTaxes = vgui.Create( "DLabel", Panel )
			Text_JobTaxes:SetPos(0,0)
			Text_JobTaxes:SetSize(300,0)
			Text_JobTaxes:SetAutoStretchVertical(true)
			Text_JobTaxes:SetText("Job Taxes")
			Text_JobTaxes:SetFont("Trebuchet24")
			Text_JobTaxes.Paint = function()
				draw.DrawText( Text_JobTaxes:GetValue(), "Trebuchet24", 1, 1, Color(0,0,0,255) )
			end
			
			local Text_GovernmentPerks = vgui.Create( "DLabel", Panel )
			Text_GovernmentPerks:SetPos(0,#Taxes*20+60)
			Text_GovernmentPerks:SetSize(300,0)
			Text_GovernmentPerks:SetAutoStretchVertical(true)
			Text_GovernmentPerks:SetText("Government Perks")
			Text_GovernmentPerks:SetFont("Trebuchet24")
			Text_GovernmentPerks.Paint = function()
				draw.DrawText( Text_GovernmentPerks:GetValue(), "Trebuchet24", 1, 1, Color(0,0,0,255) )
			end
			
			local JobTaxesList = vgui.Create( "DPanelList", Panel )
			JobTaxesList:SetSize(350,#Taxes*20)
			JobTaxesList:SetPos(5,30)
			
			for k, v in pairs( Taxes ) do
				local JobTax = vgui.Create( "DNumSlider" )
				JobTax:SetText(team.GetName(v.job))
				JobTax:SetSize(350,20)
				JobTax:SetMin(0)
				JobTax:SetMax(100)
				JobTax:SetDecimals(0)
				JobTax:SetValue(v.tax)
				
				JobTaxesList:AddItem(JobTax)
			end
			
			local UpdateTaxes = vgui.Create( "DButton", Panel )
			UpdateTaxes:SetSize(100,20)
			UpdateTaxes:SetPos(20,#Taxes*20+32.5)
			UpdateTaxes:SetText("Update Taxes")
			UpdateTaxes:SetTextColor( Color(255,255,255,150) )
			
			UpdateTaxes.DoClick = function()
				local taxes = {}
				for k, v in pairs( JobTaxesList:GetItems() ) do
					table.insert( taxes, v:GetValue() )
				end
				
				net.Start( "UpdateTaxes" )
					net.WriteTable( taxes )
				net.SendToServer()
			end
			
			UpdateTaxes.Paint = function()
				draw.RoundedBox( 4, 0, 0, UpdateTaxes:GetWide(), UpdateTaxes:GetTall(), Color(50,50,50,200) )
			end
			
			UpdateTaxes.Think = function()
				if UpdateTaxes.Hovered and !UpdateTaxes:IsDown() then
					UpdateTaxes:SetTextColor( Color(255,150,0,150) )
				elseif UpdateTaxes:IsDown() then
					UpdateTaxes:SetTextColor( Color(255,150,0,50) )
				else
					UpdateTaxes:SetTextColor( Color(255,255,255,150) )
				end
			end
			
			local PerksList = vgui.Create( "DPanelList", Panel )
			PerksList:SetSize(350,#config.GovernmentPerks*55)
			PerksList:SetPos(20,#Taxes*20+90)
			PerksList.Paint = function() end
			
			for k, v in pairs( config.GovernmentPerks ) do
				local owned = false
				
				for k, perk in pairs( Perks ) do
					if perk.name == v.name then
						owned = true
					end
				end
				
				local Perk = vgui.Create( "DPanel" )
				Perk:SetSize(335,55)
				Perk.Paint = function()
					local col
					if GovernmentBank >= v.price then
						col = Color(0,255,0,255)
					else
						col = Color(255,50,50,255)
					end
					
					draw.DrawText( v.name.." - ", "Trebuchet18", 5, 5, Color(255,255,255,150) )
					draw.DrawText( "$"..formatNumber(v.price), "Trebuchet18", surface.GetTextSize(v.name.." - ")+5, 5, col )
				end
				
				local Info = vgui.Create( "DLabel", Perk )
				Info:SetWide(200)
				Info:SetPos(15,25)
				Info:SetText(v.info)
				Info:SetWrap(true)
				Info:SetAutoStretchVertical(true)
				
				local BuyPerk = vgui.Create( "DButton", Perk )
				BuyPerk:SetSize(100,20)
				BuyPerk:SetPos(Perk:GetWide()-BuyPerk:GetWide(),Perk:GetTall()-BuyPerk:GetTall())
				BuyPerk:SetTextColor( Color(255,255,255,150) )
				BuyPerk:SetText( "Buy Perk" )
				
				BuyPerk.DoClick = function()
					net.Start( "BuyPerk" )
						net.WriteString( v.name )
					net.SendToServer()
				end
				
				BuyPerk.Paint = function()
					draw.RoundedBox( 4, 0, 0, BuyPerk:GetWide(), BuyPerk:GetTall(), Color(50,50,50,200) )
				end
				
				BuyPerk.Think = function()
					if BuyPerk.Hovered and !BuyPerk:IsDown() and !BuyPerk:GetDisabled() then
						BuyPerk:SetTextColor( Color(255,150,0,150) )
					elseif BuyPerk:GetDisabled() then
						BuyPerk:SetTextColor( Color(255,255,255,50) )
					elseif BuyPerk:IsDown() then
						BuyPerk:SetTextColor( Color(255,150,0,50) )
					else
						BuyPerk:SetTextColor( Color(255,255,255,150) )
					end
					
					if GovernmentBank < v.price or owned then
						BuyPerk:SetDisabled(true)
					else
						BuyPerk:SetDisabled(false)
					end
					
					if owned and BuyPerk:GetValue() != "Owned" then
						BuyPerk:SetText( "Owned" )
					end
					
					if owned then
						local stillOwned = false
						for k, perk in pairs( Perks ) do
							if v.name == perk.name then
								stillOwned = true
							end
						end
						
						if !stillOwned then owned = false BuyPerk:SetText( "Buy Perk" ) end
					else
						local ownedNow = false
						for k, perk in pairs( Perks ) do
							if v.name == perk.name then
								ownedNow = true
							end
						end
						
						if ownedNow then owned = true BuyPerk:SetText( "Owned" ) end
					end
				end
				
				PerksList:AddItem( Perk )
			end
		end)
		
		net.Receive( "GiveOpportunity", function()
			local Frame = vgui.Create( "DFrame" )
			Frame:SetSize(400,400)
			Frame:Center()
			Frame:SetTitle("Opportunities")
			Frame:SetDraggable(false)
			Frame:ShowCloseButton(false)
			Frame:MakePopup()
			
			timer.Simple( 60*config.opportunityTime/2, function()
				Frame:Hide()
			end)
			
			local opportunity = net.ReadTable()
			
			Frame.Paint = function()
				draw.RoundedBox( 4, 0, 0, Frame:GetWide(), Frame:GetTall(), Color(0,0,0,150) )
				draw.RoundedBox( 4, 0, 0, Frame:GetWide()-1, Frame:GetTall()-1, Color(76,76,76,255) )
				draw.RoundedBoxEx( 4, 0, 0, Frame:GetWide()-1, 25, Color(70,70,70,255), true, true, false, false )
				
				surface.SetDrawColor(Color(50,50,50,255))
				surface.DrawLine( 0, 25, Frame:GetWide()-1, 25 )
				
				surface.SetFont( "DermaDefault" )
				
				draw.RoundedBox( 4, 45, 75, 310, 110, Color(56,56,56,200) )
				draw.RoundedBoxEx( 4, 45, 200, 310, 25, Color(56,56,56,200), true, true, false, false )
				
				draw.DrawText( opportunity.title, "DermaLarge", 35, 40, Color(255,255,255,150) )
				draw.DrawText( opportunity.question, "DermaDefault", 50, 205, Color(255,255,255,150) )
			end
			
			local InfoPanel = vgui.Create( "DScrollPanel", Frame )
			InfoPanel:SetSize(300,100)
			InfoPanel:SetPos(50,80)
			
			local OpportunityInfo = vgui.Create( "DLabel", InfoPanel )
			OpportunityInfo:SetWide(300)
			OpportunityInfo:SetWrap(true)
			OpportunityInfo:SetAutoStretchVertical(true)
			OpportunityInfo:SetText(opportunity.info)
			OpportunityInfo:SetFont("DermaDefault")
			OpportunityInfo:SetTextColor(Color(255,255,255,150))
			
			local Options = vgui.Create( "DPanelList", Frame )
			Options:SetSize(310,155)
			Options:SetPos(45,225)
			Options:EnableVerticalScrollbar(true)
			Options.Paint = function()
				draw.RoundedBoxEx( 4, 0, 0, Options:GetWide(), Options:GetTall(), Color(56,56,56,200), false, false, true, true )
			end
			
			for k, v in pairs( opportunity.options ) do
				local Option = vgui.Create( "DButton" )
				Option:SetSize(310,30)
				Option:SetText(v.option)
				Option:SetTextColor(Color(255,255,255,150))
				
				Option.Paint = function()
					draw.RoundedBox( 4, 5, 2.5, Option:GetWide()-10, Option:GetTall()-5, Color(50,50,50,200) )
				end
				
				Option.Think = function()
					if Option.Hovered and !Option:IsDown() then
						Option:SetTextColor( Color(255,150,0,150) )
					elseif Option:IsDown() then
						Option:SetTextColor( Color(255,150,0,50) )
					else
						Option:SetTextColor( Color(255,255,255,150) )
					end
				end
				
				Option.DoClick = function()
					Frame:Hide()
					
					net.Start( "TakeOpportunity" )
						net.WriteString( v.option )
					net.SendToServer()
				end
				
				Options:AddItem( Option )
			end
		end)
		
		net.Receive( "SyncEconomy", function()
			Economy = net.ReadFloat()
			GovernmentBank = net.ReadFloat()
			Taxes = net.ReadTable()
			Perks = net.ReadTable()
		end)
	end
end)