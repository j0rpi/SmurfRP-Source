function ulx.weather( ply, type )
	
	if( type == "none" ) then
		
		SW.SetWeather( SW_NOWEATHER );
		
	elseif( type == "rain" ) then
		
		SW.SetWeather( SW_RAIN );
		
	elseif( type == "storm" ) then
		
		SW.SetWeather( SW_STORM );
		
	elseif( type == "snow" ) then
		
		SW.SetWeather( SW_SNOW );
		
	elseif( type == "fog" ) then
		
		SW.SetWeather( SW_FOG );
		
	end
	
	ulx.fancyLogAdmin( ply, "#A set weather to #s", type );
	
end
local weather = ulx.command( "SimpleWeather", "ulx weather", ulx.weather, "!weather" )
weather:addParam{ type=ULib.cmds.StringArg, completes={ "none", "rain", "storm", "snow", "fog" }, hint="type", error="invalid weather type \"%s\" specified", ULib.cmds.restrictToCompletes }
weather:defaultAccess( ULib.ACCESS_ADMIN )
weather:help( "Change the weather." )

function ulx.stopweather( ply )
	
	SW.SetWeather( SW_NOWEATHER );
	ulx.fancyLogAdmin( ply, "#A turned off weather" );
	
end
local weather = ulx.command( "SimpleWeather", "ulx stopweather", ulx.stopweather, "!stopweather" )
weather:defaultAccess( ULib.ACCESS_ADMIN )
weather:help( "Stop the weather." )

function ulx.autoweather( ply, enabled )
	
	SW.AutoWeatherEnabled = enabled;
	ulx.fancyLogAdmin( ply, "#A set auto-weather to #s", tostring( enabled ) );
	
end
local weather = ulx.command( "SimpleWeather", "ulx autoweather", ulx.autoweather, "!autoweather" )
weather:addParam{ type=ULib.cmds.BoolArg, hint="enabled" }
weather:defaultAccess( ULib.ACCESS_ADMIN )
weather:help( "Change auto-weather on or off." )

function ulx.settime( ply, time )
	
	SW.SetTime( time );
	ulx.fancyLogAdmin( ply, "#A set time to #s", tostring( time ) );
	
end
local weather = ulx.command( "SimpleWeather", "ulx settime", ulx.settime, "!settime" )
weather:addParam{ type=ULib.cmds.NumArg, min=0, max=24, default=0, hint="time", error="invalid time \"%s\" specified", ULib.cmds.restrictToCompletes }
weather:defaultAccess( ULib.ACCESS_ADMIN )
weather:help( "Change the time." )

function ulx.enabletime( ply, enabled )
	
	SW.PauseTime( !enabled );
	ulx.fancyLogAdmin( ply, "#A set the passage of time to #s", tostring( enabled ) );
	
end
local weather = ulx.command( "SimpleWeather", "ulx enabletime", ulx.enabletime, "!enabletime" )
weather:addParam{ type=ULib.cmds.BoolArg, hint="enabled" }
weather:defaultAccess( ULib.ACCESS_ADMIN )
weather:help( "Change the passage of time on or off." )