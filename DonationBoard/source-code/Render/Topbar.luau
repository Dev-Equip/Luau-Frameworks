--!nocheck
--!nolint
local Topbar, Class, Fusion, Fonts = {}, 
	require("../Libraries/Class"), 
	require("../Dependencies/Fusion"),
	require("../Templates/Fonts")
	Topbar.__index = Topbar
	Fusion = Fusion.scoped(Fusion)
	
	
function Topbar.new(parent: Instance)
	local self = Class.new {
		Enabled = true,

		Body = Fusion:New "Frame" {
			Name = "Topbar",
			Parent = parent,
			BackgroundColor3 = Color3.fromHex("#000000"),
			BackgroundTransparency = 0.625,
			Size = UDim2.new(1, 0, 0, 100),
			LayoutOrder = 1,

			[Fusion.Tag "A"] = "donationboard@backdropcolor",
			[Fusion.Tag "B"] = "donationboard@backdroptransparency",
			[Fusion.Children] = {
				Fusion:New "Frame" {
					Name = "TitleBar",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 50),

					[Fusion.Children] = {
						Fusion:New "UIListLayout" {
							FillDirection = Enum.FillDirection.Horizontal,
							SortOrder = Enum.SortOrder.LayoutOrder,
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							HorizontalFlex= Enum.UIFlexAlignment.None,
							ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
							VerticalAlignment = Enum.VerticalAlignment.Bottom,
							VerticalFlex= Enum.UIFlexAlignment.None,
						},

						Fusion:New "UIPadding" {
							PaddingRight = UDim.new(0, 15),
							PaddingLeft = UDim.new(0, 15),
						},

						Fusion:New "TextLabel" {
							AutomaticSize = Enum.AutomaticSize.XY,
							BackgroundTransparency = 1,
							Size = UDim2.fromScale(0, 0),
							FontFace = Font.fromName(shared["donationboard@settings"].Font, Enum.FontWeight.Bold, Enum.FontStyle.Normal),
							TextColor3 = shared["donationboard@settings"].TitleColor,
							TextSize = 39,
							TextXAlignment = Enum.TextXAlignment.Left,
							Text = "Untitled",
							[Fusion.Tag "A"] = "donationboard@titlecolor",
						},
					},
				},

				Fusion:New "Frame" {
					Name = "Actions",
					AnchorPoint = Vector2.new(0, 1),
					BackgroundTransparency = 1,
					Position = UDim2.fromScale(0, 1),
					Size = UDim2.new(1, 0, 0, 50),

					[Fusion.Children] = {
						Fusion:New "UIListLayout" {
							Padding = UDim.new(0, 8),
							FillDirection = Enum.FillDirection.Horizontal,
							SortOrder = Enum.SortOrder.LayoutOrder,
							HorizontalAlignment = Enum.HorizontalAlignment.Right,
							HorizontalFlex= Enum.UIFlexAlignment.None,
							ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							VerticalFlex= Enum.UIFlexAlignment.None,
						},	

						Fusion:New "UIPadding" {
							PaddingLeft = UDim.new(0, 15),
							PaddingRight = UDim.new(0, 15),
						},

						Fusion:New "TextButton" {
							Name = "Search",
							AutoButtonColor = true,
							BackgroundTransparency = 0.88,
							Size = UDim2.fromOffset(470, 30),
							Text = "",

							[Fusion.Children] = {
								Fusion:New "UIFlexItem" {
									FlexMode = Enum.UIFlexMode.Fill,
									ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
								},

								Fusion:New "ImageLabel" {
									AnchorPoint = Vector2.new(0, 0.5),
									BackgroundTransparency = 1,
									Position = UDim2.fromScale(0, 0.5),
									Size = UDim2.fromOffset(16, 16),
									Image = "rbxassetid://119076944242835",
									ImageColor3 = shared["donationboard@settings"].IconColor,
									ImageRectOffset = Vector2.new(259, 0),
									ImageRectSize = Vector2.new(36, 36),
									ImageTransparency = 0.33,
									[Fusion.Tag "A"] = "donationboard@iconcolor",
								},

								Fusion:New "TextBox" {
									BackgroundTransparency = 1,
									Position = UDim2.fromOffset(31, 0),
									ClearTextOnFocus = false,
									Size = UDim2.fromScale(0.948, 1),
									FontFace = Font.fromName(shared["donationboard@settings"].Font, Enum.FontWeight.Regular, Enum.FontStyle.Normal),
									PlaceholderColor3 = shared["donationboard@settings"].TextColor,
									PlaceholderText = "Search",
									TextColor3 = shared["donationboard@settings"].TextColor,
									Text = "",
									TextSize = 18,
									TextTransparency = 0.5,
									TextXAlignment = Enum.TextXAlignment.Left,
									[Fusion.Tag "A"] = "donationboard@textcolor",
								},

								Fusion:New "UIPadding" {
									PaddingLeft = UDim.new(0, 9),
									PaddingRight = UDim.new(0, 9),
								},

								Fusion:New "UIGradient" {
									Offset = Vector2.new(1, 1),
									Color = ColorSequence.new(shared["donationboard@settings"].Colors[1], shared["donationboard@settings"].Colors[2]),
									Rotation = 90,
									[Fusion.Tag "A"] = "donationboard@colors12",
									[Fusion.Tag "B"] = "donationboard@rotation",
								},

								Fusion:New "UICorner" {
									CornerRadius = UDim.new(0, 4),
								},
							},
						},

						Fusion:New "TextButton" {
							Name = "SortDirection",
							AutoButtonColor = true,
							Size = UDim2.fromOffset(30, 30),
							LayoutOrder = 1,
							Text = "",

							[Fusion.Children] = {
								Fusion:New "ImageLabel" {
									AnchorPoint = Vector2.new(0.5, 0.5),
									BackgroundTransparency = 1,
									Position = UDim2.fromScale(0.5, 0.5),
									Size = UDim2.fromOffset(26, 26),
									Image = "rbxassetid://119076944242835",
									ImageColor3 = shared["donationboard@settings"].IconColor,
									ImageRectOffset = Vector2.new(370, 0),
									ImageRectSize = Vector2.new(36, 36),
									ImageTransparency = 0,
									[Fusion.Tag "A"] = "donationboard@iconcolor",
									[Fusion.Children] = {
										Fusion:New "UIGradient" {
											Offset = Vector2.new(1, 1),
											Enabled = false,
											Color = ColorSequence.new(shared["donationboard@settings"].Colors[1], shared["donationboard@settings"].Colors[2]),
											Rotation = 90,
											[Fusion.Tag "A"] = "donationboard@colors12",
											[Fusion.Tag "B"] = "donationboard@rotation",
										},
									},
								},

								Fusion:New "UIGradient" {
									Offset = Vector2.new(1, 1),
									Color = ColorSequence.new(shared["donationboard@settings"].Colors[1], shared["donationboard@settings"].Colors[2]),
									Rotation = 90,
									[Fusion.Tag "A"] = "donationboard@colors12",
									[Fusion.Tag "B"] = "donationboard@rotation",
								},

								Fusion:New "UICorner" {
									CornerRadius = UDim.new(0, 4),
								},
							},
						},

						Fusion:New "TextButton" {
							Name = "SortOrder",
							AutoButtonColor = true,
							Size = UDim2.fromOffset(30, 30),
							LayoutOrder = 1,
							Text = "",

							[Fusion.Children] = {
								Fusion:New "ImageLabel" {
									AnchorPoint = Vector2.new(0.5, 0.5),
									BackgroundTransparency = 1,
									Position = UDim2.fromScale(0.5, 0.5),
									Size = UDim2.fromOffset(26, 26),
									Image = "rbxassetid://119076944242835",
									ImageColor3 = shared["donationboard@settings"].IconColor,
									ImageRectOffset = Vector2.new(185, 37),
									ImageRectSize = Vector2.new(36, 36),
									ImageTransparency = 0,
									[Fusion.Tag "A"] = "donationboard@iconcolor",
									[Fusion.Children] = {
										Fusion:New "UIGradient" {
											Offset = Vector2.new(1, 1),
											Enabled = false,
											Color = ColorSequence.new(shared["donationboard@settings"].Colors[1], shared["donationboard@settings"].Colors[2]),
											Rotation = 90,
											[Fusion.Tag "A"] = "donationboard@colors12",
											[Fusion.Tag "B"] = "donationboard@rotation",
										},
									},
								},

								Fusion:New "UIGradient" {
									Offset = Vector2.new(1, 1),
									Color = ColorSequence.new(shared["donationboard@settings"].Colors[1], shared["donationboard@settings"].Colors[2]),
									Rotation = 90,
									[Fusion.Tag "A"] = "donationboard@colors12",
									[Fusion.Tag "B"] = "donationboard@rotation",
								},

								Fusion:New "UICorner" {
									CornerRadius = UDim.new(0, 4),
								},
							},
						},

						Fusion:New "TextButton" {
							Name = "Tax",
							AutoButtonColor = true,
							Size = UDim2.fromOffset(30, 30),
							LayoutOrder = 1,
							Text = "",

							[Fusion.Children] = {
								Fusion:New "ImageLabel" {
									AnchorPoint = Vector2.new(0.5, 0.5),
									BackgroundTransparency = 1,
									Position = UDim2.fromScale(0.5, 0.5),
									Size = UDim2.fromOffset(18, 18),
									Image = "rbxassetid://119076944242835",
									ImageColor3 = shared["donationboard@settings"].IconColor,
									ImageRectOffset = Vector2.new(296, 0),
									ImageRectSize = Vector2.new(36, 36),
									ImageTransparency = 0,
									[Fusion.Tag "A"] = "donationboard@iconcolor",
									[Fusion.Children] = {
										Fusion:New "UIGradient" {
											Offset = Vector2.new(1, 1),
											Enabled = false,
											Color = ColorSequence.new(shared["donationboard@settings"].Colors[1], shared["donationboard@settings"].Colors[2]),
											Rotation = 90,
											[Fusion.Tag "A"] = "donationboard@colors12",
											[Fusion.Tag "B"] = "donationboard@rotation",
										},
									},
								},

								Fusion:New "UIGradient" {
									Offset = Vector2.new(1, 1),
									Color = ColorSequence.new(shared["donationboard@settings"].Colors[1], shared["donationboard@settings"].Colors[2]),
									Rotation = 90,
									[Fusion.Tag "A"] = "donationboard@colors12",
									[Fusion.Tag "B"] = "donationboard@rotation",
								},

								Fusion:New "UICorner" {
									CornerRadius = UDim.new(0, 4),
								},
							},
						},

						Fusion:New "TextButton" {
							Name = "Conversion",
							AutoButtonColor = true,
							Size = UDim2.fromOffset(30, 30),
							LayoutOrder = 1,
							Text = "",

							[Fusion.Children] = {
								Fusion:New "ImageLabel" {
									AnchorPoint = Vector2.new(0.5, 0.5),
									BackgroundTransparency = 1,
									Position = UDim2.fromScale(0.5, 0.5),
									Size = UDim2.fromOffset(20, 20),
									Image = "rbxassetid://119076944242835",
									ImageColor3 = shared["donationboard@settings"].IconColor,
									ImageRectOffset = Vector2.new(222, 37),
									ImageRectSize = Vector2.new(36, 36),
									ImageTransparency = 0,
									[Fusion.Tag "A"] = "donationboard@iconcolor",
									[Fusion.Children] = {
										Fusion:New "UIGradient" {
											Offset = Vector2.new(1, 1),
											Enabled = false,
											Color = ColorSequence.new(shared["donationboard@settings"].Colors[1], shared["donationboard@settings"].Colors[2]),
											Rotation = 90,
											[Fusion.Tag "A"] = "donationboard@colors12",
											[Fusion.Tag "B"] = "donationboard@rotation",
										},
									},
								},

								Fusion:New "UIGradient" {
									Offset = Vector2.new(1, 1),
									Color = ColorSequence.new(shared["donationboard@settings"].Colors[1], shared["donationboard@settings"].Colors[2]),
									Rotation = 90,
									[Fusion.Tag "A"] = "donationboard@colors12",
									[Fusion.Tag "B"] = "donationboard@rotation",
								},

								Fusion:New "UICorner" {
									CornerRadius = UDim.new(0, 4),
								},
							},
						},

						Fusion:New "TextButton" {
							Name = "Fullscreen",
							AutoButtonColor = true,
							LayoutOrder = 4,
							Size = UDim2.fromOffset(30, 30),
							Text = "",

							[Fusion.Children] = {
								Fusion:New "ImageLabel" {
									AnchorPoint = Vector2.new(0.5, 0.5),
									BackgroundTransparency = 1,
									Position = UDim2.fromScale(0.5, 0.5),
									Size = UDim2.fromOffset(18, 18),
									Image = "rbxassetid://119076944242835",
									ImageColor3 = shared["donationboard@settings"].IconColor,
									ImageRectOffset = Vector2.new(185, 0),
									ImageRectSize = Vector2.new(36, 36),
									ImageTransparency = 0,
									[Fusion.Tag "A"] = "donationboard@iconcolor",
									[Fusion.Children] = {
										Fusion:New "UIGradient" {
											Offset = Vector2.new(1, 1),
											Enabled = false,
											Color = ColorSequence.new(shared["donationboard@settings"].Colors[1], shared["donationboard@settings"].Colors[2]),
											Rotation = 90,
											[Fusion.Tag "A"] = "donationboard@colors12",
											[Fusion.Tag "B"] = "donationboard@rotation",
										},
									},
								},

								Fusion:New "UIGradient" {
									Offset = Vector2.new(1, 1),
									Color = ColorSequence.new(shared["donationboard@settings"].Colors[1], shared["donationboard@settings"].Colors[2]),
									Rotation = 90,
									[Fusion.Tag "A"] = "donationboard@colors12",
									[Fusion.Tag "B"] = "donationboard@rotation",
								},

								Fusion:New "UICorner" {
									CornerRadius = UDim.new(0, 4),
								},
							},
						},
					}
				}
			}
		},
	
		Actions = {"Search", "Fullscreen", "SortOrder", "SortDirection", "Tax", "Conversion"},
		Disabled = Class.new {
			Search = true,
			Fullscreen = true,
			SortOrder = true,
			SortDirection = true,
			Tax = true,
			Conversion = true,
		},
	}

	rawset(self, "Title", self.Body.TitleBar.TextLabel)
	rawset(self, "Search", self.Body.Actions.Search)
	rawset(self, "Fullscreen", self.Body.Actions.Fullscreen)
	rawset(self, "SortOrder", self.Body.Actions.SortOrder)
	rawset(self, "SortDirection", self.Body.Actions.SortDirection)
	rawset(self, "Tax", self.Body.Actions.Tax)
	rawset(self, "Conversion", self.Body.Actions.Conversion)

	local Event do
		self.Disabled.Changed:Connect(function(property, value)
			local isAllTrue = 0
			for _, buttonName in {"Search", "Fullscreen", "SortOrder", "SortDirection", "Tax", "Conversion"} do
				if (self.Disabled[buttonName] == false) then
					self[buttonName].Visible = false
					isAllTrue += 1
					continue
				end
				self[buttonName].Visible = table.find(self.Actions, buttonName) ~= nil
			end

			self.Body.Size = UDim2.new(1, 0, 0, 50 + (isAllTrue/6 < 1 and 50 or 0))			
			return
		end)

		self.Changed:Connect(function(property, value)		
			if (property) == "Enabled" then
				self.Body.Visible = value
				return
			end

			if (property == "Actions") then
				for _, buttonName in {"Search", "Fullscreen", "SortOrder", "SortDirection", "Tax", "Conversion"} do
					if (self.Disabled[buttonName] == false) then
						self[buttonName].Visible = false
						continue
					end
					self[buttonName].Visible = table.find(self.Actions, buttonName) ~= nil
				end
				return
			end
		end)
	end

	return self
end


return Topbar