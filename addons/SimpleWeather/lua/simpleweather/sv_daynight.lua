SW.Time = 0;
SW.TimePaused = false;

SW_TIME_DAWN = 6;
SW_TIME_AFTERNOON = 12;
SW_TIME_DUSK = 18;
SW_TIME_NIGHT = 24;

SW_TIME_WEATHER = 1;
SW_TIME_WEATHER_NIGHT = 2;

SW.SkyColors = { };
SW.SkyColors[SW_TIME_DAWN] = {
	TopColor 		= Vector( 0.64, 0.73, 0.91 ),
	BottomColor 	= Vector( 0.74, 0.86, 0.98 ),
	FadeBias 		= 0.82,
	HDRScale 		= 0.66,
	DuskIntensity 	= 2.44,
	DuskScale 		= 0.54,
	DuskColor 		= Vector( 1, 0.38, 0 ),
	SunSize 		= 2,
	SunColor 		= Vector( 0.2, 0.1, 0 )
};
SW.SkyColors[SW_TIME_AFTERNOON] = {
	TopColor 		= Vector( 0.24, 0.61, 1 ),
	BottomColor 	= Vector( 0.4, 0.8, 1 ),
	FadeBias 		= 0.27,
	HDRScale 		= 0.66,
	DuskIntensity 	= 0,
	DuskScale 		= 0.54,
	DuskColor 		= Vector( 1, 0.38, 0 ),
	SunSize 		= 5,
	SunColor 		= Vector( 0.2, 0.1, 0 )
};
SW.SkyColors[SW_TIME_DUSK] = {
	TopColor 		= Vector( 0.45, 0.55, 1 ),
	BottomColor 	= Vector( 0.91, 0.64, 0.05 ),
	FadeBias 		= 0.61,
	HDRScale 		= 0.66,
	DuskIntensity 	= 1.56,
	DuskScale 		= 0.54,
	DuskColor 		= Vector( 1, 0, 0 ),
	SunSize 		= 2,
	SunColor 		= Vector( 1, 0.47, 0 )
};
SW.SkyColors[SW_TIME_NIGHT] = {
	TopColor 		= Vector( 0, 0.01, 0.02 ),
	BottomColor 	= Vector( 0, 0, 0 ),
	FadeBias 		= 0.82,
	HDRScale 		= 0.66,
	DuskIntensity 	= 0,
	DuskScale 		= 0.54,
	DuskColor 		= Vector( 1, 0.38, 0 ),
	SunSize 		= 2,
	SunColor 		= Vector( 0.2, 0.1, 0 )
};
SW.SkyColors[SW_TIME_WEATHER] = {
	TopColor 		= Vector( 0.34, 0.34, 0.34 ),
	BottomColor 	= Vector( 0.19, 0.19, 0.19 ),
	FadeBias 		= 1,
	HDRScale 		= 0.66,
	DuskIntensity 	= 0,
	DuskScale 		= 0,
	DuskColor 		= Vector( 0, 0, 0 ),
	SunSize 		= 0,
	SunColor 		= Vector( 0, 0, 0 )
};
SW.SkyColors[SW_TIME_WEATHER_NIGHT] = {
	TopColor 		= Vector( 0.02, 0.02, 0.02 ),
	BottomColor 	= Vector( 0, 0, 0 ),
	FadeBias 		= 1,
	HDRScale 		= 0.66,
	DuskIntensity 	= 0,
	DuskScale 		= 0,
	DuskColor 		= Vector( 0, 0, 0 ),
	SunSize 		= 0,
	SunColor 		= Vector( 0, 0, 0 )
};

SW.LastLightStyle = "";

util.AddNetworkString( "SW.nInitFogSettings" );
util.AddNetworkString( "SW.nInitSkyboxFogSettings" );
util.AddNetworkString( "SW.nSetTimePeriod" );

function SW.UpdateLightStyle( s )
	
	engine.LightStyle( 0, s );
	
	timer.Simple( 0, function()
		
		net.Start( "SW.nRedownloadLightmaps" );
		net.Broadcast();
		
	end );
	
	SW.LastLightStyle = s;
	
end

function SW.InitDayNight()
	
	if( SW.UpdateSkybox ) then
		
		RunConsoleCommand( "sv_skyname", "painted" );
		
	end
	
end

