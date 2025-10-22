--!nocheck
--!nolint
local Navigation, Class, Fusion, Fonts = {}, 
	require("../Libraries/Class"), 
	require("../Dependencies/Fusion"),
	require("../Templates/Fonts")
	Navigation.__index = Navigation
	Fusion = Fusion.scoped(Fusion)
	
	
function Navigation.new(parent: Instance)
	local self = Class.new {
		Active = true,
		Enabled = true,

		Analytics = false,
		Donate = true,
		Settings = shared["_db/environment"].studiomode,
		Back = false,
		Save = false,

		Body = Fusion:New "Frame" {
			Name = "Navigation",
			Parent = parent,
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = Color3.fromHex("#000000"),
			BackgroundTransparency = 0.625,
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 0, 79),
			LayoutOrder = 4,

			[Fusion.Tag "A"] = "donationboard@backdropcolor",
			[Fusion.Tag "B"] = "donationboard@backdroptransparency",
			[Fusion.Children] = {
				Fusion:New "UIPadding" {
					PaddingLeft = UDim.new(0, 15),
					PaddingRight = UDim.new(0, 15),
				},

				Fusion:New "UIListLayout" {
					Padding = UDim.new(0, 15),
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					HorizontalFlex = Enum.UIFlexAlignment.None,
					ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					VerticalFlex = Enum.UIFlexAlignment.None,
				 },

				Fusion:New "TextButton" {
					Name = "Analytics",
					AutoButtonColor = true,
					Size = UDim2.fromOffset(50, 50),

					[Fusion.Children] = {
						Fusion:New "UICorner" {
							CornerRadius = UDim.new(0, 4),
						},

						Fusion:New "UIGradient" {
							Color = ColorSequence.new(shared["donationboard@settings"].Colors[1], shared["donationboard@settings"].Colors[2]),
							Rotation = 90,
							[Fusion.Tag "A"] = "donationboard@colors12",
							[Fusion.Tag "B"] = "donationboard@rotation",
						},

						Fusion:New "ImageLabel" {
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundTransparency = 1,
							Position = UDim2.fromScale(0.5, 0.5),
							Size = UDim2.fromOffset(38, 38),
							Image = "rbxassetid://119076944242835",
							ImageColor3 = shared["donationboard@settings"].IconColor,
							ImageRectOffset = Vector2.new(37, 0),
							ImageRectSize = Vector2.new(36, 36),
							[Fusion.Tag "A"] = "donationboard@iconcolor",
						}
					}
				},

				Fusion:New "TextButton" {
					Name = "Donate",
					AutoButtonColor = true,
					Size = UDim2.new(1, 0, 0, 50),

					[Fusion.Children] = {
						Fusion:New "UIFlexItem" {
							FlexMode = Enum.UIFlexMode.Fill,
							ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
						},

						Fusion:New "UICorner" {
							CornerRadius = UDim.new(0, 4),
						},

						Fusion:New "UIGradient" {
							Color = ColorSequence.new(shared["donationboard@settings"].Colors[1], shared["donationboard@settings"].Colors[2]),
							Rotation = 90,
							[Fusion.Tag "A"] = "donationboard@colors12",
							[Fusion.Tag "B"] = "donationboard@rotation",
						},

						Fusion:New "ImageLabel" {
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundTransparency = 1,
							Position = UDim2.fromScale(0.5, 0.5),
							Size = UDim2.fromOffset(38, 38),
							Image = "rbxassetid://119076944242835",
							ImageColor3 = shared["donationboard@settings"].IconColor,
							ImageRectOffset = Vector2.new(74, 0),
							ImageRectSize = Vector2.new(36, 36),
							[Fusion.Tag "A"] = "donationboard@iconcolor",
						}
					}
				},

				Fusion:New "TextButton" {
					Name = "Back",
					AutoButtonColor = true,
					Size = UDim2.new(1, 0, 0, 50),
					Visible = false,

					[Fusion.Children] = {
						Fusion:New "UIFlexItem" {
							FlexMode = Enum.UIFlexMode.Fill,
							ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
						},

						Fusion:New "UICorner" {
							CornerRadius = UDim.new(0, 4),
						},

						Fusion:New "UIGradient" {
							Color = ColorSequence.new(shared["donationboard@settings"].Colors[1], shared["donationboard@settings"].Colors[2]),
							Rotation = 90,
							[Fusion.Tag "A"] = "donationboard@colors12",
							[Fusion.Tag "B"] = "donationboard@rotation",
						},

						Fusion:New "UIListLayout" {
							Padding = UDim.new(0, 4),
							FillDirection = Enum.FillDirection.Horizontal,
							SortOrder = Enum.SortOrder.LayoutOrder,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							HorizontalFlex = Enum.UIFlexAlignment.None,
							ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							VerticalFlex = Enum.UIFlexAlignment.None,
						},

						Fusion:New "ImageLabel" {
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundTransparency = 1,
							Position = UDim2.fromScale(0.5, 0.5),
							LayoutOrder = 1,
							Size = UDim2.fromOffset(38, 38),
							Image = "rbxassetid://119076944242835",
							ImageColor3 = shared["donationboard@settings"].IconColor,
							ImageRectOffset = Vector2.new(111, 37),
							ImageRectSize = Vector2.new(36, 36),
							[Fusion.Tag "A"] = "donationboard@iconcolor",
						},

						Fusion:New "TextLabel" {
							AutomaticSize = Enum.AutomaticSize.XY,
							BackgroundTransparency = 1,
							Size = UDim2.new(),
							LayoutOrder = 2,
							FontFace = Font.fromName(shared["donationboard@settings"].Font, Enum.FontWeight.Bold, Enum.FontStyle.Normal),
							Text = "Back",
							TextColor3 = shared["donationboard@settings"].TextColor,
							TextSize = 28,
							[Fusion.Tag "A"] = "donationboard@textcolor",
						},
					}
				},

				Fusion:New "TextButton" {
					Name = "Save",
					AutoButtonColor = true,
					Size = UDim2.new(1, 0, 0, 50),
					Visible = false,

					[Fusion.Children] = {
						Fusion:New "UIFlexItem" {
							FlexMode = Enum.UIFlexMode.Fill,
							ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
						},

						Fusion:New "UICorner" {
							CornerRadius = UDim.new(0, 4),
						},

						Fusion:New "UIGradient" {
							Color = ColorSequence.new(shared["donationboard@settings"].Colors[1], shared["donationboard@settings"].Colors[2]),
							Rotation = 90,
							[Fusion.Tag "A"] = "donationboard@colors12",
							[Fusion.Tag "B"] = "donationboard@rotation",
						},

						Fusion:New "UIListLayout" {
							Padding = UDim.new(0, 4),
							FillDirection = Enum.FillDirection.Horizontal,
							SortOrder = Enum.SortOrder.LayoutOrder,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							HorizontalFlex = Enum.UIFlexAlignment.None,
							ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							VerticalFlex = Enum.UIFlexAlignment.None,
						},

						Fusion:New "ImageLabel" {
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundTransparency = 1,
							Position = UDim2.fromScale(0.5, 0.5),
							LayoutOrder = 1,
							Size = UDim2.fromOffset(32, 32),
							Image = "rbxassetid://119076944242835",
							ImageColor3 = shared["donationboard@settings"].IconColor,
							ImageRectOffset = Vector2.new(296, 37),
							ImageRectSize = Vector2.new(36, 36),
							[Fusion.Tag "A"] = "donationboard@iconcolor",
						},

						Fusion:New "TextLabel" {
							AutomaticSize = Enum.AutomaticSize.XY,
							BackgroundTransparency = 1,
							Size = UDim2.new(),
							LayoutOrder = 2,
							FontFace = Font.fromName(shared["donationboard@settings"].Font, Enum.FontWeight.Bold, Enum.FontStyle.Normal),
							Text = "Save",
							TextColor3 = shared["donationboard@settings"].TextColor,
							TextSize = 28,
							[Fusion.Tag "A"] = "donationboard@textcolor",
						},
					}
				},

				Fusion:New "TextButton" {
					Name = "Settings",
					AutoButtonColor = true,
					Size = UDim2.fromOffset(50, 50),

					[Fusion.Children] = {
						Fusion:New "UICorner" {
							CornerRadius = UDim.new(0, 4),
						},

						Fusion:New "UIGradient" {
							Color = ColorSequence.new(shared["donationboard@settings"].Colors[1], shared["donationboard@settings"].Colors[2]),
							Rotation = 90,
							[Fusion.Tag "A"] = "donationboard@colors12",
							[Fusion.Tag "B"] = "donationboard@rotation",
						},

						Fusion:New "ImageLabel" {
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundTransparency = 1,
							Position = UDim2.fromScale(0.5, 0.5),
							Size = UDim2.fromOffset(38, 38),
							Image = "rbxassetid://119076944242835",
							ImageColor3 = shared["donationboard@settings"].IconColor,
							ImageRectOffset = Vector2.new(148, 0),
							ImageRectSize = Vector2.new(36, 36),
							[Fusion.Tag "A"] = "donationboard@iconcolor",
						},
					}
				},
			}
		},
	
		Buttons = {}
	}
	
	rawset(self, "Buttons", {
		--Analytics = self.Body.Analytics,
		Donate = self.Body.Donate,
		Settings = shared["_db/environment"].studiomode and self.Body.Settings or nil,
		Back = self.Body.Back,
		Save = self.Body.Save,
	})

	for key, button in self.Buttons do button.Visible = self[key] or false end
	self.Body.Analytics.Visible = false
	if (not shared["_db/environment"].studiomode) then
		self.Body.Settings.Visible = false
	end

	local Event do
		self.Changed:Connect(function(property, value)
			if (self.Buttons[property] ~= nil) then
				for index, button in self.Buttons do
					if (index ~= property) then continue end
					button.Visible = value
				end
				return
			end
		
			if (property) == "Active" then
				for index, button in self.Buttons do
					button.Active = value
				end
				return
			end

			if (property) == "Enabled" then
				self.Body.Visible = value
				return
			end
		end)
	end

	return self
end


return Navigation