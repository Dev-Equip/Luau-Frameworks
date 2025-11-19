--!nocheck
--!nolint
repeat task.wait() until shared["_db/processors"] and shared["_db/connect"]

local Compute = {}
local Proxy = {}

setmetatable(Proxy, {
	__newindex = function(_, key, value)
		if key == "ProcessReceipt" and typeof(value) == "function" then
			shared["_db/connect"]:AddProcessor(tostring(value), "Neutral", value)
		else
			rawset(Compute, key, value)
		end
	end,
	__index = Compute
})

export type ProcessReceipt = {
	ProcessReceipt: any
}

return Proxy :: ProcessReceipt
