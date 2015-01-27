-- Weather settings

SW.AutoWeatherEnabled 		= true 	-- Enable auto-weather (i.e. automatically cycling between weather) (true/false).
SW.AutoMinTimeStartWeather 	= 1 	-- Minimum time in hours before weather begins.
SW.AutoMaxTimeStartWeather 	= 3 	-- Maximum time in hours before weather begins.
SW.AutoMinTimeStopWeather 	= 0.2 	-- Minimum time in hours before weather stops.
SW.AutoMaxTimeStopWeather 	= 1 	-- Maximum time in hours before weather stops.
SW.AutoWeatherType 			= SW_AUTO_RAIN + SW_AUTO_STORM + SW_AUTO_FOG	-- What weather to automatically start. For example, SW_AUTO_RAIN + SW_AUTO_STORM will disable snow from automatically starting, and just putting SW_AUTO_SNOW will make only snow autostart.

SW.RainOnScreen				= true 	-- Show rain on screen (true/false).
SW.RainOnScreenMinSize		= 20 	-- Minimum size of the raindrops on screen.
SW.RainOnScreenMaxSize		= 40 	-- Maximum size of the raindrops on screen.
SW.RainOnScreenMinDelay		= 0.1 	-- Minimum time in seconds between raindrops on screen.
SW.RainOnScreenMaxDelay		= 0.4 	-- Maximum time in seconds between raindrops on screen.

SW.RainSplashes 			= true 	-- Make rain splash particle effect (true/false).
SW.RainSmoke 				= true 	-- Make rain steam particle effect (true/false).

SW.ThunderMinDelay 			= 10	-- Minimum delay in seconds to cause lightning/thunder while stormy.
SW.ThunderMaxDelay 			= 30 	-- Maximum delay in seconds to cause lightning/thunder while stormy.
SW.LightningEnabled			= true 	-- Enable lightning flashes (true/false).

SW.ColormodEnabled			= true 	-- Enable colormod when it's raining or snowing (true/false).

SW.VolumeMultiplier			= 1 	-- Volume (0-1) sounds should play at. Change it if the rain's too loud!


-- Day/Night settings

SW.Realtime					= true	-- Should time pass according to the server's time. (true/false)
SW.DayTimeMul 				= 0.01	-- Multiplier of time during the day. Make this bigger for time to go faster, and smaller for time to go slower.
SW.NightTimeMul 			= 0.02	-- Multiplier of time during the night. Make this bigger for time to go faster, and smaller for time to go slower.

SW.UpdateLighting			= true	-- Enable map lighting updates (true/false). Turn this off if the map's a night map already!
SW.UpdateSun				= true	-- Enable sun moving through the sky (true/false).
SW.UpdateSkybox				= true	-- Enable the skybox to change color through the day (true/false).
SW.UpdateFog				= true	-- Turn off fog at night. Prevents weird light fog at night - turn it off if weird stuff happens.
SW.FireOutputs				= true	-- Enable any map-based effects, like lampposts turning off and on (true/false).

SW.MaxDarkness				= "b"	-- Maximum darkness level during night. Increase to add light. "a" is darkest, "z" is lightest (a-z).
SW.MaxLightness				= "y"	-- Maximum lightness level at noon on a clear day. Decrease to decrease light. "a" is darkest, "z" is lightest (a-z).
SW.MaxLightnessStorm		= "j"	-- Maximum lightness level at noon on a stormy day. Decrease to decrease light. "a" is darkest, "z" is lightest (a-z).

SW.StarRotateSpeed			= 0.01	-- How fast to rotate the stars at night. Make this smaller for slower rotation (0-1).

-- Particle configuration settings
-- Messing with this can make some weather work incorrectly... Be sure to make a backup if you change these!

SW.MaxParticles				= 5000 	-- Maximum number of particles to create at any one time.

SW.RainRadius				= 500 	-- Radius of rain effect.
SW.RainCount				= 20 	-- Amount of particles in rain effect. Make this smaller to increase performance.
SW.RainDieTime				= 3 	-- Time in seconds until rain vanishes.

SW.StormRadius				= 500 	-- Radius of storm effect.
SW.StormCount				= 120 	-- Amount of particles in storm effect. Make this smaller to increase performance.
SW.StormDieTime				= 1 	-- Time in seconds until rain vanishes.

SW.RainHeightMax			= 300 	-- Maximum height to make rain.

SW.SnowRadius				= 1700 	-- Radius of snow effect.
SW.SnowCount				= 20 	-- Amount of particles in snow effect. Make this smaller to increase performance.
SW.SnowDieTime				= 5 	-- Time in seconds until snow vanishes.

SW.SnowHeightMax			= 350 	-- Maximum height to make snow.

SW.LeaveSnowOnGround		= true	-- Leave snow on the ground (true/false).