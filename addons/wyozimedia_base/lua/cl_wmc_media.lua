wyozimc.DebugVidSlots = wyozimc.DebugVidSlots or { }
local get_free_dvs
get_free_dvs = function()
  local i = 0
  while true do
    if not wyozimc.DebugVidSlots[i] then
      return i
    end
    i = i + 1
  end
end
local dvs_count = 0
local wdebug = wyozimc.Debug
local is_valid = IsValid
local MediaContainer
do
  local _base_0 = {
    verify_components_exist = function(self)
      if not is_valid(self.player_browser_panel) then
        local browser_panel = vgui.Create("DPanel")
        do
          browser_panel:SetPos(0, 0)
          browser_panel:SetSize(self.custom_browser_width or 512, self.custom_browser_height or 287)
          browser_panel:SetVisible(false)
        end
        self.player_browser_panel = browser_panel
      end
      if not is_valid(self.player_browser) then
        local browser = vgui.Create("DHTML", self.player_browser_panel)
        do
          browser:SetPos(0, 0)
          browser:SetSize(self.player_browser_panel:GetSize())
          browser:SetPaintedManually(true)
          browser:AddFunction("wmc", "SetElapsed", function(elapsed)
            wyozimc.Debug("Setting elapsed from browser to " .. tostring(elapsed))
            if elapsed < 1 then
              self.browser_zero_elapses = self.browser_zero_elapses + 1
            else
              self.browser_zero_elapses = 0
            end
            if self.play_data then
              self.play_data.browser_vid_elapsed = math.Round(elapsed)
            end
          end)
          browser:AddFunction("wmc", "UnableToPlay", function(reason)
            return wyozimc.Debug("Unable to play media because " .. tostring(reason))
          end)
          browser:AddFunction("wmc", "SetFlashStatus", function(bool)
            self.browser_flash_found = bool
            return wyozimc.Debug("Setting flash status to " .. tostring(bool))
          end)
          self:add_browser_funcs(browser)
        end
        self.player_browser = browser
      end
      if not is_valid(self.browser_debug_comp) then
        local debug_comp = vgui.Create("DPanel")
        do
          debug_comp:SetPos(0, 0)
          debug_comp:SetSize(self.custom_browser_width or 512, self.custom_browser_height or 287)
          debug_comp:SetVisible(false)
        end
        self.browser_debug_comp = debug_comp
        local id_lbl = vgui.Create("DLabel", debug_comp)
        id_lbl:Dock(BOTTOM)
        id_lbl:SetText(self:get_debug_id())
        id_lbl:SetColor(Color(0, 0, 0))
        local browser_painter = vgui.Create("DPanel", debug_comp)
        browser_painter:Dock(FILL)
        browser_painter.Paint = function(pself, w, h)
          if not is_valid(self.player_browser) then
            debug_comp:Remove()
            return 
          end
          self.player_browser:UpdateHTMLTexture()
          surface.SetMaterial(self.player_browser:GetHTMLMaterial())
          surface.SetDrawColor(255, 255, 255)
          return surface.DrawTexturedRect(0, 0, w, h)
        end
      end
    end,
    add_browser_funcs = function(self, browser) end,
    handle_flags = function(self, url, flags) end,
    pre_play = function(self, url, provider, udata, flags) end,
    post_play = function(self, url, provider, udata, flags) end,
    pre_stop = function(self, global_request) end,
    post_stop = function(self, global_request) end,
    get_volume = function(self) end,
    get_debug_id = function(self)
      return "undefined"
    end,
    get_cached_bass_handle = function(self, url) end,
    stop = function(self, global_request, dont_destroy_soundchan)
      local handled_res, reason = self:pre_stop(global_request)
      if handled_res == true then
        wdebug("Stop prevented in pre_stop: ", reason)
        return 
      end
      if wyozimc.CallHook("WyoziMCGlobalPreStop", self, global_request) then
        return true, "Terminated by WyoziMCGlobalPreStop hook"
      end
      if is_valid(self.player_browser) then
        self.player_browser:SetHTML("Hello!")
      end
      if is_valid(self.sound_channel) and not dont_destroy_soundchan then
        self.sound_channel:Stop()
      end
      self.play_data = nil
      self:post_stop(global_request)
      return wyozimc.CallHook("WyoziMCGlobalPostStop", self, global_request)
    end,
    destroy = function(self)
      if is_valid(self.player_browser) then
        self.player_browser:Remove()
      end
      if is_valid(self.player_browser_panel) then
        self.player_browser_panel:Remove()
        if self.debugvid_slot then
          wyozimc.DebugVidSlots[self.debugvid_slot] = nil
          dvs_count = dvs_count - 1
        end
      end
      if is_valid(self.sound_channel) then
        return self.sound_channel:Stop()
      end
    end,
    create_future = function(self)
      local tbl = { }
      tbl.done = function(callback)
        tbl.done_cb = callback
      end
      return tbl
    end,
    play_url = function(self, url, startat, flags)
      if flags == nil then
        flags = 0
      end
      if not cvars.Bool("wyozimc_enabled") then
        return wyozimc.Debug("play_url prevented because wmc disabled")
      end
      local handled_res, reason = self:handle_flags(url, flags)
      if handled_res == true then
        wdebug("Play prevented in handle_flags for ", url, ": ", reason)
        return 
      end
      local provider, udata = wyozimc.FindProvider(url)
      if not provider then
        ErrorNoHalt("Trying to play something with no provider: " .. tostring(url))
        return 
      end
      udata.StartAt = math.Round(startat or udata.StartAt or 0)
      startat = udata.StartAt
      handled_res, reason = self:pre_play(url, provider, udata, flags)
      if handled_res == true then
        wdebug("Play prevented in pre_play for ", url, ": ", reason)
        return 
      end
      if wyozimc.CallHook("WyoziMCGlobalPrePlay", self, provider, url, udata, flags) then
        return true, "Terminated by WyoziMCGlobalPrePlay hook"
      end
      self:stop()
      self.old_play_data = self.play_data
      self.last_volume = nil
      self.play_data = {
        started = CurTime() - startat,
        real_started = CurTime(),
        url = url,
        startat = startat,
        flags = flags,
        provider = provider,
        udata = udata
      }
      self.browser_zero_elapses = 0
      wdebug("Playing ", url, " with flags ", bit.tohex(flags), " & startat ", startat)
      self:verify_components_exist()
      local future = self:create_future()
      if provider.QueryMeta then
        provider.QueryMeta(udata, function(data)
          wdebug("QueryData received: (title=", data.Title, " d=", data.Duration, ")")
          if not self.play_data then
            return 
          end
          if future.done_cb then
            future.done_cb(data)
          end
          self.play_data.query_data = data
        end, function(errormsg) end)
      end
      if provider.UseGmodPlayer then
        do
          local cached_handle = self:get_cached_bass_handle(url)
          if cached_handle then
            cached_handle:Play()
            wdebug("Playing ", url, " using a cached BASS handle")
          else
            sound.PlayURL(url, "noplay", function(chan)
              if not is_valid(chan) then
                return wdebug("Invalid BASS handle received for ", url)
              end
              local old_chan = self.sound_channel
              if is_valid(old_chan) then
                old_chan:Stop()
              end
              self.sound_channel = chan
              chan:Play()
              return wdebug("Playing ", url, " using BASS")
            end)
          end
        end
      elseif provider.SetHTML then
        local html_source = provider.SetHTML(udata, url)
        self.player_browser:SetHTML(html_source)
        wdebug("Playing ", url, " using SetHTML")
      else
        wdebug("Translating url ", url)
        provider.TranslateUrl(udata, function(url, newstartat)
          udata.StartAt = udata.StartAt or newstartat
          self.player_browser:OpenURL(url)
          return wdebug("Playing translated ", url, " normally")
        end)
      end
      self:post_play(url, provider, udata, flags)
      wyozimc.CallHook("WyoziMCGlobalPostPlay", self, provider, url, udata, flags)
      return future
    end,
    query_elapsed = function(self)
      if not is_valid(self.player_browser) then
        return 
      end
      do
        local pd = self.play_data
        if pd then
          do
            local fqe = pd.provider.FuncQueryElapsed
            if fqe then
              return self.player_browser:Call(fqe())
            end
          end
        end
      end
    end,
    get_played_fraction = function(self)
      local play_data = self.play_data
      if not play_data then
        return 
      end
      do
        local qd = play_data.query_data
        if qd then
          local elapsed_time = (CurTime() - play_data.started)
          local total_frac = qd.Duration == -1 and 0 or (elapsed_time / (qd.Duration or 0))
          return total_frac
        end
      end
    end,
    is_playing = function(self)
      do
        local pf = self:get_played_fraction()
        if pf then
          return pf < 1
        end
      end
      return false
    end,
    get_url = function(self)
      do
        local pd = self.play_data
        if pd then
          return pd.url
        end
      end
    end,
    has_flag = function(self, flag)
      do
        local pd = self.play_data
        if pd then
          return bit.band(pd.flags or 0, flag) == flag
        end
      end
    end,
    volume_think = function(self)
      local play_data = self.play_data
      if play_data and play_data.provider and play_data.provider.FuncSetVolume then
        local set_vol = play_data.provider.FuncSetVolume
        local cur_vol, ignore_master = self:get_volume()
        cur_vol = cur_vol or 1
        if not ignore_master then
          cur_vol = cur_vol * wyozimc.GetMasterVolume(self.play_data.provider.UseGmodPlayer)
        end
        if cur_vol ~= self.last_volume or self.play_data.real_started > CurTime() - 2 then
          if is_valid(self.player_browser) then
            self.player_browser:QueueJavascript(set_vol(cur_vol))
          end
          if is_valid(self.sound_channel) then
            set_vol(cur_vol, self.sound_channel)
          end
          self.last_volume = cur_vol
        end
      end
      if play_data then
        if (not self.last_elapsed_query or self.last_elapsed_query < CurTime() - 1) then
          self:query_elapsed()
          self.last_elapsed_query = CurTime()
        end
        do
          local elapsed = self.play_data.browser_vid_elapsed
          if elapsed then
            play_data.started = CurTime() - elapsed
          end
        end
      end
      if is_valid(self.browser_debug_comp) and self.browser_debug_comp:IsVisible() ~= cvars.Bool("wyozimc_debugvid") then
        local set_vis_state = cvars.Bool("wyozimc_debugvid")
        self.browser_debug_comp:SetVisible(set_vis_state)
        if set_vis_state then
          self.debugvid_slot = get_free_dvs()
          wyozimc.DebugVidSlots[self.debugvid_slot] = self
          dvs_count = dvs_count + 1
        else
          if self.debugvid_slot then
            wyozimc.DebugVidSlots[self.debugvid_slot] = nil
            dvs_count = dvs_count - 1
          end
          self.debugvid_slot = nil
        end
      end
      if self.last_tracked_dvs ~= dvs_count and is_valid(self.browser_debug_comp) and self.browser_debug_comp:IsVisible() then
        if self.debugvid_slot > 0 and not wyozimc.DebugVidSlots[self.debugvid_slot - 1] then
          local old_dvs = self.debugvid_slot
          self.debugvid_slot = self.debugvid_slot - 1
          wyozimc.DebugVidSlots[old_dvs] = nil
          wyozimc.DebugVidSlots[self.debugvid_slot] = self
        end
        local xpos = self.debugvid_slot % 2
        local ypos = math.floor(self.debugvid_slot / 2)
        self.browser_debug_comp:SetPos(xpos * 512, ypos * 512)
        self.last_tracked_dvs = dvs_count
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "MediaContainer"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  MediaContainer = _class_0
end
wyozimc.MediaContainer = MediaContainer
