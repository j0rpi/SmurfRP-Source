
rPrint = {}

rPrint.MinorVersion = 2
rPrint.Revision = 1
rPrint.Version = ([[%u.%u]]):format( rPrint.MinorVersion, rPrint.Revision )

rPrint.DefaultPrinterParams = {}
rPrint.SelectionModes = {
	RECHARGE = 1,
	WITHDRAW = 2,
	PURCHASE_COOLER = 3,
	TRANSFER_OWNERSHIP = 4
}

local events = {}


function rPrint.RegisterEventCallback( event, ident, callback )
	events[event] = events[event] or {}

	if !callback then
		callback = ident
		ident = #events[event] + 1
	else
		rPrint.Assert( type( ident ) == "string", "Invalid callback identifier." )
	end

	events[event][ident] = callback
end

function rPrint.UnregisterEventCallback( event, ident )
	rPrint.Assert( type( ident ) == "string", "Invalid callback identifier." )

	events[event] = events[event] or {}
	events[event][ident] = nil
end

function rPrint.TriggerEvent( event, ... )
	if !events[event] then return end

	for _, cb in pairs( events[event] ) do
		cb( ... )
	end
end

function rPrint.TriggerEventForResult( event, ... )
	if !events[event] then return end

	for _, cb in pairs( events[event] ) do
		local results = { cb( ... ) }

		if #results > 0 then 
			return unpack( results )
		end
	end
end


function rPrint.Error( msg, nohalt, noprefix, level )
	local func = nohalt and ErrorNoHalt or error
	msg = (noprefix and '' or "rPrint: ") .. msg .. '\n'
	level = level or 2

	func( msg, level )
end

function rPrint.Assert( cond, msg )
	if !cond then
		rPrint.Error( msg, false, false, 3 )
	end
end


function rPrint.RegisterPrinterType( pname, params, entname )
	params = params or {}
	entname = entname or ("rprint_" .. pname:lower():gsub( [=[[^%a%d]+]=], '_' ) .. "printer")

	local ENT = {}
	ENT.Type = "anim"
	ENT.Base = "rprint_base"
	ENT.PrintName = pname .. " Printer"
	ENT.Spawnable = false
	ENT.AdminSpawnable = false

	ENT.Params = table.Copy( rPrint.DefaultPrinterParams )
	table.Merge( ENT.Params, params )

	scripted_ents.Register( ENT, entname )

	return entname
end
