--!strict
local Class, Maid = {}, require("./Maid")
Class.__index = Class


export type Class = {
	new: (properties: {[string]: any}) -> constructor
}

export type constructor = {
	ClassName: string,

    GetPropertyChangedSignal: (self: constructor) -> RBXScriptSignal,
	GetValues: (self: constructor) -> {[string]: any},
	GetAttributes: (self: constructor) -> {[string]: any},
	GetAttribute: (self: constructor, name: string) -> any,
	SetAttribute: (self: constructor, name: string, value: any) -> constructor,
	AddTag: (self: constructor, ...string) -> constructor,
	RemoveTag: (self: constructor, ...string) -> constructor,
	HasTag: (self: constructor) -> boolean,
	GetTags: (self: constructor) -> {any},
	BindToClose: (self: constructor) -> (),
	Destroy: (self: constructor) -> (),

	Changed: RBXScriptSignal,
	AttributeChanged: RBXScriptSignal,
	AttributeAdded: RBXScriptSignal,
	AttributeRemoved: RBXScriptSignal,
	TagAdded: RBXScriptSignal,
	TagRemoved: RBXScriptSignal,
}


function Class.new(properties: {[string]: any}): constructor
	properties = properties or {}

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

	return proxy :: any
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
	self = nil :: any
	return nil
end


return Class :: Class