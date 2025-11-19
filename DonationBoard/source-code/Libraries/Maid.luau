--!strict
local Maid = {}
Maid.__index = Maid


export type Maid = {
	new: () -> constructor
}

export type TaskType = RBXScriptConnection | Instance | () -> () | thread | { [any]: any } | any

export type constructor = {
	GiveTask: (self: constructor, ...any) -> () -> (),
	IsATask: (self: constructor, task: any) -> boolean,
	RemoveTask: (self: constructor, task: any) -> constructor,
	RemoveTaskById: (self:constructor, id: string) -> constructor,
	RemoveTaskByType: (self: constructor, type: TaskType) -> constructor,
	RemoveAllTasks: (self: constructor) -> constructor,
	DoCleaningById: (self: constructor, id: string) -> constructor,
	DoCleaningByType: (self: constructor, type: TaskType) -> constructor,
	DoCleaning: () -> constructor,
}


function Maid.new(): constructor 
	local self = setmetatable({}, Maid)
	self._tasks = {}
	return self :: any
end

function Maid:GiveTask(...)
	local parameters = table.pack(...)
	local id, task = #parameters > 1 and parameters[1] or "", #parameters > 1 and parameters[2] or parameters[1]

	local count: number = 0; for index, _ in self._tasks do if index:find(id) then count += 1 end end
	local n = tostring(count + 1)
	n = `{id}{n}`
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
	for index, task in (self._tasks or {}) do
		if (typeof(index) == "string") then
			if (not index:find(id)) then
				continue
			end 
		end
		
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
		if (typeof(index) == "string") then
			if (not index:find(id)) then
				continue
			end 
		end

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

function Maid:_doTask(task: TaskType)
	if not task then return end

	local taskType = typeof(task)
	if taskType == "RBXScriptConnection" then
		task:Disconnect()
	elseif taskType == "Instance" then
		if task.Parent then
			task:Destroy()
		end
	elseif taskType == "function" then
		(task :: () -> ())()
	elseif taskType == "thread" then
		if coroutine.status(task::thread) ~= "dead" then
			coroutine.close(task::thread)
		elseif coroutine.status(task::thread) == "running" then
			coroutine.yield(task::thread)
			coroutine.close(task::thread)
		end
	elseif taskType == "table" and task.Destroy then
		task:Destroy()
	elseif taskType == "userdata" and task.disconnect then
		task:disconnect()
	elseif taskType == "table" and task.Cancel then
		task:Cancel()
	elseif taskType == "table" then
		for i, v in (task::{ [any]: any }) do
			Maid:_doTask(v)
		end
	end
end


return Maid :: Maid