--!nocheck
--!nolint
local Render, Class, Fusion, SettingsTemplate, Navigation, RefreshBar, Topbar, List, Analytics, Donate, Settings, DeveloperProducts, Alert, Util, Theme, Themes, Rates, Fonts = {}, 
require("./Libraries/Class"), 
require("./Dependencies/Fusion"),
require("./Templates/Settings"),
require("@self/Navigation"),
require("@self/RefreshBar"),
require("@self/Topbar"),
require("@self/List"),
require("@self/Analytics"),
require("@self/Donate"),
require("@self/Settings"),
require("@self/DeveloperProducts"),
require("@self/Alert"),
require("./Libraries/Util"),
require("@self/Theme"),
require("./Templates/Themes"),
require("./Templates/Rates"),
require("./Templates/Fonts")
Render.__index = Render
Fusion = Fusion.scoped(Fusion)


export type classType = {
	SurfaceGui: SurfaceGui,
	Adornee: BasePart,
	Enabled: boolean,
	Fullscreen: boolean,
	Canvas: CanvasGroup,
	Navigation: typeof(Navigation),
	RefreshBar: typeof(RefreshBar),
	Topbar: typeof(Topbar),
	List: typeof(List),
	Donate: typeof(Donate),
	Alert: typeof(Alert),
	RefreshEvent: RemoteEvent,
	AlertEvent: RemoteEvent,
	CurrentPage: string,
	PatternSpeed: number,
	Settings: typeof(SettingsTemplate),
}


