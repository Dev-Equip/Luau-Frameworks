--!nocheck
--!nolint
local Settings, Class, Util = {}, require("../../Libraries/Class"), require("../../Libraries/Util")
Settings.__index = Settings
Template = require("../../Templates/Settings")


export type classType = typeof(Template) & {
	SettingsUpdated: RBXScriptSignal
} 


function Settings.new()
    local _temp = table.clone(Template)
    _temp.Save, _temp.Load = 
        function(self)    
            local boardData = {}
            for key, value in Template do
                if (key == "Colors") then
                    boardData[key] = {
                        [1] = `#{self[key][1]:ToHex() or value[1]:ToHex()}`,
                        [2] = `#{self[key][2]:ToHex() or value[2]:ToHex()}`,
                        [3] = `#{self[key][3]:ToHex() or value[3]:ToHex()}`
                    }
                    continue
                end

                if (self[key] == nil) then
                    boardData[key] = value
                else
                    boardData[key] = self[key]
                end
            end

            shared["_db/memory"][shared["_db/keys"].settingsdata] = Settings:Serialize(boardData)
            return self
        end ,
        
        function(self)
            local boardData = game:GetService("DataStoreService"):GetDataStore(shared["_db/info"].datastorename):GetAsync(shared["_db/keys"].settingsdata) or {}
            if (boardData and typeof(boardData) == "string") then boardData = Settings:Deserialize(boardData) end

            for key, value in boardData do
                if (typeof(value) == "string" and value:sub(1, 1) == "#") then
                    self[key] = Color3.fromHex(value)
                    continue
                end
                self[key] = value
            end
            
            return self
        end

    local self = Class.new(_temp) 

	local DeveloperProducts do
        for pageIndex, pageArray in Util.PagesToTable(game:GetService("MarketplaceService"):GetDeveloperProductsAsync()) do
			for _, dict in pageArray do	
                table.insert(self.DeveloperProducts, tonumber(dict.ProductId))			
            end
        end
    end

    local Events do
		rawset(self, "_settingsupdated", Instance.new("BindableEvent"))
		rawset(self, "SettingsUpdated", self._settingsupdated.Event)
		shared["donationboard@settings"] = self

        self.Changed:Connect(function(property, value)
            if not (Template[property]) then return end
            shared["donationboard@settings"] = self
			self._settingsupdated:Fire(property, value)
        end)
    end
        
    self:Load()
    self._maid:GiveTask(coroutine.create(function()
        while (task.wait() and not shared["_db/environment"].studiomode) do
            repeat task.wait() until shared["_db/autosavetimer"]
            repeat task.wait() until shared["_db/autosavetimer"] <= 0
            repeat task.wait() until shared["_db/autosavetimer"] > 0
            self:Load()
        end
    end))

    return self :: typeof(self) & classType
end


function Settings:Serialize(boardData)
    return Util.Serialize(boardData)
end


function Settings:Deserialize(json)
	return Util.Deserialize(json)
end


return Settings