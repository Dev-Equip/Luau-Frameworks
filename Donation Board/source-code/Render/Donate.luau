--!nocheck
--!nolint
local Donate, Class, Fusion, Rates, Util, Fonts = {}, 
	require("../Libraries/Class"), 
	require("../Dependencies/Fusion"),
	require("../Templates/Rates"),
	require("../Libraries/Util"),
	require("../Templates/Fonts")
	Donate.__index = Donate
	Fusion = Fusion.scoped(Fusion)
	

function Donate.new(parent: Instance)
	local self = Class.new {
		Enabled = true,
		Keyword = "",
		Taxed = false,
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
				Fusion:New "UIFlexItem" {
					FlexMode = Enum.UIFlexMode.Fill,
				},
				
				Fusion:New "UIPadding" {
					PaddingLeft = UDim.new(0, 15),
					PaddingRight = UDim.new(0, 7),
					PaddingTop = UDim.new(0, 1),
				},
			
				Fusion:New "ScrollingFrame" {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.new(0, 0, 0, 0),
					LayoutOrder = 2,
					ScrollingDirection = Enum.ScrollingDirection.Y,
					TopImage = "rbxassetid://90470681337364",
					MidImage = "rbxassetid://128864464627223",
					BottomImage = "rbxassetid://72306694687452",

					[Fusion.Tag "A"] = "donationboard@scrollbar",
					[Fusion.Children] = {					
						Fusion:New "UIPadding" {
							PaddingBottom = UDim.new(0, 15),
							PaddingRight = UDim.new(0, 17),
							PaddingTop = UDim.new(0, 12),
						},

						Fusion:New "UIListLayout" {
							Padding = UDim.new(0, 8),
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
				return Fusion:New "TextButton" {
					AutoButtonColor = true,
					BackgroundColor3 = Color3.fromHex("#000000"),
					BackgroundTransparency = 0.625,
					Size = UDim2.new(1, 0, 0, 50),
					FontFace = Font.new(Fonts[shared["donationboard@settings"].Font], Enum.FontWeight.Regular, Enum.FontStyle.Normal),
					RichText = true,
					TextSize = 20,
					Text = "N/A",
					TextColor3 = shared["donationboard@settings"].TextColor,
					TextXAlignment = Enum.TextXAlignment.Left,

					[Fusion.Tag "A"] = "donationboard@textcolor",
					[Fusion.Tag "B"] = "donationboard@backdropcolor",
					[Fusion.Children] = {
						Fusion:New "UICorner" {
							CornerRadius = UDim.new(0, 4),
						},
						
						Fusion:New "UIPadding" {
							PaddingLeft = UDim.new(0, 15),
							PaddingRight = UDim.new(0, 15),
						},
					}
				}
			end,
		},

		Actions = {"Search", "Tax", "Conversion", "Fullscreen", "SortDirection"},

		Clear = function(self)
			for _, button in self.Body.ScrollingFrame:GetChildren() do
				if button:IsA("TextButton") then button:Destroy() end
			end
			return self
		end,

		Filter = function(self, keyword: string) 
			if (keyword) then self.Keyword = keyword return end
			for _, textbutton in self.Body.ScrollingFrame:GetChildren() do
				if not (textbutton:IsA("TextButton")) then continue end
				local hasKeyword = false
				
				if (textbutton:IsA("TextButton") and textbutton.Text:lower():gsub(",", ""):find(self.Keyword:lower():gsub(",", ""))) then
					hasKeyword = true
				end

				if (textbutton:IsA("TextButton") and tonumber(self.Keyword) and textbutton.Text:lower():find(Util.Commaify(tonumber(self.Keyword)))) then
					hasKeyword = true
				end

				textbutton.Visible = #self.Keyword < 1 or hasKeyword
			end
			return self
		end,

		Sort = function(self) 
			local Buttons = {}
			for _, button in self.Body.ScrollingFrame:GetChildren() do
				if button:IsA("TextButton") then
					table.insert(Buttons, button)
				end
			end

			table.sort(Buttons, function(a, b)
				local aRobux = a:GetAttribute("Robux")
				local bRobux = b:GetAttribute("Robux")

				if self.SortDirection:lower() == "ascending" then
					return aRobux < bRobux
				else
					return aRobux > bRobux
				end
			end)

			for index, button in ipairs(Buttons) do
				button.LayoutOrder = index
			end

		
			return self
		end,

		Tax = function(self) 
			local function f(value)
				return Util.Commaify(math.floor(value*100)/100)
			end

			for _, button in self.Body.ScrollingFrame:GetChildren() do
				if (not button:IsA("TextButton")) then continue end
				pcall(function()
					button.Text = `{button:GetAttribute("RichText"):format(f(button:GetAttribute("Robux") * (self.Taxed and 0.7 or 1)))}`..(self.Conversion and `<font transparency="0.5">→</font> {button:GetAttribute("RichText2"):format(`{self.CurrencyRate[self.Currency][1]}{f(self.CurrencyRate[self.Currency][2] * button:GetAttribute("Robux") * (self.Taxed and 0.7 or 1))}`)}` or "")
				end)
			end
		
			return self
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

			if (property == "Conversion") then
				self:Tax()
				return
			end
		end)
	end

	return self
end


return Donate