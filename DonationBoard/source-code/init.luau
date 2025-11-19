--!nocheck
--!nolint
game:WaitForChild "Compute"
repeat task.wait() until shared["_db/info"] and shared["_db/keys"] and shared["_db/environment"]

return function(task: string)
    if (task:lower() == "transferdata from 3.0 to 4.0") then
		if (game:GetService("DataStoreService"):GetDataStore(shared["_db/info"].datastorename):GetAsync(shared["_db/keys"].transferreddata)) then return end
		game:GetService("DataStoreService"):GetDataStore(shared["_db/info"].datastorename):SetAsync(shared["_db/keys"].transferreddata, tick())

        local DataStore = game:GetService("DataStoreService"):GetDataStore("Donation Board // V3 - Data"):GetAsync("Donations") or {}
		for key, dict in DataStore do
			if (table.find({"Total - Experience", "Total - Studio", "Users"}, key)) then continue end
			local Donation = require("@self/Controller/Components/Donation").new(tonumber(key))
			Donation.Experience = dict["Donated - Experience"] or 0
			Donation.Studio = dict["Donated - Studio"] or 0
			Donation.History = dict["History"] or {}
			Donation:Save()
		end
		shared["_db/autosavetimer"] = 0
    end

	if (task:lower() == "load") then
		local success, errorMessage = pcall(function()
        	_G["_db/controller"] = _G["_db/controller"] or require("@self/Controller")
		end)
		
		if not success and game:GetService("RunService"):IsStudio() then			
			local isAPIDisabled do
				for _, log in game:GetService("LogService"):GetLogHistory() do
					if (log.messageType ~= Enum.MessageType.MessageError) then continue end
					isAPIDisabled = isAPIDisabled or log.message:lower():find(string.lower(`DataStoreService: StudioAccessToApisNotAllowed: Studio access to APIs is not allowed.`))
					if isAPIDisabled then break end
				end
				
				if isAPIDisabled then 
					for _, player in game:GetService("Players"):GetPlayers() do
						local screenGui = Instance.new("ScreenGui", player.PlayerGui)
						screenGui.DisplayOrder = 99
						screenGui.IgnoreGuiInset = true
						screenGui.ResetOnSpawn = false
						local text = Instance.new("TextLabel", screenGui)
						text.Text = "Please enable API Services for Donation Board v4.0 to load."
						text.BackgroundColor3 = Color3.new(0, 0, 0)
						text.BorderSizePixel = 0
						text.TextSize = 18
						text.Size = UDim2.new(1, 0, 0, 30)
						text.TextColor3 = Color3.new(1, 1, 1)
						text.TextXAlignment = Enum.TextXAlignment.Center
						text.TextYAlignment = Enum.TextYAlignment.Center
					end
					return
				end	
			end
		end
		
		return _G["_db/controller"]
    end

	if (task:lower() == "get") then
		return _G["_db/controller"]
	end

	if (task:lower() == "store") then
		for key, value in shared["_db/environment"] do 
			game:GetService("TestService"):SetAttribute(`_db/{key}`, value)
		end
		
		return function(origin)
			for _, rig in {"R15","R6"} do
				if origin:FindFirstChild(rig) then
					if not game:GetService("ServerStorage"):FindFirstChild(rig)then
						origin:FindFirstChild(rig).Head.face.Transparency=0
						for _, part in origin:FindFirstChild(rig):GetChildren() do
							if part:IsA("BasePart")and part.Name~="HumanoidRootPart"then part.Transparency=0 end
						end
						origin:FindFirstChild(rig).Parent=game:GetService("ServerStorage")
					else origin:FindFirstChild(rig):Destroy()end
				end
			end
		end
	end

	if (task:lower() == "version") then
		return shared["_db/info"].version
	end
end
