SW_TIME_DAWN = 6;
SW_TIME_AFTERNOON = 12;
SW_TIME_DUSK = 18;
SW_TIME_NIGHT = 24;

SW_TIME_WEATHER = 1;
SW_TIME_WEATHER_NIGHT = 2;

SW.TimePeriod = SW_TIME_DUSK;

SW.CurFogDensity = 1;

function SW.nInitFogSettings( len )
	
	SW.FogSettings = net.ReadTable();
	
end
net.Receive( "SW.nInitFogSettings", SW.nInitFogSettings );

function SW.nInitSkyboxFogSettings( len )
	
	SW.SkyboxFogSettings = net.ReadTable();
	
end
net.Receive( "SW.nInitSkyboxFogSettings", SW.nInitSkyboxFogSettings );

function SW.nSetTimePeriod( len )
	
	SW.TimePeriod = net.ReadFloat();
	
end
net.Receive( "SW.nSetTimePeriod", SW.nSetTimePeriod );

function SW.DayNightThink()
	
	if( !SW.UpdateFog ) then return end
	if( !SW.FogSettings ) then return end
	
	if( SW.TimePeriod == SW_TIME_DUSK ) then
		
		SW.CurFogDensity = math.Clamp( SW.CurFogDensity - 0.001, 0, SW.FogSettings.fogmaxdensity );
		
	else
		
		SW.CurFogDensity = math.Clamp( SW.CurFogDensity + 0.001, 0, SW.FogSettings.fogmaxdensity );
		
	end
	
end

function SW.SetupWorldFog()
	
	if( !SW.UpdateFog ) then return false end
	if( !SW.FogSettings or SW.CurFogDensity == 1 ) then return false end
	
	render.FogMode( MATERIAL_FOG_LINEAR );
	render.FogStart( SW.FogSettings.fogstart );
	render.FogEnd( SW.FogSettings.fogend );
	render.FogMaxDensity( SW.CurFogDensity );
	
	local col = string.Explode( " ", SW.FogSettings.fogcolor );
	render.FogColor( col[1], col[2], col[3] );

	return true;
	
end
hook.Add( "SetupWorldFog", "SW.SetupWorldFog", SW.SetupWorldFog );

function SW.SetupSkyboxFog( scale )
	
	if( !SW.UpdateFog ) then return false end
	if( !SW.SkyboxFogSettings or SW.CurFogDensity == 1 ) then return false end
	
	render.FogMode( MATERIAL_FOG_LINEAR );
	render.FogStart( SW.SkyboxFogSettings.fogstart * scale );
	render.FogEnd( SW.SkyboxFogSettings.fogend * scale  );
	render.FogMaxDensity( SW.CurFogDensity );

	local col = string.Explode( " ", SW.SkyboxFogSettings.fogcolor );
	render.FogColor( col[1], col[2], col[3] );
	
	return true;
	
end
hook.Add( "SetupSkyboxFog", "SW.SetupSkyboxFog", SW.SetupSkyboxFog );