function Render.new(adornee: BasePart)
	Render:_getEnvironment()
	local _settings = Class.new(table.clone(SettingsTemplate))
	for key, value in Render:_requestSettings() do _settings[key] = value end
	shared["_db/cache"] = shared["_db/cache"] or {}
	shared["_db/environment"] = shared["_db/environment"] or {debugmode=game:GetService("TestService"):GetAttribute("_db/debugmode")}
	
	local self = Class.new {
		SurfaceGui = Fusion:New "SurfaceGui" {
			Name = `db@{adornee.Name:lower():gsub(" ", "")}`,
			Parent = game:GetService("Players").LocalPlayer.PlayerGui,
			Adornee = adornee,
			AlwaysOnTop = _settings.AlwaysOnTop,
			Face = Enum.NormalId.Front,
			LightInfluence = 1,
			Brightness = 2,
			ResetOnSpawn = false,
			SizingMode = Enum.SurfaceGuiSizingMode[_settings.SizingMode],
			CanvasSize = Vector2.new(562, 745) - (_settings.HideOutline and Vector2.one * 16 or Vector2.zero),
			PixelsPerStud = 50,

			[Fusion.Children] = {
				Fusion:New "Frame" {
					Name = "Body",
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					BackgroundColor3 = Color3.fromHex('#282828'),
					BackgroundTransparency = _settings.HideOutline and 1 or _settings.Transparency,
					Size = UDim2.fromOffset(562, 745),

					[Fusion.Tag "A"] = "donationboard@backgroundcolor",
					[Fusion.Children] = {
						Fusion:New "UICorner" {
							CornerRadius = UDim.new(0, 7),
						},

						Fusion:New "UIGradient" {
							Color = ColorSequence.new(_settings.Colors[1], _settings.Colors[2]),
							[Fusion.Tag "A"] = "donationboard@colors12",
							[Fusion.Tag "B"] = "donationboard@rotation",
						},

						Fusion:New "UIPadding" {
							PaddingBottom = UDim.new(0, 8),
							PaddingLeft = UDim.new(0, 8),
							PaddingRight = UDim.new(0, 8),
							PaddingTop = UDim.new(0, 8),
						},

						Fusion:New "CanvasGroup" {
							BackgroundTransparency = 1,
							Size = UDim2.fromScale(1, 1),

							[Fusion.Tag "A"] = "donationboard@tintcolor",
							[Fusion.Children] = {
								Fusion:New "UICorner" {
									CornerRadius = UDim.new(0, 8),
								},

								Fusion:New "UIStroke" {
									Color = Color3.new(1, 1, 1),
									ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
									Thickness = 2,
									Enabled = not _settings.HideOutline,

									[Fusion.Children] = {
										Fusion:New "UIGradient" {
											Color = ColorSequence.new(_settings.Colors[1], _settings.Colors[2]),
											Rotation = 45,
											[Fusion.Tag "A"] = "donationboard@colors12",
											[Fusion.Tag "B"] = "donationboard@rotation",
										},
									}
								},

								Fusion:New "Frame" {
									Name = "Background",
									BackgroundColor3 = Color3.fromHex("#282828"),
									BackgroundTransparency = 0,
									Size = UDim2.fromScale(1, 1),
									ZIndex = 0,

									[Fusion.Tag "A"] = "donationboard@backgroundcolor",
									[Fusion.Children] = {
										Fusion:New "UIGradient" {
											Rotation = 90,
											Color = ColorSequence.new({
												ColorSequenceKeypoint.new(0, _settings.Colors[1]),
												ColorSequenceKeypoint.new(0.5, _settings.Colors[2]),
												ColorSequenceKeypoint.new(1, _settings.Colors[3])
											}),

											[Fusion.Tag "A"] = "donationboard@colors123",
											[Fusion.Tag "B"] = "donationboard@rotation",
										},

										Fusion:New "ImageLabel" {
											AnchorPoint = Vector2.new(0.5, 0.5),
											BackgroundTransparency = 1,
											Position = UDim2.new(0.045, -1, 0.5, 0),
											Size = UDim2.fromScale(5, 5),
											Image = _settings.PatternId or "rbxassetid://124198052077055",
											ImageTransparency = 0.98,
											ScaleType = Enum.ScaleType.Tile,
											TileSize = UDim2.fromOffset(400, 400),
										},
									},
								}
							}
						}
					}
				}
			}
		},

		CurrentPage = "Untitled",
		PreviousPage = "Untitled",

		PatternSpeed = 0.25,
		BoardSettings = _settings,

		Adornee = adornee,
		Enabled = true,
		Fullscreen = false,
		Tax = false,
		SortOrder = "Numeric",
		SortDirection = "Ascending",
		Conversion = false,

		PromptProductPurchase = function(self, productId: number, forceSafeMode: boolean)
			if (not self.BoardSettings.SafeMode and not forceSafeMode) then
				game:GetService("MarketplaceService"):PromptProductPurchase(game:GetService("Players").LocalPlayer, productId)			
				return
			end

			self.RefreshBind:Fire("PromptProductPurchase")
			local productInfo = game:GetService("MarketplaceService"):GetProductInfo(productId, Enum.InfoType.Product)

			local Prompt = Fusion:New "ScreenGui" {
				IgnoreGuiInset = true,
				ResetOnSpawn = false,

				[Fusion.Children] = {
					Fusion:New "Frame" {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromHex("#272930"),
						Position = UDim2.fromScale(0.5, -0.5),
						Size = UDim2.fromOffset(400, 318),

						[Fusion.Children] = {
							Fusion:New "UICorner" {
								CornerRadius = UDim.new(0, 8),
							},

							Fusion:New "UIPadding" {
								PaddingLeft = UDim.new(0, 24),
								PaddingRight = UDim.new(0, 24),
							},	

							Fusion:New "TextLabel" {
								AnchorPoint = Vector2.new(0.5, 0),
								BackgroundTransparency = 1,
								Position = UDim2.new(0.5, 0, 0, 12),
								Size = UDim2.fromOffset(100, 27),

								FontFace = Font.fromName(`BuilderSans`, Enum.FontWeight.Bold, Enum.FontStyle.Normal),
								Text = "Buy Item",
								TextColor3 = shared["donationboard@settings"].TextColor,
								TextSize = 25,
								TextXAlignment = Enum.TextXAlignment.Center,
								TextYAlignment = Enum.TextYAlignment.Center,

								[Fusion.Tag "A"] = "donationboard@textcolor",
							},

							Fusion:New "Frame" {
								Position = UDim2.fromOffset(0, 52),
								BackgroundColor3 = Color3.fromHex("#d0d9fb"),
								BackgroundTransparency = 0.84,
								Size = UDim2.new(1, 0, 0, 1),
							},

							Fusion:New "ImageLabel" {
								AnchorPoint = Vector2.new(0.5, 0),
								BackgroundTransparency = 1,
								Position = UDim2.new(0.5, 0, 0, 76),
								Size = UDim2.fromOffset(85, 85),
								Image = ""
							},

							Fusion:New "TextLabel" {
								Name = "ItemName",
								AnchorPoint = Vector2.new(0.5, 0),
								BackgroundTransparency = 1,
								Position = UDim2.new(0.5, 0, 0, 185),
								Size = UDim2.new(1, 0, 0, 22),
								FontFace = Font.fromName(`BuilderSans`, Enum.FontWeight.Medium, Enum.FontStyle.Normal),
								Text = `Would you like to buy "%s"?`,
								TextColor3 = Color3.fromHex("#d5d7dd"),
								TextSize = 20,
								TextXAlignment = Enum.TextXAlignment.Center,
								TextYAlignment = Enum.TextYAlignment.Center,
							},

							Fusion:New "TextButton" {
								Name = "Cancel",
								BackgroundTransparency = 1,
								Position = UDim2.fromOffset(0, 231),
								Size = UDim2.fromOffset(170, 36),
								FontFace = Font.fromName(`BuilderSans`, Enum.FontWeight.Bold, Enum.FontStyle.Normal),
								Text = "Cancel",
								TextColor3 = shared["donationboard@settings"].TextColor,
								TextTransparency = 0.3,
								TextSize = 20,
								TextXAlignment = Enum.TextXAlignment.Center,
								TextYAlignment = Enum.TextYAlignment.Center,

								[Fusion.Tag "A"] = "donationboard@textcolor",
								[Fusion.Children] = {
									Fusion:New "UICorner" {
										CornerRadius = UDim.new(0, 8),
									},

									Fusion:New "UIStroke" {
										ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
										Color = Color3.new(1, 1, 1),
										Transparency = 0.3
									},
								}
							},

							Fusion:New "TextButton" {
								Name = "Purchase",
								BackgroundColor3 = Color3.new(1, 1, 1),
								AnchorPoint = Vector2.new(1, 0),
								Position = UDim2.new(1, 0, 0, 231),
								Size = UDim2.fromOffset(170, 36),
								FontFace = Font.fromName(`BuilderSans`, Enum.FontWeight.Bold, Enum.FontStyle.Normal),
								Text = "",
								TextColor3 = Color3.new(1, 1, 1),
								TextTransparency = 0.3,
								TextSize = 20,
								TextXAlignment = Enum.TextXAlignment.Center,
								TextYAlignment = Enum.TextYAlignment.Center,

								[Fusion.Children] = {
									Fusion:New "UICorner" {
										CornerRadius = UDim.new(0, 8),
									},

									Fusion:New "UIListLayout" {
										Padding = UDim.new(0, 5),
										FillDirection = Enum.FillDirection.Horizontal,
										HorizontalAlignment = Enum.HorizontalAlignment.Center,
										VerticalAlignment = Enum.VerticalAlignment.Center,
									},

									Fusion:New "ImageLabel" {
										BackgroundTransparency = 1,
										Size = UDim2.fromOffset(36, 36),
										Image = "rbxasset://LuaPackages/Packages/_Index/FoundationImages/FoundationImages/SpriteSheets/img_set_1x_8.png",
										ImageColor3 = Color3.fromHex("#202227"),
										ImageRectOffset = Vector2.new(454, 388),
										ImageRectSize = Vector2.new(36, 36),
									},

									Fusion:New "TextLabel" {
										AutomaticSize = Enum.AutomaticSize.X,
										BackgroundTransparency = 1,
										Size = UDim2.fromScale(0, 1),
										FontFace = Font.fromName(`BuilderSans`, Enum.FontWeight.Bold, Enum.FontStyle.Normal),
										Text = "1",
										TextColor3 = Color3.fromHex("#202227"),
										TextSize = 20,
										TextXAlignment = Enum.TextXAlignment.Center,
										TextYAlignment = Enum.TextYAlignment.Center,
									},
								}
							},

							Fusion:New "TextLabel" {
								Name = "TestPurchaseTest",
								AnchorPoint = Vector2.new(0.5, 0),
								BackgroundTransparency = 1,
								Position = UDim2.new(0.5, 0, 0, 279),
								Size = UDim2.new(1, 0, 0, 15),
								FontFace = Font.fromName(`BuilderSans`, Enum.FontWeight.Medium, Enum.FontStyle.Normal),
								Text = `This is a test purchase. Your account will not be charged.`,
								TextColor3 = Color3.fromHex("#d5d7dd"),
								TextSize = 12,
								TextXAlignment = Enum.TextXAlignment.Center,
								TextYAlignment = Enum.TextYAlignment.Center,
							},
						},
					},
				}
			}

			local connection, connection2, connection3;
			local Prep do
				Prompt.Frame.ImageLabel.Image = productInfo.IconImageAssetId
				Prompt.Frame.ItemName.Text = Prompt.Frame.ItemName.Text:format(productInfo.Name)
				Prompt.Frame.Purchase.TextLabel.Text = productInfo.PriceInRobux
				Prompt.Frame.Position = UDim2.fromScale(0.5, -0.5)

				Prompt.Frame.Cancel.MouseEnter:Connect(function()
					Prompt.Frame.Cancel.UIStroke.Transparency = 0
					Prompt.Frame.Cancel.TextTransparency = 0
				end)

				Prompt.Frame.Cancel.MouseLeave:Connect(function()
					Prompt.Frame.Cancel.UIStroke.Transparency = 0.3
					Prompt.Frame.Cancel.TextTransparency = 0.3
				end)
			end

			Prompt.Parent = game:GetService("Players").LocalPlayer.PlayerGui
			Prompt.Frame:TweenPosition(UDim2.fromScale(0.5, 0.5), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 1)

			local Disappear = function()
				if (connection) then connection:Disconnect() end
				if (connection2) then connection2:Disconnect() end
				Prompt.DisplayOrder = -1
				Prompt.Frame:TweenPosition(UDim2.fromScale(0.5, -0.5), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 1)
				task.delay(1, function()
					Prompt:Destroy()
				end)
			end

			local Successful = function()
				Prompt.Frame.Purchase.BackgroundTransparency = 0.5
				game:GetService("ReplicatedStorage"):FindFirstChild("donationboard@public").Signals:FindFirstChild("Commit"):InvokeServer("receipt", productId)

				Prompt.Frame.Size = UDim2.fromOffset(400, 182)
				Prompt.Frame.ImageLabel:Destroy()
				Prompt.Frame.ItemName.Text = ("Your purchase of %s succeeded!"):format(productInfo.Name)
				Prompt.Frame.ItemName.Position = UDim2.new(0.5, 0, 0, 76)
				Prompt.Frame.Cancel:Destroy()
				Prompt.Frame.Purchase.Size = UDim2.fromOffset(352, 36)
				Prompt.Frame.Purchase.BackgroundTransparency = 0
				Prompt.Frame.Purchase.Position = UDim2.new(1, 0, 0, 122)
				Prompt.Frame.Purchase.ImageLabel:Destroy()
				Prompt.Frame.Purchase.TextLabel.Text = "OK"
				Prompt.Frame.TestPurchaseTest:Destroy()

				connection2 = Prompt.Frame.Purchase.MouseButton1Click:Once(function()
					Prompt.Frame.Purchase.BackgroundTransparency = 0.5
					Disappear()
				end)
			end


			connection = Prompt.Frame.Cancel.MouseButton1Click:Once(function()
				connection2:Disconnect()
				Disappear()
			end)

			connection2 = Prompt.Frame.Purchase.MouseButton1Click:Once(function()
				connection:Disconnect()
				Successful()
			end)

			connection3 = self.RefreshBind.Event:Connect(function(specific)
				if (specific == "PromptProductPurchase") then
					connection:Disconnect()
					connection2:Disconnect()
					connection3:Disconnect()
					Disappear()
				end
			end)
		end,
	}

	local LoadingScreen do
		LoadingScreen = Fusion:New "SurfaceGui" {
			Name = `db@{adornee.Name:lower():gsub(" ", "")}`,
			Parent = game:GetService("Players").LocalPlayer.PlayerGui,
			Adornee = adornee,
			AlwaysOnTop = _settings.AlwaysOnTop,
			Face = Enum.NormalId.Front,
			LightInfluence = 1,
			Brightness = 2,
			ResetOnSpawn = false,
			SizingMode = Enum.SurfaceGuiSizingMode[_settings.SizingMode],
			CanvasSize = Vector2.new(562, 745) - (_settings.HideOutline and Vector2.one * 16 or Vector2.zero),
			PixelsPerStud = 50,
			ZOffset = 99,

			[Fusion.Children] = {
				Fusion:New "Frame" {
					Name = "Body",
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					BackgroundColor3 = Color3.fromHex('#282828'),
					BackgroundTransparency = 0,
					Size = UDim2.fromOffset(562, 745),

					[Fusion.Tag "A"] = "donationboard@backgroundcolor",
					[Fusion.Children] = {
						Fusion:New "UICorner" {
							CornerRadius = UDim.new(0, 7),
						},

						Fusion:New "UIGradient" {
							Color = ColorSequence.new(_settings.Colors[1], _settings.Colors[2]),
							[Fusion.Tag "A"] = "donationboard@colors12",
							[Fusion.Tag "B"] = "donationboard@rotation",
						},

						Fusion:New "UIPadding" {
							PaddingBottom = UDim.new(0, 8),
							PaddingLeft = UDim.new(0, 8),
							PaddingRight = UDim.new(0, 8),
							PaddingTop = UDim.new(0, 8),
						},

						Fusion:New "CanvasGroup" {
							BackgroundTransparency = 1,
							Size = UDim2.fromScale(1, 1),

							[Fusion.Tag "A"] = "donationboard@tintcolor",
							[Fusion.Children] = {
								Fusion:New "UICorner" {
									CornerRadius = UDim.new(0, 8),
								},

								Fusion:New "UIStroke" {
									Color = Color3.new(1, 1, 1),
									ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
									Thickness = 2,
									Enabled = not _settings.HideOutline,

									[Fusion.Children] = {
										Fusion:New "UIGradient" {
											Color = ColorSequence.new(_settings.Colors[1], _settings.Colors[2]),
											Rotation = 45,
											[Fusion.Tag "A"] = "donationboard@colors12",
											[Fusion.Tag "B"] = "donationboard@rotation",
										},
									}
								},

								Fusion:New "Frame" {
									Name = "Background",
									BackgroundColor3 = Color3.fromHex("#282828"),
									BackgroundTransparency = 0,
									Size = UDim2.fromScale(1, 1),
									ZIndex = 0,

									[Fusion.Tag "A"] = "donationboard@backgroundcolor",
									[Fusion.Children] = {
										Fusion:New "UIGradient" {
											Rotation = 90,
											Color = ColorSequence.new({
												ColorSequenceKeypoint.new(0, _settings.Colors[1]),
												ColorSequenceKeypoint.new(0.5, _settings.Colors[2]),
												ColorSequenceKeypoint.new(1, _settings.Colors[3])
											}),

											[Fusion.Tag "A"] = "donationboard@colors123",
											[Fusion.Tag "B"] = "donationboard@rotation",
										},

										Fusion:New "ImageLabel" {
											AnchorPoint = Vector2.new(0.5, 0.5),
											BackgroundTransparency = 1,
											Position = UDim2.new(0.045, -1, 0.5, 0),
											Size = UDim2.fromScale(5, 5),
											Image = _settings.PatternId or "rbxassetid://124198052077055",
											ImageTransparency = 0.98,
											ScaleType = Enum.ScaleType.Tile,
											TileSize = UDim2.fromOffset(400, 400),
										},
									},
								},

								Fusion:New "Frame" {
									Name = "Loading",
									BackgroundTransparency = 1,
									Size = UDim2.fromScale(1, 1),

									[Fusion.Children] = {
										Fusion:New "UIListLayout" {
											Padding = UDim.new(0, 15),
											FillDirection = Enum.FillDirection.Vertical,
											SortOrder = Enum.SortOrder.LayoutOrder,
											HorizontalAlignment = Enum.HorizontalAlignment.Center,
											VerticalAlignment = Enum.VerticalAlignment.Center,
										},

										Fusion:New "Frame" {
											Name = "Buffer",
											Size = UDim2.fromOffset(50, 50),
											BackgroundTransparency = 1,
											LayoutOrder = 1,

											[Fusion.Children] = {
												Fusion:New "ImageLabel" {
													Name = "Icon",
													BackgroundTransparency = 1,
													LayoutOrder = 1,
													Size = UDim2.fromOffset(50, 50),
													Image = "rbxassetid://16643866406",
												},
											},
										},

										Fusion:New "Frame" {
											Name = "Bar",
											BackgroundColor3 = Color3.new(0, 0, 0),
											BackgroundTransparency = 0.25,
											LayoutOrder = 2,
											Size = UDim2.new(0.7, 0, 0, 10),

											[Fusion.Children] = {
												Fusion:New "UICorner" {
													CornerRadius = UDim.new(1, 0)
												},	

												Fusion:New "Frame" {
													BackgroundColor3 = _settings.Colors[1],
													BackgroundTransparency = 0.25,
													LayoutOrder = 2,
													Size = UDim2.fromScale(0, 1),

													[Fusion.Tag "A"] = "donationboard@color1",
													[Fusion.Children] = {
														Fusion:New "UICorner" {
															CornerRadius = UDim.new(1, 0)
														},	
													}	
												}
											},
										},

										Fusion:New "TextLabel" {
											Name = "Percentage",
											AutomaticSize = Enum.AutomaticSize.XY,
											BackgroundTransparency = 1,
											Size = UDim2.new(),
											LayoutOrder = 3,
											FontFace = Font.fromName(_settings.Font, Enum.FontWeight.Medium, Enum.FontStyle.Normal),
											Text = "0%",
											TextColor3 = _settings.TextColor,
											TextSize = 25,
											TextTransparency = 0.3,

											[Fusion.Tag "A"] = "donationboard@textcolor",
										},
									},
								},

								Fusion:New "TextLabel" {
									Name = "PleaseWaitAMoment",
									AnchorPoint = Vector2.new(0.5, 1),
									AutomaticSize = Enum.AutomaticSize.XY,
									BackgroundTransparency = 1, 
									Size = UDim2.new(),
									Position = UDim2.fromScale(0.5, 0.9),
									LayoutOrder = 3,
									FontFace = Font.fromName(_settings.Font, Enum.FontWeight.Medium, Enum.FontStyle.Normal),
									Text = "Please wait a moment",
									TextColor3 = _settings.Colors[1],
									TextSize = 30,
									TextTransparency = 0.3,

									[Fusion.Tag "A"] = "donationboard@color1",
								},
							}
						}
					}
				}
			}
		}

		local c, manual = 0, false
		game:GetService("RunService"):BindToRenderStep("_db/loadingbuffer", 1, function(delta)
			c += delta
			LoadingScreen.Body.CanvasGroup.Loading.Bar.Frame.Size = UDim2.fromScale(math.clamp(c/5, 0, 1), 1)
			LoadingScreen.Body.CanvasGroup.Loading.Percentage.Text = c>5 and `Finalizing` or `{math.clamp(math.floor((c/5)*100), 0, 100)}%`
			LoadingScreen.Body.CanvasGroup.Loading.Buffer.Icon.Rotation += 3
			LoadingScreen.Body.CanvasGroup.PleaseWaitAMoment.Text = `Please wait a moment{string.rep(".", math.floor(c % 3) + 1)}`

			if (c>5 and not manual) then
				manual = true
				local data = self:_requestRefresh()
				warn(data)
				rawset(self, "_lastRefreshData", data or self._lastRefreshData)
				self.RefreshBar.Speed = data.Settings.RefreshRate
				self.RefreshBar:Lap()
				self.RefreshBind:Fire("List")
				self.RefreshBind:Fire("Donate")
			end
		end)
	end

	local ApplyColorScheme, ThemeKeys do
		local TagRules = {
			["donationboard@rotation"] = function(obj)
				if not (obj:GetAttribute("Rotation")) then 
					obj:SetAttribute("Rotation", obj.Rotation)
				end
				obj.Rotation = obj:GetAttribute("Rotation") + self.BoardSettings.Rotation
			end,

			["donationboard@scrollbar"] = function(obj)
				for _, prop in {"BackgroundColor3", "ScrollBarImageColor3"} do
					pcall(function() 
						local H, S, V = self.BoardSettings.Colors[1]:ToHSV()
						obj[prop] = Color3.fromHSV(H, S, math.max(V, self.BoardSettings.BackgroundColor) - math.min(V, self.BoardSettings.BackgroundColor))
					end)
				end
			end,

			["donationboard@titlecolor"] = function(obj)
				obj.TextColor3 = self.BoardSettings.TitleColor
			end,

			["donationboard@backgroundcolor"] = function(obj)
				obj.BackgroundColor3 = Color3.fromHSV(0, 0, self.BoardSettings.BackgroundColor)
			end,

			["donationboard@tintcolor"] = function(obj)
				obj.GroupColor3 = self.BoardSettings.TintColor
			end,

			["donationboard@backdropcolor"] = function(obj)
				obj.BackgroundColor3 = self.BoardSettings.BackdropColor
			end,

			["donationboard@backdroptransparency"] = function(obj)
				obj.BackgroundTransparency = self.BoardSettings.BackdropTransparency
			end,

			["donationboard@colors123"] = function(obj)
				obj.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, self.BoardSettings.Colors[1]),
					ColorSequenceKeypoint.new(0.5, self.BoardSettings.Colors[2]),
					ColorSequenceKeypoint.new(1, self.BoardSettings.Colors[3]),
				})
			end,

			["donationboard@colors12"] = function(obj)
				obj.Color = ColorSequence.new(self.BoardSettings.Colors[1], self.BoardSettings.Colors[2])
			end,

			["donationboard@colors13"] = function(obj)
				obj.Color = ColorSequence.new(self.BoardSettings.Colors[1], self.BoardSettings.Colors[3])
			end,

			["donationboard@colors23"] = function(obj)
				obj.Color = ColorSequence.new(self.BoardSettings.Colors[2], self.BoardSettings.Colors[3])
			end,

			["donationboard@textcolor"] = function(obj)
				obj.TextColor3 = self.BoardSettings.TextColor
				if obj:IsA("TextBox") then
					obj.PlaceholderColor3 = self.BoardSettings.TextColor
				end
			end,

			["donationboard@iconcolor"] = function(obj)
				obj.ImageColor3 = self.BoardSettings.IconColor
			end,

			["donationboard@rank1color"] = function(obj)
				for _, prop in {"BackgroundColor3", "TextColor3", "ImageColor3"} do
					pcall(function() obj[prop] = self.BoardSettings.Rank1Color end)
				end
			end,

			["donationboard@rank1textcolor"] = function(obj)
				for _, prop in {"TextColor3"} do
					pcall(function() obj[prop] = self.BoardSettings.Rank1TextColor end)
				end
			end,

			["donationboard@rank1transparency"] = function(obj)
				for _, prop in {"BackgroundTransparency", "TextTransparency"} do
					pcall(function() obj[prop] = self.BoardSettings.Rank1Transparency end)
				end
			end,

			["donationboard@rank2color"] = function(obj)
				for _, prop in {"BackgroundColor3", "TextColor3", "ImageColor3"} do
					pcall(function() obj[prop] = self.BoardSettings.Rank2Color end)
				end
			end,

			["donationboard@rank2textcolor"] = function(obj)
				for _, prop in {"TextColor3"} do
					pcall(function() obj[prop] = self.BoardSettings.Rank2TextColor end)
				end
			end,

			["donationboard@rank2transparency"] = function(obj)
				for _, prop in {"BackgroundTransparency", "TextTransparency"} do
					pcall(function() obj[prop] = self.BoardSettings.Rank2Transparency end)
				end
			end,

			["donationboard@rank3color"] = function(obj)
				for _, prop in {"BackgroundColor3", "TextColor3", "ImageColor3"} do
					pcall(function() obj[prop] = self.BoardSettings.Rank3Color end)
				end
			end,

			["donationboard@rank3textcolor"] = function(obj)
				for _, prop in {"TextColor3"} do
					pcall(function() obj[prop] = self.BoardSettings.Rank3TextColor end)
				end
			end,

			["donationboard@rank3transparency"] = function(obj)
				for _, prop in {"BackgroundTransparency", "TextTransparency"} do
					pcall(function() obj[prop] = self.BoardSettings.Rank3Transparency end)
				end
			end,

			["donationboard@color1"] = function(obj)
				for _, prop in {"BackgroundColor3", "TextColor3", "ImageColor3"} do
					pcall(function() obj[prop] = self.BoardSettings.Colors[1] end)
				end
			end,

			["donationboard@color2"] = function(obj)
				for _, prop in {"BackgroundColor3", "TextColor3", "ImageColor3"} do
					pcall(function() obj[prop] = self.BoardSettings.Colors[2] end)
				end
			end,

			["donationboard@color3"] = function(obj)
				for _, prop in {"BackgroundColor3", "TextColor3", "ImageColor3"} do
					pcall(function() obj[prop] = self.BoardSettings.Colors[3] end)
				end
			end,
		}

		local function applyThemeOnObject(object)
			if object:GetAttribute("Ignore") then return end
			for _, tag in object:GetTags() do
				if not (TagRules[tag]) then continue end
				TagRules[tag](object)
			end
		end

		local function applyTheme(specific: string?)
			if (specific) then
				if (specific == "Colors") then
					for _, tag in {`donationboard@colors123`, `donationboard@colors12`, `donationboard@colors13`, `donationboard@colors23`, `donationboard@color1`, `donationboard@color2`, `donationboard@color3`, `donationboard@scrollbar`} do
						for _, object in game:GetService("CollectionService"):GetTagged(tag) do
							if object:GetAttribute("Ignore") then continue end
							TagRules[tag](object)
						end
					end 
					return
				end

				specific = `donationboard@{specific:lower():gsub(" ", "")}`
				for _, object in game:GetService("CollectionService"):GetTagged(specific) do
					if object:GetAttribute("Ignore") then continue end
					TagRules[specific](object)
				end
				return
			end	

			for tag, rule in TagRules do
				for _, object in game:GetService("CollectionService"):GetTagged(tag) do
					if object:GetAttribute("Ignore") then continue end
					rule(object)
				end
			end
		end

		self.SurfaceGui.DescendantAdded:Connect(function(desc)
			applyThemeOnObject(desc)
		end)

		applyTheme()
		ApplyColorScheme = applyTheme
		ThemeKeys = {
			"Theme", "Colors", "TextColor", "IconColor", 
			"Rank1Color", "Rank2Color", "Rank3Color", "BackdropColor", 
			"BackdropTransparency","TintColor", "BackgroundColor", "TitleColor", 
			"Rank1TextColor", "Rank2TextColor", "Rank3TextColor", "Rotation"
		}
	end

	local SyncSettings do
		shared["donationboard@settings"] = self.BoardSettings:GetValues()
		self.BoardSettings.Changed:Connect(function(property, value)
			shared["donationboard@settings"] = self.BoardSettings:GetValues()

			if (table.find(ThemeKeys, property) ~= nil) then
				ApplyColorScheme(property)
				return
			end

			if (property == "Background") then
				self.SurfaceGui.Body.CanvasGroup.Background.ImageLabel.Visible = value
				return
			end

			if (property == "Brightness") then
				self.SurfaceGui.Brightness = value
				return
			end

			if (property == "LightInfluence") then
				self.SurfaceGui.LightInfluence = value
				return
			end

			if (property == "Transparency") then
				self.SurfaceGui.Body.BackgroundTransparency = self.BoardSettings.HideOutline and 1 or value
				self.SurfaceGui.Body.CanvasGroup.Background.BackgroundTransparency = value
				self.SurfaceGui.Body.CanvasGroup.Background.ImageLabel.ImageTransparency = 0.98 + (0.02 * value)
				self.SurfaceGui.Adornee.Transparency = value
				return
			end

			if (property == "Tax") then
				self.Tax = value == "On"
				self.Topbar.Disabled.Tax = value ~= "Disabled"
				return
			end

			if (property == "SortOrder") then
				self.Topbar.Disabled.SortOrder = value:lower() ~= "disabled"	
				self.SortOrder = value == "Alphabetical" and "Alphabetical" or "Numeric"
				return
			end

			if (property == "SortDirection") then
				self.Topbar.Disabled.SortDirection = value:lower() ~= "disabled"	
				self.SortDirection = value == "Descending" and "Descending" or "Ascending"
				return
			end

			if (property == "DevExRate") then
				self.Topbar.Disabled.Conversion = value:lower() ~= "disabled"	
				self.Conversion = value == "On"
				return
			end

			if (property == "DonorCount") then
				self.List.DonorCount = tonumber(value)
				return
			end

			if (property == "FullscreenEnabled") then
				self.Topbar.Disabled.Fullscreen = value
				self.Fullscreen = false
				return
			end

			if (property == "UseRobuxIcon") then
				self.RefreshBind:Fire()
				return
			end

			if (property == "DisplayTotal") then
				local _temp = self.List.Body.ScrollingFrame:FindFirstChild(("0x%05x"):format(-1))
				if (_temp) then _temp.Visible = value end
				return
			end

			if (table.find({"NamingScheme", "DonorLayout"}, property)) then
				self.RefreshBind:Fire("List")
				return 
			end

			if (property == "SafeMode") then
				self.RefreshBind:Fire("PromptProductPurchase")
				return
			end

			if (property == "PatternId") then
				self.SurfaceGui.Body.CanvasGroup.Background.ImageLabel.Image = self.BoardSettings.PatternId
				return
			end

			if (property == "HideOutline") then
				self.SurfaceGui.Body.CanvasGroup.UIStroke.Enabled = not self.BoardSettings.HideOutline
				self.SurfaceGui.Body.BackgroundTransparency = value and 1 or self.BoardSettings.Transparency 
				self.SurfaceGui.CanvasSize = Vector2.new(562, 745) - (value and Vector2.one * 16 or Vector2.zero)
				return
			end

			if (property == "HideTopbar") then
				if not (self.Topbar) then return end
				self.Topbar.Enabled = not self.BoardSettings.HideTopbar
				for _, page in {"Analytics", "DeveloperProducts", "Donate", "List", "Theme", "Settings"} do
					self[page].Body.Position = UDim2.fromOffset(0, self.BoardSettings.HideTopbar and 0 or self.Topbar.Body.AbsoluteSize.Y)
					self[page].Body.Size = UDim2.new(1, 0, 0, 544 + (self.BoardSettings.HideTopbar and 90 or (self.Topbar.Body.AbsoluteSize.Y == 50 and 50 or 0)) + (self.BoardSettings.HideRefreshbar and self.RefreshBar.Body.AbsoluteSize.Y or 0))
				end
				return
			end

			if (property == "HideRefreshbar") then
				if not (self.RefreshBar) then return end
				self.RefreshBar.Enabled = not self.BoardSettings.HideRefreshbar
				for _, page in {"Analytics", "DeveloperProducts", "Donate", "List", "Theme", "Settings"} do
					self[page].Body.Position = UDim2.fromOffset(0, self.BoardSettings.HideTopbar and 0 or self.Topbar.Body.AbsoluteSize.Y)
					self[page].Body.Size = UDim2.new(1, 0, 0, 544 + (self.BoardSettings.HideTopbar and 90 or (self.Topbar.Body.AbsoluteSize.Y == 50 and 50 or 0)) + (self.BoardSettings.HideRefreshbar and self.RefreshBar.Body.AbsoluteSize.Y or 0))
				end
				return
			end

			if (property == "HideSearch") then
				if not (self.Topbar) then return end
				self.Topbar.Disabled.Search = not value
				return
			end

			if (property == "DevExCurrency") then
				self.List.Currency = value
				self.Donate.Currency = value
				self.DeveloperProducts.Currency = value
				self.Analytics.Currency = value
				self.Settings.Currency = value
				self.Conversion = false
				return
			end

			if (property == "AlwaysOnTop") then
				self.SurfaceGui.AlwaysOnTop = value
				return
			end

			if (property == "SizingMode") then
				self.SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode[value]
				return
			end

			if (property == "Font") then
				for _, textlabel in self.SurfaceGui:GetDescendants() do
					if (table.find({"TextLabel", "TextBox", "TextButton"}, textlabel.ClassName)) then
						textlabel.FontFace = Font.fromName(value, textlabel.FontFace.Weight, textlabel.FontFace.Style)
					end
				end
				return
			end

			if (property == "Template") then

				return
			end
		end)
	end

	rawset(self, "Canvas", self.SurfaceGui.Body.CanvasGroup)
	rawset(self, "Navigation", Navigation.new(self.Canvas))
	rawset(self, "RefreshBar", RefreshBar.new(self.Canvas))
	rawset(self, "Topbar", Topbar.new(self.Canvas))
	rawset(self, "List", List.new(self.Canvas))
	rawset(self, "Analytics", Analytics.new(self.Canvas))
	rawset(self, "Donate", Donate.new(self.Canvas))
	rawset(self, "Settings", Settings.new(self.Canvas))
	rawset(self, "DeveloperProducts", DeveloperProducts.new(self.Canvas))
	rawset(self, "Theme", Theme.new(self.Canvas))
	rawset(self, "Alert", Alert)
	rawset(self, "RefreshEvent", game:GetService("CollectionService"):GetTagged("donationboard@refresh")[1])
	rawset(self, "RefreshBind", Instance.new("BindableEvent"))
	rawset(self, "AlertEvent", game:GetService("CollectionService"):GetTagged("donationboard@alert")[1])
	rawset(self, "_lastCFrame", CFrame.new())
	rawset(self, "_lastRefreshData", {TopDonors = {}, Settings = table.clone(SettingsTemplate)})

	local Event do
		self.Changed:Connect(function(property, value)
			local list = {"Enabled", "Adornee"}

			if (table.find(list, property)) then
				self.SurfaceGui[property] = value
				return
			end

			if (property == "CurrentPage") then
				self.Topbar.Title.Text = value
				self.Topbar.Search.TextBox.Text = ""
				for _, page in {"List", "Analytics", "Donate", "Settings", "DeveloperProducts", "Theme"} do
					if (not self[page]) then continue end
					self[page].Enabled = page == value
				end	

				local showBack = value ~= "List"
				self.Navigation.Back = showBack
				self.Navigation.Save = value == "Settings"
				self.Navigation.Donate = not showBack
				self.Navigation.Analytics = not showBack
				self.Navigation.Settings = not showBack
				self.Topbar.Actions = self[self.CurrentPage].Actions
				return
			end
		end)

		self.Topbar.Body.Changed:Connect(function(property)
			if (property ~= "Size") then return end
			self.BoardSettings._changed:Fire("HideTopbar")
		end)
	end

	local Refresh do
		local Update = function(category: string, dict)
			local TopDonor, Settings = dict.TopDonors, dict.Settings :: typeof(SettingsTemplate)

			local Text = {
				[1] = {
					RBX = self.BoardSettings.UseRobuxIcon and `<font transparency="0" color='#{self.BoardSettings.RobuxColor:ToHex()}'>{utf8.char(0xE002)}</font> %s` or "%s Robux",
					Conversion = `<font color="#{self.BoardSettings.Rank1TextColor:ToHex()}"><stroke color="#{self.BoardSettings.Rank1TextColor:ToHex()}" transparency="0.8" thickness="1">%s</stroke></font>`,	
				},

				[2] = {
					RBX = self.BoardSettings.UseRobuxIcon and `<font transparency="0" color='#{self.BoardSettings.RobuxColor:ToHex()}'>{utf8.char(0xE002)}</font> %s` or "%s Robux",
					Conversion = `<font color="#{self.BoardSettings.Rank2TextColor:ToHex()}"><stroke color="#{self.BoardSettings.Rank2TextColor:ToHex()}" transparency="0.8" thickness="1">%s</stroke></font>`,	
				},

				[3] = {
					RBX = self.BoardSettings.UseRobuxIcon and `<font transparency="0" color='#{self.BoardSettings.RobuxColor:ToHex()}'>{utf8.char(0xE002)}</font> %s` or "%s Robux",
					Conversion = `<font color="#{self.BoardSettings.Rank3TextColor:ToHex()}"><stroke color="#{self.BoardSettings.Rank3TextColor:ToHex()}" transparency="0.8" thickness="1">%s</stroke></font>`,	
				},

				[4] = {
					RBX = self.BoardSettings.UseRobuxIcon and `<font transparency="0" color='#{self.BoardSettings.RobuxColor:ToHex()}'>{utf8.char(0xE002)}</font> %s` or "%s Robux",
					Conversion = `<font color="#{self.BoardSettings.TextColor:ToHex()}"><stroke color="#{self.BoardSettings.TextColor:ToHex()}" transparency="0.8" thickness="1">%s</stroke></font>`,	
				},

				["Donate"] = {
					RBX = self.BoardSettings.UseRobuxIcon and `<font transparency="0" color='#{self.BoardSettings.RobuxColor:ToHex()}'>{utf8.char(0xE002)}</font> %s` or `%s Robux`,
					Conversion = `<font color="#{self.BoardSettings.TextColor:ToHex()}"><stroke color="#{self.BoardSettings.TextColor:ToHex()}" transparency="0.8" thickness="1">%s</stroke></font>`,
				},
			}

			if (category == "List") then
				local userIds, _tempUserIds = {}, {}
				for _, dict in TopDonor do 
					if shared["_db/cache"][dict[2]] then 
						userIds[tostring(dict[2])] = shared["_db/cache"][dict[2]]
						continue
					end
					table.insert(_tempUserIds, dict[2]) 
				end

				if (_tempUserIds ~= {}) then
					for i, dict in game:GetService("UserService"):GetUserInfosByUserIdsAsync(_tempUserIds) do
						userIds[tostring(dict.Id)] = dict
					end
				end

				local total, list = 0, {};
				local currentIndex = 0;
				for index, data in TopDonor do
					currentIndex = index
					task.spawn(function()
						if (self.List.Body.ScrollingFrame:FindFirstChild(("0x%05x"):format(index))) then return end
						local function formatName()
							local hasDisplayName, hasUsername = self.BoardSettings.NamingScheme:lower():find("display") ~= nil, self.BoardSettings.NamingScheme:lower():find("username") ~= nil

							if (hasDisplayName and not hasUsername) then
								return userIds[tostring(data[2])]["DisplayName"]
							elseif (not hasDisplayName and hasUsername) then
								return userIds[tostring(data[2])]["Username"]
							end

							if not (userIds[tostring(data[2])]) then return "Player (@Banned)" end
							return `{userIds[tostring(data[2])]["DisplayName"]} (@{userIds[tostring(data[2])]["Username"]})`
						end

						list[index] = self.List:Generate(data[1] > 3 and 4 or data[1])
						list[index].Archivable = true
						list[index].Name = ("0x%05x"):format(index)
						list[index].LayoutOrder = index
						list[index].Rank.TextLabel.Text = list[index].Rank.TextLabel.Text:format(data[1])
						list[index].Thumbnail.ImageLabel.Image = `rbxthumb://type=AvatarHeadShot&id={tostring(data[2])}&w=420&h=420 true false`
						list[index].Player.Username.Text = formatName()
						list[index]:SetAttribute("RichText", Text[index > 4 and 4 or index].RBX)
						list[index]:SetAttribute("RichText2", Text[index > 4 and 4 or index].Conversion)
						list[index]:SetAttribute("Robux", data[3])
						list[index].Player.Robux.Text = `{list[index]:GetAttribute("RichText"):format(Util.Commaify(data[3]))}`
						total += data[3]
					end)
				end

				list[-1] = self.List:Generate(4)
				list[-1].Archivable = true
				list[-1].Name = ("0x%05x"):format(-1)
				list[-1].Visible = self.BoardSettings.DisplayTotal
				list[-1].LayoutOrder = -1
				list[-1].Rank.TextLabel.Text = "#"
				list[-1].Thumbnail.ImageLabel.Image = ""
				list[-1].Player.Username.Text = "Total"
				list[-1]:SetAttribute("RichText", Text[4].RBX)
				list[-1]:SetAttribute("RichText2", Text[4].Conversion)
				list[-1]:SetAttribute("Robux", total)
				list[-1].Player.Robux.Text = `{list[-1]:GetAttribute("RichText"):format(Util.Commaify(total))}`

				repeat task.wait() until currentIndex >= #TopDonor
				return list
			end

			if (category == "Donate") then
				local list = {}
				for i, id in Settings.DeveloperProducts do
					if self.Donate.Body.ScrollingFrame:FindFirstChild(id) then continue end
					id = tonumber(id)
					local info = game:GetService("MarketplaceService"):GetProductInfo(id, Enum.InfoType.Product)

					list[i] = self.Donate.Templates[1]()
					list[i].Archivable = true
					list[i].Name = id
					list[i].LayoutOrder = info.PriceInRobux or 0
					list[i]:SetAttribute("RichText", Text["Donate"].RBX)
					list[i]:SetAttribute("RichText2", Text["Donate"].Conversion)
					list[i]:SetAttribute("Robux", info.PriceInRobux)
					list[i].Text = list[i].Text:format(Util.Commaify(info.PriceInRobux))

					list[i].MouseButton1Click:Connect(function()
						self:PromptProductPurchase(id)
					end)

					list[i].MouseEnter:Connect(function()
						list[i].BackgroundColor3 = self.BoardSettings.Colors[1]
						list[i].BackgroundTransparency = 0
					end)

					list[i].MouseLeave:Connect(function()
						list[i].BackgroundColor3 = self.BoardSettings.BackdropColor
						list[i].BackgroundTransparency = 0.625
					end)
				end

				return list
			end
		end

		local cooldown = {false, false}
		self.RefreshBind.Event:Connect(function(specific: string)
			if (not self._lastRefreshData) then return end
			self._lastRefreshData.Settings = shared["_db/environment"].studiomode and self.BoardSettings or self._lastRefreshData.Settings
			if (not shared["_db/environment"].studiomode) then
				for key, value in self._lastRefreshData.Settings do
					self.BoardSettings[key] = value
				end
			end

			if (not specific or specific == "List") then
				if cooldown[1] then return end
				cooldown[1] = true
				local scrollPosition = self.List.Body.ScrollingFrame.CanvasPosition
				self.List:Clear()
				if (#self._lastRefreshData.TopDonors > 0) then
					repeat task.wait() until not self.List.Body.ScrollingFrame:FindFirstChildWhichIsA("CanvasGroup")
					local list = Update("List", self._lastRefreshData)
					for _, entry in list do
						entry.Parent = self.List.Body.ScrollingFrame
					end; self.List:Filter():Sort():Tax()
				end
				self.List.Body.ScrollingFrame.CanvasPosition = scrollPosition
				cooldown = {false, cooldown[2]}
			end

			if (not specific or specific == "Donate") then
				if cooldown[2] then return end
				cooldown[2] = true
				local scrollPosition = self.Donate.Body.ScrollingFrame.CanvasPosition
				self.Donate:Clear()
				if (#self._lastRefreshData.Settings.DeveloperProducts > 0) then
					repeat task.wait() until not self.List.Body.ScrollingFrame:FindFirstChildWhichIsA("TextButton")
					local list = Update("Donate", self._lastRefreshData)
					for _, button in list do
						button.Parent = self.Donate.Body.ScrollingFrame
					end; self.Donate:Filter():Sort():Tax()
				end
				self.Donate.Body.ScrollingFrame.CanvasPosition = scrollPosition
				cooldown = {cooldown[1], false}
			end

			if (LoadingScreen and #self._lastRefreshData.TopDonors > 0) then
				game:GetService("RunService"):UnbindFromRenderStep("_db/loadingbuffer")
				LoadingScreen.ZOffset = -1
				LoadingScreen:Destroy()
				LoadingScreen = nil
			end
			return
		end)

		self.RefreshEvent.OnClientEvent:Connect(function(data)
			if (data) then
				rawset(self, "_lastRefreshData", data)
				self.RefreshBar.Speed = data.Settings.RefreshRate
				self.RefreshBar:Lap()
				self.RefreshBind:Fire("List")
				self.RefreshBind:Fire("Donate")
				return
			end
		end)
	end

	local Navigation do
		--self.Navigation.Analytics = false
		for key, button in self.Navigation.Buttons do
			if (key == "Save") then continue end
			button.MouseButton1Click:Connect(function()
				local mustSave = false
				if (key == "Back" and self.CurrentPage == "DeveloperProducts") then
					mustSave = true
				end

				if (key == "Back" and self.CurrentPage == "Settings") then
					self.PreviousPage = "List"
				elseif (key ~= "Back") then
					self.PreviousPage = self.CurrentPage
				end

				self.CurrentPage = key == "Back" and self.PreviousPage or key
				if (mustSave) then
					self.Navigation.Buttons.Save.TextLabel.Text = "Saving"
					self.Navigation.Buttons.Save.BackgroundColor3 = Color3.new(0.278431, 0.278431, 0.278431)
					Render:_saveSettings(self.BoardSettings:GetValues())
					self.Navigation.Buttons.Save.TextLabel.Text = "Saved"
					task.wait(1)
					self.Navigation.Buttons.Save.TextLabel.Text = "Save"
					self.Navigation.Buttons.Save.BackgroundColor3 = Color3.new(1, 1, 1)
					self.RefreshBind:Fire("Donate")
				end
			end)
		end
	end

	local Alerts do
		if not _G["alertsinitiated"] then 
			_G["alertsinitiated"] = true
			self.AlertEvent.OnClientEvent:Connect(function(type, message)
				if (type:lower() == "chat") then
					self.Alert:SendMessage(message)
					return
				end
			end)
		end
	end

	local Topbar do
		self.Topbar.Conversion.MouseButton1Click:Connect(function()
			self.Conversion = not self.Conversion
		end)

		self.Topbar.Tax.MouseButton1Click:Connect(function()
			self.Tax = not self.Tax
		end)

		self.Topbar.SortOrder.MouseButton1Click:Connect(function()
			self.SortOrder = self.SortOrder == "Numeric" and "Alphabetical" or "Numeric"
		end)

		self.Topbar.SortDirection.MouseButton1Click:Connect(function()
			self.SortDirection = self.SortDirection == "Ascending" and "Descending" or "Ascending"
		end)

		self.Topbar.Fullscreen.MouseButton1Click:Connect(function()
			self.Fullscreen = not self.Fullscreen
		end)

		local connection;
		self.Changed:Connect(function(property, value)
			if (property == "Fullscreen") then
				self.Topbar.Fullscreen.ImageLabel.ImageRectOffset = Vector2.new(value and 222 or 185, 0)
				self.Topbar.Fullscreen.ImageLabel.UIGradient.Enabled = value
				self.Topbar.Fullscreen.BackgroundTransparency = value and 0.8 or 0

				if (value) then
					if (workspace.CurrentCamera.CameraType == Enum.CameraType.Scriptable) then return end
					self._lastCFrame = workspace.CurrentCamera.CFrame
					if (connection) then connection:Disconnect() end
					connection = game:GetService("RunService").RenderStepped:Connect(function()
						workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
						workspace.CurrentCamera.CFrame = self.Adornee.Attachment.WorldCFrame
						pcall(function()
							game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = 0
							if (game:GetService("Players").LocalPlayer.Character.Humanoid.UseJumpPower) then
								game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = 0
								return
							end
							game:GetService("Players").LocalPlayer.Character.Humanoid.JumpHeight = 0
						end)
					end)
					return
				end

				if (connection) then connection:Disconnect(); connection = nil end
				if (workspace.CurrentCamera.CameraType == Enum.CameraType.Custom) then return end
				workspace.CurrentCamera.CFrame = self._lastCFrame or workspace.CurrentCamera.CFrame
				workspace.CurrentCamera.CameraType = Enum.CameraType.Custom 
				pcall(function()
					game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = game:GetService("StarterPlayer").CharacterWalkSpeed
					if (game:GetService("Players").LocalPlayer.Character.Humanoid.UseJumpPower) then
						game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = game:GetService("StarterPlayer").CharacterJumpPower
						return
					end
					game:GetService("Players").LocalPlayer.Character.Humanoid.JumpHeight = game:GetService("StarterPlayer").CharacterJumpHeight
				end)
			end

			if (property == "Tax") then
				self.List.Taxed = value
				self.Donate.Taxed = value
				self.Topbar.Tax.ImageLabel.UIGradient.Enabled = value
				self.Topbar.Tax.BackgroundTransparency = value and 0.8 or 0
			end

			if (property == "SortOrder") then
				self.List.SortOrder = value
				self.Topbar.SortOrder.ImageLabel.ImageRectOffset = Vector2.new(value == "Numeric" and 148 or 185, 37)
				self.Topbar.SortOrder.ImageLabel.UIGradient.Enabled = value == "Alphabetical"
				self.Topbar.SortOrder.BackgroundTransparency = value == "Alphabetical" and 0.8 or 0
			end

			if (property == "SortDirection") then
				self.List.SortDirection = value
				self.Donate.SortDirection = value
				self.Topbar.SortDirection.ImageLabel.ImageRectOffset = Vector2.new(value == "Descending" and 333 or 370, 0)
				self.Topbar.SortDirection.ImageLabel.UIGradient.Enabled = value == "Descending"
				self.Topbar.SortDirection.BackgroundTransparency = value == "Descending" and 0.8 or 0
			end

			if (property == "Conversion") then
				self.List.Conversion = value
				self.Donate.Conversion = value
				self.Topbar.Conversion.ImageLabel.UIGradient.Enabled = value
				self.Topbar.Conversion.BackgroundTransparency = value and 0.8 or 0
			end

			if (property == "Keyword") then
				self.List.Keyword = self.Keyword
				self.Donate.Keyword = self.Keyword
				self.Settings.Keyword = self.Keyword
				self.DeveloperProducts.Keyword = self.Keyword
				self.Theme.Keyword = self.Keyword
			end
		end)

		self.Topbar.Search.TextBox.Changed:Connect(function(property)
			if (property ~= "Text") then return end
			self.Keyword = self.Topbar.Search.TextBox.Text
		end)
	end

	local Pattern do
		local TileSize = self.Canvas.Background.ImageLabel.TileSize.X.Offset
		local Elapsed = 0

		self._maid:GiveTask(game:GetService("RunService").RenderStepped:Connect(function(dt)
			Elapsed += dt
			local Offset = -((Elapsed * (TileSize * self.PatternSpeed) ) % TileSize)
			self.Canvas.Background.ImageLabel.Position = UDim2.new(0, Offset, 0.5, 0)
		end))
	end

	local ScrollBarUpdates do
		for _, page in {self.Analytics, self.DeveloperProducts, self.Donate, self.List, self.Settings, self.Theme} do
			local function _update()
				if (not page) then return end
				if (not page.Body) then return end
				if (not page.Body:FindFirstChild("Frame")) then return end
				if (not page.Body:FindFirstChild("ScrollingFrame")) then return end
				page.Body.Frame.Visible = (page.Body.ScrollingFrame.AbsoluteCanvasSize.Y > page.Body.ScrollingFrame.AbsoluteWindowSize.Y)
			end

			page.Body.ScrollingFrame.ChildAdded:Connect(_update)
			page.Body.ScrollingFrame.ChildRemoved:Connect(_update)
		end
	end

	local SettingsProperties do
		local currencyRates = {}; for name, _ in Rates do table.insert(currencyRates, name) end 
		local fonts = {}; for name, _ in Fonts do table.insert(fonts, name) end

		SettingsProperties = {
			DeveloperProducts = self.Settings:Generate "Redirect" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Developer Products",
				Description = "Edit the Developer Products used by the board.",
				Options = {{"Edit Developer Products", Vector2.new(259, 37)}, {"Test", Vector2.new(259, 37)}}
			},

			ProcessReceiptPriority = self.Settings:Generate "Radio" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "ProcessReceipt Priority",
				Description = "What's the board's priority for ProcessReceipt?",
				Options = {"Lowest", "Neutral", "Highest"},
				Value = self.BoardSettings.ProcessReceiptPriority,
			},

			DirectLink = self.Settings:Generate "Checkbox" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Direct Link",
				Description = "Forces the board to be the only ProcessReceipt.",
				Value = self.BoardSettings.DirectLink,
			},

			SafeMode = self.Settings:Generate "Checkbox" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Safe Mode",
				Description = "Block transactions outside of Roblox Studio.",
				Value = self.BoardSettings.SafeMode,
			},

			Theme = self.Settings:Generate "Redirect" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Theme",
				Description = "The color scheme of the board.",
				Options = {{"Preview"}, {"Edit", Vector2.new(259, 37)}}
			},

			Background = self.Settings:Generate "Checkbox" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Background",
				Description = "Display the background pattern.",
				Value = self.BoardSettings.Background,
			},

			BackgroundColor = self.Settings:Generate "Slider" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Background Darkener",
				Description = "Adjust how dark the background is.",
				Value = self.BoardSettings.BackgroundColor, Min = 0, Max = 1,
			},

			PatternId = self.Settings:Generate "Textbox" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Pattern Texture Id",
				Description = "Texture used for the pattern.",
				Placeholder = "rbxassetid://0",
				Value = self.BoardSettings.PatternId
			},

			Brightness = self.Settings:Generate "Slider" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Brightness",
				Description = "How much light the board emits.",
				Value = self.BoardSettings.Brightness, Min = 0.1, Max = 2,
			},

			LightInfluence = self.Settings:Generate "Slider" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "LightInfluence",
				Description = "How much light influences the board.",
				Value = self.BoardSettings.LightInfluence, Min = 0, Max = 2,
			},

			Transparency = self.Settings:Generate "Slider" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Transparency",
				Description = "Change the transparency of the board.",
				Value = self.BoardSettings.Transparency, Min = 0, Max = 1
			},

			Rotation = self.Settings:Generate "Slider" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Rotation",
				Description = "Rotation of the gradient.",
				Value = self.BoardSettings.Rotation, Min = 0, Max = 360,
				Floored = true,
			},

			HideOutline = self.Settings:Generate "Checkbox" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Hide Outline",
				Description = `Remove the outline surrounding the board.`,
				Value = self.BoardSettings.HideOutline,
			},

			HideTopbar = self.Settings:Generate "Checkbox" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Hide Topbar",
				Description = `Remove the topbar and action buttons.`,
				Value = self.BoardSettings.HideTopbar,
			},

			HideRefreshbar = self.Settings:Generate "Checkbox" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Hide Refreshbar",
				Description = `Remove the refresh bar.`,
				Value = self.BoardSettings.HideRefreshbar,
			},

			HideSearch = self.Settings:Generate "Checkbox" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Hide Search",
				Description = `Remove the search bar.`,
				Value = self.BoardSettings.HideSearch,
			},

			AlwaysOnTop = self.Settings:Generate "Checkbox" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Always On Top",
				Description = `Display the board's GUI above everything.`,
				Value = self.BoardSettings.AlwaysOnTop,
			},

			SizingMode = self.Settings:Generate "Radio" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Sizing Mode",
				Description = "How the board reacts to different sizes.",
				Options = {"FixedSize", "PixelsPerStud"},
				Value = self.BoardSettings.SizingMode,
			},

			Font = self.Settings:Generate "Radio" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Font",
				Description = "The font used by the board.",
				Options = fonts,
				Value = self.BoardSettings.Font,
			},

			UseRobuxIcon = self.Settings:Generate "Checkbox" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Use Robux Icon",
				Description = `Use <font color='#ffb46a' transparency='0'>{utf8.char(0xE002)}</font> instead of Robux`,
				Value = self.BoardSettings.UseRobuxIcon,
			},

			Particles = self.Settings:Generate "Checkbox" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Particles",
				Description = "Display particles for each donation.",
				Value = self.BoardSettings.Particles,
			},

			Tax = self.Settings:Generate "Radio" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Tax",
				Description = "Change the default state of the tax toggle.",
				Options = {"Disabled", "On", "Off"},
				Value = self.BoardSettings.Tax,
			},

			SortOrder = self.Settings:Generate "Radio" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "SortOrder",
				Description = "Change the method used to sort list.",
				Options = {"Disabled", "Alphabetical", "Numeric"},
				Value = self.BoardSettings.SortOrder,
			},

			SortDirection = self.Settings:Generate "Radio" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "SortDirection",
				Description = "Change the default state of the sort direction toggle.",
				Options = {"Disabled", "Ascending", "Descending"},
				Value = self.BoardSettings.SortDirection,
			},

			DevExRate = self.Settings:Generate "Radio" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "DevEx Rate",
				Description = "Change the default state of the conversion toggle.",
				Options = {"Disabled", "On", "Off"},
				Value = self.BoardSettings.DevExRate,
			},

			DevExCurrency = self.Settings:Generate "Radio" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "DevEx Currency",
				Description = "Which currency the DevEx Rate converts to.",
				Options = currencyRates,
				Value = self.BoardSettings.DevExCurrency,
			},

			DisplayTotal = self.Settings:Generate "Checkbox" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Display Total",
				Description = "Display the total amount of donations.",
				Value = self.BoardSettings.DisplayTotal
			},

			NamingScheme = self.Settings:Generate "Radio" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Naming Scheme",
				Description = "How player names are shown.",
				Options = {"DisplayName", "Username", "Display (@Username)"},
				Value = self.BoardSettings.NamingScheme,
			},

			DonorLayout = self.Settings:Generate "Radio" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Donor Layout",
				Description = "How donor entries are displayed.",
				Options = {"1", "2", "3", "4", "5"},
				Value = tostring(self.BoardSettings.DonorLayout),
			},

			DisplayOverhead = self.Settings:Generate "Checkbox" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Display Overhead",
				Description = "Display an overhead for all rigs.",
				Value = self.BoardSettings.DisplayOverhead
			},

			DonorCount = self.Settings:Generate "Textbox" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Donor Count",
				Description = "How many donors are displayed on the list.",
				Placeholder = "0 - 999",
				Value = self.BoardSettings.DonorCount
			},

			RefreshRate = self.Settings:Generate "TextBox" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Refresh Rate",
				Description = "How many seconds it takes to refresh the board.",
				Placeholder = "In Seconds",
				Value = self.BoardSettings.RefreshRate
			},

			FullscreenEnabled = self.Settings:Generate "Checkbox" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Fullscreen Enabled",
				Description = "Whether users are able to use Fullscreen mode.",
				Value = self.BoardSettings.FullscreenEnabled
			},

			DonateMessage = self.Settings:Generate "TextBox" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Donate Message",
				Description = "A message that appears in chat after a donation.",
				Placeholder = "{player} = username / {robux} = amount",
				Value = self.BoardSettings.DonateMessage
			},

			ResetSettings = self.Settings:Generate "Redirect" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Reset Settings",
				Description = "Resets all settings to their default state.",
				Options = {"Reset"}
			},

			ResetDonors = self.Settings:Generate "Redirect" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Reset Donors",
				Description = "Resets all current donations to 0.",
				Options = {"Reset"}
			},

			Import = self.Settings:Generate "Redirect" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Import Settings",
				Description = "Import settings from json.",
				Options = {"Import"}
			},

			Export = self.Settings:Generate "Redirect" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "Export Settings",
				Description = "Export settings to json.",
				Options = {"Export"}
			},

			UserData = self.Settings:Generate "Redirect" {
				Parent = self.Settings.Body.ScrollingFrame,
				Title = "UserData",
				Description = "Adjust or remove a donor's donation.",
				Options = {"Add", "Subtract", "Set", "Remove"}
			},
		}

		local Rates do
			SettingsProperties.DevExCurrency.Content.UIListLayout.Wraps = true
			for key, button in SettingsProperties.DevExCurrency.Options do
				button.Size = UDim2.fromOffset(0, 40)
				button.AutomaticSize = Enum.AutomaticSize.X
			end
		end

		local Fonts do
			SettingsProperties.Font.Content.UIListLayout.Wraps = true
			for key, button in SettingsProperties.Font.Options do
				button.Size = UDim2.fromOffset(0, 40)
				button.AutomaticSize = Enum.AutomaticSize.X
				Fusion:New "UIPadding" {
					Parent = button,
					PaddingRight = UDim.new(0, 5),
					PaddingLeft = UDim.new(0, 5),
				}
			end
		end

		local Edit do
			Edit = SettingsProperties.Theme.Edit
			Edit.Size = UDim2.fromOffset(150, 40)
			SettingsProperties.Theme.Triggered:Connect(function(button)
				if (button ~= "Edit") then return end
				self.PreviousPage = "Settings"
				self.CurrentPage = "Theme"
			end)
		end

		local Preview do
			Preview = SettingsProperties.Theme.Preview
			Preview.TextLabel.Text = ""
			Preview.BackgroundTransparency = 0
			Preview.UIGradient.Rotation = 90 + self.BoardSettings.Rotation
			Preview.UIStroke.UIGradient.Rotation = 90 + self.BoardSettings.Rotation
			Preview.UIGradient:SetAttribute("Rotation", 90)
			Preview.UIStroke.UIGradient:SetAttribute("Rotation", 90)
		end

		local DonorLayout do
			DonorLayout = SettingsProperties.DonorLayout
			DonorLayout.Content.UIListLayout.FillDirection = Enum.FillDirection.Vertical
			for key, button in DonorLayout.Options do
				button.TextLabel.Visible = false

				local _temp = self.List.Templates[tonumber(key)]()
				button.Size = _temp.Size
				_temp.Parent = button
				_temp.BackgroundTransparency = 1
				_temp.Thumbnail.BackgroundTransparency = 1
				_temp.Player.BackgroundTransparency = 1
				_temp.Rank.BackgroundTransparency = 1
				_temp.Size = UDim2.fromScale(1, 1)
				_temp.Rank.TextLabel.Text = "#"
				_temp.Player.Robux.Text = `<font color='#{self.BoardSettings.RobuxColor:ToHex()}' transparency='0'></font> 0`
				_temp.Frame:Destroy()
			end
		end

		local ResetSettings do
			ResetSettings = SettingsProperties.ResetSettings
			ResetSettings.Reset.TextLabel:RemoveTag("donationboard@textcolor")
			ResetSettings.Reset.UIGradient:RemoveTag("donationboard@colors123")
			ResetSettings.Reset.UIStroke.UIGradient:RemoveTag("donationboard@colors123")
			ResetSettings.Reset.ImageLabel:RemoveTag("donationboard@iconcolor")
			ResetSettings.Reset.TextLabel.TextColor3 = Color3.new(1, 1, 1)
			ResetSettings.Reset.UIGradient.Color = ColorSequence.new(Color3.new(1, 0, 0), Color3.new(0.6, 0, 0))
			ResetSettings.Reset.UIStroke.UIGradient.Color = ColorSequence.new(Color3.new(1, 0, 0), Color3.new(0.6, 0, 0))
			ResetSettings.Reset.ImageLabel.ImageColor3 = Color3.new(1, 1, 1)
			ResetSettings.Triggered:Connect(function(button)
				if (button ~= "Reset") then return end
				for property, value in SettingsTemplate do
					self.BoardSettings[property] = value
				end
				self.Navigation.Buttons.Save.TextLabel.Text = "Saving"
				self.Navigation.Buttons.Save.BackgroundColor3 = Color3.new(0.278431, 0.278431, 0.278431)
				Render:_saveSettings(self.BoardSettings:GetValues())
				self.Navigation.Buttons.Save.TextLabel.Text = "Saved"
				self.BoardSettings._changed:Fire("Theme")
				self.RefreshBind:Fire("import")
				task.wait(1)
				self.Navigation.Buttons.Save.TextLabel.Text = "Save"
				self.Navigation.Buttons.Save.BackgroundColor3 = Color3.new(1, 1, 1)
			end)
		end

		local ResetDonors do
			ResetDonors = SettingsProperties.ResetDonors
			ResetDonors.Reset.TextLabel:RemoveTag("donationboard@textcolor")
			ResetDonors.Reset.UIGradient:RemoveTag("donationboard@colors123")
			ResetDonors.Reset.UIStroke.UIGradient:RemoveTag("donationboard@colors123")
			ResetDonors.Reset.ImageLabel:RemoveTag("donationboard@iconcolor")
			ResetDonors.Reset.TextLabel.TextColor3 = Color3.new(1, 1, 1)
			ResetDonors.Reset.UIGradient.Color = ColorSequence.new(Color3.new(1, 0, 0), Color3.new(0.6, 0, 0))
			ResetDonors.Reset.UIStroke.UIGradient.Color = ColorSequence.new(Color3.new(1, 0, 0), Color3.new(0.6, 0, 0))
			ResetDonors.Reset.ImageLabel.ImageColor3 = Color3.new(1, 1, 1)
			ResetDonors.Triggered:Connect(function(button)
				if (button ~= "Reset") then return end
				Render:_resetDonors()
			end)
		end

		local Import do
			Import = SettingsProperties.Import
			local TextBox = self.Settings.Templates.textbox()
			TextBox.Parent, TextBox.LayoutOrder = Import.Content, 0
			Import.Buttons.Import.UIFlexItem.Parent, Import.Buttons.Import.UIPadding.PaddingRight = TextBox, UDim.new(0, 20)
			TextBox.TextBox.Text, TextBox.TextBox.PlaceholderText = "", `Paste your json and click "import".`
			Import.Buttons.Import.AutomaticSize, Import.Buttons.Import.Size = Enum.AutomaticSize.X, UDim2.fromOffset(0, 40)
			Import.Triggered:Connect(function(button)
				if (button ~= "Import") then return end
				local data = Render:_requestJSONDecode(TextBox.TextBox.Text)
				for key, value in data do
					pcall(function()
						if (value == nil or typeof(self.BoardSettings[key]) ~= typeof(value)) then error("Invalid Value Type") end
						if (key == "DeveloperProducts") then return end
						self.BoardSettings[key] = value
					end)
				end
				self.Navigation.Buttons.Save.TextLabel.Text = "Saving"
				self.Navigation.Buttons.Save.BackgroundColor3 = Color3.new(0.278431, 0.278431, 0.278431)
				Render:_saveSettings(self.BoardSettings:GetValues())
				self.BoardSettings._changed:Fire("Theme")
				self.Navigation.Buttons.Save.TextLabel.Text = "Saved"
				self.RefreshBind:Fire("import")
				task.wait(1)
				self.Navigation.Buttons.Save.TextLabel.Text = "Save"
				self.Navigation.Buttons.Save.BackgroundColor3 = Color3.new(1, 1, 1)
			end)
		end

		local Export do
			Export = SettingsProperties.Export
			local TextBox = self.Settings.Templates.textbox()
			TextBox.Parent, TextBox.LayoutOrder = Export.Content, 0
			Export.Buttons.Export.UIFlexItem.Parent, Export.Buttons.Export.UIPadding.PaddingRight = TextBox, UDim.new(0, 20)
			TextBox.TextBox.TextEditable = false
			TextBox.TextBox.Text, TextBox.TextBox.PlaceholderText = "", `Click "export" and copy text in this box.`
			Export.Buttons.Export.AutomaticSize, Export.Buttons.Export.Size = Enum.AutomaticSize.X, UDim2.fromOffset(0, 40)
			Export.Triggered:Connect(function(button)
				if (button ~= "Export") then return end
				local data = self.BoardSettings:GetValues()
				data.DeveloperProducts = {}
				data = Render:_requestJSONEncode(data)
				TextBox.TextBox.Text = data
			end)
		end

		local UserData do
			UserData = SettingsProperties.UserData
			local Username, Amount, Add, Subtract, Set, Remove = nil, nil,
			UserData.Buttons["Add"],
			UserData.Buttons["Subtract"],
			UserData.Buttons["Set"],
			UserData.Buttons["Remove"]

			Username = self.Settings.Templates.textbox()
			Username.Parent, Username.LayoutOrder =  UserData.Content, 5
			Username.TextBox.Text, Username.TextBox.PlaceholderText = "", "Enter Username"

			Amount = self.Settings.Templates.textbox()
			Amount.Parent, Amount.LayoutOrder =  UserData.Content, 5
			Amount.TextBox.Text, Amount.TextBox.PlaceholderText = "", "0"
			Amount.Size = UDim2.fromOffset(0, 40)
			UserData.Content.UIListLayout.Wraps = true
			Fusion:New "UIFlexItem" {
				Parent = Amount,
				FlexMode = Enum.UIFlexMode.Fill,
			}

			for index, button in {Add, Subtract, Set, Remove} do
				button.AutomaticSize = Enum.AutomaticSize.None
				button.Size = UDim2.new(0, 0, 0, 40)
				button.UIPadding:Destroy()
				button.TextLabel.Size = UDim2.fromScale(1, 1)
				button.TextLabel.TextXAlignment = Enum.TextXAlignment.Center
				button.LayoutOrder = index
			end

			local isBusy = false
			UserData.Triggered:Connect(function(button)
				if isBusy then return end
				local userId = game:GetService("Players"):GetUserIdFromNameAsync(Username.TextBox.Text)
				if not userId then return end

				local amount = tonumber(Amount.TextBox.Text == "" and "0" or Amount.TextBox.Text)
				if not amount then return end

				if (button == "Add") then
					isBusy = true
					Render:_setDonor(userId, "add", amount)
					isBusy = false
					return
				end

				if (button == "Subtract") then
					isBusy = true
					Render:_setDonor(userId, "subtract", amount)
					isBusy = false
					return
				end

				if (button == "Set") then
					isBusy = true
					Render:_setDonor(userId, "set", amount)
					isBusy = false
					return
				end

				if (button == "Remove") then
					isBusy = true
					Render:_setDonor(userId, "remove")
					isBusy = false
					return
				end
			end)
		end

		for key, class in SettingsProperties do
			if not (class.ValueChanged) then continue end			
			class.ValueChanged:Connect(function()
				if (class.Value == nil) then return end
				if (key == "DonorLayout") then self.BoardSettings[key] = tonumber(class.Value) return end 
				self.BoardSettings[key] = class.Value				
			end)
		end

		self.Navigation.Buttons.Save.MouseButton1Click:Connect(function()
			if (self.CurrentPage ~= "Settings") then return end
			if (self.Navigation.Buttons.Save.TextLabel.Text ~= "Save") then return end
			self.Navigation.Buttons.Save.TextLabel.Text = "Saving"
			self.Navigation.Buttons.Save.BackgroundColor3 = Color3.new(0.278431, 0.278431, 0.278431)
			Render:_saveSettings(self.BoardSettings:GetValues())
			self.Navigation.Buttons.Save.TextLabel.Text = "Saved"
			task.wait(1)
			self.Navigation.Buttons.Save.TextLabel.Text = "Save"
			self.Navigation.Buttons.Save.BackgroundColor3 = Color3.new(1, 1, 1)
		end)
	end

	local ProductProperties do
		SettingsProperties.DeveloperProducts.Test.Size = UDim2.fromOffset(125, 40)
		SettingsProperties.DeveloperProducts.Triggered:Connect(function(button)
			if (button == "Test") then
				self:PromptProductPurchase(1651970492, true)
				return
			end

			self.PreviousPage = "Settings"
			self.CurrentPage = "DeveloperProducts"
		end)

		local DeveloperProducts, Bulk = table.unpack(Util.PagesToTable(game:GetService("MarketplaceService"):GetDeveloperProductsAsync())), false
		table.sort(DeveloperProducts, function(a, b) return tonumber(a.PriceInRobux) < tonumber(b.PriceInRobux) end)

		self.DeveloperProducts:Clear(); do			
			local All = self.DeveloperProducts:Generate "All" {
				Parent = self.DeveloperProducts.Body.ScrollingFrame,
				Title = "All",
				Description = "Change all products at once.",
				Value = false,
			}
			
			All.Triggered:Connect(function()
				Bulk = true
				local newValue = #self.BoardSettings.DeveloperProducts/#DeveloperProducts ~= 1
				for id, product in ProductProperties do
					ProductProperties[id].Value = newValue
				end
				All.Value = newValue
				Bulk = false
				self.RefreshBind:Fire("Donate")
			end)

			ProductProperties = {}; for _, product in DeveloperProducts do
				ProductProperties[product.ProductId] = self.DeveloperProducts:Generate "Product" {
					Parent = self.DeveloperProducts.Body.ScrollingFrame,
					Title = product.Name,
					Description = (`<font color='#{self.BoardSettings.RobuxColor:ToHex()}'>{utf8.char(0xE002)}</font> %s`):format(Util.Commaify(product.PriceInRobux)),
					Value = table.find(self.BoardSettings.DeveloperProducts, product.ProductId) ~= nil,
				}

				ProductProperties[product.ProductId].ValueChanged:Connect(function(value)
					if (ProductProperties[product.ProductId].Value and not table.find(self.BoardSettings.DeveloperProducts, product.ProductId)) then
						table.insert(self.BoardSettings.DeveloperProducts, product.ProductId)
					elseif (not ProductProperties[product.ProductId].Value and table.find(self.BoardSettings.DeveloperProducts, product.ProductId)) then
						table.remove(self.BoardSettings.DeveloperProducts, table.find(self.BoardSettings.DeveloperProducts, product.ProductId))
					end
					
					if (Bulk) then return end
					All.Value = #self.BoardSettings.DeveloperProducts/#DeveloperProducts == 1
				end)
			end

			All.Value = #self.BoardSettings.DeveloperProducts/#DeveloperProducts == 1
		end; self.DeveloperProducts:Filter()

	end	

	local ThemeProperties do
		local SelectedColor = 1
		local Presets = {}; for name, _ in pairs(Themes) do table.insert(Presets, name) end

		ThemeProperties = {
			Presets = self.Theme:Generate "Radio" {
				Parent = self.Theme.Body.ScrollingFrame,
				Title = "Presets",
				Description = "Choose pre-made themes.",
				Options = Presets,
				Value = "",
			},

			Colors = self.Theme:Generate "Gradient" {
				Parent = self.Theme.Body.ScrollingFrame,
				Title = "Colors",
				Description = "The gradient that colors the board.",
				Color1 = self.BoardSettings.Colors[1],
				Color2 = self.BoardSettings.Colors[2],
				Color3 = self.BoardSettings.Colors[3],
			},

			SelectColor = self.Theme:Generate "Color" {
				Parent = self.Theme.Body.ScrollingFrame,
				Title = "",
				Description = "",
				Color = self.BoardSettings.Colors[1],
			},

			Rank1Color = self.Theme:Generate "Color" {
				Parent = self.Theme.Body.ScrollingFrame,
				Title = "Rank #1 Color",
				Description = "Choose a color for rank #1.",
				Color = self.BoardSettings.Rank1Color,
			},

			Rank1TextColor = self.Theme:Generate "Color" {
				Parent = self.Theme.Body.ScrollingFrame,
				Title = "Rank #1 Text Color",
				Description = "Choose a color for the text of rank #1.",
				Color = self.BoardSettings.Rank1TextColor,
			},

			Rank1Transparency = self.Theme:Generate "Slider" {
				Parent = self.Theme.Body.ScrollingFrame,
				Title = "Rank #1 Transparency",
				Description = "Choose a transparency for rank #1.",
				Value = self.BoardSettings.Rank1Transparency, Min = 0, Max = 1,
			},

			Rank2Color = self.Theme:Generate "Color" {
				Parent = self.Theme.Body.ScrollingFrame,
				Title = "Rank #2 Color",
				Description = "Choose a color for rank #2.",
				Color = self.BoardSettings.Rank2Color,
			},

			Rank2TextColor = self.Theme:Generate "Color" {
				Parent = self.Theme.Body.ScrollingFrame,
				Title = "Rank #2 Text Color",
				Description = "Choose a color for the text of rank #2.",
				Color = self.BoardSettings.Rank2TextColor,
			},

			Rank2Transparency = self.Theme:Generate "Slider" {
				Parent = self.Theme.Body.ScrollingFrame,
				Title = "Rank #2 Transparency",
				Description = "Choose a transparency for rank #2.",
				Value = self.BoardSettings.Rank2Transparency, Min = 0, Max = 1,
			},

			Rank3Color = self.Theme:Generate "Color" {
				Parent = self.Theme.Body.ScrollingFrame,
				Title = "Rank #3 Color",
				Description = "Choose a color for rank #3.",
				Color = self.BoardSettings.Rank3Color,
			},

			Rank3TextColor = self.Theme:Generate "Color" {
				Parent = self.Theme.Body.ScrollingFrame,
				Title = "Rank #3 Text Color",
				Description = "Choose a color for the text of rank #3.",
				Color = self.BoardSettings.Rank3TextColor,
			},

			Rank3Transparency = self.Theme:Generate "Slider" {
				Parent = self.Theme.Body.ScrollingFrame,
				Title = "Rank #3 Transparency",
				Description = "Choose a transparency for rank #3.",
				Value = self.BoardSettings.Rank3Transparency, Min = 0, Max = 1,
			},

			TitleColor = self.Theme:Generate "Color" {
				Parent = self.Theme.Body.ScrollingFrame,
				Title = "Title Color",
				Description = "Choose a color for the title of pages.",
				Color = self.BoardSettings.TitleColor,
			},

			BackdropColor = self.Theme:Generate "Color" {
				Parent = self.Theme.Body.ScrollingFrame,
				Title = "Backdrop Color",
				Description = "Choose a color for backdrops.",
				Color = self.BoardSettings.BackdropColor,
			},

			BackdropTransparency = self.Theme:Generate "Slider" {
				Parent = self.Theme.Body.ScrollingFrame,
				Title = "Backdrop Transparency",
				Description = "Change the transparency of backdrops.",
				Value = self.BoardSettings.BackdropTransparency, Min = 0, Max = 1,
			},

			TintColor = self.Theme:Generate "Color" {
				Parent = self.Theme.Body.ScrollingFrame,
				Title = "Tint Color",
				Description = "Choose a color to tint everything.",
				Color = self.BoardSettings.TintColor,
			},

			RobuxColor = self.Theme:Generate "Color" {
				Parent = self.Theme.Body.ScrollingFrame,
				Title = "Robux Color",
				Description = "The color of Robux icons",
				Color = self.BoardSettings.RobuxColor
			},	

			TextColor = self.Theme:Generate "Color" {
				Parent = self.Theme.Body.ScrollingFrame,
				Title = "Text Color",
				Description = "Choose a color for text.",
				Color = self.BoardSettings.TextColor,
			},

			IconColor = self.Theme:Generate "Color" {
				Parent = self.Theme.Body.ScrollingFrame,
				Title = "Icon Color",
				Description = "Choose a color for icons.",
				Color = self.BoardSettings.IconColor,
			},
		}

		ThemeProperties.Presets.Content.UIListLayout.Wraps = true
		ThemeProperties.Presets.ValueChanged:Connect(function(themeName)
			if not (Themes[themeName]) then return end
			local data = Render:_requestJSONDecode(Themes[themeName])
			for key, value in data or {} do
				pcall(function()
					if (value == nil or typeof(self.BoardSettings[key]) ~= typeof(value)) then error("Invalid Value Type") end
					if (key == "DeveloperProducts") then return end
					self.BoardSettings[key] = value
				end)
			end
			self.BoardSettings._changed:Fire("Theme")
			self.RefreshBind:Fire("import")
		end)

		for _, button in ThemeProperties.Presets.Options do
			if (button.TextLabel.Text == "Default") then button.LayoutOrder = -1 end
			button.Size = UDim2.new(0.25, 0, 0, 40)
			button.AutomaticSize = Enum.AutomaticSize.None
		end

		ThemeProperties.SelectColor.Body.Left.Title.Visible = false
		ThemeProperties.SelectColor.Body.Left.Description.Visible = false
		ThemeProperties.SelectColor.ColorChanged:Connect(function(color)
			self.BoardSettings.Colors[SelectedColor] = color
			ThemeProperties.Colors[`Color{SelectedColor}`] = color
			self.BoardSettings._changed:Fire("Colors")
		end)

		ThemeProperties.Colors.Body.Left.Content.Frame.Color1.MouseButton1Click:Connect(function() SelectedColor = 1; ThemeProperties.SelectColor.Color = ThemeProperties.Colors[`Color{SelectedColor}`] end)
		ThemeProperties.Colors.Body.Left.Content.Frame.Color2.MouseButton1Click:Connect(function() SelectedColor = 2; ThemeProperties.SelectColor.Color = ThemeProperties.Colors[`Color{SelectedColor}`] end)
		ThemeProperties.Colors.Body.Left.Content.Frame.Color3.MouseButton1Click:Connect(function() SelectedColor = 3; ThemeProperties.SelectColor.Color = ThemeProperties.Colors[`Color{SelectedColor}`] end)

		for key, class in ThemeProperties do
			if table.find({"Colors", "SelectColor", "Presets"}, key) then continue end
			if (class.ValueChanged) then
				class.ValueChanged:Connect(function()
					if (class.Value == nil) then return end
					self.BoardSettings[key] = class.Value
				end)
			elseif (class.ColorChanged) then
				class.ColorChanged:Connect(function()
					if (class.Color == nil) then return end
					self.BoardSettings[key] = class.Color
				end)
			end
		end

		self.RefreshBind.Event:Connect(function(specific: string)
			if (not specific or specific:lower() ~= "import") then return end
			
			for key, class in SettingsProperties do
				if not (class.ValueChanged) then continue end			
				if (class.Value == nil) then continue end
				SettingsProperties[key].Value = (key == "DonorLayout") and tostring(self.BoardSettings[key]) or self.BoardSettings[key]
			end

			for key, class in ProductProperties do
				if (key == "All") then continue end
				ProductProperties[key].Value = table.find(self.BoardSettings.DeveloperProducts, tonumber(key)) ~= nil
			end

			for key, class in ThemeProperties do
				if (class.Value == nil and class.Color == nil and class.Color1 == nil) then continue end

				if (class.ValueChanged)  then 
					ThemeProperties[key].Value = self.BoardSettings[key]
				end	

				if (class.ColorChanged)  then 
					if (key == "Colors") then
						ThemeProperties[key].Color1 = self.BoardSettings.Colors[1]
						ThemeProperties[key].Color2 = self.BoardSettings.Colors[2]
						ThemeProperties[key].Color3 = self.BoardSettings.Colors[3]
						continue
					end

					if (key == "SelectColor") then
						ThemeProperties[key].Color = self.BoardSettings.Colors[1]
						SelectedColor = 1
						continue
					end

					ThemeProperties[key].Color = self.BoardSettings[key]
				end	
			end
		end)
	end

	self.PreviousPage = shared["_db/environment"].studiomode and "List" or self.PreviousPage
	self.CurrentPage = shared["_db/environment"].studiomode and "DeveloperProducts" or "List"
	for key, value in self:GetValues() do self._changed:Fire(key, value) end
	for key, value in self.BoardSettings:GetValues() do self.BoardSettings._changed:Fire(key, value) end

	return self :: typeof(self) & classType