function SW.InitPostEntity()
	
	SW.LightEnvironment = ents.FindByClass( "light_environment" )[1];
	SW.Sun = ents.FindByClass( "env_sun" )[1];
	SW.SkyPaint = ents.FindByClass( "env_skypaint" )[1];
	SW.EnvFog = ents.FindByClass( "env_fog_controller" )[1];
	SW.SkyCam = ents.FindByClass( "sky_camera" )[1];
	
	if( SW.EnvFog and SW.EnvFog:IsValid() ) then
		
		SW.FogSettings = SW.EnvFog:GetSaveTable();
		
	end
	
	if( SW.SkyCam and SW.SkyCam:IsValid() ) then
		
		SW.SkyboxFogSettings = SW.SkyCam:GetSaveTable();
		
	end
	
	if( SW.UpdateLighting ) then
		
		if( SW.LightEnvironment ) then -- Credit to looter's atmos addon for this hack
			
			SW.LightEnvironment:Fire( "FadeToPattern", "a" );
			
		else
			
			SW.UpdateLightStyle( "b" );
			
		end
		
	end
	
	if( SW.UpdateSun and SW.Sun and SW.Sun:IsValid() ) then
		
		SW.Sun:SetKeyValue( "sun_dir", "1 0 0" );
		
	end
	
	if( SW.UpdateSkybox and ( !SW.SkyPaint or !SW.SkyPaint:IsValid() ) ) then
		
		SW.SkyPaint = ents.Create( "env_skypaint" );
		SW.SkyPaint:Spawn();
		SW.SkyPaint:Activate();
		
	end
	
	SW.SkyPaintValues = SW.SkyColors[SW_TIME_NIGHT];
	
	if( SW.UpdateSkybox and SW.SkyPaint and SW.SkyPaint:IsValid() ) then
		
		SW.SkyPaint:SetStarTexture( "skybox/starfield" );
		SW.SkyPaint:SetStarScale( 0.5 );
		SW.SkyPaint:SetStarFade( 1.5 );
		SW.SkyPaint:SetStarSpeed( SW.StarRotateSpeed );
		SW.SkyPaint:SetTopColor( SW.SkyPaintValues.TopColor );
		SW.SkyPaint:SetBottomColor( SW.SkyPaintValues.BottomColor );
		SW.SkyPaint:SetFadeBias( SW.SkyPaintValues.FadeBias );
		SW.SkyPaint:SetHDRScale( SW.SkyPaintValues.HDRScale );
		SW.SkyPaint:SetDuskIntensity( SW.SkyPaintValues.DuskIntensity );
		SW.SkyPaint:SetDuskScale( SW.SkyPaintValues.DuskScale );
		SW.SkyPaint:SetDuskColor( SW.SkyPaintValues.DuskColor );
		SW.SkyPaint:SetSunColor( SW.SkyPaintValues.SunColor );
		
	end
	
end
hook.Add( "InitPostEntity", "SW.InitPostEntity", SW.InitPostEntity );

SW.LastTimePeriod = SW_TIME_NIGHT;

function SW.GetRealTime()
	
	local tab = os.date( "*t" );
	
	return tab.hour + tab.min / 60 + tab.sec / 3600;
	
end

