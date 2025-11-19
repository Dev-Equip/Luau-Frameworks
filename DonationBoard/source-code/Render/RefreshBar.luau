--!nocheck
--!nolint
local RefreshBar, Class, Fusion = {}, 
	require("../Libraries/Class"), 
	require("../Dependencies/Fusion")
	RefreshBar.__index = RefreshBar
	Fusion = Fusion.scoped(Fusion)
	
	
function RefreshBar.new(parent: Instance)
	local self = Class.new {
		Enabled = true,
		Speed = 0,

		Body = Fusion:New "Frame" {
			Name = "RefreshBar",
			Parent = parent,
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 0.75,
			Position = UDim2.fromOffset(0, parent.AbsoluteSize.Y - 79),
			Size = UDim2.new(1, 0, 0, 5),
			LayoutOrder = 3,
			
			[Fusion.Children] = {
				Fusion:New "Frame" {
					BackgroundColor3 = Color3.new(1, 1, 1),
					Size = UDim2.fromScale(1, 1),

					[Fusion.Children] = {
						Fusion:New "UIGradient" {
							Color = ColorSequence.new(shared["donationboard@settings"].Colors[1], shared["donationboard@settings"].Colors[2]),
							Rotation = 180,
							[Fusion.Tag "A"] = "donationboard@colors12",
							[Fusion.Tag "B"] = "donationboard@rotation",
						},

						Fusion:New "Frame" {
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.fromScale(1, 0.5),
							Size = UDim2.new(0, 5, 2, 0),

							[Fusion.Children] = {
								Fusion:New "UICorner" {
									CornerRadius = UDim.new(1, 0),
								}
							}
						}
					}
				},
			}
		},
	}
	
	rawset(self, "Fill", self.Body.Frame)

	local Event do
		self.Changed:Connect(function(property, value)		
			if (property) == "Enabled" then
				self.Body.Visible = value
				return
			end
		end)
	end

	self.Lap = function(self)
		self.Fill.Size = UDim2.fromScale(1, 1)
		self.Fill:TweenSize(UDim2.fromScale(0, 1), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, self.Speed, true)
	end

	return self
end


return RefreshBar