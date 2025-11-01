--!nocheck
--!nolint
Instance.new("Folder", game:GetService("ReplicatedStorage")).Name = "donationboard@public"
script.Parent.Parent.Dependencies:Clone().Parent = game:GetService("ReplicatedStorage"):FindFirstChild("donationboard@public")
script.Parent.Parent.Libraries:Clone().Parent = game:GetService("ReplicatedStorage"):FindFirstChild("donationboard@public")
script.Parent.Parent.Render:Clone().Parent = game:GetService("ReplicatedStorage"):FindFirstChild("donationboard@public")	
script.Parent.Parent.Templates:Clone().Parent = game:GetService("ReplicatedStorage"):FindFirstChild("donationboard@public")
script.Parent.Parent.Signals.Parent = game:GetService("ReplicatedStorage"):FindFirstChild("donationboard@public")
script.Compute.Parent = game