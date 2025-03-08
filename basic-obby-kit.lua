config = {
    [[
        Basic-Obby-Kit.lua
        Create basic obbies with nothing but names and tags.
        
	    --
	  
	    License: MIT License
	    See LICENSE file in the repository root for full license text.
	    
	    --
	    
	    Enable API Services in Studio for stages to save.
    ]],


	[[ TAGS ]],
	--| Set a part's tag to any of the below which will give it the effect
	"obby-kit@checkpoint",
	"obby-kit@conveyor",
	"obby-kit@speed",
	"obby-kit@jump",
	"obby-kit@heal",
	"obby-kit@damage",
	"obby-kit@kill",
	"obby-kit@respawn",
	"obby-kit@fade",
	

	[[ LEADERSTATS ]],                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     leaderstats = 
	{"Stage", (true)},
	--| You may disable leaderstats by setting true to false and changing name of "Stage"


	[[ CHECKPOINT ]],
	--| Rename the checkpoint to be Checkpoint[Stage]


	[[ CONVEYOR ]],
	--| Rotate the conveyor in direction it must travel


	[[ SPEED ]],
	--| Rename the pad to be Speed[WalkSpeed]


	[[ JUMP ]],
	--| Rename the pad to be Jump[Height]


	[[ HEAL ]],
	--| This will set the player's health to 100%


	[[ DAMAGE ]],
	--| Rename the pad to be Damage[Health]


	[[ KILL ]],
	--| Kills the player instantly


	[[ RESPAWN ]],
	--| Respawns the player (Faster than kill)
	
	
	[[ FADE ]],                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     fadeBrick = 
	{"Cooldown", 10},
	--| Cooldown for how long until the fade brick comes back
}



local Obby, Maid, Cache, Info = {}, {}, {}, {
	["OnTouch"] = {
		"speed",
		"jump",
		"heal",
		"damage",
		"kill",
		"respawn",
		"checkpoint",
		"fade",
	},

	["Passive"] = {
		"conveyor"
	},

	["Classes"] = {
		"speed",
		"jump",
		"heal",
		"damage",
		"kill",
		"respawn",
		"checkpoint",
		"conveyor",
		"fade",
	},
}

Obby.__index, Maid.__index = Obby, Maid

switch = function(case)
	return function(cases)
		local default;
		for key, action in cases do
			if key:lower() == "default" then default = action end
			if key == case then 
				return action();
			end
		end

		return default and default() or nil;
	end 
end



--|| Obby
function Obby.new( instance )
	local self = setmetatable({}, Obby)
	self._instance = instance
	self._maid = Maid.new()
	self._tag = (
		instance:HasTag("obby-kit@checkpoint") and "Checkpoint" or
		instance:HasTag("obby-kit@conveyor") and "Conveyor" or
		instance:HasTag("obby-kit@speed") and "Speed" or 
		instance:HasTag("obby-kit@jump") and "Jump" or
		instance:HasTag("obby-kit@heal") and "Heal" or
		instance:HasTag("obby-kit@damage") and "Damage" or
		instance:HasTag("obby-kit@kill") and "Kill" or
		instance:HasTag("obby-kit@respawn") and "Respawn" or
		instance:HasTag("obby-kit@fade") and "Fade" or nil
	)

	
	if (table.find(Info.OnTouch, self._tag:lower())) then
		self._maid:GiveTask(self._instance.Touched:Connect(function(hit)
			if not hit then return end
			self:OnTouch(hit)
		end))
	end
	
	if (table.find(Info.Passive, self._tag:lower())) then
		self:Passive()
	end

	return self
end


