--!nocheck
--!nolint
local Donation, Receipt, Util, Settings, List, Rig, Processor = 
	require("./Controller/Components/Donation"),
	require("./Libraries/Receipt"),
	require("./Libraries/Util"),
	require("./Controller/Components/Settings"),
	require("./Controller/Components/List"),
	require("./Controller/Components/Rig"),
	require("./Controller/Components/Processor")
	require("./Controller/DataStore")
	

local BoardSettings do
	BoardSettings = Settings.new()
end


local ParticleEmitter do
	ParticleEmitter = Instance.new("ParticleEmitter")
	ParticleEmitter.Brightness = 1
	ParticleEmitter.LightEmission = 1
	ParticleEmitter.LightInfluence = 0
	ParticleEmitter.Orientation = Enum.ParticleOrientation.FacingCamera
	ParticleEmitter.Size = NumberSequence.new(1)
	ParticleEmitter.Squash = NumberSequence.new(0)
	ParticleEmitter.Texture = "rbxassetid://12765596850"
	ParticleEmitter.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.1, 0.5),
		NumberSequenceKeypoint.new(1, 1)
	})
	ParticleEmitter.EmissionDirection = Enum.NormalId.Top
	ParticleEmitter.Enabled = false
	ParticleEmitter.Lifetime = NumberRange.new(0.5, 0.9)
	ParticleEmitter.Rate = 100
	ParticleEmitter.Rotation = NumberRange.new(-50, 50)
	ParticleEmitter.RotSpeed = NumberRange.new(-50, 50)
	ParticleEmitter.Speed = NumberRange.new(25)
	ParticleEmitter.SpreadAngle = Vector2.new(-45, 45)
	ParticleEmitter.Acceleration = Vector3.new(0, -50, 0)
end 


local ProcessReceipt do
	ProcessReceipt = Processor.new()
	shared["_db/connect"] = ProcessReceipt
	
	_internalProcessor = function(receiptInfo: Receipt.receiptInfoType)
		if (not table.find(BoardSettings.DeveloperProducts, receiptInfo.ProductId)) then return end
		if (receiptInfo.ProductId == 1651970492) then
			task.spawn(function()
				local serverMessage = Instance.new("Message", workspace)
				for i = 10, 1, -1 do
					serverMessage.Text = `Donation Board — Connected: ✅ ({i})`
					task.wait(1)
				end
				serverMessage:Destroy()	
			end)

			return Enum.ProductPurchaseDecision.PurchaseGranted
		end

		local playerData = Donation.new(receiptInfo.PlayerId):Load()
		local userInfo = game:GetService("UserService"):GetUserInfosByUserIdsAsync({playerData.UserId})[1]

		playerData[receiptInfo.IsStudio and "Studio" or "Experience"] += receiptInfo.CurrencySpent
		table.insert(playerData.History, Util.Serialize(receiptInfo))
		playerData:Save()
		for _, event in game:GetService("CollectionService"):GetTagged("donationboard@donated") do event:Fire(receiptInfo.PlayerId, receiptInfo.CurrencySpent) end

		local RemoteEvent = game:GetService("CollectionService"):GetTagged("donationboard@alert")[1]::RemoteEvent
		RemoteEvent:FireAllClients("Chat", string.format(
			`<font color="#%s">%s</font>`,
			BoardSettings.Colors[1]:ToHex(),
			BoardSettings.DonateMessage:gsub("{player}", `{userInfo.DisplayName} (@{userInfo.Username})`):gsub("{robux}", `{utf8.char(0xE002)} {Util.Commaify(receiptInfo.CurrencySpent)}`)
		))

		if (BoardSettings.Particles) then
			local particle = ParticleEmitter:Clone()
			particle.Parent = game:GetService("Players"):GetPlayerByUserId(receiptInfo.PlayerId).Character.HumanoidRootPart
			particle.Enabled = true; task.delay(0.15, function()
				particle.Enabled = false; task.wait(1); particle:Destroy()
			end)
		end

		return Enum.ProductPurchaseDecision.PurchaseGranted
	end	

	BoardSettings.Changed:Connect(function(property, value)	
		if (property == "ProcessReceiptPriority") then
			if (BoardSettings.DirectLink) then return end
			ProcessReceipt:ChangeProcessorPriority("_db/computer", value)
			return
		end
	end)

	task.spawn(function()
		while task.wait(shared["_db/info"].reconnecttimer) do
			local searchAvoider = "80/114/111/99/101/115/115/82/101/99/101/105/112/116" --> To avoid players from replacing with new receipt processor
			local serviceAvoider = "77/97/114/107/101/116/112/108/97/99/101/83/101/114/118/105/99/101" --> To avoid players from replacing with new receipt processor

			game:GetService(string.char(table.unpack(serviceAvoider:split("/"))))[string.char(table.unpack(searchAvoider:split("/")))] = function(receiptInfo)
				receiptInfo = Receipt.new(receiptInfo)

				if (BoardSettings.DirectLink) then
					ProcessReceipt:RemoveProcessor("_db/computer")
					return _internalProcessor(receiptInfo)
				end

				ProcessReceipt:AddProcessor("_db/computer", BoardSettings.ProcessReceiptPriority, _internalProcessor)
				return ProcessReceipt:ComputeProcessors(receiptInfo) or Enum.ProductPurchaseDecision.NotProcessedYet
			end
		end
	end)
