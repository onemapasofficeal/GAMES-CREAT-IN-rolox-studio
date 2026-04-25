local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sg = Instance.new("ScreenGui") sg.Name="MarketGui" sg.ResetOnSpawn=false sg.Enabled=false sg.Parent=playerGui

local panel = Instance.new("Frame") panel.Size=UDim2.new(0,440,0,480) panel.Position=UDim2.new(0.5,-220,0.5,-240) panel.BackgroundColor3=Color3.fromRGB(18,18,18) panel.BorderSizePixel=0 panel.Parent=sg
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,10)

local title = Instance.new("TextLabel") title.Size=UDim2.new(1,0,0,44) title.BackgroundTransparency=1 title.TextColor3=Color3.fromRGB(255,220,50) title.TextScaled=true title.Font=Enum.Font.GothamBold title.Text="🏪 Mercado de Jogadores" title.Parent=panel

-- Listar item
local listFrame = Instance.new("Frame") listFrame.Size=UDim2.new(1,-20,0,50) listFrame.Position=UDim2.new(0,10,0,50) listFrame.BackgroundColor3=Color3.fromRGB(30,30,30) listFrame.BorderSizePixel=0 listFrame.Parent=panel
Instance.new("UICorner",listFrame).CornerRadius=UDim.new(0,6)

local itemBox = Instance.new("TextBox") itemBox.Size=UDim2.new(0.35,0,0,32) itemBox.Position=UDim2.new(0.02,0,0.5,-16) itemBox.BackgroundColor3=Color3.fromRGB(40,40,40) itemBox.TextColor3=Color3.new(1,1,1) itemBox.PlaceholderText="Item" itemBox.TextScaled=true itemBox.Font=Enum.Font.Gotham itemBox.Text="" itemBox.Parent=listFrame
Instance.new("UICorner",itemBox).CornerRadius=UDim.new(0,4)

local qtyBox = Instance.new("TextBox") qtyBox.Size=UDim2.new(0.15,0,0,32) qtyBox.Position=UDim2.new(0.39,0,0.5,-16) qtyBox.BackgroundColor3=Color3.fromRGB(40,40,40) qtyBox.TextColor3=Color3.new(1,1,1) qtyBox.PlaceholderText="Qtd" qtyBox.TextScaled=true qtyBox.Font=Enum.Font.Gotham qtyBox.Text="1" qtyBox.Parent=listFrame
Instance.new("UICorner",qtyBox).CornerRadius=UDim.new(0,4)

local priceBox = Instance.new("TextBox") priceBox.Size=UDim2.new(0.2,0,0,32) priceBox.Position=UDim2.new(0.56,0,0.5,-16) priceBox.BackgroundColor3=Color3.fromRGB(40,40,40) priceBox.TextColor3=Color3.new(1,1,1) priceBox.PlaceholderText="Preço" priceBox.TextScaled=true priceBox.Font=Enum.Font.Gotham priceBox.Text="" priceBox.Parent=listFrame
Instance.new("UICorner",priceBox).CornerRadius=UDim.new(0,4)

local listBtn = Instance.new("TextButton") listBtn.Size=UDim2.new(0.18,0,0,32) listBtn.Position=UDim2.new(0.8,0,0.5,-16) listBtn.BackgroundColor3=Color3.fromRGB(40,100,40) listBtn.TextColor3=Color3.new(1,1,1) listBtn.TextScaled=true listBtn.Font=Enum.Font.GothamBold listBtn.Text="Listar" listBtn.Parent=listFrame
Instance.new("UICorner",listBtn).CornerRadius=UDim.new(0,4)
listBtn.MouseButton1Click:Connect(function()
	remotes:WaitForChild("MarketList"):FireServer(itemBox.Text, tonumber(qtyBox.Text) or 1, tonumber(priceBox.Text) or 0)
end)

-- Listagens
local scroll = Instance.new("ScrollingFrame") scroll.Size=UDim2.new(1,-20,1,-160) scroll.Position=UDim2.new(0,10,0,110) scroll.BackgroundTransparency=1 scroll.ScrollBarThickness=4 scroll.Parent=panel
Instance.new("UIListLayout",scroll).Padding=UDim.new(0,4)

local function refreshListings(listings)
	for _, c in ipairs(scroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
	for _, l in ipairs(listings) do
		local row = Instance.new("Frame") row.Size=UDim2.new(1,0,0,46) row.BackgroundColor3=Color3.fromRGB(30,30,30) row.BorderSizePixel=0 row.Parent=scroll
		Instance.new("UICorner",row).CornerRadius=UDim.new(0,6)

		local info = Instance.new("TextLabel") info.Size=UDim2.new(0.7,0,1,0) info.Position=UDim2.new(0,8,0,0) info.BackgroundTransparency=1 info.TextColor3=Color3.new(1,1,1) info.TextScaled=true info.Font=Enum.Font.Gotham info.Text=l.sellerName..": "..l.itemName.." x"..l.qty.." | R$"..l.price info.TextXAlignment=Enum.TextXAlignment.Left info.Parent=row
		local buyBtn = Instance.new("TextButton") buyBtn.Size=UDim2.new(0,70,0,32) buyBtn.Position=UDim2.new(1,-78,0.5,-16) buyBtn.BackgroundColor3=Color3.fromRGB(40,80,160) buyBtn.TextColor3=Color3.new(1,1,1) buyBtn.TextScaled=true buyBtn.Font=Enum.Font.GothamBold buyBtn.Text="Comprar" buyBtn.Parent=row
		Instance.new("UICorner",buyBtn).CornerRadius=UDim.new(0,4)
		local id = l.id
		buyBtn.MouseButton1Click:Connect(function() remotes:WaitForChild("MarketBuy"):FireServer(id) end)
	end
end

remotes:WaitForChild("MarketUpdate").OnClientEvent:Connect(refreshListings)
local getMarketFn = remotes:WaitForChild("GetMarket")
local listings = getMarketFn:InvokeServer()
if listings then refreshListings(listings) end

local closeBtn = Instance.new("TextButton") closeBtn.Size=UDim2.new(0.8,0,0,38) closeBtn.Position=UDim2.new(0.1,0,1,-46) closeBtn.BackgroundColor3=Color3.fromRGB(180,40,40) closeBtn.TextColor3=Color3.new(1,1,1) closeBtn.TextScaled=true closeBtn.Font=Enum.Font.GothamBold closeBtn.Text="Fechar" closeBtn.Parent=panel
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6)
closeBtn.MouseButton1Click:Connect(function() sg.Enabled=false end)

_G.OpenMarketplace = function() sg.Enabled=true end
