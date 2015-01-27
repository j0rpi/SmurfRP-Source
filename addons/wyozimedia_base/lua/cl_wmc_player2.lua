local wyozimc_enabled = CreateConVar("wyozimc_enabled", "1", FCVAR_ARCHIVE)
local wyozimc_volume = CreateConVar("wyozimc_volume", wyozimc.DefaultVolume and tostring(wyozimc.DefaultVolume) or "0.5", FCVAR_ARCHIVE)
local wyozimc_playwhenalttabbed = CreateConVar("wyozimc_playwhenalttabbed", "0", FCVAR_ARCHIVE)
local wyozimc_ignoreglobalplays = CreateConVar("wyozimc_ignoreglobalplays", "0", FCVAR_ARCHIVE)
local wyozimc_debugvid = CreateConVar("wyozimc_debugvid", "0", FCVAR_ARCHIVE)
local wyozimc_highquality = CreateConVar("wyozimc_highquality", "0", FCVAR_ARCHIVE)
local wyozimc_bassvolmapping = CreateConVar("wyozimc_bassvolmapping", "1", FCVAR_ARCHIVE)
wyozimc.GetMasterVolume = function(is_bass_module)
  local curvolume = wyozimc_volume:GetFloat()
  if is_bass_module then
    curvolume = curvolume * wyozimc_bassvolmapping:GetFloat()
  end
  if not wyozimc_playwhenalttabbed:GetBool() and not system.HasFocus() then
    curvolume = 0
  end
  return curvolume
end
wyozimc.CachedMedia = { }
local MainMediaContainer
do
  local _parent_0 = wyozimc.MediaContainer
  local _base_0 = {
    handle_flags = function(self, url, flags)
      if flags and bit.band(flags, wyozimc.FLAG_OVERRIDE_NOTHING) == wyozimc.FLAG_OVERRIDE_NOTHING then
        return true, "Flags contain FLAG_OVERRIDE_NOTHING"
      end
      if wyozimc_ignoreglobalplays:GetBool() and bit.band(flags, wyozimc.FLAG_DIRECT_REQUEST) == wyozimc.FLAG_DIRECT_REQUEST then
        return true, "Direct (serverside) request and we have global plays disabled"
      end
    end,
    pre_play = function(self, url, provider, udata, flags)
      if wyozimc.CallHook("WyoziMCPrePlay", provider, url, udata, flags) then
        return true, "Terminated by WyoziMCPrePlay hook"
      end
    end,
    post_play = function(self, url, provider, udata, flags)
      return wyozimc.CallHook("WyoziMCPostPlay", url, provider, udata, flags)
    end,
    pre_stop = function(self, global_request)
      if wyozimc.CallHook("WyoziMCPreStop", global_request) then
        return true, "Terminated by hook"
      end
    end,
    post_stop = function(self, global_request)
      return wyozimc.CallHook("WyoziMCPostStop", global_request)
    end,
    get_volume = function(self) end,
    get_debug_id = function(self)
      return "MainContainer"
    end,
    get_cached_bass_handle = function(self, url)
      do
        local handle = wyozimc.CachedMedia[url]
        if handle then
          wyozimc.CachedMedia[url] = nil
          return handle
        end
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, ...)
      return _parent_0.__init(self, ...)
    end,
    __base = _base_0,
    __name = "MainMediaContainer",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        return _parent_0[name]
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  MainMediaContainer = _class_0
end
wyozimc.MainContainer = wyozimc.MainContainer or MainMediaContainer()
concommand.Add("wyozimc_refreshmc", function()
  wyozimc.MainContainer:destroy()
  wyozimc.MainContainer = MainMediaContainer()
end)
hook.Add("Think", "WyoziMCMaintainMainVolume", function()
  return wyozimc.MainContainer:volume_think()
end)
wyozimc.PlayUrl = function(url, startat, flags)
  return wyozimc.MainContainer:play_url(url, startat, flags)
end
wyozimc.GetPlayedFraction = function()
  return wyozimc.MainContainer:get_played_fraction()
end
wyozimc.IsPlaying = function()
  return wyozimc.MainContainer:is_playing()
end
wyozimc.Stop = function(global_request)
  return wyozimc.MainContainer:stop(global_request)
end
net.Receive("wyozimc_play", function()
  local url = net.ReadString()
  local flags = net.ReadUInt(32)
  if url == "" then
    wyozimc.Debug("Got empty url, assuming we need to stop. Flags: " .. bit.tohex(flags))
    return wyozimc.Stop(bit.band(flags, wyozimc.FLAG_WAS_GLOBAL_REQUEST) == wyozimc.FLAG_WAS_GLOBAL_REQUEST)
  else
    wyozimc.Debug("Received ", url, " to play on client. Flags: " .. bit.tohex(flags))
    return wyozimc.PlayUrl(url, _, flags)
  end
end)
net.Receive("wyozimc_cache", function()
  local url = net.ReadString()
  local provider, udata = wyozimc.FindProvider(url)
  if not provider then
    ErrorNoHalt("Trying to cache something with no provider: " .. tostring(url))
    return 
  end
  if not provider.UseGmodPlayer then
    wyozimc.Debug("Trying to cache invalid provider: only GmodPlayer sounds can be cached!")
    return 
  end
  return sound.PlayURL(url, "noplay", function(chan)
    if IsValid(chan) then
      wyozimc.CachedMedia[url] = chan
      return wyozimc.Debug("Cached ", url, " using GmodPlayer")
    else
      return wyozimc.Debug("GModplayer Cached channel nonvalid for ", url)
    end
  end)
end)
concommand.Add("wyozimc_stop", function()
  return wyozimc.Stop()
end)
return hook.Add("InitPostEntity", "WyoziMCPlayLate", function()
  local url, flags, start = GetGlobalString("wmc_playurl"), GetGlobalInt("wmc_playflags"), GetGlobalInt("wmc_playat")
  if url and url ~= "" then
    return wyozimc.PlayUrl(url, CurTime() - start, flags)
  end
end)
