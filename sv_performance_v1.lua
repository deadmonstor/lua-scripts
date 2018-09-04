UseHexane = UseHexane or {}

// ServerSide Optimizer
UseHexane.OptimizerToggle = true

// ConCommand Logger
UseHexane.ConCommandLogger = true

// Net message logger
UseHexane.NetMessageLogger = true

// Lag exploit checker
UseHexane.LagExploitChecker = true
UseHexane.debug = false


/** Do not edit past here unless you know what you are doing. **/
/** Do not edit past here unless you know what you are doing. **/
/** Do not edit past here unless you know what you are doing. **/
/** Do not edit past here unless you know what you are doing. **/
/** Do not edit past here unless you know what you are doing. **/
/** Do not edit past here unless you know what you are doing. **/
/** Do not edit past here unless you know what you are doing. **/
/** Do not edit past here unless you know what you are doing. **/
/** Do not edit past here unless you know what you are doing. **/


// Net exploit warner.
UseHexane.net = {
	"SyncPrinterButtons76561198056171650",
	"sendtable",
	"steamid2",
	"pplay_deleterow",
	"pplay_sendtable",
	"WriteQuery",
	"VJSay",
	"SendMoney",
	"BailOut",
	"customprinter_get",
	"textstickers_entdata",
	"NC_GetNameChange",
	"ATS_WARP_REMOVE_CLIENT",
	"CFJoinGame",
	"Keypad",
	"CreateCase",
	"rprotect_terminal_settings",
	"StackGhost",
	"RevivePlayer",
	"ARMORY_RetrieveWeapon",
	"TransferReport",
	"SimpilicityAC_aysent",
	"pac_to_contraption",
}


if (UseHexane.OptimizerToggle or true) then
	
	hook.Add("OnEntityCreated", "GS_PodFix", function(pEntity)
		if (pEntity:GetClass() == "prop_vehicle_prisoner_pod") then
			pEntity:AddEFlags(EFL_NO_THINK_FUNCTION)
		end
	end)

	hook.Add("PlayerEnteredVehicle", "GS_PodFix", function(_, pVehicle)
		if (pVehicle:GetClass() == "prop_vehicle_prisoner_pod") then
			pVehicle:RemoveEFlags(EFL_NO_THINK_FUNCTION)
		end
	end)

	hook.Add("PlayerLeaveVehicle", "GS_PodFix", function(_, pVehicle)
		if (pVehicle:GetClass() == "prop_vehicle_prisoner_pod") then
			local sName = "GS_PodFix_" .. pVehicle:EntIndex()

			hook.Add("Think", sName, function()
				if (pVehicle:IsValid()) then
					local tSave = pVehicle:GetSaveTable()
					
					-- If set manually
					if (tSave.m_bEnterAnimOn) then
						hook.Remove("Think", sName)
					elseif (not tSave.m_bExitAnimOn) then
						pVehicle:AddEFlags(EFL_NO_THINK_FUNCTION)

						hook.Remove("Think", sName)
					end
				else
					hook.Remove("Think", sName)
				end
			end)
		end
	end)

	
	hook.Add("Initialize","UseHexane",function()

		-- Usually the cause of some if not most lag.
		hook.Remove("PlayerTick", "TickWidgets")
	 
		if timer.Exists("CheckHookTimes") then
			timer.Remove("CheckHookTimes")
		end

		hook.Remove( "Think", "CheckSchedules")
		timer.Destroy("HostnameThink")
		hook.Remove("LoadGModSave", "LoadGModSave")
			
		for k, v in pairs(ents.FindByClass("env_fire")) do v:Remove() end
		for k, v in pairs(ents.FindByClass("trigger_hurt")) do v:Remove() end
		for k, v in pairs(ents.FindByClass("prop_physics")) do v:Remove() end
		for k, v in pairs(ents.FindByClass("prop_ragdoll")) do v:Remove() end
		for k, v in pairs(ents.FindByClass("light")) do v:Remove() end
		for k, v in pairs(ents.FindByClass("spotlight_end")) do v:Remove() end
		for k, v in pairs(ents.FindByClass("beam")) do v:Remove() end
		for k, v in pairs(ents.FindByClass("point_spotlight")) do v:Remove() end
		for k, v in pairs(ents.FindByClass("env_sprite")) do v:Remove() end
		for k,v in pairs(ents.FindByClass("light_spot")) do v:Remove() end
		for k,v in pairs(ents.FindByClass("point_template")) do v:Remove() end
		
	end)
	
