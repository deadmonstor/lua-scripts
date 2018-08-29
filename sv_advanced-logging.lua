CreateConVar("advancedLogging", "0", FCVAR_SERVER_CAN_EXECUTE, "Turns on advanced logging")

advancedLogging = GetConVar( "advancedLogging" ):GetBool()

cvars.AddChangeCallback( "advancedLogging", function( convar_name, value_old, value_new )
	advancedLogging = tobool(value_new)
	local txt = (tobool(advancedLogging) == true and "Enabled" or "Disabled")
	print("[Advanced Logging] "..tostring(txt))
end )

oldFunctions = oldFunctions or {}

function betterPrint(...)

	PrintTable({...})
	
end

for k,v in pairs({
		{"http", "Fetch", http.Fetch},
		{"http", "Post", http.Post},
		{"debug", "getregistry", debug.getregistry},
		{"RunString", RunString},
		{"RunStringEx", RunStringEx},
		{"CompileString", CompileString}}) do 
	
	if type(v[2]) == "function" then
		
		v[3] = v[2]
		v[2] = nil
		
		k = v[1]
	else
	
		k = v[1] .. v[2]
		
	end
	oldFunctions[k] = oldFunctions[k] or v

	if v[2] == nil then 
	
		_G[v[1]] = function(...)
			if advancedLogging then
				betterPrint(...)
				debug.Trace()
			end

			oldFunctions[k][3](...)
		end
	
	else
	
		_G[v[1]][v[2]] = function(...)
			if advancedLogging then
				betterPrint(...)
				debug.Trace()
			end

			oldFunctions[k][3](...)
		end
		
	end
	
end