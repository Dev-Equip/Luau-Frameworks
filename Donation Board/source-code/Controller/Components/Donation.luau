--!nocheck
--!nolint
local Donation, Receipt = {}, require("../../Libraries/Receipt")
Donation.__index = Donation


export type donation = {
    UserId: number,
    Experience: number,
    Studio: number,
    History: {
        number: Receipt.receiptInfoType
    }
}


function Donation.new(userId: number)
	local self = setmetatable({}, Donation)
	self.UserId = userId
	self.History = {}
	self.Experience = 0
	self.Studio = 0
	
	return self
end


function Donation:Load()
     local _temp = (game:GetService("DataStoreService"):GetDataStore(shared["_db/info"].datastorename):GetAsync(shared["_db/keys"].donationsdata) or {})[tostring(self.UserId)]
     if (_temp) then
        self.History = _temp.History or self.History
        self.Experience = math.clamp((_temp.Experience or self.Experience), 0, 999999999999)
        self.Studio = math.clamp((_temp.Studio or self.Studio), 0, 999999999999)
     end
     return self
end


function Donation:Save()
    if not (shared["_db/memory"][shared["_db/keys"].donationsdata]) then
        shared["_db/memory"][shared["_db/keys"].donationsdata] = {}
    end

    shared["_db/memory"][shared["_db/keys"].donationsdata][tostring(self.UserId)] = (
        ((self.Experience or 0) + (self.Studio or 0)) == 0 and nil or {
            UserId = self.UserId,
            History = self.History or {},
            Experience = math.clamp((self.Experience or 0), 0, 999999999999),
            Studio = math.clamp((self.Studio or 0), 0, 999999999999),
        }
    )

    return self
end


return Donation