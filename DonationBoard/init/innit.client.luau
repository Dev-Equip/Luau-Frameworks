if not game:IsLoaded() then game.Loaded:Wait() end

local Public do
	repeat task.wait() until game:GetService("ReplicatedStorage"):FindFirstChild("donationboard@public")
	Public = game:GetService("ReplicatedStorage"):FindFirstChild("donationboard@public")
end

local Render do
	repeat task.wait() until Public:FindFirstChild("Render")
	Render = Public:FindFirstChild("Render")
end

local Board do
	repeat task.wait() until script:FindFirstAncestorWhichIsA("Model"):FindFirstChild("Board", true)
	Board = script:FindFirstAncestorWhichIsA("Model"):FindFirstChild("Board", true)
end

require(Render).new(Board)