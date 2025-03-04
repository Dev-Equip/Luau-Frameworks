--[[
    Promise.lua
    Smooth error handling

    --
  
    License: MIT License
    See LICENSE file in the repository root for full license text.
]]


local Promise = {}
Promise.__index = Promise


function Promise.new(executor)
	local self = setmetatable({}, Promise)
	self.state = "Pending"
	self.value = nil
	self.reason = nil
	self.fulfilledCallbacks = {}
	self.rejectedCallbacks = {}

	local function resolve(value)
		if self.state == "Pending" then
			self.state = "Fulfilled"
			self.value = value
			for _, callback in ipairs(self.fulfilledCallbacks) do
				callback(value)
			end
		end
	end

	local function reject(reason)
		if self.state == "Pending" then
			self.state = "Rejected"
			self.reason = reason
			for _, callback in ipairs(self.rejectedCallbacks) do
				callback(reason)
			end
		end
	end

	xpcall(function()
		executor(resolve, reject)
	end, function(err)
		reject(err)
	end)

	return self
end


function Promise:Then(onFulfilled, onRejected)
	return Promise.new(function(resolve, reject)
		local function handleFulfilled(value)
			if type(onFulfilled) == "function" then
				local result = onFulfilled(value)
				resolve(result)
			else
				resolve(value)
			end
		end

		local function handleRejected(reason)
			if type(onRejected) == "function" then
				local result = onRejected(reason)
				resolve(result)
			else
				reject(reason)
			end
		end

		if self.state == "Fulfilled" then
			handleFulfilled(self.value)
		elseif self.state == "Rejected" then
			handleRejected(self.reason)
		else
			table.insert(self.fulfilledCallbacks, handleFulfilled)
			table.insert(self.rejectedCallbacks, handleRejected)
		end
	end)
end


function Promise:catch(onRejected)
	return self:Then(nil, onRejected)
end


function Promise:finally(onFinally)
	return self:Then(
    function(value)
		onFinally()
		return value
	end, 
	
    function(reason)
		onFinally()
		return reason
	end
	)
end


function Promise.resolve(value)
	return Promise.new(function(resolve)
		resolve(value)
	end)
end


function Promise.reject(reason)
	return Promise.new(function(_, reject)
		reject(reason)
	end)
end


function Promise.all(promises)
	return Promise.new(function(resolve, reject)
		local results = {}
		local count = 0

		for i, promise in ipairs(promises) do
			promise:Then(function(value)
		results[i] = value
		count = count + 1
		if count == #promises then
			resolve(results)
		end
	end):catch(reject)
end
end)
end


function Promise.race(promises)
	return Promise.new(function(resolve, reject)
		for _, promise in ipairs(promises) do
			promise:Then(resolve):catch(reject)
end
end)
end


return Promise :: {
	new: (func: (resolve: (func: any) -> (), reject: (func: any) -> ()) -> ()) -> { state: string, value: any, reason: string?, fulfilledCallbacks: { (func: any) -> () }, rejectedCallbacks: { (func: any) -> () } },
	catch: (self: typeof(Promise), onRejected: (func: (reason: any) -> ()) -> ()) -> typeof(Promise),
	finally: (self: typeof(Promise), onFinally: (func: () -> ()) -> ()) -> typeof(Promise),
	resolve: (value: any) -> typeof(Promise),
	reject: (reason: any) -> typeof(Promise),
	all: (promises: { typeof(Promise) }) -> typeof(Promise),
	race: (promises: { typeof(Promise) }) -> typeof(Promise)
}
