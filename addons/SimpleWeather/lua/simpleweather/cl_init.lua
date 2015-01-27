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

include( "cl_daynight.lua" );
include( "simpleweather_config.lua" );
include( "sh_admin.lua" );

SW.WeatherMode = SW_NOWEATHER;
SW.CurrentParticles = 0;

local function nSetWeather()
	
	SW.WeatherMode = net.ReadFloat();
	
end
net.Receive( "SW.nSetWeather", nSetWeather );

local function nRedownloadLightmaps()
	
	render.RedownloadAllLightmaps();
	
end
net.Receive( "SW.nRedownloadLightmaps", nRedownloadLightmaps );

SW.NextLightning = 0;
SW.ViewPos = Vector();
SW.ViewAng = Angle();
SW.SkyboxVisible = false;
SW.IsOutsideFrame = false;

if( SW.Emitter2D ) then
	
	SW.Emitter2D:Finish();
	
end

if( SW.Emitter3D ) then
	
	SW.Emitter3D:Finish();
	
end

SW.Emitter2D = nil;
SW.Emitter3D = nil;

function SW.Think()
	
	if( LocalPlayer():GetViewEntity() == LocalPlayer() ) then
		
		local s = GAMEMODE:CalcView( LocalPlayer(), LocalPlayer():EyePos(), LocalPlayer():EyeAngles(), 75 );
		SW.ViewPos = s.origin;
		SW.ViewAng = s.angles;
		
	else
		
		SW.ViewPos = LocalPlayer():GetViewEntity():GetPos();
		SW.ViewAng = LocalPlayer():GetViewEntity():GetAngles();
		
	end
	
	if( !SW.ViewPos or !SW.ViewAng ) then
		
		SW.ViewPos = LocalPlayer():EyePos();
		SW.ViewAng = LocalPlayer():EyeAngles();
		
	end
	
	SW.SkyboxVisible = util.IsSkyboxVisibleFromPoint( SW.ViewPos );
	SW.IsOutsideFrame = SW.IsOutside( SW.ViewPos );
	
	if( SW.WeatherMode == SW_NOWEATHER ) then
		
		if( SW.Emitter2D ) then
			
			SW.Emitter2D:Finish();
			SW.Emitter2D = nil;
			
		end
		
		if( SW.Emitter3D ) then
			
			SW.Emitter3D:Finish();
			SW.Emitter3D = nil;
			
		end
		
	else
		
		if( !SW.Emitter2D ) then
			
			SW.Emitter2D = ParticleEmitter( SW.ViewPos );
			
		else
			
			SW.Emitter2D:SetPos( SW.ViewPos );
			
		end
		
		if( !SW.Emitter3D ) then
			
			SW.Emitter3D = ParticleEmitter( SW.ViewPos, true );
			
		else
			
			SW.Emitter3D:SetPos( SW.ViewPos );
			
		end
		
	end
	
	if( SW.Emitter2D and SW.Emitter3D ) then
		
		if( !SW.SkyboxVisible ) then
			
			SW.Emitter2D:SetNoDraw( true );
			
		else
			
			SW.Emitter2D:SetNoDraw( false );
			
		end
		
	end
	
	if( SW.WeatherMode == SW_RAIN ) then
		
		local drop = EffectData();
			drop:SetOrigin( SW.ViewPos );
			drop:SetScale( 0 );
		util.Effect( "sw_rain", drop );
		
	end
	
	if( SW.WeatherMode == SW_STORM ) then
		
		local drop = EffectData();
			drop:SetOrigin( SW.ViewPos + Vector( -70, -70, 0 ) );
			drop:SetScale( 1 );
		util.Effect( "sw_rain", drop );
		
	end
	
	if( SW.WeatherMode == SW_SNOW ) then
		
		local drop = EffectData();
			drop:SetOrigin( SW.ViewPos );
		util.Effect( "sw_snow", drop );
		
	end
	
	if( CurTime() >= SW.NextLightning ) then
		
		if( SW.WeatherMode == SW_STORM ) then
			
			if( SW.IsOutsideFrame and bit.band( util.PointContents( SW.ViewPos ), CONTENTS_WATER ) != CONTENTS_WATER ) then
				
				SW.Lightning( 0.8, 0.3 );
				
			else
				
				if( SW.SkyboxVisible ) then
					
					SW.Lightning( 0.3, 0.05 );
					
				else
					
					SW.Lightning( 0.5, 0, true );
					
				end
				
			end
			
		end
		
		SW.NextLightning = CurTime() + math.random( SW.ThunderMinDelay, SW.ThunderMaxDelay );
		
	end
	
	SW.SoundThink();
	SW.DayNightThink();
	
end
hook.Add( "Think", "SW.Think", SW.Think );

SW.Sound = nil;
SW.SoundVolume = 0;

SW.HeightMin = 0;

function SW.IsOutside( pos )
	
	local trace = { };
	trace.start = pos;
	trace.endpos = trace.start + Vector( 0, 0, 32768 );
	trace.mask = MASK_SOLID;
	local tr = util.TraceLine( trace );
	
	SW.HeightMin = ( tr.HitPos - trace.start ):Length();
	
	if( tr.StartSolid ) then return false end
	if( tr.HitSky or tr.HitNoDraw ) then return true end
	
	return false;
	
end