end


if (UseHexane.NetMessageLogger or true) then

	function net.Incoming(len, client)
		local i = net.ReadHeader()
		local name = util.NetworkIDToString(i)

		if not(name) and IsValid(client) then
		
			ServerLog(string.format("Unpooled message name for net msg #%d Client: %s (STEAMID: %s) \n", i, client:Nick(), client:SteamID()))
			
			return
			
		elseif not(name) then
		
			return
			
		end

		local func = net.Receivers[name:lower()]

		if not(func) and IsValid(client)  then
			
			ServerLog(string.format("No receiving function for '%s' (net msg #%d) Client: %s (STEAMID: %s) \n", name, i, client:Nick(), client:SteamID()))
			return
			
		elseif not(func) then
		
			return
			
		end

		len = len - 16
		
		if not table.HasValue(UseHexane.net, name) then
		
			if (IsValid(client) and (client.LastMSG or 0) < CurTime() - 0.25) then
				
				ServerLog(string.format("Net message '%s' (%d) received (%.2fkb (%db)) Client: %s (STEAMID: %s) \n", name, i, len/8/1024, len/8, client:Nick(), client:SteamID()))
				client.LastMSG = CurTime()
				
			elseif (client.LastMSG or 0) < CurTime() - 0.25 then
				
				ServerLog(string.format("Net message '%s' (%d) received (%.2fkb (%db)) Client: %s (STEAMID: %s) \n", name, i, len/8/1024, len/8, "UNKNOWN", "UNKNOWN"))
			
			end
			
		else
		
			if (IsValid(client) and (client.LastMSG or 0) < CurTime() - 0.25) then
				
				ServerLog(string.format("Net message '%s' (%d) received (%.2fkb (%db)) Client: %s (STEAMID: %s) [ Exploitable String ] \n", name, i, len/8/1024, len/8, client:Nick(), client:SteamID()))
				client.LastMSG = CurTime()

			elseif (client.LastMSG or 0) < CurTime() - 0.25 then
				
				ServerLog(string.format("Net message '%s' (%d) received (%.2fkb (%db)) Client: %s (STEAMID: %s) [ Exploitable String ] \n" , name, i, len/8/1024, len/8, "UNKNOWN", "UNKNOWN"))
			
			end
		
		end
		
		status, error = pcall( function() func(len, client) end )
		
		if not status then
			
			
			ServerLog(string.format("Error during net message (%s). Reasoning: %s \n", name, error))

			
		end
		
	end
	
end

UseHexane.crun = UseHexane.crun or concommand.Run

if (UseHexane.ConCommandLogger or true) then

	function concommand.Run(ply, cmd, args)
		if !IsValid(ply) then return UseHexane.crun(ply,cmd,args) end
		if !cmd then return UseHexane.crun(ply,cmd,args) end
		
		if args and args ~= "" and #args != 0 then
		
			ServerLog(ply:Name() .. "( "..ply:SteamID().." )" .. "has executed this command: " .. cmd .. " " .. table.concat(args, " ") .. ". \n")
			
		else
		
			ServerLog(ply:Name() .. "( "..ply:SteamID().." )" .. " has executed this command: " .. cmd .. ". \n")
			
		end
		
		return UseHexane.crun(ply, cmd, args)

	end
	
end

