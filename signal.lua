--[[
    Signal.lua
    Better bindable events as a singular metable.

    --
  
    License: MIT License
    See LICENSE file in the repository root for full license text.
]]

local Signal = {}
Signal.__index = Signal


function Signal.new()
	local self = setmetatable({}, Signal)

	self._bevent = Instance.new("BindableEvent")
	self._bfunction = Instance.new("BindableFunction")

	self.Event = self._bevent.Event
	self.OnInvoke = self._bfunction.OnInvoke

	return self
end


function Signal:Fire(...)
	self._bevent:Fire(...)
end


function Signal:Invoke(...)
	return self._bfunction:Invoke(...)
end


function Signal:Connect(...)
	return self._bevent:Connect(...)
end

function Signal:ConnectParallel(...)
	return self._bevent:ConnectParallel(...)
end


function Signal:Once(...)
	return self._bevent:Once(...)
end


function Signal:Wait()
	return self._bevent:Wait()
end


return Signal :: {
	new : () -> {
		Event: RBXScriptConnection,
		OnInvoke: (...any) -> ...any,

		Fire: (self: any, ...any) -> (),
		Invoke: (self: any, ...any) -> ...any,
		Connect: (self: any, func: (...any) -> RBXScriptConnection) -> RBXScriptConnection,
		ConnectParallel: (self: any, func: (...any) -> RBXScriptConnection) -> RBXScriptConnection,
		Once: (self: any, func: (...any) -> ()) -> RBXScriptConnection,
		Wait: (self: any) -> ...any,
	}
}