function SW.SoundThink()
	
	if( SW.WeatherMode == SW_RAIN or SW.WeatherMode == SW_STORM ) then
		
		if( !SW.Sound ) then
			
			SW.Sound = CreateSound( LocalPlayer(), "simpleweather/rain.wav" );
			SW.Sound:SetSoundLevel( 160 );
			SW.Sound:PlayEx( 0, 100 );
			
		end
		
		if( SW.IsOutsideFrame and SW.SoundVolume != 0.3 ) then
			
			SW.Sound:ChangeVolume( 0.3 * SW.VolumeMultiplier, 1 );
			SW.SoundVolume = 0.3;
			
		elseif( !SW.IsOutsideFrame ) then
			
			if( SW.SkyboxVisible and SW.SoundVolume != 0.15 ) then
				
				SW.Sound:ChangeVolume( 0.15 * SW.VolumeMultiplier, 1 );
				SW.SoundVolume = 0.15;
				
			elseif( !SW.SkyboxVisible and SW.SoundVolume != 0 ) then
				
				SW.Sound:ChangeVolume( 0, 1 );
				SW.SoundVolume = 0;
				
			end
			
		end
		
	elseif( SW.SoundVolume > 0 ) then
		
		SW.Sound:ChangeVolume( 0, 1 );
		SW.SoundVolume = 0;
		
	end
	
end

function SW.Lightning( vol, a, far )
	
	if( far ) then
		
		sound.Play( "simpleweather/thunderfar" .. math.random( 1, 2 ) .. ".mp3", SW.ViewPos, 160, 100, vol * SW.VolumeMultiplier );
		
	elseif( vol > 0 ) then
		
		sound.Play( "simpleweather/thunder" .. math.random( 1, 3 ) .. ".mp3", SW.ViewPos, 160, 100, vol * SW.VolumeMultiplier );
		sound.Play( "simpleweather/lightning" .. math.random( 1, 4 ) .. ".mp3", SW.ViewPos, 160, 100, vol * SW.VolumeMultiplier );
		
	end
	
	if( SW.LightningEnabled and a > 0 ) then
		
		table.insert( SW.HUDLightning, { c = CurTime(), a = a } );
		
	end
	
end

SW.HUDRainDrops = { };
SW.NextHUDRain = 0;
SW.HUDRainMatID = surface.GetTextureID( "simpleweather/warp_ripple3" );

SW.HUDLightning = { };

function SW.HUDPaint()
	
	for k, v in pairs( SW.HUDLightning ) do
		
		if( CurTime() - v.c > 0.4 ) then
			table.remove( SW.HUDLightning, k );
			continue;
		end
		
		surface.SetDrawColor( 255, 255, 255, 255 * ( 0.4 - ( CurTime() - v.c ) ) * v.a );
		surface.DrawRect( 0, 0, ScrW(), ScrH() );
		
	end
	
	if( !SW.RainOnScreen ) then return end
	
	if( ( SW.WeatherMode == SW_RAIN or SW.WeatherMode == SW_STORM ) and SW.IsOutsideFrame and SW.ViewAng.p < 15 and LocalPlayer():WaterLevel() < 3 ) then
		
		if( CurTime() > SW.NextHUDRain ) then
			
			SW.NextHUDRain = CurTime() + math.Rand( SW.RainOnScreenMinDelay, SW.RainOnScreenMaxDelay );
			
			if( SW.WeatherMode == SW_STORM ) then
				
				SW.NextHUDRain = CurTime() + math.Rand( SW.RainOnScreenMinDelay / 2, SW.RainOnScreenMaxDelay / 2 );
				
			end
			
			local t = { };
			t.x = math.random( 0, ScrW() );
			t.y = math.random( 0, ScrH() );
			t.r = math.random( SW.RainOnScreenMinSize, SW.RainOnScreenMaxSize );
			t.c = CurTime();
			
			table.insert( SW.HUDRainDrops, t );
			
		end
		
	end
	
	if( render.GetDXLevel() <= 90 ) then return end
	
	for k, v in pairs( SW.HUDRainDrops ) do
		
		if( CurTime() - v.c > 1 ) then
			table.remove( SW.HUDRainDrops, k );
			continue;
		end
		
		surface.SetDrawColor( 255, 255, 255, 255 * ( 1 - ( CurTime() - v.c ) ) );
		surface.SetTexture( SW.HUDRainMatID );
		surface.DrawTexturedRect( v.x, v.y, v.r, v.r );
		
	end
	
end
hook.Add( "HUDPaint", "SW.HUDPaint", SW.HUDPaint );

SW.ScreenspaceMul = 0;

function SW.RenderScreenspaceEffects()
	
	if( SW.WeatherMode != SW_NOWEATHER and SW.SkyboxVisible ) then
		
		SW.ScreenspaceMul = math.min( SW.ScreenspaceMul + FrameTime() / 2, 1 );
		
	else
		
		SW.ScreenspaceMul = math.max( SW.ScreenspaceMul - FrameTime() / 2, 0 );
		
	end
	
	if( SW.ColormodEnabled ) then
		
		local tab = { };
		
		tab[ "$pp_colour_addr" ] 		= 0;
		tab[ "$pp_colour_addg" ] 		= 0;
		tab[ "$pp_colour_addb" ] 		= 0;
		tab[ "$pp_colour_brightness" ] 	= -0.05 * SW.ScreenspaceMul;
		tab[ "$pp_colour_contrast" ] 	= 1 - 0.15 * SW.ScreenspaceMul;
		tab[ "$pp_colour_colour" ] 		= 1 - 0.25 * SW.ScreenspaceMul;
		tab[ "$pp_colour_mulr" ] 		= 0;
		tab[ "$pp_colour_mulg" ] 		= 0;
		tab[ "$pp_colour_mulb" ] 		= 0;
		
		DrawColorModify( tab );
		
	end
	
end
hook.Add( "RenderScreenspaceEffects", "SW.RenderScreenspaceEffects", SW.RenderScreenspaceEffects );

function SW.InitPostEntity()
	
	render.RedownloadAllLightmaps();
	
end
hook.Add( "InitPostEntity", "SW.InitPostEntity", SW.InitPostEntity );