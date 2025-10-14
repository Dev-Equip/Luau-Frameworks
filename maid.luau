local Maid = {}
Maid.__index = Maid


function Maid.new()
	local self = setmetatable({}, Maid)
	self._tasks = {}
	return self
end


function Maid:GiveTask(...)
	local parameters = table.pack(...)
	local id, task = #parameters > 1 and parameters[1] or "", #parameters > 1 and parameters[2] or parameters[1]

	local n = `{id}{#self._tasks + 1}`
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


function Maid:DoCleaningById(id: string)
	for index, task in self._task or {} do
		if (not index:find(id)) then continue end
		self:_doTask(self._tasks[index])
		self._tasks[index] = nil
	end

	return self
end


function Maid:DoCleaningByType(type)
	for index, task in self._task or {} do
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


return Maid
