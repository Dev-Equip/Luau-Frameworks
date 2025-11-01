--!nocheck
--!nolint
local DeveloperProducts, Class, Fusion, Rates, Util, Fonts = {}, 
	require("../Libraries/Class"), 
	require("../Dependencies/Fusion"),
	require("../Templates/Rates"),
	require("../Libraries/Util"),
	require("../Templates/Fonts")
	DeveloperProducts.__index = DeveloperProducts
	Fusion = Fusion.scoped(Fusion)
	
	
function DeveloperProducts.new(parent: Instance)
	local self = Class.new {
		Enabled = true,
		Keyword = "",

		Currency = "USD",
		CurrencyRate = Rates,

		Body = Fusion:New "Frame" {
			Parent = parent,
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, 100),
			Size = UDim2.new(1, 0, 0, 544),
			LayoutOrder = 2,
			
			[Fusion.Children] = {
				Fusion:New "UIFlexItem" {
					FlexMode = Enum.UIFlexMode.Fill,
				},

				Fusion:New "UIPadding" {
					PaddingLeft = UDim.new(0, 15),
					PaddingRight = UDim.new(0, 7),
					PaddingTop = UDim.new(0, 7),
				},
			
				Fusion:New "ScrollingFrame" {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.new(0, 0, 0, 0),
					LayoutOrder = 2,
					CanvasSize = UDim2.new(0, 0, 1, 1),
					ScrollingDirection = Enum.ScrollingDirection.Y,
					ScrollBarImageColor3 = shared["donationboard@settings"].Colors[1],
					ScrollBarThickness = 10,
					TopImage = "rbxassetid://90470681337364",
					MidImage = "rbxassetid://128864464627223",
					BottomImage = "rbxassetid://72306694687452",

					[Fusion.Tag "A"] = "donationboard@scrollbar",
					[Fusion.Children] = {
						Fusion:New "UIPadding" {
							PaddingBottom = UDim.new(0, 15),
							PaddingRight = UDim.new(0, 17),
							PaddingTop = UDim.new(0, 5),
						},
					
						Fusion:New "UIListLayout" {
							FillDirection = Enum.FillDirection.Vertical,
							SortOrder = Enum.SortOrder.LayoutOrder,
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							HorizontalFlex = Enum.UIFlexAlignment.None,
							ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
							VerticalAlignment = Enum.VerticalAlignment.Top,
							VerticalFlex = Enum.UIFlexAlignment.None,
						},
					},
				},

				Fusion:New "Frame" {
					BackgroundColor3 = shared["donationboard@settings"].Colors[1],
					BackgroundTransparency = 0.8,
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, -1, 0, 5),
					Size = UDim2.new(0, 10, 1, -11),
					ZIndex = 0,

					[Fusion.Tag "A"] = "donationboard@scrollbar",
					[Fusion.Children] = {
						Fusion:New "UICorner" {
							CornerRadius = UDim.new(1, 0),
						}
					}
				},
			}
		},

		Templates = {
			["all"] = function()
				return Fusion:New "CanvasGroup" {
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 0),

					[Fusion.Children] = {
						Fusion:New "UICorner" {
							CornerRadius = UDim.new(0, 5),
						},

						Fusion:New "UIPadding" {
							PaddingRight = UDim.new(0, 2),
						},

						Fusion:New "Frame" {
							Name = "Left",
							AutomaticSize = Enum.AutomaticSize.Y,
							BackgroundTransparency = 1,
							Position = UDim2.fromScale(0, 0),
							Size = UDim2.fromScale(1, 0),

							[Fusion.Children] = {
								Fusion:New "UIListLayout" {
									Padding = UDim.new(0, 8),
									FillDirection = Enum.FillDirection.Vertical,
									SortOrder = Enum.SortOrder.LayoutOrder,
									Wraps = false,
									HorizontalAlignment = Enum.HorizontalAlignment.Left,
									VerticalAlignment = Enum.VerticalAlignment.Top,
								},	
							
								Fusion:New "UIPadding" {
									PaddingBottom = UDim.new(0, 12),
									PaddingLeft = UDim.new(0, 10),
								},

								Fusion:New "TextLabel" {
									Name = "Title",
									BackgroundTransparency = 1,
									Size = UDim2.new(1, 0, 0, 24),
									LayoutOrder = 1,
									RichText = true,
									FontFace = Font.fromName(shared["donationboard@settings"].Font, Enum.FontWeight.Bold, Enum.FontStyle.Normal),
									TextColor3 = shared["donationboard@settings"].Colors[1],
									TextSize = 24,
									Text = "N/A",
									TextXAlignment = Enum.TextXAlignment.Left,
									[Fusion.Tag "A"] = "donationboard@color1",
								},

								Fusion:New "TextLabel" {
									Name = "Description",
									BackgroundTransparency = 1,
									Size = UDim2.new(1, 0, 0, 20),
									LayoutOrder = 2,
									FontFace = Font.fromName(shared["donationboard@settings"].Font, Enum.FontWeight.Regular, Enum.FontStyle.Normal),
									RichText = true,
									TextColor3 = shared["donationboard@settings"].TextColor,
									TextSize = 20,
									Text = "N/A",
									TextXAlignment = Enum.TextXAlignment.Left,
									[Fusion.Tag "A"] = "donationboard@textcolor",
								},
							},
						},

						Fusion:New "Frame" {
							Name = "Right",
							BackgroundTransparency = 1,
							Size = UDim2.fromScale(1, 1),
							
							[Fusion.Children] = {
								Fusion:New "UIListLayout" {
									Padding = UDim.new(0,  2),
									FillDirection = Enum.FillDirection.Horizontal,
									SortOrder = Enum.SortOrder.LayoutOrder,
									Wraps = false,
									HorizontalAlignment = Enum.HorizontalAlignment.Right,
									VerticalAlignment = Enum.VerticalAlignment.Center,
								},	
							
								Fusion:New "UIPadding" {
									PaddingBottom = UDim.new(0, 12),
									PaddingLeft = UDim.new(0, 10),
								},
							},
						},
					},
				}
			end,

			["product"] = function()
				return Fusion:New "CanvasGroup" {
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 0),

					[Fusion.Children] = {
						Fusion:New "UICorner" {
							CornerRadius = UDim.new(0, 5),
						},

						Fusion:New "UIPadding" {
							PaddingRight = UDim.new(0, 2),
						},

						Fusion:New "ImageLabel" {
							BackgroundTransparency = 1,
							Size = UDim2.fromOffset(50, 50),
							Image = "rbxassetid://119076944242835",
							ImageRectOffset = Vector2.new(333, 37),
							ImageRectSize = Vector2.new(36, 36),
							ImageColor3 = shared["donationboard@settings"].Colors[1],
							ImageTransparency = 0.5,
							[Fusion.Tag "A"] = "donationboard@color1",
						},

						Fusion:New "Frame" {
							Name = "Left",
							AutomaticSize = Enum.AutomaticSize.Y,
							BackgroundTransparency = 1,
							Position = UDim2.fromScale(0.099, 0),
							Size = UDim2.fromScale(0.901, 0),

							[Fusion.Children] = {
								Fusion:New "UIListLayout" {
									Padding = UDim.new(0, 8),
									FillDirection = Enum.FillDirection.Vertical,
									SortOrder = Enum.SortOrder.LayoutOrder,
									Wraps = false,
									HorizontalAlignment = Enum.HorizontalAlignment.Left,
									VerticalAlignment = Enum.VerticalAlignment.Top,
								},	
							
								Fusion:New "UIPadding" {
									PaddingBottom = UDim.new(0, 12),
									PaddingLeft = UDim.new(0, 10),
								},

								Fusion:New "TextLabel" {
									Name = "Title",
									BackgroundTransparency = 1,
									Size = UDim2.new(1, 0, 0, 24),
									LayoutOrder = 1,
									RichText = true,
									FontFace = Font.fromName(shared["donationboard@settings"].Font, Enum.FontWeight.Bold, Enum.FontStyle.Normal),
									TextColor3 = shared["donationboard@settings"].Colors[1],
									TextSize = 24,
									Text = "N/A",
									TextXAlignment = Enum.TextXAlignment.Left,
									[Fusion.Tag "A"] = "donationboard@color1",
								},

								Fusion:New "TextLabel" {
									Name = "Description",
									BackgroundTransparency = 1,
									Size = UDim2.new(1, 0, 0, 20),
									LayoutOrder = 2,
									FontFace = Font.fromName(shared["donationboard@settings"].Font, Enum.FontWeight.Regular, Enum.FontStyle.Normal),
									RichText = true,
									TextColor3 = shared["donationboard@settings"].TextColor,
									TextSize = 20,
									Text = "N/A",
									TextXAlignment = Enum.TextXAlignment.Left,
									[Fusion.Tag "A"] = "donationboard@textcolor",
								},
							},
						},

						Fusion:New "Frame" {
							Name = "Right",
							BackgroundTransparency = 1,
							Size = UDim2.fromScale(1, 1),
							
							[Fusion.Children] = {
								Fusion:New "UIListLayout" {
									Padding = UDim.new(0,  2),
									FillDirection = Enum.FillDirection.Horizontal,
									SortOrder = Enum.SortOrder.LayoutOrder,
									Wraps = false,
									HorizontalAlignment = Enum.HorizontalAlignment.Right,
									VerticalAlignment = Enum.VerticalAlignment.Center,
								},	
							
								Fusion:New "UIPadding" {
									PaddingBottom = UDim.new(0, 12),
									PaddingLeft = UDim.new(0, 10),
								},
							},
						},
					},
				}
			end,

			["checkbox"] = function()
				return Fusion:New "TextButton" {
					AutoButtonColor = true,
					Size = UDim2.fromOffset(30, 30),

					[Fusion.Children] = {
						Fusion:New "UICorner" {
							CornerRadius = UDim.new(0, 5),
						},

						Fusion:New "UIGradient" {
							Offset = Vector2.new(1, 1),
							Rotation = 90,
							Color = ColorSequence.new({
								ColorSequenceKeypoint.new(0, shared["donationboard@settings"].Colors[1]),
								ColorSequenceKeypoint.new(0.5, shared["donationboard@settings"].Colors[1]),
								ColorSequenceKeypoint.new(1, shared["donationboard@settings"].Colors[3]),
							}),
							[Fusion.Tag "A"] = "donationboard@colors123",
							[Fusion.Tag "B"] = "donationboard@rotation",
						},

						Fusion:New "UIStroke" {
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							Color = Color3.fromHex("#969696"),
							Thickness = 1.75,

							[Fusion.Children] = {
								Fusion:New "UIGradient" {
									Offset = Vector2.new(1, 0),
									Rotation = 90,
									Color = ColorSequence.new({
										ColorSequenceKeypoint.new(0, shared["donationboard@settings"].Colors[1]),
										ColorSequenceKeypoint.new(0.5, shared["donationboard@settings"].Colors[2]),
										ColorSequenceKeypoint.new(1, shared["donationboard@settings"].Colors[3]),
									}),
									[Fusion.Tag "A"] = "donationboard@colors123",
									[Fusion.Tag "B"] = "donationboard@rotation",
								},
							},
						},
					
						Fusion:New "ImageLabel" {
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundTransparency = 1,
							Position = UDim2.fromScale(0.5, 0.5),
							Size = UDim2.fromOffset(24, 24),
							Image = "rbxassetid://119076944242835",
							ImageColor3 = shared["donationboard@settings"].IconColor,
							ImageRectOffset = Vector2.new(0, 37),
							ImageRectSize = Vector2.new(36, 36),
							[Fusion.Tag "A"] = "donationboard@iconcolor",
						},
					},
				}
			end,
		},

		Actions = {"Search", "Fullscreen"},

		Clear = function(self)
			for _, canvas in self.Body.ScrollingFrame:GetChildren() do
				if canvas:IsA("CanvasGroup") then canvas:Destroy() end
			end
			return self
		end,
	
		Filter = function(self, keyword: string) 
			if (keyword) then self.Keyword = keyword return self end
			for _, canvas in self.Body.ScrollingFrame:GetChildren() do
				if not (canvas:IsA("CanvasGroup")) then continue end
				local hasKeyword = false
				for _, textlabel in canvas:GetDescendants() do 
					if (textlabel:IsA("TextLabel") and textlabel.Text:lower():gsub(",", ""):find(self.Keyword:lower():gsub(",", ""))) then
						hasKeyword = true
						break
					end

					if (textlabel:IsA("TextLabel") and tonumber(self.Keyword) and textlabel.Text:lower():find(Util.Commaify(tonumber(self.Keyword)))) then
						hasKeyword = true
						break
					end
				end

				canvas.Visible = #self.Keyword < 1 or hasKeyword
			end
			return self
		end,

		Generate = function(self, type: string)
			return function(properties)
				if (type:lower() == "checkbox") then
					properties = typeof(properties) == "table" and properties or {}
					local _temp, valueEvent = self.Templates.default(), Instance.new("BindableEvent")
					_temp.Parent = properties.Parent or nil
					self.Templates.checkbox().Parent = _temp.Right
					_temp.Left.Content:Destroy()

					local self = Class.new {
						Body = _temp,
						Title = properties.Title or "N/A",
						Description = properties.Description or "N/A",
						Content = _temp.Right,

						Checkbox = _temp.Right.TextButton,
						Value = properties.Value or false,

						ValueChanged = valueEvent.Event,
					}

					local Events do
						self.Checkbox.MouseButton1Click:Connect(function()
							self.Value = not self.Value
						end)

						self.Changed:Connect(function(property, value)
							if (property == "Value") then
								self.Checkbox.ImageLabel.Visible = self.Value
								self.Checkbox.BackgroundColor3 = self.Value and Color3.new(1, 1, 1) or Color3.new(0.117647, 0.109804, 0.117647)
								valueEvent:Fire(self.Value)
								return
							end

							if (property == "Title") then
								self.Body.Left.Title.Text = self.Title
								return
							end

							if (property == "Description") then
								self.Body.Left.Description.Text = self.Description
								return
							end
						end)
					end

					for index, value in self:GetValues() do
						self._changed:Fire(index, value)
					end
					
					return self
				end

				if (type:lower() == "product")  then
					properties = typeof(properties) == "table" and properties or {}
					local _temp, valueEvent = self.Templates.product(), Instance.new("BindableEvent")
					_temp.Parent = properties.Parent or nil
					self.Templates.checkbox().Parent = _temp.Right

					local self = Class.new {
						Body = _temp,
						Title = properties.Title or "N/A",
						Description = properties.Description or "N/A",
						Content = _temp.Right,

						Checkbox = _temp.Right.TextButton,
						Value = properties.Value or false,
						
						ValueChanged = valueEvent.Event,
					}

					local Events do
						self.Checkbox.MouseButton1Click:Connect(function()
							self.Value = not self.Value
						end)

						self.Changed:Connect(function(property, value)
							if (property == "Fire") then
								valueEvent:Fire(value)
							end
							
							if (property == "Value") then
								self.Checkbox.ImageLabel.Visible = self.Value
								self.Checkbox.BackgroundColor3 = self.Value and Color3.new(1, 1, 1) or Color3.new(0.117647, 0.109804, 0.117647)
								self.Body.GroupTransparency = self.Value and 0 or 0.5
								valueEvent:Fire(self.Value)
								return
							end

							if (property == "Title") then
								self.Body.Left.Title.Text = self.Title
								return
							end

							if (property == "Description") then
								self.Body.Left.Description.Text = self.Description
								return
							end
						end)
					end

					for index, value in self:GetValues() do
						self._changed:Fire(index, value)
					end
					
					return self
				end

				if (type:lower() == "all")  then
					properties = typeof(properties) == "table" and properties or {}
					local _temp, valueEvent, triggerEvent = self.Templates.product(), Instance.new("BindableEvent"), Instance.new("BindableEvent")
					_temp.Parent = properties.Parent or nil
					self.Templates.checkbox().Parent = _temp.Right

					local self = Class.new {
						Body = _temp,
						Title = properties.Title or "N/A",
						Description = properties.Description or "N/A",
						Content = _temp.Right,

						Checkbox = _temp.Right.TextButton,
						Value = properties.Value or false,

						ValueChanged = valueEvent.Event,
						Triggered = triggerEvent.Event,
					}

					local Events do
						self.Checkbox.MouseButton1Click:Connect(function()
							self.Value = not self.Value
							triggerEvent:Fire()
						end)

						self.Changed:Connect(function(property, value)
							if (property == "Trigger") then
								triggerEvent:Fire()
							end
							
							if (property == "Fire") then
								valueEvent:Fire(value)
							end
							
							if (property == "Value") then
								self.Checkbox.ImageLabel.Visible = self.Value
								self.Checkbox.BackgroundColor3 = self.Value and Color3.new(1, 1, 1) or Color3.new(0.117647, 0.109804, 0.117647)
								self.Body.GroupTransparency = self.Value and 0 or 0.5
								valueEvent:Fire(self.Value)
								return
							end

							if (property == "Title") then
								self.Body.Left.Title.Text = self.Title
								return
							end

							if (property == "Description") then
								self.Body.Left.Description.Text = self.Description
								return
							end
						end)
					end

					for index, value in self:GetValues() do
						self._changed:Fire(index, value)
					end
					
					return self
				end

				return nil
			end
		end,
	}

	local Event do
		self.Changed:Connect(function(property, value)
			if (property) == "Enabled" then
				self.Body.Visible = value
				self.Body.Parent = value and parent or nil
				return
			end
		
			if (property == "Keyword") then
				self:Filter()
				return
			end
		end)
	end

	return self
end


return DeveloperProducts