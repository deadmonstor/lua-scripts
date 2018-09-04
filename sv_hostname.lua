UseHexane = UseHexane or {}

//Hostname changer
UseHexane.HostnameToggle = true
UseHexane.servername = "UseHexane.com | "
UseHexane.tabs = {"High Performance", "Reliable Uptime", "DDoS Protectioned", "Fast Support", "Low Ping", "Multiple Locations"}
UseHexane.TabNumbers = 2 // Amount of tabs that appear in the hostname above.
UseHexane.HostnameRefreshTime = 15 // Seconds

// Do not edit past here unless you know what you are doing //

if (UseHexane.HostnameToggle or true) then
	
	timer.Create("UseHexane_HostName", 1, 0, function() 
	
		local tab = table.Copy(UseHexane.tabs)
		
		local c = {}
		
		for i=1, (UseHexane.TabNumbers or 1) do
		
			local rand = math.random(1, #tab)
			
			table.insert(c, tab[rand])
			table.remove(tab, rand)
		
		end
		
		RunConsoleCommand("hostname", UseHexane.servername .. table.concat(c, " | "))
		
	end)
	
else

	if timer.Exists("UseHexane_HostName") then timer.Remove("UseHexane_HostName") end
	
end