function SW.DayNightThink()
	
	if( !SW.TimePaused ) then
		
		if( SW.Time >= 20 or SW.Time < 4 ) then
			
			SW.Time = SW.Time + FrameTime() * SW.NightTimeMul;
			
		else
			
			SW.Time = SW.Time + FrameTime() * SW.DayTimeMul;
			
		end
		
		if( SW.Realtime ) then
			
			SW.Time = SW.GetRealTime();
			
		end
		
	end
	
	if( SW.Time >= 24 ) then
		
		SW.Time = 0;
		
	end
	
	local mul = 0; -- Credit to looter's atmos addon for this math
	
	if( SW.Time >= 4 and SW.Time < 12 ) then
		
		mul = math.EaseInOut( ( SW.Time - 4 ) / 8, 0, 1 );
		
	elseif( SW.Time >= 12 and SW.Time < 20 ) then
		
		mul = math.EaseInOut( 1 - ( SW.Time - 12 ) / 8, 1, 0 );
		
	end
	
	local s = string.char( math.Round( Lerp( mul, string.byte( SW.MaxDarkness ), string.byte( SW.MaxLightness ) ) ) );
	
	if( SW.WeatherMode > SW_NOWEATHER ) then
		
		s = string.char( math.Round( Lerp( mul, string.byte( SW.MaxDarkness ), string.byte( SW.MaxLightnessStorm ) ) ) );
		
	end
	
	if( SW.UpdateLighting and SW.LastStyle != s ) then
		
		if( SW.LightEnvironment and SW.LightEnvironment:IsValid() ) then
			
			SW.LightEnvironment:Fire( "FadeToPattern", s );
			
		else
			
			SW.UpdateLightStyle( s );
			
		end
		
		SW.LastStyle = s;
		
	end
	
	if( SW.UpdateSun and SW.Sun and SW.Sun:IsValid() ) then
		
		if( SW.Time > 4 and SW.Time < 20 ) then
			
			local mul = 1 - ( SW.Time - 4 ) / 16;
			SW.Sun:SetKeyValue( "sun_dir", tostring( Angle( -180 * mul, 20, 0 ):Forward() ) );
			
		end
		
		if( SW.WeatherMode > SW_NOWEATHER or SW.Time < 4 or SW.Time > 20 ) then
			
			SW.Sun:Fire( "TurnOff" );
			
		else
			
			SW.Sun:Fire( "TurnOn" );
			
		end
		
	end
	
	if( SW.Time < 6 ) then
		
		SW.LastTimePeriod = SW_TIME_DUSK;
		
	elseif( SW.Time < 18 ) then
		
		if( SW.LastTimePeriod != SW_TIME_DAWN ) then
			
			if( SW.UpdateFog ) then
				
				net.Start( "SW.nSetTimePeriod" );
					net.WriteFloat( SW_TIME_DAWN );
				net.Broadcast();
				
			end
			
			if( SW.FireOutputs ) then
				
				for _, v in pairs( ents.FindByName( "dawn" ) ) do
					
					v:Fire( "Trigger" );
					
				end
				
			end
			
		end
		
		SW.LastTimePeriod = SW_TIME_DAWN;
		
	else
		
		if( SW.LastTimePeriod != SW_TIME_DUSK ) then
			
			if( SW.UpdateFog ) then
				
				net.Start( "SW.nSetTimePeriod" );
					net.WriteFloat( SW_TIME_DUSK );
				net.Broadcast();
				
			end
			
			if( SW.FireOutputs ) then
				
				for _, v in pairs( ents.FindByName( "dusk" ) ) do
					
					v:Fire( "Trigger" );
					
				end
				
			end
			
		end
		
		SW.LastTimePeriod = SW_TIME_DUSK;
		
	end
	
	if( SW.UpdateSkybox and SW.SkyPaint and SW.SkyPaint:IsValid() ) then
		
		local skypaintgoal;
		
		if( SW.Time < 4 ) then
			
			skypaintgoal = SW.SkyColors[SW_TIME_NIGHT];
			
		elseif( SW.Time < 6 ) then
			
			skypaintgoal = SW.SkyColors[SW_TIME_DAWN];
			
		elseif( SW.Time < 18 ) then
			
			skypaintgoal = SW.SkyColors[SW_TIME_AFTERNOON];
			
		elseif( SW.Time < 20 ) then
			
			skypaintgoal = SW.SkyColors[SW_TIME_DUSK];
			
		else
			
			skypaintgoal = SW.SkyColors[SW_TIME_NIGHT];
			
		end
		
		if( SW.WeatherMode > SW_NOWEATHER ) then
			
			if( SW.Time >= 20 or SW.Time <= 4 ) then
				
				skypaintgoal = SW.SkyColors[SW_TIME_WEATHER_NIGHT];
				
			else
				
				skypaintgoal = SW.SkyColors[SW_TIME_WEATHER];
				
			end
			
		end
		
		if( SW.WeatherMode > SW_NOWEATHER ) then
			
			SW.SkyPaint:SetStarTexture( "skybox/clouds" );
			SW.SkyPaint:SetStarScale( 1 );
			SW.SkyPaint:SetStarFade( 0.4 );
			SW.SkyPaint:SetStarSpeed( 0.03 );
			
		else
			
			SW.SkyPaint:SetStarTexture( "skybox/starfield" );
			SW.SkyPaint:SetStarScale( 0.5 );
			SW.SkyPaint:SetStarFade( 1.5 );
			SW.SkyPaint:SetStarSpeed( SW.StarRotateSpeed );
			
		end
		
		local shouldUpdate = false;
		
		for k, v in pairs( SW.SkyPaintValues ) do
			
			if( v != skypaintgoal[k] ) then
				
				shouldUpdate = true;
				
			end
			
		end
		
		if( shouldUpdate ) then
			
			local mul = SW.DayTimeMul / 50;
			
			if( SW.Time >= 20 or SW.Time < 4 ) then
				
				mul = SW.NightTimeMul / 50;
				
			end
			
			SW.SkyPaintValues.TopColor.r = math.Approach( SW.SkyPaintValues.TopColor.r, skypaintgoal.TopColor.r, mul );
			SW.SkyPaintValues.TopColor.g = math.Approach( SW.SkyPaintValues.TopColor.g, skypaintgoal.TopColor.g, mul );
			SW.SkyPaintValues.TopColor.b = math.Approach( SW.SkyPaintValues.TopColor.b, skypaintgoal.TopColor.b, mul );
			SW.SkyPaintValues.BottomColor.r = math.Approach( SW.SkyPaintValues.BottomColor.r, skypaintgoal.BottomColor.r, mul );
			SW.SkyPaintValues.BottomColor.g = math.Approach( SW.SkyPaintValues.BottomColor.g, skypaintgoal.BottomColor.g, mul );
			SW.SkyPaintValues.BottomColor.b = math.Approach( SW.SkyPaintValues.BottomColor.b, skypaintgoal.BottomColor.b, mul );
			SW.SkyPaintValues.FadeBias = math.Approach( SW.SkyPaintValues.FadeBias, skypaintgoal.FadeBias, mul * 2 );
			SW.SkyPaintValues.HDRScale = math.Approach( SW.SkyPaintValues.HDRScale, skypaintgoal.HDRScale, mul * 2 );
			SW.SkyPaintValues.DuskIntensity = math.Approach( SW.SkyPaintValues.DuskIntensity, skypaintgoal.DuskIntensity, mul * 2 );
			SW.SkyPaintValues.DuskScale = math.Approach( SW.SkyPaintValues.DuskScale, skypaintgoal.DuskScale, mul * 2 );
			SW.SkyPaintValues.DuskColor.r = math.Approach( SW.SkyPaintValues.DuskColor.r, skypaintgoal.DuskColor.r, mul );
			SW.SkyPaintValues.DuskColor.g = math.Approach( SW.SkyPaintValues.DuskColor.g, skypaintgoal.DuskColor.g, mul );
			SW.SkyPaintValues.DuskColor.b = math.Approach( SW.SkyPaintValues.DuskColor.b, skypaintgoal.DuskColor.b, mul );
			SW.SkyPaintValues.SunColor.r = math.Approach( SW.SkyPaintValues.SunColor.r, skypaintgoal.SunColor.r, mul );
			SW.SkyPaintValues.SunColor.g = math.Approach( SW.SkyPaintValues.SunColor.g, skypaintgoal.SunColor.g, mul );
			SW.SkyPaintValues.SunColor.b = math.Approach( SW.SkyPaintValues.SunColor.b, skypaintgoal.SunColor.b, mul );
			SW.SkyPaintValues.SunSize = math.Approach( SW.SkyPaintValues.SunSize, skypaintgoal.SunSize, mul * 2 );
			
			SW.SkyPaint:SetTopColor( SW.SkyPaintValues.TopColor );
			SW.SkyPaint:SetBottomColor( SW.SkyPaintValues.BottomColor );
			SW.SkyPaint:SetFadeBias( SW.SkyPaintValues.FadeBias );
			SW.SkyPaint:SetHDRScale( SW.SkyPaintValues.HDRScale );
			SW.SkyPaint:SetDuskIntensity( SW.SkyPaintValues.DuskIntensity );
			SW.SkyPaint:SetDuskScale( SW.SkyPaintValues.DuskScale );
			SW.SkyPaint:SetDuskColor( SW.SkyPaintValues.DuskColor );
			SW.SkyPaint:SetSunColor( SW.SkyPaintValues.SunColor );
			
		end
		
		if( SW.Time > 4 and SW.Time < 20 and SW.Weather == SW_NOWEATHER ) then
			
			SW.SkyPaint:SetSunSize( SW.SkyPaintValues.SunSize );
			
		else
			
			SW.SkyPaint:SetSunSize( 0 );
			
		end
		
	end
	
