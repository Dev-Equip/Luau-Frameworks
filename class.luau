local Class = {}
Class.__index = Class


export type classType = {
	ClassName: string,
	UniqueId: number,

    GetPropertyChangedSignal: (self: classType) -> RBXScriptSignal,
	GetValues: (self: classType) -> {[string]: any},
	GetAttributes: (self: classType) -> {[string]: any},
	GetAttribute: (self: classType, name: string) -> any,
	SetAttribute: (self: classType, name: string, value: any) -> classType,
	BindToClose: (self: classType) -> (),
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

	function Maid:GiveTask(...)
		local parameters = table.pack(...)
		local id, task = #parameters > 1 and parameters[1] or "", #parameters > 1 and parameters[2] or parameters[1]

		local n = 0; for index, _ in self._tasks do if index:find(id) then n+=1 end end
		n = `{id}{n + 1}`
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

	function Maid:RemoveTask(task)
		for index, _task in self._tasks or {} do
			if (task ~= _task) then continue end
			self._tasks[index] = nil
		end

		return self
	end

	function Maid:RemoveTaskById(id: string)
		for index, task in self._tasks or {} do
			if (not index:find(id)) then continue end
			self._tasks[index] = nil
		end

		return self
	end

	function Maid:RemoveTaskByType(type: string)
		for index, task in self._tasks or {} do
			if typeof(task) ~= type then continue end 
			self._tasks[index] = nil
		end

		return self
	end

	function Maid:RemoveAllTasks()
		for index, task in self._task or {} do
			self._task[index] = nil
		end

		return self
	end

	function Maid:DoCleaningById(id: string)
		for index, task in self._tasks or {} do
			if (not index:find(id)) then continue end
			self:_doTask(self._tasks[index])
			self._tasks[index] = nil
		end

		return self
	end

	function Maid:DoCleaningByType(type: string)
		for index, task in self._tasks or {} do
			if typeof(task) ~= type then continue end 

			self:_doTask(self._tasks[index])
			self._tasks[index] = nil
		end

		return self
	end

	function Maid:DoCleaning()
		for index, task in self._task or {} do
			self:_doTask(self._task[index])
			self._task[index] = nil
		end

		return self
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

local Class, Maid = {}, require("./Maid")
Class.__index = Class


export type classType = {
	ClassName: string,
	UniqueId: number,

    GetPropertyChangedSignal: (self: classType) -> RBXScriptSignal,
	GetValues: (self: classType) -> {[string]: any},
	GetAttributes: (self: classType) -> {[string]: any},
	GetAttribute: (self: classType, name: string) -> any,
	SetAttribute: (self: classType, name: string, value: any) -> classType,
	AddTag: (self: classType, ...string) -> classType,
	RemoveTag: (self: classType, ...string) -> classType,
	HasTag: (self: classType) -> boolean,
	GetTags: (self: classType) -> {any},
	BindToClose: (self: classType) -> (),
	Destroy: (self: classType) -> (),

	Changed: RBXScriptSignal,
	AttributeChanged: RBXScriptSignal,
	AttributeAdded: RBXScriptSignal,
	AttributeRemoved: RBXScriptSignal,
	TagAdded: RBXScriptSignal,
	TagRemoved: RBXScriptSignal,
}


function Class.new(properties: {[string]: any})
	properties = properties or {}
	properties.ClassName = properties.ClassName or "Class"
	properties.UniqueId = game:GetService("HttpService"):GenerateGUID(false)

	local internal = {
		_data = properties,
		_maid = Maid.new(),
		_bindtoclose = nil,
		_originalproperties = {},
		_destroying = Instance.new("BindableEvent"),
		_changed = Instance.new("BindableEvent"),
		_attributeadded = Instance.new("BindableEvent"),
		_attributeremoved = Instance.new("BindableEvent"),
		_attributechanged = Instance.new("BindableEvent"),
		_attributes = {},
		_tagadded = Instance.new("BindableEvent"),
		_tagremoved = Instance.new("BindableEvent"),
		_tags = {},
	}

	for index, _ in properties do 
		if (index == "ClassName") then continue end
		if (index == "UniqueId") then continue end
		table.insert(internal._originalproperties, index)
	end
	
	internal.Destroying = internal._destroying.Event
	internal.Changed = internal._changed.Event
	internal.AttributeChanged = internal._attributechanged.Event
	internal.AttributeAdded = internal._attributeadded.Event
	internal.AttributeRemoved = internal._attributeremoved.Event
	internal.TagAdded = internal._tagadded.Event
	internal.TagRemoved = internal._tagremoved.Event

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
					internal._maid:GiveTask(key, value)
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


function Class:GetAttributeChangedSignal(attribute: string)
    local _event = Instance.new("BindableEvent")
    self._maid:GiveTask(_event)
    self._maid:GiveTask(self.AttributeAdded:Connect(function(attributeName: string, value)
        if (attributeName ~= attribute) then return end
        _event:Fire(value)
    end))

	self._maid:GiveTask(self.AttributeChanged:Connect(function(attributeName: string, value)
        if (attributeName ~= attribute) then return end
        _event:Fire(value)
    end))

	self._maid:GiveTask(self.AttributeRemoved:Connect(function(attributeName: string, value)
        if (attributeName ~= attribute) then return end
        _event:Fire(nil)
    end))
    return _event.Event
end


function Class:GetAttributes()
	return self._attributes
end


function Class:GetAttribute(name: string)
	return self._attributes[name]
end


function Class:SetAttribute(name: string, value: any)
	local added, removed = self._attributes[name] == nil, value == nil
	self._attributes[name] = value
	if (added) then self._attributeadded:Fire(name, value) end
	if (not added and not removed) then self._attributechanged:Fire(name, value) end
	if (removed) then self._attributeremoved:Fire(name) end
	return self
end


function Class:AddTag(...: string)
	for i, tag in table.pack((...)) do
		if (typeof(i) == "string") then continue end
		if (table.find(self._tags, tag)) then continue end

		table.insert(self._tags, tag)
		self._tagadded:Fire(tag)
		return self
	end
	return self
end


function Class:RemoveTag(...: string)
	for i, tag in table.pack((...)) do
		if (typeof(i) == "string") then continue end
		if (table.find(self._tags, tag) == nil) then continue end

		table.remove(self._tags, table.find(self._tags, tag))
		self._tagremoved:Fire(tag)
		return self
	end
	return self
end


function Class:HasTag(...: string)
	local array = {}
	for i, tag in table.pack((...)) do
		if (typeof(i) == "string") then continue end
		array[i] = table.find(self._tags, tag) ~= nil
	end
	return table.unpack(array)
end


function Class:GetTags()
	return self._tags
end


function Class:BindToClose(func)
	rawset(self, "_bindtoclose", func)
	return self
end


function Class:Destroy()
	if (self._bindtoclose) then self:_bindtoclose() end
	self._destroying:Fire()
	self._maid:DoCleaning()
	pcall(function()
		for _, object in self:GetValues() do
			if (typeof(object) ~= "Instance") then continue end
			pcall(object.Destroy, object)
		end
	end)
	self = nil
	return nil
end


return Class :: {
	new: (properties: {[string]: any}) -> classType,
}
