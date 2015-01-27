local function Weather( ply, cmd, args )
	
	if( ulx ) then
		
		ply:PrintMessage( 2, "Use ULX instead - the command is \"ulx weather\"." );
		return;
		
	end
	
	if( CLIENT ) then return end
	
	if( ply and ply:IsValid() and !ply:IsAdmin() ) then
		
		ply:PrintMessage( 2, "You need to be admin to do this!" );
		return;
		
	end
	
	if( args[1] == "none" ) then
		
		SW.SetWeather( SW_NOWEATHER );
		
	elseif( args[1] == "rain" ) then
		
		SW.SetWeather( SW_RAIN );
		
	elseif( args[1] == "storm" ) then
		
		SW.SetWeather( SW_STORM );
		
	elseif( args[1] == "snow" ) then
		
		SW.SetWeather( SW_SNOW );
		
	elseif( args[1] == "fog" ) then
		
		SW.SetWeather( SW_FOG );
		
	else
		
		ply:PrintMessage( 2, "ERROR: invalid weather type \"" .. tostring( args[1] ) .. "\" specified." );
		
	end
	
end
concommand.Add( "sw_weather", Weather, function() return { "sw_weather none", "sw_weather rain", "sw_weather storm", "sw_weather snow", "sw_weather fog" } end, "Change the weather." );

local function StopWeather( ply, cmd, args )
	
	if( ulx ) then
		
		ply:PrintMessage( 2, "Use ULX instead - the command is \"ulx stopweather\"." );
		return;
		
	end
	
	if( CLIENT ) then return end
	
	if( ply and ply:IsValid() and !ply:IsAdmin() ) then
		
		ply:PrintMessage( 2, "You need to be admin to do this!" );
		return;
		
	end
	
	SW.SetWeather( SW_NOWEATHER );
	
end
concommand.Add( "sw_stopweather", StopWeather, function() return { } end, "Stop the weather." );

local function AutoWeather( ply, cmd, args )
	
	if( ulx ) then
		
		ply:PrintMessage( 2, "Use ULX instead - the command is \"ulx autoweather\"." );
		return;
		
	end
	
	if( CLIENT ) then return end
	
	if( ply and ply:IsValid() and !ply:IsAdmin() ) then
		
		ply:PrintMessage( 2, "You need to be admin to do this!" );
		return;
		
	end
	
	if( args[1] == "0" ) then
		
		SW.AutoWeatherEnabled = false;
		
	elseif( args[1] == "1" ) then
		
		SW.AutoWeatherEnabled = true;
		
	else
		
		ply:PrintMessage( 2, "ERROR: invalid auto-weather status \"" .. tostring( args[1] ) .. "\" specified." );
		
	end
	
end
concommand.Add( "sw_autoweather", AutoWeather, function() return { "sw_autoweather 0", "sw_autoweather 1" } end, "Change auto-weather on or off." );

local function SetTime( ply, cmd, args )
	
	if( ulx ) then
		
		ply:PrintMessage( 2, "Use ULX instead - the command is \"ulx settime\"." );
		return;
		
	end
	
	if( CLIENT ) then return end
	
	if( ply and ply:IsValid() and !ply:IsAdmin() ) then
		
		ply:PrintMessage( 2, "You need to be admin to do this!" );
		return;
		
	end
	
	if( tonumber( args[1] ) and tonumber( args[1] ) >= 0 and tonumber( args[1] ) <= 24 ) then
		
		SW.SetTime( tonumber( args[1] ) );
		
	else
		
		ply:PrintMessage( 2, "ERROR: invalid time \"" .. tostring( args[1] ) .. "\" specified." );
		
	end
	
end
concommand.Add( "sw_settime", SetTime, function() return { "sw_settime (0-24)" } end, "Set the time of day." );

local function EnableTime( ply, cmd, args )
	
	if( ulx ) then
		
		ply:PrintMessage( 2, "Use ULX instead - the command is \"ulx enabletime\"." );
		return;
		
	end
	
	if( CLIENT ) then return end
	
	if( ply and ply:IsValid() and !ply:IsAdmin() ) then
		
		ply:PrintMessage( 2, "You need to be admin to do this!" );
		return;
		
	end
	
	if( args[1] == "0" ) then
		
		SW.PauseTime( true );
		
	elseif( args[1] == "1" ) then
		
		SW.PauseTime( false );
		
	else
		
		ply:PrintMessage( 2, "ERROR: invalid value \"" .. tostring( args[1] ) .. "\" specified." );
		
	end
	
end
concommand.Add( "sw_enabletime", EnableTime, function() return { "sw_pausetime 0", "sw_pausetime 1" } end, "Change the passage of time on or off." );