end


function Render:_getEnvironment()
	shared["_db/environment"] = shared["_db/environment"] or {
		context = game:GetService("RunService"):IsClient() and "Client" or "Server",
		state = game:GetService("TestService"):GetAttribute("_db/state"),
		runmode = game:GetService("TestService"):GetAttribute("_db/runmode"),
		studiomode = game:GetService("TestService"):GetAttribute("_db/studiomode"),
		debugmode = game:GetService("TestService"):GetAttribute("_db/debugmode"),
	}

	return self
end


function Render:_requestSettings()
	local settings = game:GetService("ReplicatedStorage"):FindFirstChild("donationboard@public").Signals:FindFirstChild("Request"):InvokeServer("settings")
	local timeout = 0; repeat task.wait(0.05) timeout += 0.05 until settings or timeout > 5
	return settings or {} :: typeof(SettingsTemplate)
end


function Render:_requestRefresh()
	local data = game:GetService("ReplicatedStorage"):FindFirstChild("donationboard@public").Signals:FindFirstChild("Request"):InvokeServer("refresh")
	local timeout = 0; repeat task.wait(0.05) timeout += 0.05 until data or timeout > 5
	return data
end


function Render:_saveSettings(data)
	game:GetService("ReplicatedStorage"):FindFirstChild("donationboard@public").Signals:FindFirstChild("Commit"):InvokeServer("settings", data)
	return nil
end


function Render:_resetDonors()
	game:GetService("ReplicatedStorage"):FindFirstChild("donationboard@public").Signals:FindFirstChild("Commit"):InvokeServer("resetdonors")
	return nil
end


function Render:_setDonor(userId, action, amount)
	game:GetService("ReplicatedStorage"):FindFirstChild("donationboard@public").Signals:FindFirstChild("Commit"):InvokeServer("setdonor", {userId, action, amount})
	return nil
end


function Render:_requestJSONDecode(data)
	local requestedData = game:GetService("ReplicatedStorage"):FindFirstChild("donationboard@public").Signals:FindFirstChild("Request"):InvokeServer("jsondecode", data)
	local timeout = 0; repeat task.wait(0.05) timeout += 0.05 until requestedData or timeout > 5
	return requestedData
end


function Render:_requestJSONEncode(data)
	local requestedData = game:GetService("ReplicatedStorage"):FindFirstChild("donationboard@public").Signals:FindFirstChild("Request"):InvokeServer("jsonencode", data)
	local timeout = 0; repeat task.wait(0.05) timeout += 0.05 until requestedData or timeout > 5
	return requestedData
end


return Render