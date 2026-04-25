local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sg = Instance.new("ScreenGui") sg.Name="StockGui" sg.ResetOnSpawn=false sg.Enabled=false sg.Parent=playerGui

local panel = Instance.new("Frame") panel.Size=UDim2.new(0,420,0,480) panel.Position=UDim2.new(0.5,-210,0.5,-240) panel.BackgroundColor3=Color3.fromRGB(10,15,25) panel.BorderSizePixel=0 panel.Parent=sg
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,10)

local title = Instance.new("TextLabel") title.Size=UDim2.new(1,0,0,44) title.BackgroundTransparency=1 title.TextColor3=Color3.fromRGB(50,220,100) title.TextScaled=true title.Font=Enum.Font.GothamBold title.Text="📈 Bolsa de Valores" title.Parent=panel

local scroll = Instance.new("ScrollingFrame") scroll.Size=UDim2.new(1,-20,1,-100) scroll.Position=UDim2.new(0,10,0,50) scroll.BackgroundTransparency=1 scroll.ScrollBarThickness=4 scroll.Parent=panel
Instance.new("UIListLayout",scroll).Padding=UDim.new(0,6)

local stockRows = {}

local function buildStockRows(stocks, owned)
	for _, c in ipairs(scroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
	stockRows = {}
	for _, stock in ipairs(stocks) do
		local row = Instance.new("Frame") row.Size=UDim2.new(1,0,0,70) row.BackgroundColor3=Color3.fromRGB(20,25,40) row.BorderSizePixel=0 row.Parent=scroll
		Instance.new("UICorner",row).CornerRadius=UDim.new(0,6)

		local nameLbl = Instance.new("TextLabel") nameLbl.Size=UDim2.new(0.35,0,0.5,0) nameLbl.Position=UDim2.new(0,8,0,4) nameLbl.BackgroundTransparency=1 nameLbl.TextColor3=Color3.new(1,1,1) nameLbl.TextScaled=true nameLbl.Font=Enum.Font.GothamBold nameLbl.Text=stock.name nameLbl.TextXAlignment=Enum.TextXAlignment.Left nameLbl.Parent=row
		local priceLbl = Instance.new("TextLabel") priceLbl.Size=UDim2.new(0.3,0,0.5,0) priceLbl.Position=UDim2.new(0,8,0.5,0) priceLbl.BackgroundTransparency=1 priceLbl.TextColor3=Color3.fromRGB(255,220,50) priceLbl.TextScaled=true priceLbl.Font=Enum.Font.GothamBold priceLbl.Text="R$"..stock.price priceLbl.TextXAlignment=Enum.TextXAlignment.Left priceLbl.Parent=row
		local changeLbl = Instance.new("TextLabel") changeLbl.Size=UDim2.new(0.2,0,0.5,0) changeLbl.Position=UDim2.new(0.35,0,0,4) changeLbl.BackgroundTransparency=1 local c = stock.change or 0 changeLbl.TextColor3=c>=0 and Color3.fromRGB(50,220,50) or Color3.fromRGB(220,50,50) changeLbl.TextScaled=true changeLbl.Font=Enum.Font.GothamBold changeLbl.Text=(c>=0 and "▲" or "▼")..math.abs(c) changeLbl.Parent=row

		local qtyBox = Instance.new("TextBox") qtyBox.Size=UDim2.new(0,40,0,28) qtyBox.Position=UDim2.new(0.58,0,0.5,-14) qtyBox.BackgroundColor3=Color3.fromRGB(30,35,50) qtyBox.TextColor3=Color3.new(1,1,1) qtyBox.PlaceholderText="Qtd" qtyBox.TextScaled=true qtyBox.Font=Enum.Font.Gotham qtyBox.Text="1" qtyBox.Parent=row
		Instance.new("UICorner",qtyBox).CornerRadius=UDim.new(0,4)

		local buyBtn = Instance.new("TextButton") buyBtn.Size=UDim2.new(0,50,0,28) buyBtn.Position=UDim2.new(0.73,0,0.5,-14) buyBtn.BackgroundColor3=Color3.fromRGB(30,100,30) buyBtn.TextColor3=Color3.new(1,1,1) buyBtn.TextScaled=true buyBtn.Font=Enum.Font.GothamBold buyBtn.Text="Buy" buyBtn.Parent=row
		Instance.new("UICorner",buyBtn).CornerRadius=UDim.new(0,4)

		local sellBtn = Instance.new("TextButton") sellBtn.Size=UDim2.new(0,50,0,28) sellBtn.Position=UDim2.new(0.87,0,0.5,-14) sellBtn.BackgroundColor3=Color3.fromRGB(100,30,30) sellBtn.TextColor3=Color3.new(1,1,1) sellBtn.TextScaled=true sellBtn.Font=Enum.Font.GothamBold sellBtn.Text="Sell" sellBtn.Parent=row
		Instance.new("UICorner",sellBtn).CornerRadius=UDim.new(0,4)

		local id = stock.id
		buyBtn.MouseButton1Click:Connect(function() remotes:WaitForChild("BuyStock"):FireServer(id, tonumber(qtyBox.Text) or 1) end)
		sellBtn.MouseButton1Click:Connect(function() remotes:WaitForChild("SellStock"):FireServer(id, tonumber(qtyBox.Text) or 1) end)

		stockRows[stock.id] = { priceLbl=priceLbl, changeLbl=changeLbl }
	end
end

local stocksFn = remotes:WaitForChild("GetStocks")
local stocks, owned = stocksFn:InvokeServer()
buildStockRows(stocks, owned)

remotes:WaitForChild("StockUpdate").OnClientEvent:Connect(function(updatedStocks)
	for _, s in ipairs(updatedStocks) do
		local row = stockRows[s.id]
		if row then
			row.priceLbl.Text = "R$"..s.price
			local c = s.change or 0
			row.changeLbl.Text = (c>=0 and "▲" or "▼")..math.abs(c)
			row.changeLbl.TextColor3 = c>=0 and Color3.fromRGB(50,220,50) or Color3.fromRGB(220,50,50)
		end
	end
end)

local closeBtn = Instance.new("TextButton") closeBtn.Size=UDim2.new(0.8,0,0,38) closeBtn.Position=UDim2.new(0.1,0,1,-46) closeBtn.BackgroundColor3=Color3.fromRGB(180,40,40) closeBtn.TextColor3=Color3.new(1,1,1) closeBtn.TextScaled=true closeBtn.Font=Enum.Font.GothamBold closeBtn.Text="Fechar" closeBtn.Parent=panel
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6)
closeBtn.MouseButton1Click:Connect(function() sg.Enabled=false end)

_G.OpenStockMarket = function() sg.Enabled=true end
