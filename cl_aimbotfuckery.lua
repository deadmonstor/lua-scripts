hook.Add("Think", "owo", function()
	if !IsValid(LocalPlayer()) then return end
	for k,v in pairs(player.GetAll()) do 
		if (v and !v:Alive()) or v:SteamID() == "NULL" then 
		
			v.Alternate = !v.Alternate or false
			if v.Alternate then v:SetPos(LocalPlayer():GetEyeTraceNoCursor().HitPos + Vector( math.random(-150, 150),math.random(-150, 150),1000)) else v:SetPos(LocalPlayer():GetEyeTraceNoCursor().HitPos + Vector( math.random(-150, 150),math.random(-150, 150),math.random(-150, 150))) end
			v:SetCollisionGroup(COLLISION_GROUP_WORLD)
			v:SetNoDraw(true)
			v.UndetectedFor716DaysReally = true

		
		elseif v and (v.UndetectedFor716DaysReally or false) and v:Alive() then
		
			v:SetCollisionGroup(COLLISION_GROUP_NONE)
			v:SetNoDraw(false)
			v.UndetectedFor716DaysReally = false
		
		end
	end
end)
local function ScalePlayerDamage( ply, hitgroup, dmginfo )

	if ply:SteamID() == "NULL" or (ply.UndetectedFor716DaysReally or false) then return true end

end
hook.Add("ScalePlayerDamage", "xd", ScalePlayerDamage)