if (UseHexane.LagExploitChecker or true) then
	UseHexane.Running = false
	
	function UseHexane.PrintDebug(...)
		
		if UseHexane.debug then 
		
			ServerLog(...)
			
		end
		
	end
	
	UseHexane.PrintDebug("[LAG Detect] Initializing.")
	UseHexane.PrintDebug("[Lag Detect] Making Random String!")

	local randStringAmount = math.Rand(2,4)

	UseHexane.string = ""

	for i=1, randStringAmount do
		UseHexane.string = UseHexane.string .. math.Round(math.Rand(10,999)) .. "UseHexane" .. math.Round(math.Rand(10,999)) .. "UseHexane"
	end

	UseHexane.PrintDebug("[Lag Detect] String: " .. UseHexane.string)

	UseHexane.Expected = {}
	UseHexane.Result = {}

	function UseHexane.lag_detect(ply)
		
		if not (UseHexane.Running) and ply:IsSuperAdmin() then
			
			UseHexane.Running = true
			ply:SendLua("chat.AddText(Color(45,115,255), \"[\", Color(255,255,255), \"LagCheck\", Color(45,115,255), \"] \", Color(255,255,255), \"Starting \", Color(45,115,255), \"LagCheck\", Color(255,255,255), \" Check!\")")
			UseHexane.PrintDebug("[LAG Detect] " .. ply:Nick() .. " Has Started a Lag Exploiter check!")
			
			for k,v in pairs(player.GetAll()) do
			
				v:ConCommand("say " .. UseHexane.string)
				
				if v:IsConnected() then table.insert(UseHexane.Expected, v) end
				
			end

			ply:SendLua("chat.AddText(Color(45,115,255), \"[\", Color(255,255,255), \"LagCheck\", Color(45,115,255), \"] \", Color(255,255,255), \"Sent Messages To \", Color(45,115,255), \"All\", Color(255,255,255), \" Connected Players!\")")

			UseHexane.lag_results(ply)
			
		end
		
	end

	UseHexane.PrintDebug("[LAG Detect] Created Lag Detect Function!")

	function UseHexane.lag_results( ply )
		timer.Create("UseHexane", 5, 1, function( )
		
			local plys = table.Copy(player.GetAll()) 
			
			for k,v in pairs(plys) do
			
				if table.HasValue(UseHexane.Result, v) or not table.HasValue(UseHexane.Expected, v) then 
					table.remove(plys, k)
				end
			
			end

			local size = #plys or 0
			
			ply:SendLua("chat.AddText(Color(45,115,255), \"[\", Color(255,255,255), \"LagCheck\", Color(45,115,255), \"] \", Color(255,255,255), \"Detected: \", Color(45,115,255), \"" .. size .. "\", Color(255,255,255), \" Players Thought to be exploiting\")")
			
			if (size > 0) then 
				
				ply:SendLua("chat.AddText(Color(45,115,255), \"[\", Color(255,255,255), \"LagCheck\", Color(45,115,255), \"] \", Color(255,255,255), \"Players Detected: \")")
				
				for k,v in pairs(plys) do
					
					ply:SendLua("chat.AddText(Color(255,255,255), \"Name: \", Color(45,115,255), \"" .. v:Nick() .. "\", Color(255,255,255), \" Steam: \", Color(45,115,255), \"" .. v:SteamID() .. "\")")
				end
				
			end

			UseHexane.newString()

			table.Empty(UseHexane.Expected)
			table.Empty(UseHexane.Result)
			UseHexane.Running = false
			
		end)

	end

	UseHexane.PrintDebug("[LAG Detect] Created Lag Detect Results Function!")

	function UseHexane.newString()
		
		UseHexane.PrintDebug("[Lag Detect] Making A New Random String!")

		local randStringAmount = math.Rand(2,4)

		UseHexane.string = ""

		for i=1, randStringAmount do
			UseHexane.string = UseHexane.string .. math.Round(math.Rand(10,999)) .. "UseHexane" .. math.Round(math.Rand(10,999)) .. "UseHexane"
		end

		UseHexane.PrintDebug("[Lag Detect] New String: " .. UseHexane.string)
		
	end

	hook.Add("PlayerSay", "UseHexane", function(ply, text)
		
		if (text == UseHexane.string) then
		
			table.insert(UseHexane.Result, ply)
			return ""
			
		end
		
	end)
	UseHexane.PrintDebug("[LAG Detect] Created Lag Detect Hook!")

	concommand.Add("lag_check", UseHexane.lag_detect)

	UseHexane.PrintDebug("[LAG Detect] Created Lag Detect Command!")
end