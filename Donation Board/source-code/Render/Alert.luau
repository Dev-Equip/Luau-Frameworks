--!nocheck
--!nolint
local Alert, Fusion = {}, 
require("../Dependencies/Fusion")
Fusion = Fusion.scoped(Fusion)


function Alert:SendMessage(message: string)
	pcall(function()
		game:GetService("TextChatService").TextChannels.RBXGeneral:DisplaySystemMessage(message)
	end)
end


return Alert