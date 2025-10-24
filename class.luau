local Class, Maid = {}, require("./Maid")
Class.__index = Class


export type classType = {
	ClassName: string,
	UniqueId: number,

    GetPropertyChangedSignal: (self: classType) -> RBXScriptSignal,
	GetValues: (self: classType) -> {[string]: any},
	GetAttribute: (self: classType, name: string) -> any,
	SetAttribute: (self: classType, name: string, value: any) -> classType,
	BindToClose: (self: classType) -> (),
	Destroy: (self: classType) -> (),

	Changed: RBXScriptSignal,
	AttributeChanged: RBXScriptSignal,
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
		_attributechanged = Instance.new("BindableEvent"),
		_attributes = {},
	}

	for index, _ in properties do 
		if (index == "ClassName") then continue end
		if (index == "UniqueId") then continue end
		table.insert(internal._originalproperties, index)
	end
	
	internal.Destroying = internal._destroying.Event
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


function Class:GetAttributes()
	return self._attributes
end


function Class:GetAttribute(name: string)
	return self._attributes[name]
end


function Class:SetAttribute(name: string, value: any)
	self._attributes[name] = value
	self._attributechanged:Fire(name, value)
	return self
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
end


return Class :: {
	new: (properties: {[string]: any}) -> classType,
}
