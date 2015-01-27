do
  local _parent_0 = wyozimc.MediaContainer
  local _base_0 = {
    handle_flags = function(self, url, flags) end,
    pre_play = function(self, url, provider, udata, flags) end,
    post_play = function(self, url, provider, udata, flags) end,
    pre_stop = function(self, global_request) end,
    post_stop = function(self, global_request) end,
    get_volume = function(self)
      return self.ent:GetPlayerVolume()
    end,
    get_debug_id = function(self)
      return tostring(self.ent)
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
    __init = function(self, ent)
      if not IsValid(ent) then
        ErrorNoHalt("DRPEntMediaContainer must be passed a valid entity!")
      end
      self.ent = ent
    end,
    __base = _base_0,
    __name = "DRPEntMediaContainer",
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
  DRPEntMediaContainer = _class_0
  return _class_0
end
