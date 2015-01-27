
local ProjectorPositions = {
	["rp_downtown_v4c_v2"] = {
		Position = Vector(-1813.877441, 1669.774170, 28.498878),
		Angles = Angle(24.138, 74.661, -2.446),
		WhiteScale = 0.94
	},
	["rp_downtown_v4c_v3"] = {
		Position = Vector(-1813.877441, 1669.774170, 28.498878),
		Angles = Angle(24.138, 74.661, -2.446),
		WhiteScale = 0.94
	}
}

local function AddProjs()
	local pp = ProjectorPositions[game.GetMap()]
	if pp then

		wyozimc.Debug("PP Found for ", game.GetMap())

		local projector = ents.Create("wyozi_screen_projector")
		projector:SetPos(pp.Position)
		projector:SetAngles(pp.Angles)
		projector:Spawn()
		projector:SetMoveType(MOVETYPE_NONE)

		projector:SetAllowFunc(function(ent, ply)
			if ply:Team() == TEAM_CINEMAMANAGER or wyozimc.HasPermission(ply, "PlayAll") then return true end
			GAMEMODE:Notify(ply, 1, 4, "You need to be a cinema owner to use this projector.")
			return false
		end)
		projector:SetWhiteScale(pp.WhiteScale)

		wyozimc.Debug("Added pp ", projector, " ", projector:GetPos())


	else
		wyozimc.Debug("No pp found for ", game.GetMap())
	end
end

hook.Add("InitPostEntity", "WyoziMCAddDarkRPProjectors", AddProjs)

--AddProjs()