end

function SW.SetTime( t )
	
	SW.Time = t;
	
	if( SW.UpdateSkybox and SW.SkyPaint and SW.SkyPaint:IsValid() ) then
		
		local skypaintgoal = SW.SkyColors[SW_TIME_NIGHT];
		
		if( SW.Time < 4 ) then
			
			skypaintgoal = SW.SkyColors[SW_TIME_NIGHT];
			
		elseif( SW.Time < 6 ) then
			
			skypaintgoal = SW.SkyColors[SW_TIME_DAWN];
			
		elseif( SW.Time < 18 ) then
			
			skypaintgoal = SW.SkyColors[SW_TIME_AFTERNOON];
			
		elseif( SW.Time < 20 ) then
			
			skypaintgoal = SW.SkyColors[SW_TIME_DUSK];
			
		else
			
			skypaintgoal = SW.SkyColors[SW_TIME_NIGHT];
			
		end
		
		if( SW.WeatherMode > SW_NOWEATHER ) then
			
			if( SW.Time >= 20 or SW.Time <= 4 ) then
				
				skypaintgoal = SW.SkyColors[SW_TIME_WEATHER_NIGHT];
				
			else
				
				skypaintgoal = SW.SkyColors[SW_TIME_WEATHER];
				
			end
			
		end
		
		SW.SkyPaintValues = skypaintgoal;
		
		SW.SkyPaint:SetTopColor( skypaintgoal.TopColor );
		SW.SkyPaint:SetBottomColor( skypaintgoal.BottomColor );
		SW.SkyPaint:SetFadeBias( skypaintgoal.FadeBias );
		SW.SkyPaint:SetHDRScale( skypaintgoal.HDRScale );
		SW.SkyPaint:SetDuskIntensity( skypaintgoal.DuskIntensity );
		SW.SkyPaint:SetDuskScale( skypaintgoal.DuskScale );
		SW.SkyPaint:SetDuskColor( skypaintgoal.DuskColor );
		SW.SkyPaint:SetSunColor( skypaintgoal.SunColor );
		
		if( SW.WeatherMode > SW_NOWEATHER ) then
			
			SW.SkyPaint:SetStarTexture( "skybox/clouds" );
			SW.SkyPaint:SetStarScale( 1 );
			SW.SkyPaint:SetStarFade( 0.4 );
			SW.SkyPaint:SetStarSpeed( 0.03 );
			
		else
			
			SW.SkyPaint:SetStarTexture( "skybox/starfield" );
			SW.SkyPaint:SetStarScale( 0.5 );
			SW.SkyPaint:SetStarFade( 1.5 );
			SW.SkyPaint:SetStarSpeed( SW.StarRotateSpeed );
			
		end
		
	end
	
	local mul = 0;
	
	if( SW.Time >= 4 and SW.Time < 12 ) then
		
		mul = math.EaseInOut( ( SW.Time - 4 ) / 8, 0, 1 );
		
	elseif( SW.Time >= 12 and SW.Time < 20 ) then
		
		mul = math.EaseInOut( 1 - ( SW.Time - 12 ) / 8, 1, 0 );
		
	end
	
	local s = string.char( math.Round( Lerp( mul, string.byte( SW.MaxDarkness ), string.byte( SW.MaxLightness ) ) ) );
	
	if( SW.WeatherMode > SW_NOWEATHER ) then
		
		s = string.char( math.Round( Lerp( mul, string.byte( SW.MaxDarkness ), string.byte( SW.MaxLightnessStorm ) ) ) );
		
	end
	
	if( SW.UpdateLighting and SW.LastStyle != s ) then
		
		if( SW.LightEnvironment and SW.LightEnvironment:IsValid() ) then
			
			SW.LightEnvironment:Fire( "FadeToPattern", s );
			
		else
			
			SW.UpdateLightStyle( s );
			
		end
		
		SW.LastStyle = s;
		
	end
	
	if( SW.Sun and SW.Sun:IsValid() ) then
		
		SW.Sun:SetKeyValue( "sun_dir", "1 0 0" );
		
	end
	
	if( SW.Time > 6 and SW.Time < 18 and SW.UpdateFog ) then
		
		net.Start( "SW.nSetTimePeriod" );
			net.WriteFloat( SW_TIME_DAWN );
		net.Broadcast();
		
	else
		
		net.Start( "SW.nSetTimePeriod" );
			net.WriteFloat( SW_TIME_DUSK );
		net.Broadcast();
		
	end
	
end

if( SW.Realtime ) then
	
	SW.Time = SW.GetRealTime();
	
end

function SW.PauseTime( b )
	
	SW.TimePaused = b;
	
end