AddCSLuaFile()

ENT.Type = "anim"

--[[
ENT.Author = "Wyozi"
ENT.PrintName = "Wyozi Screen: Base"
ENT.Category = "Wyozi"

ENT.Spawnable = true
ENT.AdminSpawnable = true
]]

ENT.IsWyoziScreen = true

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.Model = Model("models/dav0r/camera.mdl")

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Link")
	self:NetworkVar("Float", 0, "StartedAt")
	self:NetworkVar("Int", 1, "PlayFlags")

	self:NetworkVar("Float", 1, "DepthOffset", { KeyName = "depthoffset", Edit = { type = "Float", min = -1000, max = 1000, order = 1 } })
	self:NetworkVar("Float", 2, "WhiteScale", { KeyName = "whitescale", Edit = { type = "Float", min = 0, max = 10, order = 1 } })

	self:NetworkVar("Float", 3, "VolumeMultiplier", { KeyName = "volumemul", Edit = { type = "Float", min = 0, max = 100, order = 1 } })

	if SERVER then
		self:SetWhiteScale(1)
		self:SetDepthOffset(0.05) -- get rid of zfighting
		self:SetVolumeMultiplier(3)
	end

end

ENT.Editable = true

-- Hmm?
function ENT:CanEditVariables( ply )
	return ply:IsAdmin()
end

if SERVER then

	function ENT:Initialize()

		self:SetModel( self.Model )

		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )

		--if data.Static then
		--	self:SetMoveType( MOVETYPE_NONE )
		--else
			self:SetMoveType( MOVETYPE_VPHYSICS )
		--end
		
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end

		self:SetUseType(SIMPLE_USE)

	end

	function ENT:PlayVideo(url, startat, flags)
		self:SetLink(url)
		self:SetStartedAt(CurTime() - (startat or 0))
		self:SetPlayFlags(flags)
	end

	function ENT:StopVideo()
		self:SetLink("")
	end

	util.AddNetworkString("wyozimc_drp_play")

	function ENT:Use(activator)
		if activator:IsPlayer() then
			if self.AllowFunc and not self:AllowFunc(activator) then
				return
			end
			net.Start("wyozimc_gui")
				net.WriteBit(true)
				net.WriteString("wyozimc_drp_play")
				net.WriteEntity(self)
			net.Send(activator)
		end
	end

	function ENT:SetAllowFunc(func)
		self.AllowFunc = func
	end

	net.Receive("wyozimc_drp_play", function(le, cl)
		local url = net.ReadString()

		local provider, udata
		if url ~= "" then
			provider, udata = wyozimc.FindProvider(url)
			if not provider then
				cl:ChatPrint("invalid provider")
				return
			end
		end

		local ent = net.ReadEntity()
		local flags = net.ReadUInt(32)
		if IsValid(ent) and ent.IsWyoziScreen then
			if ent.AllowFunc and not ent:AllowFunc(cl) then
				return
			end
			if url == "" then
				ent:StopVideo()
			else
				ent:PlayVideo(url, udata and udata.StartAt or 0, flags or 0)
			end
		end
	end)

end

