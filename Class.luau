local Class = {}
Class.__index = Class


export type classType = {
	ClassName: string,
	UniqueId: number,

  GetPropertyChangedSignal: (self: classType) -> RBXScriptSignal,
	GetValues: (self: classType) -> {[string]: any},
	GetAttribute: (self: classType, name: string) -> any,
	SetAttribute: (self: classType, name: string, value: any) -> classType,
	Destroy: (self: classType) -> (),

	Changed: RBXScriptSignal,
	AttributeChanged: RBXScriptSignal,
}


local Maid do
	Maid = {}
	Maid.__index = Maid


	function Maid.new()
		local self = setmetatable({}, Maid)
		self._tasks = {}
		return self
	end


	function Maid:GiveTask(task)
		local n = #self._tasks + 1
		self._tasks[n] = task

		if (typeof(task) == "thread") then
			coroutine.resume(task)
		end

		return function()
			if self._tasks[n] then
				self:_doTask(self._tasks[n])
				self._tasks[n] = nil
			end
		end
	end


	function Maid:IsATask(task)
		return table.find({"RBXScriptConnection", "Instance", "function", "thread", "table", "userdata"}, typeof(task)) ~= nil
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
			elseif coroutine.status(task) == "running" then
				coroutine.yield(task)
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
end


function Class.new(properties: {[string]: any})
	properties = properties or {}
	properties.ClassName = properties.ClassName or "Class"
	properties.UniqueId = game:GetService("HttpService"):GenerateGUID(false)

	local internal = {
		_data = properties,
		_maid = Maid.new(),
		_originalproperties = {},
		_changed = Instance.new("BindableEvent"),
		_attributechanged = Instance.new("BindableEvent"),
		_attributes = {},
	}

	for index, _ in properties do 
		if (index == "ClassName") then continue end
		if (index == "UniqueId") then continue end
		table.insert(internal._originalproperties, index)
	end
	internal.Changed = internal._changed.Event
	internal.AttributeChanged = internal._attributechanged.Event

	local proxy = setmetatable({}, {
		__index = function(_, key)
			if Class[key] then return Class[key] end
			if internal[key] then return internal[key] end
			return internal._data[key]
		end,

		__newindex = function(_, key, value)
			local old = internal._data[key]
			if old ~= value then
				internal._data[key] = value
				if internal._maid:IsATask(value) then
					internal._maid:GiveTask(value)
				end
				internal._changed:Fire(key, value)
			end
		end,

		__tostring = function()
			return tostring(internal._data.Name or internal._data.ClassName or "Class")
		end,
	})

	return proxy
end


function Class:GetValues()
	local data = {}
	for _, key in self._originalproperties do
		data[key] = self[key]
	end
	return data
end


function Class:GetPropertyChangedSignal(property: string)
    local _event = Instance.new("BindableEvent")
    self._maid:GiveTask(_event)
    self._maid:GiveTask(self.Changed:Connect(function(propertyName: string, value)
        if (propertyName ~= property) then return end
        _event:Fire(value)
    end))
    return _event.Event
end


function Class:GetAttribute(name: string)
	return self._attributes[name]
end


function Class:SetAttribute(name: string, value: any)
	self._attributes[name] = value
	self._attributechanged:Fire(name, value)
	return self
end


function Class:Destroy()
	self._maid:DoCleaning()
	pcall(function()
		for _, object in self do
			if (typeof(object) ~= "Instance") then continue end
			object:Destroy()
		end
	end)
end


return Class :: {
	new: (properties: {[string]: any}) -> classType,
}
