config = {
    [[
        Compass.lua
        Display the direction of player's camera effectively.
        
	    --
	  
	  	Remember to place this script in either: [ StarterGui | StarterPlayerScripts ]
	  
	  	--
	  	
	    License: MIT License
	    See LICENSE file in the repository root for full license text.
    ]],


	[[ INCREMENT ]],                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     increment = 
		(15), --| Increment of degree shown (x/360)


	[[ BORDER MODE ]],                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     borderMode = 
		(true), --| Creates a dark background for games with bright light


	[[ ANALOG MODE ]],                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     analogMode = 
		(false), --| Removes degrees and only shows letters (N | NE | E | SE | S | SW | W | NW)


	[[ INDICATOR ]],                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     indicator = 
		(true), --| Display the exact angle you're looking at
}



local Compass, Offset = {}, UDim2.new(0, 0, 0, 0)
Compass.__index = Compass


function Compass:NormalizeAngle(angle)
	return (angle + 360) % 360
end


function Compass.new()
	local self = setmetatable({}, Compass)
	self._angles = {}
	self._bigMarkings, self._smallMarkings = { [0] = "N", [90] = "E", [180] = "S", [270] = "W" }, { [45] = "NE", [135] = "SE", [225] = "SW", [315] = "NW" }
	self._direction = 0
	self._time = 1
	self._increment = config.increment
	self._borderMode = config.borderMode
	self._analogMode = config.analogMode
	self._changed = Instance.new("BindableEvent")
	self.Changed = self._changed.Event

	self._screenGui = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer.PlayerGui)
	self._canvas = Instance.new("CanvasGroup", self._screenGui)
	self._label = Instance.new("TextLabel", self._screenGui)
	self._gradient = Instance.new("UIGradient", self._canvas)

	self._screenGui.Enabled = false; task.delay(2.5, function() self._screenGui.Enabled = true end)
	self._screenGui.ResetOnSpawn = false
	self._screenGui.ScreenInsets = Enum.ScreenInsets.None
	self._canvas.AnchorPoint = Vector2.new(0.5, 0)
	self._canvas.BackgroundColor3 = Color3.new(0, 0, 0)
	self._canvas.BackgroundTransparency = self._borderMode and 0.7 or 1
	self._canvas.BorderSizePixel = 0
	self._canvas.Position = UDim2.new(0.5, 0, 0, 0) + Offset
	self._canvas.Size = UDim2.fromScale(0.33, 0.07)
	self._gradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.15, 0.379), NumberSequenceKeypoint.new(0.33, 0), NumberSequenceKeypoint.new(0.66, 0), NumberSequenceKeypoint.new(0.85, 0.379), NumberSequenceKeypoint.new(1, 1) })

	self._label.AnchorPoint = Vector2.new(0.5, 0)
	self._label.AutomaticSize = Enum.AutomaticSize.XY
	self._label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	self._label.BackgroundTransparency = self._borderMode and 0.7 or 1
	self._label.BorderSizePixel = 0
	self._label.Position = UDim2.fromScale(0.5, 0.08)
	self._label.TextColor3 = Color3.fromRGB(255, 255, 255)
	self._label.FontFace = Font.new("Montserrat", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
	self._label.TextSize = 22
	self._label.TextYAlignment = Enum.TextYAlignment.Bottom
	self._label.ZIndex = 2
	self._label.Visible = config.indicator

	Instance.new("UIPadding", self._label)
	self._label.UIPadding.PaddingLeft = UDim.new(0, 22)
	self._label.UIPadding.PaddingRight = UDim.new(0, 22)
	self._label.UIPadding.PaddingTop = UDim.new(0, 3)
	self._label.UIPadding.PaddingBottom = UDim.new(0, 3)

	Instance.new("UIGradient", self._label)
	self._label.UIGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.15, 0.379), NumberSequenceKeypoint.new(0.33, 0), NumberSequenceKeypoint.new(0.66, 0), NumberSequenceKeypoint.new(0.85, 0.379), NumberSequenceKeypoint.new(1, 1) })

	local midpoint = Instance.new("Frame", self._canvas)
	midpoint.Rotation = 45
	midpoint.AnchorPoint = Vector2.new(0.5, 0.5)
	midpoint.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
	midpoint.BorderSizePixel = 0
	midpoint.Size = UDim2.fromOffset(10, 10)
	midpoint.Position = UDim2.fromScale(0.5, 0)
	midpoint.ZIndex = 2




	self:Render()

	self.Changed:Connect(function()
		local currentAngle = self:GetDirection()
		local incrementAngle = math.floor(currentAngle) - math.floor(currentAngle) % self._increment

		for i, array in pairs(self._angles) do
			local threshold = self:CalculateDirection(array.Angle)
			array.Frame.Position = ((threshold >= 1) or (threshold <= 0)) and UDim2.fromScale(threshold, 0.5) or array.Frame.Position:Lerp(UDim2.fromScale(self:CalculateDirection(array.Angle), 0.5), self._time)
			array.Frame.Visible = not (array.Frame.Position.X.Scale >= 1 or array.Frame.Position.X.Scale <= 0)
		end

		self._label.Text = math.floor(currentAngle)
	end)

	return self
