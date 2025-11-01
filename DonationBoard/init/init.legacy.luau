--!nocheck

local SourceCode do
	
	repeat
		local src = script.Parent:FindFirstChild("source-code", true)
	
		if src and not game.ServerScriptService:FindFirstChild("source-code") then
			src.Parent = game.ServerScriptService
	
		end
		task.wait()
	until game.ServerScriptService:FindFirstChild("source-code")
	
	_, SourceCode = xpcall(
		function()
			
			return require(game:GetService("ServerScriptService"):FindFirstChild("source-code"))
		end,

		function(reason)
			
			if not (shared["_db/environment"].debugmode) then return end
			error(reason)
		end
	)
end

SourceCode "Store" (script)
SourceCode "TransferData from 3.0 to 4.0"
SourceCode "Load"