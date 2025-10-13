--!nocheck
local SourceCode do
	if not (game:GetService("ServerScriptService"):FindFirstChild("source-code")) then script.Parent["source-code"].Parent = game:GetService("ServerScriptService") end 
	repeat task.wait() until game:GetService("ServerScriptService"):FindFirstChild("source-code")
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