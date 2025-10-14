--!nocheck
--!nolint
local Rig, Class, Fusion, Fonts = {}, 
	require("../../Libraries/Class"), 
	require("../../Dependencies/Fusion"),
	require("../../Templates/Fonts")
	Rig.__index, Fusion = Rig, Fusion.scoped(Fusion)


local TemplateR6, TemplateR15 = game:GetService("ServerStorage").R6, game:GetService("ServerStorage").R15


export type classType = {
	UserId: number,
	RigType: string,
	R15AnimationId: string,
	R6AnimationId: string,
	Description: HumanoidDescription,
	Rig: Model,
	Pivot: CFrame,
	Scale: number,
	Collision: boolean,
	GetCharacterHeight: (self: classType) -> number,
} 


function Rig.new(cframe: CFrame)
	local self = Class.new {
		UserId = 0,
		RigType = "auto",
		R15AnimationId = "rbxassetid://0",
		R6AnimationId = "rbxassetid://0",
		Description = game:GetService("Players"):GetHumanoidDescriptionFromUserId(1),
		Rig = TemplateR15:Clone(),
		Tag = Fusion:New "BillboardGui" {
			Brightness = 1,
			LightInfluence = 0,
			MaxDistance = 0,
			ResetOnSpawn = false,
			Size = UDim2.fromScale(6, 2.5),
			StudsOffsetWorldSpace = Vector3.yAxis * 4.405,

			[Fusion.Children] = {
				Fusion:New "Frame" {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(1, 1),

					[Fusion.Children] = {
						Fusion:New "UIListLayout" {
							Padding = UDim.new(0, 5),
							FillDirection = Enum.FillDirection.Vertical,
							SortOrder = Enum.SortOrder.LayoutOrder,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							VerticalAlignment = Enum.VerticalAlignment.Bottom,
						},

						Fusion:New "TextLabel" {
							Name = "Rank",
							AnchorPoint = Vector2.new(0, 0),
							BackgroundTransparency = 1,
							LayoutOrder = 1,
							Size = UDim2.fromScale(1, 0.325),
							FontFace = Font.fromName(shared["donationboard@settings"].Font, Enum.FontWeight.Bold, Enum.FontStyle.Normal),
							Font = Enum.Font[shared["donationboard@settings"].Font],
							Text = "#999",
							TextColor3 = Color3.new(1, 1, 1),
							TextTransparency = 0.3,
							TextScaled = true,
							TextWrapped = false,
							TextXAlignment = Enum.TextXAlignment.Center,
							TextYAlignment = Enum.TextYAlignment.Center,

							[Fusion.Children] = {
								Fusion:New "UIStroke" {
									ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
									Color = Color3.new(0.568627, 0.568627, 0.568627),
									Thickness = 1.5,
									Transparency = 0.25,
								}
							}
						},

						Fusion:New "TextLabel" {
							Name = "Username",
							AnchorPoint = Vector2.new(0, 0),
							BackgroundTransparency = 1,
							LayoutOrder = 2,
							Size = UDim2.fromScale(1, 0.225),
							FontFace = Font.fromName(shared["donationboard@settings"].Font, Enum.FontWeight.Regular, Enum.FontStyle.Normal),
							Text = "@n/a",
							TextColor3 = Color3.new(1, 1, 1),
							TextScaled = true,
							TextWrapped = false,
							TextXAlignment = Enum.TextXAlignment.Center,
							TextYAlignment = Enum.TextYAlignment.Center,

							[Fusion.Children] = {
								Fusion:New "UIStroke" {
									ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
									Color = Color3.fromHex("#919191"),
									Thickness = 1.5,
									Transparency = 0.25,
								}
							}
						},

						Fusion:New "TextLabel" {
							Name = "Robux",
							AnchorPoint = Vector2.new(0.5, 0),
							BackgroundTransparency = 1,
							LayoutOrder = 3,
							Size = UDim2.fromScale(0.5, 0.15),
							FontFace = Font.fromName(shared["donationboard@settings"].Font, Enum.FontWeight.Bold, Enum.FontStyle.Normal),
							Text = utf8.char(0xE002).." 999,999,999",
							TextColor3 = Color3.fromHex("#ffb969"),
							TextScaled = true,
							TextWrapped = false,
							TextXAlignment = Enum.TextXAlignment.Center,
							TextYAlignment = Enum.TextYAlignment.Center,

							[Fusion.Children] = {
								Fusion:New "UIStroke" {
									ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
									Color = Color3.fromHex("#91693c"),
									Thickness = 1.5,
									Transparency = 0.25,
								}
							}
						}
					}
				}
			},
		},
		Pivot = cframe,
		Parent = workspace,
		Scale = 1,
		Collision = false,

		GetCharacterHeight = function(self)
			local humanoid = self.Rig:FindFirstChild("Humanoid")
			if not humanoid then return 0 end
			
			local topY = -math.huge
			local bottomY = math.huge
			
			for _, part in self.Rig:GetChildren() do
				if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
					if humanoid:GetBodyPartR15(part) or part.Name == "Head" or part.Name:find("Leg") then
						local cf = part.CFrame
						local size = part.Size
						local top = (cf.Position + Vector3.new(0, size.Y/2, 0)).Y
						local bottom = (cf.Position - Vector3.new(0, size.Y/2, 0)).Y
						if top > topY then topY = top end
						if bottom < bottomY then bottomY = bottom end
					end
				end
			end
			
			return topY - bottomY
		end,

		GetCharacterPivotPosition = function(self)
			return self.Pivot * CFrame.new(0, self:GetFootToHRPOffset() + (self.Rig.Humanoid.RigType == Enum.HumanoidRigType.R6 and 0.5 or 0), 0)
		end,
	
		GetFootToHRPOffset = function(self)
			local humanoid = self.Rig:FindFirstChild("Humanoid")
			if not humanoid then return 0 end
			local hrp = self.Rig:FindFirstChild("HumanoidRootPart")
			if not hrp then return 0 end

			if humanoid.RigType == Enum.HumanoidRigType.R15 then
				local leftFoot = self.Rig:FindFirstChild("LeftFoot")
				local rightFoot = self.Rig:FindFirstChild("RightFoot")
				if not leftFoot or not rightFoot then return 0 end

				local leftY = leftFoot.Position.Y - leftFoot.Size.Y/2
				local rightY = rightFoot.Position.Y - rightFoot.Size.Y/2
				local bottomY = math.min(leftY, rightY)

				return hrp.Position.Y - bottomY
			else
				local leftLeg = self.Rig:FindFirstChild("Left Leg")
				local rightLeg = self.Rig:FindFirstChild("Right Leg")
				if not leftLeg or not rightLeg then return 0 end

				local leftY = leftLeg.Position.Y - leftLeg.Size.Y
				local rightY = rightLeg.Position.Y - rightLeg.Size.Y
				local bottomY = math.min(leftY, rightY)

				return hrp.Position.Y - (bottomY)
			end
		end,

		Update = function(self)
			self._changed:Fire("UserId")
		end,
	} 
	
	rawset(self, "Rank", self.Tag.Frame.Rank)
	rawset(self, "Username", self.Tag.Frame.Username)
	rawset(self, "Robux", self.Tag.Frame.Robux)

	local Event do
		self.Changed:Connect(function(property: string, value: any)
			if (property:find("Animationid")) then
				Rig._playAnimation(self.Rig, self.Rig.Humanoid.RigType.Name == "R6" and self.R6AnimationId or self.R15AnimationId)
				return
			end

			if (property == "Pivot") then
				self.Rig:PivotTo(self:GetCharacterPivotPosition())
				return
			end

			if (property == "Scale") then
				self.Rig:ScaleTo(self.Scale)
				self.Tag.Size = UDim2.fromScale(6 * self.Scale, 2.5 * self.Scale)
				self.Tag.StudsOffsetWorldSpace = Vector3.yAxis * 4.405 * self.Scale
				self.Tag.Frame.Rotation = (math.deg(math.acos(Vector3.yAxis:Dot(self.Rig.Head.CFrame.UpVector)))) * (self.Rig.Head.CFrame.RightVector:Dot(Vector3.yAxis) > 0 and 1 or -1) == (math.deg(math.acos(Vector3.yAxis:Dot(self.Rig.Head.CFrame.UpVector)))) * (self.Rig.Head.CFrame.RightVector:Dot(Vector3.yAxis) > 0 and 1 or -1) and (math.deg(math.acos(Vector3.yAxis:Dot(self.Rig.Head.CFrame.UpVector)))) * (self.Rig.Head.CFrame.RightVector:Dot(Vector3.yAxis) > 0 and 1 or -1) or 0
				return
			end

			if (property == "Collision") then
				for _, basepart in self.Rig:GetDescendants() do
					if (not basepart:IsA("BasePart")) then continue end
					basepart.CanCollide = self.Collision
				end
				return
			end

			if (table.find({"UserId", "RigType"}, property)) then
				if (not tonumber(self.UserId) or tonumber(self.UserId) < 1) then
					self.Tag.Parent = nil
					if self.Rig then self.Rig:Destroy() end
					return
				end
				
				self.Description = game:GetService("Players"):GetHumanoidDescriptionFromUserId(tonumber(self.UserId))
				local _temp = Rig._generateRig(self.RigType, self.UserId, self.Description)
				self.Tag.Parent = nil
				if (self.Rig) then self.Rig:Destroy() end
				self.Rig = _temp
				self.Rig.Parent = self.Parent
				self.Rig.HumanoidRootPart.Anchored = true
				self.Rig.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
				self.Rig.Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
				self.Tag.Parent = self.Rig
				self.Rig:ScaleTo(self.Scale)
				self.Rig:PivotTo(self:GetCharacterPivotPosition())
				self.Tag.Size = UDim2.fromScale(6 * self.Scale, 2.5 * self.Scale)
				self.Tag.StudsOffsetWorldSpace = Vector3.yAxis * 4.405 * self.Scale
				self.Tag.Frame.Rotation = (math.deg(math.acos(Vector3.yAxis:Dot(self.Rig.Head.CFrame.UpVector)))) * (self.Rig.Head.CFrame.RightVector:Dot(Vector3.yAxis) > 0 and 1 or -1) == (math.deg(math.acos(Vector3.yAxis:Dot(self.Rig.Head.CFrame.UpVector)))) * (self.Rig.Head.CFrame.RightVector:Dot(Vector3.yAxis) > 0 and 1 or -1) and (math.deg(math.acos(Vector3.yAxis:Dot(self.Rig.Head.CFrame.UpVector)))) * (self.Rig.Head.CFrame.RightVector:Dot(Vector3.yAxis) > 0 and 1 or -1) or 0
				Rig._playAnimation(self.Rig, self.Rig.Humanoid.RigType.Name == "R6" and self.R6AnimationId or self.R15AnimationId)
				task.delay(1, function()
					for _, basepart in self.Rig:GetDescendants() do
						if (not basepart:IsA("BasePart")) then continue end
						basepart.CanCollide = self.Collision
					end
				end)

				return
			end 
		end)
	end

    return self :: typeof(self) & classType
end


function Rig._generateRig(rigType: string, userId: number, description: HumanoidDescription)
	if (rigType:lower() == "auto") then
		local temp = game:GetService("Players"):CreateHumanoidModelFromUserId(userId, Enum.AssetTypeVerification.ClientOnly)
		temp.Parent = game:GetService("ReplicatedStorage")
		temp.Name = userId
		return temp
	end

	local temp = rigType:lower() == "r6" and TemplateR6:Clone() or TemplateR15:Clone()
	temp:PivotTo(CFrame.new())
	temp.Parent = game:GetService("ReplicatedStorage")
	temp.Humanoid:ApplyDescription(description, Enum.AssetTypeVerification.ClientOnly)
	temp.Name = userId
	return temp
end


function Rig._playAnimation(rig, animationId: string)
	for _, track in rig.Humanoid.Animator:GetPlayingAnimationTracks() do track:Stop() end
	if (table.find({"", "0", "rbxassetid://", "rbxassetid://0"}, animationId)) then return end
	local Animation = Instance.new("Animation", rig)
	pcall(function()
		Animation.AnimationId = animationId
		rig.Humanoid.Animator:LoadAnimation(Animation):Play()
	end)
end


return Rig