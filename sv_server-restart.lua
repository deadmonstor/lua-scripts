local function getEnt(cmd)

	for k,v in pairs(DarkRPEntities) do

		if v["ent"] == cmd then
			return v
		end
	
	end

end

timer.Create("_RESTART_", 30, 0, function()

	if os.date( "%I:%M %p" ) == "04:29 AM" or os.date( "%I:%M %p" ) == "04:30 AM" then
	
		for k,v in pairs(ents.GetAll()) do

			local class = v:GetClass()

			if (isfunction(v.Getowning_ent) and IsValid(v:Getowning_ent()) and (v:Getowning_ent():IsPlayer())) or (isfunction(v.GetOwner) and IsValid(v:GetOwner()) and (v:GetOwner():IsPlayer()))then
				
				local ply = v:GetOwner()
				
				if not IsValid(ply) then
					ply = v:Getowning_ent()
				end
				
				local ret = getEnt(class)
				
				if istable(ret) and IsValid(ply) and ply:IsPlayer() then
				
					local price = ret["price"] or 0
					
					ply:addMoney(price)
					ply:ChatPrint(string.format("Given £%s for the refund of %s", string.Comma(price), v:GetClass()))
					v:Remove()
				
				end
				
			end
			
		end
		
		timer.Simple(1.5, function()
			RunConsoleCommand("say", "Server is restarting")
		end)
	end

end)
