--!nocheck
--!nolint
local List, Class, Fusion, Rates, Util, Fonts = {}, 
	require("../Libraries/Class"), 
	require("../Dependencies/Fusion"),
	require("../Templates/Rates"),
	require("../Libraries/Util"),
	require("../Templates/Fonts")
	List.__index = List
	Fusion = Fusion.scoped(Fusion)
	
	
function List.new(parent: Instance)
	local self = Class.new {
		Enabled = true,
		Keyword = "",
		DonorCount = 50,
		Taxed = false,
		SortOrder = "Numeric",
		SortDirection = "Ascending",
		Conversion = false,

		Currency = "USD",
		CurrencyRate = Rates,

		Body = Fusion:New "Frame" {
			Parent = parent,
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, 100),
			Size = UDim2.new(1, 0, 0, 544),
			LayoutOrder = 2,
			
			[Fusion.Children] = {
				Fusion:New "UIPadding" {
					PaddingLeft = UDim.new(0, 15),
					PaddingRight = UDim.new(0, 7),
					PaddingTop = UDim.new(0, 7),
				},
			
				Fusion:New "UIFlexItem" {
					FlexMode = Enum.UIFlexMode.Fill,
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
							Padding = UDim.new(0, 2),
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
			[1] = function()
				return Fusion:New "CanvasGroup" {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 70),

					[Fusion.Children] = {
						Fusion:New "UICorner" {
							CornerRadius = UDim.new(0, 4),
						},
						
						Fusion:New "Frame" {
							AnchorPoint = Vector2.new(0, 1),
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 0.3,
							Position = UDim2.fromOffset(0, 65),
							Size = UDim2.new(1, 0, 0, 2),

							[Fusion.Children] = {
								Fusion:New "UIGradient" {
									Color = ColorSequence.new({
										ColorSequenceKeypoint.new(0, shared["donationboard@settings"].Colors[1]),
										ColorSequenceKeypoint.new(0.5,shared["donationboard@settings"].Colors[2]),
										ColorSequenceKeypoint.new(1,shared["donationboard@settings"].Colors[3]),
									}),
									[Fusion.Tag "A"] = "donationboard@colors123",
									[Fusion.Tag "B"] = "donationboard@rotation",
								}
							},
						},

						Fusion:New "Frame" {
							Name = "Thumbnail",
							AutomaticSize = Enum.AutomaticSize.X,
							BackgroundTransparency = 1,
							LayoutOrder = 1,
							Size = UDim2.fromOffset(74, 65),

							[Fusion.Children] = {
								Fusion:New "UIListLayout" {
									FillDirection = Enum.FillDirection.Horizontal,
									SortOrder = Enum.SortOrder.LayoutOrder,
									HorizontalAlignment = Enum.HorizontalAlignment.Left,
									HorizontalFlex = Enum.UIFlexAlignment.None,
									ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
									VerticalAlignment = Enum.VerticalAlignment.Center,
									VerticalFlex = Enum.UIFlexAlignment.None,
								},

								Fusion:New "UIPadding" {
									PaddingLeft = UDim.new(0, 15),
									PaddingRight = UDim.new(0, 15),
								},

								Fusion:New "ImageLabel" {
									BackgroundTransparency = 1,
									Size = UDim2.fromOffset(44, 44),
									LayoutOrder = 1,
									Image = "rbxthumb://type=AvatarHeadShot&id=1&w=420&h=420",
								},

								
							}
						},

						Fusion:New "Frame" {
							Name = "Player",
							BackgroundTransparency = 1,
							LayoutOrder = 2,
							Position = UDim2.fromOffset(75, 0),
							Size = UDim2.fromOffset(330, 65),

							[Fusion.Children] = {
								Fusion:New "UIFlexItem" {
									FlexMode = Enum.UIFlexMode.Fill,
								},

								Fusion:New "UIListLayout" {
									FillDirection = Enum.FillDirection.Vertical,
									SortOrder = Enum.SortOrder.LayoutOrder,
									HorizontalAlignment = Enum.HorizontalAlignment.Left,
									HorizontalFlex = Enum.UIFlexAlignment.None,
									ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
									VerticalAlignment = Enum.VerticalAlignment.Center,
									VerticalFlex = Enum.UIFlexAlignment.None,
								},

								Fusion:New "UIPadding" {
									PaddingLeft = UDim.new(0, 15),
									PaddingRight = UDim.new(0, 15),
								},	

								Fusion:New "TextLabel" {
									Name = "Username",
									AutomaticSize = Enum.AutomaticSize.Y,
									BackgroundTransparency = 1,
									Size = UDim2.fromScale(1, 0),
									LayoutOrder = 1,
									FontFace = Font.new(Fonts[shared["donationboard@settings"].Font], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
									Text = "Player",
									TextSize = 24,
									TextColor3 = shared["donationboard@settings"].TextColor,
									TextXAlignment = Enum.TextXAlignment.Left,
									TextWrapped = false,
									TextTruncate = Enum.TextTruncate.SplitWord,
									[Fusion.Tag "A"] = "donationboard@textcolor",
								},
							
								Fusion:New "TextLabel" {
									Name = "Robux",
									AutomaticSize = Enum.AutomaticSize.XY,
									BackgroundTransparency = 1,
									LayoutOrder = 2,
									Size = UDim2.new(),
									FontFace = Font.new(Fonts[shared["donationboard@settings"].Font], Enum.FontWeight.Regular, Enum.FontStyle.Normal),
									Text = "N/A",
									RichText = true,
									TextSize = 20,
									TextColor3 = shared["donationboard@settings"].TextColor,
									TextTransparency = 0.25,
									TextXAlignment = Enum.TextXAlignment.Left,
									[Fusion.Tag "A"] = "donationboard@textcolor",
								}
							}
						},

						Fusion:New "Frame" {
							Name = "Rank",
							BackgroundTransparency = 1,
							LayoutOrder = 3,
							AnchorPoint = Vector2.new(1, 0),
							Position = UDim2.fromScale(1, 0),
							Size = UDim2.fromOffset(100, 65),

							[Fusion.Children] = {
								Fusion:New "UIListLayout" {
									FillDirection = Enum.FillDirection.Horizontal,
									SortOrder = Enum.SortOrder.LayoutOrder,
									HorizontalAlignment = Enum.HorizontalAlignment.Right,
									HorizontalFlex = Enum.UIFlexAlignment.None,
									ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
									VerticalAlignment = Enum.VerticalAlignment.Center,
									VerticalFlex = Enum.UIFlexAlignment.None,
								},

								Fusion:New "UIPadding" {
									PaddingRight = UDim.new(0, 15),
								},

								Fusion:New "TextLabel" {
									AnchorPoint = Vector2.new(1, 0.5),
									AutomaticSize = Enum.AutomaticSize.XY,
									BackgroundTransparency = 1,
									Size = UDim2.new(),
									FontFace = Font.new(Fonts[shared["donationboard@settings"].Font], Enum.FontWeight.Medium, Enum.FontStyle.Normal),
									Text = "#%d",
									TextSize = 43,
									TextColor3 = Color3.new(1, 1, 1),
									TextTransparency = 0.3,
									TextXAlignment = Enum.TextXAlignment.Left,
								}
							}
						},
					}
				}
			end,

			[2] = function()
				return Fusion:New "CanvasGroup" {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 70),

					[Fusion.Children] = {
						Fusion:New "UICorner" {
							CornerRadius = UDim.new(0, 4),
						},
						
						Fusion:New "Frame" {
							AnchorPoint = Vector2.new(0, 1),
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 0.3,
							Position = UDim2.fromOffset(0, 65),
							Size = UDim2.new(1, 0, 0, 2),

							[Fusion.Children] = {
								Fusion:New "UIGradient" {
									Color = ColorSequence.new({
										ColorSequenceKeypoint.new(0, shared["donationboard@settings"].Colors[1]),
										ColorSequenceKeypoint.new(0.5,shared["donationboard@settings"].Colors[2]),
										ColorSequenceKeypoint.new(1,shared["donationboard@settings"].Colors[3]),
									}),
									[Fusion.Tag "A"] = "donationboard@colors123",
									[Fusion.Tag "B"] = "donationboard@rotation",
								}
							},
						},

						Fusion:New "Frame" {
							Name = "Rank",
							BackgroundTransparency = 1,
							LayoutOrder = 3,
							Position = UDim2.new(),
							Size = UDim2.fromOffset(74, 65),

							[Fusion.Children] = {
								Fusion:New "UIListLayout" {
									FillDirection = Enum.FillDirection.Horizontal,
									SortOrder = Enum.SortOrder.LayoutOrder,
									HorizontalAlignment = Enum.HorizontalAlignment.Center,
									HorizontalFlex = Enum.UIFlexAlignment.None,
									ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
									VerticalAlignment = Enum.VerticalAlignment.Center,
									VerticalFlex = Enum.UIFlexAlignment.None,
								},

								Fusion:New "TextLabel" {
									AnchorPoint = Vector2.new(0, 0.5),
									AutomaticSize = Enum.AutomaticSize.Y,
									BackgroundTransparency = 1,
									Position = UDim2.fromScale(0, 0.5),
									Size = UDim2.fromScale(1, 0),
									FontFace = Font.new(Fonts[shared["donationboard@settings"].Font], Enum.FontWeight.Medium, Enum.FontStyle.Normal),
									Text = "#%d",
									TextSize = 35,
									TextScaled = true,
									TextColor3 = Color3.new(1, 1, 1),
									TextXAlignment = Enum.TextXAlignment.Center,
								}
							}
						},

						Fusion:New "Frame" {
							Name = "Thumbnail",
							AutomaticSize = Enum.AutomaticSize.X,
							BackgroundTransparency = 1,
							LayoutOrder = 1,
							Position = UDim2.fromOffset(75, 0),
							Size = UDim2.fromOffset(74, 65),

							[Fusion.Children] = {
								Fusion:New "UIListLayout" {
									FillDirection = Enum.FillDirection.Horizontal,
									SortOrder = Enum.SortOrder.LayoutOrder,
									HorizontalAlignment = Enum.HorizontalAlignment.Left,
									HorizontalFlex = Enum.UIFlexAlignment.None,
									ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
									VerticalAlignment = Enum.VerticalAlignment.Center,
									VerticalFlex = Enum.UIFlexAlignment.None,
								},

								Fusion:New "UIPadding" {
									PaddingLeft = UDim.new(0, 15),
									PaddingRight = UDim.new(0, 15),
								},

								Fusion:New "ImageLabel" {
									BackgroundTransparency = 1,
									Size = UDim2.fromOffset(44, 44),
									LayoutOrder = 1,
									Image = "rbxthumb://type=AvatarHeadShot&id=1&w=420&h=420",
								},

								
							}
						},

						Fusion:New "Frame" {
							Name = "Player",
							BackgroundTransparency = 1,
							LayoutOrder = 2,
							Position = UDim2.fromOffset(150, 0),
							Size = UDim2.fromOffset(356, 65),

							[Fusion.Children] = {
								Fusion:New "UIFlexItem" {
									FlexMode = Enum.UIFlexMode.Fill,
								},

								Fusion:New "UIListLayout" {
									FillDirection = Enum.FillDirection.Vertical,
									SortOrder = Enum.SortOrder.LayoutOrder,
									HorizontalAlignment = Enum.HorizontalAlignment.Left,
									HorizontalFlex = Enum.UIFlexAlignment.None,
									ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
									VerticalAlignment = Enum.VerticalAlignment.Center,
									VerticalFlex = Enum.UIFlexAlignment.None,
								},

								Fusion:New "UIPadding" {
									PaddingLeft = UDim.new(0, 15),
									PaddingRight = UDim.new(0, 15),
								},	

								Fusion:New "TextLabel" {
									Name = "Username",
									AutomaticSize = Enum.AutomaticSize.Y,
									BackgroundTransparency = 1,
									Size = UDim2.fromScale(1, 0),
									LayoutOrder = 1,
									FontFace = Font.new(Fonts[shared["donationboard@settings"].Font], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
									Text = "Player",
									TextSize = 24,
									TextColor3 = shared["donationboard@settings"].TextColor,
									TextXAlignment = Enum.TextXAlignment.Left,
									TextWrapped = false,
									TextTruncate = Enum.TextTruncate.SplitWord,
									[Fusion.Tag "A"] = "donationboard@textcolor",
								},
							
								Fusion:New "TextLabel" {
									Name = "Robux",
									AutomaticSize = Enum.AutomaticSize.XY,
									BackgroundTransparency = 1,
									LayoutOrder = 2,
									Size = UDim2.new(),
									FontFace = Font.new(Fonts[shared["donationboard@settings"].Font], Enum.FontWeight.Regular, Enum.FontStyle.Normal),
									Text = "N/A",
									RichText = true,
									TextSize = 20,
									TextColor3 = shared["donationboard@settings"].TextColor,
									TextTransparency = 0.25,
									TextXAlignment = Enum.TextXAlignment.Left,
									[Fusion.Tag "A"] = "donationboard@textcolor",
								}
							}
						},
					}
				}
			end,
		
			[3] = function()
				return Fusion:New "CanvasGroup" {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 70),

					[Fusion.Children] = {
						Fusion:New "UICorner" {
							CornerRadius = UDim.new(0, 4),
						},

						Fusion:New "Frame" {
							AnchorPoint = Vector2.new(0, 1),
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 0.5,
							Position = UDim2.fromOffset(0, 65),
							Size = UDim2.new(1, 0, 0, 2),

							[Fusion.Children] = {
								Fusion:New "UIGradient" {
									Color = ColorSequence.new({
										ColorSequenceKeypoint.new(0, shared["donationboard@settings"].Colors[1]),
										ColorSequenceKeypoint.new(0.5,shared["donationboard@settings"].Colors[2]),
										ColorSequenceKeypoint.new(1,shared["donationboard@settings"].Colors[3]),
									}),
									[Fusion.Tag "A"] = "donationboard@colors123",
									[Fusion.Tag "B"] = "donationboard@rotation",
								}
							},
						},

						Fusion:New "Frame" {
							Name = "Rank",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 0.85,
							Size = UDim2.fromOffset(74, 65),
							Visible = false,

							[Fusion.Children] = {
								Fusion:New "UIListLayout" {
									FillDirection = Enum.FillDirection.Horizontal,
									SortOrder = Enum.SortOrder.LayoutOrder,
									HorizontalAlignment = Enum.HorizontalAlignment.Center,
									HorizontalFlex = Enum.UIFlexAlignment.None,
									ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
									VerticalAlignment = Enum.VerticalAlignment.Center,
									VerticalFlex = Enum.UIFlexAlignment.None,
								},

								Fusion:New "TextLabel" {
									AnchorPoint = Vector2.new(0.5, 0.5),
									AutomaticSize = Enum.AutomaticSize.XY,
									BackgroundTransparency = 1,
									Position = UDim2.fromScale(0, 1),
									Size = UDim2.fromOffset(0, 0),
									FontFace = Font.new(Fonts[shared["donationboard@settings"].Font], Enum.FontWeight.Medium, Enum.FontStyle.Normal),
									Text = "#%d",
									TextSize = 20,
									TextScaled = true,
									TextColor3 = Color3.new(1, 1, 1),
									TextXAlignment = Enum.TextXAlignment.Center,
								}
							}
						},

						Fusion:New "Frame" {
							Name = "Thumbnail",
							AutomaticSize = Enum.AutomaticSize.X,
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 0.85,
							LayoutOrder = 2,
							Position = UDim2.fromOffset(0, 0),
							Size = UDim2.fromOffset(74, 65),
							[Fusion.Children] = {
								Fusion:New "UIListLayout" {
									FillDirection = Enum.FillDirection.Horizontal,
									SortOrder = Enum.SortOrder.LayoutOrder,
									HorizontalAlignment = Enum.HorizontalAlignment.Left,
									HorizontalFlex = Enum.UIFlexAlignment.None,
									ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
									VerticalAlignment = Enum.VerticalAlignment.Center,
									VerticalFlex = Enum.UIFlexAlignment.None,
								},

								Fusion:New "UIPadding" {
									PaddingLeft = UDim.new(0, 15),
									PaddingRight = UDim.new(0, 15),
								},

								Fusion:New "ImageLabel" {
									BackgroundTransparency = 1,
									Size = UDim2.fromOffset(44, 44),
									LayoutOrder = 1,
									Image = "rbxthumb://type=AvatarHeadShot&id=1&w=420&h=420",
								},

								
							}
						},

						Fusion:New "Frame" {
							Name = "Player",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 0.85,
							LayoutOrder = 3,
							Position = UDim2.fromOffset(75, 0),
							Size = UDim2.fromOffset(432, 65),

							[Fusion.Children] = {
								Fusion:New "UIListLayout" {
									Padding = UDim.new(0, 12),
									FillDirection = Enum.FillDirection.Horizontal,
									SortOrder = Enum.SortOrder.LayoutOrder,
									HorizontalAlignment = Enum.HorizontalAlignment.Left,
									HorizontalFlex = Enum.UIFlexAlignment.None,
									ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
									VerticalAlignment = Enum.VerticalAlignment.Center,
									VerticalFlex = Enum.UIFlexAlignment.None,
								},

								Fusion:New "UIPadding" {
									PaddingLeft = UDim.new(0, 15),
									PaddingRight = UDim.new(0, 15),
								},	

								Fusion:New "TextLabel" {
									Name = "Username",
									AutomaticSize = Enum.AutomaticSize.Y,
									BackgroundTransparency = 1,
									Size = UDim2.fromScale(0, 0),
									LayoutOrder = 1,
									FontFace = Font.new(Fonts[shared["donationboard@settings"].Font], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
									Text = "Player",
									TextSize = 20,
									TextColor3 = shared["donationboard@settings"].TextColor,
									TextXAlignment = Enum.TextXAlignment.Left,
									TextWrapped = false,
									TextTruncate = Enum.TextTruncate.SplitWord,
									[Fusion.Tag "A"] = "donationboard@textcolor",

									[Fusion.Children] = {
										Fusion:New "UIFlexItem" {
											FlexMode = Enum.UIFlexMode.Fill,
										},
									},
								},
							
								Fusion:New "TextLabel" {
									Name = "Robux",
									AutomaticSize = Enum.AutomaticSize.XY,
									BackgroundTransparency = 1,
									LayoutOrder = 2,
									Size = UDim2.fromOffset(0, 0),
									FontFace = Font.new(Fonts[shared["donationboard@settings"].Font], Enum.FontWeight.Regular, Enum.FontStyle.Normal),
									Text = "N/A",
									RichText = true,
									TextSize = 20,
									TextColor3 = shared["donationboard@settings"].TextColor,
									TextTransparency = 0.25,
									TextXAlignment = Enum.TextXAlignment.Right,
									[Fusion.Tag "A"] = "donationboard@textcolor",
								}
							}
						},
					}
				}
			end,
		
			[4] = function()
				return Fusion:New "CanvasGroup" {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 55),

					[Fusion.Children] = {
						Fusion:New "UICorner" {
							CornerRadius = UDim.new(0, 4),
						},

						Fusion:New "Frame" {
							AnchorPoint = Vector2.new(0, 0),
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 0.5,
							Position = UDim2.fromOffset(0, 50),
							Size = UDim2.new(1, 0, 0, 2),
							ZIndex = 2,

							[Fusion.Children] = {
								Fusion:New "UIGradient" {
									Color = ColorSequence.new({
										ColorSequenceKeypoint.new(0, shared["donationboard@settings"].Colors[1]),
										ColorSequenceKeypoint.new(0.5,shared["donationboard@settings"].Colors[2]),
										ColorSequenceKeypoint.new(1,shared["donationboard@settings"].Colors[3]),
									}),
									[Fusion.Tag "A"] = "donationboard@colors123",
									[Fusion.Tag "B"] = "donationboard@rotation",
								}
							},
						},

						Fusion:New "Frame" {
							Name = "Rank",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 0.85,
							Size = UDim2.fromOffset(50, 50),
							[Fusion.Children] = {
								Fusion:New "UIListLayout" {
									FillDirection = Enum.FillDirection.Horizontal,
									SortOrder = Enum.SortOrder.LayoutOrder,
									HorizontalAlignment = Enum.HorizontalAlignment.Center,
									HorizontalFlex = Enum.UIFlexAlignment.None,
									ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
									VerticalAlignment = Enum.VerticalAlignment.Center,
									VerticalFlex = Enum.UIFlexAlignment.None,
								},

								Fusion:New "TextLabel" {
									AnchorPoint = Vector2.new(0, 0.5),
									AutomaticSize = Enum.AutomaticSize.Y,
									BackgroundTransparency = 1,
									Position = UDim2.fromScale(0, 0.5),
									Size = UDim2.fromScale(1, 0.5),
									FontFace = Font.new(Fonts[shared["donationboard@settings"].Font], Enum.FontWeight.Medium, Enum.FontStyle.Normal),
									Text = "#%d",
									TextSize = 30,
									TextScaled = true,
									TextColor3 = Color3.new(1, 1, 1),
									TextXAlignment = Enum.TextXAlignment.Center,
								}
							}
						},

						Fusion:New "Frame" {
							Name = "Thumbnail",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 0.85,
							LayoutOrder = 2,
							Position = UDim2.fromOffset(51, 0),
							Size = UDim2.fromOffset(70, 50),
							[Fusion.Children] = {
								Fusion:New "UIListLayout" {
									FillDirection = Enum.FillDirection.Horizontal,
									SortOrder = Enum.SortOrder.LayoutOrder,
									HorizontalAlignment = Enum.HorizontalAlignment.Center,
									HorizontalFlex = Enum.UIFlexAlignment.None,
									ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
									VerticalAlignment = Enum.VerticalAlignment.Center,
									VerticalFlex = Enum.UIFlexAlignment.None,
								},

								Fusion:New "UIPadding" {
									PaddingLeft = UDim.new(0, 7),
									PaddingRight = UDim.new(0, 7),
								},

								Fusion:New "ImageLabel" {
									BackgroundTransparency = 1,
									Size = UDim2.fromOffset(40, 40),
									LayoutOrder = 1,
									Image = "rbxthumb://type=AvatarHeadShot&id=1&w=420&h=420",
								},

								
							}
						},

						Fusion:New "Frame" {
							Name = "Player",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 0.85,
							LayoutOrder = 3,
							AnchorPoint = Vector2.new(1, 0),
							Position = UDim2.fromScale(1, 0),
							Size = UDim2.fromOffset(385, 50),

							[Fusion.Children] = {
								Fusion:New "UIListLayout" {
									Padding = UDim.new(0, 12),
									FillDirection = Enum.FillDirection.Horizontal,
									SortOrder = Enum.SortOrder.LayoutOrder,
									HorizontalAlignment = Enum.HorizontalAlignment.Left,
									HorizontalFlex = Enum.UIFlexAlignment.None,
									ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
									VerticalAlignment = Enum.VerticalAlignment.Center,
									VerticalFlex = Enum.UIFlexAlignment.None,
								},

								Fusion:New "UIPadding" {
									PaddingLeft = UDim.new(0, 15),
									PaddingRight = UDim.new(0, 15),
								},	

								Fusion:New "TextLabel" {
									Name = "Username",
									AutomaticSize = Enum.AutomaticSize.Y,
									BackgroundTransparency = 1,
									Size = UDim2.fromScale(0, 0),
									LayoutOrder = 1,
									FontFace = Font.new(Fonts[shared["donationboard@settings"].Font], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
									Text = "Player",
									TextSize = 20,
									TextColor3 = shared["donationboard@settings"].TextColor,
									TextXAlignment = Enum.TextXAlignment.Left,
									TextWrapped = false,
									TextTruncate = Enum.TextTruncate.SplitWord,
									[Fusion.Tag "A"] = "donationboard@textcolor",

									[Fusion.Children] = {
										Fusion:New "UIFlexItem" {
											FlexMode = Enum.UIFlexMode.Fill,
										},
									},
								},
							
								Fusion:New "TextLabel" {
									Name = "Robux",
									AutomaticSize = Enum.AutomaticSize.XY,
									BackgroundTransparency = 1,
									LayoutOrder = 2,
									Size = UDim2.fromOffset(0, 0),
									FontFace = Font.new(Fonts[shared["donationboard@settings"].Font], Enum.FontWeight.Regular, Enum.FontStyle.Normal),
									Text = "N/A",
									RichText = true,
									TextSize = 20,
									TextColor3 = shared["donationboard@settings"].TextColor,
									TextTransparency = 0.25,
									TextXAlignment = Enum.TextXAlignment.Right,
									[Fusion.Tag "A"] = "donationboard@textcolor",
								}
							}
						},
					}
				}
			end,
		
			[5] = function()
				return Fusion:New "CanvasGroup" {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 70),

					[Fusion.Children] = {
						Fusion:New "UICorner" {
							CornerRadius = UDim.new(0, 4),
						},

						Fusion:New "Frame" {
							AnchorPoint = Vector2.new(0, 1),
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 0.5,
							Position = UDim2.fromOffset(0, 65),
							Size = UDim2.new(1, 0, 0, 2),

							[Fusion.Children] = {
								Fusion:New "UIGradient" {
									Color = ColorSequence.new({
										ColorSequenceKeypoint.new(0, shared["donationboard@settings"].Colors[1]),
										ColorSequenceKeypoint.new(0.5,shared["donationboard@settings"].Colors[2]),
										ColorSequenceKeypoint.new(1,shared["donationboard@settings"].Colors[3]),
									}),
									[Fusion.Tag "A"] = "donationboard@colors123",
									[Fusion.Tag "B"] = "donationboard@rotation",
								}
							},
						},

						Fusion:New "Frame" {
							Name = "Rank",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 0.85,
							Size = UDim2.fromOffset(50, 65),
							[Fusion.Children] = {
								Fusion:New "UIListLayout" {
									FillDirection = Enum.FillDirection.Horizontal,
									SortOrder = Enum.SortOrder.LayoutOrder,
									HorizontalAlignment = Enum.HorizontalAlignment.Right,
									HorizontalFlex = Enum.UIFlexAlignment.None,
									ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
									VerticalAlignment = Enum.VerticalAlignment.Center,
									VerticalFlex = Enum.UIFlexAlignment.None,
								},

								Fusion:New "TextLabel" {
									AnchorPoint = Vector2.new(0, 0.5),
									AutomaticSize = Enum.AutomaticSize.Y,
									BackgroundTransparency = 1,
									Position = UDim2.fromScale(0, 0.5),
									Size = UDim2.fromScale(1, 0),
									FontFace = Font.new(Fonts[shared["donationboard@settings"].Font], Enum.FontWeight.Medium, Enum.FontStyle.Normal),
									Text = "#%d",
									TextSize = 35,
									TextScaled = true,
									TextColor3 = Color3.new(1, 1, 1),
									TextXAlignment = Enum.TextXAlignment.Center,
								}
							}
						},

						Fusion:New "Frame" {
							Name = "Thumbnail",
							AutomaticSize = Enum.AutomaticSize.X,
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 0.85,
							LayoutOrder = 2,
							Position = UDim2.fromOffset(51, 0),
							Size = UDim2.fromOffset(74, 65),
							Visible = false,

							[Fusion.Children] = {
								Fusion:New "UIListLayout" {
									FillDirection = Enum.FillDirection.Horizontal,
									SortOrder = Enum.SortOrder.LayoutOrder,
									HorizontalAlignment = Enum.HorizontalAlignment.Left,
									HorizontalFlex = Enum.UIFlexAlignment.None,
									ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
									VerticalAlignment = Enum.VerticalAlignment.Center,
									VerticalFlex = Enum.UIFlexAlignment.None,
								},

								Fusion:New "UIPadding" {
									PaddingLeft = UDim.new(0, 15),
									PaddingRight = UDim.new(0, 15),
								},

								Fusion:New "ImageLabel" {
									BackgroundTransparency = 1,
									Size = UDim2.fromOffset(44, 44),
									LayoutOrder = 1,
									Image = "rbxthumb://type=AvatarHeadShot&id=1&w=420&h=420",
								},

								
							}
						},

						Fusion:New "Frame" {
							Name = "Player",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 0.85,
							LayoutOrder = 3,
							AnchorPoint = Vector2.new(1, 0),
							Position = UDim2.fromScale(1, 0),
							Size = UDim2.fromOffset(456, 65),

							[Fusion.Children] = {
								Fusion:New "UIListLayout" {
									Padding = UDim.new(0, 12),
									FillDirection = Enum.FillDirection.Horizontal,
									SortOrder = Enum.SortOrder.LayoutOrder,
									HorizontalAlignment = Enum.HorizontalAlignment.Left,
									HorizontalFlex = Enum.UIFlexAlignment.None,
									ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
									VerticalAlignment = Enum.VerticalAlignment.Center,
									VerticalFlex = Enum.UIFlexAlignment.None,
								},

								Fusion:New "UIPadding" {
									PaddingLeft = UDim.new(0, 15),
									PaddingRight = UDim.new(0, 15),
								},	

								Fusion:New "TextLabel" {
									Name = "Username",
									AutomaticSize = Enum.AutomaticSize.Y,
									BackgroundTransparency = 1,
									Size = UDim2.fromScale(0, 0),
									LayoutOrder = 1,
									FontFace = Font.new(Fonts[shared["donationboard@settings"].Font], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
									Text = "Player",
									TextSize = 20,
									TextColor3 = shared["donationboard@settings"].TextColor,
									TextXAlignment = Enum.TextXAlignment.Left,
									TextWrapped = false,
									TextTruncate = Enum.TextTruncate.SplitWord,
									[Fusion.Tag "A"] = "donationboard@textcolor",

									[Fusion.Children] = {
										Fusion:New "UIFlexItem" {
											FlexMode = Enum.UIFlexMode.Fill,
										},
									},
								},
							
								Fusion:New "TextLabel" {
									Name = "Robux",
									AutomaticSize = Enum.AutomaticSize.XY,
									BackgroundTransparency = 1,
									LayoutOrder = 2,
									Size = UDim2.fromOffset(0, 0),
									FontFace = Font.new(Fonts[shared["donationboard@settings"].Font], Enum.FontWeight.Regular, Enum.FontStyle.Normal),
									Text = "N/A",
									RichText = true,
									TextSize = 20,
									TextColor3 = shared["donationboard@settings"].TextColor,
									TextTransparency = 0.25,
									TextXAlignment = Enum.TextXAlignment.Right,
									[Fusion.Tag "A"] = "donationboard@textcolor",
								}
							}
						},
					}
				}
			end,
		},

		Actions = {"Search", "Tax", "Conversion", "Fullscreen", "SortOrder", "SortDirection"},

		Clear = function(self)
			for _, canvas in self.Body.ScrollingFrame:GetChildren() do
				if canvas:IsA("CanvasGroup") then canvas:Destroy() end
			end
			return self
		end,
	
		Filter = function(self, keyword: string) 
			if (keyword) then self.Keyword = keyword return self end
			for _, canvas in self.Body.ScrollingFrame:GetChildren() do
				if not (canvas:IsA("CanvasGroup")) or canvas.Name == ("0x%05x"):format(-1) then continue end
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

				if (self.DonorCount < canvas.LayoutOrder) then
					canvas.Visible = false
					continue
				end
				canvas.Visible = #self.Keyword < 1 or hasKeyword
			end
			return self
		end,
	
		Sort = function(self) 
			local Canvases = {}
			for _, canvas in self.Body.ScrollingFrame:GetChildren() do
				if canvas:IsA("CanvasGroup") and canvas.Name ~= ("0x%05x"):format(-1) then
					table.insert(Canvases, canvas)
				end
			end

			table.sort(Canvases, function(a, b)
				local aName = a.Player.Username.Text:lower()
				local bName = b.Player.Username.Text:lower()
				local aRank = tonumber(a.Rank.TextLabel.Text:match("%d+")) or 0
				local bRank = tonumber(b.Rank.TextLabel.Text:match("%d+")) or 0

				if (self.SortOrder:lower() == "numeric") then
					if self.SortDirection:lower() == "ascending" then
						return aRank < bRank
					end
					return aRank > bRank
				end

				if self.SortDirection:lower() == "ascending" then
					return aName < bName
				end
				return aName > bName
			end)

			for index, canvas in Canvases do
				canvas.LayoutOrder = index
			end
		
			return self
		end,

		Tax = function(self) 
			local function f(value)
				return Util.Commaify(math.floor(value*100)/100)
			end

			for _, canvas in self.Body.ScrollingFrame:GetChildren() do
				if (not canvas:IsA("CanvasGroup")) then continue end
				pcall(function()
					canvas.Player.Robux.Text =`{canvas:GetAttribute("RichText"):format(f(canvas:GetAttribute("Robux") * (self.Taxed and 0.7 or 1)))}`..(self.Conversion and `<font transparency="0.5">→</font> {canvas:GetAttribute("RichText2"):format(`{self.CurrencyRate[self.Currency][1]}{f(self.CurrencyRate[self.Currency][2] * canvas:GetAttribute("Robux") * (self.Taxed and 0.7 or 1))}`)}` or "")
				end)
			end
		
			return self
		end,
	
		Generate = function(self, rankNumber: number)
			local _temp = self.Templates[shared["donationboard@settings"].DonorLayout]()

			if (rankNumber < 4) then
				_temp.Thumbnail:AddTag(`donationboard@rank{rankNumber}color`)
				_temp.Thumbnail:AddTag(`donationboard@rank{rankNumber}transparency`)
				_temp.Player:AddTag(`donationboard@rank{rankNumber}color`)
				_temp.Player:AddTag(`donationboard@rank{rankNumber}transparency`)
				_temp.Rank:AddTag(`donationboard@rank{rankNumber}color`)
				_temp.Rank:AddTag(`donationboard@rank{rankNumber}transparency`)
				_temp.Rank.TextLabel:AddTag(`donationboard@rank{rankNumber}textcolor`)
				_temp.Frame.UIGradient:Destroy()
				_temp.Frame:AddTag(`donationboard@rank{rankNumber}color`)
				_temp.Frame.BackgroundTransparency = 0.5
				return _temp
			end

			_temp.Thumbnail.BackgroundTransparency = 1
			_temp.Player.BackgroundTransparency = 1
			_temp.Rank.BackgroundTransparency = 1
			_temp.Frame.UIGradient:AddTag("donationboard@colors123")
			_temp.Frame.BackgroundTransparency = 0.8
			_temp.Rank.TextLabel:AddTag(`donationboard@textcolor`)
			_temp.Rank.TextLabel.TextTransparency = 0.5

			return _temp
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
		
			if (property == "Taxed") then
				self:Tax()
				return
			end

			if (property == "SortDirection") then
				self:Sort()
				return
			end

			if (property == "SortOrder") then
				self:Sort()
				return
			end

			if (property == "Conversion") then
				self:Tax()
				return
			end
		end)
	end

	return self
end


return List