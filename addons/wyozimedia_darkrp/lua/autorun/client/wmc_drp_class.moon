export DRPEntMediaContainer

class DRPEntMediaContainer extends wyozimc.MediaContainer

	new: (ent) =>
		if not IsValid(ent)
			ErrorNoHalt("DRPEntMediaContainer must be passed a valid entity!")

		@ent = ent

	-- Return true here to prevent starting media
	handle_flags: (url, flags) =>

	-- Return true here to prevent starting media
	pre_play: (url, provider, udata, flags) =>

	post_play: (url, provider, udata, flags) =>

	-- Return true here to prevent stopping media
	pre_stop: (global_request) =>

	post_stop: (global_request) =>

	-- Return a fraction 0 - 1 what volume should we have. Optinally return true as second return value to ignore master volume
	get_volume: =>
		@ent\GetPlayerVolume!

	get_debug_id: =>
		tostring(@ent)

	-- If you want to cache BASS handles, this'd be a good place to return them It's assumed that bass handles
	--  are cleared after being return from here
	get_cached_bass_handle: (url) => 
		if handle = wyozimc.CachedMedia[url]
			wyozimc.CachedMedia[url] = nil
			return handle