function Obby:OnTouch(hit)
	local player = game:GetService("Players"):GetPlayerFromCharacter(hit:FindFirstAncestorWhichIsA("Model"))
	if not player or Cache[player] then return end

	Cache[player] = true
	task.delay(1, function() Cache[player] = nil end)

	switch (self._tag:lower()) {
		["checkpoint"] = function()
			if (config.leaderstats[2]) then
				local leaderstats = player:FindFirstChild "leaderstats"
				leaderstats = leaderstats:FindFirstChild(config.leaderstats[1])

				if (leaderstats) and (tonumber(string.match(self._instance.name, "%[(%d+%.?%d*)%]")) > leaderstats.Value) then
					leaderstats.Value = tonumber(string.match(self._instance.name, "%[(%d+%.?%d*)%]"))
					player.RespawnLocation = self._instance
				end
			else
				local leaderstats = player:FindFirstChild(config.leaderstats[1])

				if (leaderstats) and (tonumber(string.match(self._instance.name, "%[(%d+%.?%d*)%]")) > leaderstats.Value) then
					leaderstats.Value = tonumber(string.match(self._instance.name, "%[(%d+%.?%d*)%]"))
					player.RespawnLocation = self._instance
				end
				
				if (player.RespawnLocation and (tonumber(string.match(self._instance.name, "%[(%d+%.?%d*)%]")) or 0 > (tonumber(string.match(player.RespawnLocation.Name, "%[(%d+%.?%d*)%]"))))) then

				end
			end
		end,

		["speed"] = function()
			player.Character.Humanoid.WalkSpeed = tonumber(string.match(self._instance.name, "%[(%d+%.?%d*)%]"))
		end,

		["jump"] = function()
			player.Character.Humanoid.JumpHeight = tonumber(string.match(self._instance.name, "%[(%d+%.?%d*)%]"))
			player.Character.Humanoid.JumpPower = (tonumber(string.match(self._instance.name, "%[(%d+%.?%d*)%]"))::number/7.2) * 50
		end,

		["heal"] = function()
			player.Character.Humanoid.Health = player.Character.Humanoid.MaxHealth
		end,

		["damage"] = function()
			player.Character.Humanoid:TakeDamage(tonumber(string.match(self._instance.name, "%[(%d+%.?%d*)%]")))
		end,

		["kill"] = function()
			player.Character.Humanoid.Health = 0
		end,

		["respawn"] = function()
			player:LoadCharacter()
		end,
		
		["fade"] = function()
			if (self._instance.Transparency > 0) then return end
			local Tween = game:GetService("TweenService"):Create( self._instance, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
				Transparency = 1,
			})
			
			Tween:Play()
			
			Tween.Completed:Once(function(playbackState)
				if playbackState ~= Enum.PlaybackState.Completed then return end
				self._instance.CanCollide = false
				task.wait(config.fadeBrick[2])
				self._instance.CanCollide = true
				game:GetService("TweenService"):Create(self._instance, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
					Transparency = 0,
				}):Play()
			end)
		end,
	}
end


function Obby:Passive()
	switch (self._tag:lower()) {
		["conveyor"] = function()
			self._maid:GiveTask(game:GetService("RunService").Heartbeat:Connect(function(delta)
				if (self._instance.AssemblyLinearVelocity.Magnitude > 0) then return end
				self._instance.AssemblyLinearVelocity += (self._instance.CFrame.LookVector * 0.5) * (((tonumber(string.match(self._instance.name, "%[(%d+%.?%d*)%]"))) or 1) * 0.75)
			end))
		end
	}
end



--|| Maid
function Maid.new()
	local self = setmetatable({}, Maid)
	self._tasks = {}
	return self
end


function Maid:GiveTask(task)
	local n = #self._tasks + 1
	self._tasks[n] = task

	return function()
		if self._tasks[n] then
			self:_doTask(self._tasks[n])
			self._tasks[n] = nil
		end
	end
end


function Maid:DoCleaningByType(type)
	for i = 1, #self._tasks do 
		if typeof(self._tasks[i]) ~= type then continue end 

		self:_doTask(self._tasks[i])
		self._tasks[i] = nil
	end
end


function Maid:DoCleaning()
	for i = 1, #self._tasks do
		self:_doTask(self._tasks[i])
		self._tasks[i] = nil
	end
end


