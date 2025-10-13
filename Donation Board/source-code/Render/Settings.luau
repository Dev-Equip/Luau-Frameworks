--!nocheck
--!nolint
local Settings, Class, Fusion, Rates, Util, Fonts = {}, 
	require("../Libraries/Class"), 
	require("../Dependencies/Fusion"),
	require("../Templates/Rates"),
	require("../Libraries/Util"),
	require("../Templates/Fonts")
	Settings.__index = Settings
	Fusion = Fusion.scoped(Fusion)
	
	
function Settings.new(parent: Instance)
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
							Padding = UDim.new(0, 12),
							FillDirection = Enum.FillDirection.Vertical,
							SortOrder = Enum.SortOrder.LayoutOrder,
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							HorizontalFlex = Enum.UIFlexAlignment.None,
							ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
							VerticalAlignment = Enum.VerticalAlignment.Top,
							VerticalFlex = Enum.UIFlexAlignment.None,
						},
					}
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
			["default"] = function()
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
							Name = "Divider",
							AnchorPoint = Vector2.new(0.5, 1),
							BackgroundColor3 = Color3.fromHex("#646464"),
							BackgroundTransparency = 0.65,
							Position = UDim2.fromScale(0.5, 1),
							Size = UDim2.new(1, 0, 0, 2),

							[Fusion.Children] = {
								Fusion:New "UIGradient" {
									Color = ColorSequence.new({
										ColorSequenceKeypoint.new(0, shared["donationboard@settings"].Colors[1]),
										ColorSequenceKeypoint.new(0.5, shared["donationboard@settings"].Colors[2]),
										ColorSequenceKeypoint.new(1, shared["donationboard@settings"].Colors[3])
									}),

									[Fusion.Tag "A"] = "donationboard@colors123",
									[Fusion.Tag "B"] = "donationboard@rotation",
								}
							},
						},

						Fusion:New "Frame" {
							Name = "Left",
							AutomaticSize = Enum.AutomaticSize.Y,
							BackgroundTransparency = 1,
							Size = UDim2.fromScale(1, 0),

							[Fusion.Children] = {
								Fusion:New "UIListLayout" {
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
									FontFace = Font.new(Fonts[shared["donationboard@settings"].Font], Enum.FontWeight.Bold, Enum.FontStyle.Normal),
									TextColor3 = shared["donationboard@settings"].TextColor,
									TextSize = 24,
									Text = "N/A",
									TextXAlignment = Enum.TextXAlignment.Left,
									[Fusion.Tag "A"] = "donationboard@textcolor",
								},

								Fusion:New "TextLabel" {
									Name = "Description",
									BackgroundTransparency = 1,
									Size = UDim2.new(1, 0, 0, 20),
									LayoutOrder = 2,
									FontFace = Font.new(Fonts[shared["donationboard@settings"].Font], Enum.FontWeight.Regular, Enum.FontStyle.Normal),
									RichText = true,
									TextColor3 = shared["donationboard@settings"].TextColor,
									TextTransparency = 0.25,
									TextSize = 20,
									Text = "N/A",
									TextXAlignment = Enum.TextXAlignment.Left,
									[Fusion.Tag "A"] = "donationboard@textcolor",
								},

								Fusion:New "Frame" {
									Name = "Content",
									AutomaticSize = Enum.AutomaticSize.Y,
									BackgroundTransparency = 1,
									Size = UDim2.fromScale(1, 0),
									LayoutOrder = 3,
									[Fusion.Children] = {
										Fusion:New "UIListLayout" {
											Padding = UDim.new(0, 15),
											FillDirection = Enum.FillDirection.Horizontal,
											SortOrder = Enum.SortOrder.LayoutOrder,
											Wraps = false,
											HorizontalAlignment = Enum.HorizontalAlignment.Center,
											HorizontalFlex = Enum.UIFlexAlignment.Fill,
											VerticalAlignment = Enum.VerticalAlignment.Top,
										},

										Fusion:New "UIPadding" {
											PaddingTop = UDim.new(0, 20),
										},
									},
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

			["slider"] = function()
				return Fusion:New "TextButton" {
					AutoButtonColor = true,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = Color3.new(1, 1, 1),
					BackgroundTransparency = 0.8,
					Size = UDim2.new(1, 0, 0, 10),
					Text = "",

					[Fusion.Children] = {
						Fusion:New "UICorner" {
							CornerRadius = UDim.new(1, 0),
						},

						Fusion:New "UIGradient" {
							Color = ColorSequence.new({
								ColorSequenceKeypoint.new(0, shared["donationboard@settings"].Colors[1]),
								ColorSequenceKeypoint.new(0.5, shared["donationboard@settings"].Colors[2]),
								ColorSequenceKeypoint.new(1, shared["donationboard@settings"].Colors[3]),
							}),

							[Fusion.Tag "A"] = "donationboard@colors123",
							[Fusion.Tag "B"] = "donationboard@rotation",
						},

						Fusion:New "Frame" {
							Name = "Points", 
							Active = false,
							BackgroundTransparency = 1,
							Size = UDim2.fromScale(1, 1),

							[Fusion.Children] = {
								Fusion:New "UIListLayout" {
									FillDirection = Enum.FillDirection.Horizontal,
									Wraps = false,
									HorizontalAlignment = Enum.HorizontalAlignment.Center,
									HorizontalFlex = Enum.UIFlexAlignment.SpaceAround,
									VerticalAlignment = Enum.VerticalAlignment.Center,
								},

								Fusion:New "Frame" {
									BackgroundTransparency = 0.85,
									Size = UDim2.fromOffset(6, 6),
								},

								Fusion:New "Frame" {
									BackgroundTransparency = 0.85,
									Size = UDim2.fromOffset(6, 6),
								},

								Fusion:New "Frame" {
									BackgroundTransparency = 0.85,
									Size = UDim2.fromOffset(6, 6),
								},

								Fusion:New "Frame" {
									BackgroundTransparency = 0.85,
									Size = UDim2.fromOffset(6, 6),
								},

								Fusion:New "Frame" {
									BackgroundTransparency = 0.85,
									Size = UDim2.fromOffset(6, 6),
								},

								Fusion:New "Frame" {
									BackgroundTransparency = 0.85,
									Size = UDim2.fromOffset(6, 6),
								},

								Fusion:New "Frame" {
									BackgroundTransparency = 0.85,
									Size = UDim2.fromOffset(6, 6),
								},
							},
						},
					
						Fusion:New "Frame" {
							Name = "Fill",
							Active = false,
							Size = UDim2.fromScale(0, 1),
							ZIndex = 2,

							[Fusion.Children] = {
								Fusion:New "UICorner" {
									CornerRadius = UDim.new(1, 0),
								},	

								Fusion:New "Frame" {
									Active = false,
									AnchorPoint = Vector2.new(0.5, 0.5),
									Position = UDim2.fromScale(1, 0.5),
									Size = UDim2.fromOffset(18, 18),
									ZIndex = 3,

									[Fusion.Children] = {
										Fusion:New "UICorner" {
											CornerRadius = UDim.new(1, 0),
										}
									}
								},
							
								Fusion:New "UIGradient" {
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
					}
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
								ColorSequenceKeypoint.new(0.5, shared["donationboard@settings"].Colors[2]),
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

			["radio"] = function()
				return Fusion:New "TextButton" {
					AutoButtonColor = true,
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundTransparency = 0.8,
					Size = UDim2.new(0, 0, 0, 40),
					Text = "",

					[Fusion.Children] = {
						Fusion:New "UIListLayout" {
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							VerticalAlignment = Enum.VerticalAlignment.Center,
						},

						Fusion:New "TextLabel" {
							AutomaticSize = Enum.AutomaticSize.X,
							BackgroundTransparency = 1,
							Size = UDim2.fromScale(0, 1),
							Text = "N/A",
							FontFace = Font.new(Fonts[shared["donationboard@settings"].Font], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
							TextColor3 = shared["donationboard@settings"].TextColor,
							TextSize = 20,
							TextXAlignment = Enum.TextXAlignment.Center,
							TextYAlignment = Enum.TextYAlignment.Center,
							[Fusion.Tag "A"] = "donationboard@textcolor",
						},

						Fusion:New "UICorner" {
							CornerRadius = UDim.new(0, 5),
						},

						Fusion:New "UIGradient" {
							Color = ColorSequence.new({
								ColorSequenceKeypoint.new(0, shared["donationboard@settings"].Colors[1]),
								ColorSequenceKeypoint.new(0.5, shared["donationboard@settings"].Colors[2]),
								ColorSequenceKeypoint.new(1, shared["donationboard@settings"].Colors[3]),
							}),
							[Fusion.Tag "A"] = "donationboard@colors123",
							[Fusion.Tag "B"] = "donationboard@rotation",
							Rotation = 90,
						},

						Fusion:New "UIStroke" {
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							Color = Color3.new(1, 1, 1),
							Thickness = 1.5,

							[Fusion.Children] = {
								Fusion:New "UIGradient" {
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
					},
				}
			end,
		
			["textbox"] = function()
				return Fusion:New "Frame" {
					BackgroundTransparency = 0.8,
					Size = UDim2.new(1, 0, 0, 40),

					[Fusion.Children] = {
						Fusion:New "TextBox" {
							BackgroundTransparency = 1,
							Size = UDim2.fromScale(1, 1),
							PlaceholderText = "Type Something",
							Text = "N/A",
							FontFace = Font.new(Fonts[shared["donationboard@settings"].Font], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
							TextColor3 = shared["donationboard@settings"].TextColor,
							TextSize = 20,
							TextTransparency = 0.5,
							TextTruncate = Enum.TextTruncate.SplitWord,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Center,
							[Fusion.Tag "A"] = "donationboard@textcolor",
						},

						Fusion:New "UICorner" {
							CornerRadius = UDim.new(0, 5),
						},

						Fusion:New "UIGradient" {
							Color = ColorSequence.new({
								ColorSequenceKeypoint.new(0, shared["donationboard@settings"].Colors[1]),
								ColorSequenceKeypoint.new(0.5, shared["donationboard@settings"].Colors[2]),
								ColorSequenceKeypoint.new(1, shared["donationboard@settings"].Colors[3]),
							}),
							[Fusion.Tag "A"] = "donationboard@colors123",
							[Fusion.Tag "B"] = "donationboard@rotation",
							Rotation = 90,
						},

						Fusion:New "UIStroke" {
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							Color = Color3.new(1, 1, 1),
							Thickness = 1.5,

							[Fusion.Children] = {
								Fusion:New "UIGradient" {
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
					
						Fusion:New "UIPadding" {
							PaddingLeft = UDim.new(0, 20),
							PaddingRight = UDim.new(0, 20),
						},	
					}
				}
			end,

			["redirect"] = function()
				return Fusion:New "TextButton" {
					AutoButtonColor = true,
					BackgroundTransparency = 0.8,
					Size = UDim2.new(1, 0, 0, 40),
					Text = "",

					[Fusion.Children] = {
						Fusion:New "TextLabel" {
							BackgroundTransparency = 1,
							AutomaticSize = Enum.AutomaticSize.X,
							Size = UDim2.fromScale(0, 1),
							Text = "N/A",
							FontFace = Font.new(Fonts[shared["donationboard@settings"].Font], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
							TextColor3 = shared["donationboard@settings"].TextColor,
							TextSize = 20,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Center,
							[Fusion.Tag "A"] = "donationboard@textcolor",
						},
					
						Fusion:New "UICorner" {
							CornerRadius = UDim.new(0, 5),
						},

						Fusion:New "UIFlexItem" {
							FlexMode = Enum.UIFlexMode.Fill,
						},

						Fusion:New "UIGradient" {
							Color = ColorSequence.new({
								ColorSequenceKeypoint.new(0, shared["donationboard@settings"].Colors[1]),
								ColorSequenceKeypoint.new(0.5, shared["donationboard@settings"].Colors[2]),
								ColorSequenceKeypoint.new(1, shared["donationboard@settings"].Colors[3]),
							}),
							[Fusion.Tag "A"] = "donationboard@colors123",
							[Fusion.Tag "B"] = "donationboard@rotation",
							Rotation = 90,
						},

						Fusion:New "UIStroke" {
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							Color = Color3.new(1, 1, 1),
							Thickness = 1.5,

							[Fusion.Children] = {
								Fusion:New "UIGradient" {
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
					
						Fusion:New "UIPadding" {
							PaddingLeft = UDim.new(0, 20),
							PaddingRight = UDim.new(0, 10),
						},	

						Fusion:New "ImageLabel" {
							AnchorPoint = Vector2.new(1, 0.5),
							BackgroundTransparency = 1,
							Position = UDim2.fromScale(1, 0.5),
							Size = UDim2.fromOffset(20, 20),
							Image = "rbxassetid://119076944242835",
							ImageColor3 = shared["donationboard@settings"].IconColor,
							ImageRectOffset = Vector2.new(259, 37),
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
				if (type:lower() == "slider") then
					properties = typeof(properties) == "table" and properties or {}
					local _temp, valueEvent = self.Templates.default(), Instance.new("BindableEvent")
					_temp.Parent = properties.Parent or nil
					self.Templates.slider().Parent = _temp.Left.Content
					local IsDragging = false

					Fusion:New "TextLabel" {
						Name = "Display",
						Parent = _temp.Right,
						AutomaticSize = Enum.AutomaticSize.XY,
						BackgroundTransparency = 1,
						Size = UDim2.new(),
						LayoutOrder = 2,
						FontFace = Font.new(Fonts[shared["donationboard@settings"].Font], Enum.FontWeight.Regular, Enum.FontStyle.Normal),
						RichText = true,
						TextColor3 = shared["donationboard@settings"].TextColor,
						TextTransparency = 0.25,
						TextSize = 20,
						Text = "N/A",
						TextXAlignment = Enum.TextXAlignment.Left,
						[Fusion.Tag "A"] = "donationboard@textcolor",
						[Fusion.Children] = {
							Fusion:New "UIGradient" {
								Offset = Vector2.new(1, 1),
								Rotation = 90,
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, shared["donationboard@settings"].Colors[1]),
									ColorSequenceKeypoint.new(0.5, shared["donationboard@settings"].Colors[2]),
									ColorSequenceKeypoint.new(1, shared["donationboard@settings"].Colors[3]),
								}),
								[Fusion.Tag "A"] = "donationboard@colors123",
								[Fusion.Tag "B"] = "donationboard@rotation",
							},
						}
					}
					
					local self = Class.new {
						Body = _temp,
						Title = properties.Title or "N/A",
						Description = properties.Description or "N/A",
						Content = _temp.Left.Content,
						
						Slider = _temp.Left.Content.TextButton,
						Min = properties.Min or 0,
						Max = properties.Max or 1,
						Value = properties.Value or 0.5,
						Floored = properties.Floored or false,

						ValueChanged = valueEvent.Event,
					}

					local Events do
						self.Changed:Connect(function(property, value)
							if (property == "Min") then
								self.Value = self.Min > self.Value and self.Min or (self.Floored and math.floor(self.Value) or self.Value)
								return
							end

							if (property == "Max") then
								self.Value = self.Max < self.Value and self.Max or (self.Floored and math.floor(self.Value) or self.Value)
								return
							end

							if (property == "Value") then
								if (self.Value < self.Min or self.Value > self.Max) then self.Value = math.clamp((self.Floored and math.floor(self.Value) or self.Value), self.Min, self.Max) return end
								self.Slider.Fill.Size = UDim2.fromScale((self.Value-self.Min)/(self.Max-self.Min), 1)
								self.Body.Right.Display.Text = (self.Floored and math.floor(self.Value) or (math.floor(self.Value*100)/100))
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
					
						local function GetSliderValueFromMouse()
							local surfaceGui = self.Body:FindFirstAncestorWhichIsA("SurfaceGui")
							local adornee = surfaceGui.Adornee
							local unitRay = workspace.CurrentCamera:ScreenPointToRay(
								game:GetService("UserInputService"):GetMouseLocation().X,
								game:GetService("UserInputService"):GetMouseLocation().Y
							)

							local raycastParams = RaycastParams.new()
							raycastParams.FilterDescendantsInstances = {game:GetService("Players").LocalPlayer.Character}
							raycastParams.FilterType = Enum.RaycastFilterType.Exclude

							local raycastResult = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, raycastParams)
							if not raycastResult then return end

							if raycastResult.Instance == adornee then
								local localHit = adornee.CFrame:PointToObjectSpace(raycastResult.Position)

								local relativeX = (localHit.X + (adornee.Size.X / 2)) / adornee.Size.X

								local sliderFrame = self.Slider
								local absPos = sliderFrame.AbsolutePosition
								local absSize = sliderFrame.AbsoluteSize
								local parentSize = surfaceGui.AbsoluteSize

								local frameMin = absPos.X / parentSize.X
								local frameMax = (absPos.X + absSize.X) / parentSize.X

								local t = (relativeX - frameMin) / (frameMax - frameMin)
								local value = ((1 - math.clamp(t, 0, 1)) * (self.Max - self.Min)) + self.Min
								return self.Floored and math.floor(value) or value
							end
						end


						self.Slider.MouseButton1Down:Connect(function()
							IsDragging = true
							local value = GetSliderValueFromMouse()
							if value then
								self.Value = (self.Floored and math.floor(value) or value)
							end
						end)


						game:GetService("UserInputService").InputEnded:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 then
								IsDragging = false
							end
						end)

						game:GetService("RunService").RenderStepped:Connect(function()
							if IsDragging then
								local value = GetSliderValueFromMouse()
								if value then
									self.Value = (self.Floored and math.floor(value) or value)
								end
							end
						end)

					end

					for index, value in self:GetValues() do
						self._changed:Fire(index, value)
					end

					return self
				end

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

				if (type:lower() == "radio") then
					properties = typeof(properties) == "table" and properties or {}
					local _temp, valueEvent = self.Templates.default(), Instance.new("BindableEvent")
					_temp.Parent = properties.Parent or nil
					for index, option in properties.Options do
						local _button = self.Templates.radio()
						_button.Parent = _temp.Left.Content
						_button.Name = option
						_button.TextLabel.Text = option
						_button.LayoutOrder = index
					end

					local self = Class.new {
						Body = _temp,
						Title = properties.Title or "N/A",
						Description = properties.Description or "N/A",
						Content = _temp.Left.Content,

						Options = {},
						Value = properties.Value or "",

						ValueChanged = valueEvent.Event,
					}

					for _, button in self.Content:GetChildren() do
						if (button:IsA("TextButton")) then 
							self.Options[button.LayoutOrder] = button 
							button.MouseButton1Click:Connect(function()
								self.Value = button.Name
							end)
						end
					end

					local Events do
						self.Changed:Connect(function(property, value)
							if (property == "Value") then
								for _, button in self.Options do
									local selected = button.Name == value
									button.BackgroundTransparency = selected and 0 or 0.8
								end

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

				if (type:lower() == "textbox") then
					properties = typeof(properties) == "table" and properties or {}
					local _temp, valueEvent = self.Templates.default(), Instance.new("BindableEvent")
					_temp.Parent = properties.Parent or nil
					self.Templates.textbox().Parent = _temp.Left.Content

					local self = Class.new {
						Body = _temp,
						Title = properties.Title or "N/A",
						Description = properties.Description or "N/A",
						Content = _temp.Left.Content,

						TextBox = _temp.Left.Content.Frame.TextBox,
						Value = properties.Value or "",
						Placeholder = properties.Placeholder or "",

						ValueChanged = valueEvent.Event,
					}

					local Events do
						self.TextBox.Changed:Connect(function(property)
							if (property ~= "Text") then return end
							self.Value = self.TextBox.Text
						end)

						self.Changed:Connect(function(property, value)
							if (property == "Placeholder") then
								self.TextBox.PlaceholderText = value
								return
							end

							if (property == "Value") then
								self.TextBox.TextTransparency = #tostring(self.Value) > 0 and 0 or 0.5
								if (not self.TextBox:IsFocused()) then
									self.TextBox.Text = self.Value
								end
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

				if (type:lower() == "redirect") then
					properties = typeof(properties) == "table" and properties or {}
					local _temp, event, buttons = self.Templates.default(), Instance.new("BindableEvent"), {}
					_temp.Parent = properties.Parent or nil

					for _, option in properties.Options do
						local icon; if (typeof(option) == "table") then
							icon = option[2]
							option = option[1]
						end

						local _button = self.Templates.redirect()
						_button.Parent = _temp.Left.Content
						_button.Name = option
						_button.TextLabel.Text = option
						_button.ImageLabel.ImageRectOffset = icon or Vector2.new(-37, 0)
						_button.MouseButton1Click:Connect(function()
							event:Fire(option)
						end)
						buttons[option] = _button
					end

					local self = Class.new {
						Body = _temp,
						Title = properties.Title or "N/A",
						Description = properties.Description or "N/A",
						Content = _temp.Left.Content,

						Buttons = buttons,
						Triggered = event.Event
					}

					for key, button in buttons do rawset(self, key, button) end
					self.Content.UIListLayout.HorizontalFlex = Enum.UIFlexAlignment.None

					local Events do
						self.Changed:Connect(function(property, value)
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


return Settings