if CLIENT then

	ENT.HTMLWidth = 512

	function ENT:OnRemove()
		if self.MediaContainer then
			self.MediaContainer:destroy()
		end
	end

	function ENT:DestroyBrowser(killed_by_distance)
		if self.MediaContainer and self.SetToPlayUrl then
			self.MediaContainer:stop(_, killed_by_distance)
			self.SetToPlayUrl = nil
		end
	end

	function ENT:ShouldDestroyBrowser(is_dead)
		if not cvars.Bool("wyozimc_enabled") then return true end

		local ad = 300 * self:GetVolumeMultiplier()
		local tdist = is_dead and (ad-200) or (ad+200) -- Makes it so distance at which browser creates/destroys isnt same. This is to make it impossible to walk forward and back and spam browser creation, thus lagging a lot
		
		--debugoverlay.Line(self:GetPos(), self:GetPos() + (LocalPlayer():EyePos() - self:GetPos()):GetNormalized()*ad)
		return LocalPlayer():GetPos():Distance(self:GetPos()) > tdist
	end

	-- Units Per Second to Feet Per Second
	-- No idea if correct calculation but close enough?
	local function UPSToFPS(ups)
	    return ups / 16
	end

	-- Feet Per Second -> Meters Per Second
	local function FPSToMPS(fps)
	    return fps * 0.3048
	end

	function ENT:GetPlayerVolume()
		local dist = LocalPlayer():GetPos():Distance(self:GetPos())
		local trace = { start = self:GetPos(), endpos = LocalPlayer():EyePos(), filter = self }
        local tr = util.TraceLine( trace ) 

		local m = 1
		if tr.HitWorld then
			m = 2
		end

		-- PHYSICS TIME M8S

		local distance = dist * m -- m = a modifier (e.g. if we hit a wall). Simple but works!

		-- Distance by default is in source units, let's convert to meters!
		distance = FPSToMPS(UPSToFPS(distance))

		-- While the thing is all dandy and stuff now, it decays too quickly, let's just divide now, cba to figure out what's wrong

		local volumemul = self:GetVolumeMultiplier()
		if volumemul == 0 then volumemul = 1 end

		distance = distance / volumemul

		local v = math.Clamp(1 / distance^2, 0, 1)

		return v
	end

	function ENT:Think()
		-- bad place for this but meh
		if self.RenderData.Height and self.RenderData.Width then
			self.HTMLHeight = self.HTMLWidth * (self.RenderData.Height / self.RenderData.Width)
		else
			self.HTMLHeight = 512
		end

		if self:ShouldDestroyBrowser(not self.MediaContainer or not IsValid(self.MediaContainer.player_browser)) then
			if self.MediaContainer and IsValid(self.MediaContainer.player_browser) then
				self:DestroyBrowser(true)
			end
		else
			local link = self:GetLink()
			
			if link ~= "" then
				if not self.MediaContainer then
					self.MediaContainer = DRPEntMediaContainer(self)
					self.MediaContainer.custom_browser_width = self.HTMLWidth
					self.MediaContainer.custom_browser_height = self.HTMLHeight
				end
				if not self.MediaTitle and self.MediaContainer.play_data and self.MediaContainer.play_data.query_data then
					self.MediaTitle = self.MediaContainer.play_data.query_data.Title
				end
				if link ~= self.SetToPlayUrl or self.LoadingStartedAt ~= self:GetStartedAt() then
					local startat = CurTime() - self:GetStartedAt()
					self.MediaContainer:play_url(link, startat, self:GetPlayFlags())
					self.LoadingStartedAt = self:GetStartedAt()
					self.SetToPlayUrl = link
					self.MediaTitle = nil
				end
			elseif self.MediaContainer and self.MediaContainer:is_playing() then
				self.MediaContainer:stop()
				self.MediaTitle = nil
			end

			if self.MediaContainer then
				self.MediaContainer:volume_think()
				if IsValid(self.MediaContainer.sound_channel) then
					self.MediaContainer.sound_channel:SetPos(self:GetPos())
				end
			end
			
		end
	end

	function ENT:DrawScreen()

		if not self.MediaContainer then return false end
		local browser = self.MediaContainer.player_browser
		if not IsValid(browser) then return false end

		render.PushFilterMin( TEXFILTER.ANISOTROPIC )
		render.PushFilterMag( TEXFILTER.ANISOTROPIC )

		browser:UpdateHTMLTexture()
		local mat = browser:GetHTMLMaterial()
		surface.SetMaterial(mat)
		surface.SetDrawColor(255, 255, 255)
		surface.DrawTexturedRect(0, 0, 512, 512)

		render.PopFilterMin()
		render.PopFilterMag()

		return true
	end
	
	function ENT:Draw()
		self:DrawModel()

		if not self.RenderData or self.RenderData.AudioOnly then return end

		render.SuppressEngineLighting(true)

		local pos, ang
		local scalemul = 1
		local draw_scale

		self.HTMLHeight = self.HTMLHeight or 0

		if self.RenderData.Projector then
			local midpos = self:LocalToWorld(self:OBBCenter())

			local vecdir = self:GetForward()-- + self:GetRight()*0.25
			local tr = util.QuickTrace(midpos, midpos + vecdir * 10000, self)
			pos = tr.HitPos
			ang = tr.HitNormal:Angle()

            ang:RotateAroundAxis(ang:Right(), -90)
            ang:RotateAroundAxis(ang:Up(), 90)
            draw_scale = math.Clamp(pos:Distance(midpos) * 0.002 * self:GetWhiteScale(), 0.001, 100)

            local s_hwidth, s_hheight = draw_scale*self.HTMLWidth*0.37, draw_scale*self.HTMLHeight*0.66

            pos = pos - ang:Right()*s_hwidth

            pos = pos - ang:Forward()*s_hheight

            self:SetRenderBoundsWS(self:GetPos() - vecdir*1000, tr.HitPos + vecdir*1000)

            pos = pos + tr.HitNormal * self:GetDepthOffset()

            debugoverlay.Line(midpos, tr.HitPos, 0.1, Color(255, 0, 0))
            debugoverlay.Line(midpos, pos, 0.1, Color(0, 0, 255))

            if cvars.Bool("wyozimc_debug") then
            	local hp = tr.HitPos
            	local mins, maxs = Vector(-s_hheight, -s_hwidth, -5), Vector(s_hheight, s_hwidth, 5)
            	render.DrawWireframeBox(hp, ang, mins, maxs, Color(255, 255, 255), true)
            end
		else
			pos = self:LocalToWorld(self.RenderData.Offset)
			ang = self:LocalToWorldAngles(self.RenderData.Rotation)
			draw_scale = self.RenderData.Width / self.HTMLWidth
		end

		cam.Start3D2D(pos, ang, draw_scale)
			surface.SetDrawColor(0, 0, 0)
			surface.DrawRect(0, 0, self.HTMLWidth, self.HTMLHeight)

			local drawn = self:DrawScreen()

			if not drawn then
				surface.SetDrawColor(0, 0, 0)
				surface.DrawRect(0, 0, self.HTMLWidth, self.HTMLHeight)

				draw.SimpleText("No media. Press 'e' on the projector/TV.", "DermaLarge", self.HTMLWidth/2, self.HTMLHeight/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		cam.End3D2D()

		render.SuppressEngineLighting(false)

	end
end

-- Stupid darkrp stuff
function ENT:Setowning_ent(ent)
	self.DRP_OwningEnt = ent
end