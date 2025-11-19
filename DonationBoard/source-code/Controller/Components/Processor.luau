--!nocheck
--!nolint
local Processor, Class, Receipt = {}, require("../../Libraries/Class"), require("../../Libraries/Receipt")
Processor.__index = Processor


export type classType = {
	ProcessReceipt: {},
	ComputeProcessors: (self: classType, receiptInfo: Receipt.receiptInfoType) -> classType,
	AddProcessor: (self: classType, name: string, priority: string, callback: (...any) -> Enum.ProductPurchaseDecision) -> classType,
	ChangeProcessorPriority: (self: classType, name: string, priority: string) -> classType,
	GetProcessor: (self: classType, name: string) -> number,
	RemoveProcessor: (self: classType, name: string) -> classType,
} 


function Processor.new()
    local self = Class.new {
		ProcessReceipt = {},

		ComputeProcessors = function(self, receiptInfo)
			local compute = shared["_db/processors"]
			table.sort(compute, function(a, b) return a.priority > b.priority end)

			for _, processor in ipairs(compute) do
				local success, result = pcall(processor.callback, receiptInfo)
				if (success and result == Enum.ProductPurchaseDecision.PurchaseGranted) then
					return result
				end
			end

			return Enum.ProductPurchaseDecision.NotProcessedYet
		end,
	
		AddProcessor = function(self, name, priority, callback)
			self:RemoveProcessor(name)
			table.insert(shared["_db/processors"], {
				name = name,
				callback = callback,
				priority = tonumber(priority) or ({
					Lowest = -1,
					Neutral = 0,
					Highest = 1,
				})[priority or "Neutral"]
			})

			return self
		end,

		ChangeProcessorPriority = function(self, name, priority)
			for needle, processor in shared["_db/processors"] do
				if (processor.name == name) then 
					shared["_db/processors"][needle].priority = tonumber(priority) or ({
						Lowest = -1,
						Neutral = 0,
						Highest = 1,
					})[priority or "Neutral"]
				end
			end
		end,

		GetProcessor = function(self, name)
			for needle, processor in shared["_db/processors"] do
				if (processor.name == name) then 
					return needle
				end
			end
			return nil
		end,

		RemoveProcessor = function(self, name)
			for needle, processor in shared["_db/processors"] do
				if (processor.name == name) then 
					table.remove(shared["_db/processors"], needle) 
				end
			end

			return self
		end,
	} 

	local Router do
		setmetatable(self.ProcessReceipt, {
			__newindex = function(self, key, value)
				if (key == "ProcessReceipt") then
					self:AddProcessor(
						typeof(value) == "table" and value[1] or "Untitled", 
						typeof(value) == "table" and value[2] or "Neutral",
						typeof(value) == "table" and value[3] or function() end
					)
				end
			end,

			__index = function(self, key)
				if (key == "ProcessReceipt") then
					return shared["_db/processors"]
				end

				return self[key]
			end,
		})
	end
	
    return self :: typeof(self) & classType
end


return Processor