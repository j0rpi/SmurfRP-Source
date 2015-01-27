
if SERVER then
	-- Set FPP ownership & allow funcs. Stupid hacky timer hack because owningent isn't available immediately on creation
	hook.Add("OnEntityCreated", "WyoziMCDarkRPFixFptjesBadGamemode", function(ent)
		if ent:GetClass() == "wyozi_screen_radio" then
			timer.Simple(0.1, function()
				if not IsValid(ent) then return end
				local ply = ent.DRP_OwningEnt
				if not IsValid(ply) then return end

				ent:CPPISetOwner(ply)
				ent:SetAllowFunc(function(ent, ply)
					if ply:Team() == TEAM_DJ or wyozimc.HasPermission(ply, "PlayAll") then return true end
					GAMEMODE:Notify(ply, 1, 4, "You need to be a DJ to use this radio.")
					return false
				end)
			end)
		end
		if ent:GetClass() == "wyozi_discoball" then
			timer.Simple(0.1, function()
				if not IsValid(ent) then return end
				local ply = ent.DRP_OwningEnt
				if not IsValid(ply) then return end

				ent:CPPISetOwner(ply)
			end)
		end
	end)

	hook.Add("OnPlayerChangedTeam", "WyoziMCDarkRPRemoveOldRadios", function(ply, oldjob, newjob)
		if oldjob == TEAM_DJ and wyozimc.DRP_RemoveRadiosOnTeamChange then
			for k, v in pairs(ents.FindByClass("wyozi_screen_radio")) do
				if v.SID == ply.SID then
					wyozimc.Debug(ply, " changed job. Removing his old radio ", v)
					v:Remove()
					ply["maxwyozi_screen_radio"] = (ply["maxwyozi_screen_radio"] or 1) - 1 
				end
			end
			for k, v in pairs(ents.FindByClass("wyozi_discoball")) do
				if v.SID == ply.SID then
					wyozimc.Debug(ply, " changed job. Removing his old discoball ", v)
					v:Remove()
					ply["maxwyozi_discoball"] = (ply["maxwyozi_discoball"] or 1) - 1 
				end
			end
		end
	end)
	hook.Add("canPocket", "WyoziMCPreventPocket", function(ply, ent)
		if ent:GetClass() == "wyozi_screen_projector" then
			return false, "You can't pocket this!"
		end
	end)
end

-- Allow DJs and cinema owners to modify media list
hook.Add("WyoziMCPermission", "WyoziMCDarkRPJobPermissions", function(permission, ply)
	local team = ply:Team()
	if wyozimc.DRP_AllowJobEdit and (team == TEAM_DJ or team == TEAM_CINEMAOWNER) and (permission == "Add" or permission == "Delete") then
		return true
	end
end)