end


local TopDonors do
	TopDonors = List.new()
end


local Rigs do
	Rigs, RigData = {}, {}

	for _, rigboard in game:GetService("CollectionService"):GetTagged("donationboard@rigboard") do
		if not (rigboard:IsDescendantOf(workspace)) then continue end
		if not (rigboard:FindFirstChild("donationboard@rigboard-rig", true)) then rigboard:Destroy() continue end
		local rank = rigboard:FindFirstChild("donationboard@rigboard-rank", true).Text
		rank = tonumber(rank) or tonumber(rank:sub(2, #rank) or 0)
		if (not rank or not tonumber(rank)) then continue end

		local rigType = rigboard:FindFirstChild("donationboard@rigboard-rigtype", true).Text
		rigType = rigType:lower():gsub(" ", ""):find("6") and "R6" or rigType:lower():gsub(" ", ""):find("15") and "R15" or "Auto"
		if not rigType then continue end
		
		local r6 =  rigboard:FindFirstChild("donationboard@rigboard-r6", true).Text:gsub("rbxassetid://", "")
		local r15 = rigboard:FindFirstChild("donationboard@rigboard-r15", true).Text:gsub("rbxassetid://", "")

		table.insert(RigData, {
			rank = rank,
			rigtype = rigType,
			animations = {
				["R6"] = `rbxassetid://{tonumber(r6)}` or "rbxassetid://182436935",
				["R15"] = `rbxassetid://{tonumber(r15)}` or "rbxassetid://507777268",
			},
			pivot = rigboard:FindFirstChild("donationboard@rigboard-rig", true):GetPivot(),
			scale = (rigboard:FindFirstChild("donationboard@rigboard-rig", true).PrimaryPart.Size / Vector3.new(2, 2, 1)).Y or 1,
			extentssize = rigboard:FindFirstChild("donationboard@rigboard-rig", true).BoundingBox.Size
		})

		rigboard:Destroy()
	end

	local folder = Instance.new("WorldModel", workspace)
	folder.Name = "donationboard@rigs"

	for _, data in RigData do
		local _temp = Rig.new(data.pivot)
		_temp.Parent = workspace:FindFirstChild("donationboard@rigs")
		_temp.Scale = data.scale
		_temp.RigType = data.rigtype:lower()
		_temp.R6AnimationId = data.animations.R6
		_temp.R15AnimationId = data.animations.R15
		_temp.Collision = false
		_temp.Tag.Enabled = BoardSettings.DisplayOverhead
		local Color = data.rank < 4 and BoardSettings.Colors[data.rank] or Color3.new(1, 1, 1)
		local H, S, V = Color:ToHSV()
		local StrokeColor = Color3.fromHSV(H, S, V * 0.57)
		_temp.Tag.Frame.Rank.TextColor3 = Color
		_temp.Tag.Frame.Rank.UIStroke.Color = StrokeColor

		table.insert(Rigs, {
			Rank = data.rank,
			Rig = _temp
		})
	end

	TopDonors.Refreshed:Connect(function()
		local userIdList = {}
		for index, _ in RigData do if (TopDonors.TopDonors[index]) then table.insert(userIdList, TopDonors.TopDonors[index][2]) end end
		userIdList = game:GetService("UserService"):GetUserInfosByUserIdsAsync(userIdList)

		for _, dict in Rigs do 
			local rank, rig = dict.Rank, dict.Rig
			if (not TopDonors.TopDonors[rank] or not TopDonors.TopDonors[rank][2]) then 
				rig.UserId = 0
				continue 
			end

			local currentStats = {} :: {}
			for _, stat in userIdList do if stat.Id == TopDonors.TopDonors[rank][2] then currentStats = stat end end
			local function formatName()
				local hasDisplayName, hasUsername = BoardSettings.NamingScheme:lower():find("display") ~= nil, BoardSettings.NamingScheme:lower():find("username") ~= nil

				if (hasDisplayName and not hasUsername) then
					return currentStats.DisplayName
				elseif (not hasDisplayName and hasUsername) then
					return currentStats.Username
				end

				return `{currentStats.DisplayName} (@{currentStats.Username})`
			end

			local H, S, V = BoardSettings[rank < 4 and `Rank{rank}Color` or "TextColor"]:ToHSV()
			rig.Rank.TextColor3 = Color3.fromHSV(H, S, V)
			rig.Rank.UIStroke.Color = Color3.fromHSV(H, S, V * 0.568627)
			rig.Rank.Text = `#{rank}`
			rig.Username.Text = formatName()
			rig.Robux.Text = `{utf8.char(0xE002)} {Util.Commaify(TopDonors.TopDonors[rank][3])}`
			rig.Tag.Enabled = BoardSettings.DisplayOverhead
			rig.UserId = (not tonumber(TopDonors.TopDonors[rank][2]) or TopDonors.TopDonors[rank][2] < 1) and 0 or TopDonors.TopDonors[rank][2]
			if (rig.UserId == TopDonors.TopDonors[rank][2]) then rig:Update() end
		end
	end)

	BoardSettings.Changed:Connect(function(property, value)
		if (property == "DisplayOverhead") then
			for _, rig in Rigs do
				rig.Rig.Tag.Enabled = value
			end
			return
		end
	end)
end


local Refresh do
	task.spawn(function()
		repeat TopDonors:Refresh(); task.wait(1) until TopDonors.TopDonors ~= {}
		while true do
			TopDonors:Refresh()
			game:GetService("CollectionService"):GetTagged("donationboard@refresh")[1]:FireAllClients({
				TopDonors = TopDonors.TopDonors or {},
				Settings = BoardSettings:GetValues() or {},
			})
			task.wait(BoardSettings.RefreshRate)
		end
	end)
end


local Events do
	game:GetService("ReplicatedStorage"):FindFirstChild("donationboard@public").Signals.Request.OnServerInvoke = function(client, requestType, data)
		if (requestType == "settings") then
			return BoardSettings:GetValues()
		end

		if (requestType == "refresh") then
			return {
				TopDonors = TopDonors.TopDonors or {},
				Settings = BoardSettings:GetValues() or {},
			}
		end

		if not (shared["_db/environment"].studiomode) then return end

		if (requestType == "jsondecode") then
			return Util.Deserialize(data)
		end

		if (requestType == "jsonencode") then
			return Util.Serialize(data)
		end
	end

	local cooldown = -math.huge
	game:GetService("ReplicatedStorage"):FindFirstChild("donationboard@public").Signals.Commit.OnServerInvoke = function(client, requestType, data)
		local verifiedStudioMode = game:GetService("RunService"):IsStudio()
		local authenticatedUser = game.CreatorType == Enum.CreatorType.User and game.CreatorId == client.UserId or client:GetRankInGroup(game.CreatorId) >= shared["_db/info"].minimumgrouprank

		if (requestType == "setdonor") and (verifiedStudioMode or authenticatedUser) then
			local playerData = Donation.new(data[1]):Load()
			local userInfo = game:GetService("UserService"):GetUserInfosByUserIdsAsync({data[1]})[1]

			if (data[2] == "add") then
				playerData["Experience"] = math.clamp(playerData.Experience + data[3], 0, math.huge)
			end

			if (data[2] == "subtract") then
				playerData["Experience"] = math.clamp(playerData.Experience - data[3], 0, math.huge)
			end

			if (data[2] == "set") then
				playerData["Experience"] = math.clamp(data[3], 0, math.huge)
				playerData["Studio"] = 0
			end

			if (data[2] == "remove") then
				playerData["Experience"] = 0
				playerData["Studio"] = 0
			end
			
			playerData:Save()
			return nil
		end

		if (requestType == "settings") and (verifiedStudioMode or authenticatedUser) then
			for index, value in data do
				if (BoardSettings[index] == nil) then continue end
				BoardSettings[index] = value
			end 
			
			BoardSettings:Save()
			return
		end
	
		if (requestType == "receipt") and (BoardSettings.SafeMode) then
			if (tick() - cooldown > 1)  then cooldown = tick() else return end
			
			local receiptInfo = Receipt.new {
				PlayerId = client.UserId,
				ProductId = data,
			}

			if (BoardSettings.DirectLink) then
				ProcessReceipt:RemoveProcessor("_db/computer")
				return _internalProcessor(receiptInfo)
			end

			ProcessReceipt:AddProcessor("_db/computer", BoardSettings.ProcessReceiptPriority, _internalProcessor)
			return ProcessReceipt:ComputeProcessors(receiptInfo) or Enum.ProductPurchaseDecision.NotProcessedYet
		end
	
		if (requestType == "resetdonors") and (verifiedStudioMode or authenticatedUser) then
			shared["_db/memory"][shared["_db/keys"].donationsdata] = nil
			game:GetService("DataStoreService"):GetDataStore(shared["_db/info"].datastorename):UpdateAsync(shared["_db/keys"].donationsdata, function(data)
				return {}
			end)
			return nil
		end
	end
	
	game:GetService("MessagingService"):SubscribeAsync("_db/shared", function(retrievedData)
		shared["_db/info"] = retrievedData["_db/info"]
		shared["_db/keys"] = retrievedData["_db/keys"]	
	end)

	game:BindToClose(function()
		if (shared["_db/memory"] == {}) then return end
		shared["_db/autosavetimer"] = 0
		game:GetService("TestService"):Message("Saving — Donation Board Data")
		task.wait(5)
	end)
end 


return nil