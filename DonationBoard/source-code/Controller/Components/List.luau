--!nocheck
--!nolint
local List, Class = {}, require("../../Libraries/Class")
List.__index = List


export type classType = {
    Studio: boolean,
    Experience: boolean,
    Total: {Studio: number, Experience: number},
    TopDonors: {number:{number}},
    Refresh: (self: classType) -> (),
    Refreshed: RBXScriptSignal,
    GetByRank: (self: classType, rank: number) -> ({number:{number}}?),
    GetUserId: (self: classType, userId: number) -> ({number:{number}}?),
    GetByRobux: (self: classType, min: number, max: number?) -> ({number:{number}}?),
} 


function List.new()
    local self = Class.new {
        Studio = shared["_db/environment"].studiomode,
        Experience = true,
        TopDonors = {},
        Total = {
            Studio = 0,
            Experience = 0,
        },
    }

    local _refreshed = Instance.new("BindableEvent")
    rawset(self, "Refreshed", _refreshed.Event)

    function self:Refresh()
        local _temp, _total = {}, {Studio = 0, Experience = 0}
        for userId, data in (game:GetService("DataStoreService"):GetDataStore(shared["_db/info"].datastorename):GetAsync(shared["_db/keys"].donationsdata) or {}) do
            if (data.Studio == 0) and (data.Experience == 0) then continue end

            _total.Experience += (self.Experience and data.Experience or 0)
            _total.Studio += (self.Studio and data.Studio or 0)
            
            local donated = (self.Experience and data.Experience or 0) + (self.Studio and data.Studio or 0)
            if donated <= 0 then continue end

            table.insert(_temp, {tonumber(userId), donated})
        end
		table.sort(_temp, function(a, b) return a[2] > b[2] end)
		for index, dict in _temp do table.insert(dict, 1, index) end
        self.TopDonors = _temp
		self.Total = _total
        _refreshed:Fire()
        return self
    end

    function self:GetByRank(rank: number)
        for _, array in self.TopDonors do
            if array[1] == rank then return array end
        end

        return nil
    end

    function self:GetByUserId(userId: number)
        for _, array in self.TopDonors do
            if array[2] == userId then return array end
        end

        return nil
    end

    function self:GetByRobux(min: number, max: number?)
        local list = {}

        for _, array in self.TopDonors do
            if array[3] >= min and array[3] <= (max or min) then table.insert(list, array) end
        end

        return #list == 1 and list[1] or #list > 1 and list or nil
    end

    return self :: typeof(self) & classType
end


return List