end


function Compass:GetDirection()
	return 180 - math.deg(math.atan2((workspace.CurrentCamera.CFrame.LookVector).X, (workspace.CurrentCamera.CFrame.LookVector).Z))
end


function Compass:CalculateDirection(angle)
	local relativeAngle = self:NormalizeAngle(angle - self._direction)

	if relativeAngle > 180 then
		relativeAngle = relativeAngle - 360
	end

	local clampedAngle = math.clamp(relativeAngle, -workspace.CurrentCamera.FieldOfView/2, workspace.CurrentCamera.FieldOfView/2)

	return (clampedAngle + workspace.CurrentCamera.FieldOfView/2) / workspace.CurrentCamera.FieldOfView
end


function Compass:Render()

	local function createAngle(angle)
		local Frame = Instance.new("Frame", self._canvas)
		Frame.AnchorPoint = Vector2.new(0.5, 0.5)
		Frame.Position = UDim2.fromScale(0.5, 0.5)
		Frame.BackgroundTransparency = 1
		Frame.Size = UDim2.new(0, 30, 1, 0)
		Frame.Visible = false
		Frame.BorderSizePixel = 0

		local TextLabel = Instance.new("TextLabel", Frame)
		TextLabel.Text = self._bigMarkings[angle] or self._smallMarkings[angle] or angle
		TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		TextLabel.AutomaticSize = Enum.AutomaticSize.XY
		TextLabel.BackgroundTransparency = 1
		TextLabel.BorderSizePixel = 0
		TextLabel.Position = UDim2.fromScale(0.5, 0.75)
		TextLabel.TextColor3 = Color3.fromRGB(215, 215, 215)
		TextLabel.FontFace = Font.new("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
		TextLabel.TextSize = self._bigMarkings[angle] and 35 or self._smallMarkings[angle] and 22 or 18
		TextLabel.TextTransparency = not (self._analogMode) and 0 or (self._analogMode and (self._bigMarkings[angle] or self._smallMarkings[angle])) and 0 or 1
		TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom

		local UIStroke = Instance.new("UIStroke", TextLabel)
		UIStroke.Color = Color3.fromRGB(0, 0, 0)
		UIStroke.Thickness = 1.5
		UIStroke.Enabled = not (self._analogMode) or (self._analogMode and (self._bigMarkings[angle] or self._smallMarkings[angle]))

		local UIGradient = Instance.new("UIGradient", UIStroke)
		UIGradient.Rotation = 90
		UIGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.733, 1), NumberSequenceKeypoint.new(1, 0.746) })

		local Indicator = Instance.new("Frame", Frame)
		Indicator.BackgroundColor3 = Color3.fromRGB(215, 215, 215)
		Indicator.BackgroundTransparency = 0
		Indicator.AnchorPoint = Vector2.new(0.5, 1)
		Indicator.Position = UDim2.fromScale(0.5, self._bigMarkings[angle] and 0.35 or 0.4)
		Indicator.Size = self._bigMarkings[angle] and UDim2.fromOffset(3, 14) or UDim2.fromOffset(3, 8)
		Indicator.BorderSizePixel = 0

		local UICorner = Instance.new("UICorner", Indicator)
		UICorner.CornerRadius = UDim.new(1, 0)

		return Frame
	end

	for i = 0, math.floor(360/self._increment) do
		local angle = (i * self._increment)
		if angle == 360 then continue end

		self._angles[i] = {
			Angle = angle,
			Frame = createAngle(angle)
		}
	end

	for degree, letter in self._bigMarkings do
		if not (self._angles[math.floor(degree/self._increment)]) then
			self.angles[math.floor(degree/self._increment)] = {
				Angle = degree,
				Frame = createAngle(math.floor(degree/self._increment))
			}
		end
	end 

	for degree, letter in self._smallMarkings do
		if not (self._angles[math.floor(degree/self._increment)]) then
			self.angles[math.floor(degree/self._increment)] = {
				Angle = degree,
				Frame = createAngle(math.floor(degree/self._increment))
			}
		end
	end 

	game:GetService("RunService").RenderStepped:Connect(function()
		local newDirection = self:GetDirection() 
		self._direction = newDirection
		self._changed:Fire()
	end)
end


Compass.new()
