SW = SW or { };

SW_NOWEATHER = 0;
SW_RAIN = 1;
SW_SNOW = 2;
SW_STORM = 3;
SW_FOG = 4;

SW_AUTO_RAIN = 1;
SW_AUTO_SNOW = 2;
SW_AUTO_STORM = 4;
SW_AUTO_FOG = 8;

AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "cl_daynight.lua" );
AddCSLuaFile( "simpleweather_config.lua" );
AddCSLuaFile( "sh_admin.lua" );

include( "simpleweather_config.lua" );
include( "sv_daynight.lua" );
include( "sh_admin.lua" );

resource.AddWorkshop( 218917501 );

SW.WeatherMode = SW_NOWEATHER;
SW.NextRandomWeather = math.random( SW.AutoMinTimeStartWeather * 60 * 60, SW.AutoMaxTimeStartWeather * 60 * 60 );

function SW.SetWeather( i )
	
	SW.WeatherMode = i;
	
	net.Start( "SW.nSetWeather" );
		net.WriteFloat( i );
	net.Broadcast();
	
end

util.AddNetworkString( "SW.nSetWeather" );
util.AddNetworkString( "SW.nRedownloadLightmaps" );

function SW.Think()
	
	if( SW.AutoWeatherEnabled and CurTime() > SW.NextRandomWeather ) then
		
		if( SW.WeatherMode == SW_NOWEATHER ) then
			
			local types = { };
			
			if( bit.band( SW.AutoWeatherType, SW_AUTO_RAIN ) == SW_AUTO_RAIN ) then
				table.insert( types, SW_RAIN );
			end
			
			if( bit.band( SW.AutoWeatherType, SW_AUTO_SNOW ) == SW_AUTO_SNOW ) then
				table.insert( types, SW_SNOW );
			end
			
			if( bit.band( SW.AutoWeatherType, SW_AUTO_STORM ) == SW_AUTO_STORM ) then
				table.insert( types, SW_STORM );
			end
			
			if( bit.band( SW.AutoWeatherType, SW_AUTO_FOG ) == SW_AUTO_FOG ) then
				table.insert( types, SW_FOG );
			end
			
			SW.SetWeather( table.Random( types ) );
			SW.NextRandomWeather = CurTime() + math.Rand( SW.AutoMinTimeStopWeather * 60 * 60, SW.AutoMaxTimeStopWeather * 60 * 60 );
			
		else
			
			SW.SetWeather( SW_NOWEATHER );
			SW.NextRandomWeather = CurTime() + math.Rand( SW.AutoMinTimeStartWeather * 60 * 60, SW.AutoMaxTimeStartWeather * 60 * 60 );
			
		end
		
	end
	
	SW.DayNightThink();
	
end
hook.Add( "Think", "SW.Think", SW.Think );

function SW.PlayerInitialSpawn( ply )
	
	net.Start( "SW.nSetWeather" );
		net.WriteFloat( SW.WeatherMode );
	net.Send( ply );
	
	if( SW.FogSettings and SW.UpdateFog ) then
		
		net.Start( "SW.nInitFogSettings" );
			net.WriteTable( SW.FogSettings );
		net.Send( ply );
		
	end
	
	if( SW.SkyboxFogSettings and SW.UpdateFog ) then
		
		net.Start( "SW.nInitSkyboxFogSettings" );
			net.WriteTable( SW.SkyboxFogSettings );
		net.Send( ply );
		
	end
	
end
hook.Add( "PlayerInitialSpawn", "SW.PlayerInitialSpawn", SW.PlayerInitialSpawn );

function SW.Initialize()
	
	SW.InitDayNight();
	
end
hook.Add( "Initialize", "SW.Initialize", SW.Initialize );