function Maid:_doTask(task)
	if not task then return end

	local taskType = typeof(task)

	if taskType == "RBXScriptConnection" then
		task:Disconnect()
	elseif taskType == "Instance" then
		if task.Parent then
			task:Destroy()
		end
	elseif taskType == "function" then
		task()
	elseif taskType == "thread" then
		if coroutine.status(task) ~= "dead" then
			coroutine.close(task)
		end
	elseif taskType == "table" and task.Destroy then
		task:Destroy()
	elseif taskType == "userdata" and task.disconnect then
		task:disconnect()
	elseif taskType == "table" and task.Cancel then
		task:Cancel()
	end
end



--|| Collection Service
local Tags = {
	"obby-kit@checkpoint",
	"obby-kit@conveyor",
	"obby-kit@speed",
	"obby-kit@jump",
	"obby-kit@heal",
	"obby-kit@damage",
	"obby-kit@kill",
	"obby-kit@respawn",
	"obby-kit@fade",
}

for _, _tag in Tags do
	for _, instance in game:GetService("CollectionService"):GetTagged(_tag) do
		if not instance:IsA("BasePart") then continue end
		Obby.new(instance)
	end
end



--|| Players
function playerAdded(player)
	if (config.leaderstats[2]) then
		if not (config.leaderstats[2]) then return end

		local leaderstats = Instance.new("Folder", player)
		leaderstats.Name = "leaderstats"

		local stage = Instance.new("IntValue", leaderstats)
		stage.Name = config.leaderstats[1]

		xpcall(
			function()
				local data = game:GetService("DataStoreService"):GetDataStore("obby-kit@data"):GetAsync(player.UserId) or 1
				stage.Value = data

				player.CharacterAdded:Connect(function(char)
					repeat task.wait() until char:FindFirstChild("Humanoid")
					player.RespawnLocation = workspace:FindFirstChild(`Checkpoint[{data or 1}]`)
					if not player.RespawnLocation then return end
					char:PivotTo(player.RespawnLocation.CFrame)
				end)
			end,

			function(errorMessage) 
				error("Obby-Kit: DataStore has received an error.")
			end
		)
		
		return
	end	

	local stage = Instance.new("IntValue", player)
	stage.Name = config.leaderstats[1]

	xpcall(
		function()
			local data = game:GetService("DataStoreService"):GetDataStore("obby-kit@data"):GetAsync(player.UserId) or 1
			stage.Value = data

			player.CharacterAdded:Connect(function(char)
				repeat task.wait() until char:FindFirstChild("Humanoid")
				player.RespawnLocation = workspace:FindFirstChild(`Checkpoint[{data or 1}]`)
				char:PivotTo(player.RespawnLocation.CFrame)
			end)
		end,

		function(errorMessage) 
			error("Obby-Kit: DataStore has received an error.")
		end
	)
end

function playerRemoving(player)
	if (config.leaderstats[2]) then
		local leaderstats = player:FindFirstChild("leaderstats")
		if not leaderstats then return end

		local stage = leaderstats:FindFirstChild(config.leaderstats[1])
		if not stage then return end

		xpcall(
			function()
				if stage.Value < 2 then error("Couldn't overwrite stage for potential mistake of data.") end
				game:GetService("DataStoreService"):GetDataStore("obby-kit@data"):SetAsync(player.UserId, stage.Value)	
			end,

			function(errorMessage)
				error("Obby-Kit: DataStore has received an error.")
			end
		)
		
		return
	end


	local stage = player:FindFirstChild(config.leaderstats[1])
	if not stage then return end

	xpcall(
		function()
			if stage.Value < 2 then error("Couldn't overwrite stage for potential mistake of data.") end
			game:GetService("DataStoreService"):GetDataStore("obby-kit@data"):SetAsync(player.UserId, stage.Value)	
		end,

		function(errorMessage)
			error("Obby-Kit: DataStore has received an error.")
		end
	)
end



game:GetService("Players").PlayerAdded:Connect(playerAdded)
game:GetService("Players").PlayerRemoving:Connect(playerRemoving)
for _, player in game:GetService("Players"):GetPlayers() do playerAdded(player) end
