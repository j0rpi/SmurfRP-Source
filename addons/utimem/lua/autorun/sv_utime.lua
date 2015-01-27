-- Written by Team Ulysses, http://ulyssesmod.net/
-- Modified by ACProdigy for MySQL operation
-- Modified by MRDRMUFN for gm_mysqloo support
-- Modified by TweaK for more reliable operation

if not SERVER then return end

module( "Utime", package.seeall )

require( "mysqloo" )

----- Database connection details -----

local DATABASE_HOST = "mysql13.citynetwork.se"
local DATABASE_USERNAME = "122056-fi85712"
local DATABASE_PASSWORD = "valvehelpedme"
local DATABASE_PORT = 3306
local DATABASE_NAME = "122056-darkrp"

--=== DO NOT EDIT BELOW THIS POINT ===--

local utime_welcome = CreateConVar( "utime_welcome", "1", FCVAR_ARCHIVE )
local queue = {}

local db = mysqloo.connect( DATABASE_HOST, DATABASE_USERNAME, DATABASE_PASSWORD, DATABASE_NAME, DATABASE_PORT )

local function query( str, callback )
	local q = db:query( str )
	
	function q:onSuccess( data )
		callback( data )
	end
	
	function q:onError( err )
		if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
			table.insert( queue, { str, callback } )
			db:connect()
		return end
		
		print( "[UTime] Error! Query failed: " .. err )
	end
	
	q:start()
end

function db:onConnected()
	print( "[UTime] Connected to MySQL." )
	
	for k, v in pairs( queue ) do
		query( v[ 1 ], v[ 2 ] )
	end
	
	queue = {}
end

function db:onConnectionFailed( err )
	print( "[UTime] Database connection failed: " .. err )
end

db:connect()

-- Check that the table exists, create it if not
table.insert( queue, { "SHOW TABLES LIKE 'utime'", function( data )
	if table.Count( data ) < 1 then -- the table doesn't exist
		query( "CREATE TABLE utime (id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT, player INTEGER UNSIGNED NOT NULL, totaltime INTEGER UNSIGNED NOT NULL, lastvisit INTEGER UNSIGNED NOT NULL, steamid VARCHAR(45) NOT NULL, playername VARCHAR(100) NOT NULL, PRIMARY KEY (id))", function( data )
			print( "[UTime] Successfully created table!" )
		end )
	end
end } )

function PlayerJoined( ply )
	local uid = ply:UniqueID()
	local sid = ply:SteamID()
	
	query( "SELECT totaltime, lastvisit FROM utime WHERE player = " .. uid, function( data )
		local time = 0
		
		if table.Count( data ) > 0 then -- player exists
			row = data[ 1 ]
			if utime_welcome:GetBool() then
				ULib.tsay( ply, "Welcome back! You last played here on " .. os.date( "%a, %b %d, %Y", row.lastvisit ) )
			end
			
			-- update lastvisit time
			query( "UPDATE utime SET lastvisit = " .. os.time() .. " WHERE player = " .. uid, function() end )
			
			time = row.totaltime
		else -- player does not exist
			if utime_welcome:GetBool() then
				-- ULib.tsay( ply, "[UTime]Welcome to our server " .. ply:Nick() .. "!" )
				ULib.tsay( ply, "Welcome to our server " .. ply:Nick() .. "!" )
			end
			
			-- create the player
			query( "INSERT into utime ( player, totaltime, lastvisit, steamid, playername ) VALUES ( " ..
				uid .. ", 0, " .. os.time() .. ", '" .. sid .. "', '" .. db:escape( ply:Nick() ) .. "' )", 
				function() print( "[UTime] Successfully created new player " .. ply:Nick() .. "." ) end )
		end
		
		ply:SetUTime( time )
		ply:SetUTimeStart( CurTime() )
		ply.UTimeLoaded = true
	end )
end
hook.Add( "PlayerInitialSpawn", "UTimeInitialSpawn", PlayerJoined )

function UpdatePlayer( ply )
	query( "UPDATE utime SET totaltime = " .. math.floor( ply:GetUTimeTotalTime() ) .. ", steamid = '" .. 
	ply:SteamID() .. "', playername = '" .. db:escape( ply:Nick() ) .. "' WHERE player = " .. 
	ply:UniqueID() .. ";", function() end )
end
hook.Add( "PlayerDisconnected", "UTimeDisconnect", UpdatePlayer )

function UpdateAll()
	for _, ply in pairs( player.GetAll() ) do
		if IsValid( ply ) and ply:IsConnected() and ply.UTimeLoaded then
			UpdatePlayer( ply )
		end
	end
end
timer.Create( "UTimeTimer", 67, 0, UpdateAll )
