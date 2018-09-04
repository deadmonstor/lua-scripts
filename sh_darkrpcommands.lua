//

if CLIENT then
	net.Receive("DarkRPChatCommands", function()

		chat.AddText(unpack(net.ReadTable()))

	end)
end

if SERVER then 

	DarkRPChatCommands = DarkRPChatCommands or {}
	util.AddNetworkString("DarkRPChatCommands")

	local col = Color(0,255,0)

	hook.Add("PlayerSay", "DarkRPChatCommands", function(send, text, a)

		local x = string.Split( text, " " )
		local text = x[1]
		table.remove(x, 1)
		x = table.concat(x)
		
		string.gsub(string.sub(x, 1), "[^a-zA-Z0-9 ]", "")
		if DarkRPChatCommands[text] != nil then
			DarkRPChatCommands[text](send, x)
			return ""
		end
	end)

	local raidTimer = 4 // Minutes
	local allowedToRaidFor = 2 // Minutes

	DarkRPChatCommands["/raid"] = function(ply, text) 
		if (ply:GetNWInt("InRaid", 0)) == 0 then
			if (ply:GetNWInt("LastRaid", 0) > CurTime() - (60 * raidTimer)) then 
			
				net.Start("DarkRPChatCommands")
					net.WriteTable({col, "[Raid] ", Color(255, 255, 255), "You cannot raid for another "..((math.Round(ply:GetNWInt("LastRaid", 0) - CurTime())) + (60 * raidTimer)).." second(s)"})
				net.Send(ply)
				
				return
			end
			
			local nick = ply:Nick()
			nick = string.gsub(nick, '[^a-zA-Z0-9 ]', '') 
			text = string.gsub(text, '[^a-zA-Z0-9 ]', '')
			
			if string.len(text) == 0 or string.len(string.Replace(text , " ", "")) == 0 then
				text = "No reason"
			end
			
			ply:SetNWInt("InRaid", 1)
			
			net.Start("DarkRPChatCommands")
				net.WriteTable({col, "[Raid] ", Color(255, 255, 255), sql.SQLStr(nick, true).." has started a raid || " , Color(255,255,255), sql.SQLStr(text, true)})
			net.Broadcast()
			
			timer.Simple((60 * allowedToRaidFor), function()
			
				if IsValid(ply) and ply:GetNWInt("InRaid", 0) == 1 then
				
					local nick = ply:Nick()
					nick = string.gsub(nick, '%W', '')
					
					net.Start("DarkRPChatCommands")
						net.WriteTable({col, "[Raid] ", Color(255, 255, 255), sql.SQLStr(nick, true).." has finished a raid"})
					net.Broadcast()
					
					ply:SetNWInt("InRaid", 0)
					ply:SetNWInt("LastRaid", CurTime())
				end
			
			end)
			
		else
		
			local nick = ply:Nick()
			nick = string.gsub(nick, '%W', '')

			net.Start("DarkRPChatCommands")
				net.WriteTable({col, "[Raid] ", Color(255, 255, 255), sql.SQLStr(nick, true).." has finished a raid"})
			net.Broadcast()
		
			ply:SetNWInt("LastRaid", CurTime())
			ply:SetNWInt("InRaid", 0)
		
		end	
	end

	local pdRaidTimer = 4 // Minutes
	local allowedToRaidForPD = 2 // Minutes

	DarkRPChatCommands["/pdraid"] = function(ply, text) 
		if (ply:GetNWInt("InPDRaid", 0)) == 0 then
			if (ply:GetNWInt("LastPDRaid", 0) > CurTime() - (60 * pdRaidTimer)) then 
			
				net.Start("DarkRPChatCommands")
					net.WriteTable({col, "[PD Raid] ", Color(255, 255, 255), "You cannot PD raid for another "..((math.Round(ply:GetNWInt("LastPDRaid", 0) - CurTime())) + (60 * pdRaidTimer)).." second(s)"})
				net.Send(ply)
				
				return
			end
			
			local nick = ply:Nick()
			nick = string.gsub(nick, '[^a-zA-Z0-9 ]', '') 
			text = string.gsub(text, '[^a-zA-Z0-9 ]', '')
			
			if string.len(text) == 0 or string.len(string.Replace(text , " ", "")) == 0 then
				text = "No reason"
			end
			
			ply:SetNWInt("InPDRaid", 1)
			
			net.Start("DarkRPChatCommands")
				net.WriteTable({col, "[PD Raid] ", Color(255, 255, 255), sql.SQLStr(nick, true).." has started a PD raid || " , Color(255,255,255), sql.SQLStr(text, true)})
			net.Broadcast()
			
			timer.Simple((60 * allowedToRaidForPD), function()
			
				if IsValid(ply) and ply:GetNWInt("InPDRaid", 0) == 1 then
				
					local nick = ply:Nick()
					nick = string.gsub(nick, '%W', '')
					
					net.Start("DarkRPChatCommands")
						net.WriteTable({col, "[PD Raid] ", Color(255, 255, 255), sql.SQLStr(nick, true).." has finished a PD raid"})
					net.Broadcast()
					
					ply:SetNWInt("InPDRaid", 0)
					ply:SetNWInt("LastPDRaid", CurTime())
				end
			
			end)
			
		else
		
			local nick = ply:Nick()
			nick = string.gsub(nick, '%W', '')

			net.Start("DarkRPChatCommands")
				net.WriteTable({col, "[PD Raid] ", Color(255, 255, 255), sql.SQLStr(nick, true).." has finished a raid"})
			net.Broadcast()
		
			ply:SetNWInt("LastPDRaid", CurTime())
			ply:SetNWInt("InPDRaid", 0)
		
		end	
	end

	hook.Add("PlayerDeath", "OnDeathOnCoolDown", function(ply)

		if IsValid(ply) and ply:GetNWInt("InRaid", 0) == 1 then
			
			net.Start("DarkRPChatCommands")
				net.WriteTable({col, "[Raid] ", Color(255, 255, 255), sql.SQLStr(ply:Nick(), true).." has finished a raid"})
			net.Broadcast()
			
			ply:SetNWInt("InRaid", 0)
			ply:SetNWInt("LastRaid", CurTime())
			
		end
		
		if IsValid(ply) and ply:GetNWInt("InPDRaid", 0) == 1 then
				
			net.Start("DarkRPChatCommands")
				net.WriteTable({col,  "[PD Raid] ", Color(255, 255, 255), sql.SQLStr(ply:Nick(), true).." has finished a PD raid"})
			net.Broadcast()
			
			ply:SetNWInt("InPDRaid", 0)
			ply:SetNWInt("LastPDRaid", CurTime())
			
		end

	end)
end